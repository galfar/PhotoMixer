unit FormToolsSetDateTime;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls, System.DateUtils,
  rkSmartPath, Tools, Vcl.ExtCtrls, Helpers;

type
  TToolsSetDateTimeForm = class(TForm)
    DatePickerNew: TDateTimePicker;
    TimePickerNew: TDateTimePicker;
    TimePickerInc: TDateTimePicker;
    CheckSkipWithMeta: TCheckBox;
    Label4: TLabel;
    PathPhotos: TrkSmartPath;
    BtnBrowseOutputDir: TButton;
    Button1: TButton;
    Label1: TLabel;
    CheckIncTimes: TCheckBox;
    Button2: TButton;
    Bevel1: TBevel;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BtnBrowseOutputDirClick(Sender: TObject);
  private

  public
    procedure ApplySettings(Settings: Tools.TSettings);
    procedure UpdateSettings(Settings: Tools.TSettings);
  end;

var
  ToolsSetDateTimeForm: TToolsSetDateTimeForm;

implementation

{$R *.dfm}

{ TToolsSetDateTimeForm }

procedure TToolsSetDateTimeForm.ApplySettings(Settings: Tools.TSettings);
begin

end;

procedure TToolsSetDateTimeForm.UpdateSettings(Settings: Tools.TSettings);
begin
  with Settings do
  begin
    SetDateTime.TargetDir := PathPhotos.Path;
    SetDateTime.Time := TimeOf(TimePickerNew.Time);
    SetDateTime.Date := DateOf(DatePickerNew.Date);
    SetDateTime.TimeInc := TimeOf(TimePickerInc.Time);
    SetDateTime.IncrementalTimes := CheckIncTimes.Checked;
    SetDateTime.SkipWithMeta := CheckSkipWithMeta.Checked;
  end;
end;

procedure TToolsSetDateTimeForm.BtnBrowseOutputDirClick(Sender: TObject);
begin
  BrowseForDir('Select photo folder', PathPhotos, True);
end;

procedure TToolsSetDateTimeForm.Button1Click(Sender: TObject);
begin
  ModalResult := mrOk;
end;

procedure TToolsSetDateTimeForm.FormCreate(Sender: TObject);
begin
  DatePickerNew.Date := Now;
  TimePickerNew.Time := Now;
end;

end.
