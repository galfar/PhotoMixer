unit FrameDialogControls;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls,
  Helpers, FrameBase;

type
  TDialogControlsFrame = class(TBaseFrame)
    BtnOk: TButton;
    BtnCancel: TButton;
    Panel1: TPanel;
  end;

implementation

{$R *.dfm}

end.
