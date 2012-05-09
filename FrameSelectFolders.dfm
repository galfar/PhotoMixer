inherited SelectFoldersFrame: TSelectFoldersFrame
  Width = 610
  Height = 148
  Color = clWindow
  Font.Height = -12
  Font.Name = 'Segoe UI'
  ParentBackground = False
  ParentColor = False
  ParentFont = False
  object Label4: TLabel
    Left = 16
    Top = 31
    Width = 69
    Height = 15
    Caption = 'Photo folder:'
  end
  object LabOutFolder: TLabel
    Left = 16
    Top = 111
    Width = 75
    Height = 15
    Caption = 'Output folder:'
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
    EmptyPathIcon = 15
    EmptyPathText = 'Computer'
    NewFolderName = 'New Folder'
    ParentColor = False
    ParentBackground = False
    Path = 'C:\Users\Marek Mauder\Documents\'
    SpecialFolders = [spDesktop, spDocuments, spPictures]
    TabOrder = 0
  end
  object BtnBrowseFolder: TButton
    Left = 510
    Top = 25
    Width = 75
    Height = 25
    Caption = 'Browse...'
    TabOrder = 1
    OnClick = BtnBrowseFolderClick
  end
  object CheckModifyExisting: TCheckBox
    Left = 16
    Top = 72
    Width = 177
    Height = 17
    Caption = 'Modify existing photos'
    TabOrder = 2
  end
  object PathOutFolder: TrkSmartPath
    Left = 128
    Top = 105
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
    EmptyPathIcon = 15
    EmptyPathText = 'Computer'
    NewFolderName = 'New Folder'
    ParentColor = False
    ParentBackground = False
    Path = 'C:\Users\Marek Mauder\Documents\'
    SpecialFolders = [spDesktop, spDocuments, spPictures]
    TabOrder = 3
  end
  object BtnBrowseOutFolder: TButton
    Left = 510
    Top = 105
    Width = 75
    Height = 25
    Caption = 'Browse...'
    TabOrder = 4
    OnClick = BtnBrowseOutFolderClick
  end
end
