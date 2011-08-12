unit UICustomComponents;

interface

uses
  Types, Messages, Windows, SysUtils, Classes, Graphics, Menus, ImgList, Controls,
  ComCtrls, StdCtrls, CommCtrl, Forms;

type
  { Regular TImageList draws very ugly disabled 32bit images. This
    image list draws nice ones. For this to work correctly
    source images must be 32bit - seeting ColorDepth to cd32Bit is not
    enough (if 24bit image is loaded alpha is then zero and nothing is shown).}
  TSIImageList = class(TImageList)
  protected
    procedure DoDraw(Index: Integer; Canvas: TCanvas; X, Y: Integer;
      Style: Cardinal; Enabled: Boolean = True); override;
  end;

  TGetImageIndex = procedure(Sender: TObject; const ItemIndex: Integer; var ImageIndex: Integer) of object;
  TGetItemHint = procedure(Sender: TObject; const ItemIndex: Integer; var ItemHint: string) of object;

  TImageMargins = class(TMargins)
  protected
    class procedure InitDefaults(Margins: TMargins); override;
  published
    property Left default 2;
    property Top default 1;
    property Right default 2;
    property Bottom default 1;
  end;

  { Adds images for ListBox items. OnGetImageIndex and Images propties must be
    assigned to display the images. Also adds support for hints for
    individual items and selection by right click (for item-based popup menu mainly).}
  TSIImageListBox = class(TListBox)
  private
    FImages: TImageList;
    FOnGetImageIndex: TGetImageIndex;
    FOnGetItemHint: TGetItemHint;
    FImageMargins: TMargins;
    FSelectByRightClick: Boolean;
    FPopupOnItemOnly: Boolean;
    FLastHintIdx: Integer;
    procedure SetImages(const Value: TImageList);
    procedure SetImageMargins(const Value: TMargins);
  protected
    procedure DrawItem(Index: Integer; Rect: TRect;
      State: TOwnerDrawState); override;
    procedure CNDrawItem(var Message: TWMDrawItem); message CN_DRAWITEM; // Don't draw focus rect
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure DoContextPopup(MousePos: TPoint; var Handled: Boolean); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Images: TImageList read FImages write SetImages;
    property OnGetImageIndex: TGetImageIndex read FOnGetImageIndex write FOnGetImageIndex;
    property OnGetItemHint: TGetItemHint read FOnGetItemHint write FOnGetItemHint;
    property ImageMargins: TMargins read FImageMargins write SetImageMargins;
    property SelectByRightClick: Boolean read FSelectByRightClick write FSelectByRightClick;
    property PopupOnItemOnly: Boolean read FPopupOnItemOnly write FPopupOnItemOnly;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('ScanImage', [TSIImageList, TSIImageListBox]);
end;

{ TSIImageList }

procedure TSIImageList.DoDraw(Index: Integer; Canvas: TCanvas; X, Y: Integer;
  Style: Cardinal; Enabled: Boolean);
var
  Options: TImageListDrawParams;

  function GetRGBColor(Value: TColor): Cardinal;
  begin
    Result := ColorToRGB(Value);
    case Result of
      clNone: Result := CLR_NONE;
      clDefault: Result := CLR_DEFAULT;
    end;
  end;

begin
  if Enabled or (ColorDepth <> cd32Bit) then
    inherited
  else if HandleAllocated then
  begin
    FillChar(Options, SizeOf(Options), 0);
    Options.cbSize := SizeOf(Options);
    Options.himl := Self.Handle;
    Options.i := Index;
    Options.hdcDst := Canvas.Handle;
    Options.x := X;
    Options.y := Y;
    Options.cx := 0;
    Options.cy := 0;
    Options.xBitmap := 0;
    Options.yBitmap := 0;
    Options.rgbBk := GetRGBColor(BkColor);
    Options.rgbFg := GetRGBColor(BlendColor);
    Options.fStyle := Style;
    Options.fState := ILS_SATURATE; // Grayscale for 32bit images

    ImageList_DrawIndirect(@Options);
  end;
end;

{ TImageMargins }

class procedure TImageMargins.InitDefaults(Margins: TMargins);
begin
  with Margins do
  begin
    Left := 2;
    Right := 2;
    Top := 1;
    Bottom := 1;
  end;
end;

{ TSIListBox }

constructor TSIImageListBox.Create(AOwner: TComponent);
begin
  inherited;
  Style := lbOwnerDrawFixed;
  ShowHint := True;
  FLastHintIdx := -1;
  FImageMargins := TImageMargins.Create(Self);
  FSelectByRightClick := True;
  FPopupOnItemOnly := True;
end;

destructor TSIImageListBox.Destroy;
begin
  FImageMargins.Free;
  inherited;
end;

procedure TSIImageListBox.SetImageMargins(const Value: TMargins);
begin
  FImageMargins.Assign(Value);
end;

procedure TSIImageListBox.SetImages(const Value: TImageList);
begin
  if FImages <> Value then
  begin
    FImages := Value;
    ItemHeight := FImages.Height + FImageMargins.Top + FImageMargins.Bottom;
    Invalidate;
  end;
end;

procedure TSIImageListBox.CNDrawItem(var Message: TWMDrawItem);
var
  State: TOwnerDrawState;
begin
  with Message.DrawItemStruct^ do
  begin
    State := TOwnerDrawState(LoWord(itemState));
    Canvas.Handle := hDC;
    Canvas.Font := Font;
    Canvas.Brush := Brush;
    if (Integer(itemID) >= 0) and (odSelected in State) then
    begin
      Canvas.Brush.Color := clHighlight;
      Canvas.Font.Color := clHighlightText
    end;
    if Integer(itemID) >= 0 then
      DrawItem(itemID, rcItem, State)
    else
      Canvas.FillRect(rcItem);
    Canvas.Handle := 0;
  end;
end;

procedure TSIImageListBox.DrawItem(Index: Integer; Rect: TRect;
  State: TOwnerDrawState);
var
  Flags: Cardinal;
  Data: string;
  ImageIndex: Integer;
begin
  if Assigned(OnDrawItem) then
    inherited
  else
  begin
    Canvas.FillRect(Rect);
    if Index < Count then
    begin
      Flags := DT_SINGLELINE or DT_VCENTER or DT_NOPREFIX or DT_END_ELLIPSIS;
      Data := '';
      if (Style in [lbVirtual, lbVirtualOwnerDraw]) then
        Data := DoGetData(Index)
      else
        Data := Items[Index];

      if FImages <> nil then
      begin
        ImageIndex := -1;
        if Assigned(FOnGetImageIndex) then
          FOnGetImageIndex(Self, Index, ImageIndex);
        if ImageIndex >= 0 then
          FImages.Draw(Canvas, Rect.Left + FImageMargins.Left, Rect.Top + FImageMargins.Top, ImageIndex);
        Inc(Rect.Left, Images.Width + FImageMargins.Left + FImageMargins.Right);
      end
      else
        Inc(Rect.Left, 2);

      DrawText(Canvas.Handle, Data, Length(Data), Rect, Flags);
    end;
  end;
end;

procedure TSIImageListBox.MouseDown(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
var
  Idx: Integer;
begin
  if SelectByRightClick and (Button = mbRight) then
  begin
    Idx := ItemAtPos(Point(X, Y), True);
    if (Idx >= 0) and ((ItemIndex <> Idx) or (SelCount > 0)) then
    begin
      if MultiSelect then
      begin
        ClearSelection;
        Selected[Idx] := True;
      end
      else
        ItemIndex := Idx;
    end;
  end;
  inherited;
end;

procedure TSIImageListBox.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  Idx: Integer;
  ItemHint: string;
begin
  if ShowHint then
  begin
    Idx := ItemAtPos(Point(X, Y), True);
    if Idx >= 0 then
    begin
      ItemHint := '';
      if Idx <> FLastHintIdx then
        Application.CancelHint;
      if Assigned(FOnGetItemHint) then
        FOnGetItemHint(Self, Idx, ItemHint);
      Self.Hint := ItemHint;
    end
    else
      Application.CancelHint;

    FLastHintIdx := Idx;
  end;
  inherited;
end;

procedure TSIImageListBox.DoContextPopup(MousePos: TPoint;
  var Handled: Boolean);
var
  Idx: Integer;
begin
  if PopupOnItemOnly then
  begin
    Idx := ItemAtPos(MousePos, True);
    if Idx < 0 then
      Handled := True;
  end;
  inherited;
end;

end.
