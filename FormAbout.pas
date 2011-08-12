unit FormAbout;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ShellAPI;

type
  TAboutForm = class(TForm)
    Label1: TLabel;
    LabVersion: TLabel;
    LabHomeSite: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure LabHomeSiteClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AboutForm: TAboutForm;

const 
  SHomeSite = 'http://galfar.vevb.net/photomixer';

implementation

uses FormMain;

{$R *.dfm}

procedure TAboutForm.FormCreate(Sender: TObject);
begin
  Caption := 'About ' + Application.Title;
  LabHomeSite.Caption := SHomeSite;
  LabVersion.Caption := MainForm.Version.FileVersion;
end;

procedure TAboutForm.LabHomeSiteClick(Sender: TObject);
begin
  ShellAPI.ShellExecute(0, 'Open', SHomeSite, '', nil, SW_SHOWNORMAL);
end;

end.
