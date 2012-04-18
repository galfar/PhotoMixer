unit Tools;

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
  sdJpegImage,
  sdJpegLossless,
  Helpers;

type
  TSettings = class
  public
    type
      TInputOutputDirs = record
        InDir: string;
        OutDir: string;
        ModifyExisting: Boolean;
      end;
      TSetDateTime = record
        Time: TTime;
        Date: TDate;
        TimeInc: TTime;
        IncrementalTimes: Boolean;
        SkipWithMeta: Boolean;
      end;
  public
    InputOutputDirs: TInputOutputDirs;
    SetDateTime: TSetDateTime;
  end;

  TTools = class
  private
    FUI: IUIBridge;
    FSettings: TSettings;
    function PrepareOutFile(const InFilePath: string): string;
  public
    constructor Create(UI: IUIBridge);
    destructor Destroy; override;

    procedure ClearDirectory(const Dir: string);
    procedure SetPhotoDateTime;
    procedure SetFileTimeFromMeta;
    procedure AutoOrientByMeta;

    property Settings: TSettings read FSettings;
  end;

implementation

{ TTools }

constructor TTools.Create(UI: IUIBridge);
begin
  FSettings := TSettings.Create;
  FUI := UI;
end;

destructor TTools.Destroy;
begin
  FSettings.Free;
  inherited;
end;

function TTools.PrepareOutFile(const InFilePath: string): string;
var
  FileName: string;
begin
  if Settings.InputOutputDirs.ModifyExisting then
    Result := InFilePath
  else
  begin
    FileName := ExtractFileName(InFilePath);
    Result := Settings.InputOutputDirs.OutDir + PathDelim + FileName;
    if not SameText(InFilePath, Result) then
      CopyFile(InFilePath, Result, True);
  end;
end;

procedure TTools.SetFileTimeFromMeta;
var
  FileList: TStringDynArray;
  InFile, OutFile: string;
  Exif: TExifDataPatcher;
  DateTime: TDateTime;
  Counter: Integer;
begin
  FileList := TDirectory.GetFiles(Settings.InputOutputDirs.InDir);
  Counter := 0;
  FUI.ShowMessage(TMessageType.mtImportant, 'Starting Set File Time From Metadata tool...', []);

  for InFile in FileList do
  begin
    if not IsJpeg(InFile) then
      Continue;

    OutFile := PrepareOutFile(InFile);
    Exif := TExifDataPatcher.Create;

    try
      Exif.OpenFile(OutFile);

      if not Exif.Empty and (Exif.DateTimeOriginal <> 0) then
      begin
        DateTime := Exif.DateTimeOriginal;
        Exif.CloseFile(False);
        TFile.SetCreationTime(OutFile, DateTime);
        TFile.SetLastWriteTime(OutFile, DateTime);
        Inc(Counter);
      end;

    finally
      Exif.Free;
    end;
  end;

  FUI.ShowMessage(TMessageType.mtInfo, 'Processed %d files in "%s" folder',
    [Counter, Settings.InputOutputDirs.InDir]);
end;

procedure TTools.SetPhotoDateTime;
var
  FileList: TStringDynArray;
  InFile, OutFile: string;
  Exif: TExifDataPatcher;
  DateTime: TDateTime;
  Counter: Integer;
begin
  DateTime := Settings.SetDateTime.Date + Settings.SetDateTime.Time;
  FileList := TDirectory.GetFiles(Settings.InputOutputDirs.InDir);
  Counter := 0;
  FUI.ShowMessage(TMessageType.mtImportant, 'Starting Set Photo Date & Time tool...', []);

  for InFile in FileList do
  begin
    if not IsJpeg(InFile) then
      Continue;

    OutFile := PrepareOutFile(InFile);
    Exif := TExifDataPatcher.Create;

    try
      Exif.OpenFile(OutFile);

      if not Settings.SetDateTime.SkipWithMeta or
        (Settings.SetDateTime.SkipWithMeta and (Exif.Empty or (Exif.DateTime = 0))) then
      begin
        Exif.SetAllDateTimeValues(DateTime);
        Exif.CloseFile(True); // Must be closed and updated before setting file system time
        TFile.SetCreationTime(OutFile, DateTime);
        TFile.SetLastWriteTime(OutFile, DateTime);
        Inc(Counter);
      end;

      if Settings.SetDateTime.IncrementalTimes then
        DateTime := DateTime + Settings.SetDateTime.TimeInc;
    finally
      Exif.Free;
    end;
  end;

  FUI.ShowMessage(TMessageType.mtInfo, 'Processed %d files in "%s" folder',
    [Counter, Settings.InputOutputDirs.InDir]);
end;

procedure TTools.AutoOrientByMeta;
var
  FileList: TStringDynArray;
  InFile, OutFile: string;
  Exif: TExifData;
  Patcher: TExifDataPatcher;
  Total, Rotated: Integer;
  JpegImg: TsdJpegImage;

  function OrientationToStr(Value: TExifOrientation): string;
  begin
    case Value of
      toTopLeft: Result := 'Normal';
      toTopRight: Result := 'Mirror horizontal';
      toBottomRight: Result := 'Rotate 180°';
      toBottomLeft: Result := 'Mirror vertical';
      toLeftTop: Result := 'Mirrow horizontal and rotate 270°';
      toRightTop: Result := 'Rotate 90°';
      toRightBottom: Result := 'Mirror horizontal and rotate 90°';
      toLeftBottom: Result := 'Rotate 270°';
    else
      Result := 'Unknown';
    end;
  end;

  procedure LosslessRotate(Orientation: TExifOrientation; Lossless: TsdLosslessOperation);
  begin
    case Orientation of
      toTopRight:    Lossless.FlipHorizontal;
      toBottomRight: Lossless.Rotate180;
      toBottomLeft:  Lossless.FlipVertical;
      toLeftTop:     Lossless.Transpose;
      toRightTop:    Lossless.Rotate90;
      toRightBottom:
        begin
          Lossless.FlipHorizontal;
          Lossless.Rotate90;
        end;
      toLeftBottom:  Lossless.Rotate270;
    else
      Assert(False);
    end;
  end;

begin
  FileList := TDirectory.GetFiles(Settings.InputOutputDirs.InDir);
  Total := 0;
  Rotated := 0;
  FUI.ShowMessage(TMessageType.mtImportant, 'Starting Auto Orient by Metadata tool...', []);

  for InFile in FileList do
  begin
    if not IsJpeg(InFile) then
      Continue;

    OutFile := PrepareOutFile(InFile);
    Exif := TExifData.Create;

    try
      Exif.LoadFromJPEG(InFile);

      if not Exif.Empty then
      begin
        FUI.ShowMessage(TMessageType.mtInfo, 'Orientation: %s (%s)',
          [OrientationToStr(Exif.Orientation), ExtractFileName(InFile)]);

        if not (Exif.Orientation in [toUndefined, toTopLeft]) then
        begin
          JpegImg := TsdJpegImage.Create(nil);
          try
            JpegImg.LoadFromFile(OutFile);
            LosslessRotate(Exif.Orientation, JpegImg.Lossless);
            JpegImg.SaveToFile(OutFile);
          finally
            JpegImg.Free;
          end;

          Patcher := TExifDataPatcher.Create;
          try
            Patcher.OpenFile(OutFile);
            Patcher.Orientation := toTopLeft;
            Patcher.UpdateFile;
          finally
            Patcher.Free;
          end;

          Inc(Rotated);
        end;
      end;

      Inc(Total);
    finally
      Exif.Free;
    end;
  end;

  FUI.ShowMessage(TMessageType.mtInfo, 'Processed %d of %d files in "%s" folder',
    [Rotated, Total, Settings.InputOutputDirs.InDir]);
end;

procedure TTools.ClearDirectory(const Dir: string);
begin

end;


end.
