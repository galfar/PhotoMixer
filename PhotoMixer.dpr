program PhotoMixer;

uses
  Forms,
  FormMain in 'FormMain.pas' {MainForm},
  Helpers in 'Helpers.pas',
  MixerUnit in 'MixerUnit.pas',
  FormAbout in 'FormAbout.pas' {AboutForm};

{$R *.res}

begin
{$IFDEF DEBUG}
  ReportMemoryLeaksOnShutdown := True;
{$ENDIF}
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'PhotoMixer';
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TAboutForm, AboutForm);
  Application.Run;
end.
