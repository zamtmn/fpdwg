{*************************************************************************** }
{  gfdwg - free implementation of the DWG file format based on LibreDWG      }
{                                                                            }
{        Copyright (C) 2022 Andrey Zubarev <zamtmn@yandex.ru>                }
{                                                                            }
{  This library is free software, licensed under the terms of the GNU        }
{  General Public License as published by the Free Software Foundation,      }
{  either version 3 of the License, or (at your option) any later version.   }
{  You should have received a copy of the GNU General Public License         }
{  along with this program.  If not, see <http://www.gnu.org/licenses/>.     }
{*************************************************************************** }

unit dwgproc;

{$IFDEF FPC}
  {$PACKRECORDS C}
  {$MACRO ON}
  {$IFDEF Windows}
    {$DEFINE extdecl := stdcall}
  {$ELSE}
    {$DEFINE extdecl := cdecl}
  {$ENDIF}
  {$Mode objfpc}{$H+}
  {$ModeSwitch advancedrecords}
{$ENDIF}

interface
  uses
    SysUtils, Math, {ctypes,} dynlibs, dwg, ghashmap, TypInfo,
    // R3: handle / text helpers moved into their own units. Re-exported so
    // existing callers (uzefflibredwg2ents.pas, uzedwgtestdwgproc.pas) keep
    // seeing the same names through `uses dwgproc`.
    uzedwghandle, uzedwgtext;

  resourcestring
    rsHandlerAlreadyReg='Handler already registered for %d';
    rsCouldNotLoadLib='Could not load library: %s';

  const
  {$if defined(Windows)}
    LibreDWG_Lib = 'libredwg-0.dll';
  {$elseif defined(OS2)}
    //LibreDWG_Lib = '';
  {$elseif defined(darwin)}
    //LibreDWG_LIB =  '';
  {$elseif defined(haiku) or defined(OpenBSD)}
    //LibreDWG_LIB = '';
  {$elseif defined(MorphOS)}
    //LibreDWG_LIB = '';
  {$else}
    LibreDWG_LIB = 'libredwg.so';
  {$endif}
  type

    TDWGCtx=record
      DWG:Dwg_Data;
      DWGVer:DWG_VERSION_TYPE;
      DWGCodePage:Integer;
      procedure CreateRec(var ADWG:Dwg_Data);
    end;

    // Plain record used by ZCAD LINE mapper and its unit tests. It exposes
    // the bare (x,y,z) pairs that GDBObjLine needs without dragging the
    // ZCAD entity unit into dwgproc.
    TDWGLineEndpoints=record
      StartX,StartY,StartZ:double;
      EndX,EndY,EndZ:double;
    end;

    // Stage 5 (TZ §12.5): plain mirror records that LINE/CIRCLE/ARC/POINT/
    // LWPOLYLINE/TEXT/MTEXT mappers fill before pushing into the ZCAD entity.
    // Keeping them in dwgproc means the scalar copy path is unit-testable
    // against fake LibreDWG records without pulling in the zengine entity
    // graph or libredwg.so.
    TDWGCircleProps=record
      CenterX,CenterY,CenterZ:double;
      Radius:double;
      Thickness:double;
    end;

    TDWGArcProps=record
      CenterX,CenterY,CenterZ:double;
      Radius:double;
      Thickness:double;
      StartAngle:double;
      EndAngle:double;
    end;

    TDWGPointProps=record
      X,Y,Z:double;
      Thickness:double;
      XAngle:double;
    end;

    TDWGTextProps=record
      DataFlags:integer;
      InsertX,InsertY,InsertZ:double;
      AlignX,AlignY:double;
      Height:double;
      Rotation:double;
      Oblique:double;
      WidthFactor:double;
      Generation:integer;
      HorizAlignment:integer;
      VertAlignment:integer;
      Value:string;
    end;

    TDWGTextJustifyKind=(dwtjTopLeft,dwtjTopCenter,dwtjTopRight,
      dwtjMiddleLeft,dwtjMiddleCenter,dwtjMiddleRight,
      dwtjBottomLeft,dwtjBottomCenter,dwtjBottomRight,
      dwtjLeft,dwtjCenter,dwtjRight);

    TDWGMTextProps=record
      InsertX,InsertY,InsertZ:double;
      XAxisX,XAxisY,XAxisZ:double;
      Rotation:double;
      RectWidth,RectHeight:double;
      TextHeight:double;
      Attachment:integer;
      LineSpaceFactor:double;
      Value:string;
    end;

    TDWGMTextJustify=(dwgmtjTopLeft,dwgmtjTopCenter,dwgmtjTopRight,
      dwgmtjMiddleLeft,dwgmtjMiddleCenter,dwgmtjMiddleRight,
      dwgmtjBottomLeft,dwgmtjBottomCenter,dwgmtjBottomRight);

    TDWGLWPolylineVertex=record
      X,Y:double;
      StartWidth,EndWidth,Bulge:double;
    end;

    TDWGLWPolylineProps=record
      Closed:Boolean;
      ConstWidth:double;
      Elevation:double;
      Thickness:double;
      Vertices:array of TDWGLWPolylineVertex;
    end;

    TDWGProxyEntityPayload=record
      ProxyID:Integer;
      ClassID:Integer;
      DWGVersions:Integer;
      MaintVersion:Integer;
      DWGVersion:Integer;
      FromDXF:Integer;
      EntityDataSize:Integer;
      HasGraphic:Boolean;
      Graphic:TBytes;
    end;

    // Stage 8 (TZ §12.8): raw-geometry mirror records for HATCH/SPLINE/
    // ELLIPSE/SOLID/3DFACE/POLYLINE variants. They intentionally stay as
    // plain records so unit tests can exercise the LibreDWG field mapping
    // without allocating ZCAD entities.
    TDWGPoint2D=record
      X,Y:double;
    end;

    TDWGPoint3D=record
      X,Y,Z:double;
    end;

    TDWGInsertProps=record
      InsertPoint:TDWGPoint3D;
      Scale:TDWGPoint3D;
      Rotation:double;
      Extrusion:TDWGPoint3D;
    end;

    TDWG3DFaceProps=record
      Corners:array[0..3] of TDWGPoint3D;
      InvisibleFlags:Integer;
    end;

    TDWGSolidProps=record
      Thickness:double;
      Elevation:double;
      Corners:array[0..3] of TDWGPoint3D;
      Extrusion:TDWGPoint3D;
    end;

    TDWGEllipseProps=record
      Center:TDWGPoint3D;
      MajorAxis:TDWGPoint3D;
      Extrusion:TDWGPoint3D;
      AxisRatio:double;
      StartAngle:double;
      EndAngle:double;
    end;

    TDWGSplineControlPoint=record
      X,Y,Z,W:double;
    end;

    TDWGSplineProps=record
      Flag:Integer;
      Scenario:Integer;
      Degree:Integer;
      Closed:Boolean;
      Periodic:Boolean;
      Rational:Boolean;
      Weighted:Boolean;
      Knots:array of double;
      ControlPoints:array of TDWGSplineControlPoint;
      FitPoints:array of TDWGPoint3D;
    end;

    TDWGHatchPolylinePoint=record
      X,Y:double;
      Bulge:double;
    end;

    TDWGHatchPathProps=record
      IsPolyline:Boolean;
      Closed:Boolean;
      PolylinePoints:array of TDWGHatchPolylinePoint;
    end;

    TDWGHatchPatternLineProps=record
      Angle:double;
      Base,Offset:TDWGPoint2D;
      Dashes:array of double;
    end;

    TDWGHatchProps=record
      PatternName:string;
      Elevation:double;
      Extrusion:TDWGPoint3D;
      IsSolidFill:Boolean;
      Style:Integer;
      PatternType:Integer;
      Angle:double;
      Scale:double;
      PatternLines:array of TDWGHatchPatternLineProps;
      Paths:array of TDWGHatchPathProps;
    end;

    TDWGPolylineRefProps=record
      Closed:Boolean;
      Elevation:double;
      VertexHandles:array of QWord;
    end;

    // Stage 5 (TZ §12.5): the LibreDWG bindings only expose
    // PDwg_Entity_LINE; declare the pointer aliases the Stage 5 helpers
    // require so callers can pass &dwg.tio.entity^.tio.TEXT directly.
    // R3: PDwg_Entity_TEXT / PDwg_Entity_MTEXT are also declared in
    // uzedwghandle (which is re-exported above) and reach callers from
    // there; the rest stay here next to their TDWGCopy* mappers.
    PDwg_Entity_CIRCLE=^Dwg_Entity_CIRCLE;
    PDwg_Entity_ARC=^Dwg_Entity_ARC;
    PDwg_Entity_POINT=^Dwg_Entity_POINT;
    PDwg_Entity_LWPOLYLINE=^Dwg_Entity_LWPOLYLINE;
    PDwg_Entity_PROXY_ENTITY=^Dwg_Entity_PROXY_ENTITY;
    PDwg_Entity__3DFACE=^Dwg_Entity__3DFACE;
    PDwg_Entity_SOLID=^Dwg_Entity_SOLID;
    PDwg_Entity_ELLIPSE=^Dwg_Entity_ELLIPSE;
    PDwg_Entity_SPLINE=^Dwg_Entity_SPLINE;
    PDwg_Entity_HATCH=^Dwg_Entity_HATCH;
    PDwg_Entity_POLYLINE_2D=^Dwg_Entity_POLYLINE_2D;
    PDwg_Entity_POLYLINE_3D=^Dwg_Entity_POLYLINE_3D;
    PDwg_Entity_POLYLINE_MESH=^Dwg_Entity_POLYLINE_MESH;
    PDwg_Entity_POLYLINE_PFACE=^Dwg_Entity_POLYLINE_PFACE;
    PDwg_Entity_VERTEX_2D=^Dwg_Entity_VERTEX_2D;
    PDwg_Entity_VERTEX_3D=^Dwg_Entity_VERTEX_3D;
    PDwg_Entity_VERTEX_MESH=^Dwg_Entity_VERTEX_MESH;
    PDwg_Entity_VERTEX_PFACE=^Dwg_Entity_VERTEX_PFACE;
    PDwg_Entity_VERTEX_PFACE_FACE=^Dwg_Entity_VERTEX_PFACE_FACE;
    PBITCODE_H=^BITCODE_H;

    TData=PtrInt;
    TCounter=Integer;
    TProcessLongProcess=procedure(const Data:TData;const Counter:TCounter);

    HashDWG_OBJECT_TYPE=class
      class function hash(dot:DWG_OBJECT_TYPE; n:longint):SizeUInt;
    end;

    generic GDWGParser<GUserCtx>=class
      type
        TDWGObjectLoadProc=procedure(var ZContext:GUserCtx;var DWGContext:TDWGCtx;var DWGObject:Dwg_Object;P:Pointer);
        PTDWGObjectData=^TDWGObjectData;
        TDWGObjectData=record
          LoadEntityProc:TDWGObjectLoadProc;
          LoadObjectProc:TDWGObjectLoadProc;
          procedure Create;
        end;
        //work in fpc3.2.2
        //TDWGObjectsDataDict=class (specialize TDictionary<DWG_OBJECT_TYPE,TDWGObjectData>)
        //  function GetMutableValue(key:DWG_OBJECT_TYPE; out PAValue:PTDWGObjectData):boolean;
        //end;
        TDWGObjectsDataDict=specialize THashmap<DWG_OBJECT_TYPE,TDWGObjectData,HashDWG_OBJECT_TYPE>;
      var
        DWGObj2LPDict:TDWGObjectsDataDict;
      constructor create;
      destructor destroy;override;
      procedure RegisterDWGEntityLoadProc(const DOT:DWG_OBJECT_TYPE;const LP:TDWGObjectLoadProc);
      procedure RegisterDWGObjectLoadProc(const DOT:DWG_OBJECT_TYPE;const LP:TDWGObjectLoadProc);
      procedure parseDwg_Data(var ZContext:GUserCtx;var dwg:Dwg_Data;const lpp:TProcessLongProcess;const data:TData);
    end;


  var
    dwg_read_file : function(const filename:pchar;
                             dwg:PDwg_Data):integer;extdecl;
    dxf_read_file : function(const filename:pchar;
                             dwg:PDwg_Data):integer;extdecl;
    dwg_free : procedure(dwg:PDwg_Data);extdecl;

  procedure FreeLibreDWG;
  procedure LoadLibreDWG(lib : pchar = LibreDWG_Lib; reloadlib : Boolean = False);
  // R3: BITCODE_T2Text remains here as a TDWGCtx-aware shim that delegates
  // to uzedwgtext.DWGSafeDecodeText. The real handle/text helpers live in
  // uzedwghandle and uzedwgtext (both re-exported by this unit).
  procedure BITCODE_T2Text(const p:BITCODE_T;constref DWGContext:TDWGCtx;out text:string);
  function DWG_V2Str(v:DWG_VERSION_TYPE):string;
  function DWGReadCodeIsCritical(Code:integer):Boolean;
  function DWGReadCodeToText(Code:integer):string;

  // Pure copy of a LIBREDWG line geometry into a ZCAD-shaped record.
  // Lives in dwgproc so tests can verify the Z-coord fix without ZCAD deps.
  procedure DWGCopyLineEndpoints(const Line:Dwg_Entity_LINE;out Endpoints:TDWGLineEndpoints);
  function DWGLineEndpointsAreZeroLength(const Endpoints:TDWGLineEndpoints):Boolean;

  // Stage 5 (TZ §12.5): pure scalar copies into the mirror records above.
  // Each routine is pointer-aware (nil source produces a zeroed record) so
  // callers can drive them straight from LibreDWG output without first
  // checking for missing payloads. The text decode goes through
  // DWGSafeDecodeText so the loader does not crash on a stripped-down
  // fixture that omits the payload field.
  procedure DWGCopyCircleProps(const Circle:Dwg_Entity_CIRCLE;
    out Props:TDWGCircleProps);
  procedure DWGCopyArcProps(const Arc:Dwg_Entity_ARC;out Props:TDWGArcProps);
  procedure DWGCopyPointProps(const Point:Dwg_Entity_POINT;
    out Props:TDWGPointProps);
  procedure DWGCopyTextProps(const Text:Dwg_Entity_TEXT;
    Version:DWG_VERSION_TYPE;out Props:TDWGTextProps); overload;
  procedure DWGCopyTextProps(const Text:Dwg_Entity_TEXT;
    Version:DWG_VERSION_TYPE;Codepage:Integer;out Props:TDWGTextProps); overload;
  function DWGTextUsesAlignmentPoint(DataFlags,HorizAlignment,
    VertAlignment:Integer):Boolean;
  procedure DWGTextEffectiveInsertPoint(const Props:TDWGTextProps;
    out X,Y,Z:Double);
  function DWGTextAlignmentToJustifyKind(HorizAlignment,
    VertAlignment:Integer;
    DefaultJustify:TDWGTextJustifyKind=dwtjTopLeft):TDWGTextJustifyKind;
  procedure DWGCopyMTextProps(const MText:Dwg_Entity_MTEXT;
    Version:DWG_VERSION_TYPE;out Props:TDWGMTextProps); overload;
  procedure DWGCopyMTextProps(const MText:Dwg_Entity_MTEXT;
    Version:DWG_VERSION_TYPE;Codepage:Integer;out Props:TDWGMTextProps); overload;
  procedure DWGCopyInsertProps(const Insert:Dwg_Entity_INSERT;
    out Props:TDWGInsertProps); overload;
  procedure DWGCopyInsertProps(const Insert:Dwg_Entity_MINSERT;
    out Props:TDWGInsertProps); overload;
  function DWGMTextAttachmentToJustify(Attachment:Integer;
    DefaultJustify:TDWGMTextJustify=dwgmtjTopLeft):TDWGMTextJustify;
  function DWGLWPolylineWidthRecordCount(const Props:TDWGLWPolylineProps):Integer;
  procedure DWGCopyLWPolylineProps(const LWP:Dwg_Entity_LWPOLYLINE;
    out Props:TDWGLWPolylineProps);
  function DWGProxyEntityPayloadLooksSane(PProxy:PDwg_Entity_PROXY_ENTITY):Boolean;
  procedure DWGCopyProxyEntityPayload(PProxy:PDwg_Entity_PROXY_ENTITY;
    out Payload:TDWGProxyEntityPayload);
  function DWGCopyProxyEntityPayloadOrPreview(PProxy:PDwg_Entity_PROXY_ENTITY;
    const DWGObject:Dwg_Object;out Payload:TDWGProxyEntityPayload;
    out UsedPreview:Boolean):Boolean;
  // LibreDWG exposes custom/zombie entity proxy graphics on the common
  // entity preview fields even when fixedtype is DWG_TYPE_UNKNOWN_ENT.
  // Some files leave preview_is_proxy unset, so the implementation also
  // accepts preview data whose header matches the proxy graphic stream.
  function DWGCopyEntityPreviewProxyPayload(const DWGObject:Dwg_Object;
    out Payload:TDWGProxyEntityPayload):Boolean;
  procedure DWGCopy3DFaceProps(const Face:Dwg_Entity__3DFACE;
    out Props:TDWG3DFaceProps);
  procedure DWGCopySolidProps(const Solid:Dwg_Entity_SOLID;
    out Props:TDWGSolidProps);
  procedure DWGCopyEllipseProps(const Ellipse:Dwg_Entity_ELLIPSE;
    out Props:TDWGEllipseProps);
  procedure DWGCopySplineProps(const Spline:Dwg_Entity_SPLINE;
    out Props:TDWGSplineProps);
  procedure DWGCopyHatchProps(const Hatch:Dwg_Entity_HATCH;
    Version:DWG_VERSION_TYPE;out Props:TDWGHatchProps); overload;
  procedure DWGCopyHatchProps(const Hatch:Dwg_Entity_HATCH;
    Version:DWG_VERSION_TYPE;Codepage:Integer;out Props:TDWGHatchProps); overload;
  function DWGHatchArcSampleAngle(StartAngle,EndAngle:Double;
    IsCounterClockwise:Boolean;SampleIndex,SampleCount:Integer):Double;
  procedure DWGCopyPolyline2DRefProps(const Polyline:Dwg_Entity_POLYLINE_2D;
    out Props:TDWGPolylineRefProps);
  procedure DWGCopyPolyline3DRefProps(const Polyline:Dwg_Entity_POLYLINE_3D;
    out Props:TDWGPolylineRefProps);
  procedure DWGCopyPolylineMeshRefProps(
    const Polyline:Dwg_Entity_POLYLINE_MESH;
    out Props:TDWGPolylineRefProps);
  procedure DWGCopyPolylinePFaceRefProps(
    const Polyline:Dwg_Entity_POLYLINE_PFACE;
    out Props:TDWGPolylineRefProps);

implementation

  type
    PDwg_Object_Entity=^Dwg_Object_Entity;

  var
    hlib : tlibhandle;

   class function HashDWG_OBJECT_TYPE.hash(dot:DWG_OBJECT_TYPE; n:longint):SizeUInt;
   begin
     result:=ord(dot) mod SizeUInt(n);
   end;

  procedure TDWGCtx.CreateRec(var ADWG:Dwg_Data);
  begin
    DWG:=ADWG;
    DWGVer:=ADWG.HEADER.version;
    if DWGVer=R_INVALID then
      DWGVer:=ADWG.HEADER.from_version;
    DWGCodePage:=ADWG.HEADER.codepage;
  end;

  procedure GDWGParser.TDWGObjectData.Create;
  begin
    LoadEntityProc:=nil;
    LoadObjectProc:=nil;
  end;

  procedure GDWGParser.RegisterDWGEntityLoadProc(const DOT:DWG_OBJECT_TYPE;const LP:TDWGObjectLoadProc);
  var
    dod:TDWGObjectData;
  begin
    // Stage 1: catch double registration so a later mapper does not silently
    // overwrite an earlier one. The hashmap container does not provide a public
    // contains() variant on the FPC version we target, so we look up via
    // GetValue and fall back to insert when the key is absent.
    if DWGObj2LPDict.GetValue(DOT,dod) then
      raise Exception.Create(format(rsHandlerAlreadyReg,[Ord(DOT)]));
    dod.Create;
    dod.LoadEntityProc:=LP;
    dod.LoadObjectProc:=nil;
    DWGObj2LPDict.insert(DOT,dod);
  end;

  procedure GDWGParser.RegisterDWGObjectLoadProc(const DOT:DWG_OBJECT_TYPE;const LP:TDWGObjectLoadProc);
  var
    dod:TDWGObjectData;
  begin
    if DWGObj2LPDict.GetValue(DOT,dod) then
      raise Exception.Create(format(rsHandlerAlreadyReg,[Ord(DOT)]));
    dod.Create;
    dod.LoadEntityProc:=nil;
    dod.LoadObjectProc:=LP;
    DWGObj2LPDict.insert(DOT,dod);
  end;

  procedure GDWGParser.parseDwg_Data(var ZContext:GUserCtx;var dwg:Dwg_Data;const lpp:TProcessLongProcess;const data:TData);
  //work in fpc3.2.2
  //var
  //  i:BITCODE_BL;
  //  pdod:PTDWGObjectData;
  //  DWGContext:TDWGCtx;
  //begin
  //  DWGContext.CreateRec(dwg);
  //  if DWGObj2LPDict<>nil then begin
  //    i:=0;
  //    while (i<dwg.num_objects) do begin
  //      if DWGObj2LPDict.GetMutableValue(dwg.&object[i].fixedtype,pdod) then begin
  //        if pdod^.LoadEntityProc<>nil then
  //          pdod^.LoadEntityProc(ZContext,DWGContext,dwg.&object[i],dwg.&object[i].tio.entity^.tio.UNUSED)
  //        else if pdod^.LoadObjectProc<>nil then
  //          pdod^.LoadObjectProc(ZContext,DWGContext,dwg.&object[i],dwg.&object[i].tio.&object^.tio.DUMMY);
  //      end;
  //      if @lpp<>nil then
  //        lpp(data,i);
  //      inc(i);
  //    end;
  //  end;
  //end;

    // Issue #1213: when no mapper is registered for an ENTITY fixedtype,
    // fall back to the UNKNOWN_ENT handler so primitives ZCAD does not model
    // directly (e.g. MULTILEADER, MLINE, IMAGE, TABLE) still reach a handler
    // and surface as proxy entities via their preview-graphics bytes.
    // fpdwginspect's TDWGObjectFactory.CreateMaterializedObject performs the
    // analogous fallback to its TDWGUnknownMapper — which is precisely why
    // `fpdwginspect --dump-unknown` lists primitives the ZCAD loader was
    // silently dropping.
    //
    // Scope notes:
    //   * Only ENTITY supertype gets the fallback. OBJECT supertype types
    //     already silently skipped are metadata, not drawable primitives;
    //     the fixedtype histogram diagnostic still enumerates them.
    //   * VERTEX_* and SEQEND-like child entities are consumed inside their
    //     parent polyline / insert mapper. Routing them through UNKNOWN_ENT
    //     would emit a spurious "unknown entity" warning for every vertex,
    //     so they are excluded explicitly.
    //   * UNUSED / FREED slots carry no payload to dispatch on.
    function IsParentOwnedChildEntity(FixedType:DWG_OBJECT_TYPE):Boolean;
    begin
      case FixedType of
        DWG_TYPE_VERTEX_2D,
        DWG_TYPE_VERTEX_3D,
        DWG_TYPE_VERTEX_MESH,
        DWG_TYPE_VERTEX_PFACE,
        DWG_TYPE_VERTEX_PFACE_FACE:
          Result:=True;
      else
        Result:=False;
      end;
    end;

    function ResolveFallbackDispatch(const Obj:Dwg_Object;
      out FallbackDod:TDWGObjectData):Boolean;
    begin
      Result:=False;
      if Obj.supertype<>DWG_SUPERTYPE_ENTITY then
        Exit;
      if (Obj.fixedtype=DWG_TYPE_UNUSED) or (Obj.fixedtype=DWG_TYPE_FREED) then
        Exit;
      if IsParentOwnedChildEntity(Obj.fixedtype) then
        Exit;
      Result:=DWGObj2LPDict.GetValue(DWG_TYPE_UNKNOWN_ENT,FallbackDod);
    end;

  var
    i:BITCODE_BL;
    dod:TDWGObjectData;
    DWGContext:TDWGCtx;
    Dispatched:Boolean;
  begin
    DWGContext.CreateRec(dwg);
    DWGNormalizeObjectHandles(dwg);
    if DWGObj2LPDict<>nil then begin
      i:=0;
      while (i<dwg.num_objects) do begin
        Dispatched:=DWGObj2LPDict.GetValue(dwg.&object[i].fixedtype,dod);
        if not Dispatched then
          Dispatched:=ResolveFallbackDispatch(dwg.&object[i],dod);
        if Dispatched then begin
          if dod.LoadEntityProc<>nil then begin
            if dwg.&object[i].tio.entity<>nil then
              dod.LoadEntityProc(ZContext,DWGContext,dwg.&object[i],
                dwg.&object[i].tio.entity^.tio.UNUSED)
            else
              dod.LoadEntityProc(ZContext,DWGContext,dwg.&object[i],nil);
          end else if dod.LoadObjectProc<>nil then begin
            if dwg.&object[i].tio.&object<>nil then
              dod.LoadObjectProc(ZContext,DWGContext,dwg.&object[i],
                dwg.&object[i].tio.&object^.tio.DUMMY)
            else
              dod.LoadObjectProc(ZContext,DWGContext,dwg.&object[i],nil);
          end;
        end;
        if @lpp<>nil then
          lpp(data,i);
        inc(i);
      end;
    end;
  end;

  function DWGReadCodeIsCritical(Code:integer):Boolean;
  const
    CriticalMask =
      Ord(DWG_ERR_CLASSESNOTFOUND) or
      Ord(DWG_ERR_SECTIONNOTFOUND) or
      Ord(DWG_ERR_PAGENOTFOUND) or
      Ord(DWG_ERR_INTERNALERROR) or
      Ord(DWG_ERR_INVALIDDWG) or
      Ord(DWG_ERR_IOERROR) or
      Ord(DWG_ERR_OUTOFMEM);
  begin
    Result := (Code and CriticalMask) <> 0;
  end;

  function DWGReadCodeToText(Code:integer):string;

    procedure AddFlag(Mask:DWG_ERROR;const Name:string);
    begin
      if (Code and Ord(Mask)) = 0 then
        Exit;
      if Result <> '' then
        Result := Result + ',';
      Result := Result + Name;
    end;

  begin
    Result := '';
    if Code = Ord(DWG_NOERR) then
      Exit('DWG_NOERR');

    AddFlag(DWG_ERR_WRONGCRC, 'DWG_ERR_WRONGCRC');
    AddFlag(DWG_ERR_NOTYETSUPPORTED, 'DWG_ERR_NOTYETSUPPORTED');
    AddFlag(DWG_ERR_UNHANDLEDCLASS, 'DWG_ERR_UNHANDLEDCLASS');
    AddFlag(DWG_ERR_INVALIDTYPE, 'DWG_ERR_INVALIDTYPE');
    AddFlag(DWG_ERR_INVALIDHANDLE, 'DWG_ERR_INVALIDHANDLE');
    AddFlag(DWG_ERR_INVALIDEED, 'DWG_ERR_INVALIDEED');
    AddFlag(DWG_ERR_VALUEOUTOFBOUNDS, 'DWG_ERR_VALUEOUTOFBOUNDS');
    AddFlag(DWG_ERR_CLASSESNOTFOUND, 'DWG_ERR_CLASSESNOTFOUND');
    AddFlag(DWG_ERR_SECTIONNOTFOUND, 'DWG_ERR_SECTIONNOTFOUND');
    AddFlag(DWG_ERR_PAGENOTFOUND, 'DWG_ERR_PAGENOTFOUND');
    AddFlag(DWG_ERR_INTERNALERROR, 'DWG_ERR_INTERNALERROR');
    AddFlag(DWG_ERR_INVALIDDWG, 'DWG_ERR_INVALIDDWG');
    AddFlag(DWG_ERR_IOERROR, 'DWG_ERR_IOERROR');
    AddFlag(DWG_ERR_OUTOFMEM, 'DWG_ERR_OUTOFMEM');
    if Result = '' then
      Result := 'DWG_ERR_UNKNOWN';
  end;

  //work in fpc3.2.2
  //function GDWGParser.TDWGObjectsDataDict.GetMutableValue(key:DWG_OBJECT_TYPE; out PAValue:PTDWGObjectData):Boolean;
  //var
  //  LIndex: SizeInt;
  //  LHash: UInt32;
  //begin
  //  LIndex := FindBucketIndex(FItems, key, LHash);
  //
  //  if LIndex < 0 then begin
  //    result:=false;
  //    PAValue:=nil;
  //  end else begin
  //    result:=true;
  //    PAValue:=@FItems[LIndex].Pair.Value;
  //  end;
  //end;

  constructor GDWGParser.create;
  begin
    DWGObj2LPDict:=TDWGObjectsDataDict.create;
  end;
  destructor GDWGParser.destroy;
  begin
    DWGObj2LPDict.Free;
  end;

  function DWG_V2Str(v:DWG_VERSION_TYPE):string;
  begin
    if Ord(v)>Ord(R_AFTER)then
      v:=R_AFTER;
    result:=GetEnumName(typeinfo(v),Ord(v));
  end;

  procedure BITCODE_T2Text(const p:BITCODE_T;constref DWGContext:TDWGCtx;out text:string);
  begin
    // R3: defer to the version-based helper in uzedwgtext so the actual
    // decoding rules live in one place. We pass the parser's resolved
    // header version/codepage (the same ones TDWGCtx.CreateRec populates).
    DWGSafeDecodeText(p,DWGContext.DWGVer,DWGContext.DWGCodePage,text);
  end;

  procedure DWGCopyLineEndpoints(const Line:Dwg_Entity_LINE;out Endpoints:TDWGLineEndpoints);
  begin
    Endpoints.StartX:=Line.start.x;
    Endpoints.StartY:=Line.start.y;
    Endpoints.StartZ:=Line.start.z;
    Endpoints.EndX:=Line.end_.x;
    Endpoints.EndY:=Line.end_.y;
    Endpoints.EndZ:=Line.end_.z;
  end;

  function DWGLineEndpointsAreZeroLength(const Endpoints:TDWGLineEndpoints):Boolean;
  begin
    Result:=(Endpoints.StartX=Endpoints.EndX) and
            (Endpoints.StartY=Endpoints.EndY) and
            (Endpoints.StartZ=Endpoints.EndZ);
  end;

  procedure DWGCopyCircleProps(const Circle:Dwg_Entity_CIRCLE;
    out Props:TDWGCircleProps);
  begin
    Props.CenterX:=Circle.center.x;
    Props.CenterY:=Circle.center.y;
    Props.CenterZ:=Circle.center.z;
    Props.Radius:=Circle.radius;
    Props.Thickness:=Circle.thickness;
  end;

  procedure DWGCopyArcProps(const Arc:Dwg_Entity_ARC;out Props:TDWGArcProps);
  begin
    Props.CenterX:=Arc.center.x;
    Props.CenterY:=Arc.center.y;
    Props.CenterZ:=Arc.center.z;
    Props.Radius:=Arc.radius;
    Props.Thickness:=Arc.thickness;
    Props.StartAngle:=Arc.start_angle;
    Props.EndAngle:=Arc.end_angle;
  end;

  procedure DWGCopyPointProps(const Point:Dwg_Entity_POINT;
    out Props:TDWGPointProps);
  begin
    Props.X:=Point.x;
    Props.Y:=Point.y;
    Props.Z:=Point.z;
    Props.Thickness:=Point.thickness;
    Props.XAngle:=Point.x_ang;
  end;

  procedure DWGCopyTextProps(const Text:Dwg_Entity_TEXT;
    Version:DWG_VERSION_TYPE;out Props:TDWGTextProps);
  begin
    DWGCopyTextProps(Text,Version,-1,Props);
  end;

  procedure DWGCopyTextProps(const Text:Dwg_Entity_TEXT;
    Version:DWG_VERSION_TYPE;Codepage:Integer;out Props:TDWGTextProps);
  begin
    Props.DataFlags:=Text.dataflags;
    Props.InsertX:=Text.ins_pt.x;
    Props.InsertY:=Text.ins_pt.y;
    Props.InsertZ:=Text.elevation;
    Props.AlignX:=Text.alignment_pt.x;
    Props.AlignY:=Text.alignment_pt.y;
    Props.Height:=Text.height;
    Props.Rotation:=Text.rotation;
    Props.Oblique:=Text.oblique_angle;
    Props.WidthFactor:=Text.width_factor;
    Props.Generation:=Text.generation;
    Props.HorizAlignment:=Text.horiz_alignment;
    Props.VertAlignment:=Text.vert_alignment;
    DWGSafeDecodeText(Text.text_value,Version,Codepage,Props.Value);
  end;

  function DWGTextUsesAlignmentPoint(DataFlags,HorizAlignment,
    VertAlignment:Integer):Boolean;
  begin
    // Some DWG files carry dataflags bit 2 on default Left text while
    // alignment_pt remains 0,0. The actual 72/73 alignment codes decide
    // whether the second point is meaningful.
    Result:=(HorizAlignment<>0) or (VertAlignment<>0);
  end;

  procedure DWGTextEffectiveInsertPoint(const Props:TDWGTextProps;
    out X,Y,Z:Double);
  begin
    if DWGTextUsesAlignmentPoint(Props.DataFlags,Props.HorizAlignment,
      Props.VertAlignment) then begin
      X:=Props.AlignX;
      Y:=Props.AlignY;
    end else begin
      X:=Props.InsertX;
      Y:=Props.InsertY;
    end;
    Z:=Props.InsertZ;
  end;

  function DWGTextAlignmentToJustifyKind(HorizAlignment,
    VertAlignment:Integer;
    DefaultJustify:TDWGTextJustifyKind=dwtjTopLeft):TDWGTextJustifyKind;
  const
    DWGTextMaxVertAlignment=3;
    DWGTextMaxHorizAlignment=5;
    DWGTextJustifyMap:array[0..3,0..5] of TDWGTextJustifyKind=(
      (dwtjLeft,dwtjCenter,dwtjRight,dwtjLeft,dwtjMiddleCenter,dwtjLeft),
      (dwtjBottomLeft,dwtjBottomCenter,dwtjBottomRight,dwtjBottomLeft,
        dwtjMiddleCenter,dwtjBottomLeft),
      (dwtjMiddleLeft,dwtjMiddleCenter,dwtjMiddleRight,dwtjMiddleLeft,
        dwtjMiddleCenter,dwtjMiddleLeft),
      (dwtjTopLeft,dwtjTopCenter,dwtjTopRight,dwtjTopLeft,
        dwtjMiddleCenter,dwtjTopLeft)
    );
  begin
    if (VertAlignment<0) or (VertAlignment>DWGTextMaxVertAlignment) then
      Exit(DefaultJustify);
    if (HorizAlignment<0) or (HorizAlignment>DWGTextMaxHorizAlignment) then
      Exit(DefaultJustify);
    Result:=DWGTextJustifyMap[VertAlignment,HorizAlignment];
  end;

  procedure DWGCopyMTextProps(const MText:Dwg_Entity_MTEXT;
    Version:DWG_VERSION_TYPE;out Props:TDWGMTextProps);
  begin
    DWGCopyMTextProps(MText,Version,-1,Props);
  end;

  procedure DWGCopyMTextProps(const MText:Dwg_Entity_MTEXT;
    Version:DWG_VERSION_TYPE;Codepage:Integer;out Props:TDWGMTextProps);
  begin
    Props.InsertX:=MText.ins_pt.x;
    Props.InsertY:=MText.ins_pt.y;
    Props.InsertZ:=MText.ins_pt.z;
    Props.XAxisX:=MText.x_axis_dir.x;
    Props.XAxisY:=MText.x_axis_dir.y;
    Props.XAxisZ:=MText.x_axis_dir.z;
    Props.Rotation:=ArcTan2(Props.XAxisY,Props.XAxisX);
    Props.RectWidth:=MText.rect_width;
    Props.RectHeight:=MText.rect_height;
    Props.TextHeight:=MText.text_height;
    Props.Attachment:=MText.attachment;
    Props.LineSpaceFactor:=MText.linespace_factor;
    DWGSafeDecodeText(MText.text,Version,Codepage,Props.Value);
  end;

  function DWGMTextAttachmentToJustify(Attachment:Integer;
    DefaultJustify:TDWGMTextJustify=dwgmtjTopLeft):TDWGMTextJustify;
  begin
    case Attachment of
      1: Result:=dwgmtjTopLeft;
      2: Result:=dwgmtjTopCenter;
      3: Result:=dwgmtjTopRight;
      4: Result:=dwgmtjMiddleLeft;
      5: Result:=dwgmtjMiddleCenter;
      6: Result:=dwgmtjMiddleRight;
      7: Result:=dwgmtjBottomLeft;
      8: Result:=dwgmtjBottomCenter;
      9: Result:=dwgmtjBottomRight;
    else
      Result:=DefaultJustify;
    end;
  end;

  function DWGLWPolylineWidthRecordCount(const Props:TDWGLWPolylineProps):Integer;
  begin
    // ZCAD GDBObjLWPolyline stores one width record per vertex. Open polylines
    // ignore the trailing generated segment later, but CalcWidthSegment still
    // reads the final width slot while building its cached geometry.
    Result:=Length(Props.Vertices);
  end;

  procedure DWGCopyLWPolylineProps(const LWP:Dwg_Entity_LWPOLYLINE;
    out Props:TDWGLWPolylineProps);
  type
    PBitcode2RD=^BITCODE_2RD;
    PBitcodeBD=^BITCODE_BD;
    PLWPWidth=^Dwg_LWPOLYLINE_width;
  var
    i,n:Integer;
    pPoint:PBitcode2RD;
    pBulge:PBitcodeBD;
    pWidth:PLWPWidth;
  begin
    // Stage 5: bit 512 of `flag` marks a closed polyline (per LibreDWG header
    // comments). Bulge / width arrays are only consulted when their counters
    // match num_points; mismatched arrays are treated as missing so a
    // stripped fixture cannot dereference into garbage.
    Props.Closed:=(LWP.flag and 512)<>0;
    Props.ConstWidth:=LWP.const_width;
    Props.Elevation:=LWP.elevation;
    Props.Thickness:=LWP.thickness;
    n:=LWP.num_points;
    if n<0 then
      n:=0;
    SetLength(Props.Vertices,n);
    if (n>0) and (LWP.points<>nil) then begin
      pPoint:=PBitcode2RD(LWP.points);
      for i:=0 to n-1 do begin
        Props.Vertices[i].X:=pPoint^.x;
        Props.Vertices[i].Y:=pPoint^.y;
        Props.Vertices[i].StartWidth:=LWP.const_width;
        Props.Vertices[i].EndWidth:=LWP.const_width;
        Props.Vertices[i].Bulge:=0;
        Inc(pPoint);
      end;
    end;
    if (n>0) and (LWP.num_bulges=BITCODE_BL(n)) and (LWP.bulges<>nil) then begin
      pBulge:=PBitcodeBD(LWP.bulges);
      for i:=0 to n-1 do begin
        Props.Vertices[i].Bulge:=pBulge^;
        Inc(pBulge);
      end;
    end;
    if (n>0) and (LWP.num_widths=BITCODE_BL(n)) and (LWP.widths<>nil) then begin
      pWidth:=PLWPWidth(LWP.widths);
      for i:=0 to n-1 do begin
        Props.Vertices[i].StartWidth:=pWidth^.start;
        Props.Vertices[i].EndWidth:=pWidth^.end_;
        Inc(pWidth);
      end;
    end;
  end;

  function DWGProxyEntityPayloadLooksSane(PProxy:PDwg_Entity_PROXY_ENTITY):Boolean;
  const
    MAX_PROXY_GRAPHIC_BYTES=128*1024*1024;
  begin
    Result:=False;
    if PProxy=nil then
      Exit;
    if PProxy^.proxy_id<>BITCODE_BL(Ord(DWG_TYPE_PROXY_ENTITY)) then
      Exit;
    if PProxy^.from_dxf>1 then
      Exit;
    if PProxy^.proxy_data_size>BITCODE_BL(MAX_PROXY_GRAPHIC_BYTES) then
      Exit;
    if (PProxy^.proxy_data_size>0) and (PProxy^.proxy_data=nil) then
      Exit;
    Result:=True;
  end;

  procedure DWGCopyProxyEntityPayload(PProxy:PDwg_Entity_PROXY_ENTITY;
    out Payload:TDWGProxyEntityPayload);
    function BLToInt(Value:BITCODE_BL):Integer;
    begin
      if Value>BITCODE_BL(High(Integer)) then
        Result:=High(Integer)
      else
        Result:=Integer(Value);
    end;
  var
    ByteCount:Integer;
  begin
    Payload.ProxyID:=0;
    Payload.ClassID:=0;
    Payload.DWGVersions:=0;
    Payload.MaintVersion:=0;
    Payload.DWGVersion:=0;
    Payload.FromDXF:=0;
    Payload.EntityDataSize:=0;
    Payload.HasGraphic:=False;
    SetLength(Payload.Graphic,0);

    if PProxy=nil then
      Exit;

    Payload.ProxyID:=BLToInt(PProxy^.proxy_id);
    Payload.ClassID:=BLToInt(PProxy^.class_id);
    Payload.DWGVersions:=BLToInt(PProxy^.dwg_versions);
    Payload.MaintVersion:=BLToInt(PProxy^.maint_version);
    Payload.DWGVersion:=BLToInt(PProxy^.dwg_version);
    Payload.FromDXF:=PProxy^.from_dxf;
    Payload.EntityDataSize:=BLToInt(PProxy^.data_size);

    if not DWGProxyEntityPayloadLooksSane(PProxy) then
      Exit;
    if (PProxy^.proxy_data=nil) or (PProxy^.proxy_data_size=0) then
      Exit;
    if PProxy^.proxy_data_size>BITCODE_BL(High(Integer)) then
      Exit;

    ByteCount:=Integer(PProxy^.proxy_data_size);
    SetLength(Payload.Graphic,ByteCount);
    Move(PProxy^.proxy_data^,Payload.Graphic[0],ByteCount);
    Payload.HasGraphic:=ByteCount>0;
  end;

  function DWGCopyProxyEntityPayloadOrPreview(PProxy:PDwg_Entity_PROXY_ENTITY;
    const DWGObject:Dwg_Object;out Payload:TDWGProxyEntityPayload;
    out UsedPreview:Boolean):Boolean;
  var
    ExplicitPayload,PreviewPayload:TDWGProxyEntityPayload;
  begin
    UsedPreview:=False;
    DWGCopyProxyEntityPayload(PProxy,ExplicitPayload);
    Payload:=ExplicitPayload;
    if ExplicitPayload.HasGraphic then begin
      Result:=True;
      Exit;
    end;

    if DWGCopyEntityPreviewProxyPayload(DWGObject,PreviewPayload) then begin
      Payload:=PreviewPayload;
      UsedPreview:=True;
      Result:=True;
      Exit;
    end;

    Result:=False;
  end;

  function DWGCopyEntityPreviewProxyPayload(const DWGObject:Dwg_Object;
    out Payload:TDWGProxyEntityPayload):Boolean;
  const
    MAX_PROXY_PREVIEW_COMMAND_COUNT=100000;
    function BLToInt(Value:BITCODE_BL):Integer;
    begin
      if Value>BITCODE_BL(High(Integer)) then
        Result:=High(Integer)
      else
        Result:=Integer(Value);
    end;
    function BLLToInt(Value:BITCODE_BLL):Integer;
    begin
      if Value>BITCODE_BLL(High(Integer)) then
        Result:=High(Integer)
      else
        Result:=Integer(Value);
    end;
    function PreviewLooksLikeProxyGraphic(Ent:PDwg_Object_Entity;
      ByteCount:Integer):Boolean;
    var
      Header:array[0..7] of Byte;
      ChunkSize,CommandCount:Cardinal;
    begin
      Result:=False;
      if (Ent=nil) or (Ent^.preview=nil) or (ByteCount<SizeOf(Header)) then
        Exit;

      Move(Ent^.preview^,Header[0],SizeOf(Header));
      Move(Header[0],ChunkSize,SizeOf(ChunkSize));
      Move(Header[4],CommandCount,SizeOf(CommandCount));
      Result:=(ChunkSize=Cardinal(ByteCount))
        and (CommandCount>0)
        and (CommandCount<Cardinal(MAX_PROXY_PREVIEW_COMMAND_COUNT));
    end;
  var
    Ent:PDwg_Object_Entity;
    ByteCount:Integer;
  begin
    Payload.ProxyID:=498;
    Payload.ClassID:=499;
    Payload.DWGVersions:=15;
    Payload.MaintVersion:=0;
    Payload.DWGVersion:=0;
    Payload.FromDXF:=0;
    Payload.EntityDataSize:=0;
    Payload.HasGraphic:=False;
    SetLength(Payload.Graphic,0);
    Result:=False;

    if (DWGObject.supertype<>DWG_SUPERTYPE_ENTITY)
      or (DWGObject.tio.entity=nil) then
      Exit;

    Ent:=DWGObject.tio.entity;
    if (Ent^.preview_exists=0) or (Ent^.preview=nil) or (Ent^.preview_size=0) then
      Exit;
    if Ent^.preview_size>BITCODE_BLL(High(Integer)) then
      Exit;
    ByteCount:=BLLToInt(Ent^.preview_size);
    if (Ent^.preview_is_proxy=0)
      and not PreviewLooksLikeProxyGraphic(Ent,ByteCount) then
      Exit;

    if DWGObject.klass<>nil then begin
      if DWGObject.klass^.number<>0 then
        Payload.ClassID:=Integer(DWGObject.klass^.number);
      Payload.DWGVersion:=BLToInt(DWGObject.klass^.dwg_version);
      Payload.MaintVersion:=BLToInt(DWGObject.klass^.maint_version);
    end;

    Payload.EntityDataSize:=0;
    SetLength(Payload.Graphic,ByteCount);
    Move(Ent^.preview^,Payload.Graphic[0],ByteCount);
    Payload.HasGraphic:=ByteCount>0;
    Result:=Payload.HasGraphic;
  end;

  function DWGBLToInt(Value:BITCODE_BL):Integer;
  begin
    if Value>BITCODE_BL(High(Integer)) then
      Result:=High(Integer)
    else
      Result:=Integer(Value);
  end;

  procedure DWGPoint3DFrom3BD(const Src:BITCODE_3BD;out Dest:TDWGPoint3D);
  begin
    Dest.X:=Src.x;
    Dest.Y:=Src.y;
    Dest.Z:=Src.z;
  end;

  function DWGPoint3DFrom2RDAtElevation(const Src:BITCODE_2RD;
    Elevation:double):TDWGPoint3D;
  begin
    Result.X:=Src.x;
    Result.Y:=Src.y;
    Result.Z:=Elevation;
  end;

  procedure DWGCopyInsertProps(const Insert:Dwg_Entity_INSERT;
    out Props:TDWGInsertProps);
  begin
    DWGPoint3DFrom3BD(Insert.ins_pt,Props.InsertPoint);
    DWGPoint3DFrom3BD(Insert.scale,Props.Scale);
    Props.Rotation:=Insert.rotation;
    DWGPoint3DFrom3BD(Insert.extrusion,Props.Extrusion);
  end;

  procedure DWGCopyInsertProps(const Insert:Dwg_Entity_MINSERT;
    out Props:TDWGInsertProps);
  begin
    DWGPoint3DFrom3BD(Insert.ins_pt,Props.InsertPoint);
    DWGPoint3DFrom3BD(Insert.scale,Props.Scale);
    Props.Rotation:=Insert.rotation;
    DWGPoint3DFrom3BD(Insert.extrusion,Props.Extrusion);
  end;

  procedure DWGCopy3DFaceProps(const Face:Dwg_Entity__3DFACE;
    out Props:TDWG3DFaceProps);
  begin
    DWGPoint3DFrom3BD(Face.corner1,Props.Corners[0]);
    DWGPoint3DFrom3BD(Face.corner2,Props.Corners[1]);
    DWGPoint3DFrom3BD(Face.corner3,Props.Corners[2]);
    DWGPoint3DFrom3BD(Face.corner4,Props.Corners[3]);
    Props.InvisibleFlags:=Face.invis_flags;
  end;

  procedure DWGCopySolidProps(const Solid:Dwg_Entity_SOLID;
    out Props:TDWGSolidProps);
  begin
    Props.Thickness:=Solid.thickness;
    Props.Elevation:=Solid.elevation;
    Props.Corners[0]:=DWGPoint3DFrom2RDAtElevation(Solid.corner1,Solid.elevation);
    Props.Corners[1]:=DWGPoint3DFrom2RDAtElevation(Solid.corner2,Solid.elevation);
    Props.Corners[2]:=DWGPoint3DFrom2RDAtElevation(Solid.corner3,Solid.elevation);
    Props.Corners[3]:=DWGPoint3DFrom2RDAtElevation(Solid.corner4,Solid.elevation);
    DWGPoint3DFrom3BD(Solid.extrusion,Props.Extrusion);
  end;

  procedure DWGCopyEllipseProps(const Ellipse:Dwg_Entity_ELLIPSE;
    out Props:TDWGEllipseProps);
  begin
    DWGPoint3DFrom3BD(Ellipse.center,Props.Center);
    DWGPoint3DFrom3BD(Ellipse.sm_axis,Props.MajorAxis);
    DWGPoint3DFrom3BD(Ellipse.extrusion,Props.Extrusion);
    Props.AxisRatio:=Ellipse.axis_ratio;
    Props.StartAngle:=Ellipse.start_angle;
    Props.EndAngle:=Ellipse.end_angle;
  end;

  procedure DWGCopySplineProps(const Spline:Dwg_Entity_SPLINE;
    out Props:TDWGSplineProps);
  type
    PBitcodeBD=^BITCODE_BD;
    PBitcode3DPoint=^BITCODE_3DPOINT;
    PSplineControlPoint=^Dwg_SPLINE_control_point;
  var
    i,n:Integer;
    pKnot:PBitcodeBD;
    pControl:PSplineControlPoint;
    pFit:PBitcode3DPoint;
  begin
    Props.Flag:=Spline.flag;
    Props.Scenario:=Spline.scenario;
    Props.Degree:=Spline.degree;
    Props.Closed:=((Spline.flag and 1)<>0) or (Spline.closed_b<>0)
      or ((Spline.splineflags and 4)<>0);
    Props.Periodic:=((Spline.flag and 2)<>0) or (Spline.periodic<>0);
    Props.Rational:=((Spline.flag and 4)<>0) or (Spline.rational<>0);
    Props.Weighted:=Spline.weighted<>0;
    SetLength(Props.Knots,0);
    SetLength(Props.ControlPoints,0);
    SetLength(Props.FitPoints,0);

    n:=DWGBLToInt(Spline.num_knots);
    if (n>0) and (Spline.knots<>nil) then begin
      SetLength(Props.Knots,n);
      pKnot:=PBitcodeBD(Spline.knots);
      for i:=0 to n-1 do begin
        Props.Knots[i]:=pKnot^;
        Inc(pKnot);
      end;
    end;

    n:=DWGBLToInt(Spline.num_ctrl_pts);
    if (n>0) and (Spline.ctrl_pts<>nil) then begin
      SetLength(Props.ControlPoints,n);
      pControl:=PSplineControlPoint(Spline.ctrl_pts);
      for i:=0 to n-1 do begin
        Props.ControlPoints[i].X:=pControl^.x;
        Props.ControlPoints[i].Y:=pControl^.y;
        Props.ControlPoints[i].Z:=pControl^.z;
        Props.ControlPoints[i].W:=pControl^.w;
        Inc(pControl);
      end;
    end;

    n:=DWGBLToInt(Spline.num_fit_pts);
    if (n>0) and (Spline.fit_pts<>nil) then begin
      SetLength(Props.FitPoints,n);
      pFit:=PBitcode3DPoint(Spline.fit_pts);
      for i:=0 to n-1 do begin
        DWGPoint3DFrom3BD(pFit^,Props.FitPoints[i]);
        Inc(pFit);
      end;
    end;
  end;

  procedure DWGCopyHatchProps(const Hatch:Dwg_Entity_HATCH;
    Version:DWG_VERSION_TYPE;out Props:TDWGHatchProps);
  begin
    DWGCopyHatchProps(Hatch,Version,-1,Props);
  end;

  function DWGHatchArcSampleAngle(StartAngle,EndAngle:Double;
    IsCounterClockwise:Boolean;SampleIndex,SampleCount:Integer):Double;
  var
    Sweep:Double;
  begin
    if SampleCount<=0 then
      Exit(StartAngle);
    Sweep:=EndAngle-StartAngle;
    if not IsCounterClockwise then begin
      StartAngle:=2*Pi-StartAngle;
      Sweep:=-Sweep;
    end;
    Result:=StartAngle+Sweep*SampleIndex/SampleCount;
  end;

  procedure DWGCopyHatchProps(const Hatch:Dwg_Entity_HATCH;
    Version:DWG_VERSION_TYPE;Codepage:Integer;out Props:TDWGHatchProps);
  type
    PHatchPath=^Dwg_HATCH_Path;
    PHatchPolylinePath=^Dwg_HATCH_PolylinePath;
    PHatchDefLine=^Dwg_HATCH_DefLine;
    PBitcodeBD=^BITCODE_BD;
  var
    i,j,n,PointCount,DashCount:Integer;
    pPath:PHatchPath;
    pPoint:PHatchPolylinePath;
    pDefLine:PHatchDefLine;
    pDash:PBitcodeBD;
  begin
    Props.PatternName:='';
    Props.Elevation:=Hatch.elevation;
    DWGPoint3DFrom3BD(Hatch.extrusion,Props.Extrusion);
    Props.IsSolidFill:=Hatch.is_solid_fill<>0;
    Props.Style:=Hatch.style;
    Props.PatternType:=Hatch.pattern_type;
    Props.Angle:=Hatch.angle;
    Props.Scale:=Hatch.scale_spacing;
    SetLength(Props.PatternLines,0);
    SetLength(Props.Paths,0);
    DWGSafeDecodeText(Hatch.name,Version,Codepage,Props.PatternName);

    n:=Integer(Hatch.num_deflines);
    if (n>0) and (Hatch.deflines<>nil) then begin
      SetLength(Props.PatternLines,n);
      pDefLine:=PHatchDefLine(Hatch.deflines);
      for i:=0 to n-1 do begin
        Props.PatternLines[i].Angle:=pDefLine^.angle;
        Props.PatternLines[i].Base.X:=pDefLine^.pt0.x;
        Props.PatternLines[i].Base.Y:=pDefLine^.pt0.y;
        Props.PatternLines[i].Offset.X:=pDefLine^.offset.x;
        Props.PatternLines[i].Offset.Y:=pDefLine^.offset.y;
        SetLength(Props.PatternLines[i].Dashes,0);
        DashCount:=Integer(pDefLine^.num_dashes);
        if (DashCount>0) and (pDefLine^.dashes<>nil) then begin
          SetLength(Props.PatternLines[i].Dashes,DashCount);
          pDash:=PBitcodeBD(pDefLine^.dashes);
          for j:=0 to DashCount-1 do begin
            Props.PatternLines[i].Dashes[j]:=pDash^;
            Inc(pDash);
          end;
        end;
        Inc(pDefLine);
      end;
    end;

    n:=DWGBLToInt(Hatch.num_paths);
    if (n<=0) or (Hatch.paths=nil) then
      Exit;
    SetLength(Props.Paths,n);
    pPath:=PHatchPath(Hatch.paths);
    for i:=0 to n-1 do begin
      Props.Paths[i].IsPolyline:=(pPath^.flag and 2)<>0;
      Props.Paths[i].Closed:=pPath^.closed<>0;
      SetLength(Props.Paths[i].PolylinePoints,0);
      if Props.Paths[i].IsPolyline and (pPath^.polyline_paths<>nil) then begin
        PointCount:=DWGBLToInt(pPath^.num_segs_or_paths);
        SetLength(Props.Paths[i].PolylinePoints,PointCount);
        pPoint:=PHatchPolylinePath(pPath^.polyline_paths);
        for j:=0 to PointCount-1 do begin
          Props.Paths[i].PolylinePoints[j].X:=pPoint^.point.x;
          Props.Paths[i].PolylinePoints[j].Y:=pPoint^.point.y;
          Props.Paths[i].PolylinePoints[j].Bulge:=pPoint^.bulge;
          Inc(pPoint);
        end;
      end;
      Inc(pPath);
    end;
  end;

  procedure DWGCopyPolylineRefPropsCommon(Closed:Boolean;Elevation:double;
    NumOwned:BITCODE_BL;VertexRefs:PBITCODE_H;out Props:TDWGPolylineRefProps);
  var
    i,n:Integer;
    pRef:PBITCODE_H;
    Handle:QWord;
  begin
    Props.Closed:=Closed;
    Props.Elevation:=Elevation;
    SetLength(Props.VertexHandles,0);
    n:=DWGBLToInt(NumOwned);
    if (n<=0) or (VertexRefs=nil) then
      Exit;
    SetLength(Props.VertexHandles,n);
    pRef:=VertexRefs;
    for i:=0 to n-1 do begin
      if DWGRefHandleValue(pRef^,Handle) then
        Props.VertexHandles[i]:=Handle
      else
        Props.VertexHandles[i]:=0;
      Inc(pRef);
    end;
  end;

  procedure DWGCopyPolyline2DRefProps(const Polyline:Dwg_Entity_POLYLINE_2D;
    out Props:TDWGPolylineRefProps);
  begin
    DWGCopyPolylineRefPropsCommon((Polyline.flag and 1)<>0,
      Polyline.elevation,Polyline.num_owned,Polyline.vertex,Props);
  end;

  procedure DWGCopyPolyline3DRefProps(const Polyline:Dwg_Entity_POLYLINE_3D;
    out Props:TDWGPolylineRefProps);
  begin
    DWGCopyPolylineRefPropsCommon((Polyline.flag and 1)<>0,0,
      Polyline.num_owned,Polyline.vertex,Props);
  end;

  procedure DWGCopyPolylineMeshRefProps(
    const Polyline:Dwg_Entity_POLYLINE_MESH;
    out Props:TDWGPolylineRefProps);
  begin
    DWGCopyPolylineRefPropsCommon((Polyline.flag and 1)<>0,0,
      Polyline.num_owned,Polyline.vertex,Props);
  end;

  procedure DWGCopyPolylinePFaceRefProps(
    const Polyline:Dwg_Entity_POLYLINE_PFACE;
    out Props:TDWGPolylineRefProps);
  begin
    DWGCopyPolylineRefPropsCommon(False,0,Polyline.num_owned,
      Polyline.vertex,Props);
  end;



  procedure FreeLibreDWG;
  begin
    if (hlib <> 0) then
      FreeLibrary(hlib);
    hlib:=0;
    dwg_read_file:=nil;
    dxf_read_file:=nil;
    dwg_free:=nil;
  end;

  procedure LoadLibreDWG(lib : pchar = LibreDWG_Lib; reloadlib : Boolean = False);
  begin
    if reloadlib then
      FreeLibreDWG;
    if hlib = 0 then begin
      hlib:=LoadLibrary(lib);
      pointer(dwg_read_file):=GetProcAddress(hlib,'dwg_read_file');
      pointer(dxf_read_file):=GetProcAddress(hlib,'dxf_read_file');
      pointer(dwg_free):=GetProcAddress(hlib,'dwg_free');
    end;
    if hlib=0 then
      raise Exception.Create(format(rsCouldNotLoadLib,[lib]));
  end;

initialization
  hlib:=0;
  FreeLibreDWG;
finalization
  FreeLibreDWG;
end.
