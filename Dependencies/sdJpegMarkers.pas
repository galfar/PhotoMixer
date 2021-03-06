{ unit sdJpegMarkers

  Author: Nils Haeck M.Sc.
  Copyright (c) 2007 SimDesign B.V.
  contributor: Dec
  More information: www.simdesign.nl or n.haeck@simdesign.nl

  This software may ONLY be used or replicated in accordance with
  the LICENSE found in this source distribution.

  See readme.txt for colorspace and conventional markers

}
unit sdJpegMarkers;

{$i simdesign.inc}

interface

uses
  Classes, Contnrs, SysUtils, sdJpegTypes, sdJpegCoder, sdJpegHuffman, sdDebug;

const

  // Jpeg markers defined in Table B.1
  mkNone  = 0;

  mkSOF0  = $c0; // Baseline DCT + Huffman encoding
  mkSOF1  = $c1; // Extended Sequential DCT + Huffman encoding
  mkSOF2  = $c2; // Progressive DCT + Huffman encoding
  mkSOF3  = $c3; // Lossless (sequential) + Huffman encoding

  mkSOF5  = $c5; // Differential Sequential DCT + Huffman encoding
  mkSOF6  = $c6; // Differential Progressive DCT + Huffman encoding
  mkSOF7  = $c7; // Differential Lossless (sequential) + Huffman encoding

  mkJPG   = $c8; // Reserved for Jpeg extensions
  mkSOF9  = $c9; // Extended Sequential DCT + Arithmetic encoding
  mkSOF10 = $ca; // Progressive DCT + Arithmetic encoding
  mkSOF11 = $cb; // Lossless (sequential) + Arithmetic encoding

  mkSOF13 = $cd; // Differential Sequential DCT + Arithmetic encoding
  mkSOF14 = $ce; // Differential Progressive DCT + Arithmetic encoding
  mkSOF15 = $cf; // Differential Lossless (sequential) + Arithmetic encoding

  mkDHT   = $c4; // Define Huffman Table

  mkDAC   = $cc; // Define Arithmetic Coding

  mkRST0  = $d0; // Restart markers
  mkRST1  = $d1;
  mkRST2  = $d2;
  mkRST3  = $d3;
  mkRST4  = $d4;
  mkRST5  = $d5;
  mkRST6  = $d6;
  mkRST7  = $d7;

  mkSOI   = $d8; // Start of Image
  mkEOI   = $d9; // End of Image
  mkSOS   = $da; // Start of Scan
  mkDQT   = $db; // Define Quantization Table
  mkDNL   = $dc; // Define Number of Lines
  mkDRI   = $dd; // Define Restart Interval
  mkDHP   = $de; // Define Hierarchical Progression
  mkEXP   = $df; // Expand reference components

  // For APPn markers see:
  // http://www.ozhiker.com/electronics/pjmt/jpeg_info/app_segments.html

  mkAPP0  = $e0; // APPn markers - APP0 = JFIF
  mkAPP1  = $e1; //                APP1 = EXIF or XMP
  mkAPP2  = $e2; //                ICC colour profile
  mkAPP3  = $e3;
  mkAPP4  = $e4;
  mkAPP5  = $e5;
  mkAPP6  = $e6;
  mkAPP7  = $e7;
  mkAPP8  = $e8;
  mkAPP9  = $e9;
  mkAPP10 = $ea;
  mkAPP11 = $eb;
  mkAPP12 = $ec;
  mkAPP13 = $ed; //                APP13 = IPTC or Adobe IRB
  mkAPP14 = $ee; //                APP14 = Adobe
  mkAPP15 = $ef;

  mkJPG0  = $f0; // JPGn markers - reserved for JPEG extensions
  mkJPG13 = $fd;
  mkCOM   = $fe; // Comment

  mkTEM   = $01; // Reserved for temporary use

type

  TsdJpegMarker = class(TDebugPersistent)
  private
    FMarkerTag: byte;
    FStream: TMemoryStream;
    FCodingInfo: TsdJpegInfo;
    //FOwner: TDebugComponent;
  protected
    function GetMarkerName: Utf8String; virtual;
    procedure StoreData(S: TStream; Size: integer);
    procedure DebugSample(S: TStream; Size: integer);
  public
    constructor Create(ACodingInfo: TsdJpegInfo; ATag: byte); virtual;
    destructor Destroy; override;
    class function GetByte(S: TStream): byte;
    class function GetWord(S: TStream): word;
    class procedure PutByte(S: TStream; B: byte);
    class procedure PutWord(S: TStream; W: word);
    class function GetSignature: AnsiString; virtual;
    class function GetMarker: Byte; virtual;
    class function IsSegment(AMarker: Byte; AStream: TStream): Boolean; virtual;
    procedure LoadFromStream(S: TStream; Size: integer);
    procedure SaveToStream(S: TStream);
    procedure ReadMarker; virtual;
    procedure WriteMarker; virtual;
    // Any of the mkXXXX constants defined in sdJpegConsts
    property MarkerTag: byte read FMarkerTag;
    // 3letter description of the marker or the hex description
    property MarkerName: Utf8String read GetMarkerName;
    // marker data stored in its stream
    property Stream: TMemoryStream read FStream;
    // Reference to owner TsdJpegFormat, set when adding to the list, and used
    // for DoDebugOut
    property Owner: TDebugComponent read FOwner write FOwner;
  end;

  TsdJpegMarkerSet = set of byte;

  TsdJpegMarkerClass = class of TsdJpegMarker;

  TsdJpegMarkerList = class(TObjectList)
  private
    FOwner: TDebugComponent;// Reference to owner TsdJpegFormat
    function GetItems(Index: integer): TsdJpegMarker;
  public
    constructor Create(AOwner: TDebugComponent);
    function ByTag(AMarkerTag: byte): TsdJpegMarker;
    function ByClass(AClass: TsdJpegMarkerClass): TsdJpegMarker;
    function HasMarker(ASet: TsdJpegMarkerSet): boolean;
    procedure RemoveMarkers(ASet: TsdJpegMarkerSet);
    procedure InsertAfter(ASet: TsdJpegMarkerSet; AMarker: TsdJpegMarker);
    procedure Add(AItem: TObject);
    property Items[Index: integer]: TsdJpegMarker read GetItems; default;
  end;

  TsdAPPnMarker = class(TsdJpegMarker)
  protected
    function GetMarkerName: Utf8String; override;
  public
    procedure ReadMarker; override;
  end;

  TsdDHTMarker = class(TsdJpegMarker)
  private
  protected
    function GetMarkerName: Utf8String; override;
  public
    FMarkerInfo: array of TsdDHTMarkerInfo;
    procedure ReadMarker; override;
    procedure WriteMarker; override;
  end;

  TsdDQTMarker = class(TsdJpegMarker)
  private
  protected
    function GetMarkerName: Utf8String; override;
  public
    FTableIndices: array of byte;
    procedure ReadMarker; override;
    procedure WriteMarker; override;
  end;

  TsdDRIMarker = class(TsdJpegMarker)
  protected
    function GetMarkerName: Utf8String; override;
  public
    procedure ReadMarker; override;
    procedure WriteMarker; override;
  end;

  TsdSOFnMarker = class(TsdJpegMarker)
  protected
    function GetMarkerName: Utf8String; override;
  public
    procedure ReadMarker; override;
    procedure WriteMarker; override;
  end;

  TsdSOSMarkerInfo = record
    ComponentID: byte;
    DCTable: byte;
    ACTable: byte;
  end;

  TsdSOSMarker = class(TsdJpegMarker)
  private
    FSpectralStart,
    FSpectralEnd,
    FApproxHigh,
    FApproxLow: byte;
  protected
    procedure FindScanComponent(AScan: TsdScanComponent; AId: byte);
    function GetMarkerName: Utf8String; override;
  public
    FScanCount: byte;
    FMarkerInfo: array of TsdSOSMarkerInfo;
    procedure ReadMarker; override;
    procedure WriteMarker; override;
  end;

  TsdSOIMarker = class(TsdJpegMarker)
  protected
    function GetMarkerName: Utf8String; override;
  public
    procedure ReadMarker; override;
  end;

  TsdEOIMarker = class(TsdJpegMarker)
  protected
    function GetMarkerName: Utf8String; override;
  public
    procedure ReadMarker; override;
  end;

  TsdRSTMarker = class(TsdJpegMarker)
  protected
    function GetMarkerName: Utf8String; override;
  public
    procedure ReadMarker; override;
  end;

  TsdDNLMarker = class(TsdJpegMarker)
  protected
    function GetMarkerName: Utf8String; override;
  public
    procedure ReadMarker; override;
    procedure WriteMarker; override;
  end;

  TsdCOMMarker = class(TsdAppnMarker)
  private
    function GetComment: AnsiString;
    procedure SetComment(const Value: AnsiString);
  protected
    function GetMarkerName: Utf8String; override;
  public
    procedure ReadMarker; override;
    property Comment: AnsiString read GetComment write SetComment;
  end;

  TsdJFIFUnits = (
    juNoUnits,
    juXandYareDotsPerInch,
    juXandYareDotsPerCm
  );

  // If a JFIF APP0 marker segment is present, the colorspace is known to be either
  // grayscale or YCbCr.
  // JFIF spec:
  // http://www.jpeg.org/public/jfif.pdf
  TsdJFIFMarker = class(TsdAPPnMarker)
  private
    FIsValid: boolean;
    FVersion: word;
    FUnits: TsdJFIFUnits;
    FXDensity, FYDensity: word;
    FXThumbnail, FYThumbnail: byte;
    function GetUnits: TsdJFIFUnits;
    function GetVersion: word;
    function GetXDensity: word;
    function GetXThumbnail: byte;
    function GetYDensity: word;
    function GetYThumbnail: byte;
  protected
    function GetIsValid: boolean;
    procedure SaveData;
    function GetMarkerName: Utf8String; override;
  public
    class function GetSignature: AnsiString; override;
    class function GetMarker: Byte; override;
    constructor Create(AInfo: TsdJpegInfo; ATag: byte); override;
    property IsValid: boolean read GetIsValid;
    property Version: word read GetVersion;
    property Units: TsdJFIFUnits read GetUnits;
    property XDensity: word read GetXDensity;
    property YDensity: word read GetYDensity;
    property XThumbnail: byte read GetXThumbnail;
    property YThumbnail: byte read GetYThumbnail;
  end;

  // Added by Dec
  // AVI1 marker can be found in frames in MotionJpeg avi files
  // In some cases there are no DHT and we must add it manually
  // See TsdJpegFormat.LoadFromStream for details
  TsdAVI1Marker = class(TsdAPPnMarker)
  protected
    function GetMarkerName: Utf8String; override;
  public
    class function GetSignature: AnsiString; override;
    class function GetMarker: Byte; override;
  end;

  // If an APP2  marker segment containing an embedded ICC profile is also present,
  // then the YCbCr is converted to RGB according to the formulas given in the
  // JFIF spec, and the ICC profile is assumed to refer to the resulting RGB space.
  TsdICCProfileMarker = class(TsdAppnMarker)
  private
    FIsValid: boolean;
    FCurrentMarker: byte;
    FMarkerCount: byte;
    function GetCurrentMarker: byte;
    function GetMarkerCount: byte;
    function GetData: pointer;
    function GetDataLength: integer;
    procedure SetDataLength(const Value: integer);
    procedure SetCurrentMarker(const Value: byte);
    procedure SetMarkerCount(const Value: byte);
  protected
    function GetIsValid: boolean;
    function GetMarkerName: Utf8String; override;
  public
    class function GetSignature: AnsiString; override;
    class function GetMarker: Byte; override;
    property IsValid: boolean read GetIsValid;
    property CurrentMarker: byte read GetCurrentMarker write SetCurrentMarker;
    property MarkerCount: byte read GetMarkerCount write SetMarkerCount;
    property Data: pointer read GetData;
    property DataLength: integer read GetDataLength write SetDataLength;
  end;

  TsdEXIFMarker = class(TsdAPPnMarker)
  protected
    function GetMarkerName: Utf8String; override;
  public
    class function GetSignature: AnsiString; override;
    class function GetMarker: Byte; override;
  end;

  TsdG3FAXMarker = class(TsdAPPnMarker)
  protected
    function GetMarkerName: Utf8String; override;
  public
    class function GetSignature: AnsiString; override;
    class function GetMarker: Byte; override;
  end;

  TsdIPTCMarker = class(TsdAPPnMarker)
  protected
    function GetMarkerName: Utf8String; override;
  end;

  // If an Adobe APP14 marker segment is present, the colorspace is determined by
  // consulting the transform  flag. The transform flag takes one of three values:
  //
  // * 2 - The image is encoded as YCCK (implicitly converted from CMYK on encoding).
  // * 1 - The image is encoded as YCbCr (implicitly converted from RGB on encoding).
  // * 0 - Unknown. 3-channel images are assumed to be RGB, 4-channel images are
  //       assumed to be CMYK.
  TsdAdobeApp14Marker = class(TsdAppnMarker)
  private
    FIsValid: boolean;
    FVersion: word;
    FFlags0: word;
    FFlags1: word;
    FTransform: byte;
    function GetTransform: byte;
    procedure SetTransform(const Value: byte);
  protected
    function GetIsValid: boolean;
    procedure SaveData;
    function GetMarkerName: Utf8String; override;
  public
    class function GetSignature: AnsiString; override;
    class function GetMarker: Byte; override;
    constructor Create(AInfo: TsdJpegInfo; ATag: byte); override;
    property IsValid: boolean read GetIsValid;
    property Transform: byte read GetTransform write SetTransform;
  end;

function IntMin(i1, i2: integer): integer;

procedure RegisterJpegMarkerClass(AClass: TsdJpegMarkerClass);
function FindJpegMarkerClassList(AMarker: Byte; AStream: TStream): TsdJpegMarkerClass;

implementation

uses
  sdJpegImage;

var
  glJpegMarkerClassList: TList;

procedure RegisterJpegMarkerClass(AClass: TsdJpegMarkerClass);
var
  i: Integer;
  Res: Boolean;
  M1, M2: Byte;
  S1, S2: AnsiString;
begin
  if glJpegMarkerClassList = nil then
    glJpegMarkerClassList := TList.Create;

  glJpegMarkerClassList.Add(AClass);
  repeat
    Res := False;
    for i := 0 to glJpegMarkerClassList.Count - 2 do
    begin
      S1 := TsdJpegMarkerClass(glJpegMarkerClassList[i]).GetSignature;
      S2 := TsdJpegMarkerClass(glJpegMarkerClassList[i + 1]).GetSignature;
      if S1 > S2 then
      begin
        glJpegMarkerClassList.Move(i, i + 1);
        Res := True;
      end
      else
        if S1 = S2 then
        begin
          M1 := TsdJpegMarkerClass(glJpegMarkerClassList[i]).GetMarker;
          M2 := TsdJpegMarkerClass(glJpegMarkerClassList[i + 1]).GetMarker;
          if M1 > M2 then
          begin
            glJpegMarkerClassList.Move(i, i + 1);
            Res := True;
          end
        end
    end;
  until not Res;
end;

function FindJpegMarkerClassList(AMarker: Byte; AStream: TStream): TsdJpegMarkerClass;
var
  i: Integer;
  SavePos: Int64;
begin
  Result := nil;
  if glJpegMarkerClassList = nil then
    Exit;
  SavePos := AStream.Position;
  try
    for i := glJpegMarkerClassList.Count - 1 downto 0 do
      try
        AStream.Position := SavePos;
        if TsdJpegMarkerClass(glJpegMarkerClassList[i]).IsSegment(AMarker, AStream) then
        begin
          Result := TsdJpegMarkerClass(glJpegMarkerClassList[i]);
          Break;
        end;
      except
      end;
  finally
    AStream.Position := SavePos;
  end;
end;

function IntMin(i1, i2: integer): integer;
begin
  if i1 < i2 then
    Result := i1
  else
    Result := i2;
end;

{ TsdJpegMarker }

constructor TsdJpegMarker.Create(ACodingInfo: TsdJpegInfo; ATag: byte);
begin
  inherited Create;
  FCodingInfo := ACodingInfo;
  FMarkerTag := ATag;
  FStream := TMemoryStream.Create;
end;

procedure TsdJpegMarker.DebugSample(S: TStream; Size: integer);
var
  i: integer;
  B: byte;
  Msg: Utf8String;
begin
  Msg := '';
  S.Position := 0;
  for i := 0 to IntMin(Size, 32) - 1 do
  begin
    S.Read(B, 1);
    Msg := Msg + IntToHex(B, 2);
    if i mod 4 = 3 then
      Msg := Msg + '-';
  end;
  S.Position := 0;
  DoDebugOut(Self, wsInfo, Msg + '...');
end;

destructor TsdJpegMarker.Destroy;
begin
  FreeAndNil(FStream);
  inherited;
end;

class function TsdJpegMarker.GetByte(S: TStream): byte;
begin
  S.Read(Result, 1);
end;

function TsdJpegMarker.GetMarkerName: Utf8String;
begin
  Result := IntToHex(FMarkerTag, 2);
end;

class function TsdJpegMarker.GetWord(S: TStream): word;
var
  W: word;
begin
  S.Read(W, 2);
  Result := Swap(W);
end;

procedure TsdJpegMarker.LoadFromStream(S: TStream; Size: integer);
begin
  DoDebugOut(Self, wsInfo, Format('<loading marker %s, length:%d>', [MarkerName, Size]));
  // by default, we copy the marker data to the marker stream,
  // overriding methods may use other means
  StoreData(S, Size);
  // Read the marker (default does nothing but is overridden in descendants)
  ReadMarker;
end;

class procedure TsdJpegMarker.PutByte(S: TStream; B: byte);
begin
  S.Write(B, 1);
end;

class procedure TsdJpegMarker.PutWord(S: TStream; W: word);
begin
  W := Swap(W);
  S.Write(W, 2);
end;

procedure TsdJpegMarker.ReadMarker;
begin
// default does nothing
end;

procedure TsdJpegMarker.SaveToStream(S: TStream);
begin
  // the default SaveToStream method. If the marker was modified, the FStream was already
  // updated with .WriteMarker
  if FStream.Size > 0 then
  begin
    DoDebugOut(Self, wsInfo, Format('saving marker %s, length:%d', [MarkerName, FStream.Size]));
    FStream.Position := 0;
    S.CopyFrom(FStream, FStream.Size);
  end;
end;

procedure TsdJpegMarker.StoreData(S: TStream; Size: integer);
begin
  // We store the data for later use
  FStream.Clear;
  FStream.CopyFrom(S, Size);
  FStream.Position := 0;
end;

procedure TsdJpegMarker.WriteMarker;
begin
// default does nothing
end;

// Added by Dec begin
class function TsdJpegMarker.GetSignature: AnsiString;
begin
  Result := '';
end;

class function TsdJpegMarker.GetMarker: Byte;
begin
  Result := 0;
end;

class function TsdJpegMarker.IsSegment(AMarker: Byte; AStream: TStream): Boolean;
var
  S: Word;
  Sign: AnsiString;
begin
  Result := AMarker = GetMarker;
  if not Result then
    Exit;
  Sign := GetSignature;
  if Sign = '' then
    Exit;
  S := GetWord(AStream);
  Result := S >= Length(Sign);
  if not Result then
    Exit;
  AStream.ReadBuffer(Sign[1], Length(Sign));
  Result := Sign = GetSignature;
end;
// Added by Dec end

{ TsdJpegMarkerList }

procedure TsdJpegMarkerList.Add(AItem: TObject);
begin
  inherited Add(AItem);
  if AItem is TsdJpegMarker then
  begin
    TsdJpegMarker(AItem).Owner := FOwner;
  end;
end;

function TsdJpegMarkerList.ByTag(AMarkerTag: byte): TsdJpegMarker;
var
  i: integer;
begin
  for i := 0 to Count - 1 do
    if Items[i].MarkerTag = AMarkerTag then
    begin
      Result := Items[i];
      exit;
    end;
  Result := nil;
end;

function TsdJpegMarkerList.ByClass(AClass: TsdJpegMarkerClass): TsdJpegMarker;
var
  i: integer;
begin
  for i := 0 to Count - 1 do
    if Items[i] is AClass then
    begin
      Result := Items[i];
      exit;
    end;
  Result := nil;
end;

constructor TsdJpegMarkerList.Create(AOwner: TDebugComponent);
begin
  inherited Create(True);
  FOwner := AOwner;
end;

function TsdJpegMarkerList.GetItems(Index: integer): TsdJpegMarker;
begin
  Result := Get(Index);
end;

function TsdJpegMarkerList.HasMarker(ASet: TsdJpegMarkerSet): boolean;
var
  i: integer;
begin
  for i := 0 to Count - 1 do
    if Items[i].MarkerTag in ASet then
    begin
      Result := True;
      exit;
    end;
  Result := False;
end;

procedure TsdJpegMarkerList.InsertAfter(ASet: TsdJpegMarkerSet; AMarker: TsdJpegMarker);
var
  i: integer;
begin
  for i := Count - 1 downto 0 do
    if Items[i].MarkerTag in ASet then
    begin
      Insert(i + 1, AMarker);
      exit;
    end;
  // If none found, just add the marker
  Add(AMarker);
end;

procedure TsdJpegMarkerList.RemoveMarkers(ASet: TsdJpegMarkerSet);
var
  i: integer;
begin
  for i := Count - 1 downto 0 do
    if Items[i].MarkerTag in ASet then
      Delete(i);
end;

{ TsdAPPnMarker }

procedure TsdAPPnMarker.ReadMarker;
begin
  DoDebugOut(Self, wsInfo, Format('<%s marker, length:%d>',
    [MarkerName, FStream.Size]));
  // show first bytes as hex
  DebugSample(FStream, FStream.Size);
end;

function TsdAPPnMarker.GetMarkerName: Utf8String;
begin
  Result := Format('APP%d', [FMarkerTag and $0F]);
end;

{ TsdDHTMarker }

function TsdDHTMarker.GetMarkerName: Utf8String;
begin
  Result := 'DHT';
end;

procedure TsdDHTMarker.ReadMarker;
var
  i, j, Idx, Count, InfoCount: integer;
  Item: PsdDHTMarkerInfo;
  B: byte;
  Table: TsdHuffmanTable;
begin
  // Define Huffman Table
  SetLength(FMarkerInfo, 0);
  InfoCount := 0;
  repeat
    SetLength(FMarkerInfo, InfoCount + 1);
    Item := @FMarkerInfo[InfoCount];
    inc(InfoCount);
    B := GetByte(FStream);
    Item.Tc := B shr 4;
    Item.Th := B and $0F;

    // Number of elements for each bitsize
    FStream.Read(Item.BitLengths[0], 16);

    // Count values
    Count := 0;
    for i := 0 to 15 do
      inc(Count, Item.BitLengths[i]);

    // Set pointer and table info
    Table := nil;
    case Item.Tc of
    0:
      begin
        Table := TsdHuffmanTableList(FCodingInfo.FDCHuffmanTables)[Item.Th];
        DoDebugOut(Self, wsInfo, Format('DC Huffman table=%d, length=%d', [Item.Th, Count]));
      end;
    1:
      begin
        Table := TsdHuffmanTableList(FCodingInfo.FACHuffmanTables)[Item.Th];
        DoDebugOut(Self, wsInfo, Format('AC Huffman table=%d, length=%d', [Item.Th, Count]));
      end;
    else
      DoDebugOut(Self, wsFail, sInvalidTableClass);
    end;

    // Set table length
    if assigned(Table) then
    begin
      Table.Count := Count;
      SetLength(Item.BitValues, Count);

      // Read values
      Idx := 0;
      for i := 0 to 15 do
      begin
        for j := 0 to Item.BitLengths[i] - 1 do
        begin
          Table[Idx].L := i + 1;
          Item.BitValues[Idx] := GetByte(FStream);
          Table[Idx].V := Item.BitValues[Idx];
          inc(Idx);
        end;
      end;
    end;
  until (FStream.Position = FStream.Size) or (Table = nil);
end;

procedure TsdDHTMarker.WriteMarker;
var
  i, Count: integer;
  B: byte;
  Item: PsdDHTMarkerInfo;
  Table: TsdHuffmanTable;
  //local
  procedure SetTableValues;
  var
    i, j, Idx: integer;
  begin
    Idx := 0;
    for i := 0 to 15 do
      for j := 0 to Item.BitLengths[i] - 1 do
      begin
        Table[Idx].L := i + 1;
        Table[Idx].V := Item.BitValues[Idx];
        inc(Idx);
      end;
  end;
//main
begin
  FStream.Clear;
  for i := 0 to length(FMarkerInfo) - 1 do
  begin
    Item := @FMarkerInfo[i];
    B := Item.Tc shl 4 + Item.Th;
    PutByte(FStream, B);
    case Item.Tc of
    0: Table := TsdHuffmanTableList(FCodingInfo.FDCHuffmanTables)[Item.Th];
    1: Table := TsdHuffmanTableList(FCodingInfo.FACHuffmanTables)[Item.Th];
    end;
    Count := length(Item.BitValues);
    // Set table length
    Table.Count := Count;
    SetTableValues;
    // Number of elements for each bitsize
    FStream.Write(Item.BitLengths[0], 16);
    // Write values
    if Count > 0 then
      FStream.Write(Item.BitValues[0], Count);
  end;
end;

{ TsdDQTMarker }

function TsdDQTMarker.GetMarkerName: Utf8String;
begin
  Result := 'DQT';
end;

procedure TsdDQTMarker.ReadMarker;
var
  i, Count: integer;
  B: byte;
  P, T: byte;
  Table: TsdQuantizationTable;
  function TabVal(x: integer): integer;
  begin
    Result := Table.FQuant[cJpegForwardZigZag8x8[i * 8 + x]];
  end;
begin
  // Define Quantization Table
  // Read quantization table(s)
  SetLength(FTableIndices, 0);
  Count := 0;
  repeat
    B := GetByte(FStream);
    P := B shr 4;
    T := B and $0F;
    // Store for later use
    SetLength(FTableIndices, Count + 1);
    FTableIndices[Count] := T;
    inc(Count);
    // Initialize table
    Table := FCodingInfo.FQuantizationTables[T];
    Table.FPrecision := TsdQuantizationPrecision(P);
    case P of
    0:
      for i := 0 to 63 do
        Table.FQuant[i] := GetByte(FStream);
    1:
      for i := 0 to 63 do
        Table.FQuant[i] := GetWord(FStream);
    end;//case
    case Table.FPrecision of
    qp8bit: DoDebugOut(Self, wsInfo, Format('QTable=%d precision=8bit', [T]));
    qp16bit: DoDebugOut(Self, wsInfo, Format('QTable=%d precision=16bit', [T]));
    end;
    for i := 0 to 7 do
      DoDebugOut(Self, wsInfo, Format('%3d %3d %3d %3d %3d %3d %3d %3d',
        [TabVal(0), TabVal(1), TabVal(2), TabVal(3), TabVal(4), TabVal(5), TabVal(6), TabVal(7)]));
  until FStream.Position = FStream.Size;
end;

procedure TsdDQTMarker.WriteMarker;
var
  i, j: integer;
  B: byte;
  Table: TsdQuantizationTable;
begin
  FStream.Clear;
  for i := 0 to length(FTableIndices) - 1 do
  begin
    Table := FCodingInfo.FQuantizationTables[FTableIndices[i]];
    case Table.FPrecision of
    qp8bit:  B := $00;
    qp16bit: B := $10;
    end;
    B := B or FTableIndices[i];
    FStream.Write(B, 1);
    // Write table
    case Table.FPrecision of
    qp8bit:
      for j := 0 to 63 do
        PutByte(FStream, Table.FQuant[j]);
    qp16bit:
      for j := 0 to 63 do
        PutWord(FStream, Table.FQuant[j]);
    end;
  end;
end;

{ TsdDRIMarker }

function TsdDRIMarker.GetMarkerName: Utf8String;
begin
  Result := 'DRI';
end;

procedure TsdDRIMarker.ReadMarker;
begin
  // Define Restart Interval
  // Read restart interval MCU count
  FCodingInfo.FRestartInterval := GetWord(FStream);
  DoDebugOut(Self, wsInfo, Format('Restart interval: %d', [FCodingInfo.FRestartInterval]));
end;

procedure TsdDRIMarker.WriteMarker;
begin
  FStream.Clear;
  PutWord(FStream, FCodingInfo.FRestartInterval);
end;

{ TsdSOFnMarker }

function TsdSOFnMarker.GetMarkerName: Utf8String;
begin
  Result := Format('SOF%s', [IntToHex(MarkerTag and $0F, 1)]);
end;

procedure TsdSOFnMarker.ReadMarker;
var
  i: integer;
  B, Nf: byte;
  Frame: TsdFrameComponent;
begin
  // start of frame x
  inherited;

  // Determine encoding
  case MarkerTag of
  mkSOF0:
    begin
      FCodingInfo.FEncodingMethod := emBaselineDCT;
      DoDebugOut(Self, wsInfo, 'Coding method: Baseline DCT');
    end;
  mkSOF1:
    begin
      FCodingInfo.FEncodingMethod := emExtendedDCT;
      DoDebugOut(Self, wsInfo, 'Coding method: Extended DCT');
    end;
  mkSOF2:
    begin
      FCodingInfo.FEncodingMethod := emProgressiveDCT;
      DoDebugOut(Self, wsInfo, 'Coding method: Progressive DCT');
    end;
  mkSOF3, mkSOF5..mkSOF7, mkSOF9..mkSOF11, mkSOF13..mkSOF15:
    begin
      // We do not yet support anything fancy
      DoDebugOut(Self, wsWarn, Format(sUnsupportedEncoding, [(MarkerTag and $0F)]));
      exit;
    end;
  end;//case

  // Read Frame Header
  FCodingInfo.FSamplePrecision := GetByte(FStream);
  FCodingInfo.FHeight := GetWord(FStream);
  FCodingInfo.FWidth := GetWord(FStream);

  // The weird case of FInfo.Y = 0: we expect a DNL marker somewhere telling
  // us the actual Y dimension. We set WaitForDNL to true.
  if FCodingInfo.FHeight = 0 then
    FCodingInfo.FWaitForDNL := True;

  // Variable Nf: Number of image components in frame
  Nf := GetByte(FStream);
  FCodingInfo.FFrameCount := Nf;
  DoDebugOut(Self, wsInfo, Format('Image %dx%d, %d frames, %dbit samples',
    [FCodingInfo.FWidth, FCodingInfo.FHeight, FCodingInfo.FFrameCount, FCodingInfo.FSamplePrecision]));

  for i := 0 to Nf - 1 do
  begin
    Frame := FCodingInfo.FFrames[i];
    Frame.FComponentID := GetByte(FStream);  // Image component (can be ASCII too!)
    B := GetByte(FStream);
    if Nf = 1 then
    begin
      // Jpeg spec specifies that with just one frame (no interlace), we need to
      // have a 1x1 MCU, so these ones should be 1, even if they read differently.
      Frame.FHorzSampling := 1;
      Frame.FVertSampling := 1;
    end else
    begin
      Frame.FHorzSampling := B shr 4;     // Horizontal blocksize in MCU
      Frame.FVertSampling := B and $0F;   // Vertical blocksize in MCU
    end;
    Frame.FQTable := GetByte(FStream); // Index into quantization table array
    DoDebugOut(Self, wsInfo, Format('Frame %d: %dx%d sampling ID=%s QTable=%d',
      [i, Frame.FHorzSampling, Frame.FVertSampling, IntToHex(Frame.FComponentID, 2), Frame.FQTable]));
  end;
end;

procedure TsdSOFnMarker.WriteMarker;
var
  i: integer;
  B: byte;
  Frame: TsdFrameComponent;
begin
  FStream.Clear;
  // Write Frame Header
  PutByte(FStream, FCodingInfo.FSamplePrecision);
  PutWord(FStream, FCodingInfo.FHeight);
  PutWord(FStream, FCodingInfo.FWidth);
  PutByte(FStream, FCodingInfo.FFrameCount);
  for i := 0 to FCodingInfo.FFrameCount - 1 do
  begin
    Frame := FCodingInfo.FFrames[i];
    PutByte(FStream, Frame.FComponentID);
    B := Frame.FHorzSampling shl 4 + Frame.FVertSampling;
    PutByte(FStream, B);
    PutByte(FStream, Frame.FQTable);
  end;
end;

{ TsdSOSMarker }

procedure TsdSOSMarker.FindScanComponent(AScan: TsdScanComponent; AId: byte);
var
  i: integer;
begin
  // Let's find the index of the component this one belongs to
  AScan.FComponent := -1;
  for i := 0 to FCodingInfo.FFrameCount - 1 do
    if FCodingInfo.FFrames[i].FComponentID = AId then
      AScan.FComponent := i;

  // Make sure we have a frame for this scan
  if AScan.FComponent = -1 then
    DoDebugOut(Self, wsFail, sInvalidFrameRef);
end;

function TsdSOSMarker.GetMarkerName: Utf8String;
begin
  Result := 'SOS';
end;

procedure TsdSOSMarker.ReadMarker;
var
  i: integer;
  B, Cs: byte;
  Scan: TsdScanComponent;
begin
  // Start of Scan
  DoDebugOut(Self, wsInfo, '<SOS marker, coding starts>');

  // Variable Ns, number of image components in scan
  FScanCount := GetByte(FStream);
  FCodingInfo.FScanCount := FScanCount;
  FCodingInfo.FScans.Clear;
  SetLength(FMarkerInfo, FScanCount);
  if FScanCount = 1 then
    DoDebugOut(Self, wsInfo, 'Single Channel')
  else
    DoDebugOut(Self, wsInfo, Format('Interleaved (%d channels)', [FScanCount]));

  // read table specifiers
  for i := 0 to FScanCount - 1 do
  begin
    Scan := FCodingInfo.FScans[i];

    Cs := GetByte(FStream); // Image component reference (can be ASCII too!)
    FMarkerInfo[i].ComponentID := Cs;
    FindScanComponent(Scan, Cs);

    B := GetByte(FStream);
    FMarkerInfo[i].DCTable := B shr 4;   // DC entropy table selector
    FMarkerInfo[i].ACTable := B and $0F; // AC entropy table selector
    Scan.FDCTable := FMarkerInfo[i].DCTable;
    Scan.FACTable := FMarkerInfo[i].ACTable;
    Scan.FPredictor := 0;       // Predictor (used for diff'ing the DC component)
    DoDebugOut(Self, wsInfo, Format('Channel %d DCTable: %d, ACTable: %d', [Scan.FComponent, Scan.FDCTable, Scan.FACTable]))
  end;

  // read Ss, Se, these are used in progressive scans
  FSpectralStart := GetByte(FStream);
  FCodingInfo.FSpectralStart := FSpectralStart;

  FSpectralEnd := GetByte(FStream);
  FCodingInfo.FSpectralEnd := FSpectralEnd;

  // read Ah, Al, these are used in progressive scans
  B := GetByte(FStream);
  FApproxHigh := B shr 4;
  FCodingInfo.FApproxHigh := FApproxHigh;
  FApproxLow := B and $0F;
  FCodingInfo.FApproxLow  := FApproxLow;

  // Following is entropy coded data
  if FCodingInfo.FEncodingMethod = emProgressiveDCT then
    DoDebugOut(Self, wsInfo, Format('Progressive params: Ss=%d, Se=%d, Ah=%d, Al=%d', [FSpectralStart, FSpectralEnd, FApproxHigh, FApproxLow]));
end;

procedure TsdSOSMarker.WriteMarker;
// Write SOS data, and also apply it back to FCodingInfo for use by the decoder.
var
  i: integer;
  B: byte;
  Scan: TsdScanComponent;
begin
  FStream.Clear;
  PutByte(FStream, FScanCount);

  // write table specifiers
  FCodingInfo.FScanCount := FScanCount;
  for i := 0 to FScanCount - 1 do
  begin
    Scan := FCodingInfo.FScans[i];
    PutByte(FStream, FMarkerInfo[i].ComponentID);
    FindScanComponent(Scan, FMarkerInfo[i].ComponentID);
    B := FMarkerInfo[i].DCTable shl 4 + FMarkerInfo[i].ACTable;
    PutByte(FStream, B);
    Scan.FDCTable := FMarkerInfo[i].DCTable;
    Scan.FACTable := FMarkerInfo[i].ACTable;
    Scan.FPredictor := 0;
  end;

  // Write Ss, Se, Ah and Al
  B := FApproxHigh shl 4 + FApproxLow;
  PutByte(FStream, FSpectralStart);
  PutByte(FStream, FSpectralEnd);
  PutByte(FStream, B);
  FCodingInfo.FSpectralStart := FSpectralStart;
  FCodingInfo.FSpectralEnd := FSpectralEnd;
  FCodingInfo.FApproxHigh := FApproxHigh;
  FCodingInfo.FApproxLow  := FApproxLow;
end;

{ TsdSOIMarker }

function TsdSOIMarker.GetMarkerName: Utf8String;
begin
  Result := 'SOI';
end;

procedure TsdSOIMarker.ReadMarker;
begin
  // Start of Image
  DoDebugOut(Self, wsInfo, '<SOI marker>');
end;

{ TsdEOIMarker }

function TsdEOIMarker.GetMarkerName: Utf8String;
begin
  Result := 'EOI';
end;

procedure TsdEOIMarker.ReadMarker;
begin
  // End of Image
  DoDebugOut(Self, wsInfo, '<EOI marker>');
end;

{ TsdRSTMarker }

function TsdRSTMarker.GetMarkerName: Utf8String;
begin
  Result := 'RST';
end;

procedure TsdRSTMarker.ReadMarker;
begin
  DoDebugOut(Self, wsInfo, Format('<RST%s marker>', [IntToHex(MarkerTag and $0F, 1), FStream.Size]));
end;

{ TsdDNLMarker }

function TsdDNLMarker.GetMarkerName: Utf8String;
begin
  Result := 'DNL';
end;

procedure TsdDNLMarker.ReadMarker;
begin
  FCodingInfo.FHeight := GetWord(FStream);
  DoDebugOut(Self, wsInfo, Format('Image height: %d', [FCodingInfo.FHeight]));
end;

procedure TsdDNLMarker.WriteMarker;
begin
  FStream.Clear;
  PutWord(FStream, FCodingInfo.FHeight);
end;

{ TsdCOMMarker }

function TsdCOMMarker.GetComment: AnsiString;
begin
  SetLength(Result, FStream.Size);
  if FStream.Size = 0 then
    exit;
  FStream.Position := 0;
  FStream.Read(Result[1], FStream.Size);
end;

function TsdCOMMarker.GetMarkerName: Utf8String;
begin
  Result := 'COM';
end;

procedure TsdCOMMarker.ReadMarker;
begin
  DoDebugOut(Self, wsInfo, GetComment);
end;

procedure TsdCOMMarker.SetComment(const Value: AnsiString);
var
  Size: integer;
begin
  FStream.Clear;
  Size := length(Value);
  if Size >=0 then
    exit;
  FStream.Write(Value[1], Size);
end;

{ TsdJFIFMarker }

class function TsdJFIFMarker.GetSignature: AnsiString;
begin
  Result := 'JFIF';
end;

class function TsdJFIFMarker.GetMarker: Byte;
begin
  Result := $E0;
end;

constructor TsdJFIFMarker.Create(AInfo: TsdJpegInfo; ATag: byte);
begin
  inherited;
  // Set sensible defaults
  FVersion := 258;
  FUnits := juXandYAreDotsPerInch;
  FXDensity := 600;
  FYDensity := 600;
  // Save data
  SaveData;
end;

function TsdJFIFMarker.GetIsValid: boolean;
var
  Magic: array[0..4] of AnsiChar;
begin
  Result := False;
  if FIsValid then
  begin
    Result := True;
    exit;
  end;
  FStream.Position := 0;
  FStream.Read(Magic, 5);
  FIsValid := (Magic = 'JFIF');
  if not FIsValid then
    exit;
  Result := True;
  FVersion := GetWord(FStream);
  FStream.Read(FUnits, 1);
  FXDensity := GetWord(FStream);
  FYDensity := GetWord(FStream);
  FXThumbnail := GetByte(FStream);
  FYThumbnail := GetByte(FStream);
end;

function TsdJFIFMarker.GetUnits: TsdJFIFUnits;
begin
  GetIsValid;
  Result := FUnits;
end;

function TsdJFIFMarker.GetVersion: word;
begin
  GetIsValid;
  Result := FVersion;
end;

function TsdJFIFMarker.GetXDensity: word;
begin
  GetIsValid;
  Result := FXDensity;
end;

function TsdJFIFMarker.GetXThumbnail: byte;
begin
  GetIsValid;
  Result := FXThumbnail;
end;

function TsdJFIFMarker.GetYDensity: word;
begin
  GetIsValid;
  Result := FYDensity;
end;

function TsdJFIFMarker.GetYThumbnail: byte;
begin
  GetIsValid;
  Result := FYThumbnail;
end;

procedure TsdJFIFMarker.SaveData;
var
  Magic: array[0..4] of AnsiChar;
begin
  Magic := 'JFIF'#0;
  FStream.Clear;
  FStream.Write(Magic, 5);
  PutWord(FStream, FVersion);
  FStream.Write(FUnits, 1);
  PutWord(FStream, FXDensity);
  PutWord(FStream, FYDensity);
  PutByte(FStream, FXThumbnail);
  PutByte(FStream, FYThumbnail);
end;

function TsdJFIFMarker.GetMarkerName: Utf8String;
begin
  Result := 'JFIF';
end;

{ TsdAVI1Marker }

class function TsdAVI1Marker.GetSignature: AnsiString;
begin
  Result := 'AVI1';
end;

class function TsdAVI1Marker.GetMarker: Byte;
begin
  Result := $E0;
end;

function TsdAVI1Marker.GetMarkerName: Utf8String;
begin
  Result := 'AVI1';
end;

{ TsdICCProfileMarker }

class function TsdICCProfileMarker.GetSignature: AnsiString;
begin
  Result := 'ICC_PROFILE'#0;
end;

class function TsdICCProfileMarker.GetMarker: Byte;
begin
  Result := $E2;
end;

function TsdICCProfileMarker.GetCurrentMarker: byte;
begin
  GetIsValid;
  Result := FCurrentMarker;
end;

function TsdICCProfileMarker.GetData: pointer;
var
  PData: PByte;
begin
  GetIsValid;
  if not FIsValid then
    Result := nil
  else
  begin
    PData := FStream.Memory;
    inc(PData, 14);
    Result := PData;
  end;
end;

function TsdICCProfileMarker.GetDataLength: integer;
begin
  GetIsValid;
  if not FIsValid then
    Result := 0
  else
    Result := FStream.Size - 14;
end;

function TsdICCProfileMarker.GetIsValid: boolean;
var
  Magic: array[0..11] of AnsiChar;
begin
  Result := False;
  if FIsValid then
  begin
    Result := True;
    exit;
  end;
  FStream.Position := 0;
  FStream.Read(Magic, 12);
  FIsValid := (Magic = 'ICC_PROFILE');
  if not FIsValid then
    exit;
  Result := True;
  FCurrentMarker := GetByte(FStream);
  FMarkerCount := GetByte(FStream);
  // ICC-Profile data follows
end;

function TsdICCProfileMarker.GetMarkerCount: byte;
begin
  GetIsValid;
  Result := FMarkerCount;
end;

procedure TsdICCProfileMarker.SetCurrentMarker(const Value: byte);
begin
  FStream.Position := 12;
  PutByte(FStream, Value);
  FCurrentMarker := Value;
end;

procedure TsdICCProfileMarker.SetDataLength(const Value: integer);
var
  Magic: AnsiString;
begin
  FStream.Size := Value + 14;
  FStream.Position := 0;
  Magic := 'ICC_PROFILE'#0;
  FStream.Write(Magic[1], 12);
end;

procedure TsdICCProfileMarker.SetMarkerCount(const Value: byte);
begin
  FStream.Position := 13;
  PutByte(FStream, Value);
  FMarkerCount := Value;
end;

function TsdICCProfileMarker.GetMarkerName: Utf8String;
begin
  Result := 'ICCProfile';
end;

{ TsdEXIFMarker }

class function TsdEXIFMarker.GetSignature: AnsiString;
begin
  Result := 'EXIF'#0;
end;

class function TsdEXIFMarker.GetMarker: Byte;
begin
  Result := $E1;
end;

function TsdEXIFMarker.GetMarkerName: Utf8String;
begin
  Result := 'EXIF';
end;

{ TsdG3FAXMarker }

class function TsdG3FAXMarker.GetSignature: AnsiString;
begin
  Result := 'G3FAX';
end;

class function TsdG3FAXMarker.GetMarker: Byte;
begin
  Result := $E1;
end;

function TsdG3FAXMarker.GetMarkerName: Utf8String;
begin
  Result := 'G3FAX';
end;

{ TsdIPTCMarker }

function TsdIPTCMarker.GetMarkerName: Utf8String;
begin
  Result := 'IPTC';
end;

{ TsdAdobeApp14Marker }

class function TsdAdobeApp14Marker.GetSignature: AnsiString;
begin
  Result := 'Adobe';
end;

class function TsdAdobeApp14Marker.GetMarker: Byte;
begin
  Result := $EE;
end;

constructor TsdAdobeApp14Marker.Create(AInfo: TsdJpegInfo; ATag: byte);
begin
  inherited;
  // Defaults
  FVersion := 100;
  SaveData;
end;

function TsdAdobeApp14Marker.GetIsValid;
var
  Magic: array[0..4] of AnsiChar;
begin
  Result := False;
  if FIsValid then
  begin
    Result := True;
    exit;
  end;

  // Check length of Adobe marker
  if FStream.Size <> 12 then
    exit;
  FStream.Position := 0;
  FStream.Read(Magic, 5);
  FIsValid := (Magic = 'Adobe');
  if not FIsValid then
    exit;

  Result := True;
  FVersion := GetWord(FStream);
  FFlags0 := GetWord(FStream);
  FFlags1 := GetWord(FStream);
  FTransform := GetByte(FStream);
end;

function TsdAdobeApp14Marker.GetTransform: byte;
begin
  GetIsValid;
  Result := FTransform;
end;

procedure TsdAdobeApp14Marker.SaveData;
var
  Magic: array[0..4] of AnsiChar;
begin
  Magic := 'Adobe';
  FStream.Clear;
  FStream.Write(Magic, 5);
  PutWord(FStream, FVersion);
  PutWord(FStream, FFlags0);
  PutWord(FStream, FFlags1);
  PutByte(FStream, FTransform);
end;

procedure TsdAdobeApp14Marker.SetTransform(const Value: byte);
begin
  GetIsValid;
  FTransform := Value;
  SaveData;
end;

function TsdAdobeApp14Marker.GetMarkerName: Utf8String;
begin
  Result := 'APP14';
end;

initialization

  RegisterJpegMarkerClass(TsdJFIFMarker);
  RegisterJpegMarkerClass(TsdAVI1Marker);
  RegisterJpegMarkerClass(TsdEXIFMarker);
  RegisterJpegMarkerClass(TsdG3FAXMarker);
  RegisterJpegMarkerClass(TsdICCProfileMarker);
  RegisterJpegMarkerClass(TsdAdobeApp14Marker);

finalization
  if glJpegMarkerClassList <> nil then
    glJpegMarkerClassList.Free;
end.
