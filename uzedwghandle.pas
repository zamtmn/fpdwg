{*************************************************************************** }
{  fpdwg - DWG handle helpers (Stage 1, refactored 5.x R3)                   }
{                                                                            }
{        Copyright (C) 2026 Andrey Zubarev <zamtmn@yandex.ru>                }
{                                                                            }
{  This library is free software, licensed under the terms of the GNU        }
{  General Public License as published by the Free Software Foundation,      }
{  either version 3 of the License, or (at your option) any later version.   }
{*************************************************************************** }

{ Refactor R3 (per TZ_DWG_LOAD_TO_ZCAD_AUDIT §3.3): handle-extraction
  helpers moved out of dwgproc.pp so the binding unit stays focused on the
  libredwg dynamic load surface. Each helper accepts already-decoded raw
  LibreDWG records so callers can drive them from fake fixtures in
  fpdwg_tests without libredwg.so being present.

  dwgproc.pp re-exports these names through its interface uses clause so
  existing callers (uzefflibredwg2ents.pas, uzedwgtestdwgproc.pas) keep
  compiling unchanged. }

unit uzedwghandle;

{$IFDEF FPC}
  {$PACKRECORDS C}
  {$Mode objfpc}{$H+}
  {$ModeSwitch advancedrecords}
{$ENDIF}

interface

uses
  dwg;

const
  DWG_MAX_REF_HANDLE_CANDIDATES = 3;

type
  { Stage 5 (TZ §12.5): the LibreDWG bindings only expose PDwg_Entity_LINE,
    so we declare the entity pointer aliases the Stage 5 mappers and the
    text-style helpers below need. Kept here (next to the helpers that use
    them) instead of in the binding unit so the binding stays a pure
    libredwg surface. }
  PDwg_Entity_TEXT  = ^Dwg_Entity_TEXT;
  PDwg_Entity_MTEXT = ^Dwg_Entity_MTEXT;
  PDwg_Object_STYLE = ^Dwg_Object_STYLE;
  PDwg_Object_VPORT = ^Dwg_Object_VPORT;

  PPDwg_Object_Ref = ^PDwg_Object_Ref;

  TDWGRefHandleCandidates = record
    Count: Integer;
    Values: array[0..DWG_MAX_REF_HANDLE_CANDIDATES - 1] of QWord;
  end;

  TDWGEntityLineTypeKind = (
    dltMissing,
    dltByLayer,
    dltByBlock,
    dltContinuous,
    dltHandle
  );

  TDWGEntityCommonProps = record
    ColorIndex: Integer;
    LineWeight: Integer;
    LineTypeScale: Double;
    LineTypeFlags: Integer;
    Invisible: Boolean;
  end;

  TDWGLayerVisualProps = record
    ColorIndex: Integer;
    LineWeight: Integer;
    On: Boolean;
    Locked: Boolean;
    Plot: Boolean;
  end;

  TDWGTextStyleProps = record
    Name: string;
    FontFile: string;
    BigFontFile: string;
    TextSize: Double;
    WidthFactor: Double;
    ObliqueAngle: Double;
    IsShape: Boolean;
    IsVertical: Boolean;
  end;

  TDWGLinetypeDashKind = (
    dldDash,
    dldText,
    dldShape
  );

  TDWGLinetypeDashProps = record
    Kind: TDWGLinetypeDashKind;
    Length: Double;
    ShapeCode: Integer;
    StyleHandle: QWord;
    XOffset: Double;
    YOffset: Double;
    Scale: Double;
    Rotation: Double;
    AbsoluteRotation: Boolean;
    Text: string;
  end;

  TDWGLinetypeProps = record
    Name: string;
    Description: string;
    PatternLength: Double;
    Dashes: array of TDWGLinetypeDashProps;
  end;

  TDWGHeaderCurrentEntityProps = record
    ColorIndex: Integer;
    LineWeight: Integer;
    LineTypeScale: Double;
    GlobalLineTypeScale: Double;
    LineWeightDisplay: Boolean;
  end;

  TDWGViewSpace = (
    dvsUnknown,
    dvsModelSpace,
    dvsPaperSpace
  );

  TDWGViewProps = record
    CenterX: Double;
    CenterY: Double;
    Height: Double;
    Width: Double;
    HasWidth: Boolean;
    Space: TDWGViewSpace;
  end;

{ Object handle: the stable QWord identifier the import context indexes by. }
function DWGObjectHandleValue(const Obj: Dwg_Object): QWord;

{ Normalize Dwg_Object.handle.value from LibreDWG's resolved object-ref tables.
  Some decoded files expose only the low bits in the object record while
  absolute_ref keeps the full DXF handle; import phases call this once before
  scanning/dispatch so duplicate detection and mapper logs use the full key. }
procedure DWGNormalizeObjectHandles(var Raw: Dwg_Data);

{ Owner handle on a Dwg_Object. Returns False when the object has no owner
  (typical for top-level objects). The actual lookup goes through
  DWGRefHandleValue so a present-but-zero ownerhandle is treated as missing.

  Issue #1118 / #1120: LibreDWG marks model/paper-space ownership via the
  BITCODE_BB `entmode` field instead of populating `ownerhandle`:
    entmode=0  -> no owner (top-level)
    entmode=1  -> implicit owner is paper-space block (ownerhandle is null)
    entmode=2  -> implicit owner is model-space block (ownerhandle is null)
    entmode=3  -> explicit ownerhandle (read it)
  When entmode is 1 or 2 we resolve the implicit owner from the parent
  Dwg_Data with three fall-through paths (mirroring libredwg's own
  dwg_model_space_object() / dwg_paper_space_object() helpers):
    A. Dwg^.mspace_block / pspace_block (resolved BLOCK_HEADER pointer)
    B. Dwg^.header_vars.BLOCK_RECORD_MSPACE / BLOCK_RECORD_PSPACE
    C. Dwg^.block_control.model_space / paper_space
  Issue #1120 (testdwg2007.dwg) showed that path A alone is not enough:
  some decode paths leave mspace_block nil while the header_vars and/or
  block_control entries do carry a usable handle reference. Without paths
  B/C the entity falls back to ownerhandle (null for entmode=1/2), which
  drops segments to the arNullOwner fallback root and they never render. }
function DWGObjectOwnerHandleValue(const Obj: Dwg_Object;
  out Value: QWord): Boolean;
function DWGObjectOwnerHandleCandidatesValue(const Obj: Dwg_Object;
  out Candidates: TDWGRefHandleCandidates): Boolean;

{ Generic BITCODE_H decoder: returns False when the ref is nil and no usable
  handle can be recovered. Issue #1213 follow-up: priority mirrors
  fpdwginspect's HandleRefFromBitCode — the resolved object's own
  Dwg_Object.handle.value comes first, then Ref^.absolute_ref, then
  Ref^.handleref.value. R2007+ files were observed with absolute_ref
  truncated to 16 bits (OFFSETOBJHANDLE refs) while LibreDWG still carried
  the full 64-bit handle on the resolved object header; preferring
  obj.handle.value avoids the FFFF -> 0 wraparound that previously dropped
  every entity above handle 0xFFFF (handle_hex=A325E in the issue). }
function DWGRefHandleValue(Ref: BITCODE_H; out Value: QWord): Boolean;
function DWGRefHandleCandidatesValue(Ref: BITCODE_H;
  out Candidates: TDWGRefHandleCandidates): Boolean;

{ Stage 3 (TZ §12.3): pull layer / linetype refs off an entity-typed
  Dwg_Object. Returns False when Obj is not an entity, or when the ref is
  missing/null. Object-typed records (LAYER, LTYPE, BLOCK_HEADER) do not
  expose these slots, so callers reading from a non-entity object get False. }
function DWGEntityLayerHandleValue(const Obj: Dwg_Object;
  out Value: QWord): Boolean;
function DWGEntityLayerHandleCandidatesValue(const Obj: Dwg_Object;
  out Candidates: TDWGRefHandleCandidates): Boolean;
function DWGEntityLineTypeHandleValue(const Obj: Dwg_Object;
  out Value: QWord): Boolean;
function DWGEntityLineTypeRefValue(const Obj: Dwg_Object;
  out Kind: TDWGEntityLineTypeKind; out Value: QWord): Boolean;
function DWGEntityLineTypeRefCandidatesValue(const Obj: Dwg_Object;
  out Kind: TDWGEntityLineTypeKind;
  out Candidates: TDWGRefHandleCandidates): Boolean;
function DWGLayerLineTypeHandleValue(const PLayer: PDwg_Object_LAYER;
  out Value: QWord): Boolean;
function DWGLayerLineTypeHandleCandidatesValue(const PLayer: PDwg_Object_LAYER;
  out Candidates: TDWGRefHandleCandidates): Boolean;

function DWGColorIndexToACI(const Color: Dwg_Color; out Value: Integer): Boolean;
function DWGColorMethodToText(const Method: Dwg_Color_Method): string;
function DWGColorLooksLikeLostACI(const Color: Dwg_Color): Boolean;
function DWGColorIsOff(const Color: Dwg_Color): Boolean;
function DWGLineWeightToDXF(const Value: Integer): Integer;
function DWGLayerVisualPropsValue(const PLayer: PDwg_Object_LAYER;
  out Props: TDWGLayerVisualProps): Boolean;
function DWGEntityCommonPropsValue(const Obj: Dwg_Object;
  out Props: TDWGEntityCommonProps): Boolean;
function DWGEntityLineTypeKindToText(const Kind: TDWGEntityLineTypeKind): string;
function DWGHeaderCurrentLayerHandleValue(const Raw: Dwg_Data;
  out Value: QWord): Boolean;
function DWGHeaderCurrentLineTypeHandleValue(const Raw: Dwg_Data;
  out Value: QWord): Boolean;
function DWGHeaderCurrentTextStyleHandleValue(const Raw: Dwg_Data;
  out Value: QWord): Boolean;
function DWGHeaderCurrentDimStyleHandleValue(const Raw: Dwg_Data;
  out Value: QWord): Boolean;
function DWGHeaderCurrentEntityPropsValue(const Raw: Dwg_Data;
  out Props: TDWGHeaderCurrentEntityProps): Boolean;
function DWGHeaderViewPropsValue(const Raw: Dwg_Data;
  out Props: TDWGViewProps): Boolean;
function DWGVPortViewPropsValue(const PVPort: PDwg_Object_VPORT;
  out Props: TDWGViewProps): Boolean;
function DWGViewSpaceToText(const Space: TDWGViewSpace): string;
function DWGTextStylePropsValue(const PStyle: PDwg_Object_STYLE;
  Version: DWG_VERSION_TYPE; out Props: TDWGTextStyleProps): Boolean; overload;
function DWGTextStylePropsValue(const PStyle: PDwg_Object_STYLE;
  Version: DWG_VERSION_TYPE; Codepage: Integer;
  out Props: TDWGTextStyleProps): Boolean; overload;
function DWGLinetypePropsValue(const PLType: PDwg_Object_LTYPE;
  Version: DWG_VERSION_TYPE; out Props: TDWGLinetypeProps): Boolean; overload;
function DWGLinetypePropsValue(const PLType: PDwg_Object_LTYPE;
  Version: DWG_VERSION_TYPE; Codepage: Integer;
  out Props: TDWGLinetypeProps): Boolean; overload;

{ Stage 5 (TZ §12.5): TEXT/MTEXT mappers need the style ref. Returning
  False allows the caller to fall back to the registered text-style
  fallback (typically Standard). }
function DWGTextStyleHandleValue(const PText: PDwg_Entity_TEXT;
  out Value: QWord): Boolean;
function DWGTextStyleHandleCandidatesValue(const PText: PDwg_Entity_TEXT;
  out Candidates: TDWGRefHandleCandidates): Boolean;
function DWGMTextStyleHandleValue(const PMText: PDwg_Entity_MTEXT;
  out Value: QWord): Boolean;
function DWGMTextStyleHandleCandidatesValue(const PMText: PDwg_Entity_MTEXT;
  out Candidates: TDWGRefHandleCandidates): Boolean;

implementation

uses
  uzedwgtext;

const
  DWGByBlockColorIndex = 0;
  DWGByLayerColorIndex = 256;
  DWGDefaultLineTypeScale = 1.0;
  DWGLineWeightByLayer = -1;
  DWGLTypeShapeFlagAbsRotation = 1;
  DWGLTypeShapeFlagIsText = 2;
  DWGLTypeShapeFlagIsShape = 4;
  DWGLineWeights: array[0..31] of Integer = (
    0, 5, 9, 13, 15, 18, 20, 25,
    30, 35, 40, 50, 53, 60, 70, 80,
    90, 100, 106, 120, 140, 158, 200, 211,
    0, 0, 0, 0, 0, -1, -2, -3
  );

function DWGObjectVersionBeforeR2000(const Obj: Dwg_Object): Boolean;
var
  Dwg: ^_dwg_struct;
  Version: DWG_VERSION_TYPE;
begin
  Result := False;
  Dwg := Obj.parent;
  if Dwg = nil then
    Exit;
  Version := Dwg^.header.version;
  if Version = R_INVALID then
    Version := Dwg^.header.from_version;
  Result := (Version >= R_13b1) and (Version < R_2000b);
end;

function DWGObjectHandleValue(const Obj: Dwg_Object): QWord;
begin
  Result := Obj.handle.value;
end;

function DWGRefAbsoluteHandleValue(Ref: BITCODE_H; out Value: QWord): Boolean;
begin
  Value := 0;
  if Ref = nil then
    Exit(False);
  if Ref^.absolute_ref <> 0 then
    Value := Ref^.absolute_ref;
  Result := Value <> 0;
end;

procedure DWGNormalizeObjectHandlesFromRefs(var Raw: Dwg_Data;
  Refs: PPDwg_Object_Ref; Count: BITCODE_BL);
var
  I: BITCODE_BL;
  Ref: PDwg_Object_Ref;
  AbsoluteHandle: QWord;
begin
  if (Count = 0) or (Refs = nil) then
    Exit;
  I := 0;
  while I < Count do
  begin
    Ref := Refs[I];
    // Issue #1213: normalize widen-only. The original code unconditionally
    // overwrote Ref^.obj^.handle.value with absolute_ref. That fixes one
    // class of LibreDWG bug (handle.value left at a low truncated value
    // while absolute_ref carries the full handle, covered by the existing
    // ObjectHandleNormalizeUsesObjectRefAbsoluteRefs test) but introduces
    // the opposite one when absolute_ref itself is the truncated value
    // (R2007+ OFFSETOBJHANDLE refs sometimes carry only the low 16 bits).
    // When that happens the loader saw the wraparound reported in #1213:
    // handle_hex=FFFF at index 11713, then 0, 1, 2, ... — every subsequent
    // object's full handle was overwritten with its absolute_ref mod 2^16,
    // collapsing into the duplicate-handle path and dropping the entity.
    // Only widening the handle preserves the more informative of the two
    // sources without losing the case the original normalization fixed.
    if (Ref <> nil) and (Ref^.obj <> nil) and
       (Ref^.obj^.parent = @Raw) and
       DWGRefAbsoluteHandleValue(Ref, AbsoluteHandle) and
       (AbsoluteHandle > Ref^.obj^.handle.value) then
      Ref^.obj^.handle.value := AbsoluteHandle;
    Inc(I);
  end;
end;

procedure DWGNormalizeObjectHandles(var Raw: Dwg_Data);
begin
  DWGNormalizeObjectHandlesFromRefs(Raw, Raw.object_ref, Raw.num_object_refs);
  DWGNormalizeObjectHandlesFromRefs(Raw, Raw.object_ordered_ref,
    Raw.num_object_ordered_refs);
end;

procedure DWGAddRefHandleCandidate(var Candidates: TDWGRefHandleCandidates;
  Value: QWord);
var
  I: Integer;
begin
  if Value = 0 then
    Exit;
  for I := 0 to Candidates.Count - 1 do
    if Candidates.Values[I] = Value then
      Exit;
  if Candidates.Count > High(Candidates.Values) then
    Exit;
  Candidates.Values[Candidates.Count] := Value;
  Inc(Candidates.Count);
end;

procedure DWGAppendRefHandleCandidates(var Dest: TDWGRefHandleCandidates;
  const Source: TDWGRefHandleCandidates);
var
  I: Integer;
begin
  for I := 0 to Source.Count - 1 do
    DWGAddRefHandleCandidate(Dest, Source.Values[I]);
end;

function DWGRefHandleCandidatesValue(Ref: BITCODE_H;
  out Candidates: TDWGRefHandleCandidates): Boolean;
begin
  FillChar(Candidates, SizeOf(Candidates), 0);
  if Ref = nil then
    Exit(False);
  // Issue #1213: mirror fpdwginspect's HandleRefFromBitCode priority order.
  // Ref^.obj^.handle.value is LibreDWG's canonical resolved handle and was
  // observed to carry the full 64-bit value even when absolute_ref had been
  // truncated to the low 16 bits (R2007+ OFFSETOBJHANDLE refs). Putting it
  // first prevents handle-wraparound at A325E from collapsing the entity
  // into the duplicate-handle bucket.
  if Ref^.obj <> nil then
    DWGAddRefHandleCandidate(Candidates, DWGObjectHandleValue(Ref^.obj^));
  DWGAddRefHandleCandidate(Candidates, Ref^.absolute_ref);
  DWGAddRefHandleCandidate(Candidates, Ref^.handleref.value);
  Result := Candidates.Count > 0;
end;

function DWGRefHandleValue(Ref: BITCODE_H; out Value: QWord): Boolean;
var
  Candidates: TDWGRefHandleCandidates;
begin
  Value := 0;
  Result := DWGRefHandleCandidatesValue(Ref, Candidates);
  if Result then
    Value := Candidates.Values[0];
end;

function DWGObjectOwnerHandleValue(const Obj: Dwg_Object;
  out Value: QWord): Boolean;
var
  Candidates: TDWGRefHandleCandidates;
begin
  Value := 0;
  Result := DWGObjectOwnerHandleCandidatesValue(Obj, Candidates);
  if Result then
    Value := Candidates.Values[0];
end;

function DWGObjectOwnerHandleCandidatesValue(const Obj: Dwg_Object;
  out Candidates: TDWGRefHandleCandidates): Boolean;
var
  Ent: ^Dwg_Object_Entity;
  Dwg: ^_dwg_struct;
  ImplicitOwner: ^Dwg_Object;
  HRef: BITCODE_H;
  RefCandidates: TDWGRefHandleCandidates;
begin
  FillChar(Candidates, SizeOf(Candidates), 0);
  case Obj.supertype of
    DWG_SUPERTYPE_ENTITY:
      if Obj.tio.entity <> nil then
      begin
        Ent := Obj.tio.entity;
        // Issue #1118 / #1120: prefer entmode-derived implicit owner over
        // ownerhandle. LibreDWG only fills ownerhandle when entmode=3; for
        // entmode=1/2 the owner is paper/model space and ownerhandle is null.
        // Fall through to ownerhandle when entmode=0 (no owner) or 3.
        //
        // Issue #1120: the original fix only consulted Dwg^.mspace_block /
        // pspace_block. Those pointers stay nil in some decode paths even
        // after a successful libredwg load (testdwg2007.dwg shows entmode=2
        // LINE entities with mspace_block = nil), so we add two more
        // fall-throughs that mirror libredwg's own dwg_model_space_object()
        // helper:
        //   1. Dwg^.header_vars.BLOCK_RECORD_MSPACE / BLOCK_RECORD_PSPACE
        //      (BITCODE_H — the recorded handle reference)
        //   2. Dwg^.block_control.model_space / paper_space
        //      (BITCODE_H — the BLOCK_CONTROL table entry)
        // Either of these gives us the handle without needing the resolved
        // pointer, which is what we ultimately want.
        if (Ent^.entmode = 1) or (Ent^.entmode = 2) then
        begin
          Dwg := Obj.parent;
          if Dwg <> nil then
          begin
            // Path A: resolved block-header pointer (preferred when set).
            if Ent^.entmode = 2 then
              ImplicitOwner := Dwg^.mspace_block
            else
              ImplicitOwner := Dwg^.pspace_block;
            if ImplicitOwner <> nil then
            begin
              DWGAddRefHandleCandidate(Candidates,
                DWGObjectHandleValue(ImplicitOwner^));
            end;
            // Path B: header_vars.BLOCK_RECORD_*SPACE handle reference.
            if Ent^.entmode = 2 then
              HRef := Dwg^.header_vars.BLOCK_RECORD_MSPACE
            else
              HRef := Dwg^.header_vars.BLOCK_RECORD_PSPACE;
            if DWGRefHandleCandidatesValue(HRef, RefCandidates) then
              DWGAppendRefHandleCandidates(Candidates, RefCandidates);
            // Path C: block_control table entry.
            if Ent^.entmode = 2 then
              HRef := Dwg^.block_control.model_space
            else
              HRef := Dwg^.block_control.paper_space;
            if DWGRefHandleCandidatesValue(HRef, RefCandidates) then
              DWGAppendRefHandleCandidates(Candidates, RefCandidates);
          end;
          // entmode signalled an implicit owner but no path resolved it
          // (parent missing or the layout records were not loaded). Fall
          // through to ownerhandle so the legacy path still has a chance.
        end;
        if DWGRefHandleCandidatesValue(Ent^.ownerhandle, RefCandidates) then
          DWGAppendRefHandleCandidates(Candidates, RefCandidates);
        Exit(Candidates.Count > 0);
      end;
    DWG_SUPERTYPE_OBJECT:
      if Obj.tio.&object <> nil then
      begin
        if DWGRefHandleCandidatesValue(Obj.tio.&object^.ownerhandle,
          Candidates) then
          Exit(True);
      end;
  end;
  Result := False;
end;

function DWGEntityLayerHandleValue(const Obj: Dwg_Object;
  out Value: QWord): Boolean;
var
  Candidates: TDWGRefHandleCandidates;
begin
  Value := 0;
  Result := DWGEntityLayerHandleCandidatesValue(Obj, Candidates);
  if Result then
    Value := Candidates.Values[0];
end;

function DWGEntityLayerHandleCandidatesValue(const Obj: Dwg_Object;
  out Candidates: TDWGRefHandleCandidates): Boolean;
begin
  FillChar(Candidates, SizeOf(Candidates), 0);
  if (Obj.supertype <> DWG_SUPERTYPE_ENTITY) or (Obj.tio.entity = nil) then
    Exit(False);
  Result := DWGRefHandleCandidatesValue(Obj.tio.entity^.layer, Candidates);
end;

function DWGEntityLineTypeHandleValue(const Obj: Dwg_Object;
  out Value: QWord): Boolean;
var
  Kind: TDWGEntityLineTypeKind;
begin
  Result := DWGEntityLineTypeRefValue(Obj, Kind, Value) and
    (Kind = dltHandle);
  if not Result then
    Value := 0;
end;

function DWGEntityLineTypeRefValue(const Obj: Dwg_Object;
  out Kind: TDWGEntityLineTypeKind; out Value: QWord): Boolean;
var
  Candidates: TDWGRefHandleCandidates;
begin
  Value := 0;
  Result := DWGEntityLineTypeRefCandidatesValue(Obj, Kind, Candidates);
  if Result and (Candidates.Count > 0) then
    Value := Candidates.Values[0];
end;

function DWGEntityLineTypeRefCandidatesValue(const Obj: Dwg_Object;
  out Kind: TDWGEntityLineTypeKind;
  out Candidates: TDWGRefHandleCandidates): Boolean;
var
  Ent: ^Dwg_Object_Entity;
begin
  Kind := dltMissing;
  FillChar(Candidates, SizeOf(Candidates), 0);
  if (Obj.supertype <> DWG_SUPERTYPE_ENTITY) or (Obj.tio.entity = nil) then
    Exit(False);

  Ent := Obj.tio.entity;

  if DWGObjectVersionBeforeR2000(Obj) then
  begin
    if Ent^.isbylayerlt <> 0 then
    begin
      Kind := dltByLayer;
      Exit(True);
    end;
    if DWGRefHandleCandidatesValue(Ent^.ltype, Candidates) then
    begin
      Kind := dltHandle;
      Exit(True);
    end;
    Exit(False);
  end;

  case Ent^.ltype_flags of
    0:
      begin
        Kind := dltByLayer;
        Exit(True);
      end;
    1:
      begin
        Kind := dltByBlock;
        Exit(True);
      end;
    2:
      begin
        Kind := dltContinuous;
        Exit(True);
      end;
    3:
      begin
        if DWGRefHandleCandidatesValue(Ent^.ltype, Candidates) then
        begin
          Kind := dltHandle;
          Exit(True);
        end;
        Exit(False);
      end;
  end;

  if DWGRefHandleCandidatesValue(Ent^.ltype, Candidates) then
  begin
    Kind := dltHandle;
    Exit(True);
  end;
  Result := False;
end;

function DWGLayerLineTypeHandleValue(const PLayer: PDwg_Object_LAYER;
  out Value: QWord): Boolean;
var
  Candidates: TDWGRefHandleCandidates;
begin
  Value := 0;
  Result := DWGLayerLineTypeHandleCandidatesValue(PLayer, Candidates);
  if Result then
    Value := Candidates.Values[0];
end;

function DWGLayerLineTypeHandleCandidatesValue(const PLayer: PDwg_Object_LAYER;
  out Candidates: TDWGRefHandleCandidates): Boolean;
begin
  FillChar(Candidates, SizeOf(Candidates), 0);
  if PLayer = nil then
    Exit(False);
  Result := DWGRefHandleCandidatesValue(PLayer^.ltype, Candidates);
end;

function DWGColorIndexToACI(const Color: Dwg_Color; out Value: Integer): Boolean;
begin
  Value := Color.index;
  case Color.method of
    DWG_COLOR_METHOD_BYLAYER:
      Value := DWGByLayerColorIndex;
    DWG_COLOR_METHOD_BYBLOCK:
      Value := DWGByBlockColorIndex;
  end;

  if Value < 0 then
    Value := -Value;

  if (Value < DWGByBlockColorIndex) or (Value > DWGByLayerColorIndex) then
  begin
    Value := DWGByLayerColorIndex;
    Exit(False);
  end;
  Result := True;
end;

function DWGColorRawValueToACI(const Color: Dwg_Color; out Value: Integer): Boolean;
begin
  if Color.method <> DWG_COLOR_METHOD_ACI then
  begin
    Value := DWGByLayerColorIndex;
    Exit(False);
  end;

  Value := Color.raw;
  if Value < 0 then
    Value := -Value;
  Result := (Value > 0) and (Value <= 255);
end;

function DWGColorTruecolorPayloadToACI(const Color: Dwg_Color; out Value: Integer): Boolean;
begin
  if Color.method <> DWG_COLOR_METHOD_TRUECOLOR then
  begin
    Value := DWGByLayerColorIndex;
    Exit(False);
  end;

  Value := Integer(Color.rgb and $00FFFFFF);
  Result := (Value > 0) and (Value <= 255);
end;

function DWGColorMethodToText(const Method: Dwg_Color_Method): string;
begin
  case Method of
    DWG_COLOR_METHOD_VOID:
      Result := 'VOID';
    DWG_COLOR_METHOD_BYLAYER:
      Result := 'BYLAYER';
    DWG_COLOR_METHOD_BYBLOCK:
      Result := 'BYBLOCK';
    DWG_COLOR_METHOD_ACI:
      Result := 'ACI';
    DWG_COLOR_METHOD_TRUECOLOR:
      Result := 'TRUECOLOR';
    DWG_COLOR_METHOD_FGCOLOR:
      Result := 'FGCOLOR';
    DWG_COLOR_METHOD_NONE:
      Result := 'NONE';
  else
    Result := 'UNKNOWN';
  end;
end;

function DWGColorLooksLikeLostACI(const Color: Dwg_Color): Boolean;
begin
  Result :=
    (Color.method = DWG_COLOR_METHOD_ACI) and
    ((Color.rgb and $00FFFFFF) = $00FFFFFF) and
    (Abs(Color.index) = 7) and
    (Color.raw = 0);
end;

function DWGColorIsOff(const Color: Dwg_Color): Boolean;
begin
  Result := Color.index < 0;
end;

function DWGLineWeightToDXF(const Value: Integer): Integer;
begin
  if Value < 0 then
    Exit(Value);
  Result := DWGLineWeights[Value mod 32];
end;

function DWGHeaderColorIndexToACI(const Color: Dwg_Color;
  out Value: Integer): Boolean;
begin
  Value := DWGByLayerColorIndex;
  case Color.method of
    DWG_COLOR_METHOD_VOID,
    DWG_COLOR_METHOD_NONE:
      Exit(False);
  end;
  Result := DWGColorIndexToACI(Color, Value);
  if not Result then
    Value := DWGByLayerColorIndex;
end;

function DWGLayerVisualPropsValue(const PLayer: PDwg_Object_LAYER;
  out Props: TDWGLayerVisualProps): Boolean;
var
  RawColorIndex: Integer;
begin
  Props.ColorIndex := 7;
  Props.LineWeight := -3;
  Props.On := True;
  Props.Locked := False;
  Props.Plot := True;

  if PLayer = nil then
    Exit(False);

  { R2004+ CMC layer colors can arrive with color.index normalized away from
    the original layer ACI. Prefer preserved ACI side channels before falling
    back to the decoded index so layer table colors do not collapse to white. }
  if not DWGColorRawValueToACI(PLayer^.color, Props.ColorIndex) then
  begin
    if not DWGColorTruecolorPayloadToACI(PLayer^.color, Props.ColorIndex) then
    begin
      RawColorIndex := PLayer^.color.index;
      if RawColorIndex < 0 then
        RawColorIndex := -RawColorIndex;
      if (RawColorIndex > 0) and (RawColorIndex <= 255) then
        Props.ColorIndex := RawColorIndex
      else if not DWGColorIndexToACI(PLayer^.color, Props.ColorIndex) then
        Props.ColorIndex := 7;
    end;
  end;
  if (Props.ColorIndex <= 0) or (Props.ColorIndex > 255) then
    Props.ColorIndex := 7;
  Props.LineWeight := DWGLineWeightToDXF(PLayer^.linewt);
  Props.On := PLayer^.off = 0;
  Props.Locked := PLayer^.locked <> 0;
  Props.Plot := PLayer^.plotflag <> 0;
  Result := True;
end;

function DWGEntityCommonPropsValue(const Obj: Dwg_Object;
  out Props: TDWGEntityCommonProps): Boolean;
var
  Ent: ^Dwg_Object_Entity;
begin
  Props.ColorIndex := DWGByLayerColorIndex;
  Props.LineWeight := DWGLineWeightByLayer;
  Props.LineTypeScale := DWGDefaultLineTypeScale;
  Props.LineTypeFlags := -1;
  Props.Invisible := False;

  if (Obj.supertype <> DWG_SUPERTYPE_ENTITY) or (Obj.tio.entity = nil) then
    Exit(False);

  Ent := Obj.tio.entity;
  DWGColorIndexToACI(Ent^.color, Props.ColorIndex);
  Props.LineWeight := DWGLineWeightToDXF(Ent^.linewt);
  if Ent^.ltype_scale > 0 then
    Props.LineTypeScale := Ent^.ltype_scale;
  Props.LineTypeFlags := Ent^.ltype_flags;
  Props.Invisible := Ent^.invisible <> 0;
  Result := True;
end;

function DWGEntityLineTypeKindToText(const Kind: TDWGEntityLineTypeKind): string;
begin
  case Kind of
    dltByLayer:
      Result := 'ByLayer';
    dltByBlock:
      Result := 'ByBlock';
    dltContinuous:
      Result := 'Continuous';
    dltHandle:
      Result := 'handle';
    else
      Result := 'missing';
  end;
end;

function DWGHeaderCurrentLayerHandleValue(const Raw: Dwg_Data;
  out Value: QWord): Boolean;
begin
  Result := DWGRefHandleValue(Raw.header_vars.CLAYER, Value);
end;

function DWGHeaderCurrentLineTypeHandleValue(const Raw: Dwg_Data;
  out Value: QWord): Boolean;
begin
  Result := DWGRefHandleValue(Raw.header_vars.CELTYPE, Value);
end;

function DWGHeaderCurrentTextStyleHandleValue(const Raw: Dwg_Data;
  out Value: QWord): Boolean;
begin
  Result := DWGRefHandleValue(Raw.header_vars.TEXTSTYLE, Value);
end;

function DWGHeaderCurrentDimStyleHandleValue(const Raw: Dwg_Data;
  out Value: QWord): Boolean;
begin
  Result := DWGRefHandleValue(Raw.header_vars.DIMSTYLE, Value);
end;

function DWGHeaderCurrentEntityPropsValue(const Raw: Dwg_Data;
  out Props: TDWGHeaderCurrentEntityProps): Boolean;
begin
  Props.ColorIndex := DWGByLayerColorIndex;
  Props.LineWeight := DWGLineWeightByLayer;
  Props.LineTypeScale := DWGDefaultLineTypeScale;
  Props.GlobalLineTypeScale := DWGDefaultLineTypeScale;
  Props.LineWeightDisplay := False;

  DWGHeaderColorIndexToACI(Raw.header_vars.CECOLOR, Props.ColorIndex);
  Props.LineWeight := DWGLineWeightToDXF(Raw.header_vars.CELWEIGHT);
  if Raw.header_vars.CELTSCALE > 0 then
    Props.LineTypeScale := Raw.header_vars.CELTSCALE;
  if Raw.header_vars.LTSCALE > 0 then
    Props.GlobalLineTypeScale := Raw.header_vars.LTSCALE;
  Props.LineWeightDisplay := Raw.header_vars.LWDISPLAY <> 0;
  Result := True;
end;

function DWGDefaultViewProps: TDWGViewProps;
begin
  Result.CenterX := 0;
  Result.CenterY := 0;
  Result.Height := 0;
  Result.Width := 0;
  Result.HasWidth := False;
  Result.Space := dvsUnknown;
end;

function DWGHeaderViewPropsValue(const Raw: Dwg_Data;
  out Props: TDWGViewProps): Boolean;
begin
  Props := DWGDefaultViewProps;
  if Raw.header_vars.VIEWSIZE <= 0 then
    Exit(False);

  Props.CenterX := Raw.header_vars.VIEWCTR.x;
  Props.CenterY := Raw.header_vars.VIEWCTR.y;
  Props.Height := Raw.header_vars.VIEWSIZE;
  if Raw.header_vars.TILEMODE = 0 then
    Props.Space := dvsPaperSpace
  else
    Props.Space := dvsModelSpace;
  Result := True;
end;

function DWGVPortViewPropsValue(const PVPort: PDwg_Object_VPORT;
  out Props: TDWGViewProps): Boolean;
begin
  Props := DWGDefaultViewProps;
  if (PVPort = nil) or (PVPort^.VIEWSIZE <= 0) then
    Exit(False);

  Props.CenterX := PVPort^.VIEWCTR.x;
  Props.CenterY := PVPort^.VIEWCTR.y;
  Props.Height := PVPort^.VIEWSIZE;
  if PVPort^.view_width > 0 then
  begin
    Props.Width := PVPort^.view_width;
    Props.HasWidth := True;
  end
  else if PVPort^.aspect_ratio > 0 then
  begin
    Props.Width := Props.Height * PVPort^.aspect_ratio;
    Props.HasWidth := True;
  end;
  Props.Space := dvsModelSpace;
  Result := True;
end;

function DWGViewSpaceToText(const Space: TDWGViewSpace): string;
begin
  case Space of
    dvsModelSpace:
      Result := 'model';
    dvsPaperSpace:
      Result := 'paper';
  else
    Result := 'unknown';
  end;
end;

function DWGTextStylePropsValue(const PStyle: PDwg_Object_STYLE;
  Version: DWG_VERSION_TYPE; out Props: TDWGTextStyleProps): Boolean;
begin
  Result := DWGTextStylePropsValue(PStyle, Version, -1, Props);
end;

function DWGTextStylePropsValue(const PStyle: PDwg_Object_STYLE;
  Version: DWG_VERSION_TYPE; Codepage: Integer;
  out Props: TDWGTextStyleProps): Boolean;
begin
  Props.Name := '';
  Props.FontFile := '';
  Props.BigFontFile := '';
  Props.TextSize := 0;
  Props.WidthFactor := 1.0;
  Props.ObliqueAngle := 0;
  Props.IsShape := False;
  Props.IsVertical := False;
  Result := PStyle <> nil;
  if not Result then
    Exit;
  DWGSafeDecodeText(PStyle^.name, Version, Codepage, Props.Name);
  DWGSafeDecodeText(PStyle^.font_file, Version, Codepage, Props.FontFile);
  DWGSafeDecodeText(PStyle^.bigfont_file, Version, Codepage,
    Props.BigFontFile);
  Props.TextSize := PStyle^.text_size;
  if PStyle^.width_factor <> 0 then
    Props.WidthFactor := PStyle^.width_factor
  else
    Props.WidthFactor := 1.0;
  Props.ObliqueAngle := PStyle^.oblique_angle;
  Props.IsShape := PStyle^.is_shape <> 0;
  Props.IsVertical := PStyle^.is_vertical <> 0;
end;

function DWGLinetypeDashKindFromFlags(Flags: Integer): TDWGLinetypeDashKind;
begin
  if (Flags and DWGLTypeShapeFlagIsShape) <> 0 then
    Result := dldShape
  else if (Flags and DWGLTypeShapeFlagIsText) <> 0 then
    Result := dldText
  else
    Result := dldDash;
end;

function DWGLinetypePropsValue(const PLType: PDwg_Object_LTYPE;
  Version: DWG_VERSION_TYPE; out Props: TDWGLinetypeProps): Boolean;
begin
  Result := DWGLinetypePropsValue(PLType, Version, -1, Props);
end;

function DWGLinetypePropsValue(const PLType: PDwg_Object_LTYPE;
  Version: DWG_VERSION_TYPE; Codepage: Integer;
  out Props: TDWGLinetypeProps): Boolean;
type
  PLTypeDash = ^Dwg_LTYPE_dash;
var
  I, Count: Integer;
  PDash: PLTypeDash;
begin
  Props.Name := '';
  Props.Description := '';
  Props.PatternLength := 0;
  SetLength(Props.Dashes, 0);

  Result := PLType <> nil;
  if not Result then
    Exit;

  DWGSafeDecodeText(PLType^.name, Version, Codepage, Props.Name);
  DWGSafeDecodeText(PLType^.description, Version, Codepage,
    Props.Description);
  Props.PatternLength := PLType^.pattern_len;

  Count := PLType^.numdashes;
  if Count <= 0 then
    Exit;

  if PLType^.dashes <> nil then
  begin
    SetLength(Props.Dashes, Count);
    PDash := PLType^.dashes;
    for I := 0 to Count - 1 do
    begin
      Props.Dashes[I].Kind :=
        DWGLinetypeDashKindFromFlags(Integer(PDash^.shape_flag));
      Props.Dashes[I].Length := PDash^.length;
      Props.Dashes[I].ShapeCode := PDash^.complex_shapecode;
      Props.Dashes[I].StyleHandle := 0;
      DWGRefHandleValue(PDash^.style, Props.Dashes[I].StyleHandle);
      Props.Dashes[I].XOffset := PDash^.x_offset;
      Props.Dashes[I].YOffset := PDash^.y_offset;
      Props.Dashes[I].Scale := PDash^.scale;
      Props.Dashes[I].Rotation := PDash^.rotation;
      Props.Dashes[I].AbsoluteRotation :=
        (Integer(PDash^.shape_flag) and DWGLTypeShapeFlagAbsRotation) <> 0;
      DWGSafeDecodeText(PDash^.text, Version, Codepage,
        Props.Dashes[I].Text);
      Inc(PDash);
    end;
  end
  else
  begin
    if Count > High(PLType^.dashes_r11) + 1 then
      Count := High(PLType^.dashes_r11) + 1;
    SetLength(Props.Dashes, Count);
    for I := 0 to Count - 1 do
    begin
      Props.Dashes[I].Kind := dldDash;
      Props.Dashes[I].Length := PLType^.dashes_r11[I];
      Props.Dashes[I].ShapeCode := 0;
      Props.Dashes[I].StyleHandle := 0;
      Props.Dashes[I].XOffset := 0;
      Props.Dashes[I].YOffset := 0;
      Props.Dashes[I].Scale := 0;
      Props.Dashes[I].Rotation := 0;
      Props.Dashes[I].AbsoluteRotation := False;
      Props.Dashes[I].Text := '';
    end;
  end;
end;

function DWGTextStyleHandleValue(const PText: PDwg_Entity_TEXT;
  out Value: QWord): Boolean;
var
  Candidates: TDWGRefHandleCandidates;
begin
  Value := 0;
  Result := DWGTextStyleHandleCandidatesValue(PText, Candidates);
  if Result then
    Value := Candidates.Values[0];
end;

function DWGTextStyleHandleCandidatesValue(const PText: PDwg_Entity_TEXT;
  out Candidates: TDWGRefHandleCandidates): Boolean;
begin
  FillChar(Candidates, SizeOf(Candidates), 0);
  if PText = nil then
    Exit(False);
  Result := DWGRefHandleCandidatesValue(PText^.style, Candidates);
end;

function DWGMTextStyleHandleValue(const PMText: PDwg_Entity_MTEXT;
  out Value: QWord): Boolean;
var
  Candidates: TDWGRefHandleCandidates;
begin
  Value := 0;
  Result := DWGMTextStyleHandleCandidatesValue(PMText, Candidates);
  if Result then
    Value := Candidates.Values[0];
end;

function DWGMTextStyleHandleCandidatesValue(const PMText: PDwg_Entity_MTEXT;
  out Candidates: TDWGRefHandleCandidates): Boolean;
begin
  FillChar(Candidates, SizeOf(Candidates), 0);
  if PMText = nil then
    Exit(False);
  Result := DWGRefHandleCandidatesValue(PMText^.style, Candidates);
end;

end.
