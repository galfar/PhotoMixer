unit rkVistaPanel;

// VistaPanel by Roy Magne Klever
// © 2011 by Roy Magne Klever. All rights reserved
//
// This file is not distributable without permission by Roy Magne Klever
// WEB: www.rmklever.com
// Mail: roymagne@rmklever.com
//
// version 1.1, June 2011
//
// MPL 1.1 licenced

interface

uses
  Windows, SysUtils, Classes, Controls, ExtCtrls, Graphics, Forms, Messages;

type
  TvgStyle = (vgVista, vgGlass, vgSimple, vgImage, vgAlpha, vgAlphaGradient);

  TFrameOptions = set of (frLeft, frTop, frRight, frBottom);

  TrkVistaPanel = class(TCustomControl)
  private
    FBorderStyle: TBorderStyle;
    FBottomColor: TColor;
    FBottomLine: Boolean;
    FCenter: Boolean;
    FColor1: TColor;
    FColor2: TColor;
    FColor3: TColor;
    FColor4: TColor;
    FColorBorder: TColor;
    FFrames: TFrameOptions;
    FPicture: TPicture;
    FStyle: TvgStyle;
    FOpacity: Byte;
    procedure CMCtl3DChanged(var Message: TMessage); message CM_CTL3DCHANGED;
    procedure CMIsToolControl(var Message: TMessage); message CM_ISTOOLCONTROL;
    procedure SetBorderStyle(Value: TBorderStyle);
    procedure SetColor1(const Value: TColor);
    procedure SetColor2(const Value: TColor);
    procedure SetColor3(const Value: TColor);
    procedure SetColor4(const Value: TColor);
    procedure WMERASEBKGND(var Message: TWMEraseBkgnd); message WM_ERASEBKGND;
    procedure WMWindowPosChanged(var Message: TWMWindowPosChanged); message
      WM_WINDOWPOSCHANGED;
    procedure WMPaint(var Message: TWMPaint); message WM_PAINT;
    procedure SetColorFrame(const Value: TColor);
    procedure SetCenter(const Value: Boolean);
    procedure SetBottomLine(const Value: Boolean);
    procedure SetBottomColor(const Value: TColor);
    procedure SetStyle(const Value: TvgStyle);
    procedure WinGradient(Canvas: TCanvas; AColor1, AColor2: TColor);
    procedure FillGradient(Canvas: TCanvas; AColor1, AColor2: TColor);
    procedure SetPicture(const Value: TPicture);
    procedure MakeBackground(Canvas: TCanvas);
    procedure SetFrames(const Value: TFrameOptions);
    procedure AlphaGradient(ACanvas: TCanvas; AWidth, AHeight: Integer);
    procedure SetOpacity(const Value: Byte);
    procedure Alpha(ACanvas: TCanvas; AWidth, AHeight: Integer);
    { Private declarations }
  protected
    { Protected declarations }
    procedure CreateParams(var Params: TCreateParams); override;
    procedure PaintWindow(DC: HDC); override;
    procedure Resize; override;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure GlassGradient(ACanvas: TCanvas; AWidth, AHeight: Integer; c1, c2,
      c3, c4: TColor; Center: Boolean);
  published
    { Published declarations }
    property Align;
    property Anchors;
    property AutoSize;
    property BevelInner;
    property BevelOuter;
    property BevelKind;
    property BevelWidth;
    property BorderStyle: TBorderStyle read FBorderStyle write SetBorderStyle
      default bsNone;
    property BorderWidth;
    property BottomLine: Boolean read FBottomLine write SetBottomLine default True;
    property Center: Boolean read FCenter write SetCenter default False;
    property BottomColor: TColor read FBottomColor write SetBottomColor default clBtnFace;
    property Color1: TColor read FColor1 write SetColor1 default clBlack;
    property Color2: TColor read FColor2 write SetColor2 default clBlack;
    property Color3: TColor read FColor3 write SetColor3 default clBlack;
    property Color4: TColor read FColor4 write SetColor4 default clBlack;
    property ColorFrame: TColor read FColorBorder write SetColorFrame default $00C8BA90;
    property Enabled;
    property Frames: TFrameOptions read FFrames write SetFrames;
    property Height;
    property Left;
    property Opacity: Byte read FOpacity write SetOpacity;
    property ParentBackground;
    property Picture: TPicture read FPicture write SetPicture;
    property ShowHint;
    property Style: TvgStyle read FStyle write SetStyle;
    property Top;
    property Visible;
    property Width;
    property OnEnter;
    property OnExit;
    property OnResize;
    property OnClick;
    property OnDblClick;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseDown;
    property OnMouseUp;
    property OnMouseMove;
    property OnKeyDown;
    property OnKeyUp;
  end;

procedure Register;

implementation

procedure DrawParentImage(Control: TControl; Dest: TCanvas);
var
  SaveIndex: Integer;
  DC: HDC;
  Position: TPoint;
begin
  with Control do
  begin
    if Parent = nil then
      Exit;
    DC := Dest.Handle;
    SaveIndex := SaveDC(DC);
{$IFDEF DFS_COMPILER_2}
    GetViewportOrgEx(DC, @Position);
{$ELSE}
    GetViewportOrgEx(DC, Position);
{$ENDIF}
    SetViewportOrgEx(DC, Position.X - Left, Position.Y - Top, nil);
    IntersectClipRect(DC, 0, 0, Parent.ClientWidth, Parent.ClientHeight);
    Parent.Perform(WM_ERASEBKGND, DC, 0);
    Parent.Perform(WM_PAINT, DC, 0);
    RestoreDC(DC, SaveIndex);
  end;
end;

procedure TrkVistaPanel.WMERASEBKGND(var Message: TWMEraseBkgnd);
begin
  Message.Result := 1;
end;

procedure TrkVistaPanel.WMPaint(var Message: TWMPaint);
begin
  PaintHandler(Message);
end;

procedure TrkVistaPanel.CMCtl3DChanged(var Message: TMessage);
begin
  if NewStyleControls and (FBorderStyle = bsSingle) then
    RecreateWnd;
  inherited;
end;

procedure TrkVistaPanel.CMIsToolControl(var Message: TMessage);
begin
  Message.Result := 1;
end;

procedure TrkVistaPanel.WMWindowPosChanged(var Message: TWMWindowPosChanged);
begin
  Invalidate;
  inherited;
  if not (csLoading in ComponentState) then
    Resize;
end;

procedure TrkVistaPanel.SetBorderStyle(Value: TBorderStyle);
begin
  if Value <> FBorderStyle then
  begin
    FBorderStyle := Value;
    RecreateWnd;
  end;
end;

procedure TrkVistaPanel.SetBottomColor(const Value: TColor);
begin
  FBottomColor := Value;
  Invalidate;
end;

procedure TrkVistaPanel.SetBottomLine(const Value: Boolean);
begin
  FBottomLine := Value;
  Invalidate;
end;

procedure TrkVistaPanel.SetCenter(const Value: Boolean);
begin
  FCenter := Value;
  Invalidate;
end;

procedure TrkVistaPanel.SetColor1(const Value: TColor);
begin
  FColor1 := Value;
  Invalidate;
end;

procedure TrkVistaPanel.SetColor2(const Value: TColor);
begin
  FColor2 := Value;
  Invalidate;
end;

procedure TrkVistaPanel.SetColor3(const Value: TColor);
begin
  FColor3 := Value;
  Invalidate;
end;

procedure TrkVistaPanel.SetColor4(const Value: TColor);
begin
  FColor4 := Value;
  Invalidate;
end;

procedure TrkVistaPanel.SetColorFrame(const Value: TColor);
begin
  FColorBorder := Value;
  Invalidate;
end;

procedure TrkVistaPanel.SetFrames(const Value: TFrameOptions);
begin
  FFrames := Value;
  Invalidate;
end;

procedure TrkVistaPanel.SetOpacity(const Value: Byte);
begin
  FOpacity := Value;
  Invalidate;
end;

procedure TrkVistaPanel.SetPicture(const Value: TPicture);
begin
  FPicture.Assign(Value);
  if FStyle = vgImage then
    Invalidate;
end;

procedure TrkVistaPanel.SetStyle(const Value: TvgStyle);
begin
  FStyle := Value;
  Invalidate;
end;

procedure TrkVistaPanel.WinGradient(Canvas: TCanvas; AColor1, AColor2: TColor);
var
  Vertexs: array[0..1] of TTriVertex;
  GRect: TGradientRect;
begin
  Vertexs[0].X := ClientRect.Left;
  Vertexs[0].Y := ClientRect.Top;
  Vertexs[0].Red := (AColor1 and $000000FF) shl 8;
  Vertexs[0].Green := (AColor1 and $0000FF00);
  Vertexs[0].Blue := (AColor1 and $00FF0000) shr 8;
  Vertexs[0].Alpha := 0;
  Vertexs[1].X := ClientRect.Right;
  Vertexs[1].Y := ClientRect.Bottom;
  Vertexs[1].Red := (AColor2 and $000000FF) shl 8;
  Vertexs[1].Green := (AColor2 and $0000FF00);
  Vertexs[1].Blue := (AColor2 and $00FF0000) shr 8;
  Vertexs[1].Alpha := 0;
  GRect.UpperLeft := 0;
  GRect.LowerRight := 1;
  GradientFill(Canvas.Handle, @Vertexs, 2, @GRect, 1, GRADIENT_FILL_RECT_V);
end;

procedure TrkVistaPanel.FillGradient(Canvas: TCanvas; AColor1, AColor2: TColor);
type
  PRGBTripleArray = ^TRGBTripleArray;
  TRGBTripleArray = array[0..1024] of TRGBTriple;
var
  rc1, gc1, bc1, rc2, gc2, bc2, rc3, gc3, bc3, y1, i, GSize: Integer;
  Row: PRGBTripleArray;
  GradCol: TRGBTriple;
  GradientBmp: TBitmap;
begin
  rc1 := GetRValue(ColorToRGB(AColor1));
  gc1 := GetGValue(ColorToRGB(AColor1));
  bc1 := GetBValue(ColorToRGB(AColor1));
  rc2 := GetRValue(ColorToRGB(AColor2));
  gc2 := GetGValue(ColorToRGB(AColor2));
  bc2 := GetBValue(ColorToRGB(AColor2));
  rc3 := rc1 + (((rc2 - rc1) * 15) div 9);
  gc3 := gc1 + (((gc2 - gc1) * 15) div 9);
  bc3 := bc1 + (((bc2 - bc1) * 15) div 9);
  if rc3 < 0 then
    rc3 := 0
  else if rc3 > 255 then
    rc3 := 255;
  if gc3 < 0 then
    gc3 := 0
  else if gc3 > 255 then
    gc3 := 255;
  if bc3 < 0 then
    bc3 := 0
  else if bc3 > 255 then
    bc3 := 255;
  GradientBMP := TBitmap.Create;
  GradientBmp.PixelFormat := pf24bit;
  GradientBmp.Width := 1;
  GradientBmp.Height := ClientHeight - 1;
  GSize := GradientBmp.Height;
  y1 := GSize div 2;
  for i := 0 to y1 - 1 do
  begin
    Row := PRGBTripleArray(GradientBmp.ScanLine[i]);
    GradCol.rgbtRed := Byte(rc1 + ((rc2 - rc1) * i) div y1);
    GradCol.rgbtGreen := Byte(gc1 + ((gc2 - gc1) * i) div y1);
    GradCol.rgbtBlue := Byte(bc1 + ((bc2 - bc1) * i) div y1);
    Row[0] := GradCol;
  end;
  for i := y1 to GSize - 1 do
  begin
    Row := PRGBTripleArray(GradientBmp.ScanLine[i]);
    GradCol.rgbtRed := Byte(rc3 + ((rc2 - rc3) * i) div GSize);
    GradCol.rgbtGreen := Byte(gc3 + ((gc2 - gc3) * i) div GSize);
    GradCol.rgbtBlue := Byte(bc3 + ((bc2 - bc3) * i) div GSize);
    Row[0] := GradCol;
  end;
  Canvas.StretchDraw(ClientRect, GradientBmp);
  GradientBmp.Free;
end;

procedure TrkVistaPanel.GlassGradient(ACanvas: TCanvas; AWidth, AHeight:
  Integer; c1, c2, c3, c4: TColor; Center: Boolean);
type
  PRGB = ^TRGB;
  TRGB = record b, g, r: Byte;
  end;
  PRGBArray = ^TRGBArray;
  TRGBARRAY = array[0..0] of TRGB;
var
  rc1, gc1, bc1, rc2, gc2, bc2, rc3, gc3, bc3: Integer;
  x, y, w, h: Integer;
  i, w1: Integer;
  Row: PRGBArray;
  C: TRGB;
  bmp: TBitmap;
  slMain, slSize, slPtr: Integer;
  Color: Integer;
  QCol: array of TRGB;
  r, g, b: Byte;
begin
  bmp := TBitmap.Create;
  bmp.PixelFormat := pf24Bit;
  bmp.Width := AWidth;
  bmp.Height := AHeight;
  h := bmp.Height;
  w := bmp.Width;
  SetLength(QCol, h);
  // Get colors for first gradient
  Color := ColorToRGB(c1);
  rc1 := Byte(Color);
  gc1 := Byte(Color shr 8);
  bc1 := Byte(Color shr 16);
  Color := ColorToRGB(c2);
  rc2 := Byte(Color);
  gc2 := Byte(Color shr 8);
  bc2 := Byte(Color shr 16);
  rc3 := rc1 + (((rc2 - rc1) * 7) div 2);
  gc3 := gc1 + (((gc2 - gc1) * 7) div 2);
  bc3 := bc1 + (((bc2 - bc1) * 7) div 2);
  if rc3 < 0 then
    rc3 := 0
  else if rc3 > 255 then
    rc3 := 255;
  if gc3 < 0 then
    gc3 := 0
  else if gc3 > 255 then
    gc3 := 255;
  if bc3 < 0 then
    bc3 := 0
  else if bc3 > 255 then
    bc3 := 255;
  // Calc first gradient
  y := h div 2;
  for i := 0 to y - 1 do
  begin
    C.r := Byte(rc1 + (((rc2 - rc1) * (i)) div y));
    C.g := Byte(gc1 + (((gc2 - gc1) * (i)) div y));
    C.b := Byte(bc1 + (((bc2 - bc1) * (i)) div y));
    QCol[i] := C;
  end;
  if rc2 > rc1 then
  begin
    rc3 := rc2;
    gc3 := gc2;
    bc3 := bc2;
  end;
  for i := y to h - 1 do
  begin
    C.r := Byte(rc3 + (((rc2 - rc3) * (i)) div h));
    C.g := Byte(gc3 + (((gc2 - gc3) * (i)) div h));
    C.b := Byte(bc3 + (((bc2 - bc3) * (i)) div h));
    QCol[i] := C;
  end;
  // First gradient done
  // Get colors for second gradient
  Color := ColorToRGB(c3);
  rc1 := Byte(Color);
  gc1 := Byte(Color shr 8);
  bc1 := Byte(Color shr 16);
  Color := ColorToRGB(c4);
  rc2 := Byte(Color);
  gc2 := Byte(Color shr 8);
  bc2 := Byte(Color shr 16);
  w1 := w - 1;
  if Center then
    w := (w shr 1) + (w and 1);
  // Init scanline accsess
  slMain := Integer(bmp.ScanLine[0]);
  slSize := Integer(bmp.ScanLine[1]) - slMain;
  // Paint gradient
  for x := 0 to w - 1 do
  begin
    C.b := Byte(bc1 + (((bc2 - bc1) * x) div w));
    C.g := Byte(gc1 + (((gc2 - gc1) * x) div w));
    C.r := Byte(rc1 + (((rc2 - rc1) * x) div w));
    slPtr := slMain;
    for y := 0 to h - 1 do
    begin
      Row := PRGBArray(slPtr);
      r := QCol[y].r;
      g := QCol[y].g;
      b := QCol[y].b;
      Row[x].r := (C.r - r) shr 1 + r;
      Row[x].g := (C.g - g) shr 1 + g;
      Row[x].b := (C.b - b) shr 1 + b;
      if (Center) and (x < (w1 - x)) then
      begin
        Row[w1 - x].r := (C.r - r) shr 1 + r;
        Row[w1 - x].g := (C.g - g) shr 1 + g;
        Row[w1 - x].b := (C.b - b) shr 1 + b;
      end;
      slPtr := slPtr + slSize;
    end;
  end;
  QCol := nil;
  if FBottomLine then
  begin
    bmp.Canvas.Pen.Color:= FBottomColor;
    bmp.Canvas.MoveTo(0, AHeight - 2);
    bmp.Canvas.LineTo(AWidth, AHeight - 2);
  end;
  Canvas.Draw(0, 0, bmp);
  bmp.Free;
end;

procedure TrkVistaPanel.AlphaGradient(ACanvas: TCanvas; AWidth, AHeight: Integer);
var
  bmp: TBitmap;
begin
  bmp := TBitmap.Create;
  bmp.PixelFormat := pf24Bit;
  bmp.Width := AWidth;
  bmp.Height := AHeight;
  WinGradient(bmp.Canvas, FColor1, FColor2);
  DrawParentImage(Self, Canvas);
  ACanvas.Draw(0, 0, bmp, FOpacity);
  bmp.Free;
end;

procedure TrkVistaPanel.Alpha(ACanvas: TCanvas; AWidth, AHeight: Integer);
type
  PRGB = ^TRGB;
  TRGB = record b, g, r: Byte;
  end;
  PRGBArray = ^TRGBArray;
  TRGBARRAY = array[0..0] of TRGB;
var
  i, x, y: Integer;
  Row: PRGBArray;
  bmp: TBitmap;
  SCL: Integer;
  SCLStep: Integer;
  r, g, b: Byte;
  LutA: array[0..768] of Byte;
begin
  bmp := TBitmap.Create;
  bmp.PixelFormat := pf24Bit;
  bmp.Width := AWidth;
  bmp.Height := AHeight;
  DrawParentImage(Self, bmp.Canvas);
  r:= Byte(FColor1);
  g:= Byte(FColor1 shr 8);
  b:= Byte(FColor1 shr 16);
  SCL:= Integer(bmp.ScanLine[0]);
  SCLStep:= Integer(bmp.ScanLine[1]) - SCL;
  for i := 0 to 255 do
  begin
    LutA[i] := Byte(Opacity * (r - i) shr 8 + i);
    LutA[i + 256] := Byte(Opacity * (g - i) shr 8 + i);
    LutA[i + 512] := Byte(Opacity * (b - i) shr 8 + i);
  end;
  for y := 0 to bmp.Height - 1 do
  begin
    Row:= PRGBArray(SCL);
    for x := 0 to bmp.Width - 1 do
    begin
      Row[x].R := LutA[Row[x].R];
      Row[x].G := LutA[Row[x].G + 256];
      Row[x].B := LutA[Row[x].B + 512];
    end;
    SCL:= SCL + SCLStep;
  end;
  ACanvas.Draw(0, 0, bmp);
  bmp.Free;
end;

procedure TrkVistaPanel.PaintWindow(DC: HDC);
begin
  Canvas.Lock;
  try
    Canvas.Handle := DC;
    try
      case FStyle of
        vgVista:
          GlassGradient(Canvas, CLientWidth, ClientHeight, FColor1, FColor2,
            FColor3, FColor4, FCenter);
        vgGlass:
          FillGradient(Canvas,FColor1, FColor2);
        vgSimple:
          WinGradient(Canvas, FColor1, FColor2);
        vgImage:
          MakeBackground(Canvas);
        vgAlpha:
          Alpha(Canvas, ClientWidth, ClientHeight);
        vgAlphaGradient:
          AlphaGradient(Canvas, ClientWidth, ClientHeight);
      else
      end;
      Canvas.Pen.Color := FColorBorder;
      if frLeft in FFrames then
      begin
        Canvas.MoveTo(ClientRect.Left, ClientRect.Top);
        Canvas.LineTo(ClientRect.Left, ClientRect.Bottom - 1);
      end;
      if frTop in FFrames then
      begin
        Canvas.MoveTo(ClientRect.Left, ClientRect.Top);
        Canvas.LineTo(ClientRect.Right - 1, ClientRect.Top);
      end;
      if frRight in FFrames then
      begin
        Canvas.MoveTo(ClientRect.Right - 1, ClientRect.Top);
        Canvas.LineTo(ClientRect.Right - 1, ClientRect.Bottom - 1);
      end;
      if frBottom in FFrames then
      begin
        Canvas.MoveTo(ClientRect.Left, ClientRect.Bottom - 1);
        Canvas.LineTo(ClientRect.Right, ClientRect.Bottom -1);
      end;
    finally
      Canvas.Handle := 0;
    end;
  finally
    Canvas.Unlock;
  end;
end;

constructor TrkVistaPanel.Create(AOwner: TComponent);
begin
  inherited;
  ControlStyle := ControlStyle + [csOpaque, csAcceptsControls, csReplicatable,
    csNeedsBorderPaint];
  FBorderStyle := bsNone;
  FBottomLine:= True;
  FBottomColor:= clBtnFace;
  FColor1 := clWhite;
  FColor2 := clSilver;
  FColor3 := clYellow;
  FColor4 := clTeal;
  FColorBorder := clGreen;
  FCenter := False;
  FFrames := [];
  FPicture := TPicture.Create;
  FStyle:= vgVista;
end;

destructor TrkVistaPanel.Destroy;
begin
  FPicture.Free;
  inherited Destroy;
end;

procedure TrkVistaPanel.MakeBackground(Canvas: TCanvas);
var
  iWidth, iHeight, x, y: Integer;
  aRect, bRect: TRect;
begin
  if FPicture.Graphic.Empty then
    Exit;
  iWidth := FPicture.Width;
  iHeight := FPicture.Height;
  bRect.Left := 0;
  bRect.Top := 0;
  bRect.Right := iWidth;
  bRect.Bottom := iHeight;
  aRect.Left := 0;
  aRect.Top := 0;
  aRect.Right := iWidth;
  aRect.Bottom := iHeight;
  for X := 0 to (ClientWidth div iWidth) + 1 do
  begin
    for Y := 0 to (ClientHeight div iHeight) + 1 do
    begin
      Canvas.Draw(aRect.Left, aRect.Top, FPicture.Graphic);
      aRect.Top := aRect.Bottom;
      aRect.Bottom := aRect.Bottom + iHeight;
    end;
    aRect.Left := aRect.Right;
    aRect.Right := aRect.Right + iWidth;
    aRect.Top := 0;
    aRect.Bottom := iHeight;
  end;
end;

procedure TrkVistaPanel.Resize;
begin
  Invalidate;
end;

procedure TrkVistaPanel.CreateParams(var Params: TCreateParams);
const
  BorderStyles: array[TBorderStyle] of DWord = (0, WS_BORDER);
begin
  inherited CreateParams(Params);
  with Params do
  begin
    Style := Style or BorderStyles[FBorderStyle];
    if NewStyleControls and Ctl3D and (FBorderStyle = bsSingle) then
    begin
      Style := Style and not WS_BORDER;
      ExStyle := ExStyle or WS_EX_CLIENTEDGE;
    end;
  end;
end;

procedure Register;
begin
  RegisterComponents('rmKlever', [TrkVistaPanel]);
end;

end.

