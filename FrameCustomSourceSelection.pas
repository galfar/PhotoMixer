unit FrameCustomSourceSelection;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, FrameBase,
  Helpers, Mixer;

type
  TCustomSourceSelectionFrame = class(TBaseFrame)
    CheckCustomSource: TCheckBox;
    ComboRefSource: TComboBox;
    procedure CheckCustomSourceClick(Sender: TObject);
    procedure ComboRefSourceChange(Sender: TObject);
  private
    FSource: TSource;
    function GetChecked: Boolean;
  public
    procedure DoIdle; override;
    procedure Setup(ASource: TSource);

    property Checked: Boolean read GetChecked;
  end;

implementation

uses
  FormMain, UITools;

{$R *.dfm}

{ TCustomSourceSelectionFrame }

procedure TCustomSourceSelectionFrame.CheckCustomSourceClick(Sender: TObject);
begin
  if not CheckCustomSource.Checked then
    ComboRefSource.ItemIndex := -1;
end;

procedure TCustomSourceSelectionFrame.ComboRefSourceChange(Sender: TObject);
begin
  FSource.MasterSource := ComboRefSource.ItemIndex;
end;

procedure TCustomSourceSelectionFrame.DoIdle;
begin
  ComboRefSource.Visible := GetChecked;
end;

function TCustomSourceSelectionFrame.GetChecked: Boolean;
begin
  Result := CheckCustomSource.Checked;
end;

procedure TCustomSourceSelectionFrame.Setup(ASource: TSource);
begin
  FSource := ASource;
  FillComboWithSources(ComboRefSource, MainForm.Mixer);
  CheckCustomSource.Checked := FSource.MasterSource >= 0;
  ComboRefSource.ItemIndex := FSource.MasterSource;
end;

end.
