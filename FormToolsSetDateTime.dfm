object Form1: TForm1
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Set Photo Date & Time'
  ClientHeight = 269
  ClientWidth = 470
  Color = clWindow
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object DateTimePicker1: TDateTimePicker
    Left = 216
    Top = 96
    Width = 194
    Height = 21
    Date = 40808.948731967590000000
    Time = 40808.948731967590000000
    TabOrder = 0
  end
  object DateTimePicker2: TDateTimePicker
    Left = 112
    Top = 96
    Width = 89
    Height = 21
    Date = 40808.948836435190000000
    Time = 40808.948836435190000000
    Kind = dtkTime
    TabOrder = 1
  end
  object DateTimePicker3: TDateTimePicker
    Left = 216
    Top = 136
    Width = 89
    Height = 21
    Date = 40808.000694444450000000
    Format = 'HH:mm:ss'
    Time = 40808.000694444450000000
    Kind = dtkTime
    TabOrder = 2
  end
end
