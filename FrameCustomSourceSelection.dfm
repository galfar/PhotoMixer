object CustomSourceSelectionFrame: TCustomSourceSelectionFrame
  Left = 0
  Top = 0
  Width = 452
  Height = 31
  TabOrder = 0
  object CheckCustomSource: TCheckBox
    Left = 16
    Top = 3
    Width = 160
    Height = 17
    Caption = 'Custom master source'
    TabOrder = 0
    OnClick = CheckCustomSourceClick
  end
  object ComboRefSource: TComboBox
    Left = 227
    Top = 3
    Width = 206
    Height = 21
    Hint = 
      'Select source whose date & time will be used as a base for other' +
      ' sources'
    Style = csDropDownList
    ParentShowHint = False
    ShowHint = True
    TabOrder = 1
    OnChange = ComboRefSourceChange
    Items.Strings = (
      'Source 1'
      'Source 2')
  end
end
