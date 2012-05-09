inherited DialogControlsFrame: TDialogControlsFrame
  Width = 610
  Height = 60
  Color = clWindow
  Font.Height = -12
  Font.Name = 'Segoe UI'
  ParentBackground = False
  ParentColor = False
  ParentFont = False
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
      Anchors = [akTop, akRight]
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 1
    end
  end
end
