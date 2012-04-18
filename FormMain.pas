unit FormMain;

interface

uses
  Types, Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, rkVistaPanel, ExtCtrls, ComCtrls, JvExControls, JvPageList,
  rkSmartTabs, StdCtrls, rkGlassButton, rkSmartPath, JvExStdCtrls, ShlObj,
  JvHtControls, JvExExtCtrls, JvExtComponent, FileCtrl,
  ImgList, ActnList, AppEvnts, JvComponentBase, JvAppStorage, JvAppIniStorage,
  JvFormPlacement, IoUtils, FormAbout, Menus, DateUtils, JvRichEdit,
  ShellCtrls, ExtDlgs, Mask, JvSpin, JclFileUtils,
  JvBalloonHint, GFImageList, Helpers, Tools, Mixer, JvExMask;

type
  TMainForm = class(TForm, IUIBridge, IIdleHandler)
    PanelTop: TrkVistaPanel;
    TabsMain: TrkSmartTabs;
    PageList: TJvPageList;
    PageSource: TJvStandardPage;
    PageSettings: TJvStandardPage;
    BtnAddSource: TrkGlassButton;
    BtnProcess: TrkGlassButton;
    BtnAbout: TrkGlassButton;
    PathSourceDir: TrkSmartPath;
    Label1: TLabel;
    BtnBrowseSourceDir: TButton;
    Label3: TLabel;
    EditSourceName: TEdit;
    Label4: TLabel;
    PathOutput: TrkSmartPath;
    BtnBrowseOutputDir: TButton;
    Actions: TActionList;
    ActAddSource: TAction;
    Label6: TLabel;
    EditFileTypes: TEdit;
    CheckSyncSources: TCheckBox;
    IniFile: TJvAppIniFileStorage;
    FormStorage: TJvFormStorage;
    Button1: TButton;
    BtnTools: TrkGlassButton;
    PopupTools: TPopupMenu;
    dfsadsad1: TMenuItem;
    asdsad1: TMenuItem;
    LogView: TJvRichEdit;
    PopupLog: TPopupMenu;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    PanelSrcSync: TPanel;
    RadioSyncRef: TRadioButton;
    RadioSyncShift: TRadioButton;
    PanelSyncRef: TPanel;
    EditSrcRefPhoto: TEdit;
    Label5: TLabel;
    Button3: TButton;
    PanelSyncShift: TPanel;
    Label2: TLabel;
    PanelRefSource: TPanel;
    LabRefSource: TLabel;
    ComboRefSource: TComboBox;
    EditSrcSyncShift: TJvSpinEdit;
    ActToolsLoadSettings: TAction;
    ActToolsSaveSettings: TAction;
    N1: TMenuItem;
    ActToolsClearOutDir: TAction;
    ClearOutputFolder1: TMenuItem;
    Label7: TLabel;
    EditNamePattern: TEdit;
    ActLogClear: TAction;
    ActLogCopy: TAction;
    Images: TGFImageList;
    ProgressBar: TProgressBar;
    ControlHint: TJvBalloonHint;
    ActToolsSetDateTime: TAction;
    SetPhotoDateTime1: TMenuItem;
    ActToolsFileFromMeta: TAction;
    SetFileDateFromPhotoMetadata1: TMenuItem;
    ActToolsAutoOrient: TAction;
    AutoOrientAccordingtoMetadata1: TMenuItem;
    procedure TabsMainCloseTab(Sender: TObject; Index: Integer;
      var Close: Boolean);
    procedure TabsMainTabChange(Sender: TObject);
    procedure BtnBrowseSourceDirClick(Sender: TObject);
    procedure PathSourceDirPathChanged(Sender: TObject);
    procedure EditSourceNameChange(Sender: TObject);
    procedure TabsMainAddClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ActAddSourceExecute(Sender: TObject);
    procedure BtnProcessClick(Sender: TObject);
    procedure IniFileGetFileName(Sender: TJvCustomAppStorage;
      var FileName: TFileName);
    procedure CheckSyncSourcesClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure EditFileTypesChange(Sender: TObject);
    procedure BtnAboutClick(Sender: TObject);
    procedure PathOutputPathChanged(Sender: TObject);
    procedure ComboRefSourceChange(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure Button3Click(Sender: TObject);
    procedure RadioSyncRefClick(Sender: TObject);
    procedure RadioSyncShiftClick(Sender: TObject);
    procedure EditSrcSyncShiftChange(Sender: TObject);
    procedure EditNamePatternChange(Sender: TObject);
    procedure ActLogClearExecute(Sender: TObject);
    procedure ActLogCopyExecute(Sender: TObject);
    procedure BtnBrowseOutputDirClick(Sender: TObject);
    procedure ActToolsClearOutDirExecute(Sender: TObject);
    procedure ActToolsSaveSettingsExecute(Sender: TObject);
    procedure ActToolsLoadSettingsExecute(Sender: TObject);
    procedure ActToolsSetDateTimeExecute(Sender: TObject);
    procedure ActToolsFileFromMetaExecute(Sender: TObject);
    procedure ActToolsAutoOrientExecute(Sender: TObject);
  private
    Mixer: TMixer;
    Tools: TTools;
    UserDocsDir: string;
    StartTime: TDateTime;
    LogFont: TFont;    

    procedure SelectSource(Index: Integer);
    procedure LoadMixerSettings(Ini: TJvAppIniFileStorage);
    procedure SaveMixerSettings(Ini: TJvAppIniFileStorage);
    procedure LoadToolsSettings(Ini: TJvAppIniFileStorage);
    procedure SaveToolsSettings(Ini: TJvAppIniFileStorage);
    procedure PopulateUI;
    procedure SetDefaultSettings;

    function GenSourceName: string;
    function GetSourceIndex: Integer;

    procedure ShowControlHint(Control: TControl; const Msg: string; Icon: TJvIconKind = ikInformation;
      const Header: string = ''; VisibleTime: Integer = 1500);
    procedure ShowControlError(Control: TControl; const Msg: string);  
    
    procedure TryStartingMixer;
    
    // IUIBridge methods
    procedure ShowMessage(MsgType: TMessageType; const MsgFmt: string; const Args: array of const);
    procedure OnBegin;
    procedure OnEnd(UserAbort: Boolean);
    procedure OnProgress(Current, Total: Integer);

    // IIdleHandler methods
    procedure DoIdle;
  public
    Version: TJclFileVersionInfo;
  end;

var
  MainForm: TMainForm;

implementation

uses
  FormToolsSetDateTime, DataModule, PM.Consts, UITools;

{$R *.dfm}

function TMainForm.GenSourceName: string;
begin
  Result := SSource + ' ' + IntToStr(Mixer.SourceCount);
end;

function TMainForm.GetSourceIndex: Integer;
begin
  Result := TabsMain.ActiveTab - 1;
  Assert((Result >= 0) and (Result < Mixer.SourceCount));
end;

procedure TMainForm.ActAddSourceExecute(Sender: TObject);
var
  Src: TSource;
begin
  Src := Mixer.AddSource;
  Src.Name := GenSourceName;
  Src.PhotoDir := UserDocsDir;
  ComboRefSource.Items.Add(Src.Name);
  TabsMain.AddTab(Src.Name);
  EditSourceName.SetFocus;
end;

procedure TMainForm.ActLogClearExecute(Sender: TObject);
begin
  LogView.Clear;
end;

procedure TMainForm.ActLogCopyExecute(Sender: TObject);
begin
  LogView.SelectAll;
  LogView.CopyToClipboard;  
end;

procedure TMainForm.ActToolsAutoOrientExecute(Sender: TObject);
begin
  if SelectPhotoFolders(ActToolsAutoOrient.Caption, Tools.Settings.InputOutputDirs) then
    Tools.AutoOrientByMeta;
end;

procedure TMainForm.ActToolsClearOutDirExecute(Sender: TObject);
var
  FileList: TStringDynArray;
  S: string;
begin
  if TDirectory.Exists(Mixer.Settings.OutputDir) then
  begin
    FileList := TDirectory.GetFiles(Mixer.Settings.OutputDir);
    for S in FileList do
      TFile.Delete(S);
    ShowMessage(mtInfo, 'Deleted %d files in folder: %s', [Length(FileList), Mixer.Settings.OutputDir]);      
  end
  else
    ShowMessage(mtError, 'Failed to delete files in folder: %s', [Mixer.Settings.OutputDir]);
end;

procedure TMainForm.ActToolsFileFromMetaExecute(Sender: TObject);
begin
  if SelectPhotoFolders(ActToolsFileFromMeta.Caption, Tools.Settings.InputOutputDirs) then
    Tools.SetFileTimeFromMeta;
end;

procedure TMainForm.ActToolsLoadSettingsExecute(Sender: TObject);
var
  Ini: TJvAppIniFileStorage;
begin
  if MainDataModule.OpenSettingsDialog.Execute then
  begin
    Ini := TJvAppIniFileStorage.Create(nil);    
    try
      Ini.StorageOptions := IniFile.StorageOptions;
      Ini.Location := flCustom;
      Ini.FileName := MainDataModule.OpenSettingsDialog.FileName;

      LoadMixerSettings(Ini);
    finally
      Ini.Free;
    end;    
  end; 
end;

procedure TMainForm.ActToolsSaveSettingsExecute(Sender: TObject);
var
  Ini: TJvAppIniFileStorage;
begin
  if MainDataModule.SaveSettingsDialog.Execute then
  begin
    Ini := TJvAppIniFileStorage.Create(nil);    
    try
      Ini.StorageOptions := IniFile.StorageOptions;
      Ini.Location := flCustom;
      Ini.FileName := MainDataModule.SaveSettingsDialog.FileName;

      SaveMixerSettings(Ini);
    finally
      Ini.Free;
    end;
  end;    
end;

procedure TMainForm.ActToolsSetDateTimeExecute(Sender: TObject);
begin
  if UITools.ShowSetPhotoDateTimeDialog(Tools.Settings.InputOutputDirs,
    Tools.Settings.SetDateTime) then
  begin
    Tools.SetPhotoDateTime;
  end;
end;

procedure TMainForm.DoIdle;
begin
  if not Mixer.Running then
  begin
    BtnProcess.Caption := 'Run!';
    BtnProcess.ImageIndex := 0;
    if not PathOutput.Enabled then
      SetWinControlState(PageSettings, True);
  end
  else
  begin
    BtnProcess.Caption := 'Stop!';
    BtnProcess.ImageIndex := 1;
  end;

  TabsMain.Enabled := not Mixer.Running;
  BtnAddSource.Enabled := not Mixer.Running;
  BtnTools.Enabled := not Mixer.Running;

  LabRefSource.Visible := Mixer.Settings.SyncSources;
  ComboRefSource.Visible := Mixer.Settings.SyncSources;
  PanelRefSource.Visible := Mixer.Settings.SyncSources;
  PanelSrcSync.Visible := Mixer.Settings.SyncSources;

  if TabsMain.ActiveTab > 0 then
  begin
    PanelSyncRef.Visible := Mixer.Source[TabsMain.ActiveTab - 1].SyncMode = smRefPhoto;
    PanelSyncShift.Visible := Mixer.Source[TabsMain.ActiveTab - 1].SyncMode = smExplicitShift;
  end;
end;

procedure TMainForm.BtnAboutClick(Sender: TObject);
begin
  AboutForm.ShowModal;
end;

procedure TMainForm.BtnBrowseOutputDirClick(Sender: TObject);
begin
  BrowseForDir(SSelectOutputPhotoFolder, PathOutput, True);
end;

procedure TMainForm.BtnBrowseSourceDirClick(Sender: TObject);
begin
  BrowseForDir(SSelectSourcePhotoFolder, PathSourceDir, False);
end;

procedure TMainForm.BtnProcessClick(Sender: TObject);
begin
  if not Mixer.Running then
    TryStartingMixer
  else
    Mixer.Abort;
end;

procedure TMainForm.Button1Click(Sender: TObject);
begin
  EditFileTypes.Text := SDefaultFileTypes;
end;

procedure TMainForm.Button3Click(Sender: TObject);
begin
  MainDataModule.OpenPictureDlg.InitialDir := Mixer.Source[GetSourceIndex].PhotoDir;
  if MainDataModule.OpenPictureDlg.Execute then
  begin
    Mixer.Source[GetSourceIndex].RefPhoto := MainDataModule.OpenPictureDlg.FileName;
    EditSrcRefPhoto.Text := ExtractFileName(MainDataModule.OpenPictureDlg.FileName);
  end;
end;

procedure TMainForm.CheckSyncSourcesClick(Sender: TObject);
begin
  Mixer.Settings.SyncSources := CheckSyncSources.Checked;
end;

procedure TMainForm.ComboRefSourceChange(Sender: TObject);
begin
  Mixer.Settings.RefSource := ComboRefSource.ItemIndex;
end;

procedure TMainForm.EditFileTypesChange(Sender: TObject);
begin
  Mixer.Settings.FileTypes := EditFileTypes.Text;
end;

procedure TMainForm.EditNamePatternChange(Sender: TObject);
begin
  Mixer.Settings.NamePattern := EditNamePattern.Text;
end;

procedure TMainForm.EditSourceNameChange(Sender: TObject);
var
  Src: TSource;
  Idx: Integer;
begin
  Assert(TabsMain.ActiveTab > 0);
  Src := Mixer.Source[TabsMain.ActiveTab - 1];
  Src.Name := EditSourceName.Text;
  TabsMain.Tabs[TabsMain.ActiveTab] := Src.Name;     
  TabsMain.Invalidate;
  Idx := ComboRefSource.ItemIndex;
  ComboRefSource.Items[TabsMain.ActiveTab - 1] := Src.Name; 
  if Idx = TabsMain.ActiveTab - 1 then
    ComboRefSource.ItemIndex := Idx; // ItemIndex is reset by changing the Items
end;

procedure TMainForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := not Mixer.Running;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  Mixer := TMixer.Create(Self);
  Tools := TTools.Create(Self);

  UserDocsDir := PathOutput.GetSpecialFolderPath(CSIDL_MYDOCUMENTS);
  Version := TJclFileVersionInfo.Create(MainInstance);

  Caption := SAppTitle;

  LogFont := TFont.Create;
  LogFont.Assign(LogView.Font);

  LoadMixerSettings(IniFile);
  LoadToolsSettings(IniFile);

  MainDataModule.RegisterIdleHandler(Self);
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  SaveMixerSettings(IniFile);
  SaveToolsSettings(IniFile);

  Mixer.Free;
  Tools.Free;
  LogFont.Free;
  Version.Free;
end;

procedure TMainForm.IniFileGetFileName(Sender: TJvCustomAppStorage;
  var FileName: TFileName);
var
  Dir: string;
begin
  Dir := PathSourceDir.GetSpecialFolderPath(CSIDL_APPDATA) + PathDelim + SAppDataDir;
  IoUtils.TDirectory.CreateDirectory(Dir);
  FileName := Dir + PathDelim + SSettingsFile;      
end;

procedure TMainForm.EditSrcSyncShiftChange(Sender: TObject);
begin
  Mixer.Source[GetSourceIndex].ExplicitShift := Round(EditSrcSyncShift.Value);
end;

procedure TMainForm.PopulateUI;
var
  I: Integer;
  Src: TSource;     
begin
  TabsMain.Tabs.Clear;
  TabsMain.AddTab(STabSettingsName);  

  PathOutput.Path := Mixer.Settings.OutputDir; 
  EditNamePattern.Text := Mixer.Settings.NamePattern;
  EditFileTypes.Text := Mixer.Settings.FileTypes;
  CheckSyncSources.Checked := Mixer.Settings.SyncSources;
  
  ComboRefSource.Items.Clear;
  for I := 0 to Mixer.SourceCount - 1 do
  begin
    Src := Mixer.Source[I]; 
    ComboRefSource.AddItem(Src.Name, nil);  
    TabsMain.AddTab(Name);
  end;
  ComboRefSource.ItemIndex := Mixer.Settings.RefSource;
    
  if Mixer.SourceCount = 0 then
  begin
    ActAddSource.Execute;
    TabsMain.ActiveTab := 1;
  end 
  else   
    TabsMain.ActiveTab := 0;
end;

procedure TMainForm.RadioSyncRefClick(Sender: TObject);
begin
  Mixer.Source[GetSourceIndex].SyncMode := smRefPhoto;
end;

procedure TMainForm.RadioSyncShiftClick(Sender: TObject);
begin
  Mixer.Source[GetSourceIndex].SyncMode := smExplicitShift;
end;

procedure TMainForm.SetDefaultSettings;
begin
  Tools.Settings.InputOutputDirs.InDir := UserDocsDir;
  Tools.Settings.InputOutputDirs.OutDir := UserDocsDir + PathDelim + SOutput;
  Tools.Settings.InputOutputDirs.ModifyExisting := True;

  Tools.Settings.SetDateTime.Date := Now;
  Tools.Settings.SetDateTime.Time := Now;
  Tools.Settings.SetDateTime.TimeInc := EncodeTime(0, 1, 0, 0);
  Tools.Settings.SetDateTime.IncrementalTimes := False;
  Tools.Settings.SetDateTime.SkipWithMeta := True;
end;

procedure TMainForm.LoadMixerSettings(Ini: TJvAppIniFileStorage);
var
  Count, I: Integer;
  Src: TSource; 
  SrcPath: string;    
begin
  Ini.Reload;
  Mixer.Reset;

  Mixer.Settings.OutputDir := Ini.ReadString(SSettingsOptionsPath + 'OutDir', UserDocsDir);
  Mixer.Settings.NamePattern := Ini.ReadString(SSettingsOptionsPath + 'NamePattern', 'My Album');
  Mixer.Settings.FileTypes := Ini.ReadString(SSettingsOptionsPath + 'FileTypes', SDefaultFileTypes);
  Mixer.Settings.SyncSources := Ini.ReadBoolean(SSettingsOptionsPath + 'SyncSources', True);
  Mixer.Settings.RefSource := Ini.ReadInteger(SSettingsOptionsPath + 'RefSource', -1);

  Count := Ini.ReadInteger(SSettingsSourcesPath + 'Count', 0);          
  for I := 0 to Count - 1 do
  begin
    Src := Mixer.AddSource;
    SrcPath := Format(SSettingsSourcesPath + 'Source%2.2d.', [I]);
    Src.Name := Ini.ReadString(SrcPath + 'Name', 'Source ' + IntToStr(I + 1));
    Src.PhotoDir := Ini.ReadString(SrcPath + 'PhotoDir', UserDocsDir);                
    Src.RefPhoto := Ini.ReadString(SrcPath + 'RefPhoto', '');
    Ini.ReadEnumeration(SrcPath + 'SyncMode', TypeInfo(TSyncMode), Src.SyncMode, Src.SyncMode);                
    Src.RefPhoto := Ini.ReadString(SrcPath + 'RefPhoto', '');        
    Src.ExplicitShift := Ini.ReadInteger(SrcPath + 'ExplicitShift', 0);
  end;  

  PopulateUI;
end;

procedure TMainForm.LoadToolsSettings(Ini: TJvAppIniFileStorage);
begin
  Ini.Reload;

  Tools.Settings.InputOutputDirs.InDir := Ini.ReadString(SSettingsToolsPath + 'InDir', UserDocsDir);
  Tools.Settings.InputOutputDirs.OutDir := Ini.ReadString(SSettingsToolsPath + 'OutDir', UserDocsDir + PathDelim + SOutput);
  Tools.Settings.InputOutputDirs.ModifyExisting := Ini.ReadBoolean(SSettingsToolsPath + 'ModifyExisting', True);

  Tools.Settings.SetDateTime.Date := DateOf(Ini.ReadDateTime(SSettingsToolsPath + 'SetDateTime' + PathDelim + 'DateTime', Now));
  Tools.Settings.SetDateTime.Time := TimeOf(Ini.ReadDateTime(SSettingsToolsPath + 'SetDateTime' + PathDelim + 'DateTime', Now));
  Tools.Settings.SetDateTime.TimeInc := TimeOf(Ini.ReadDateTime(SSettingsToolsPath + 'SetDateTime' + PathDelim + 'TimeInc', EncodeTime(0, 1, 0, 0)));
  Tools.Settings.SetDateTime.IncrementalTimes := Ini.ReadBoolean(SSettingsToolsPath + 'SetDateTime' + PathDelim + 'IncrementalTimes', False);
  Tools.Settings.SetDateTime.SkipWithMeta := Ini.ReadBoolean(SSettingsToolsPath + 'SetDateTime' + PathDelim + 'SkipWithMeta', True);
end;

procedure TMainForm.SaveMixerSettings(Ini: TJvAppIniFileStorage);
var
  I: Integer;
  Src: TSource;     
  SrcPath: string;    
begin
  Ini.WriteInteger(SSettingsOptionsPath + 'Version', CurrentSettingsVersion);
  Ini.WriteString(SSettingsOptionsPath + 'OutDir', Mixer.Settings.OutputDir);
  Ini.WriteString(SSettingsOptionsPath + 'NamePattern', Mixer.Settings.NamePattern);
  Ini.WriteString(SSettingsOptionsPath + 'FileTypes', Mixer.Settings.FileTypes);
  Ini.WriteBoolean(SSettingsOptionsPath + 'SyncSources', Mixer.Settings.SyncSources);
  Ini.WriteInteger(SSettingsOptionsPath + 'RefSource', Mixer.Settings.RefSource);
                         
  Ini.WriteInteger(SSettingsSourcesPath + 'Count', Mixer.SourceCount);
  for I := 0 to Mixer.SourceCount - 1 do
  begin
    Src := Mixer.Source[I];
    SrcPath := Format(SSettingsSourcesPath + 'Source%2.2d.', [I]);
    Ini.WriteString(SrcPath + 'Name', Src.Name);
    Ini.WriteString(SrcPath + 'PhotoDir', Src.PhotoDir);        
    Ini.WriteEnumeration(SrcPath + 'SyncMode', TypeInfo(TSyncMode), Src.SyncMode);                
    Ini.WriteString(SrcPath + 'RefPhoto', Src.RefPhoto);        
    Ini.WriteInteger(SrcPath + 'ExplicitShift', Src.ExplicitShift);        
  end;
  
  Ini.Flush;
end;

procedure TMainForm.SaveToolsSettings(Ini: TJvAppIniFileStorage);
var
  DateTime: TDateTime;
begin
  Ini.WriteString(SSettingsToolsPath + 'InDir', Tools.Settings.InputOutputDirs.InDir);
  Ini.WriteString(SSettingsToolsPath + 'OutDir', Tools.Settings.InputOutputDirs.OutDir);
  Ini.WriteBoolean(SSettingsToolsPath + 'ModifyExisting', Tools.Settings.InputOutputDirs.ModifyExisting);

  DateTime := DateOf(Tools.Settings.SetDateTime.Date) + TimeOf(Tools.Settings.SetDateTime.Time);
  Ini.WriteDateTime(SSettingsToolsPath + 'SetDateTime' + PathDelim + 'DateTime', DateTime);
  Ini.WriteDateTime(SSettingsToolsPath + 'SetDateTime' + PathDelim + 'TimeInc', Tools.Settings.SetDateTime.TimeInc);
  Ini.WriteBoolean(SSettingsToolsPath + 'SetDateTime' + PathDelim + 'IncrementalTimes', Tools.Settings.SetDateTime.IncrementalTimes);
  Ini.WriteBoolean(SSettingsToolsPath + 'SetDateTime' + PathDelim + 'SkipWithMeta', Tools.Settings.SetDateTime.SkipWithMeta);

  Ini.Flush;
end;

procedure TMainForm.PathOutputPathChanged(Sender: TObject);
begin
  Mixer.Settings.OutputDir := PathOutput.Path;
end;

procedure TMainForm.PathSourceDirPathChanged(Sender: TObject);
begin  
  Mixer.Source[TabsMain.ActiveTab - 1].PhotoDir := PathSourceDir.Path;
end;

procedure TMainForm.SelectSource(Index: Integer);
var
  Src: TSource;
begin
  if TabsMain.ActiveTab - 1 <> Index then
    TabsMain.ActiveTab := Index + 1;
  Src := Mixer.Source[Index];
  EditSourceName.Text := Src.Name;
  PathSourceDir.Path := Src.PhotoDir;  
  EditSrcRefPhoto.Text := ExtractFileName(Src.RefPhoto);
  EditSrcSyncShift.Value := Src.ExplicitShift;
  RadioSyncRef.Checked := Src.SyncMode = smRefPhoto;
  RadioSyncShift.Checked := not RadioSyncRef.Checked;

  PageList.ActivePage := PageSource;
end;

procedure TMainForm.TabsMainAddClick(Sender: TObject);
begin
  ActAddSource.Execute;
end;

procedure TMainForm.TabsMainCloseTab(Sender: TObject; Index: Integer;
  var Close: Boolean);
begin
  Close := Index > 0;
  if Close then
  begin
    Mixer.DeleteSource(Index - 1);
    ComboRefSource.Items.Delete(Index - 1);
  end;
end;

procedure TMainForm.TabsMainTabChange(Sender: TObject);
begin
  if TabsMain.ActiveTab > 0 then
    SelectSource(TabsMain.ActiveTab - 1)
  else  
    PageList.ActivePage := PageSettings;
end;

procedure TMainForm.TryStartingMixer;

  function DoInputChecks: Boolean;
  var
    I: Integer;
    Src: TSource;
  begin
    for I := 0 to Mixer.SourceCount - 1 do
    begin
      Src := Mixer.Source[I];
      if not TDirectory.Exists(Src.PhotoDir) then
      begin
        SelectSource(I);   
        ShowControlError(PathSourceDir, 'Source photo folder does not exist');
        Exit(False);
      end;
      if Mixer.Settings.SyncSources and (Src.SyncMode = smRefPhoto) then
      begin
        if Src.RefPhoto = '' then              
        begin
          SelectSource(I);
          ShowControlError(EditSrcRefPhoto, 'Source reference photo not defined');
          Exit(False);
        end
        else if not TFile.Exists(Src.RefPhoto) then              
        begin
          SelectSource(I);
          ShowControlError(EditSrcRefPhoto, 'Source reference photo does not exist');
          Exit(False);
        end;
      end;
    end;         
        
    if not ForceDirectories(Mixer.Settings.OutputDir) then
    begin
      ShowControlError(PathOutput, 'Cannot create output folder');
      Exit(False);
    end;

    if Mixer.Settings.SyncSources and (Mixer.Settings.RefSource < 0) then
    begin
      ShowControlError(ComboRefSource, 'Sync reference source not selected');
      Exit(False);      
    end;    

    Result := True;
  end;

begin
  TabsMain.ActiveTab := 0;
  LogView.Clear;
    
  if not DoInputChecks then
    Exit;
 
  SetWinControlState(PageSettings, False, LogView);
  Progressbar.Position := 0;
  ProgressBar.Visible := True;  
  Mixer.Start;
end;

procedure TMainForm.ShowControlError(Control: TControl; const Msg: string);
begin
  ShowControlHint(Control, Msg, ikError);
end;

procedure TMainForm.ShowControlHint(Control: TControl; const Msg: string;
  Icon: TJvIconKind; const Header: string; VisibleTime: Integer);
var
  S: string;
begin
  S := Header;
  case Icon of
    ikError: S := 'Error';
    ikInformation: S := 'Information';
    ikWarning: S := 'Warning';
  end;
  ControlHint.ActivateHint(Control, Msg, Icon, S, VisibleTime);
end;

procedure TMainForm.ShowMessage(MsgType: TMessageType; const MsgFmt: string;
  const Args: array of const);
var
  Msg: string; 
  Proc: TThreadProcedure;   
begin     
  Msg := Format(MsgFmt, Args) + SLineBreak;   

  Proc :=
    procedure     
    begin           
      LogFont.Color := clWindowText;
      LogFont.Style := [];
  
      case MsgType of
        mtImportant:
          begin
            LogFont.Style := [fsBold];
          end;
        mtWarning:   
          begin
            LogFont.Color := clOlive;
            Msg := 'Warning: ' + Msg;
          end;                               
        mtError:
          begin
            LogFont.Style := [fsBold];
            LogFont.Color := clRed;
            Msg := 'Fatal Error: ' + Msg;
          end;
      end;

      LogView.AddFormatText(Msg, LogFont);
      LogView.SelStart := LogView.GetTextLen;
      LogView.SelLength := 0;
      LogView.Perform(EM_SCROLLCARET, 0, 0);
    end;

  if (TThread.CurrentThread.ThreadID <> MainThreadID) then
    TThread.Synchronize(TThread.CurrentThread, Proc)
  else 
    Proc;    
end;

procedure TMainForm.OnBegin;
begin
  StartTime := Now;
end;

procedure TMainForm.OnEnd(UserAbort: Boolean);
var
  Span: TDateTime;
begin
  Span := Now - StartTime;
  if not UserAbort then
    ShowMessage(TMessageType.mtImportant, 'Photo mixing finished in %s', [TimeToStr(Span)])
  else 
    ShowMessage(TMessageType.mtImportant, 'Photo mixing aborted', []);
end;

procedure TMainForm.OnProgress(Current, Total: Integer);
begin  
  Assert(TThread.CurrentThread.ThreadID <> MainThreadID);
  TThread.Synchronize(TThread.CurrentThread, 
    procedure 
    begin
      ProgressBar.Max := Total;
      ProgressBar.Position := Current;
    end);  
end;

end.
