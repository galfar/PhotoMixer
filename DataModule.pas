unit DataModule;

interface

uses
  System.SysUtils, System.Classes, System.Generics.Collections,
  Vcl.AppEvnts, Vcl.Dialogs, Vcl.ExtDlgs, Helpers, Vcl.ImgList, Vcl.Controls,
  GFImageList;

type
  TMainDataModule = class(TDataModule, IIdleManager)
    OpenPictureDlg: TOpenPictureDialog;
    OpenSettingsDialog: TOpenDialog;
    SaveSettingsDialog: TSaveDialog;
    AppEvents: TApplicationEvents;
    Images: TGFImageList;
    procedure DataModuleCreate(Sender: TObject);
    procedure AppEventsIdle(Sender: TObject; var Done: Boolean);
    procedure DataModuleDestroy(Sender: TObject);
  private
    FIdleHandlers: TList<IIdleHandler>;
  public
    procedure RegisterIdleHandler(Handler: IIdleHandler);
    procedure UnRegister(Handler: IIdleHandler);
  end;

var
  MainDataModule: TMainDataModule;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

uses
  PM.Consts;

{$R *.dfm}

procedure TMainDataModule.AppEventsIdle(Sender: TObject; var Done: Boolean);
var
  Handler: IIdleHandler;
begin
  for Handler in FIdleHandlers do
    Handler.DoIdle;
  Done := True;
end;

procedure TMainDataModule.DataModuleCreate(Sender: TObject);
begin
  FIdleHandlers := TList<IIdleHandler>.Create;

  OpenSettingsDialog.Filter := SSettingsFilter + '|' + OpenSettingsDialog.Filter;
  SaveSettingsDialog.Filter := SSettingsFilter;
end;

procedure TMainDataModule.DataModuleDestroy(Sender: TObject);
begin
  FIdleHandlers.Free;
end;

procedure TMainDataModule.RegisterIdleHandler(Handler: IIdleHandler);
begin
  FIdleHandlers.Add(Handler);
end;

procedure TMainDataModule.UnRegister(Handler: IIdleHandler);
begin
  FIdleHandlers.Remove(Handler);
end;

end.
