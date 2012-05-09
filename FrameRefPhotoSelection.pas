unit FrameRefPhotoSelection;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Helpers, Mixer;

type
  TRefSourceSelectionFrame = class(TFrame)
    Label5: TLabel;
    EditSrcRefPhoto: TEdit;
    BtnViewRefPhoto: TButton;
    BtnBrowseRefPhoto: TButton;
    procedure BtnViewRefPhotoClick(Sender: TObject);
    procedure BtnBrowseRefPhotoClick(Sender: TObject);
  private
    FPhotoPath: string;
    FSource: TSource;
    FIsMasterRef: Boolean;
    FMasterCombo: TComboBox;
    procedure SetPhotoPath(const Value: string);
    property PhotoPath: string read FPhotoPath write SetPhotoPath;
  public
    procedure Setup(ASource: TSource; AMasterCombo: TComboBox = nil);
  end;

implementation

uses
  FormMain, DataModule;

{$R *.dfm}

procedure TRefSourceSelectionFrame.BtnBrowseRefPhotoClick(Sender: TObject);
var
  InitDir: string;
begin
  InitDir := FSource.PhotoDir;
  if FIsMasterRef and (FMasterCombo.ItemIndex >= 0) then
    InitDir := MainForm.Mixer.Source[FMasterCombo.ItemIndex].PhotoDir;

  MainDataModule.OpenPictureDlg.InitialDir := InitDir;
  if MainDataModule.OpenPictureDlg.Execute then
    PhotoPath := MainDataModule.OpenPictureDlg.FileName;
end;

procedure TRefSourceSelectionFrame.BtnViewRefPhotoClick(Sender: TObject);
begin
  if FileExists(FPhotoPath) then
    ShellExecute(FPhotoPath);
end;

procedure TRefSourceSelectionFrame.SetPhotoPath(const Value: string);
begin
  FPhotoPath := Value;
  EditSrcRefPhoto.Text := ExtractFileName(FPhotoPath);

  if FIsMasterRef then
    FSource.MasterRefPhoto := PhotoPath
  else
    FSource.RefPhoto := PhotoPath;
end;

procedure TRefSourceSelectionFrame.Setup(ASource: TSource;
  AMasterCombo: TComboBox);
begin
  FSource := ASource;
  FMasterCombo := AMasterCombo;
  FIsMasterRef := AMasterCombo <> nil;

  if FIsMasterRef then
    PhotoPath := FSource.MasterRefPhoto
  else
    PhotoPath := FSource.RefPhoto;
end;

end.
