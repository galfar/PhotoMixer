object ToolsSetDateTimeForm: TToolsSetDateTimeForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Set Photo Date & Time'
  ClientHeight = 271
  ClientWidth = 600
  Color = clWindow
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 15
  object Label4: TLabel
    Left = 16
    Top = 31
    Width = 69
    Height = 15
    Caption = 'Photo folder:'
  end
  object Label1: TLabel
    Left = 16
    Top = 71
    Width = 93
    Height = 15
    Caption = 'New date && time:'
  end
  object Bevel1: TBevel
    AlignWithMargins = True
    Left = 6
    Top = 215
    Width = 588
    Height = 50
    Margins.Left = 6
    Margins.Top = 6
    Margins.Right = 6
    Margins.Bottom = 6
    Align = alBottom
    Shape = bsTopLine
    Style = bsRaised
    ExplicitLeft = 0
    ExplicitTop = 224
    ExplicitWidth = 50
  end
  object DatePickerNew: TDateTimePicker
    Left = 231
    Top = 68
    Width = 150
    Height = 23
    Date = 40808.948731967590000000
    Time = 40808.948731967590000000
    TabOrder = 0
  end
  object TimePickerNew: TDateTimePicker
    Left = 128
    Top = 68
    Width = 89
    Height = 23
    Date = 40808.948836435190000000
    Time = 40808.948836435190000000
    Kind = dtkTime
    TabOrder = 1
  end
  object TimePickerInc: TDateTimePicker
    Left = 231
    Top = 112
    Width = 89
    Height = 23
    Date = 40808.000694444450000000
    Format = 'HH:mm:ss'
    Time = 40808.000694444450000000
    Kind = dtkTime
    TabOrder = 2
  end
  object CheckSkipWithMeta: TCheckBox
    Left = 16
    Top = 160
    Width = 441
    Height = 17
    Caption = 'Skip photos with some date && time already present in metadata'
    Checked = True
    State = cbChecked
    TabOrder = 3
  end
  object PathPhotos: TrkSmartPath
    Left = 128
    Top = 25
    Width = 372
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
    NewFolderName = 'New Folder'
    ParentColor = False
    ParentBackground = False
    Path = 'd:\projects\raging\p35\'
    SpecialFolders = [spDesktop, spDocuments, spPictures]
    TabOrder = 4
  end
  object BtnBrowseOutputDir: TButton
    Left = 510
    Top = 25
    Width = 75
    Height = 25
    Caption = 'Browse...'
    TabOrder = 5
  end
  object Button1: TButton
    Left = 328
    Top = 236
    Width = 121
    Height = 25
    Caption = 'OK'
    TabOrder = 6
    OnClick = Button1Click
  end
  object CheckIncTimes: TCheckBox
    Left = 16
    Top = 118
    Width = 185
    Height = 17
    Caption = 'Time increase for each photo'
    Checked = True
    State = cbChecked
    TabOrder = 7
  end
  object Button2: TButton
    Left = 463
    Top = 236
    Width = 121
    Height = 25
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 8
  end
end
