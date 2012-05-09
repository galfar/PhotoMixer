object RefSourceSelectionFrame: TRefSourceSelectionFrame
  Left = 0
  Top = 0
  Width = 428
  Height = 38
  Color = clWindow
  ParentBackground = False
  ParentColor = False
  TabOrder = 0
  object Label5: TLabel
    Left = 0
    Top = 10
    Width = 98
    Height = 15
    AutoSize = False
    Caption = 'Reference photo:'
    WordWrap = True
  end
  object EditSrcRefPhoto: TEdit
    Left = 104
    Top = 7
    Width = 202
    Height = 23
    ReadOnly = True
    TabOrder = 0
    Text = 'photo.jpg'
  end
  object BtnViewRefPhoto: TButton
    Left = 312
    Top = 5
    Width = 25
    Height = 25
    ImageIndex = 5
    ImageMargins.Left = 1
    ImageMargins.Top = 1
    Images = MainDataModule.Images
    TabOrder = 1
    OnClick = BtnViewRefPhotoClick
  end
  object BtnBrowseRefPhoto: TButton
    Left = 342
    Top = 5
    Width = 75
    Height = 25
    Caption = 'Browse...'
    TabOrder = 2
    OnClick = BtnBrowseRefPhotoClick
  end
end
