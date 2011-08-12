unit MixerUnit;

interface

uses 
  Types,
  SysUtils,
  Classes, 
  DateUtils,
  Generics.Collections, 
  IoUtils,
  ImagingUtility,
  CCR.Exif,
  Helpers;

const
  FileTypeSeparator = ',';
  NameFormat = ' %.4d-%.2d-%.2d %.2d-%.2d-%.2d.jpg';
  
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

  TMessageType = (mtInfo, mtImportant, mtWarning, mtError);

  IUIBridge = interface
    procedure ShowMessage(MsgType: TMessageType; const MsgFmt: string; const Args: array of const);
    procedure Ping;
    procedure OnBegin;
    procedure OnEnd(UserAbort: Boolean);
    procedure OnProgress(Current, Total: Integer);
  end;
  
  TSourceList = TObjectList<TSource>;

  TMixer = class
  private
    FSources: TSourceList;
    FSettings: TSettings;
    FRunning: Boolean; 
    FAborted: Boolean;   
    FUI: IUIBridge;    
    FDayDict: TDictionary<Integer, Integer>;
    function GetSource(Index: Integer): TSource;
    function PrepareReferenceTimes: Boolean;
    function ReadPhotoDate(const FileName: string; out FromExif: Boolean): TDateTime;
    procedure MoveAndRenameByTime(Src: TSource; const FileName: string);
    function GetSourceCount: Integer;
    property UI: IUIBridge read FUI;
    property DayDict: TDictionary<Integer, Integer> read FDayDict;
  public
    constructor Create(UI: IUIBridge);
    destructor Destroy; override;
  
    function AddSource: TSource;     
    procedure DeleteSource(Index: Integer); 
    procedure Reset;

    function Start: Boolean;
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

function TMixer.ReadPhotoDate(const FileName: string; out FromExif: Boolean): TDateTime;
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

procedure TMixer.Reset;
begin
  Settings.OutputDir := '';
  FSources.Clear;
end;

function TMixer.PrepareReferenceTimes: Boolean;
var
  Src, RefSrc: TSource;
  RefDate, SrcDate: TDateTime;
  RefFile: string;
  FromExif: Boolean;
  RefDateSec, SrcDateSec: Integer;
begin
  Assert((Settings.RefSource >= 0) and (Settings.RefSource < FSources.Count));
  RefSrc := FSources[Settings.RefSource];
  RefFile := RefSrc.RefPhoto;
  
  RefDate := ReadPhotoDate(RefFile, FromExif);
  UI.ShowMessage(mtInfo, 'Main reference time: %s (source: %s)', [DateTimeToStr(RefDate), 
    Iff(FromExif, 'EXIF', 'file system')]);

  for Src in FSources do
  begin
    if Src = RefSrc then
    begin
      Src.TimeShift := 0;
    end
    else 
    begin
      case Src.SyncMode of
        smRefPhoto: 
          begin
            SrcDate := ReadPhotoDate(Src.RefPhoto, FromExif);
            Src.TimeShift := SecondsBetween(RefDate, SrcDate);
            if SrcDate > RefDate then
              Src.TimeShift := -Src.TimeShift;
          end;
        smExplicitShift: 
          begin
            Src.TimeShift := Src.ExplicitShift;
          end;
      else
        Assert(False);
      end;            
    end;
    UI.ShowMessage(mtInfo, 'Source "%s" has time shift of %s seconds', [Src.Name, 
      IntToStrFmt(Src.TimeShift)]);
  end;

  Result := True;
end;

function TMixer.GetSource(Index: Integer): TSource;
begin
  Result := FSources[Index];
end;

function TMixer.GetSourceCount: Integer;
begin
  Result := FSources.Count;
end;

procedure TMixer.MoveAndRenameByTime(Src: TSource; const FileName: string);
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
          UI.ShowMessage(mtWarning, 'Failed to update EXIF metadata of file "%s"', [FileName]);  
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
      
  DestFile := Settings.OutputDir + Settings.NamePattern + Format(NameFormat, 
    [YearOf(DateTime), MonthOf(DateTime), DayOf(DateTime), HourOf(DateTime), MinuteOf(DateTime), DayFot]);
      
  if TFile.Exists(DestFile) and not DeleteFile(DestFile) then
    UI.ShowMessage(mtWarning, 'Failed to delete old existing file "%s". Opened in another process?', [FileName]);  
            
  try
    TFile.Move(FileName, DestFile);
    TFile.SetLastWriteTime(DestFile, DateTime);                   
  except
    UI.ShowMessage(mtWarning, 'Failed to rename file "%s" to "%s". Opened in another process?', [FileName, DestFile]);  
  end;
end;

function TMixer.Start: Boolean;
var
  I, SrcCounter, TotalFiles, CurrFile: Integer;
  Src: TSource;
  FileName, TmpFile: string;  
  FileExts: TStringDynArray;
  FilterPredicate: TDirectory.TFilterPredicate;  
  FileTime: TDateTime;

  procedure PrepareFileDefs;
  begin
    FileExts := StrTokens(Settings.FileTypes, FileTypeSeparator); 
    FilterPredicate := 
      function(const Path: string; const SearchRec: TSearchRec): Boolean
      var
        Ext: string;
        Len, Offset: Integer;
      begin
        Len := Length(Path);
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
  Assert(not Running);

  if Settings.SyncSources and not PrepareReferenceTimes then
    Exit(False);  

  FDayDict := TDictionary<Integer, Integer>.Create;  
  PrepareFileDefs;     
                 
  FRunning := True;    
  TotalFiles := 0;
  CurrFile := 0;
  
  FUI.OnBegin; 
  
  try 
    FUI.ShowMessage(mtInfo, 'Building file lists...', []);
    for Src in FSources do
    begin
      Src.FileList := TDirectory.GetFiles(Src.PhotoDir, '*.*', 
        TSearchOption.soAllDirectories, FilterPredicate);     
      Src.FileCount := Length(Src.FileList);  
      Inc(TotalFiles, Src.FileCount);  
      UI.Ping;  
    end;
  
    for Src in FSources do
    begin      
      FUI.ShowMessage(mtImportant, 'Processing source "%s"...', [Src.Name]);      
      
      for FileName in Src.FileList do
      begin
        TmpFile := Settings.OutputDir + ExtractFileName(FileName);        
        
        if CopyFile(FileName, TmpFile, True) then 
          MoveAndRenameByTime(Src, TmpFile)
        else
          UI.ShowMessage(mtWarning, 'Failed to copy file to output folder "%s"', [FileName]);  
          
        UI.Ping;
        Inc(CurrFile);
        UI.OnProgress(CurrFile, TotalFiles);

        if FAborted then
          Break;
      end;   

      Src.FileList := nil;
      
      if FAborted then
        Break
      else
        UI.ShowMessage(mtInfo, '%d files processed', [Src.FileCount]);       
    end;  
  finally    
    FDayDict.Free;    
    UI.OnEnd(FAborted);
    FRunning := False; 
    FAborted := False;    
  end;  
end;

procedure TMixer.Abort;
begin
  FAborted := True;
  FRunning := False;
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


end.
