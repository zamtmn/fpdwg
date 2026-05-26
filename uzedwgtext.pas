{*************************************************************************** }
{  fpdwg - DWG safe text decoder (refactored 5.x R3)                         }
{                                                                            }
{        Copyright (C) 2026 Andrey Zubarev <zamtmn@yandex.ru>                }
{                                                                            }
{  This library is free software, licensed under the terms of the GNU        }
{  General Public License as published by the Free Software Foundation,      }
{  either version 3 of the License, or (at your option) any later version.   }
{*************************************************************************** }

{ Refactor R3 (per TZ_DWG_LOAD_TO_ZCAD_AUDIT §3.3): BITCODE_T2Text and
  DWGSafeDecodeText extracted from dwgproc.pp so the binding unit can shed
  its non-binding helpers. The version-based DWGSafeDecodeText is the
  primary entry point because it is also what TZ_loadDWG.md §support
  expects from the future codepage layer. The TDWGCtx-based BITCODE_T2Text
  variant continues to live in dwgproc.pp as a thin shim that delegates
  here, so existing callers that already hold a TDWGCtx do not have to
  reach into its internals to get a version. }

unit uzedwgtext;

{$IFDEF FPC}
  {$PACKRECORDS C}
  {$Mode objfpc}{$H+}
{$ENDIF}

interface

uses
  SysUtils, dwg;

{ Decode a LibreDWG-allocated BITCODE_T payload into UTF-8 bytes stored in a
  Pascal string. The binding exposes BITCODE_T as a C string pointer, so the
  decoder applies the DWG header codepage or the UTF-16LE path explicitly.
  Tolerates a nil pointer: the caller gets an empty string instead of an AV. }
procedure DWGSafeDecodeText(const p: BITCODE_T; Version: DWG_VERSION_TYPE;
  out text: string); overload;
procedure DWGSafeDecodeText(const p: BITCODE_T; Version: DWG_VERSION_TYPE;
  Codepage: Integer; out text: string); overload;
function DWGDecodedTextForZCAD(const Text: string): string;
function DWGDecodedTextToZCADString(const Text: string): UnicodeString;
function DWGDecodedTextToZCADTemplate(const Text: string): UnicodeString;

implementation

const
  DWG_CP_UTF8 = 0;
  DWG_CP_US_ASCII = 1;
  DWG_CP_ISO_8859_1 = 2;
  DWG_CP_ISO_8859_2 = 3;
  DWG_CP_ISO_8859_3 = 4;
  DWG_CP_ISO_8859_4 = 5;
  DWG_CP_ISO_8859_5 = 6;
  DWG_CP_ISO_8859_6 = 7;
  DWG_CP_ISO_8859_7 = 8;
  DWG_CP_ISO_8859_8 = 9;
  DWG_CP_ISO_8859_9 = 10;
  DWG_CP_CP437 = 11;
  DWG_CP_CP850 = 12;
  DWG_CP_CP852 = 13;
  DWG_CP_CP855 = 14;
  DWG_CP_CP857 = 15;
  DWG_CP_CP860 = 16;
  DWG_CP_CP861 = 17;
  DWG_CP_CP863 = 18;
  DWG_CP_CP864 = 19;
  DWG_CP_CP865 = 20;
  DWG_CP_CP869 = 21;
  DWG_CP_CP932 = 22;
  DWG_CP_MACINTOSH = 23;
  DWG_CP_BIG5 = 24;
  DWG_CP_CP949 = 25;
  DWG_CP_JOHAB = 26;
  DWG_CP_CP866 = 27;
  DWG_CP_ANSI_1250 = 28;
  DWG_CP_ANSI_1251 = 29;
  DWG_CP_ANSI_1252 = 30;
  DWG_CP_GB2312 = 31;
  DWG_CP_ANSI_1253 = 32;
  DWG_CP_ANSI_1254 = 33;
  DWG_CP_ANSI_1255 = 34;
  DWG_CP_ANSI_1256 = 35;
  DWG_CP_ANSI_1257 = 36;
  DWG_CP_ANSI_874 = 37;
  DWG_CP_ANSI_932 = 38;
  DWG_CP_ANSI_936 = 39;
  DWG_CP_ANSI_949 = 40;
  DWG_CP_ANSI_950 = 41;
  DWG_CP_ANSI_1361 = 42;
  DWG_CP_UTF16 = 43;
  DWG_CP_ANSI_1258 = 44;

function DWGLibreCodePageToSystem(Codepage: Integer;
  out SystemCodepage: TSystemCodePage): Boolean;
begin
  Result := True;
  case Codepage of
    65001:
      SystemCodepage := CP_UTF8;
    437, 850, 852, 855, 857, 860, 861, 863, 864, 865, 866, 869,
    874, 932, 936, 949, 950, 1250, 1251, 1252, 1253, 1254, 1255,
    1256, 1257, 1258, 1361, 10000, 28591, 28592, 28593, 28594,
    28595, 28596, 28597, 28598, 28599:
      SystemCodepage := Codepage;
    DWG_CP_UTF8,
    DWG_CP_US_ASCII:
      SystemCodepage := CP_UTF8;
    DWG_CP_ISO_8859_1:
      SystemCodepage := 28591;
    DWG_CP_ISO_8859_2:
      SystemCodepage := 28592;
    DWG_CP_ISO_8859_3:
      SystemCodepage := 28593;
    DWG_CP_ISO_8859_4:
      SystemCodepage := 28594;
    DWG_CP_ISO_8859_5:
      SystemCodepage := 28595;
    DWG_CP_ISO_8859_6:
      SystemCodepage := 28596;
    DWG_CP_ISO_8859_7:
      SystemCodepage := 28597;
    DWG_CP_ISO_8859_8:
      SystemCodepage := 28598;
    DWG_CP_ISO_8859_9:
      SystemCodepage := 28599;
    DWG_CP_CP437:
      SystemCodepage := 437;
    DWG_CP_CP850:
      SystemCodepage := 850;
    DWG_CP_CP852:
      SystemCodepage := 852;
    DWG_CP_CP855:
      SystemCodepage := 855;
    DWG_CP_CP857:
      SystemCodepage := 857;
    DWG_CP_CP860:
      SystemCodepage := 860;
    DWG_CP_CP861:
      SystemCodepage := 861;
    DWG_CP_CP863:
      SystemCodepage := 863;
    DWG_CP_CP864:
      SystemCodepage := 864;
    DWG_CP_CP865:
      SystemCodepage := 865;
    DWG_CP_CP869:
      SystemCodepage := 869;
    DWG_CP_CP932,
    DWG_CP_ANSI_932:
      SystemCodepage := 932;
    DWG_CP_MACINTOSH:
      SystemCodepage := 10000;
    DWG_CP_BIG5,
    DWG_CP_ANSI_950:
      SystemCodepage := 950;
    DWG_CP_CP949,
    DWG_CP_ANSI_949:
      SystemCodepage := 949;
    DWG_CP_JOHAB,
    DWG_CP_ANSI_1361:
      SystemCodepage := 1361;
    DWG_CP_CP866:
      SystemCodepage := 866;
    DWG_CP_ANSI_1250:
      SystemCodepage := 1250;
    DWG_CP_ANSI_1251:
      SystemCodepage := 1251;
    DWG_CP_ANSI_1252:
      SystemCodepage := 1252;
    DWG_CP_GB2312,
    DWG_CP_ANSI_936:
      SystemCodepage := 936;
    DWG_CP_ANSI_1253:
      SystemCodepage := 1253;
    DWG_CP_ANSI_1254:
      SystemCodepage := 1254;
    DWG_CP_ANSI_1255:
      SystemCodepage := 1255;
    DWG_CP_ANSI_1256:
      SystemCodepage := 1256;
    DWG_CP_ANSI_1257:
      SystemCodepage := 1257;
    DWG_CP_ANSI_874:
      SystemCodepage := 874;
    DWG_CP_ANSI_1258:
      SystemCodepage := 1258;
  else
    SystemCodepage := DefaultSystemCodePage;
    Result := False;
  end;
end;

function DWGDecodeAnsiText(const p: BITCODE_T; Codepage: Integer;
  out text: string): Boolean;
var
  Raw: RawByteString;
  SourceCodepage: TSystemCodePage;
begin
  Result := False;
  if not DWGLibreCodePageToSystem(Codepage, SourceCodepage) then
    Exit;
  SetString(Raw, PAnsiChar(p), SizeInt(StrLen(PAnsiChar(p))));
  SetCodePage(Raw, SourceCodepage, False);
  SetCodePage(Raw, CP_UTF8, True);
  text := string(Raw);
  Result := True;
end;

function DWGByteIsPrintableASCII(B: Byte): Boolean;
begin
  Result := (B = 9) or (B = 10) or (B = 13) or ((B >= 32) and (B <= 126));
end;

function DWGCodeUnitLooksLikeUTF16Text(CodeUnit: Word): Boolean;
begin
  Result := ((CodeUnit >= $4E00) and (CodeUnit <= $9FFF)) or
    ((CodeUnit >= $3040) and (CodeUnit <= $30FF)) or
    ((CodeUnit >= $FF00) and (CodeUnit <= $FFEF));
end;

function DWGTextHasAnsiASCIIPrefix(const p: BITCODE_T): Boolean;
const
  MaxProbeBytes = 32;
var
  I, FirstNul: Integer;
begin
  Result := False;
  FirstNul := -1;
  for I := 0 to MaxProbeBytes - 1 do
  begin
    if PAnsiChar(p)[I] = #0 then
    begin
      FirstNul := I;
      Break;
    end;
    if not DWGByteIsPrintableASCII(Ord(PAnsiChar(p)[I])) then
      Exit;
  end;

  if FirstNul <= 1 then
    Exit;

  I := 1;
  while I < FirstNul do
  begin
    if PAnsiChar(p)[I] <> #0 then
    begin
      Result := True;
      Exit;
    end;
    Inc(I, 2);
  end;
end;

function DWGTextLooksLikeUTF16LE(const p: BITCODE_T): Boolean;
const
  MaxProbeChars = 16;
var
  I, Pairs, Score, StrongPairs: Integer;
  Lo, Hi: Byte;
  CodeUnit: Word;
begin
  Result := False;
  if (p = nil) or (PAnsiChar(p)[0] = #0) then
    Exit;
  { LibreDWG exposes BITCODE_T as PAnsiChar even when the payload is UTF-16LE.
    Score UTF-16 code units, but reject ordinary single-byte ASCII first so
    R2007+ codepage strings such as "Hello" do not become CJK-looking pairs. }
  if DWGTextHasAnsiASCIIPrefix(p) then
    Exit;

  Pairs := 0;
  Score := 0;
  StrongPairs := 0;
  for I := 0 to MaxProbeChars - 1 do
  begin
    Lo := Ord(PAnsiChar(p)[I * 2]);
    Hi := Ord(PAnsiChar(p)[I * 2 + 1]);
    if (Lo = 0) and (Hi = 0) then
      Break;

    Inc(Pairs);
    CodeUnit := Word(Lo) or (Word(Hi) shl 8);
    if (Hi = 0) and DWGByteIsPrintableASCII(Lo) then
    begin
      Inc(Score, 4);
      Inc(StrongPairs);
    end
    else if Hi in [$01..$06] then
    begin
      Inc(Score, 3);
      Inc(StrongPairs);
    end
    else if DWGCodeUnitLooksLikeUTF16Text(CodeUnit) then
    begin
      Inc(Score, 3);
      Inc(StrongPairs);
    end
    else if (CodeUnit >= $D800) and (CodeUnit <= $DFFF) then
      Dec(Score, 3)
    else if (CodeUnit >= $E000) and (CodeUnit <= $F8FF) then
      Dec(Score, 3)
    else if CodeUnit < 32 then
      Dec(Score, 2)
    else
      Inc(Score);

    if (Lo = 0) and (Hi <> 0) then
      Dec(Score, 2);
  end;

  Result := (Pairs > 0) and (StrongPairs > 0) and (Score >= 4);
end;

function DWGDecodeUTF16Text(const p: BITCODE_T): string;
begin
  Result := string(UTF8Encode(UnicodeString(PUnicodeChar(p))));
end;

procedure DWGSafeDecodeText(const p: BITCODE_T; Version: DWG_VERSION_TYPE;
  out text: string);
begin
  text := '';
  if p = nil then
    Exit;
  if (Version > R_2004) and DWGTextLooksLikeUTF16LE(p) then
    text := DWGDecodeUTF16Text(p)
  else
    text := pchar(p);
end;

procedure DWGSafeDecodeText(const p: BITCODE_T; Version: DWG_VERSION_TYPE;
  Codepage: Integer; out text: string);
begin
  text := '';
  if p = nil then
    Exit;

  if (Codepage = DWG_CP_UTF16) or
    ((Version > R_2004) and DWGTextLooksLikeUTF16LE(p)) then
  begin
    text := DWGDecodeUTF16Text(p);
    Exit;
  end;

  if DWGDecodeAnsiText(p, Codepage, text) then
    Exit;
  text := pchar(p);
end;

function DWGDecodedTextForZCAD(const Text: string): string;
begin
  { DWGSafeDecodeText already returns the UTF-8 byte string table/block mappers
    expect. Keep this post-decode step explicit so those mappers do not apply
    another locale conversion. }
  Result := Text;
end;

function DWGDecodedTextToZCADString(const Text: string): UnicodeString;
begin
  { TEXT/MTEXT entity fields are TDXFEntsInternalStringType = UnicodeString.
    DWGSafeDecodeText returns UTF-8 bytes, so decode UTF-8 explicitly instead
    of letting a plain UnicodeString cast use the process default code page. }
  Result := UTF8Decode(Text);
end;

function DWGDecodedTextToZCADTemplate(const Text: string): UnicodeString;
var
  I: Integer;
  Decoded: UnicodeString;
begin
  Decoded := DWGDecodedTextToZCADString(Text);
  Result := '';
  for I := 1 to Length(Decoded) do
    if Ord(Decoded[I]) > 127 then
      Result := Result + '\U+' + IntToHex(Ord(Decoded[I]), 4)
    else
      Result := Result + Decoded[I];
end;

end.
