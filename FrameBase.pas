unit FrameBase;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Helpers;

type
  { Base frame for dialog frames. Must have a DFM or streaming etc. of descendants
    will get broken (IDE would treat the frame as form in designer).
    http://stackoverflow.com/questions/876081/registering-a-custom-frame
    Also in descendant frames' DFMs change "object" to "inherited" if
    IDE gets confused.}
  TBaseFrame = class abstract(TFrame, IIdleHandler)
  public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;

    procedure DoIdle; virtual;
    procedure PlaceOnForm(Form: TForm; X, Y: Integer); virtual;
  end;

implementation

uses
  DataModule;

{$R *.dfm}

{ TBaseFrame }

procedure TBaseFrame.AfterConstruction;
begin
  inherited;
  MainDataModule.RegisterIdleHandler(Self);
end;

procedure TBaseFrame.BeforeDestruction;
begin
  MainDataModule.UnRegister(Self);
  inherited;
end;

procedure TBaseFrame.DoIdle;
begin

end;

procedure TBaseFrame.PlaceOnForm(Form: TForm; X, Y: Integer);
begin
  Left := X;
  Top := Y;
  Parent := Form;
end;

end.
