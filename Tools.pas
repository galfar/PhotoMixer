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
  Helpers;

type
  TSettings = class
  private
    type
      TSetDateTime = record
        TargetDir: string;
        Time: TTime;
        Date: TDate;
        TimeInc: TTime;
        IncrementalTimes: Boolean;
        SkipWithMeta: Boolean;
      end;
  public
    SetDateTime: TSetDateTime;
  end;

  TTools = class
  private
    FUI: IUIBridge;
    FSettings: TSettings;
  public
    constructor Create(UI: IUIBridge);
    destructor Destroy; override;

    procedure ClearDirectory(const Dir: string);
    procedure SetPhotoDateTime;
    procedure SetFileTimeFromMeta(const Dir: string);

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

procedure TTools.SetFileTimeFromMeta(const Dir: string);
var
  FileList: TStringDynArray;
  S: string;
  Exif: TExifDataPatcher;
  DateTime: TDateTime;
  Counter: Integer;
begin
  FileList := TDirectory.GetFiles(Dir);
  Counter := 0;

  for S in FileList do
  begin
    if not IsJpeg(S) then
      Continue;

    Exif := TExifDataPatcher.Create;
    try
      Exif.OpenFile(S);

      if not Exif.Empty and (Exif.DateTime <> 0) then
      begin
        DateTime := Exif.DateTime;
        Exif.CloseFile(False);
        TFile.SetCreationTime(S, DateTime);
        TFile.SetLastWriteTime(S, DateTime);
        Inc(Counter);
      end;

    finally
      Exif.Free;
    end;
  end;

  FUI.ShowMessage(TMessageType.mtImportant, 'Processed %d files in %s folder', [Counter, Dir]);
end;

procedure TTools.SetPhotoDateTime;
var
  FileList: TStringDynArray;
  S: string;
  Exif: TExifDataPatcher;
  DateTime: TDateTime;
  Counter: Integer;
begin
  DateTime := Settings.SetDateTime.Date + Settings.SetDateTime.Time;
  FileList := TDirectory.GetFiles(Settings.SetDateTime.TargetDir);

  for S in FileList do
  begin
    if not IsJpeg(S) then
      Continue;

    Exif := TExifDataPatcher.Create;
    try
      Exif.OpenFile(S);

      if not Settings.SetDateTime.SkipWithMeta or
        (Settings.SetDateTime.SkipWithMeta and (Exif.Empty or (Exif.DateTime = 0))) then
      begin
        Exif.SetAllDateTimeValues(DateTime);
        Exif.CloseFile(True); // Must be closed and updated before setting file system time
        TFile.SetCreationTime(S, DateTime);
        TFile.SetLastWriteTime(S, DateTime);
        Inc(Counter);
      end;

      if Settings.SetDateTime.IncrementalTimes then
        DateTime := DateTime + Settings.SetDateTime.TimeInc;
    finally
      Exif.Free;
    end;
  end;

  FUI.ShowMessage(TMessageType.mtImportant, 'Processed %d files in %s folder', [Counter, Settings.SetDateTime.TargetDir]);
end;

procedure TTools.ClearDirectory(const Dir: string);
begin

end;


end.
