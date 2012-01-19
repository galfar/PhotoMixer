unit FormAbout;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ShellAPI, JvExControls, JvLabel;

type
  TAboutForm = class(TForm)
    Label1: TLabel;
    LabVersion: TLabel;
    Label2: TLabel;
    LabHomeSite: TJvLabel;
    LabBuildDate: TLabel;
    LabCopyright: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure LabHomeSiteClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AboutForm: TAboutForm;

implementation

uses
  FormMain, PM.Consts;

{$R *.dfm}

procedure TAboutForm.FormCreate(Sender: TObject);
begin
  Caption := 'About ' + Application.Title;
  LabHomeSite.Caption := SHomeSite;
  LabVersion.Caption := MainForm.Version.FileVersion;
  LabBuildDate.Caption := MainForm.Version.GetCustomFieldValue('Last Compile');
  LabCopyright.Caption := SCopyrightStatement;
end;

procedure TAboutForm.LabHomeSiteClick(Sender: TObject);
begin
  ShellAPI.ShellExecute(0, 'Open', SHomeSite, '', nil, SW_SHOWNORMAL);
end;

end.
