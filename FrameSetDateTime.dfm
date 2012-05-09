inherited SetDateTimeFrame: TSetDateTimeFrame
  Width = 610
  Height = 155
  Color = clWindow
  Font.Height = -12
  Font.Name = 'Segoe UI'
  ParentBackground = False
  ParentColor = False
  ParentFont = False
  object Label1: TLabel
    Left = 16
    Top = 23
    Width = 93
    Height = 15
    Caption = 'New date && time:'
  end
  object DatePickerNew: TDateTimePicker
    Left = 231
    Top = 20
    Width = 150
    Height = 23
    Date = 40808.948731967590000000
    Time = 40808.948731967590000000
    TabOrder = 0
  end
  object TimePickerNew: TDateTimePicker
    Left = 128
    Top = 20
    Width = 89
    Height = 23
    Date = 40808.948836435190000000
    Time = 40808.948836435190000000
    Kind = dtkTime
    TabOrder = 1
  end
  object TimePickerInc: TDateTimePicker
    Left = 231
    Top = 66
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
    Top = 112
    Width = 441
    Height = 17
    Caption = 'Skip photos with some date && time already present in metadata'
    Checked = True
    State = cbChecked
    TabOrder = 3
  end
  object CheckIncTimes: TCheckBox
    Left = 16
    Top = 70
    Width = 185
    Height = 17
    Caption = 'Time increase for each photo'
    Checked = True
    State = cbChecked
    TabOrder = 4
  end
  object BtnSetNow: TButton
    Left = 398
    Top = 19
    Width = 91
    Height = 25
    Caption = 'Set Current'
    TabOrder = 5
    OnClick = BtnSetNowClick
  end
end
