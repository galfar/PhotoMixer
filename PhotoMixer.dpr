program PhotoMixer;

uses
  Forms,
  FormMain in 'FormMain.pas' {MainForm},
  PM.Consts in 'PM.Consts.pas',
  Helpers in 'Helpers.pas',
  Mixer in 'Mixer.pas',
  FormAbout in 'FormAbout.pas' {AboutForm},
  Tools in 'Tools.pas',
  DataModule in 'DataModule.pas' {MainDataModule: TDataModule},
  FrameSelectFolders in 'FrameSelectFolders.pas' {SelectFoldersFrame: TFrame},
  FrameDialogControls in 'FrameDialogControls.pas' {DialogControlsFrame: TFrame},
  UITools in 'UITools.pas',
  FrameSetDateTime in 'FrameSetDateTime.pas' {SetDateTimeFrame: TFrame};

{$R *.res}

begin
{$IFDEF DEBUG}
  ReportMemoryLeaksOnShutdown := True;
{$ENDIF}
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := SAppTitle;
  Application.CreateForm(TMainDataModule, MainDataModule);
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TAboutForm, AboutForm);
  Application.Run;
end.
