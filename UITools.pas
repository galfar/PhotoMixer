unit UITools;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Forms, Vcl.StdCtrls, Helpers, Mixer, Tools;

function SelectPhotoFolders(const Caption: string;
  var InOutSettings: TSettings.TInputOutputDirs): Boolean;

function ShowSetPhotoDateTimeDialog(var InOutSettings: TSettings.TInputOutputDirs;
  var SetDateTime: TSettings.TSetDateTime): Boolean;

procedure FillComboWithSources(Combo: TComboBox; Mixer: TMixer);

implementation

uses
  DataModule, FrameSelectFolders, FrameDialogControls, FrameSetDateTime;

function SelectPhotoFolders(const Caption: string;
  var InOutSettings: TSettings.TInputOutputDirs): Boolean;
var
  Form: TForm;
  FrameSelect: TSelectFoldersFrame;
  FrameControls: TDialogControlsFrame;
  Accepted: Boolean;
begin
  Accepted := False;
  Form := CreateDialogForm(Caption);
  FrameSelect := TSelectFoldersFrame.Create(Form);
  FrameControls := TDialogControlsFrame.Create(Form);

  try
    FrameSelect.PlaceOnForm(Form, 0, 0);
    FrameControls.PlaceOnForm(Form, 0, FrameSelect.Height);

    FrameControls.BtnOk.OnClick := MakeNotify(
      procedure(Sender: TObject)
      begin
        Accepted := True;
        Form.Close;
      end);

    FrameSelect.Setup(InOutSettings);

    Form.ShowModal;

    if Accepted then
      FrameSelect.GetSelection(InOutSettings);
  finally
    Form.Free;
  end;
  Result := Accepted;
end;

function ShowSetPhotoDateTimeDialog(var InOutSettings: TSettings.TInputOutputDirs;
  var SetDateTime: TSettings.TSetDateTime): Boolean;
var
  Form: TForm;
  FrameSelect: TSelectFoldersFrame;
  FrameControls: TDialogControlsFrame;
  FrameSetDateTime: TSetDateTimeFrame;
  Accepted: Boolean;
begin
  Accepted := False;
  Form := CreateDialogForm('Set Photo Date & Time');
  FrameSelect := TSelectFoldersFrame.Create(Form);
  FrameControls := TDialogControlsFrame.Create(Form);
  FrameSetDateTime := TSetDateTimeFrame.Create(Form);

  try
    FrameSelect.PlaceOnForm(Form, 0, 0);
    FrameSetDateTime.PlaceOnForm(Form, 0, FrameSelect.Height);
    FrameControls.PlaceOnForm(Form, 0, FrameSelect.Height + FrameSetDateTime.Height);

    FrameSelect.Setup(InOutSettings);
    FrameSetDateTime.Setup(SetDateTime);

    FrameControls.BtnOk.OnClick := MakeNotify(
      procedure(Sender: TObject)
      begin
        Accepted := True;
        Form.Close;
      end);

    Form.ShowModal;

    if Accepted then
    begin
      FrameSelect.GetSelection(InOutSettings);
      FrameSetDateTime.GetSettings(SetDateTime);
    end;

  finally
    Form.Free;
  end;
  Result := Accepted;
end;

procedure FillComboWithSources(Combo: TComboBox; Mixer: TMixer);
var
  I: Integer;
  Src: TSource;
begin
  Combo.Items.Clear;
  for I := 0 to Mixer.SourceCount - 1 do
  begin
    Src := Mixer.Source[I];
    Combo.AddItem(Src.Name, nil);
  end;
end;

end.
