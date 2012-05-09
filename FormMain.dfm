object MainForm: TMainForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'PhotoMixer'
  ClientHeight = 567
  ClientWidth = 681
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  GlassFrame.Top = 200
  OldCreateOrder = False
  Position = poScreenCenter
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 15
  object TabsMain: TrkSmartTabs
    Left = 0
    Top = 38
    Width = 681
    Height = 30
    Align = alTop
    ActiveTab = 0
    ColorTabActive = clWhite
    ColorTabHot = 16316664
    ColorTabInActive = 15790320
    ColorTxtActive = clBlack
    ColorTxtHot = clBlack
    ColorTxtInActive = clBlack
    ColorBrdActive = clBlack
    ColorBrdHot = clBlack
    ColorBrdInActive = clBlack
    ColorBackground = 15395562
    GdiPlusText = True
    Images = MainDataModule.Images
    LevelTabActive = 255
    LevelTabHot = 192
    LevelTabInActive = 224
    PinnedStr = '!'
    SeeThruTabs = False
    ShowImages = True
    Tabs.Strings = (
      'Settings'
      'Source 1')
    OnAddClick = TabsMainAddClick
    OnCloseTab = TabsMainCloseTab
    OnTabChange = TabsMainTabChange
  end
  object PanelTop: TrkVistaPanel
    Left = 0
    Top = 0
    Width = 681
    Height = 38
    Align = alTop
    BevelInner = bvNone
    BevelOuter = bvNone
    Color1 = clWhite
    Color2 = 15395562
    Color3 = 16769217
    Color4 = 16758897
    ColorFrame = clGreen
    Frames = []
    Opacity = 40
    ParentBackground = False
    Style = vgGlass
    object BtnAddSource: TrkGlassButton
      AlignWithMargins = True
      Left = 6
      Top = 4
      Width = 100
      Height = 30
      Margins.Left = 6
      Margins.Top = 4
      Margins.Right = 0
      Margins.Bottom = 4
      Action = ActAddSource
      Align = alLeft
      AltFocus = False
      AltRender = True
      Color = clBlack
      ColorDown = clBlack
      ColorFrame = clGray
      DropDownAlignment = paLeft
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBtnText
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = []
      Glossy = True
      GlossyLevel = 15
      GlyphPos = gpLeft
      ImageIndex = 3
      Images = MainDataModule.Images
      ImageSpacing = 0
      LightHeight = 27
      ShadowStyle = ssNone
      TabOrder = 0
      TextAlign = taCenter
    end
    object BtnProcess: TrkGlassButton
      AlignWithMargins = True
      Left = 218
      Top = 4
      Width = 100
      Height = 30
      Margins.Left = 6
      Margins.Top = 4
      Margins.Right = 0
      Margins.Bottom = 4
      Align = alLeft
      AltFocus = False
      AltRender = True
      Caption = 'Run!'
      Color = clBlack
      ColorDown = clBlack
      ColorFrame = clGray
      DropDownAlignment = paLeft
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBtnText
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = []
      Glossy = True
      GlossyLevel = 15
      GlyphPos = gpLeft
      ImageIndex = 0
      Images = MainDataModule.Images
      ImageSpacing = -8
      LightHeight = 27
      ShadowStyle = ssNone
      TabOrder = 1
      TextAlign = taCenter
      OnClick = BtnProcessClick
    end
    object BtnAbout: TrkGlassButton
      AlignWithMargins = True
      Left = 575
      Top = 4
      Width = 100
      Height = 30
      Margins.Left = 6
      Margins.Top = 4
      Margins.Right = 6
      Margins.Bottom = 4
      Align = alRight
      AltFocus = False
      AltRender = True
      Caption = 'About'
      Color = clBlack
      ColorDown = clBlack
      ColorFrame = clGray
      DropDownAlignment = paLeft
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBtnText
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = []
      Glossy = True
      GlossyLevel = 15
      GlyphPos = gpLeft
      ImageIndex = 4
      Images = MainDataModule.Images
      ImageSpacing = -2
      LightHeight = 27
      ShadowStyle = ssNone
      TabOrder = 2
      TextAlign = taCenter
      OnClick = BtnAboutClick
    end
    object BtnTools: TrkGlassButton
      AlignWithMargins = True
      Left = 112
      Top = 4
      Width = 100
      Height = 30
      Margins.Left = 6
      Margins.Top = 4
      Margins.Right = 0
      Margins.Bottom = 4
      Align = alLeft
      AltFocus = False
      AltRender = True
      Arrow = True
      Caption = 'Tools'
      Color = clBlack
      ColorDown = clBlack
      ColorFrame = clGray
      DropDownAlignment = paLeft
      DropDownMenu = PopupTools
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBtnText
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = []
      Glossy = True
      GlossyLevel = 15
      GlyphPos = gpLeft
      ImageIndex = 2
      Images = MainDataModule.Images
      ImageSpacing = 0
      LightHeight = 27
      ShadowStyle = ssNone
      TabOrder = 3
      TextAlign = taCenter
    end
  end
  object PageList: TJvPageList
    Left = 0
    Top = 68
    Width = 681
    Height = 499
    ActivePage = PageSource
    PropagateEnable = False
    Align = alClient
    object PageSettings: TJvStandardPage
      Left = 0
      Top = 0
      Width = 681
      Height = 499
      Caption = 'Output Page'
      Color = clBtnHighlight
      object Label4: TLabel
        Left = 16
        Top = 31
        Width = 75
        Height = 15
        Caption = 'Output folder:'
      end
      object Label6: TLabel
        Left = 16
        Top = 94
        Width = 52
        Height = 15
        Caption = 'File types:'
      end
      object Label7: TLabel
        Left = 16
        Top = 63
        Width = 79
        Height = 15
        Caption = 'Base file name:'
      end
      object LabDefaultMasterSource: TLabel
        Left = 16
        Top = 129
        Width = 115
        Height = 39
        AutoSize = False
        Caption = 'Default master reference source:'
        FocusControl = ComboDefaultMasterSource
        WordWrap = True
      end
      object PathOutput: TrkSmartPath
        Left = 131
        Top = 25
        Width = 453
        Height = 25
        AllowKeyNav = True
        BtnGreyGrad1 = 15921906
        BtnGreyGrad2 = 14935011
        BtnNormGrad1 = 16643818
        BtnNormGrad2 = 16046502
        BtnHotGrad1 = 16643818
        BtnHotGrad2 = 16441260
        BtnPenGray = 9408399
        BtnPenNorm = 11632444
        BtnPenShade1 = 9598820
        BtnPenShade2 = 15388572
        BtnPenArrow = clBlack
        ColorEnter = clWindow
        ColorExit = clWindow
        ComputerAsDefault = True
        DirMustExist = False
        EmptyPathIcon = 12
        EmptyPathText = 'Computer'
        NewFolderName = 'New Folder'
        ParentColor = False
        ParentBackground = False
        Path = 'd:\projects\raging\p35\'
        SpecialFolders = [spDesktop, spDocuments, spPictures]
        TabOrder = 0
        OnPathChanged = PathOutputPathChanged
      end
      object BtnBrowseOutputDir: TButton
        Left = 590
        Top = 25
        Width = 75
        Height = 25
        Caption = 'Browse...'
        TabOrder = 1
        OnClick = BtnBrowseOutputDirClick
      end
      object EditFileTypes: TEdit
        Left = 131
        Top = 91
        Width = 453
        Height = 21
        AutoSize = False
        TabOrder = 2
        Text = 'jpg, jpeg, avi, mov'
        OnChange = EditFileTypesChange
      end
      object Button1: TButton
        Left = 590
        Top = 89
        Width = 75
        Height = 25
        Caption = 'Defaults'
        TabOrder = 3
        OnClick = Button1Click
      end
      object LogView: TJvRichEdit
        Left = 16
        Top = 192
        Width = 649
        Height = 281
        ClipboardCommands = [caCopy, caCut, caPaste, caClear]
        Font.Charset = EASTEUROPE_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        PopupMenu = PopupLog
        ReadOnly = True
        TabOrder = 4
      end
      object EditNamePattern: TEdit
        Left = 131
        Top = 60
        Width = 453
        Height = 21
        AutoSize = False
        TabOrder = 5
        Text = 'My Album'
        OnChange = EditNamePatternChange
      end
      object ProgressBar: TProgressBar
        AlignWithMargins = True
        Left = 16
        Top = 478
        Width = 649
        Height = 17
        Margins.Left = 16
        Margins.Top = 4
        Margins.Right = 16
        Margins.Bottom = 4
        Align = alBottom
        Smooth = True
        TabOrder = 6
        Visible = False
      end
      object ComboDefaultMasterSource: TComboBox
        Left = 131
        Top = 132
        Width = 206
        Height = 23
        Hint = 
          'Select source whose date & time will be used as a base for other' +
          ' sources'
        Style = csDropDownList
        ParentShowHint = False
        ShowHint = True
        TabOrder = 7
        OnChange = ComboDefaultMasterSourceChange
        Items.Strings = (
          'Source 1'
          'Source 2')
      end
    end
    object PageSource: TJvStandardPage
      Left = 0
      Top = 0
      Width = 681
      Height = 499
      Caption = 'Source Page'
      Color = clBtnHighlight
      object Label1: TLabel
        Left = 16
        Top = 79
        Width = 102
        Height = 15
        Caption = 'Folder with photos:'
      end
      object Label3: TLabel
        Left = 16
        Top = 31
        Width = 72
        Height = 15
        Caption = 'Source name:'
      end
      object PathSourceDir: TrkSmartPath
        Left = 131
        Top = 73
        Width = 453
        Height = 25
        BtnGreyGrad1 = 15921906
        BtnGreyGrad2 = 14935011
        BtnNormGrad1 = 16643818
        BtnNormGrad2 = 16046502
        BtnHotGrad1 = 16643818
        BtnHotGrad2 = 16441260
        BtnPenGray = 9408399
        BtnPenNorm = 11632444
        BtnPenShade1 = 9598820
        BtnPenShade2 = 15388572
        BtnPenArrow = clBlack
        ColorEnter = clWindow
        ColorExit = clWindow
        ComputerAsDefault = True
        DirMustExist = False
        EmptyPathIcon = 12
        EmptyPathText = 'Computer'
        NewFolderName = 'NewFolder'
        ParentColor = False
        ParentBackground = False
        Path = 'd:\projects\raging\p35\'
        ShowNewFolder = False
        SpecialFolders = [spDesktop, spDocuments, spPictures]
        TabOrder = 0
        OnPathChanged = PathSourceDirPathChanged
      end
      object BtnBrowseSourceDir: TButton
        Left = 590
        Top = 73
        Width = 75
        Height = 25
        Caption = 'Browse...'
        TabOrder = 1
        OnClick = BtnBrowseSourceDirClick
      end
      object EditSourceName: TEdit
        Left = 131
        Top = 28
        Width = 453
        Height = 21
        AutoSize = False
        TabOrder = 2
        Text = 'Source Name'
        OnChange = EditSourceNameChange
      end
      object PanelSrcSync: TPanel
        Left = 3
        Top = 120
        Width = 675
        Height = 251
        BevelEdges = [beTop]
        BevelKind = bkFlat
        BevelOuter = bvNone
        Caption = 'PanelSrcSync'
        ShowCaption = False
        TabOrder = 3
        object RadioSyncRef: TRadioButton
          Left = 13
          Top = 55
          Width = 177
          Height = 26
          Caption = 'Sync using reference photo'
          TabOrder = 0
          WordWrap = True
          OnClick = RadioSyncRefClick
        end
        object RadioSyncShift: TRadioButton
          Left = 13
          Top = 168
          Width = 177
          Height = 20
          Caption = 'Sync using custom time shift'
          TabOrder = 1
          WordWrap = True
          OnClick = RadioSyncShiftClick
        end
        object PanelSyncShift: TPanel
          Left = 244
          Top = 164
          Width = 254
          Height = 41
          BevelOuter = bvNone
          Caption = 'PanelSyncShift'
          ShowCaption = False
          TabOrder = 2
          object Label2: TLabel
            Left = 0
            Top = 6
            Width = 98
            Height = 15
            AutoSize = False
            Caption = 'Shift in seconds:'
          end
          object EditSrcSyncShift: TJvSpinEdit
            Left = 104
            Top = 2
            Width = 121
            Height = 23
            ArrowKeys = False
            Thousands = True
            Value = 4587.000000000000000000
            TabOrder = 0
            OnChange = EditSrcSyncShiftChange
          end
        end
        object RadioNoSync: TRadioButton
          Left = 13
          Top = 12
          Width = 537
          Height = 26
          Caption = 
            'No synchronization for this source, just use existing date && ti' +
            'me'
          TabOrder = 3
          WordWrap = True
          OnClick = RadioNoSyncClick
        end
        inline CustomRefMasterFrame: TCustomSourceSelectionFrame
          Left = 17
          Top = 90
          Width = 452
          Height = 31
          TabOrder = 4
          inherited ComboRefSource: TComboBox
            Height = 23
          end
        end
        inline CustomShiftMasterFrame: TCustomSourceSelectionFrame
          Left = 17
          Top = 200
          Width = 452
          Height = 31
          TabOrder = 5
          inherited ComboRefSource: TComboBox
            Height = 23
          end
        end
        inline RefPhotoSourceFrame: TRefSourceSelectionFrame
          Left = 243
          Top = 50
          Width = 428
          Height = 38
          Color = clWindow
          ParentBackground = False
          ParentColor = False
          TabOrder = 6
        end
        inline RefPhotoMasterFrame: TRefSourceSelectionFrame
          Left = 244
          Top = 120
          Width = 428
          Height = 38
          Color = clWindow
          ParentBackground = False
          ParentColor = False
          TabOrder = 7
          inherited Label5: TLabel
            Caption = 'Master ref. photo:'
          end
        end
      end
    end
  end
  object Actions: TActionList
    Images = MainDataModule.Images
    Left = 138
    Top = 478
    object ActLogCopy: TAction
      Category = 'Log'
      Caption = 'Copy to Clipboard'
      OnExecute = ActLogCopyExecute
    end
    object ActAddSource: TAction
      Category = 'Misc'
      Caption = 'Add Source'
      ImageIndex = 3
      OnExecute = ActAddSourceExecute
    end
    object ActToolsLoadSettings: TAction
      Category = 'Tools'
      Caption = 'Load Settings'
      OnExecute = ActToolsLoadSettingsExecute
    end
    object ActToolsSaveSettings: TAction
      Category = 'Tools'
      Caption = 'Save Settings'
      OnExecute = ActToolsSaveSettingsExecute
    end
    object ActToolsClearOutDir: TAction
      Category = 'Tools'
      Caption = 'Clear Output Folder'
      OnExecute = ActToolsClearOutDirExecute
    end
    object ActLogClear: TAction
      Category = 'Log'
      Caption = 'Clear'
      OnExecute = ActLogClearExecute
    end
    object ActToolsSetDateTime: TAction
      Category = 'Tools'
      Caption = 'Set Photo Date && Time'
      OnExecute = ActToolsSetDateTimeExecute
    end
    object ActToolsFileFromMeta: TAction
      Category = 'Tools'
      Caption = 'Set File Date && Time from EXIF'
      OnExecute = ActToolsFileFromMetaExecute
    end
    object ActToolsAutoOrient: TAction
      Category = 'Tools'
      Caption = 'Auto Orient According to EXIF'
      OnExecute = ActToolsAutoOrientExecute
    end
  end
  object IniFile: TJvAppIniFileStorage
    StorageOptions.BooleanStringTrueValues = 'true, YES, Y'
    StorageOptions.BooleanStringFalseValues = 'false, NO, N'
    StorageOptions.SetAsString = True
    StorageOptions.FloatAsString = True
    FileName = 'PhotoMixer.ini'
    FlushOnDestroy = False
    Location = flCustom
    SubStorages = <>
    OnGetFileName = IniFileGetFileName
    Left = 250
    Top = 488
  end
  object FormStorage: TJvFormStorage
    AppStorage = IniFile
    AppStoragePath = 'Forms.%FORM_NAME%\'
    Options = [fpLocation]
    StoredValues = <>
    Left = 340
    Top = 488
  end
  object PopupTools: TPopupMenu
    Left = 20
    Top = 474
    object dfsadsad1: TMenuItem
      Action = ActToolsLoadSettings
    end
    object asdsad1: TMenuItem
      Action = ActToolsSaveSettings
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object ClearOutputFolder1: TMenuItem
      Action = ActToolsClearOutDir
    end
    object SetPhotoDateTime1: TMenuItem
      Action = ActToolsSetDateTime
    end
    object SetFileDateFromPhotoMetadata1: TMenuItem
      Action = ActToolsFileFromMeta
    end
    object AutoOrientAccordingtoMetadata1: TMenuItem
      Action = ActToolsAutoOrient
    end
  end
  object PopupLog: TPopupMenu
    Left = 84
    Top = 474
    object MenuItem1: TMenuItem
      Action = ActLogCopy
    end
    object MenuItem2: TMenuItem
      Action = ActLogClear
    end
  end
  object ControlHint: TJvBalloonHint
    Left = 430
    Top = 486
  end
end
