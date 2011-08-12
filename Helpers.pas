unit Helpers;

interface

uses
  Types, Classes, SysUtils, Windows, Controls, Forms, FileCtrl, rkSmartPath, 
  ImagingUtility, JvBalloonHint;

type
  THandle<T> = reference to function: T;  
  TSmartPointer<T: class> = class(TInterfacedObject, THandle<T>)
  private
    FValue: T;
  public
    constructor Create(AValue: T);
    destructor Destroy; override;
    function Invoke: T;
  end;

  TNotifyRef = reference to procedure(Sender: TObject);
  // Hacky stuff to turn anonymous methods into TNotifyEvent
  // http://blog.barrkel.com/2010/01/using-anonymous-methods-in-method.html
  // May not work when anon method captures some local vars
procedure MethRefToMethPtr(const MethRef; var MethPtr);
function MakeNotify(const ANotifyRef: TNotifyRef): TNotifyEvent;
  
function SelectDir(const Caption: string; var Dir: string; AllowCreateDir: Boolean;
  Parent: TWinControl = nil; AdditionalOptions: TSelectDirExtOpts = []): Boolean;
procedure BrowseForDir(const Prompt: string; PathCtrl: TrkSmartPath; AllowCreateDir: Boolean);  
function StrTokens(const S: string; Sep: Char; DoTrim: Boolean = True): TStringDynArray;
function CopyFile(const SourceFileName, DestFileName: string;
  const Overwrite: Boolean): Boolean;
function IsJpeg(const FileName: string): Boolean;  
procedure SetWinControlState(Control: TWinControl; Enabled: Boolean; ControlKeptEnabled: TControl = nil);

type
  TIconKind = TJvIconKind;
  
implementation

constructor TSmartPointer<T>.Create(AValue: T);
begin
  FValue := AValue;
end;

destructor TSmartPointer<T>.Destroy;
begin
  FValue.Free;
end;

function TSmartPointer<T>.Invoke: T;
begin
  Result := FValue;
end;

procedure MethRefToMethPtr(const MethRef; var MethPtr);
type
  TVtable = array[0..3] of Pointer;
  PVtable = ^TVtable;
  PPVtable = ^PVtable;
begin
  // 3 is offset of Invoke, after QI, AddRef, Release
  TMethod(MethPtr).Code := PPVtable(MethRef)^^[3];
  TMethod(MethPtr).Data := Pointer(MethRef);
end;

function MakeNotify(const ANotifyRef: TNotifyRef): TNotifyEvent;
begin
  MethRefToMethPtr(ANotifyRef, Result);
end;

function SelectDir(const Caption: string; var Dir: string; AllowCreateDir: Boolean;
  Parent: TWinControl; AdditionalOptions: TSelectDirExtOpts): Boolean;
var
  Options: TSelectDirExtOpts;
begin
  Options := [sdNewUI, sdShowShares] + AdditionalOptions;
  if AllowCreateDir then
    Options := Options + [sdNewFolder, sdValidateDir];
  Result := FileCtrl.SelectDirectory(Caption, '', Dir, Options, Parent);
end;

procedure BrowseForDir(const Prompt: string; PathCtrl: TrkSmartPath; AllowCreateDir: Boolean);  
var
  Dir: string;
begin
  Dir := PathCtrl.Path;
  if SelectDir(Prompt, Dir, AllowCreateDir) then
    PathCtrl.Path := ExcludeTrailingPathDelimiter(Dir);
end;

function StrTokens(const S: string; Sep: Char; DoTrim: Boolean): TStringDynArray;
var
  Token, Str: string;
begin
  Str := S;
  while Str <> '' do
  begin
    Token := StrToken(Str, Sep);
    if DoTrim then
      Token := Trim(Token);
    SetLength(Result, Length(Result) + 1);  
    Result[Length(Result) - 1] := Token;
  end;
end;

function CopyFile(const SourceFileName, DestFileName: string;
  const Overwrite: Boolean): Boolean;
begin
  Result := Windows.CopyFile(PChar(SourceFileName), PChar(DestFileName), not Overwrite);
end;

function IsJpeg(const FileName: string): Boolean;
var
  Ext: string;
begin
  Ext := LowerCase(GetFileExt(FileName));
  Result := (Ext = 'jpg') or (Ext = 'jpeg');
end;

procedure SetWinControlState(Control: TWinControl; Enabled: Boolean; ControlKeptEnabled: TControl);
var
  I: Integer;
  SubControl: TControl;
begin
  for I := 0 to Control.ControlCount - 1 do
  begin
    SubControl := Control.Controls[I];
    if (SubControl is TWinControl) and (TWinControl(SubControl).ControlCount > 0) then
    begin
      Control.Controls[I].Enabled := Enabled;
      SetWinControlState(TWinControl(Control.Controls[I]), Enabled);
    end
    else
    begin
      if not Enabled and (Control.Controls[I] = ControlKeptEnabled) then
        Continue;            
      Control.Controls[I].Enabled := Enabled;
    end;
  end;
end;

end.
