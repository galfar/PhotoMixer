unit FrameSelectFolders;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, rkSmartPath,
  Helpers, Tools, FrameBase;

type
  TSelectFoldersFrame = class(TBaseFrame)
    PathPhotos: TrkSmartPath;
    Label4: TLabel;
    BtnBrowseFolder: TButton;
    CheckModifyExisting: TCheckBox;
    LabOutFolder: TLabel;
    PathOutFolder: TrkSmartPath;
    BtnBrowseOutFolder: TButton;
    procedure BtnBrowseFolderClick(Sender: TObject);
    procedure BtnBrowseOutFolderClick(Sender: TObject);
  public
    procedure DoIdle; override;

    procedure Setup(const InOutSettings: TSettings.TInputOutputDirs);
    procedure GetSelection(out InOutSettings: TSettings.TInputOutputDirs);
  end;

implementation

uses
  DataModule, PM.Consts;

{$R *.dfm}

{ TSelectFoldersFrame }

procedure TSelectFoldersFrame.BtnBrowseFolderClick(Sender: TObject);
begin
  BrowseForDir(SSelectPhotoFolder, PathPhotos, False);
end;

procedure TSelectFoldersFrame.BtnBrowseOutFolderClick(Sender: TObject);
begin
  BrowseForDir(SSelectPhotoFolder, PathOutFolder, True);
end;

procedure TSelectFoldersFrame.DoIdle;
begin
  LabOutFolder.Visible := not CheckModifyExisting.Checked;
  PathOutFolder.Visible := not CheckModifyExisting.Checked;
  BtnBrowseOutFolder.Visible := not CheckModifyExisting.Checked;
end;

procedure TSelectFoldersFrame.GetSelection(out InOutSettings: TSettings.TInputOutputDirs);
begin
  InOutSettings.InDir := PathPhotos.Path;
  InOutSettings.OutDir := PathOutFolder.Path;
  InOutSettings.ModifyExisting := CheckModifyExisting.Checked;
end;

procedure TSelectFoldersFrame.Setup(const InOutSettings: TSettings.TInputOutputDirs);
begin
  PathPhotos.Path := InOutSettings.InDir;
  PathOutFolder.Path := InOutSettings.OutDir;
  CheckModifyExisting.Checked := InOutSettings.ModifyExisting;
end;

end.
