object MainDataModule: TMainDataModule
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 402
  Width = 645
  object OpenPictureDlg: TOpenPictureDialog
    Left = 48
    Top = 32
  end
  object OpenSettingsDialog: TOpenDialog
    Filter = 'All files (*.*)|*.*'
    Left = 232
    Top = 32
  end
  object SaveSettingsDialog: TSaveDialog
    DefaultExt = 'pms'
    Left = 232
    Top = 88
  end
  object AppEvents: TApplicationEvents
    OnIdle = AppEventsIdle
    Left = 112
    Top = 74
  end
end
