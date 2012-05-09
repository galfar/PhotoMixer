unit FrameSetDateTime;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls,
  Helpers, Tools, System.DateUtils, FrameBase;

type
  TSetDateTimeFrame = class(TBaseFrame)
    Label1: TLabel;
    DatePickerNew: TDateTimePicker;
    TimePickerNew: TDateTimePicker;
    TimePickerInc: TDateTimePicker;
    CheckSkipWithMeta: TCheckBox;
    CheckIncTimes: TCheckBox;
    BtnSetNow: TButton;
    procedure BtnSetNowClick(Sender: TObject);
  private
  public
    procedure DoIdle; override;

    procedure Setup(Settings: TSettings.TSetDateTime);
    procedure GetSettings(out Settings: TSettings.TSetDateTime);
  end;

implementation

uses
  DataModule;

{$R *.dfm}

procedure TSetDateTimeFrame.BtnSetNowClick(Sender: TObject);
begin
  DatePickerNew.Date := Now;
  TimePickerNew.Time := Now;
end;

procedure TSetDateTimeFrame.DoIdle;
begin
  TimePickerInc.Visible := CheckIncTimes.Checked;
end;

procedure TSetDateTimeFrame.GetSettings(out Settings: TSettings.TSetDateTime);
begin
  Settings.Time := TimeOf(TimePickerNew.Time);
  Settings.Date := DateOf(DatePickerNew.Date);
  Settings.TimeInc := TimeOf(TimePickerInc.Time);
  Settings.IncrementalTimes := CheckIncTimes.Checked;
  Settings.SkipWithMeta := CheckSkipWithMeta.Checked;
end;

procedure TSetDateTimeFrame.Setup(Settings: TSettings.TSetDateTime);
begin
  TimePickerNew.Time := Settings.Time;
  DatePickerNew.Date := Settings.Date;
  TimePickerInc.Time := Settings.TimeInc;
  CheckIncTimes.Checked := Settings.IncrementalTimes;
  CheckSkipWithMeta.Checked := Settings.SkipWithMeta;
end;

end.
