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
  SSettingsToolsPath = 'Tools' + PathDelim;
  SSettingsFilter = 'PhotoMixer settings (*.pms)|*.pms';
  SHomeSite = 'http://galfar.vevb.net/photomixer';
  SCopyrightStatement = 'Copyright 2011 Marek Mauder';
  SSelectPhotoFolder = 'Select Photo Folder';
  SSelectOutputPhotoFolder = 'Select Output Photo Folder';
  SSelectSourcePhotoFolder = 'Select Source Photo Folder';
  SSource = 'Source';
  SOutput = 'Output';

  CurrentSettingsVersion = 1;

implementation

end.
