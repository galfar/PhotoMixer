object AboutForm: TAboutForm
  Left = 0
  Top = 0
  AlphaBlend = True
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'AboutForm'
  ClientHeight = 263
  ClientWidth = 371
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Segoe UI'
  Font.Style = []
  GlassFrame.Enabled = True
  GlassFrame.Left = 10
  GlassFrame.Right = 10
  GlassFrame.Bottom = 10
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 45
    Top = 8
    Width = 306
    Height = 64
    Alignment = taRightJustify
    Caption = 'PhotoMixer'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 4802889
    Font.Height = -53
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object LabVersion: TLabel
    Left = 190
    Top = 80
    Width = 161
    Height = 13
    Alignment = taRightJustify
    AutoSize = False
    Caption = '0.9.1.1112'
  end
  object Label2: TLabel
    Left = 289
    Top = 129
    Width = 62
    Height = 33
    Alignment = taRightJustify
    Caption = 'Beta'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 4802889
    Font.Height = -27
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object LabHomeSite: TJvLabel
    Left = 144
    Top = 228
    Width = 207
    Height = 20
    Cursor = crHandPoint
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'http://galfar.vevb.net/photomixer'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -13
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    Transparent = True
    OnClick = LabHomeSiteClick
    HotTrack = True
    HotTrackFont.Charset = DEFAULT_CHARSET
    HotTrackFont.Color = clHighlight
    HotTrackFont.Height = -13
    HotTrackFont.Name = 'Segoe UI'
    HotTrackFont.Style = [fsUnderline]
  end
  object LabBuildDate: TLabel
    Left = 200
    Top = 96
    Width = 151
    Height = 13
    Alignment = taRightJustify
    AutoSize = False
    Caption = '2011-12-03 00:36'
  end
  object LabCopyright: TLabel
    Left = 160
    Top = 212
    Width = 191
    Height = 13
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Copyright'
  end
end
