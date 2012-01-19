unit PM.Consts;

interface

uses
  System.SysUtils;

const
  SAppTitle = 'PhotoMixer';
  STabSettingsName = 'Settings';
  SDefaultFileTypes = 'jpg, jpeg, png';
  SAppDataDir = 'PhotoMixer';
  SSettingsFile = 'Settings.ini';
  SSettingsSourcesPath = 'Sources' + PathDelim;
  SSettingsOptionsPath = 'Options' + PathDelim;
  SSettingsFilter = 'PhotoMixer settings (*.pms)|*.pms';
  SHomeSite = 'http://galfar.vevb.net/photomixer';
  SCopyrightStatement = 'Copyright 2011 Marek Mauder';

  CurrentSettingsVersion = 1;

implementation

end.
