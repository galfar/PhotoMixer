program PhotoMixer;

uses
  Forms,
  FormMain in 'FormMain.pas' {MainForm},
  PM.Consts in 'PM.Consts.pas',
  Helpers in 'Helpers.pas',
  Mixer in 'Mixer.pas',
  FormAbout in 'FormAbout.pas' {AboutForm},
  FormToolsSetDateTime in 'FormToolsSetDateTime.pas' {ToolsSetDateTimeForm},
  Tools in 'Tools.pas',
  DataModule in 'DataModule.pas' {MainDataModule: TDataModule};

{$R *.res}

begin
{$IFDEF DEBUG}
  ReportMemoryLeaksOnShutdown := True;
{$ENDIF}
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := SAppTitle;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TAboutForm, AboutForm);
  Application.CreateForm(TToolsSetDateTimeForm, ToolsSetDateTimeForm);
  Application.CreateForm(TMainDataModule, MainDataModule);
  Application.Run;
end.
