unit DataModule;

interface

uses
  System.SysUtils, System.Classes, Vcl.Dialogs, Vcl.ExtDlgs;

type
  TMainDataModule = class(TDataModule)
    OpenPictureDlg: TOpenPictureDialog;
    OpenSettingsDialog: TOpenDialog;
    SaveSettingsDialog: TSaveDialog;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainDataModule: TMainDataModule;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

uses
  PM.Consts;

{$R *.dfm}

procedure TMainDataModule.DataModuleCreate(Sender: TObject);
begin
  OpenSettingsDialog.Filter := SSettingsFilter + '|' + OpenSettingsDialog.Filter;
  SaveSettingsDialog.Filter := SSettingsFilter;
end;

end.
