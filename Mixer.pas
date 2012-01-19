unit Mixer;

interface

uses 
  Types,
  SysUtils,
  Classes,
  DateUtils,
  Generics.Defaults,
  Generics.Collections,
  IoUtils,
  ActiveX,
  ImagingUtility,
  CCR.Exif,
  Helpers;

const
  FileTypeSeparator = ',';
  NameFormat = '%.4d-%.2d-%.2d %.2d-%.2d-%.2d.jpg';
  
type
  TSyncMode = (
    smRefPhoto,
    smExplicitShift
  );

  TSource = class
  public
    Name: string;
    PhotoDir: string;
    SyncMode: TSyncMode;
    RefPhoto: string;
    ExplicitShift: Int64;
  private     
    TimeShift: Int64; 
    FileList: TStringDynArray;
    FileCount: Integer;
  end;

  TSettings = class
  public 
    OutputDir: string;
    FileTypes: string;
    NamePattern: string;
    SyncSources: Boolean;
    RefSource: Integer;  
  end;

  IWorkerBridge = interface
    procedure Started;
    procedure Finished;
    procedure ShowMessage(MsgType: TMessageType; const MsgFmt: string; const Args: array of const);
    procedure Progress(Current, Total: Integer);
  end;
  
  TSourceList = TObjectList<TSource>;

  TMixer = class(TSingletonImplementation, IWorkerBridge)
  private 
    type
      TBaseWorker = class(TThread)      
      protected
        FBridge: IWorkerBridge;                      
      public 
        constructor Create(ABridge: IWorkerBridge);
        property Bridge: IWorkerBridge read FBridge;
      end;
    
      TMixWorker = class(TBaseWorker)
      private 
        FDayDict: TDictionaryIntInt;
        FSettings: TSettings; 
        FSources: TSourceList;
        procedure PrepareReferenceTimes;
        function ReadPhotoDate(const FileName: string; out FromExif: Boolean): TDateTime;
        procedure MoveAndRenameByTime(Src: TSource; const FileName: string);

        property DayDict: TDictionaryIntInt read FDayDict;                    
        property Settings: TSettings read FSettings;                    
        property Sources: TSourceList read FSources;                    
      protected
        procedure Execute; override;
      public
        constructor Create(ABridge: IWorkerBridge; ASettings: TSettings; ASources: TSourceList);
      end;
      
  private         
    FSources: TSourceList;
    FSettings: TSettings;
    FRunning: Boolean; 
    FAborted: Boolean;   
    FUI: IUIBridge; 
    FMixWorker: TMixWorker;       
    function GetSource(Index: Integer): TSource; 
    function GetSourceCount: Integer;    
    property Sources: TSourceList read FSources;  

    // IWorkerBridge
    procedure Started;
    procedure Finished;  
    procedure ShowMessage(MsgType: TMessageType; const MsgFmt: string; const Args: array of const);
    procedure Progress(Current, Total: Integer);
  public
    constructor Create(UI: IUIBridge);
    destructor Destroy; override;
  
    function AddSource: TSource;     
    procedure DeleteSource(Index: Integer); 
    procedure Reset;

    procedure Start;
    procedure Abort;
    
    property Settings: TSettings read FSettings;
    property Source[Index: Integer]: TSource read GetSource;
    property SourceCount: Integer read GetSourceCount;
    property Running: Boolean read FRunning;
  end;
  
implementation

{ TMixer }

constructor TMixer.Create(UI: IUIBridge);
begin
  FUI := UI;
  FSources := TSourceList.Create;
  FSettings := TSettings.Create;
end;

destructor TMixer.Destroy;
begin
  FSources.Free; 
  FSettings.Free;
  inherited;
end;

procedure TMixer.Reset;
begin
  Settings.OutputDir := '';
  FSources.Clear;
end;

function TMixer.GetSource(Index: Integer): TSource;
begin
  Result := FSources[Index];
end;

function TMixer.GetSourceCount: Integer;
begin
  Result := FSources.Count;
end;

procedure TMixer.Start;
begin  
  Assert(not Running);      
  Assert(FMixWorker = nil);
  FMixWorker := TMixWorker.Create(Self, Settings, Sources);
end;

procedure TMixer.Started;
begin
  FRunning := True;
  FAborted := False; 
  FUI.OnBegin; 
end;

procedure TMixer.Finished;
begin
  FRunning := False;
  FUI.OnEnd(FAborted);
  FMixWorker := nil;
end;

procedure TMixer.Abort;
begin
  Assert(FMixWorker <> nil);
  FAborted := True;
  FRunning := False;
  FMixWorker.Terminate;
end;

procedure TMixer.Progress(Current, Total: Integer);
begin
  FUI.OnProgress(Current, Total);
end;

procedure TMixer.ShowMessage(MsgType: TMessageType; const MsgFmt: string; const Args: array of const);
begin
  FUI.ShowMessage(MsgType, MsgFmt, Args);
end;

function TMixer.AddSource: TSource;
var 
  Src: TSource;
begin
  Src := TSource.Create;  
  FSources.Add(Src);                                   
  Result := Src;
end;

procedure TMixer.DeleteSource(Index: Integer);
begin
  FSources.Delete(Index);
end;

{ TMixer.TBaseWorker }

constructor TMixer.TBaseWorker.Create(ABridge: IWorkerBridge);
begin
  inherited Create(False);
  FBridge := ABridge;
  FreeOnTerminate := True;
end;

{ TMixer.TMixWorker }

constructor TMixer.TMixWorker.Create(ABridge: IWorkerBridge; ASettings: TSettings; ASources: TSourceList);
begin
  inherited Create(ABridge);
  FSettings := ASettings;
  FSources := ASources;
end;

function TMixer.TMixWorker.ReadPhotoDate(const FileName: string; out FromExif: Boolean): TDateTime;
var
  Exif: TExifData;
begin
  FromExif := False;
  Result := 0;
  
  if IsJpeg(FileName) then  
  begin      
    Exif := TExifData.Create;
    try
      try
        Exif.LoadFromJPEG(FileName);
        Result := Exif.DateTimeOriginal;
        FromExif := True;
      except
        Result := 0;
      end;  
    finally
      Exif.Free;
    end;
  end;

  if Result = 0 then
    Result := TFile.GetLastWriteTime(FileName);
end;

procedure TMixer.TMixWorker.PrepareReferenceTimes;
var
  Src, RefSrc: TSource;
  RefDate, SrcDate: TDateTime;
  RefFile: string;
  FromExif: Boolean;

  function IsRefPhotoNeeded: Boolean;
  var
    Src: TSource;
  begin
    Result := False;
    for Src in Sources do
    begin
      if Src.SyncMode = smRefPhoto then
        Exit(True);
    end;
  end;

begin
  RefSrc := nil;
  RefDate := 0;

  if IsRefPhotoNeeded then
  begin
    Assert((Settings.RefSource >= 0) and (Settings.RefSource < Sources.Count));
    RefSrc := Sources[Settings.RefSource];
    RefFile := RefSrc.RefPhoto;

    RefDate := ReadPhotoDate(RefFile, FromExif);
    Bridge.ShowMessage(mtInfo, 'Main reference time: %s (source: %s)', [DateTimeToStr(RefDate),
      Iff(FromExif, 'EXIF', 'file system')]);
  end;

  for Src in Sources do
  begin
    case Src.SyncMode of
      smRefPhoto:
        begin
          Assert(RefSrc <> nil);
          Assert(RefDate <> 0);

          if Src = RefSrc then
          begin
            Src.TimeShift := 0;
            Continue;
          end;
          SrcDate := ReadPhotoDate(Src.RefPhoto, FromExif);
          Src.TimeShift := SecondsBetween(RefDate, SrcDate);
          if SrcDate > RefDate then
            Src.TimeShift := -Src.TimeShift;
        end;
      smExplicitShift:
        begin
          Src.TimeShift := Src.ExplicitShift;
        end;
    end;
    Bridge.ShowMessage(mtInfo, 'Source "%s" has time shift of %s seconds', [Src.Name,
      IntToStrFmt(Src.TimeShift)]);
  end;
end;

procedure TMixer.TMixWorker.MoveAndRenameByTime(Src: TSource; const FileName: string);
var
  DateTime: TDateTime;
  DestFile: string;
  DayId, DayFot: Integer;
  FromExif: Boolean;
  Exif: TExifDataPatcher;
begin  
  DateTime := ReadPhotoDate(FileName, FromExif);
    
  if Settings.SyncSources and (Src.TimeShift <> 0) then
  begin
    DateTime := IncSecond(DateTime, Src.TimeShift);

    if FromExif then  
    begin      
      Exif := TExifDataPatcher.Create;
      try
        try
          Exif.OpenFile(FileName);
          Exif.SetAllDateTimeValues(DateTime);
          Exif.UpdateFile;
        except
          Bridge.ShowMessage(mtWarning, 'Failed to update EXIF metadata of file "%s"', [FileName]);  
        end;  
      finally
        Exif.Free;
      end;
    end;         
  end;

  // Counter of photos per day to get unique id even for photos taken inside one minute or second
  DayId := MonthOf(DateTime) * 100000 + DayOf(DateTime) * 1440 + HourOf(DateTime) * 60 + MinuteOf(DateTime);
  if DayDict.ContainsKey(DayId) then
  begin
    DayFot := DayDict[DayId];
    Inc(DayFot);
    DayDict[DayId] := DayFot;
  end
  else
  begin
    DayFot := 0;
    DayDict.Add(DayId, DayFot);
  end;           
      
  DestFile := Settings.OutputDir + Settings.NamePattern + ' ' + Format(NameFormat,
    [YearOf(DateTime), MonthOf(DateTime), DayOf(DateTime), HourOf(DateTime), MinuteOf(DateTime), DayFot]);
      
  if TFile.Exists(DestFile) and not DeleteFile(DestFile) then
    Bridge.ShowMessage(mtWarning, 'Failed to delete old existing file "%s". Opened in another process?', [FileName]);  
            
  try
    TFile.Move(FileName, DestFile);
    TFile.SetCreationTime(DestFile, DateTime);
    TFile.SetLastWriteTime(DestFile, DateTime);
  except
    Bridge.ShowMessage(mtWarning, 'Failed to rename file "%s" to "%s". Opened in another process?', [FileName, DestFile]);  
  end;
end;

procedure TMixer.TMixWorker.Execute;
var
  TotalFiles, CurrFile: Integer;
  Src: TSource;
  FileName, TmpFile: string;  
  FileExts: TStringDynArray;
  FilterPredicate: TDirectory.TFilterPredicate;  
  
  procedure PrepareFileDefs;
  var
    Types: string;
  begin
    Types := StringReplace(Settings.FileTypes, ';', FileTypeSeparator, [rfReplaceAll]); 
    FileExts := StrTokens(Types, FileTypeSeparator); 
    FilterPredicate := 
      function(const Path: string; const SearchRec: TSearchRec): Boolean
      var
        Ext: string;
        Offset: Integer;
      begin
        for Ext in FileExts do
        begin
          Offset := Length(SearchRec.Name) - Length(Ext) + 1;
          if PosEx(LowerCase(Ext), LowerCase(SearchRec.Name), Offset) = Offset then
            Exit(True);
        end;
        Result := False;
      end;    
  end;  

begin
  TThread.NameThreadForDebugging('MixWorker', Self.ThreadID);
  CoInitialize(nil); // Needed for some CRR,Exif XMP stuff :(   
    
  if Settings.SyncSources then 
    PrepareReferenceTimes;

  FDayDict := TDictionaryIntInt.Create;  
  PrepareFileDefs;     
    
  TotalFiles := 0;
  CurrFile := 0;
  Bridge.Started;
  
  try 
    Bridge.ShowMessage(mtInfo, 'Building file lists...', []);
    for Src in FSources do
    begin
      Src.FileList := TDirectory.GetFiles(Src.PhotoDir, '*.*', 
        TSearchOption.soAllDirectories, FilterPredicate);     
      Src.FileCount := Length(Src.FileList);  
      Inc(TotalFiles, Src.FileCount);  
    end;
  
    for Src in Sources do
    begin      
      Bridge.ShowMessage(mtImportant, 'Processing source "%s"...', [Src.Name]);      
      
      for FileName in Src.FileList do
      begin
        TmpFile := Settings.OutputDir + ExtractFileName(FileName);        
        
        if CopyFile(FileName, TmpFile, True) then 
          MoveAndRenameByTime(Src, TmpFile)
        else
          Bridge.ShowMessage(mtWarning, 'Failed to copy file to output folder "%s"', [FileName]);  
          
        Inc(CurrFile);
        Bridge.Progress(CurrFile, TotalFiles);

        if Terminated then
          Break;
      end;   

      Src.FileList := nil;
      
      if Terminated then
        Break
      else
        Bridge.ShowMessage(mtInfo, '%d files processed', [Src.FileCount]);       
    end;    
  finally
    FDayDict.Free;  
    Bridge.Finished;        
    CoUninitialize(); 
  end;  
end;



end.
