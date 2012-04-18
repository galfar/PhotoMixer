object DialogControlsFrame: TDialogControlsFrame
  Left = 0
  Top = 0
  Width = 610
  Height = 60
  Color = clWindow
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  ParentBackground = False
  ParentColor = False
  ParentFont = False
  TabOrder = 0
  object Panel1: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 604
    Height = 54
    Align = alClient
    BevelEdges = [beTop]
    BevelKind = bkFlat
    BevelOuter = bvNone
    Caption = 'Panel1'
    ShowCaption = False
    TabOrder = 0
    ExplicitLeft = 0
    ExplicitTop = 0
    ExplicitWidth = 657
    ExplicitHeight = 105
    DesignSize = (
      604
      52)
    object BtnOk: TButton
      Left = 322
      Top = 20
      Width = 121
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'OK'
      TabOrder = 0
    end
    object BtnCancel: TButton
      Left = 463
      Top = 20
      Width = 121
      Height = 25
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 1
    end
  end
end
