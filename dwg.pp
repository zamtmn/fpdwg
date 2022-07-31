{*************************************************************************** }
{  LibreDWG - free implementation of the DWG file format                     }
{                                                                            }
{  Copyright (C) 2009-2010,2018-2021 Free Software Foundation, Inc.          }
{                                                                            }
{  This library is free software, licensed under the terms of the GNU        }
{  General Public License as published by the Free Software Foundation,      }
{  either version 3 of the License, or (at your option) any later version.   }
{  You should have received a copy of the GNU General Public License         }
{  along with this program.  If not, see <http://www.gnu.org/licenses/>.     }
{*************************************************************************** }
{
 * dwg.h: main public header file (the other variant is dwg_api.h)
 *
 * written by Felipe Castro
 * modified by Felipe Corrêa da Silva Sances
 * modified by Rodrigo Rodrigues da Silva
 * modified by Till Heuschmann
 * modified by Reini Urban
}

{
  Automatically converted by H2Pas 1.0.0 from dwg.h
  The following command line parameters were used:
    dwg.h
}

unit dwg;

{$IFDEF FPC}
  {$PACKRECORDS C}
  {$MACRO ON}
  {$IFDEF Windows}
    {$DEFINE extdecl := stdcall}
  {$ELSE}
    {$DEFINE extdecl := cdecl}
  {$ENDIF}
{$ENDIF}

interface
  uses
    SysUtils, ctypes;

  const

    LIBREDWG_VERSION_MAJOR = 0;
    LIBREDWG_VERSION_MINOR = 10;
    LIBREDWG_VERSION       = LIBREDWG_VERSION_MAJOR * 100 + LIBREDWG_VERSION_MINOR;
    LIBREDWG_SO_VERSION    = '0:10:0';

  type
     uint8_t = cuint8;
      int8_t = cint8;
    uint16_t = cuint16;
     int16_t = cint16;
    uint32_t = cuint32;
     int32_t = cint32;
    uint64_t = cuint64;
     int64_t = cint64;
  type
    BITCODE_DOUBLE = double;
    BITCODE_RC = byte;
    BITCODE_RCd = char;
    BITCODE_RCu = byte;
    BITCODE_RCx = byte;
    BITCODE_B = byte;
    BITCODE_BB = byte;
    BITCODE_3B = byte;
    BITCODE_BS = uint16_t;
    BITCODE_BSd = int16_t;
    BITCODE_BSx = uint16_t;
    BITCODE_RS = uint16_t;
    BITCODE_RSd = int16_t;
    BITCODE_RSx = uint16_t;
    BITCODE_BL = uint32_t;
    BITCODE_BLx = uint32_t;
    BITCODE_BLd = int32_t;
    BITCODE_RL = uint32_t;
    BITCODE_RLx = uint32_t;
    BITCODE_RLd = int32_t;
    BITCODE_MC = longint;
    BITCODE_UMC = dword;
    BITCODE_MS = BITCODE_BL;
    BITCODE_RD = BITCODE_DOUBLE;
    BITCODE_RLL = uint64_t;
    BITCODE_BLL = uint64_t;
 {$ifndef HAVE_NATIVE_WCHAR2}
    dwg_wchar_t = BITCODE_RS;
    DWGCHAR = dwg_wchar_t;
 {$endif}
    BITCODE_TF = ^byte;
    BITCODE_TV = ^char;
    BITCODE_T16 = BITCODE_TV;
    BITCODE_T32 = BITCODE_TV;
    BITCODE_TU32 = BITCODE_TV;
    BITCODE_BT = BITCODE_DOUBLE;
    BITCODE_DD = BITCODE_DOUBLE;
    BITCODE_BD = BITCODE_DOUBLE;
    BITCODE_4BITS = BITCODE_RC;
    BITCODE_D2T = BITCODE_TV;
    BITCODE_T = BITCODE_TV;
 {$ifdef HAVE_NATIVE_WCHAR2}
    BITCODE_TU = ^dwg_wchar_t;
 {$else}
    BITCODE_TU = ^BITCODE_RS;
 {$endif}

    type
      _dwg_time_bll = record
          days : BITCODE_BL;
          ms : BITCODE_BL;
          value : BITCODE_BD;
        end;
      Dwg_Bitcode_TimeBLL = _dwg_time_bll;

      _dwg_bitcode_2rd = record
          x : BITCODE_RD;
          y : BITCODE_RD;
        end;
      Dwg_Bitcode_2RD = _dwg_bitcode_2rd;

      _dwg_bitcode_2bd = record
          x : BITCODE_BD;
          y : BITCODE_BD;
        end;
      Dwg_Bitcode_2BD = _dwg_bitcode_2bd;

      _dwg_bitcode_3rd = record
          x : BITCODE_RD;
          y : BITCODE_RD;
          z : BITCODE_RD;
        end;
      Dwg_Bitcode_3RD = _dwg_bitcode_3rd;

      _dwg_bitcode_3bd = record
          x : BITCODE_BD;
          y : BITCODE_BD;
          z : BITCODE_BD;
        end;
      Dwg_Bitcode_3BD = _dwg_bitcode_3bd;
      BITCODE_TIMEBLL = Dwg_Bitcode_TimeBLL;
      BITCODE_TIMERLL = Dwg_Bitcode_TimeBLL;
      BITCODE_2RD = Dwg_Bitcode_2RD;
      BITCODE_2BD = Dwg_Bitcode_2BD;
      BITCODE_2DPOINT = Dwg_Bitcode_2BD;
      BITCODE_2BD_1 = Dwg_Bitcode_2BD;
      BITCODE_3RD = Dwg_Bitcode_3RD;
      BITCODE_3BD = Dwg_Bitcode_3BD;
      BITCODE_3DPOINT = Dwg_Bitcode_3BD;
      BITCODE_3BD_1 = Dwg_Bitcode_3BD;
      BITCODE_BE = Dwg_Bitcode_3BD;
      BITCODE_3DVECTOR = BITCODE_3BD_1;
    { MC0.0/0  MicroCAD Release 1.1  }
    { AC1.2/0  AutoCAD Release 1.2  }
    { AC1.3/1  AutoCAD Release 1.3  }
    { AC1.40/2 AutoCAD Release 1.4  }
    { AC1.50/3 AutoCAD 2.0 beta  }
    { AC1.50/4 AutoCAD Release 2.0  }
    { AC2.10/5 AutoCAD Release 2.10  }
    { AC2.21/6 AutoCAD Release 2.21  }
    { AC2.22/7 AutoCAD Release 2.22  }
    { AC1001/8 AutoCAD Release 2.4  }
    { AC1002/9 AutoCAD Release 2.5  }
    { AC1003/10 AutoCAD Release 2.6  }
    { AC1004/0xb AutoCAD Release 9  }
    { AC1005/0xc AutoCAD Release 9c1  }
    { AC1006/0xd AutoCAD Release 10  }
    { AC1007/0xe AutoCAD 11 beta 1  }
    { AC1008/0xf AutoCAD 11 beta 2  }
    { AC1009/0x10 AutoCAD Release 11/12 (LT R1/R2)  }
    { AC1010/0x11 AutoCAD 13 beta 1  }
    { AC1011/0x12 AutoCAD 13 beta 2  }
    { AC1012/0x13 AutoCAD Release 13  }
    { AC1013/0x14 AutoCAD Release 13c3  }
    { AC1014/0x15 AutoCAD Release 14  }
    { AC1500/0x16 AutoCAD 2000 beta  }
    { AC1015/0x16 AutoCAD Release 2000  }
    { AC1016/0x17 AutoCAD Release 2000i  }
    { AC1017/0x18 AutoCAD Release 2002  }
    { AC402b/0x18 AutoCAD 2004 alpha a  }
    { AC402b/0x18 AutoCAD 2004 alpha b  }
    { AC1018/0x18 AutoCAD 2004 beta  }
    { AC1018/0x19 AutoCAD Release 2004 - 2006  }
    { AC1019/0x19 AutoCAD 2005  }
    { AC1020/0x19 AutoCAD 2006  }
    { AC1021/0x19 AutoCAD 2007 beta  }
    { AC1021/0x1b AutoCAD Release 2007 - 2009  }
    { AC1022/0x1b AutoCAD 2008  }
    { AC1023/0x1b AutoCAD 2009  }
    { AC1024/0x1b AutoCAD 2009  }
    { AC1024/0x1c AutoCAD Release 2010 - 2012  }
    { AC1025/0x1d AutoCAD 2011  }
    { AC1026/0x1e AutoCAD 2012  }
    { AC1027/0x1e AutoCAD 2013 beta  }
    { AC1027/0x1f AutoCAD Release 2013 - 2017  }
    { AC1028/0x1f AutoCAD 2014  }
    { AC1029/0x1f AutoCAD 2015  }
    { AC1030/0x1f AutoCAD 2016  }
    { AC1031/0x20 AutoCAD 2017  }
    { AC1032/0x20 AutoCAD 2018 beta  }
    { AC1032/0x21 AutoCAD Release 2018 - 2021  }
    { AC1033/0x22AutoCAD 2019  }
    { AC1034/0x23 AutoCAD 2020  }
    { AC1035/0x24 AutoCAD 2021  }
    { AC103-4 AutoCAD Release 2022?  }

    type
      DWG_VERSION_TYPE = (R_INVALID,R_1_1,R_1_2,R_1_3,R_1_4,R_2_0b,
        R_2_0,R_2_10,R_2_21,R_2_22,R_2_4,R_2_5,
        R_2_6,R_9,R_9c1,R_10,R_11b1,R_11b2,R_11,
        R_12 := R_11,R_13b1,R_13b2,R_13,R_13c3,R_14,
        R_2000b,R_2000,R_2000i,R_2002,R_2004a,
        R_2004b,R_2004c,R_2004,R_2005,R_2006,R_2007b,
        R_2007,R_2008,R_2009,R_2010b,R_2010,R_2011,
        R_2012,R_2013b,R_2013,R_2014,R_2015,R_2016,
        R_2017,R_2018b,R_2018,R_2019,R_2020,R_2021,
        R_2022,R_AFTER);

    { was #define dname def_expr }
    function DWG_VERSIONS : longint;      

(* Const before type ignored *)
(* Const before declarator ignored *)
(* Const before type ignored *)
(* Const before declarator ignored *)
  { char[6] mostly }
(* Const before type ignored *)
(* Const before declarator ignored *)

  type
    Tdwg_versions = record
        r : Dwg_Version_Type;
        _type : ^char;
        hdr : ^char;
        desc : ^char;
        dwg_version : uint8_t;
      end;

    DWG_CLASS_STABILITY = (DWG_CLASS_STABLE,DWG_CLASS_UNSTABLE,DWG_CLASS_DEBUGGING,
      DWG_CLASS_UNHANDLED);
  {*
   Object supertypes that exist in dwg-files.
    }

    DWG_OBJECT_SUPERTYPE = (DWG_SUPERTYPE_ENTITY,DWG_SUPERTYPE_OBJECT
      );
  {*
   Object and Entity types that exist in dwg-files.
    }
  { DWG_TYPE_TRACE_old = 0x09, /* old TRACE r10-r11 only */ }
  { 52 SHAPEFILE_CONTROL  }
  { DWG_TYPE_<UNKNOWN> = 0x36,  }
  { DWG_TYPE_<UNKNOWN> = 0x37,  }
  { DWG_TYPE_<UNKNOWN> = 0x3a,  }
  { DWG_TYPE_<UNKNOWN> = 0x3b,  }
  { ??  }
  { 498  }
  { 499  }
  { non-fixed types > 500. not stored as type, but as fixedtype  }
  {DWG_TYPE_PARTIAL_VIEWING_FILTER, }
  { preR13 entities  }
  { pre2.0 entities  }
  { after 1.0 add new types here for binary compat }

    DWG_OBJECT_TYPE = (DWG_TYPE_UNUSED := $00,DWG_TYPE_TEXT := $01,
      DWG_TYPE_ATTRIB := $02,DWG_TYPE_ATTDEF := $03,
      DWG_TYPE_BLOCK := $04,DWG_TYPE_ENDBLK := $05,
      DWG_TYPE_SEQEND := $06,DWG_TYPE_INSERT := $07,
      DWG_TYPE_MINSERT := $08,DWG_TYPE_VERTEX_2D := $0a,
      DWG_TYPE_VERTEX_3D := $0b,DWG_TYPE_VERTEX_MESH := $0c,
      DWG_TYPE_VERTEX_PFACE := $0d,DWG_TYPE_VERTEX_PFACE_FACE := $0e,
      DWG_TYPE_POLYLINE_2D := $0f,DWG_TYPE_POLYLINE_3D := $10,
      DWG_TYPE_ARC := $11,DWG_TYPE_CIRCLE := $12,
      DWG_TYPE_LINE := $13,DWG_TYPE_DIMENSION_ORDINATE := $14,
      DWG_TYPE_DIMENSION_LINEAR := $15,DWG_TYPE_DIMENSION_ALIGNED := $16,
      DWG_TYPE_DIMENSION_ANG3PT := $17,DWG_TYPE_DIMENSION_ANG2LN := $18,
      DWG_TYPE_DIMENSION_RADIUS := $19,DWG_TYPE_DIMENSION_DIAMETER := $1A,
      DWG_TYPE_POINT := $1b,DWG_TYPE__3DFACE := $1c,
      DWG_TYPE_POLYLINE_PFACE := $1d,DWG_TYPE_POLYLINE_MESH := $1e,
      DWG_TYPE_SOLID := $1f,DWG_TYPE_TRACE := $20,
      DWG_TYPE_SHAPE := $21,DWG_TYPE_VIEWPORT := $22,
      DWG_TYPE_ELLIPSE := $23,DWG_TYPE_SPLINE := $24,
      DWG_TYPE_REGION := $25,DWG_TYPE__3DSOLID := $26,
      DWG_TYPE_BODY := $27,DWG_TYPE_RAY := $28,
      DWG_TYPE_XLINE := $29,DWG_TYPE_DICTIONARY := $2a,
      DWG_TYPE_OLEFRAME := $2b,DWG_TYPE_MTEXT := $2c,
      DWG_TYPE_LEADER := $2d,DWG_TYPE_TOLERANCE := $2e,
      DWG_TYPE_MLINE := $2f,DWG_TYPE_BLOCK_CONTROL := $30,
      DWG_TYPE_BLOCK_HEADER := $31,DWG_TYPE_LAYER_CONTROL := $32,
      DWG_TYPE_LAYER := $33,DWG_TYPE_STYLE_CONTROL := $34,
      DWG_TYPE_STYLE := $35,DWG_TYPE_LTYPE_CONTROL := $38,
      DWG_TYPE_LTYPE := $39,DWG_TYPE_VIEW_CONTROL := $3c,
      DWG_TYPE_VIEW := $3d,DWG_TYPE_UCS_CONTROL := $3e,
      DWG_TYPE_UCS := $3f,DWG_TYPE_VPORT_CONTROL := $40,
      DWG_TYPE_VPORT := $41,DWG_TYPE_APPID_CONTROL := $42,
      DWG_TYPE_APPID := $43,DWG_TYPE_DIMSTYLE_CONTROL := $44,
      DWG_TYPE_DIMSTYLE := $45,DWG_TYPE_VX_CONTROL := $46,
      DWG_TYPE_VX_TABLE_RECORD := $47,DWG_TYPE_GROUP := $48,
      DWG_TYPE_MLINESTYLE := $49,DWG_TYPE_OLE2FRAME := $4a,
      DWG_TYPE_DUMMY := $4b,DWG_TYPE_LONG_TRANSACTION := $4c,
      DWG_TYPE_LWPOLYLINE := $4d,DWG_TYPE_HATCH := $4e,
      DWG_TYPE_XRECORD := $4f,DWG_TYPE_PLACEHOLDER := $50,
      DWG_TYPE_VBA_PROJECT := $51,DWG_TYPE_LAYOUT := $52,
      DWG_TYPE_PROXY_ENTITY := $1f2,DWG_TYPE_PROXY_OBJECT := $1f3,
      DWG_TYPE_ACDSRECORD := 500,DWG_TYPE_ACDSSCHEMA,
      DWG_TYPE_ACMECOMMANDHISTORY,DWG_TYPE_ACMESCOPE,
      DWG_TYPE_ACMESTATEMGR,DWG_TYPE_ACSH_BOOLEAN_CLASS,
      DWG_TYPE_ACSH_BOX_CLASS,DWG_TYPE_ACSH_BREP_CLASS,
      DWG_TYPE_ACSH_CHAMFER_CLASS,DWG_TYPE_ACSH_CONE_CLASS,
      DWG_TYPE_ACSH_CYLINDER_CLASS,DWG_TYPE_ACSH_EXTRUSION_CLASS,
      DWG_TYPE_ACSH_FILLET_CLASS,DWG_TYPE_ACSH_HISTORY_CLASS,
      DWG_TYPE_ACSH_LOFT_CLASS,DWG_TYPE_ACSH_PYRAMID_CLASS,
      DWG_TYPE_ACSH_REVOLVE_CLASS,DWG_TYPE_ACSH_SPHERE_CLASS,
      DWG_TYPE_ACSH_SWEEP_CLASS,DWG_TYPE_ACSH_TORUS_CLASS,
      DWG_TYPE_ACSH_WEDGE_CLASS,DWG_TYPE_ALDIMOBJECTCONTEXTDATA,
      DWG_TYPE_ALIGNMENTPARAMETERENTITY,DWG_TYPE_ANGDIMOBJECTCONTEXTDATA,
      DWG_TYPE_ANNOTSCALEOBJECTCONTEXTDATA,
      DWG_TYPE_ARCALIGNEDTEXT,DWG_TYPE_ARC_DIMENSION,
      DWG_TYPE_ASSOC2DCONSTRAINTGROUP,DWG_TYPE_ASSOC3POINTANGULARDIMACTIONBODY,
      DWG_TYPE_ASSOCACTION,DWG_TYPE_ASSOCACTIONPARAM,
      DWG_TYPE_ASSOCALIGNEDDIMACTIONBODY,DWG_TYPE_ASSOCARRAYACTIONBODY,
      DWG_TYPE_ASSOCARRAYMODIFYACTIONBODY,
      DWG_TYPE_ASSOCARRAYMODIFYPARAMETERS,
      DWG_TYPE_ASSOCARRAYPATHPARAMETERS,DWG_TYPE_ASSOCARRAYPOLARPARAMETERS,
      DWG_TYPE_ASSOCARRAYRECTANGULARPARAMETERS,
      DWG_TYPE_ASSOCASMBODYACTIONPARAM,DWG_TYPE_ASSOCBLENDSURFACEACTIONBODY,
      DWG_TYPE_ASSOCCOMPOUNDACTIONPARAM,DWG_TYPE_ASSOCDEPENDENCY,
      DWG_TYPE_ASSOCDIMDEPENDENCYBODY,DWG_TYPE_ASSOCEDGEACTIONPARAM,
      DWG_TYPE_ASSOCEDGECHAMFERACTIONBODY,
      DWG_TYPE_ASSOCEDGEFILLETACTIONBODY,DWG_TYPE_ASSOCEXTENDSURFACEACTIONBODY,
      DWG_TYPE_ASSOCEXTRUDEDSURFACEACTIONBODY,
      DWG_TYPE_ASSOCFACEACTIONPARAM,DWG_TYPE_ASSOCFILLETSURFACEACTIONBODY,
      DWG_TYPE_ASSOCGEOMDEPENDENCY,DWG_TYPE_ASSOCLOFTEDSURFACEACTIONBODY,
      DWG_TYPE_ASSOCMLEADERACTIONBODY,DWG_TYPE_ASSOCNETWORK,
      DWG_TYPE_ASSOCNETWORKSURFACEACTIONBODY,
      DWG_TYPE_ASSOCOBJECTACTIONPARAM,DWG_TYPE_ASSOCOFFSETSURFACEACTIONBODY,
      DWG_TYPE_ASSOCORDINATEDIMACTIONBODY,
      DWG_TYPE_ASSOCOSNAPPOINTREFACTIONPARAM,
      DWG_TYPE_ASSOCPATCHSURFACEACTIONBODY,
      DWG_TYPE_ASSOCPATHACTIONPARAM,DWG_TYPE_ASSOCPERSSUBENTMANAGER,
      DWG_TYPE_ASSOCPLANESURFACEACTIONBODY,
      DWG_TYPE_ASSOCPOINTREFACTIONPARAM,DWG_TYPE_ASSOCRESTOREENTITYSTATEACTIONBODY,
      DWG_TYPE_ASSOCREVOLVEDSURFACEACTIONBODY,
      DWG_TYPE_ASSOCROTATEDDIMACTIONBODY,DWG_TYPE_ASSOCSWEPTSURFACEACTIONBODY,
      DWG_TYPE_ASSOCTRIMSURFACEACTIONBODY,
      DWG_TYPE_ASSOCVALUEDEPENDENCY,DWG_TYPE_ASSOCVARIABLE,
      DWG_TYPE_ASSOCVERTEXACTIONPARAM,DWG_TYPE_BASEPOINTPARAMETERENTITY,
      DWG_TYPE_BLKREFOBJECTCONTEXTDATA,DWG_TYPE_BLOCKALIGNEDCONSTRAINTPARAMETER,
      DWG_TYPE_BLOCKALIGNMENTGRIP,DWG_TYPE_BLOCKALIGNMENTPARAMETER,
      DWG_TYPE_BLOCKANGULARCONSTRAINTPARAMETER,
      DWG_TYPE_BLOCKARRAYACTION,DWG_TYPE_BLOCKBASEPOINTPARAMETER,
      DWG_TYPE_BLOCKDIAMETRICCONSTRAINTPARAMETER,
      DWG_TYPE_BLOCKFLIPACTION,DWG_TYPE_BLOCKFLIPGRIP,
      DWG_TYPE_BLOCKFLIPPARAMETER,DWG_TYPE_BLOCKGRIPLOCATIONCOMPONENT,
      DWG_TYPE_BLOCKHORIZONTALCONSTRAINTPARAMETER,
      DWG_TYPE_BLOCKLINEARCONSTRAINTPARAMETER,
      DWG_TYPE_BLOCKLINEARGRIP,DWG_TYPE_BLOCKLINEARPARAMETER,
      DWG_TYPE_BLOCKLOOKUPACTION,DWG_TYPE_BLOCKLOOKUPGRIP,
      DWG_TYPE_BLOCKLOOKUPPARAMETER,DWG_TYPE_BLOCKMOVEACTION,
      DWG_TYPE_BLOCKPARAMDEPENDENCYBODY,DWG_TYPE_BLOCKPOINTPARAMETER,
      DWG_TYPE_BLOCKPOLARGRIP,DWG_TYPE_BLOCKPOLARPARAMETER,
      DWG_TYPE_BLOCKPOLARSTRETCHACTION,DWG_TYPE_BLOCKPROPERTIESTABLE,
      DWG_TYPE_BLOCKPROPERTIESTABLEGRIP,DWG_TYPE_BLOCKRADIALCONSTRAINTPARAMETER,
      DWG_TYPE_BLOCKREPRESENTATION,DWG_TYPE_BLOCKROTATEACTION,
      DWG_TYPE_BLOCKROTATIONGRIP,DWG_TYPE_BLOCKROTATIONPARAMETER,
      DWG_TYPE_BLOCKSCALEACTION,DWG_TYPE_BLOCKSTRETCHACTION,
      DWG_TYPE_BLOCKUSERPARAMETER,DWG_TYPE_BLOCKVERTICALCONSTRAINTPARAMETER,
      DWG_TYPE_BLOCKVISIBILITYGRIP,DWG_TYPE_BLOCKVISIBILITYPARAMETER,
      DWG_TYPE_BLOCKXYGRIP,DWG_TYPE_BLOCKXYPARAMETER,
      DWG_TYPE_CAMERA,DWG_TYPE_CELLSTYLEMAP,
      DWG_TYPE_CONTEXTDATAMANAGER,DWG_TYPE_CSACDOCUMENTOPTIONS,
      DWG_TYPE_CURVEPATH,DWG_TYPE_DATALINK,
      DWG_TYPE_DATATABLE,DWG_TYPE_DBCOLOR,DWG_TYPE_DETAILVIEWSTYLE,
      DWG_TYPE_DGNDEFINITION,DWG_TYPE_DGNUNDERLAY,
      DWG_TYPE_DICTIONARYVAR,DWG_TYPE_DICTIONARYWDFLT,
      DWG_TYPE_DIMASSOC,DWG_TYPE_DMDIMOBJECTCONTEXTDATA,
      DWG_TYPE_DWFDEFINITION,DWG_TYPE_DWFUNDERLAY,
      DWG_TYPE_DYNAMICBLOCKPROXYNODE,DWG_TYPE_DYNAMICBLOCKPURGEPREVENTER,
      DWG_TYPE_EVALUATION_GRAPH,DWG_TYPE_EXTRUDEDSURFACE,
      DWG_TYPE_FCFOBJECTCONTEXTDATA,DWG_TYPE_FIELD,
      DWG_TYPE_FIELDLIST,DWG_TYPE_FLIPPARAMETERENTITY,
      DWG_TYPE_GEODATA,DWG_TYPE_GEOMAPIMAGE,
      DWG_TYPE_GEOPOSITIONMARKER,DWG_TYPE_GRADIENT_BACKGROUND,
      DWG_TYPE_GROUND_PLANE_BACKGROUND,DWG_TYPE_HELIX,
      DWG_TYPE_IBL_BACKGROUND,DWG_TYPE_IDBUFFER,
      DWG_TYPE_IMAGE,DWG_TYPE_IMAGEDEF,DWG_TYPE_IMAGEDEF_REACTOR,
      DWG_TYPE_IMAGE_BACKGROUND,DWG_TYPE_INDEX,
      DWG_TYPE_LARGE_RADIAL_DIMENSION,DWG_TYPE_LAYERFILTER,
      DWG_TYPE_LAYER_INDEX,DWG_TYPE_LAYOUTPRINTCONFIG,
      DWG_TYPE_LEADEROBJECTCONTEXTDATA,DWG_TYPE_LIGHT,
      DWG_TYPE_LIGHTLIST,DWG_TYPE_LINEARPARAMETERENTITY,
      DWG_TYPE_LOFTEDSURFACE,DWG_TYPE_MATERIAL,
      DWG_TYPE_MENTALRAYRENDERSETTINGS,DWG_TYPE_MESH,
      DWG_TYPE_MLEADEROBJECTCONTEXTDATA,DWG_TYPE_MLEADERSTYLE,
      DWG_TYPE_MOTIONPATH,DWG_TYPE_MPOLYGON,
      DWG_TYPE_MTEXTATTRIBUTEOBJECTCONTEXTDATA,
      DWG_TYPE_MTEXTOBJECTCONTEXTDATA,DWG_TYPE_MULTILEADER,
      DWG_TYPE_NAVISWORKSMODEL,DWG_TYPE_NAVISWORKSMODELDEF,
      DWG_TYPE_NPOCOLLECTION,DWG_TYPE_NURBSURFACE,
      DWG_TYPE_OBJECT_PTR,DWG_TYPE_ORDDIMOBJECTCONTEXTDATA,
      DWG_TYPE_PARTIAL_VIEWING_INDEX,DWG_TYPE_PDFDEFINITION,
      DWG_TYPE_PDFUNDERLAY,DWG_TYPE_PERSUBENTMGR,
      DWG_TYPE_PLANESURFACE,DWG_TYPE_PLOTSETTINGS,
      DWG_TYPE_POINTCLOUD,DWG_TYPE_POINTCLOUDCOLORMAP,
      DWG_TYPE_POINTCLOUDDEF,DWG_TYPE_POINTCLOUDDEFEX,
      DWG_TYPE_POINTCLOUDDEF_REACTOR,DWG_TYPE_POINTCLOUDDEF_REACTOR_EX,
      DWG_TYPE_POINTCLOUDEX,DWG_TYPE_POINTPARAMETERENTITY,
      DWG_TYPE_POINTPATH,DWG_TYPE_POLARGRIPENTITY,
      DWG_TYPE_RADIMLGOBJECTCONTEXTDATA,DWG_TYPE_RADIMOBJECTCONTEXTDATA,
      DWG_TYPE_RAPIDRTRENDERSETTINGS,DWG_TYPE_RASTERVARIABLES,
      DWG_TYPE_RENDERENTRY,DWG_TYPE_RENDERENVIRONMENT,
      DWG_TYPE_RENDERGLOBAL,DWG_TYPE_RENDERSETTINGS,
      DWG_TYPE_REVOLVEDSURFACE,DWG_TYPE_ROTATIONPARAMETERENTITY,
      DWG_TYPE_RTEXT,DWG_TYPE_SCALE,DWG_TYPE_SECTIONOBJECT,
      DWG_TYPE_SECTIONVIEWSTYLE,DWG_TYPE_SECTION_MANAGER,
      DWG_TYPE_SECTION_SETTINGS,DWG_TYPE_SKYLIGHT_BACKGROUND,
      DWG_TYPE_SOLID_BACKGROUND,DWG_TYPE_SORTENTSTABLE,
      DWG_TYPE_SPATIAL_FILTER,DWG_TYPE_SPATIAL_INDEX,
      DWG_TYPE_SUN,DWG_TYPE_SUNSTUDY,DWG_TYPE_SWEPTSURFACE,
      DWG_TYPE_TABLE,DWG_TYPE_TABLECONTENT,
      DWG_TYPE_TABLEGEOMETRY,DWG_TYPE_TABLESTYLE,
      DWG_TYPE_TEXTOBJECTCONTEXTDATA,DWG_TYPE_TVDEVICEPROPERTIES,
      DWG_TYPE_VISIBILITYGRIPENTITY,DWG_TYPE_VISIBILITYPARAMETERENTITY,
      DWG_TYPE_VISUALSTYLE,DWG_TYPE_WIPEOUT,
      DWG_TYPE_WIPEOUTVARIABLES,DWG_TYPE_XREFPANELOBJECT,
      DWG_TYPE_XYPARAMETERENTITY,DWG_TYPE_BREAKDATA,
      DWG_TYPE_BREAKPOINTREF,DWG_TYPE_FLIPGRIPENTITY,
      DWG_TYPE_LINEARGRIPENTITY,DWG_TYPE_ROTATIONGRIPENTITY,
      DWG_TYPE_XYGRIPENTITY,DWG_TYPE__3DLINE,
      DWG_TYPE_REPEAT,DWG_TYPE_ENDREP,DWG_TYPE_LOAD,
      DWG_TYPE_FREED := $fffd,DWG_TYPE_UNKNOWN_ENT := $fffe,
      DWG_TYPE_UNKNOWN_OBJ := $ffff);
  { i.e. all the added table or iterator objects (mspace block) }
  { includes also MINSERT }
  { also mesh/pfaces }
  { also mesh/pface vertices }
  { all types }

    DWG_OBJECT_TYPE_R11 = (DWG_TYPE_UNUSED_R11 := 0,DWG_TYPE_LINE_R11 := 1,
      DWG_TYPE_POINT_R11 := 2,DWG_TYPE_CIRCLE_R11 := 3,
      DWG_TYPE_SHAPE_R11 := 4,DWG_TYPE_REPEAT_R11 := 5,
      DWG_TYPE_ENDREP_R11 := 6,DWG_TYPE_TEXT_R11 := 7,
      DWG_TYPE_ARC_R11 := 8,DWG_TYPE_TRACE_R11 := 9,
      DWG_TYPE_LOAD_R11 := 10,DWG_TYPE_SOLID_R11 := 11,
      DWG_TYPE_BLOCK_R11 := 12,DWG_TYPE_ENDBLK_R11 := 13,
      DWG_TYPE_INSERT_R11 := 14,DWG_TYPE_ATTDEF_R11 := 15,
      DWG_TYPE_ATTRIB_R11 := 16,DWG_TYPE_SEQEND_R11 := 17,
      DWG_TYPE_PLINE_R11 := 18,DWG_TYPE_POLYLINE_R11 := 19,
      DWG_TYPE_VERTEX_R11 := 20,DWG_TYPE_3DLINE_R11 := 21,
      DWG_TYPE_3DFACE_R11 := 22,DWG_TYPE_DIMENSION_R11 := 23,
      DWG_TYPE_VIEWPORT_R11 := 24,DWG_TYPE_UNKNOWN_R11 := 25
      );
  {*
   Error codes returned.
    }
  { sorted by severity  }
  { 2  }
  { 4  }
  { 8  }
  { 16  }
  { 32  }
  { 64  }
  { -------- critical errors -------  }
  { 128  }
  { 256  }
  { 512  }
  { 1024  }
  { 2048  }
  { 4096  }
  { 8192  }

    DWG_ERROR = (DWG_NOERR := 0,DWG_ERR_WRONGCRC := 1,
      DWG_ERR_NOTYETSUPPORTED := 1 shl 1,DWG_ERR_UNHANDLEDCLASS := 1 shl 2,
      DWG_ERR_INVALIDTYPE := 1 shl 3,DWG_ERR_INVALIDHANDLE := 1 shl 4,
      DWG_ERR_INVALIDEED := 1 shl 5,DWG_ERR_VALUEOUTOFBOUNDS := 1 shl 6,
      DWG_ERR_CLASSESNOTFOUND := 1 shl 7,DWG_ERR_SECTIONNOTFOUND := 1 shl 8,
      DWG_ERR_PAGENOTFOUND := 1 shl 9,DWG_ERR_INTERNALERROR := 1 shl 10,
      DWG_ERR_INVALIDDWG := 1 shl 11,DWG_ERR_IOERROR := 1 shl 12,
      DWG_ERR_OUTOFMEM := 1 shl 13);

  const
    DWG_ERR_CRITICAL = DWG_ERR_CLASSESNOTFOUND;    
  {*
     handles resolve absolute or relative indices to objects.
  
     code 2-5: represents the type of the relation: hard/soft, owner/id.
  
     code TYPEDOBJHANDLE:
      2 Soft owner,
      3 Hard owner,
      4 Soft pointer,
      5 Hard pointer
  
     code > 6: the handle is stored as an offset from some other handle.
  
     code OFFSETOBJHANDLE for soft owners or pointers:
      6 ref + 1,
      8 ref - 1,
      a ref + offset,
      c ref - offset
  
    See \ref Dwg_Handle
    }
  {!< OFFSETOBJHANDLE if > 6  }
  { to be freed or not }

  type
    _dwg_handle = record
        code : BITCODE_RC;
        size : BITCODE_RC;
        value : dword;
        is_global : BITCODE_B;
      end;
    Dwg_Handle = _dwg_handle;

  const
    FORMAT_H = '%u.%u.%lX';    
(* error 
#define ARGS_H(hdl) (hdl).code, (hdl).size, (hdl).value
in define line 769 *)
      FORMAT_REF = '(%u.%u.%lX) abs:%lX';      
(* error 
#define ARGS_REF(ref) (ref)->handleref.code, (ref)->handleref.size, \
in define line 772 *)
    {*
    object references: obj is resolved by handleref (e.g. via
    dwg_resolve_handleref) when reading a DWG to the respective \ref
    Dwg_Object, and absolute_ref is resolved to the global
    _dwg_struct::object_ref index. It is the same as the hex number in the
    DXF handles.
    
    Used as \ref Dwg_Object_Ref
     }
    { preR13 only, the TABLE index (also used for DXF) }

    type
      _dwg_object_ref = record
          obj : ^_dwg_object;
          handleref : Dwg_Handle;
          absolute_ref : dword;
          r11_idx : BITCODE_RS;
        end;
      Dwg_Object_Ref = _dwg_object_ref;

      BITCODE_H = ^Dwg_Object_Ref;
    { can be relative }

      DWG_HDL_CODE = (DWG_HDL_OWNER := 0,DWG_HDL_SOFTOWN := 2,
        DWG_HDL_HARDOWN := 3,DWG_HDL_SOFTPTR := 4,
        DWG_HDL_HARDPTR := 5);
    {*
     CMC or ENC colors: color index or rgb value. layers are off when the index
     is negative.
     Used as \ref Dwg_Color
      }
    { CmColor: R15 and earlier  }
    { <0: turned off. 0: BYBLOCK, 256: BYLAYER  }
    { 1: has name, 2: has book_name.  }
    { ENC only  }
    { DXF 420  }
    { first byte of rgb:
                             0xc0 for ByLayer (also c3 and rgb of 0x100)
                             0xc1 for ByBlock (also c3 and rgb of 0)
                             0xc2 for entities (default), with names with an additional name flag RC,
                             0xc3 for truecolor,
                             0xc5 for foreground color
                             0xc8 for none (also c3 and rgb of 0x101)
                            }
    { DXF 430  }
    { DXF 430, DXF: "book_name$name"  }
    { Entities only: }
    { 0 BYLAYER, 1 BYBLOCK, 3 alpha  }
    { DXF 440. 0-255  }

      _dwg_color = record
          index : BITCODE_BSd;
          flag : BITCODE_BS;
          raw : BITCODE_BS;
          rgb : BITCODE_BL;
          method : dword;
          name : BITCODE_T;
          book_name : BITCODE_T;
          handle : BITCODE_H;
          alpha_type : BITCODE_BB;
          alpha : BITCODE_RC;
        end;
      Dwg_Color = _dwg_color;

      BITCODE_CMC = Dwg_Color;

      BITCODE_CMTC = Dwg_Color;
    { truecolor even before r2004 }

      BITCODE_ENC = Dwg_Color;
(* error 
EXPORT const char* dwg_color_method_name (unsigned method);
 in declarator_list *)
    {*
     ASCII or Unicode text in xdata \ref Dwg_Resbuf
      }
      _dwg_binary_chunk = record
          size : word;
          flag0 : word;
          u : record
              case longint of
                0 : ( data : ^char );
                1 : ( wdata : ^DWGCHAR );
              end;
        end;


    {*
     result buffers: xdata linked list of dxf group - value pairs.
     Used as \ref Dwg_Resbuf
      }

      _dwg_resbuf = record
          _type : smallint;
          value : record
              case longint of
                0 : ( pt : array[0..2] of double );
                1 : ( i8 : char );
                2 : ( i16 : smallint );
                3 : ( i32 : longint );
                4 : ( i64 : BITCODE_BLL );
                5 : ( dbl : double );
                6 : ( hdl : array[0..7] of byte );
                7 : ( h : Dwg_Handle );
                8 : ( str : _dwg_binary_chunk );
              end;
          nextrb : ^_dwg_resbuf;
        end;
      Dwg_Resbuf = _dwg_resbuf;
    {*
     \struct Dwg_Header_Variables
     DWG header variables for all versions.
     If uppercase related to the DXF HEADER $ name.
    
     \ref _dwg_header_variables
      }
    {!< r2010+  }
    {!< r13+  }
    {!< r2013+  }
    {!< r10+  }
    { 412148564080.0  }
    { 1.0  }
    { 1.0  }
    { 1.0  }
    { "" 4x pre 2007...  }
    { ""  }
    { ""  }
    { ""  }
    { 24L  }
    { 0L  }
    { 0 r13-r14  }
    {!< r11-r2000 code 5, no DXF  }
    { undocumented  }
    { -r11  }
    { Undocumented  }
    {some r13 only }
    { 0 English, 1 Metric. Stored as Section 4  }
    { <r14: default 1  }
    {!< code 5, DXF 8  }
    {!< code 5, DXF 7  }
    {!< code 5, DXF 6  }
    {!< r2007+ code 5, no DXF  }
    {!< code 5, DXF 2  }
    {!< code 5, DXF 2  }
    {!< r13+ ...  }
    {!< r13+ code 5, DXF 2  }
    {!< r2000+ code 5, DXF 2  }
    {!< r2000+ code 5, DXF 2  }
    { -r11  }
    { -r11  }
    { -r11  }
    { -r11  }
    { -r11  }
    { -r11  }
    { -r11  }
    { -r11  }
    { -r11  }
    { -r11  }
    { -r11  }
    { -r11  }
    {!< code 5, DXF 2  }
    {!< code 5, DXF 2  }
    {!< code 5, DXF 2  }
    {!< r13-r14 only RC  }
    {!< r13-r14 only RC  }
    {!< r13-r14 only RC  }
    {!< r13-r14 only RC  }
    {!< r13-r14 only RC  }
    {!< r13-r14 only RC  }
    {!< r13-r14 only RC  }
    {!< r13-r14 only RC  }
    {!< r13-r14 only RC  }
    {!< code 5, DXF 7  }
    { preR13 => handle  }
    { r10-r11  }
    { preR13 => CMC  }
    {!< r2000+ ...  }
    {!< r2007+  }
    {!< r2010+  }
    {!< r2010+  }
    {!< r2010+  }
    {!< r2010+  }
    {!< r2010+  }
    {BITCODE_H DIMTXSTY; }    {!< r2000+  }
    {!< r2000+ code 5, DXF 1  }
    {!< r2000+ code 5, DXF 1  }
    {!< r2000+ code 5, DXF 1  }
    {!< r2000+ code 5, DXF 1  }
    {!< r2007+ code 5, DXF 6  }
    {!< r2007+ code 5, DXF 6  }
    {!< r2007+ code 5, DXF 6  }
    {!< r2000+  }
    {!< r2000+  }
    {!< code 3  }
    {!< code 3  }
    {!< code 3  }
    {!< code 3  }
    {!< code 3  }
    {!< code 3  }
    {!< code 3  }
    {!< code 3  }
    {!< code 3  }
    {!< r11-r2000 code 3  }
    {!< code 5  }
    {!< code 5  }
    {!< code 5, the "NOD"  }
    {!< r2000+  }
    {!< r2000+  }
    {!< r2000+  }
    {!< r2000+  }
    {!< r2000+ code 5  }
    {!< r2000+ code 5  }
    {!< r2000+ code 5  }
    {!< r2004+ code 5  }
    {!< r2004+ code 5  }
    {!< r2007+ code 5  }
    {!< r2010+ code 5 ??  }
    {!< r2013+ code 5 LIGHTLIST?  }
    {!< = FLAGS & 0x1f, see dxf_cvt_lweight() DXF 370 (int16)  }
    {!< = FLAGS & 0x60  }
    {!< = FLAGS & 0x180  }
    {!< = !(FLAGS & 0x200)  }
    {!< = !(FLAGS & 0x400)  }
    {!< = FLAGS & 0x800  }
    {!< = FLAGS & 0x2000  }
    {!< = FLAGS & 0x4000  }
    {!< when CEPSNTYPE = 3, code 5  }
    {!< code 5  }
    {!< code 5  }
    {!< code 5  }
    {!< code 5  }
    {!< code 5  }
    {!< r2007+ ...  }
    {!< r2007+ code 5, DXF 345 VISUALSTYLE  }
    {!< r2007+ code 5, DXF 346 VISUALSTYLE  }
    {!< r2007+ code 5, DXF 349 VISUALSTYLE  }
    {!< r14+ ... optional  }
    { -r1.40  }
    { r2.0 - r10  }
    { r11, or RD  }
    { r11  }
    { r1.2 - r1.4  }
    { r11  }
    { r11  }
    { r11  }
    { r11  }
    { r11  }
    { r11  }

      _dwg_header_variables = record
          size : BITCODE_RL;
          bitsize_hi : BITCODE_RL;
          bitsize : BITCODE_RL;
          ACADMAINTVER : BITCODE_RC;
          REQUIREDVERSIONS : BITCODE_BLL;
          DWGCODEPAGE : BITCODE_TV;
          unknown_0 : BITCODE_BD;
          unknown_1 : BITCODE_BD;
          unknown_2 : BITCODE_BD;
          unknown_3 : BITCODE_BD;
          unknown_text1 : BITCODE_TV;
          unknown_text2 : BITCODE_TV;
          unknown_text3 : BITCODE_TV;
          unknown_text4 : BITCODE_TV;
          unknown_8 : BITCODE_BL;
          unknown_9 : BITCODE_BL;
          unknown_10 : BITCODE_BS;
          unknown_18 : BITCODE_BS;
          VX_TABLE_RECORD : BITCODE_H;
          DIMASO : BITCODE_B;
          DIMSHO : BITCODE_B;
          DIMSAV : BITCODE_B;
          PLINEGEN : BITCODE_B;
          ORTHOMODE : BITCODE_B;
          REGENMODE : BITCODE_B;
          FILLMODE : BITCODE_B;
          QTEXTMODE : BITCODE_B;
          PSLTSCALE : BITCODE_B;
          LIMCHECK : BITCODE_B;
          BLIPMODE : BITCODE_B;
          unknown_11 : BITCODE_B;
          USRTIMER : BITCODE_B;
          FASTZOOM : BITCODE_B;
          FLATLAND : BITCODE_B;
          VIEWMODE : BITCODE_B;
          SKPOLY : BITCODE_B;
          ANGDIR : BITCODE_B;
          SPLFRAME : BITCODE_B;
          ATTREQ : BITCODE_B;
          ATTDIA : BITCODE_B;
          MIRRTEXT : BITCODE_B;
          WORLDVIEW : BITCODE_B;
          WIREFRAME : BITCODE_B;
          TILEMODE : BITCODE_B;
          PLIMCHECK : BITCODE_B;
          VISRETAIN : BITCODE_B;
          DELOBJ : BITCODE_B;
          DISPSILH : BITCODE_B;
          PELLIPSE : BITCODE_B;
          SAVEIMAGES : BITCODE_BS;
          PROXYGRAPHICS : BITCODE_BS;
          MEASUREMENT : BITCODE_BS;
          DRAGMODE : BITCODE_BS;
          TREEDEPTH : BITCODE_BS;
          LUNITS : BITCODE_BS;
          LUPREC : BITCODE_BS;
          AUNITS : BITCODE_BS;
          AUPREC : BITCODE_BS;
          ATTMODE : BITCODE_BS;
          COORDS : BITCODE_BS;
          PDMODE : BITCODE_BS;
          PICKSTYLE : BITCODE_BS;
          OSMODE : BITCODE_BL;
          unknown_12 : BITCODE_BL;
          unknown_13 : BITCODE_BL;
          unknown_14 : BITCODE_BL;
          USERI1 : BITCODE_BS;
          USERI2 : BITCODE_BS;
          USERI3 : BITCODE_BS;
          USERI4 : BITCODE_BS;
          USERI5 : BITCODE_BS;
          SPLINESEGS : BITCODE_BS;
          SURFU : BITCODE_BS;
          SURFV : BITCODE_BS;
          SURFTYPE : BITCODE_BS;
          SURFTAB1 : BITCODE_BS;
          SURFTAB2 : BITCODE_BS;
          SPLINETYPE : BITCODE_BS;
          SHADEDGE : BITCODE_BS;
          SHADEDIF : BITCODE_BS;
          UNITMODE : BITCODE_BS;
          MAXACTVP : BITCODE_BS;
          ISOLINES : BITCODE_BS;
          CMLJUST : BITCODE_BS;
          TEXTQLTY : BITCODE_BS;
          unknown_14b : BITCODE_BL;
          LTSCALE : BITCODE_BD;
          TEXTSIZE : BITCODE_BD;
          TRACEWID : BITCODE_BD;
          SKETCHINC : BITCODE_BD;
          FILLETRAD : BITCODE_BD;
          THICKNESS : BITCODE_BD;
          ANGBASE : BITCODE_BD;
          PDSIZE : BITCODE_BD;
          PLINEWID : BITCODE_BD;
          USERR1 : BITCODE_BD;
          USERR2 : BITCODE_BD;
          USERR3 : BITCODE_BD;
          USERR4 : BITCODE_BD;
          USERR5 : BITCODE_BD;
          CHAMFERA : BITCODE_BD;
          CHAMFERB : BITCODE_BD;
          CHAMFERC : BITCODE_BD;
          CHAMFERD : BITCODE_BD;
          FACETRES : BITCODE_BD;
          CMLSCALE : BITCODE_BD;
          CELTSCALE : BITCODE_BD;
          VIEWTWIST : BITCODE_BD;
          MENU : BITCODE_TV;
          TDCREATE : BITCODE_TIMEBLL;
          TDUPDATE : BITCODE_TIMEBLL;
          TDUCREATE : BITCODE_TIMEBLL;
          TDUUPDATE : BITCODE_TIMEBLL;
          unknown_15 : BITCODE_BL;
          unknown_16 : BITCODE_BL;
          unknown_17 : BITCODE_BL;
          TDINDWG : BITCODE_TIMEBLL;
          TDUSRTIMER : BITCODE_TIMEBLL;
          CECOLOR : BITCODE_CMC;
          HANDLING : BITCODE_BS;
          HANDSEED : BITCODE_H;
          unknown_5 : BITCODE_RS;
          unknown_6 : BITCODE_RS;
          unknown_7 : BITCODE_RD;
          CLAYER : BITCODE_H;
          TEXTSTYLE : BITCODE_H;
          CELTYPE : BITCODE_H;
          CMATERIAL : BITCODE_H;
          DIMSTYLE : BITCODE_H;
          CMLSTYLE : BITCODE_H;
          PSVPSCALE : BITCODE_BD;
          PINSBASE : BITCODE_3BD;
          PEXTMIN : BITCODE_3BD;
          PEXTMAX : BITCODE_3BD;
          PLIMMIN : BITCODE_2DPOINT;
          PLIMMAX : BITCODE_2DPOINT;
          PELEVATION : BITCODE_BD;
          PUCSORG : BITCODE_3BD;
          PUCSXDIR : BITCODE_3BD;
          PUCSYDIR : BITCODE_3BD;
          PUCSNAME : BITCODE_H;
          PUCSBASE : BITCODE_H;
          PUCSORTHOREF : BITCODE_H;
          PUCSORTHOVIEW : BITCODE_BS;
          PUCSORGTOP : BITCODE_3BD;
          PUCSORGBOTTOM : BITCODE_3BD;
          PUCSORGLEFT : BITCODE_3BD;
          PUCSORGRIGHT : BITCODE_3BD;
          PUCSORGFRONT : BITCODE_3BD;
          PUCSORGBACK : BITCODE_3BD;
          INSBASE : BITCODE_3BD;
          EXTMIN : BITCODE_3BD;
          EXTMAX : BITCODE_3BD;
          VIEWDIR : BITCODE_3BD;
          TARGET : BITCODE_3BD;
          LIMMIN : BITCODE_2DPOINT;
          LIMMAX : BITCODE_2DPOINT;
          VIEWCTR : BITCODE_3RD;
          ELEVATION : BITCODE_BD;
          VIEWSIZE : BITCODE_RD;
          SNAPMODE : BITCODE_RS;
          SNAPUNIT : BITCODE_2RD;
          SNAPBASE : BITCODE_2RD;
          SNAPANG : BITCODE_RD;
          SNAPSTYLE : BITCODE_RS;
          SNAPISOPAIR : BITCODE_RS;
          GRIDMODE : BITCODE_RS;
          GRIDUNIT : BITCODE_2RD;
          AXISMODE : BITCODE_BS;
          AXISUNIT : BITCODE_2RD;
          UCSORG : BITCODE_3BD;
          UCSXDIR : BITCODE_3BD;
          UCSYDIR : BITCODE_3BD;
          UCSNAME : BITCODE_H;
          UCSBASE : BITCODE_H;
          UCSORTHOVIEW : BITCODE_BS;
          UCSORTHOREF : BITCODE_H;
          UCSORGTOP : BITCODE_3BD;
          UCSORGBOTTOM : BITCODE_3BD;
          UCSORGLEFT : BITCODE_3BD;
          UCSORGRIGHT : BITCODE_3BD;
          UCSORGFRONT : BITCODE_3BD;
          UCSORGBACK : BITCODE_3BD;
          DIMPOST : BITCODE_TV;
          DIMAPOST : BITCODE_TV;
          DIMTOL : BITCODE_B;
          DIMLIM : BITCODE_B;
          DIMTIH : BITCODE_B;
          DIMTOH : BITCODE_B;
          DIMSE1 : BITCODE_B;
          DIMSE2 : BITCODE_B;
          DIMALT : BITCODE_B;
          DIMTOFL : BITCODE_B;
          DIMSAH : BITCODE_B;
          DIMTIX : BITCODE_B;
          DIMSOXD : BITCODE_B;
          DIMALTD : BITCODE_BS;
          DIMZIN : BITCODE_BS;
          DIMSD1 : BITCODE_B;
          DIMSD2 : BITCODE_B;
          DIMTOLJ : BITCODE_BS;
          DIMJUST : BITCODE_BS;
          DIMFIT : BITCODE_BS;
          DIMUPT : BITCODE_B;
          DIMTZIN : BITCODE_BS;
          DIMMALTZ : BITCODE_BS;
          DIMMALTTZ : BITCODE_BS;
          DIMTAD : BITCODE_BS;
          DIMUNIT : BITCODE_BS;
          DIMAUNIT : BITCODE_BS;
          DIMDEC : BITCODE_BS;
          DIMTDEC : BITCODE_BS;
          DIMALTU : BITCODE_BS;
          DIMALTTD : BITCODE_BS;
          DIMTXSTY : BITCODE_H;
          DIMSCALE : BITCODE_BD;
          DIMASZ : BITCODE_BD;
          DIMEXO : BITCODE_BD;
          DIMDLI : BITCODE_BD;
          DIMEXE : BITCODE_BD;
          DIMRND : BITCODE_BD;
          DIMDLE : BITCODE_BD;
          DIMTP : BITCODE_BD;
          DIMTM : BITCODE_BD;
          DIMFXL : BITCODE_BD;
          DIMJOGANG : BITCODE_BD;
          DIMTFILL : BITCODE_BS;
          DIMTFILLCLR : BITCODE_CMC;
          DIMAZIN : BITCODE_BS;
          DIMARCSYM : BITCODE_BS;
          DIMTXT : BITCODE_BD;
          DIMCEN : BITCODE_BD;
          DIMTSZ : BITCODE_BD;
          DIMALTF : BITCODE_BD;
          DIMLFAC : BITCODE_BD;
          DIMTVP : BITCODE_BD;
          DIMTFAC : BITCODE_BD;
          DIMGAP : BITCODE_BD;
          DIMPOST_T : BITCODE_T;
          DIMAPOST_T : BITCODE_T;
          DIMBLK_T : BITCODE_T;
          DIMBLK1_T : BITCODE_T;
          DIMBLK2_T : BITCODE_T;
          unknown_string : BITCODE_T;
          DIMALTRND : BITCODE_BD;
          DIMCLRD_C : BITCODE_RS;
          DIMCLRE_C : BITCODE_RS;
          DIMCLRT_C : BITCODE_RS;
          DIMCLRD : BITCODE_CMC;
          DIMCLRE : BITCODE_CMC;
          DIMCLRT : BITCODE_CMC;
          DIMADEC : BITCODE_BS;
          DIMFRAC : BITCODE_BS;
          DIMLUNIT : BITCODE_BS;
          DIMDSEP : BITCODE_BS;
          DIMTMOVE : BITCODE_BS;
          DIMALTZ : BITCODE_BS;
          DIMALTTZ : BITCODE_BS;
          DIMATFIT : BITCODE_BS;
          DIMFXLON : BITCODE_B;
          DIMTXTDIRECTION : BITCODE_B;
          DIMALTMZF : BITCODE_BD;
          DIMALTMZS : BITCODE_T;
          DIMMZF : BITCODE_BD;
          DIMMZS : BITCODE_T;
          DIMLDRBLK : BITCODE_H;
          DIMBLK : BITCODE_H;
          DIMBLK1 : BITCODE_H;
          DIMBLK2 : BITCODE_H;
          DIMLTYPE : BITCODE_H;
          DIMLTEX1 : BITCODE_H;
          DIMLTEX2 : BITCODE_H;
          DIMLWD : BITCODE_BSd;
          DIMLWE : BITCODE_BSd;
          BLOCK_CONTROL_OBJECT : BITCODE_H;
          LAYER_CONTROL_OBJECT : BITCODE_H;
          STYLE_CONTROL_OBJECT : BITCODE_H;
          LTYPE_CONTROL_OBJECT : BITCODE_H;
          VIEW_CONTROL_OBJECT : BITCODE_H;
          UCS_CONTROL_OBJECT : BITCODE_H;
          VPORT_CONTROL_OBJECT : BITCODE_H;
          APPID_CONTROL_OBJECT : BITCODE_H;
          DIMSTYLE_CONTROL_OBJECT : BITCODE_H;
          VX_CONTROL_OBJECT : BITCODE_H;
          DICTIONARY_ACAD_GROUP : BITCODE_H;
          DICTIONARY_ACAD_MLINESTYLE : BITCODE_H;
          DICTIONARY_NAMED_OBJECT : BITCODE_H;
          TSTACKALIGN : BITCODE_BS;
          TSTACKSIZE : BITCODE_BS;
          HYPERLINKBASE : BITCODE_T;
          STYLESHEET : BITCODE_TV;
          DICTIONARY_LAYOUT : BITCODE_H;
          DICTIONARY_PLOTSETTINGS : BITCODE_H;
          DICTIONARY_PLOTSTYLENAME : BITCODE_H;
          DICTIONARY_MATERIAL : BITCODE_H;
          DICTIONARY_COLOR : BITCODE_H;
          DICTIONARY_VISUALSTYLE : BITCODE_H;
          DICTIONARY_LIGHTLIST : BITCODE_H;
          unknown_20 : BITCODE_H;
          FLAGS : BITCODE_BL;
          CELWEIGHT : BITCODE_BSd;
          ENDCAPS : BITCODE_B;
          JOINSTYLE : BITCODE_B;
          LWDISPLAY : BITCODE_B;
          XEDIT : BITCODE_B;
          EXTNAMES : BITCODE_B;
          PSTYLEMODE : BITCODE_B;
          OLESTARTUP : BITCODE_B;
          INSUNITS : BITCODE_BS;
          CEPSNTYPE : BITCODE_BS;
          CPSNID : BITCODE_H;
          FINGERPRINTGUID : BITCODE_TV;
          VERSIONGUID : BITCODE_TV;
          SORTENTS : BITCODE_RC;
          INDEXCTL : BITCODE_RC;
          HIDETEXT : BITCODE_RC;
          XCLIPFRAME : BITCODE_RC;
          DIMASSOC : BITCODE_RC;
          HALOGAP : BITCODE_RC;
          OBSCOLOR : BITCODE_BS;
          INTERSECTIONCOLOR : BITCODE_BS;
          OBSLTYPE : BITCODE_RC;
          INTERSECTIONDISPLAY : BITCODE_RC;
          PROJECTNAME : BITCODE_TV;
          BLOCK_RECORD_PSPACE : BITCODE_H;
          BLOCK_RECORD_MSPACE : BITCODE_H;
          LTYPE_BYLAYER : BITCODE_H;
          LTYPE_BYBLOCK : BITCODE_H;
          LTYPE_CONTINUOUS : BITCODE_H;
          CAMERADISPLAY : BITCODE_B;
          unknown_21 : BITCODE_BL;
          unknown_22 : BITCODE_BL;
          unknown_23 : BITCODE_BD;
          STEPSPERSEC : BITCODE_BD;
          STEPSIZE : BITCODE_BD;
          _3DDWFPREC : BITCODE_BD;
          LENSLENGTH : BITCODE_BD;
          CAMERAHEIGHT : BITCODE_BD;
          SOLIDHIST : BITCODE_RC;
          SHOWHIST : BITCODE_RC;
          PSOLWIDTH : BITCODE_BD;
          PSOLHEIGHT : BITCODE_BD;
          LOFTANG1 : BITCODE_BD;
          LOFTANG2 : BITCODE_BD;
          LOFTMAG1 : BITCODE_BD;
          LOFTMAG2 : BITCODE_BD;
          LOFTPARAM : BITCODE_BS;
          LOFTNORMALS : BITCODE_RC;
          LATITUDE : BITCODE_BD;
          LONGITUDE : BITCODE_BD;
          NORTHDIRECTION : BITCODE_BD;
          TIMEZONE : BITCODE_BL;
          LIGHTGLYPHDISPLAY : BITCODE_RC;
          TILEMODELIGHTSYNCH : BITCODE_RC;
          DWFFRAME : BITCODE_RC;
          DGNFRAME : BITCODE_RC;
          REALWORLDSCALE : BITCODE_B;
          INTERFERECOLOR : BITCODE_CMC;
          INTERFEREOBJVS : BITCODE_H;
          INTERFEREVPVS : BITCODE_H;
          DRAGVS : BITCODE_H;
          CSHADOW : BITCODE_RC;
          SHADOWPLANELOCATION : BITCODE_BD;
          unknown_54 : BITCODE_BS;
          unknown_55 : BITCODE_BS;
          unknown_56 : BITCODE_BS;
          unknown_57 : BITCODE_BS;
          dwg_size : BITCODE_RL;
          numentities : BITCODE_RS;
          circle_zoom_percent : BITCODE_RS;
          unknown_58 : BITCODE_RC;
          unknown_59 : BITCODE_RC;
          unknown_60 : BITCODE_RC;
          FRONTZ : BITCODE_BD;
          BACKZ : BITCODE_BD;
          UCSICON : BITCODE_RC;
          oldCECOLOR_hi : BITCODE_RL;
          oldCECOLOR_lo : BITCODE_RL;
          layer_colors : array[0..127] of BITCODE_RS;
          unknown_51e : BITCODE_RS;
          unknown_520 : BITCODE_RS;
          unknown_unit1 : BITCODE_T;
          unknown_unit2 : BITCODE_T;
          unknown_unit3 : BITCODE_T;
          unknown_unit4 : BITCODE_T;
        end;
      Dwg_Header_Variables = _dwg_header_variables;
    { OBJECTS ****************************************************************** }
    {*
     UNUSED (0) entity. Unknown entities are stored as blob
      }

      Dwg_Entity_UNUSED = longint;
    {* \ref Dwg_Entity_TEXT
     TEXT (1/7) entity
      }
    {!< r2000+. should be renamed to opts for r11 compat  }
    {!< DXF 30 (z coord of 10), when dataflags & 1  }
    {!< DXF 10  }
    {!< DXF 11. optional, when dataflags & 2, i.e 72/73 != 0  }
    {!< DXF 210. Default 0,0,1  }
    {!< DXF 39  }
    {!< DXF 51  }
    {!< DXF 50  }
    {!< DXF 40  }
    {!< DXF 41  }
    {!< DXF 1  }
    {!< DXF 71  }
    {!< DXF 72. options 0-5:
                                     0 = Left; 1= Center; 2 = Right; 3 = Aligned;
                                     4 = Middle; 5 = Fit  }
    {!< DXF 73. options 0-3:
                                     0 = Baseline; 1 = Bottom; 2 = Middle; 3 = Top  }
    {!< code 5, DXF 7, optional  }

      _dwg_entity_TEXT = record
          parent : ^_dwg_object_entity;
          dataflags : BITCODE_RC;
          elevation : BITCODE_RD;
          ins_pt : BITCODE_2DPOINT;
          alignment_pt : BITCODE_2DPOINT;
          extrusion : BITCODE_BE;
          thickness : BITCODE_RD;
          oblique_angle : BITCODE_RD;
          rotation : BITCODE_RD;
          height : BITCODE_RD;
          width_factor : BITCODE_RD;
          text_value : BITCODE_T;
          generation : BITCODE_BS;
          horiz_alignment : BITCODE_BS;
          vert_alignment : BITCODE_BS;
          style : BITCODE_H;
        end;
      Dwg_Entity_TEXT = _dwg_entity_TEXT;
    {* \ref Dwg_Entity_ATTRIB
     ATTRIB (2/16) entity
      }
    { R2010+  }
    { R2018+  }
    { DXF 73 but unused  }
    { bitmask of:
                           0 none
                           1 invisible, overridden by ATTDISP
                           2 constant, no prompt
                           4 verify on insert
                           8 preset, inserted only with its default values, not editable.  }
    { R2018+ TODO  }
    { R2018+  }

      _dwg_entity_ATTRIB = record
          parent : ^_dwg_object_entity;
          elevation : BITCODE_BD;
          ins_pt : BITCODE_2DPOINT;
          alignment_pt : BITCODE_2DPOINT;
          extrusion : BITCODE_BE;
          thickness : BITCODE_RD;
          oblique_angle : BITCODE_RD;
          rotation : BITCODE_RD;
          height : BITCODE_RD;
          width_factor : BITCODE_RD;
          text_value : BITCODE_T;
          generation : BITCODE_BS;
          horiz_alignment : BITCODE_BS;
          vert_alignment : BITCODE_BS;
          dataflags : BITCODE_RC;
          class_version : BITCODE_RC;
          _type : BITCODE_RC;
          tag : BITCODE_T;
          field_length : BITCODE_BS;
          flags : BITCODE_RC;
          lock_position_flag : BITCODE_B;
          style : BITCODE_H;
          mtext_handles : BITCODE_H;
          annotative_data_size : BITCODE_BS;
          annotative_data_bytes : BITCODE_RC;
          annotative_app : BITCODE_H;
          annotative_short : BITCODE_BS;
        end;
      Dwg_Entity_ATTRIB = _dwg_entity_ATTRIB;
    {* \ref Dwg_Entity_ATTDEF
     ATTDEF (3/15) entity
      }
    { R2010+  }
    { R2018+  }
    { => HEADER.AFLAGS  }
    { R2018+ TODO  }
    { R2018+  }
    { R2010+  }

      _dwg_entity_ATTDEF = record
          parent : ^_dwg_object_entity;
          elevation : BITCODE_BD;
          ins_pt : BITCODE_2DPOINT;
          alignment_pt : BITCODE_2DPOINT;
          extrusion : BITCODE_BE;
          thickness : BITCODE_RD;
          oblique_angle : BITCODE_RD;
          rotation : BITCODE_RD;
          height : BITCODE_RD;
          width_factor : BITCODE_RD;
          default_value : BITCODE_T;
          generation : BITCODE_BS;
          horiz_alignment : BITCODE_BS;
          vert_alignment : BITCODE_BS;
          dataflags : BITCODE_RC;
          class_version : BITCODE_RC;
          _type : BITCODE_RC;
          tag : BITCODE_T;
          field_length : BITCODE_BS;
          flags : BITCODE_RC;
          lock_position_flag : BITCODE_B;
          style : BITCODE_H;
          mtext_handles : BITCODE_H;
          annotative_data_size : BITCODE_BS;
          annotative_data_bytes : BITCODE_RC;
          annotative_app : BITCODE_H;
          annotative_short : BITCODE_BS;
          attdef_class_version : BITCODE_RC;
          prompt : BITCODE_T;
        end;
      Dwg_Entity_ATTDEF = _dwg_entity_ATTDEF;
    {*
     BLOCK (4/12) entity
      }
    { DXF 2 }
    { DXF 3 }
    { preR13 only }

      _dwg_entity_BLOCK = record
          parent : ^_dwg_object_entity;
          name : BITCODE_T;
          xref_pname : BITCODE_T;
          base_pt : BITCODE_2RD;
        end;
      Dwg_Entity_BLOCK = _dwg_entity_BLOCK;
    {*
     ENDBLK (5/13) entity
      }

      _dwg_entity_ENDBLK = record
          parent : ^_dwg_object_entity;
        end;
      Dwg_Entity_ENDBLK = _dwg_entity_ENDBLK;
    {*
     SEQEND (6/17) entity
      }

      _dwg_entity_SEQEND = record
          parent : ^_dwg_object_entity;
          unknown_r11 : BITCODE_RL;
        end;
      Dwg_Entity_SEQEND = _dwg_entity_SEQEND;
    {*
     INSERT (7/14) entity
      }
    { DXF 2  }
    { pre-R13  }
    { pre-R2.0  }

      _dwg_entity_INSERT = record
          parent : ^_dwg_object_entity;
          ins_pt : BITCODE_3DPOINT;
          scale_flag : BITCODE_BB;
          scale : BITCODE_3DPOINT;
          rotation : BITCODE_BD;
          extrusion : BITCODE_BE;
          has_attribs : BITCODE_B;
          num_owned : BITCODE_BL;
          block_header : BITCODE_H;
          first_attrib : BITCODE_H;
          last_attrib : BITCODE_H;
          attribs : ^BITCODE_H;
          seqend : BITCODE_H;
          num_cols : BITCODE_RS;
          num_rows : BITCODE_RS;
          col_spacing : BITCODE_RD;
          row_spacing : BITCODE_RD;
          block_name : BITCODE_TV;
        end;
      Dwg_Entity_INSERT = _dwg_entity_INSERT;
    {*
     MINSERT (8) entity
      }

      _dwg_entity_MINSERT = record
          parent : ^_dwg_object_entity;
          ins_pt : BITCODE_3DPOINT;
          scale_flag : BITCODE_BB;
          scale : BITCODE_3DPOINT;
          rotation : BITCODE_BD;
          extrusion : BITCODE_BE;
          has_attribs : BITCODE_B;
          num_owned : BITCODE_BL;
          num_cols : BITCODE_BS;
          num_rows : BITCODE_BS;
          col_spacing : BITCODE_BD;
          row_spacing : BITCODE_BD;
          block_header : BITCODE_H;
          first_attrib : BITCODE_H;
          last_attrib : BITCODE_H;
          attribs : ^BITCODE_H;
          seqend : BITCODE_H;
        end;
      Dwg_Entity_MINSERT = _dwg_entity_MINSERT;
    {*
     VERTEX_2D (10/20) entity
      }
    { R2010+  }

      _dwg_entity_VERTEX_2D = record
          parent : ^_dwg_object_entity;
          flag : BITCODE_RC;
          point : BITCODE_3BD;
          start_width : BITCODE_BD;
          end_width : BITCODE_BD;
          id : BITCODE_BL;
          bulge : BITCODE_BD;
          tangent_dir : BITCODE_BD;
        end;
      Dwg_Entity_VERTEX_2D = _dwg_entity_VERTEX_2D;
    {*
     VERTEX_3D (11) entity
      }

      _dwg_entity_VERTEX_3D = record
          parent : ^_dwg_object_entity;
          flag : BITCODE_RC;
          point : BITCODE_3BD;
        end;
      Dwg_Entity_VERTEX_3D = _dwg_entity_VERTEX_3D;
    {*
     VERTEX_MESH (12) - same as VERTEX_3D entity
      }

      Dwg_Entity_VERTEX_MESH = Dwg_Entity_VERTEX_3D;
    {*
     VERTEX_PFACE (13) - same as VERTEX_3D entity
      }

      Dwg_Entity_VERTEX_PFACE = Dwg_Entity_VERTEX_3D;
    {*
     VERTEX_PFACE_FACE (14) entity
      }

      _dwg_entity_VERTEX_PFACE_FACE = record
          parent : ^_dwg_object_entity;
          flag : BITCODE_RC;
          vertind : array[0..3] of BITCODE_BS;
        end;
      Dwg_Entity_VERTEX_PFACE_FACE = _dwg_entity_VERTEX_PFACE_FACE;


      {$define COMMON_ENTITY_POLYLINE:=parent:^_dwg_object_entity;has_vertex:BITCODE_B;num_owned:BITCODE_BL;first_vertex:BITCODE_H;last_vertex:BITCODE_H;vertex:^BITCODE_H;seqend:BITCODE_H}


    {*
     2D POLYLINE (15/18) entity
      }
      _dwg_entity_POLYLINE_2D = record
        COMMON_ENTITY_POLYLINE;
        flag : BITCODE_BS;{1: closed, 2: curve_fit, 4: spline_fit, 8: 3d, 0x10: 3dmesh,
                           0x20: mesh_closed_in_n, 0x40: polyface_mesh, 0x80: ltype_continuous}
        curve_type : BITCODE_BS;
        start_width : BITCODE_BD;
        end_width : BITCODE_BD;
        thickness : BITCODE_BT;
        elevation : BITCODE_BD;
        extrusion : BITCODE_BE;
      end;
      Dwg_Entity_POLYLINE_2D = _dwg_entity_POLYLINE_2D;
    {*
     3D POLYLINE (16/19) entity
      }
      _dwg_entity_POLYLINE_3D = record
        COMMON_ENTITY_POLYLINE;
        curve_type : BITCODE_RC;
        flag : BITCODE_RC;
        end;
      Dwg_Entity_POLYLINE_3D = _dwg_entity_POLYLINE_3D;
    {*
     ARC (17/8) entity
      }

      _dwg_entity_ARC = record
          parent : ^_dwg_object_entity;
          center : BITCODE_3BD;
          radius : BITCODE_BD;
          thickness : BITCODE_BT;
          extrusion : BITCODE_BE;
          start_angle : BITCODE_BD;
          end_angle : BITCODE_BD;
        end;
      Dwg_Entity_ARC = _dwg_entity_ARC;
    {*
     CIRCLE (18/3) entity
      }

      _dwg_entity_CIRCLE = record
          parent : ^_dwg_object_entity;
          center : BITCODE_3BD;
          radius : BITCODE_BD;
          thickness : BITCODE_BT;
          extrusion : BITCODE_BE;
        end;
      Dwg_Entity_CIRCLE = _dwg_entity_CIRCLE;
    {*
     LINE (19/1) entity
      }

      _dwg_entity_LINE = record
          parent : ^_dwg_object_entity;
          z_is_zero : BITCODE_RC;
          start : BITCODE_3BD;
          &end : BITCODE_3BD;
          thickness : BITCODE_BT;
          extrusion : BITCODE_BE;
        end;
      Dwg_Entity_LINE = _dwg_entity_LINE;
    {*
     * Macro for common DIMENSION declaration
     *
     * flag 70: value & 31: 0-6 denote the type, + bitmask 32-128.
     * 0: linear, 1: aligned, 2: ang2ln, 3: diameter, 4: radius
     * 5: ang3pt, 6: ordinate.
     * 32: block (2) used by this dimension only.
     * 64: if set, ordinate is type X, else ordinate is type Y.
     * 128: non-default dimension text location
      }
      {$define DIMENSION_COMMON:=parent:^_dwg_object_entity;class_version:BITCODE_RC; {* R2010+ *}extrusion:BITCODE_BE;def_pt:BITCODE_3BD;text_midpt:BITCODE_2RD;elevation:BITCODE_BD;flag:BITCODE_RC; {* calculated, DXF only 70 *}flag1:BITCODE_RC; {* as in the DWG *}user_text:BITCODE_T;text_rotation:BITCODE_BD;horiz_dir:BITCODE_BD;ins_scale:BITCODE_3BD;ins_rotation:BITCODE_BD;attachment:BITCODE_BS;lspace_style:BITCODE_BS;lspace_factor:BITCODE_BD;act_measurement:BITCODE_BD;unknown:BITCODE_B;flip_arrow1:BITCODE_B;flip_arrow2:BITCODE_B;clone_ins_pt:BITCODE_2RD;dimstyle:BITCODE_H;block:BITCODE_H}

      _dwg_DIMENSION_common = record
         DIMENSION_COMMON;
        end;
      Dwg_DIMENSION_common = _dwg_DIMENSION_common;

    {*
     ordinate dimension - DIMENSION_ORDINATE (20) entity
      }
      _dwg_entity_DIMENSION_ORDINATE = record
          DIMENSION_COMMON;
          feature_location_pt : BITCODE_3BD;
          leader_endpt : BITCODE_3BD;
          flag2 : BITCODE_RC; { use_x_axis }
        end;
      Dwg_Entity_DIMENSION_ORDINATE = _dwg_entity_DIMENSION_ORDINATE;
    {*
     linear dimension - DIMENSION_LINEAR (21/23) entity
      }
      _dwg_entity_DIMENSION_LINEAR = record
          DIMENSION_COMMON;
          xline1_pt : BITCODE_3BD;
          xline2_pt : BITCODE_3BD;
          oblique_angle : BITCODE_BD;
          dim_rotation : BITCODE_BD;
        end;
      Dwg_Entity_DIMENSION_LINEAR = _dwg_entity_DIMENSION_LINEAR;
    {*
     aligned dimension - DIMENSION_ALIGNED (22) entity
      }
      _dwg_entity_DIMENSION_ALIGNED = record
          DIMENSION_COMMON;
          xline1_pt : BITCODE_3BD;
          xline2_pt : BITCODE_3BD;
          oblique_angle : BITCODE_BD;
        end;
      Dwg_Entity_DIMENSION_ALIGNED = _dwg_entity_DIMENSION_ALIGNED;
    {*
     angular 3pt dimension - DIMENSION_ANG3PT (23) entity
      }
      _dwg_entity_DIMENSION_ANG3PT = record
          DIMENSION_COMMON;
          xline1_pt : BITCODE_3BD;
          xline2_pt : BITCODE_3BD;
          center_pt : BITCODE_3BD;
        end;
      Dwg_Entity_DIMENSION_ANG3PT = _dwg_entity_DIMENSION_ANG3PT;
    {*
     angular 2 line dimension - DIMENSION_ANG2LN (24) entity
      }
      _dwg_entity_DIMENSION_ANG2LN = record
          DIMENSION_COMMON;
          xline1start_pt : BITCODE_3BD;
          xline1end_pt : BITCODE_3BD;
          xline2start_pt : BITCODE_3BD;
          xline2end_pt : BITCODE_3BD;
        end;
      Dwg_Entity_DIMENSION_ANG2LN = _dwg_entity_DIMENSION_ANG2LN;
    {*
     radius dimension - DIMENSION_RADIUS (25) entity
      }
      _dwg_entity_DIMENSION_RADIUS = record
          DIMENSION_COMMON;
          first_arc_pt : BITCODE_3BD;{!< DXF 15  }
          leader_len : BITCODE_BD;{!< DXF 40  }
        end;
      Dwg_Entity_DIMENSION_RADIUS = _dwg_entity_DIMENSION_RADIUS;
    {*
     diameter dimension - DIMENSION_DIAMETER (26) entity
      }
      _dwg_entity_DIMENSION_DIAMETER = record
          DIMENSION_COMMON;{ DXF 10 def_pt = = far_chord_pt  }
          first_arc_pt : BITCODE_3BD;{!< DXF 15  }
          leader_len : BITCODE_BD;{!< DXF 40  }
        end;
      Dwg_Entity_DIMENSION_DIAMETER = _dwg_entity_DIMENSION_DIAMETER;
    {*
     arc dimension - ARC_DIMENSION (varies) entity
      }
      _dwg_entity_ARC_DIMENSION = record
          DIMENSION_COMMON;
          xline1_pt : BITCODE_3BD;{ DXF 13  }
          xline2_pt : BITCODE_3BD;{ DXF 14  }
          center_pt : BITCODE_3BD;{ DXF 15  }
          is_partial : BITCODE_B;{ DXF 70  }
          arc_start_param : BITCODE_BD;{ DXF 41  }
          arc_end_param : BITCODE_BD;{ DXF 42  }
          has_leader : BITCODE_B;{ DXF 71  }
          leader1_pt : BITCODE_3BD;{ DXF 16  }
          leader2_pt : BITCODE_3BD;{ DXF 17  }
        end;
      Dwg_Entity_ARC_DIMENSION = _dwg_entity_ARC_DIMENSION;
    {*
     arc dimension - LARGE_RADIAL_DIMENSION (varies) entity
      }
      _dwg_entity_LARGE_RADIAL_DIMENSION = record
          DIMENSION_COMMON;
          first_arc_pt : BITCODE_3BD;{!< DXF 15  }
          leader_len : BITCODE_BD;{!< DXF 40  }
          ovr_center : BITCODE_3BD;{!< DXF 12-32  }
          jog_point : BITCODE_3BD;{!< DXF 13-33  }
        end;
      Dwg_Entity_LARGE_RADIAL_DIMENSION = _dwg_entity_LARGE_RADIAL_DIMENSION;
    {*
     Struct for:  POINT (27/2)
      }

      _dwg_entity_POINT = record
          parent : ^_dwg_object_entity;
          x : BITCODE_BD;
          y : BITCODE_BD;
          z : BITCODE_BD;
          thickness : BITCODE_BT;
          extrusion : BITCODE_BE;
          x_ang : BITCODE_BD;
        end;
      Dwg_Entity_POINT = _dwg_entity_POINT;
    {*
     Struct for:  3D FACE (28/22)
      }

      _dwg_entity_3DFACE = record
          parent : ^_dwg_object_entity;
          has_no_flags : BITCODE_B;
          z_is_zero : BITCODE_B;
          corner1 : BITCODE_3BD;
          corner2 : BITCODE_3BD;
          corner3 : BITCODE_3BD;
          corner4 : BITCODE_3BD;
          invis_flags : BITCODE_BS;
        end;
      Dwg_Entity__3DFACE = _dwg_entity_3DFACE;
    {*
     Struct for:  POLYLINE (PFACE) (29)
      }
      _dwg_entity_POLYLINE_PFACE = record
          COMMON_ENTITY_POLYLINE;
          numverts : BITCODE_BS;
          numfaces : BITCODE_BS;
        end;
      Dwg_Entity_POLYLINE_PFACE = _dwg_entity_POLYLINE_PFACE;
    {*
     Struct for:  POLYLINE (MESH) (30)
      }
      _dwg_entity_POLYLINE_MESH = record
          COMMON_ENTITY_POLYLINE;
          flag : BITCODE_BS;
          curve_type : BITCODE_BS;
          num_m_verts : BITCODE_BS;
          num_n_verts : BITCODE_BS;
          m_density : BITCODE_BS;
          n_density : BITCODE_BS;
        end;
      Dwg_Entity_POLYLINE_MESH = _dwg_entity_POLYLINE_MESH;
    {*
     Struct for:  SOLID (31/11)
      }

      _dwg_entity_SOLID = record
          parent : ^_dwg_object_entity;
          thickness : BITCODE_BT;
          elevation : BITCODE_BD;
          corner1 : BITCODE_2RD;
          corner2 : BITCODE_2RD;
          corner3 : BITCODE_2RD;
          corner4 : BITCODE_2RD;
          extrusion : BITCODE_BE;
        end;
      Dwg_Entity_SOLID = _dwg_entity_SOLID;
    {*
     Struct for:  TRACE (32/9)
      }

      _dwg_entity_TRACE = record
          parent : ^_dwg_object_entity;
          thickness : BITCODE_BT;
          elevation : BITCODE_BD;
          corner1 : BITCODE_2RD;
          corner2 : BITCODE_2RD;
          corner3 : BITCODE_2RD;
          corner4 : BITCODE_2RD;
          extrusion : BITCODE_BE;
        end;
      Dwg_Entity_TRACE = _dwg_entity_TRACE;
    {*
     Struct for:  SHAPE (33/4)
      }
    { DXF 10-30 }
    { DXF 40 }
    { DXF 50 }
    { DXF 41 }
    { DXF 51 }
    { DXF 39 }
    { DXF 2, STYLE index in dwg to SHAPEFILE }
    { DXF 210 }

      _dwg_entity_SHAPE = record
          parent : ^_dwg_object_entity;
          ins_pt : BITCODE_3BD;
          scale : BITCODE_BD;
          rotation : BITCODE_BD;
          width_factor : BITCODE_BD;
          oblique_angle : BITCODE_BD;
          thickness : BITCODE_BD;
          style_id : BITCODE_BS;
          extrusion : BITCODE_BE;
          style : BITCODE_H;
        end;
      Dwg_Entity_SHAPE = _dwg_entity_SHAPE;
    {*
     Struct for:  VIEWPORT ENTITY (34/24)
      }
    { DXF 68, -1 should be accepted also  }
    { DXF 69  }
    { the height }

      _dwg_entity_VIEWPORT = record
          parent : ^_dwg_object_entity;
          center : BITCODE_3BD;
          width : BITCODE_BD;
          height : BITCODE_BD;
          on_off : BITCODE_RS;
          id : BITCODE_RS;
          view_target : BITCODE_3BD;
          VIEWDIR : BITCODE_3BD;
          twist_angle : BITCODE_BD;
          VIEWSIZE : BITCODE_BD;
          lens_length : BITCODE_BD;
          front_clip_z : BITCODE_BD;
          back_clip_z : BITCODE_BD;
          SNAPANG : BITCODE_BD;
          VIEWCTR : BITCODE_2RD;
          SNAPBASE : BITCODE_2RD;
          SNAPUNIT : BITCODE_2RD;
          GRIDUNIT : BITCODE_2RD;
          circle_zoom : BITCODE_BS;
          grid_major : BITCODE_BS;
          num_frozen_layers : BITCODE_BL;
          status_flag : BITCODE_BL;
          style_sheet : BITCODE_TV;
          render_mode : BITCODE_RC;
          ucs_at_origin : BITCODE_B;
          UCSVP : BITCODE_B;
          ucsorg : BITCODE_3BD;
          ucsxdir : BITCODE_3BD;
          ucsydir : BITCODE_3BD;
          ucs_elevation : BITCODE_BD;
          UCSORTHOVIEW : BITCODE_BS;
          shadeplot_mode : BITCODE_BS;
          use_default_lights : BITCODE_B;
          default_lighting_type : BITCODE_RC;
          brightness : BITCODE_BD;
          contrast : BITCODE_BD;
          ambient_color : BITCODE_CMC;
          vport_entity_header : BITCODE_H;
          frozen_layers : ^BITCODE_H;
          clip_boundary : BITCODE_H;
          named_ucs : BITCODE_H;
          base_ucs : BITCODE_H;
          background : BITCODE_H;
          visualstyle : BITCODE_H;
          shadeplot : BITCODE_H;
          sun : BITCODE_H;
        end;
      Dwg_Entity_VIEWPORT = _dwg_entity_VIEWPORT;
    {*
     ELLIPSE (35) entity
      }
    { i.e RadiusRatio  }

      _dwg_entity_ELLIPSE = record
          parent : ^_dwg_object_entity;
          center : BITCODE_3BD;
          sm_axis : BITCODE_3BD;
          extrusion : BITCODE_BE;
          axis_ratio : BITCODE_BD;
          start_angle : BITCODE_BD;
          end_angle : BITCODE_BD;
        end;
      Dwg_Entity_ELLIPSE = _dwg_entity_ELLIPSE;
    {*
     spline - SPLINE (36) entity
      }

      _dwg_SPLINE_control_point = record
          parent : ^_dwg_entity_SPLINE;
          x : double;
          y : double;
          z : double;
          w : double;
        end;
      Dwg_SPLINE_control_point = _dwg_SPLINE_control_point;
    { computed  }
    { 1 spline, 2 bezier  }
    { 2013+: method fit points = 1, CV frame show = 2, closed = 4  }
    { 2013+: Chord = 0, Square root = 1, Uniform = 2, Custom = 15  }
    { bit 0 of 70  }
    { bit 1 of 70  }
    { bit 2 of 70  }
    { bit 4 of 70  }

      _dwg_entity_SPLINE = record
          parent : ^_dwg_object_entity;
          flag : BITCODE_RS;
          scenario : BITCODE_BS;
          degree : BITCODE_BS;
          splineflags1 : BITCODE_BL;
          knotparam : BITCODE_BL;
          fit_tol : BITCODE_BD;
          beg_tan_vec : BITCODE_3BD;
          end_tan_vec : BITCODE_3BD;
          closed_b : BITCODE_B;
          periodic : BITCODE_B;
          rational : BITCODE_B;
          weighted : BITCODE_B;
          knot_tol : BITCODE_BD;
          ctrl_tol : BITCODE_BD;
          num_fit_pts : BITCODE_BS;
          fit_pts : ^BITCODE_3DPOINT;
          num_knots : BITCODE_BL;
          knots : ^BITCODE_BD;
          num_ctrl_pts : BITCODE_BL;
          ctrl_pts : ^Dwg_SPLINE_control_point;
        end;
      Dwg_Entity_SPLINE = _dwg_entity_SPLINE;
    {*
     3DSOLID (38) entity
      }
      _dwg_3DSOLID_wire = record
          parent : ^_dwg_entity_3DSOLID;
          _type : BITCODE_RC;
          selection_marker : BITCODE_BLd;
          color : BITCODE_BL;
          acis_index : BITCODE_BLd;
          num_points : BITCODE_BL;
          points : ^BITCODE_3BD;
          transform_present : BITCODE_B;
          axis_x : BITCODE_3BD;
          axis_y : BITCODE_3BD;
          axis_z : BITCODE_3BD;
          translation : BITCODE_3BD;
          scale : BITCODE_3BD;
          has_rotation : BITCODE_B;
          has_reflection : BITCODE_B;
          has_shear : BITCODE_B;
        end;
      Dwg_3DSOLID_wire = _dwg_3DSOLID_wire;

      _dwg_3DSOLID_silhouette = record
          parent : ^_dwg_entity_3DSOLID;
          vp_id : BITCODE_BL;
          vp_target : BITCODE_3BD;
          vp_dir_from_target : BITCODE_3BD;
          vp_up_dir : BITCODE_3BD;
          vp_perspective : BITCODE_B;
          has_wires : BITCODE_B;
          num_wires : BITCODE_BL;
          wires : ^Dwg_3DSOLID_wire;
        end;
      Dwg_3DSOLID_silhouette = _dwg_3DSOLID_silhouette;
    { code 5  }

      _dwg_3DSOLID_material = record
          parent : ^_dwg_entity_3DSOLID;
          array_index : BITCODE_BL;
          mat_absref : BITCODE_BL;
          material_handle : BITCODE_H;
        end;
      Dwg_3DSOLID_material = _dwg_3DSOLID_material;

      {$define _3DSOLID_FIELDS:=acis_empty:BITCODE_B;unknown:BITCODE_B;version:BITCODE_BS;num_blocks:BITCODE_BL;block_size:^BITCODE_BL;encr_sat_data:^pchar;sab_size:BITCODE_BL;acis_data:^BITCODE_RC;(*The decrypted SAT v1 or the SAB v2 stream*)wireframe_data_present:BITCODE_B;point_present:BITCODE_B;point:BITCODE_3BD;isolines:BITCODE_BL;(*i.e. wires*)isoline_present:BITCODE_B;(*ie. has_wires*)num_wires:BITCODE_BL;wires:^Dwg_3DSOLID_wire;num_silhouettes:BITCODE_BL;silhouettes:^Dwg_3DSOLID_silhouette;_dxf_sab_converted:^BITCODE_B;(*internally calculated*)acis_empty2:^BITCODE_B;extra_acis_data:^_dwg_entity_3DSOLID;num_materials:BITCODE_BL;materials:^Dwg_3DSOLID_material;revision_guid{[39]}:array[0..38] of BITCODE_RC;revision_major:BITCODE_BL;revision_minor1:BITCODE_BS;revision_minor2:BITCODE_BS;revision_bytes{[9]}:array[0..8] of BITCODE_RC;end_marker:BITCODE_BL;history_id:BITCODE_H;has_revision_guid:BITCODE_B;acis_empty_bit:BITCODE_B}

      _dwg_entity_3DSOLID = record
          _3DSOLID_FIELDS;
     {$ifdef undeffed}
      (*  acis_empty : BITCODE_B;{!< no DXF  }
        unknown : BITCODE_B;
        version : BITCODE_BS;
    {!< DXF 70 Modeler format version =1 }
        num_blocks : BITCODE_BL;cvar;public;
        block_size : ^BITCODE_BL;cvar;public;
        encr_sat_data : ^^char;cvar;public;
    {!< DXF 1, the encrypted SAT data  }
        acis_data : ^BITCODE_RC;cvar;public;
    {!< decrypted SAT data  }
        wireframe_data_present : BITCODE_B;cvar;public;
        point_present : BITCODE_B;cvar;public;
        point : BITCODE_3BD;cvar;public;
        num_isolines : BITCODE_BL;cvar;public;
        isoline_present : BITCODE_B;cvar;public;
        num_wires : BITCODE_BL;cvar;public;
        wires : ^Dwg_3DSOLID_wire;cvar;public;
        num_silhouettes : BITCODE_BL;cvar;public;
        silhouettes : ^Dwg_3DSOLID_silhouette;cvar;public;
        acis_empty2 : BITCODE_B;cvar;public;
    { is it the best approach?  }
        unknown_2007 : BITCODE_BL;cvar;public;
        history_id : BITCODE_H;cvar;public;
        acis_empty_bit : BITCODE_B;cvar;public;
      *)
{$endif}
      end;
      Dwg_Entity__3DSOLID=_dwg_entity_3DSOLID;
    {*
     REGION (37) entity
      }
      Dwg_Entity_REGION = Dwg_Entity__3DSOLID;
    {*
     BODY (39) entity
      }
      Dwg_Entity_BODY = Dwg_Entity__3DSOLID;
    {*
     ray - RAY (40) entity
      }
      _dwg_entity_RAY = record
          parent : ^_dwg_object_entity;
          point : BITCODE_3BD;{!< DXF 10  }
          vector : BITCODE_3BD;{!< DXF 11  }
        end;
      Dwg_Entity_RAY = _dwg_entity_RAY;
    {*
     XLINE (41) entity
      }
      Dwg_Entity_XLINE = Dwg_Entity_RAY;
    {*
     DICTIONARY (42)
     This structure is used for all the new tables.
     Beware: Keep same offsets as DICTIONARYWDFLT
      }
    {!< no DXF  }
    {!< DXF 280  }
    {!< DXF 281, ie merge_style  }
    {!< DXF 3  }
    {!< DXF 350/360, pairwise with texts  }
    {!< r14 only  }

      _dwg_object_DICTIONARY = record
          parent : ^_dwg_object_object;
          numitems : BITCODE_BL;
          is_hardowner : BITCODE_RC;
          cloning : BITCODE_BS;
          texts : ^BITCODE_T;
          itemhandles : ^BITCODE_H;
          cloning_r14 : BITCODE_RC;
        end;
      Dwg_Object_DICTIONARY = _dwg_object_DICTIONARY;
    {*
     Class DICTIONARYWDFLT (varies)
      }
    {!< no DXF  }
    {!< DXF 280  }
    {!< DXF 281, ie merge_style  }
    {!< DXF 3  }
    {!< DXF 350/360, pairwise with texts  }
    {!< r14 only  }

      _dwg_object_DICTIONARYWDFLT = record
          parent : ^_dwg_object_object;
          numitems : BITCODE_BL;
          is_hardowner : BITCODE_RC;
          cloning : BITCODE_BS;
          texts : ^BITCODE_T;
          itemhandles : ^BITCODE_H;
          cloning_r14 : BITCODE_RL;
          defaultid : BITCODE_H;
        end;
      Dwg_Object_DICTIONARYWDFLT = _dwg_object_DICTIONARYWDFLT;
    {*
     OLEFRAME (43) entity
     (replaced by OLE2FRAME (74) later)
      }

      _dwg_entity_OLEFRAME = record
          parent : ^_dwg_object_entity;
          flag : BITCODE_BS;
          mode : BITCODE_BS;
          data_size : BITCODE_BL;
          data : BITCODE_TF;
        end;
      Dwg_Entity_OLEFRAME = _dwg_entity_OLEFRAME;
    {*
     MTEXT (44) entity
      }
    {!< DXF 10  }
    {!< DXF 210  }
    {!< DXF 11, defines the rotation  }
    {!< no DXF  }
    {!< DXF 41  }
    {!< DXF 40 >= 0.0  }
    {!< DXF 71.
                                 1 = Top left, 2 = Top center, 3 = Top
                                 right, 4 = Middle left, 5 = Middle
                                 center, 6 = Middle right, 7 = Bottom
                                 left, 8 = Bottom center, 9 = Bottom
                                 right  }
    {!< DXF 72.
                                  1 = Left to right, 3 = Top to bottom,
                                  5 = By style (the flow direction is inherited
                                  from the associated text style)  }
    {!< DXF 42  }
    {!< DXF 43 the actual height  }
    {!< DXF 1  }
    {!< DXF 7  }
    {!< DXF 73. r2000+  }
    {!< DXF 44. r2000+. Mtext line spacing factor (optional):
                                   Percentage of default (3-on-5) line spacing to
                                   be applied. Valid values range from 0.25 to 4.00  }
    { always 0 }
    {!< DXF 90. r2004+
                                   0 = Background fill off,
                                   1 = Use background fill color,
                                   2 = Use drawing window color as background fill color.
                                  16 = textframe (r2018+)  }
    {!< DXF 45. r2004+
                                   margin around the text.  }
    {!< DXF 63. r2004+. on bg_fill_flag==1  }
    {!< DXF 441. r2004+. unused  }
    {!< r2018+:  }
    {!< always 0  }
    {!< DXF 70. default true  }
    {!< redundant copy, not BS  }
    {!< DXF 71 0: none, 1: static, 2: dynamic.  }
    {!< DXF 72 if static  }
    {!< DXF 44  }
    {!< DXF 45  }
    {!< DXF 73  }
    {!< DXF 74  }
    {!< DXF 72 if dynamic and not auto_height  }
    {!< DXF 46  }

      _dwg_entity_MTEXT = record
          parent : ^_dwg_object_entity;
          ins_pt : BITCODE_3BD;
          extrusion : BITCODE_BE;
          x_axis_dir : BITCODE_3BD;
          rect_height : BITCODE_BD;
          rect_width : BITCODE_BD;
          text_height : BITCODE_BD;
          attachment : BITCODE_BS;
          flow_dir : BITCODE_BS;
          extents_width : BITCODE_BD;
          extents_height : BITCODE_BD;
          text : BITCODE_T;
          style : BITCODE_H;
          linespace_style : BITCODE_BS;
          linespace_factor : BITCODE_BD;
          unknown_b0 : BITCODE_B;
          bg_fill_flag : BITCODE_BL;
          bg_fill_scale : BITCODE_BL;
          bg_fill_color : BITCODE_CMC;
          bg_fill_trans : BITCODE_BL;
          is_not_annotative : BITCODE_B;
          class_version : BITCODE_BS;
          default_flag : BITCODE_B;
          appid : BITCODE_H;
          ignore_attachment : BITCODE_BL;
          column_type : BITCODE_BS;
          numfragments : BITCODE_BL;
          column_width : BITCODE_BD;
          gutter : BITCODE_BD;
          auto_height : BITCODE_B;
          flow_reversed : BITCODE_B;
          num_column_heights : BITCODE_BL;
          column_heights : ^BITCODE_BD;
        end;
      Dwg_Entity_MTEXT = _dwg_entity_MTEXT;
    {*
     LEADER (45) entity
      }
    { always seems to be zero  }
    {< DXF(72) 0: line, 1: spline (oda bug)  }
    {< DXF(73) 0: text, 1: tol, 2: insert, 3 (def): none  }
    {< DXF(76)  }
    { R_14-R_2007 ?  }
    { R_13-R_14 only  }
    {< DXF(40)  }
    {< DXF(41)  }
    { DXF 340 Hard reference to associated annotation (mtext, tolerance, or insert entity)  }

      _dwg_entity_LEADER = record
          parent : ^_dwg_object_entity;
          unknown_bit_1 : BITCODE_B;
          path_type : BITCODE_BS;
          annot_type : BITCODE_BS;
          num_points : BITCODE_BL;
          points : ^BITCODE_3DPOINT;
          origin : BITCODE_3DPOINT;
          extrusion : BITCODE_BE;
          x_direction : BITCODE_3DPOINT;
          inspt_offset : BITCODE_3DPOINT;
          endptproj : BITCODE_3DPOINT;
          dimgap : BITCODE_BD;
          box_height : BITCODE_BD;
          box_width : BITCODE_BD;
          hookline_dir : BITCODE_B;
          arrowhead_on : BITCODE_B;
          arrowhead_type : BITCODE_BS;
          dimasz : BITCODE_BD;
          unknown_bit_2 : BITCODE_B;
          unknown_bit_3 : BITCODE_B;
          unknown_short_1 : BITCODE_BS;
          byblock_color : BITCODE_BS;
          hookline_on : BITCODE_B;
          unknown_bit_5 : BITCODE_B;
          associated_annotation : BITCODE_H;
          dimstyle : BITCODE_H;
        end;
      Dwg_Entity_LEADER = _dwg_entity_LEADER;
    {*
     TOLERANCE (46) entity
      }

      _dwg_entity_TOLERANCE = record
          parent : ^_dwg_object_entity;
          unknown_short : BITCODE_BS;
          height : BITCODE_BD;
          dimgap : BITCODE_BD;
          ins_pt : BITCODE_3BD;
          x_direction : BITCODE_3BD;
          extrusion : BITCODE_BE;
          text_value : BITCODE_T;
          dimstyle : BITCODE_H;
        end;
      Dwg_Entity_TOLERANCE = _dwg_entity_TOLERANCE;
    {*
     MLINE (47) entity
      }

      _dwg_MLINE_line = record
          parent : ^_dwg_MLINE_vertex;
          num_segparms : BITCODE_BS;
          segparms : ^BITCODE_BD;
          num_areafillparms : BITCODE_BS;
          areafillparms : ^BITCODE_BD;
        end;
      Dwg_MLINE_line = _dwg_MLINE_line;

      _dwg_MLINE_vertex = record
          parent : ^_dwg_entity_MLINE;
          vertex : BITCODE_3BD;
          vertex_direction : BITCODE_3BD;
          miter_direction : BITCODE_3BD;
          num_lines : BITCODE_RC;
          lines : ^Dwg_MLINE_line;
        end;
      Dwg_MLINE_vertex = _dwg_MLINE_vertex;
    { Linesinstyle  }

      _dwg_entity_MLINE = record
          parent : ^_dwg_object_entity;
          scale : BITCODE_BD;
          justification : BITCODE_RC;
          base_point : BITCODE_3BD;
          extrusion : BITCODE_BE;
          flags : BITCODE_BS;
          num_lines : BITCODE_RC;
          num_verts : BITCODE_BS;
          verts : ^Dwg_MLINE_vertex;
          mlinestyle : BITCODE_H;
        end;
      Dwg_Entity_MLINE = _dwg_entity_MLINE;

      {$define COMMON_TABLE_CONTROL_FIELDS:=parent:^_dwg_object_object;num_entries:BITCODE_BS;entries:^BITCODE_H}

      // table entries may be imported from xref's
      {$define COMMON_TABLE_FIELDS:=parent:^_dwg_object_object;flag:BITCODE_XXlaytype;name:BITCODE_T;used:BITCODE_RSd;(*may be referenced by xref:*)is_xref_ref:BITCODE_B;(*is a xref reference:*)is_xref_resolved:BITCODE_BS;(*0 or 256*)(*is dependent on xref:*)is_xref_dep:BITCODE_B;xref:BITCODE_H}
    {*
     BLOCK_CONTROL (48) object, table header
      }
      _dwg_object_BLOCK_CONTROL = record
          COMMON_TABLE_CONTROL_FIELDS;
          model_space : BITCODE_H;
          paper_space : BITCODE_H;
      end;
      Dwg_Object_BLOCK_CONTROL=_dwg_object_BLOCK_CONTROL;
    {*
     BLOCK_HEADER (49/T1) object, table entry
      }
    { preR13  }
    { flag 70 bit 1  }
    { flag 70 bit 2  }
    { flag 70 bit 3  }
    { flag 70 bit 4  }
    { flag 70 bit 6  }
    { no DXF. BLL?  }
    { DXF 310. Called PreviewIcon  }
      _dwg_object_BLOCK_HEADER = record
          {$define BITCODE_XXlaytype:=BITCODE_RC}
          COMMON_TABLE_FIELDS;
          {$undef BITCODE_XXlaytype}
          __iterator : BITCODE_BL;
          flag2 : BITCODE_RC;
          anonymous : BITCODE_B;
          hasattrs : BITCODE_B;
          blkisxref : BITCODE_B;
          xrefoverlaid : BITCODE_B;
          loaded_bit : BITCODE_B;
          num_owned : BITCODE_BL;
          base_pt : BITCODE_3DPOINT;
          xref_pname : BITCODE_TV;
          num_inserts : BITCODE_RL;
          description : BITCODE_TV;
          preview_size : BITCODE_BL;
          preview : BITCODE_TF;
          insert_units : BITCODE_BS;
          explodable : BITCODE_B;
          block_scaling : BITCODE_RC;
          block_entity : BITCODE_H;
          first_entity : BITCODE_H;
          last_entity : BITCODE_H;
          entities : ^BITCODE_H;
          endblk_entity : BITCODE_H;
          inserts : ^BITCODE_H;
          layout : BITCODE_H;
          unknown_r11 : BITCODE_RS;
          unknown1_r11 : BITCODE_RS;
        end;
      Dwg_Object_BLOCK_HEADER = _dwg_object_BLOCK_HEADER;
    {*
     LAYER_CONTROL (50) object, table header
      }
      _dwg_object_LAYER_CONTROL = record
          COMMON_TABLE_CONTROL_FIELDS;
        end;
      Dwg_Object_LAYER_CONTROL = _dwg_object_LAYER_CONTROL;
    {*
     LAYER (51/T2) object, table entry
      }
    {<! flag DXF 70 r2000+
         1:  frozen
         2:  on
         4:  frozen_in_new
         8:  locked
         bits 6-10: linewt
         32768: plotflag (bit 16)
      }
    { DXF 390  }
    { DXF 347  }
    { DXF 6  }
    { DXF 348  }
      _dwg_object_LAYER = record
          {$define BITCODE_XXlaytype:=BITCODE_BS}
          COMMON_TABLE_FIELDS;
          {$undef BITCODE_XXlaytype}
          frozen : BITCODE_B;
          &on : BITCODE_B;
          frozen_in_new : BITCODE_B;
          locked : BITCODE_B;
          plotflag : BITCODE_B;
          linewt : BITCODE_RC;
          color : BITCODE_CMC;
          plotstyle : BITCODE_H;
          material : BITCODE_H;
          ltype : BITCODE_H;
          visualstyle : BITCODE_H;
        end;
      Dwg_Object_LAYER = _dwg_object_LAYER;
    {*
     STYLE_CONTROL (52) object, table header
      }
(* error 
  COMMON_TABLE_CONTROL_FIELDS;
 in declarator_list *)

      _dwg_object_STYLE_CONTROL = record
          COMMON_TABLE_CONTROL_FIELDS;
        end;
      Dwg_Object_STYLE_CONTROL = _dwg_object_STYLE_CONTROL;
    {*
     STYLE (53/T3) object, table entry.
     TextStyleTableRecord. Some call it SHAPEFILE.
      }
    {<! flag DXF 70:
         1:  is_vertical
         2:  is_upsidedown
         4:  is_shape
         8:  underlined
         16: overlined (0x10)
         32: is_shx
         64: pre_loaded (0x40)
        128: is_backward (0x80)
        256: shape_loaded (0x100)
        512: is_striked (0x200)
      }

      _dwg_object_STYLE = record
          {$define BITCODE_XXlaytype:=BITCODE_RC}
          COMMON_TABLE_FIELDS;
          {$undef BITCODE_XXlaytype}
          is_shape : BITCODE_B;
          is_vertical : BITCODE_B;
          text_size : BITCODE_BD;
          width_factor : BITCODE_BD;
          oblique_angle : BITCODE_BD;
          generation : BITCODE_RC;
          last_height : BITCODE_BD;
          font_file : BITCODE_T;
          bigfont_file : BITCODE_T;
          unknown : BITCODE_RS;
        end;
      Dwg_Object_STYLE = _dwg_object_STYLE;
    { 54 and 55 are UNKNOWN OBJECTS  }
    {*
     LTYPE_CONTROL (56) object, table header
      }
(* error 
  COMMON_TABLE_CONTROL_FIELDS;
 in declarator_list *)

      _dwg_object_LTYPE_CONTROL = record
          COMMON_TABLE_CONTROL_FIELDS;
          bylayer : BITCODE_H;
          byblock : BITCODE_H;
        end;
      Dwg_Object_LTYPE_CONTROL = _dwg_object_LTYPE_CONTROL;
    {*
     LTYPE (57/T4) object, table entry
      }
    { on shape_flag 2: shape number.
                                       4: index into strings_area.  }
    { 1: text rotated 0, 2: complex_shapecode is index,
                                4: complex_shapecode is index into strings_area.  }
    { DXF 9, only if shape_flag & 2. e.g. GAS_LINE  }

      _dwg_LTYPE_dash = record
          parent : ^_dwg_object_LTYPE;
          length : BITCODE_BD;
          complex_shapecode : BITCODE_BS;
          style : BITCODE_H;
          x_offset : BITCODE_RD;
          y_offset : BITCODE_RD;
          scale : BITCODE_BD;
          rotation : BITCODE_BD;
          shape_flag : BITCODE_BS;
          text : BITCODE_T;
        end;
      Dwg_LTYPE_dash = _dwg_LTYPE_dash;
    { could be made a union if we care }
    { if some shape_flag & 4 (ODA bug)  }

      _dwg_object_LTYPE = record
          {$define BITCODE_XXlaytype:=BITCODE_RC}
          COMMON_TABLE_FIELDS;
          {$undef BITCODE_XXlaytype}
          description : BITCODE_TV;
          pattern_len : BITCODE_BD;
          alignment : BITCODE_RC;
          num_dashes : BITCODE_RC;
          dashes : ^Dwg_LTYPE_dash;
          dashes_r11 : array[0..11] of BITCODE_RD;
          has_strings_area : BITCODE_B;
          strings_area : BITCODE_TF;
        end;
      Dwg_Object_LTYPE = _dwg_object_LTYPE;
    { 58 and 59 are UNKNOWN OBJECTS  }
    {*
     VIEW_CONTROL (60) object, table header
      }
(* error 
  COMMON_TABLE_CONTROL_FIELDS;
 in declarator_list *)

      _dwg_object_VIEW_CONTROL = record
          COMMON_TABLE_CONTROL_FIELDS;
        end;
      Dwg_Object_VIEW_CONTROL = _dwg_object_VIEW_CONTROL;
    {*
     VIEW (61/T5) object, table entry
      }
    { AbstractViewTableRecord }
    { ViInfo }
    { DXF 71. 0: perspective, 1: front_clip_on, 2: back_clip_on, 3: front_clip_at_eye_on }
    { ViewTableRecord }

      _dwg_object_VIEW = record
          {$define BITCODE_XXlaytype:=BITCODE_RC}
          COMMON_TABLE_FIELDS;
          {$undef BITCODE_XXlaytype}
          VIEWSIZE : BITCODE_BD;
          view_width : BITCODE_BD;
          aspect_ratio : BITCODE_BD;
          VIEWCTR : BITCODE_2RD;
          view_target : BITCODE_3BD;
          VIEWDIR : BITCODE_3BD;
          twist_angle : BITCODE_BD;
          lens_length : BITCODE_BD;
          front_clip_z : BITCODE_BD;
          back_clip_z : BITCODE_BD;
          VIEWMODE : BITCODE_4BITS;
          render_mode : BITCODE_RC;
          use_default_lights : BITCODE_B;
          default_lightning_type : BITCODE_RC;
          brightness : BITCODE_BD;
          contrast : BITCODE_BD;
          ambient_color : BITCODE_CMC;
          is_pspace : BITCODE_B;
          associated_ucs : BITCODE_B;
          ucsorg : BITCODE_3BD;
          ucsxdir : BITCODE_3BD;
          ucsydir : BITCODE_3BD;
          ucs_elevation : BITCODE_BD;
          UCSORTHOVIEW : BITCODE_BS;
          is_camera_plottable : BITCODE_B;
          background : BITCODE_H;
          visualstyle : BITCODE_H;
          sun : BITCODE_H;
          base_ucs : BITCODE_H;
          named_ucs : BITCODE_H;
          livesection : BITCODE_H;
        end;
      Dwg_Object_VIEW = _dwg_object_VIEW;
    {*
     UCS_CONTROL (62) object, table header
      }
(* error 
  COMMON_TABLE_CONTROL_FIELDS;
 in declarator_list *)

      _dwg_object_UCS_CONTROL = record
          COMMON_TABLE_CONTROL_FIELDS;
        end;
      Dwg_Object_UCS_CONTROL = _dwg_object_UCS_CONTROL;
    {*
     UCS (63/T6) object, table entry
      }
    { 71 }
    { 13 }

      _dwg_UCS_orthopts = record
          parent : ^_dwg_object_UCS;
          _type : BITCODE_BS;
          pt : BITCODE_3BD;
        end;
      Dwg_UCS_orthopts = _dwg_UCS_orthopts;
    { missing in ODA docs }

      _dwg_object_UCS = record
          {$define BITCODE_XXlaytype:=BITCODE_RC}
          COMMON_TABLE_FIELDS;
          {$undef BITCODE_XXlaytype}
          ucsorg : BITCODE_3BD;
          ucsxdir : BITCODE_3BD;
          ucsydir : BITCODE_3BD;
          ucs_elevation : BITCODE_BD;
          UCSORTHOVIEW : BITCODE_BS;
          base_ucs : BITCODE_H;
          named_ucs : BITCODE_H;
          num_orthopts : BITCODE_BS;
          orthopts : ^Dwg_UCS_orthopts;
        end;
      Dwg_Object_UCS = _dwg_object_UCS;
    {*
     VPORT_CONTROL (64) object, table header
      }
(* error 
  COMMON_TABLE_CONTROL_FIELDS;
 in declarator_list *)

      _dwg_object_VPORT_CONTROL = record
          COMMON_TABLE_CONTROL_FIELDS;
        end;
      Dwg_Object_VPORT_CONTROL = _dwg_object_VPORT_CONTROL;
    {*
     VPORT (65/T7) object, table entry
      }
    { AbstractViewTableRecord }
    { really the view height }
    { in DWG r13+, needed to calc. aspect_ratio }
    { DXF 41 = view_width / VIEWSIZE }
    { ViInfo }
    { ViewportTableRecord }
    { circle sides: nr of tesselations  }
    { DXF 71:  0: icon_on, 1: icon_at_ucsorg  }
    { DXF 76: on or off  }
    { DXF 75: on or off  }
    { bit 1: bound to limits, bit 2: adaptive  }

      _dwg_object_VPORT = record
          {$define BITCODE_XXlaytype:=BITCODE_RC}
          COMMON_TABLE_FIELDS;
          {$undef BITCODE_XXlaytype}
          VIEWSIZE : BITCODE_BD;
          view_width : BITCODE_BD;
          aspect_ratio : BITCODE_BD;
          VIEWCTR : BITCODE_2RD;
          view_target : BITCODE_3BD;
          VIEWDIR : BITCODE_3BD;
          view_twist : BITCODE_BD;
          lens_length : BITCODE_BD;
          front_clip_z : BITCODE_BD;
          back_clip_z : BITCODE_BD;
          VIEWMODE : BITCODE_4BITS;
          render_mode : BITCODE_RC;
          use_default_lights : BITCODE_B;
          default_lightning_type : BITCODE_RC;
          brightness : BITCODE_BD;
          contrast : BITCODE_BD;
          ambient_color : BITCODE_CMC;
          lower_left : BITCODE_2RD;
          upper_right : BITCODE_2RD;
          UCSFOLLOW : BITCODE_B;
          circle_zoom : BITCODE_BS;
          FASTZOOM : BITCODE_B;
          UCSICON : BITCODE_RC;
          GRIDMODE : BITCODE_B;
          GRIDUNIT : BITCODE_2RD;
          SNAPMODE : BITCODE_B;
          SNAPSTYLE : BITCODE_B;
          SNAPISOPAIR : BITCODE_BS;
          SNAPANG : BITCODE_BD;
          SNAPBASE : BITCODE_2RD;
          SNAPUNIT : BITCODE_2RD;
          ucs_at_origin : BITCODE_B;
          UCSVP : BITCODE_B;
          ucsorg : BITCODE_3BD;
          ucsxdir : BITCODE_3BD;
          ucsydir : BITCODE_3BD;
          ucs_elevation : BITCODE_BD;
          UCSORTHOVIEW : BITCODE_BS;
          grid_flags : BITCODE_BS;
          grid_major : BITCODE_BS;
          background : BITCODE_H;
          visualstyle : BITCODE_H;
          sun : BITCODE_H;
          named_ucs : BITCODE_H;
          base_ucs : BITCODE_H;
        end;
      Dwg_Object_VPORT = _dwg_object_VPORT;
    {*
     APPID_CONTROL (66) object
     The table header of all registered applications
      }
(* error 
  COMMON_TABLE_CONTROL_FIELDS;
 in declarator_list *)

      _dwg_object_APPID_CONTROL = record
          COMMON_TABLE_CONTROL_FIELDS;
        end;
      Dwg_Object_APPID_CONTROL = _dwg_object_APPID_CONTROL;
    {*
     APPID (67/T8) object
     The table entry of a registered application
      }

      _dwg_object_APPID = record
          {$define BITCODE_XXlaytype:=BITCODE_RC}
          COMMON_TABLE_FIELDS;
          {$undef BITCODE_XXlaytype}
          unknown : BITCODE_RC;
        end;
      Dwg_Object_APPID = _dwg_object_APPID;
    {*
     DIMSTYLE_CONTROL (68) object
     The table header of all dimension styles
      }
(* error 
  COMMON_TABLE_CONTROL_FIELDS;
 in declarator_list *)
    { DXF 71 undocumented  }
    { DXF 340  }

      _dwg_object_DIMSTYLE_CONTROL = record
          COMMON_TABLE_CONTROL_FIELDS;
          num_morehandles : BITCODE_RC;
          morehandles : ^BITCODE_H;
        end;
      Dwg_Object_DIMSTYLE_CONTROL = _dwg_object_DIMSTYLE_CONTROL;
    {*
     DIMSTYLE (69/T9) object, table entry
      }
    {!< r13-r14 only RC  }
    {!< r13-r14 only RC  }
    {!< r13-r14 only RC  }
    {!< r13-r14 only RC  }
    {!< r13-r14 only RC  }
    {!< r13-r14 only RC  }
    {!< r13-r14 only RC  }
    {!< r13-r14 only RC  }
    {!< r13-r14 only RC  }
    { BITCODE_H DIMTXSTY;  }
    { preR13  }
    { preR13  }
    { preR13  }
    {!< r2007+  }
    {!< r2010+  }
    {!< r2010+  }
    {!< r2010+  }
    {!< r2010+  }
    {!< r2010+  }

      _dwg_object_DIMSTYLE = record
          {$define BITCODE_XXlaytype:=BITCODE_RC}
          COMMON_TABLE_FIELDS;
          {$undef BITCODE_XXlaytype}
          DIMTOL : BITCODE_B;
          DIMLIM : BITCODE_B;
          DIMTIH : BITCODE_B;
          DIMTOH : BITCODE_B;
          DIMSE1 : BITCODE_B;
          DIMSE2 : BITCODE_B;
          DIMALT : BITCODE_B;
          DIMTOFL : BITCODE_B;
          DIMSAH : BITCODE_B;
          DIMTIX : BITCODE_B;
          DIMSOXD : BITCODE_B;
          DIMALTD : BITCODE_BS;
          DIMZIN : BITCODE_BS;
          DIMSD1 : BITCODE_B;
          DIMSD2 : BITCODE_B;
          DIMTOLJ : BITCODE_BS;
          DIMJUST : BITCODE_BS;
          DIMFIT : BITCODE_BS;
          DIMUPT : BITCODE_B;
          DIMTZIN : BITCODE_BS;
          DIMMALTZ : BITCODE_BS;
          DIMMALTTZ : BITCODE_BS;
          DIMTAD : BITCODE_BS;
          DIMUNIT : BITCODE_BS;
          DIMAUNIT : BITCODE_BS;
          DIMDEC : BITCODE_BS;
          DIMTDEC : BITCODE_BS;
          DIMALTU : BITCODE_BS;
          DIMALTTD : BITCODE_BS;
          DIMSCALE : BITCODE_BD;
          DIMASZ : BITCODE_BD;
          DIMEXO : BITCODE_BD;
          DIMDLI : BITCODE_BD;
          DIMEXE : BITCODE_BD;
          DIMRND : BITCODE_BD;
          DIMDLE : BITCODE_BD;
          DIMTP : BITCODE_BD;
          DIMTM : BITCODE_BD;
          DIMFXL : BITCODE_BD;
          DIMJOGANG : BITCODE_BD;
          DIMTFILL : BITCODE_BS;
          DIMTFILLCLR : BITCODE_CMC;
          DIMAZIN : BITCODE_BS;
          DIMARCSYM : BITCODE_BS;
          DIMTXT : BITCODE_BD;
          DIMCEN : BITCODE_BD;
          DIMTSZ : BITCODE_BD;
          DIMALTF : BITCODE_BD;
          DIMLFAC : BITCODE_BD;
          DIMTVP : BITCODE_BD;
          DIMTFAC : BITCODE_BD;
          DIMGAP : BITCODE_BD;
          DIMPOST : BITCODE_T;
          DIMAPOST : BITCODE_T;
          DIMBLK_T : BITCODE_T;
          DIMBLK1_T : BITCODE_T;
          DIMBLK2_T : BITCODE_T;
          DIMALTRND : BITCODE_BD;
          DIMCLRD_N : BITCODE_RS;
          DIMCLRE_N : BITCODE_RS;
          DIMCLRT_N : BITCODE_RS;
          DIMCLRD : BITCODE_CMC;
          DIMCLRE : BITCODE_CMC;
          DIMCLRT : BITCODE_CMC;
          DIMADEC : BITCODE_BS;
          DIMFRAC : BITCODE_BS;
          DIMLUNIT : BITCODE_BS;
          DIMDSEP : BITCODE_BS;
          DIMTMOVE : BITCODE_BS;
          DIMALTZ : BITCODE_BS;
          DIMALTTZ : BITCODE_BS;
          DIMATFIT : BITCODE_BS;
          DIMFXLON : BITCODE_B;
          DIMTXTDIRECTION : BITCODE_B;
          DIMALTMZF : BITCODE_BD;
          DIMALTMZS : BITCODE_T;
          DIMMZF : BITCODE_BD;
          DIMMZS : BITCODE_T;
          DIMLWD : BITCODE_BSd;
          DIMLWE : BITCODE_BSd;
          flag0 : BITCODE_B;
          DIMTXSTY : BITCODE_H;
          DIMLDRBLK : BITCODE_H;
          DIMBLK : BITCODE_H;
          DIMBLK1 : BITCODE_H;
          DIMBLK2 : BITCODE_H;
          DIMLTYPE : BITCODE_H;
          DIMLTEX1 : BITCODE_H;
          DIMLTEX2 : BITCODE_H;
        end;
      Dwg_Object_DIMSTYLE = _dwg_object_DIMSTYLE;
    {*
     VX_CONTROL (70) table object (r11-r2000)
     The table header for all viewport entities (unused in newer versions)
     Called VXTable
      }
(* error 
  COMMON_TABLE_CONTROL_FIELDS;
 in declarator_list *)

      _dwg_object_VX_CONTROL = record
          COMMON_TABLE_CONTROL_FIELDS;
        end;
      Dwg_Object_VX_CONTROL = _dwg_object_VX_CONTROL;
    {*
     VX_TABLE_RECORD (71/T10) table object (r11-r2000)
     Called VXTableRecord / VX_TABLE_RECORD
      }

      _dwg_object_VX_TABLE_RECORD = record
          {$define BITCODE_XXlaytype:=BITCODE_RC}
          COMMON_TABLE_FIELDS;
          {$undef BITCODE_XXlaytype}
          is_on : BITCODE_B;
          viewport : BITCODE_H;
          prev_entry : BITCODE_H;
        end;
      Dwg_Object_VX_TABLE_RECORD = _dwg_object_VX_TABLE_RECORD;
    {*
     GROUP (72) object
      }

      _dwg_object_GROUP = record
          parent : ^_dwg_object_object;
          name : BITCODE_TV;
          unnamed : BITCODE_BS;
          selectable : BITCODE_BS;
          num_groups : BITCODE_BL;
          groups : ^BITCODE_H;
        end;
      Dwg_Object_GROUP = _dwg_object_GROUP;
    {*
     MLINESTYLE (73) object
      }
    { until 2018  }
    { since 2018  }

      _dwg_MLINESTYLE_line = record
          parent : ^_dwg_object_MLINESTYLE;
          offset : BITCODE_BD;
          color : BITCODE_CMC;
          lt_index : BITCODE_BSd;
          lt_ltype : BITCODE_H;
        end;
      Dwg_MLINESTYLE_line = _dwg_MLINESTYLE_line;

      _dwg_object_MLINESTYLE = record
          parent : ^_dwg_object_object;
          name : BITCODE_TV;
          description : BITCODE_TV;
          flag : BITCODE_BS;
          fill_color : BITCODE_CMC;
          start_angle : BITCODE_BD;
          end_angle : BITCODE_BD;
          num_lines : BITCODE_RC;
          lines : ^Dwg_MLINESTYLE_line;
        end;
      Dwg_Object_MLINESTYLE = _dwg_object_MLINESTYLE;
    {*
     OLE2FRAME (74 + varies) object
      }
    {!< DXF 71, 1: Link, 2: Embedded, 3: Static  }
    {!< r2000+ DXF 72, tile_mode, 0: mspace, 1: pspace  }
    {!< r2000+ DXF 73, 0 or 1 (locked)  }
    {!< DXF 90  }
    {!< DXF 310, the binary object data  }
    { embedded into data, not yet decoded: }
    { the MS-CFB (ole2 stream) starts at 0x80 in data }
    { before is probably: }
    {!< DXF 70, always 2  }
    {!< DXF 3, e.g. OLE or Paintbrush Picture  }
    {!< DXF 10, upper left corner  }
    {!< DXF 11, lower right corner  }

      _dwg_entity_OLE2FRAME = record
          parent : ^_dwg_object_entity;
          _type : BITCODE_BS;
          mode : BITCODE_BS;
          lock_aspect : BITCODE_RC;
          data_size : BITCODE_BL;
          data : BITCODE_TF;
          oleversion : BITCODE_BS;
          oleclient : BITCODE_TF;
          pt1 : BITCODE_3BD;
          pt2 : BITCODE_3BD;
        end;
      Dwg_Entity_OLE2FRAME = _dwg_entity_OLE2FRAME;
    {*
     DUMMY (75) object, placeholder for unsupported types on encode.
      }

      _dwg_object_DUMMY = record
          parent : ^_dwg_object_object;
        end;
      Dwg_Object_DUMMY = _dwg_object_DUMMY;
    {*
     LONG_TRANSACTION (76) object
      }
    { ??? not seen  }

      _dwg_object_LONG_TRANSACTION = record
          parent : ^_dwg_object_object;
        end;
      Dwg_Object_LONG_TRANSACTION = _dwg_object_LONG_TRANSACTION;
    { NOT SURE ABOUT THIS ONE (IS IT OBJECT OR ENTITY?):  }
    {*
     subtype PROXY_LWPOLYLINE (33) in a PROXY object
     Not a LWPOLYLINE (77? + varies)
      }
    { 40  }
    { 41  }

      _dwg_LWPOLYLINE_width = record
          start : BITCODE_BD;
          &end : BITCODE_BD;
        end;
      Dwg_LWPOLYLINE_width = _dwg_LWPOLYLINE_width;
    { from flags to *widths  }

      _dwg_PROXY_LWPOLYLINE = record
          parent : ^_dwg_entity_PROXY_ENTITY;
          size : BITCODE_RL;
          flags : BITCODE_BS;
          const_width : BITCODE_BD;
          elevation : BITCODE_BD;
          thickness : BITCODE_BD;
          extrusion : BITCODE_BE;
          num_points : BITCODE_BL;
          points : ^BITCODE_2RD;
          num_bulges : BITCODE_BL;
          bulges : ^BITCODE_BD;
          num_widths : BITCODE_BL;
          widths : ^Dwg_LWPOLYLINE_width;
          unknown_1 : BITCODE_RC;
          unknown_2 : BITCODE_RC;
          unknown_3 : BITCODE_RC;
        end;
      Dwg_PROXY_LWPOLYLINE = _dwg_PROXY_LWPOLYLINE;
    {*
     (ACAD_)PROXY_ENTITY (498, 0x1f2) object
      }
    {!< DXF 91, always 498, same as obj->type  }
    {!< DXF 95 <r2018, 71 r2018+  }
    {!< DXF 97 r2018+  }
    {!< DXF 70  }
    {!< DXF 93  }
    {!< DXF 310  }
    {!< DXF 340  }

      _dwg_entity_PROXY_ENTITY = record
          parent : ^_dwg_object_entity;
          class_id : BITCODE_BL;
          version : BITCODE_BL;
          maint_version : BITCODE_BL;
          from_dxf : BITCODE_B;
          data_numbits : BITCODE_BL;
          data_size : BITCODE_BL;
          data : ^BITCODE_RC;
          num_objids : BITCODE_BL;
          objids : ^BITCODE_H;
        end;
      Dwg_Entity_PROXY_ENTITY = _dwg_entity_PROXY_ENTITY;
    {*
     (ACAD_)PROXY OBJECT (499, 0x1f3) object
      }
    {!< DXF 91, always 499, same as obj->type  }
    {!< DXF 95 <r2018, 71 r2018+  }
    {!< DXF 97 r2018+  }
    {!< DXF 70  }
    {!< DXF 93  }
    {!< DXF 310  }
    {!< DXF 340  }

      _dwg_object_PROXY_OBJECT = record
          parent : ^_dwg_object_object;
          class_id : BITCODE_BL;
          version : BITCODE_BL;
          maint_version : BITCODE_BL;
          from_dxf : BITCODE_B;
          data_numbits : BITCODE_BL;
          data_size : BITCODE_BL;
          data : ^BITCODE_RC;
          num_objids : BITCODE_BL;
          objids : ^BITCODE_H;
        end;
      Dwg_Object_PROXY_OBJECT = _dwg_object_PROXY_OBJECT;
    {*
     * types which are fixed and non-fixed:
     * also OLE2FRAME above
      }
    {*
     Structs for HATCH (78 + varies)
      }
    {0.0 non-shifted, 1.0 shifted }

      _dwg_HATCH_Color = record
          parent : ^_dwg_entity_HATCH;
          shift_value : BITCODE_BD;
          color : BITCODE_CMC;
        end;
      Dwg_HATCH_Color = _dwg_HATCH_Color;

      _dwg_HATCH_ControlPoint = record
          parent : ^_dwg_HATCH_PathSeg;
          point : BITCODE_2RD;
          weight : BITCODE_BD;
        end;
      Dwg_HATCH_ControlPoint = _dwg_HATCH_ControlPoint;
    { i.e. curve_type: 1-4 }
    { could be a union }
    { LINE  }
    { CIRCULAR ARC  }
    { ELLIPTICAL ARC  }
    { BITCODE_2RD center  }
    { BITCODE_BD start_angle;  }
    { BITCODE_BD end_angle;  }
    { BITCODE_B is_ccw;  }
    { SPLINE  }

      _dwg_HATCH_PathSeg = record
          parent : ^_dwg_HATCH_Path;
          curve_type : BITCODE_RC;
          first_endpoint : BITCODE_2RD;
          second_endpoint : BITCODE_2RD;
          center : BITCODE_2RD;
          radius : BITCODE_BD;
          start_angle : BITCODE_BD;
          end_angle : BITCODE_BD;
          is_ccw : BITCODE_B;
          endpoint : BITCODE_2RD;
          minor_major_ratio : BITCODE_BD;
          degree : BITCODE_BL;
          is_rational : BITCODE_B;
          is_periodic : BITCODE_B;
          num_knots : BITCODE_BL;
          num_control_points : BITCODE_BL;
          knots : ^BITCODE_BD;
          control_points : ^Dwg_HATCH_ControlPoint;
          num_fitpts : BITCODE_BL;
          fitpts : ^BITCODE_2RD;
          start_tangent : BITCODE_2RD;
          end_tangent : BITCODE_2RD;
        end;
      Dwg_HATCH_PathSeg = _dwg_HATCH_PathSeg;

      _dwg_HATCH_PolylinePath = record
          parent : ^_dwg_HATCH_Path;
          point : BITCODE_2RD;
          bulge : BITCODE_BD;
        end;
      Dwg_HATCH_PolylinePath = _dwg_HATCH_PolylinePath;
    { Segment path  }
    { 2: is_polyline, 4: is_derived, 8: is_textbox,
                          0x20: is_open, 0x80: is_textisland, 0x100: is_duplicate, 0x200: is_annotative  }
    { Polyline path  }
    { needed? }

      _dwg_HATCH_Path = record
          parent : ^_dwg_entity_HATCH;
          flag : BITCODE_BL;
          num_segs_or_paths : BITCODE_BL;
          segs : ^Dwg_HATCH_PathSeg;
          bulges_present : BITCODE_B;
          closed : BITCODE_B;
          polyline_paths : ^Dwg_HATCH_PolylinePath;
          num_boundary_handles : BITCODE_BL;
          boundary_handles : ^BITCODE_H;
        end;
      Dwg_HATCH_Path = _dwg_HATCH_Path;

      _dwg_HATCH_DefLine = record
          parent : ^_dwg_entity_HATCH;
          angle : BITCODE_BD;
          pt0 : BITCODE_2BD;
          offset : BITCODE_2BD;
          num_dashes : BITCODE_BS;
          dashes : ^BITCODE_BD;
        end;
      Dwg_HATCH_DefLine = _dwg_HATCH_DefLine;
    { 1: SPHERICAL, 2: HEMISPHERICAL, 3: CURVED, 4: LINEAR, 5: CYLINDER  }
    { also named loop }
    {BITCODE_BL sum_boundary_handles; }
    {BITCODE_H* boundary_handles; }

      _dwg_entity_HATCH = record
          parent : ^_dwg_object_entity;
          is_gradient_fill : BITCODE_BL;
          reserved : BITCODE_BL;
          gradient_angle : BITCODE_BD;
          gradient_shift : BITCODE_BD;
          single_color_gradient : BITCODE_BL;
          gradient_tint : BITCODE_BD;
          num_colors : BITCODE_BL;
          colors : ^Dwg_HATCH_Color;
          gradient_name : BITCODE_T;
          elevation : BITCODE_BD;
          extrusion : BITCODE_BE;
          name : BITCODE_TV;
          is_solid_fill : BITCODE_B;
          is_associative : BITCODE_B;
          num_paths : BITCODE_BL;
          paths : ^Dwg_HATCH_Path;
          style : BITCODE_BS;
          pattern_type : BITCODE_BS;
          angle : BITCODE_BD;
          scale_spacing : BITCODE_BD;
          double_flag : BITCODE_B;
          num_deflines : BITCODE_BS;
          deflines : ^Dwg_HATCH_DefLine;
          has_derived : BITCODE_B;
          pixel_size : BITCODE_BD;
          num_seeds : BITCODE_BL;
          seeds : ^BITCODE_2RD;
        end;
      Dwg_Entity_HATCH = _dwg_entity_HATCH;
    { derived from Hatch }
    { 1: SPHERICAL, 2: HEMISPHERICAL, 3: CURVED, 4: LINEAR, 5: CYLINDER  }
    { also named loop }
    { DXF 62  }
    { DXF 11 (ocs)  }
    { DXF 99  }
    {BITCODE_H* boundary_handles; }

      _dwg_entity_MPOLYGON = record
          parent : ^_dwg_object_entity;
          is_gradient_fill : BITCODE_BL;
          reserved : BITCODE_BL;
          gradient_angle : BITCODE_BD;
          gradient_shift : BITCODE_BD;
          single_color_gradient : BITCODE_BL;
          gradient_tint : BITCODE_BD;
          num_colors : BITCODE_BL;
          colors : ^Dwg_HATCH_Color;
          gradient_name : BITCODE_T;
          elevation : BITCODE_BD;
          extrusion : BITCODE_BE;
          name : BITCODE_T;
          is_solid_fill : BITCODE_B;
          is_associative : BITCODE_B;
          num_paths : BITCODE_BL;
          paths : ^Dwg_HATCH_Path;
          style : BITCODE_BS;
          pattern_type : BITCODE_BS;
          angle : BITCODE_BD;
          scale_spacing : BITCODE_BD;
          double_flag : BITCODE_B;
          num_deflines : BITCODE_BS;
          deflines : ^Dwg_HATCH_DefLine;
          color : BITCODE_CMC;
          x_dir : BITCODE_2RD;
          num_boundary_handles : BITCODE_BL;
        end;
      Dwg_Entity_MPOLYGON = _dwg_entity_MPOLYGON;
    {*
     XRECORD (79 + varies) object
      }
    { DXF 280, as with DICTIONARY.
                             DuplicateRecordCloning mergeStyle:
                             1: erase allowed,
                             0x80: cloning allowed  }
    { computed  }

      _dwg_object_XRECORD = record
          parent : ^_dwg_object_object;
          cloning : BITCODE_BS;
          xdata_size : BITCODE_BL;
          num_xdata : BITCODE_BL;
          xdata : ^Dwg_Resbuf;
          num_objid_handles : BITCODE_BL;
          objid_handles : ^BITCODE_H;
        end;
      Dwg_Object_XRECORD = _dwg_object_XRECORD;
    {*
     PLACEHOLDER (80 + varies) object
     ACDBPLACEHOLDER
      }

      _dwg_object_PLACEHOLDER = record
          parent : ^_dwg_object_object;
        end;
      Dwg_Object_PLACEHOLDER = _dwg_object_PLACEHOLDER;
    {*
     * Entity MULTILEADER (varies)
     * R2000+ in work
      }
    {!< DXF 12  }
    {!< DXF 13  }

      _dwg_LEADER_Break = record
          parent : ^_dwg_LEADER_Line;
          start : BITCODE_3BD;
          &end : BITCODE_3BD;
        end;
      Dwg_LEADER_Break = _dwg_LEADER_Break;
    { as documented by DXF }
    {!< DXF 10  }
    {!< DXF 12, 13  }
    {!< DXF 91  }
    {!< r2010+:  }
    { 0 = invisible leader, 1 = straight leader, 2 = spline leader }
    { of the line }
    { 5 340 }
    { 5 341 }
    { 1 = leader type, 2 = line color, 4 = line type, 8 = line weight, }
    { 16 = arrow size, 32 = arrow symbol (handle) }

      _dwg_LEADER_Line = record
          parent : ^_dwg_LEADER_Node;
          num_points : BITCODE_BL;
          points : ^BITCODE_3DPOINT;
          num_breaks : BITCODE_BL;
          breaks : ^Dwg_LEADER_Break;
          line_index : BITCODE_BL;
          _type : BITCODE_BS;
          color : BITCODE_CMC;
          ltype : BITCODE_H;
          linewt : BITCODE_BLd;
          arrow_size : BITCODE_BD;
          arrow_handle : BITCODE_H;
          flags : BITCODE_BL;
        end;
      Dwg_LEADER_Line = _dwg_LEADER_Line;

      _dwg_LEADER_ArrowHead = record
          parent : ^_dwg_entity_MULTILEADER;
          is_default : BITCODE_B;
          arrowhead : BITCODE_H;
        end;
      Dwg_LEADER_ArrowHead = _dwg_LEADER_ArrowHead;

      _dwg_LEADER_BlockLabel = record
          parent : ^_dwg_entity_MULTILEADER;
          attdef : BITCODE_H;
          label_text : BITCODE_TV;
          ui_index : BITCODE_BS;
          width : BITCODE_BD;
        end;
      Dwg_LEADER_BlockLabel = _dwg_LEADER_BlockLabel;
    {!< DXF 290  }
    {!< DXF 291  }
    {!< DXF 10  }
    {!< DXF 11  }
    {!< DXF 90  }
    {!< DXF 40  }
    {!< DXF 10  }
    {!< DXF 12, 13  }
    {2010+ 271 }

      _dwg_LEADER_Node = record
          parent : ^_dwg_entity_MULTILEADER;
          has_lastleaderlinepoint : BITCODE_B;
          has_dogleg : BITCODE_B;
          lastleaderlinepoint : BITCODE_3BD;
          dogleg_vector : BITCODE_3BD;
          branch_index : BITCODE_BL;
          dogleg_length : BITCODE_BD;
          num_lines : BITCODE_BL;
          lines : ^Dwg_LEADER_Line;
          num_breaks : BITCODE_BL;
          breaks : ^Dwg_LEADER_Break;
          attach_dir : BITCODE_BS;
        end;
      Dwg_LEADER_Node = _dwg_LEADER_Node;
    { common to text and block }
    {$define CMLContent_fields:=&type:BITCODE_RC; (* 1 for blk, 2 for text *)normal:BITCODE_3BD;location:BITCODE_3BD;rotation:BITCODE_BD}
      _dwg_MLEADER_Content_MText = record
          CMLContent_fields;
          style : BITCODE_H;
          direction : BITCODE_3BD;
          color : BITCODE_CMC;
          width : BITCODE_BD;
          height : BITCODE_BD;
          line_spacing_factor : BITCODE_BD;
          default_text : BITCODE_T;
          line_spacing_style : BITCODE_BS;
          alignment : BITCODE_BS;
          flow : BITCODE_BS;
          bg_color : BITCODE_CMC;
          bg_scale : BITCODE_BD;
          bg_transparency : BITCODE_BL;
          is_bg_fill : BITCODE_B;
          is_bg_mask_fill : BITCODE_B;
          col_type : BITCODE_BS;
          is_height_auto : BITCODE_B;
          col_width : BITCODE_BD;
          col_gutter : BITCODE_BD;
          is_col_flow_reversed : BITCODE_B;
          num_col_sizes : BITCODE_BL;
          col_sizes : ^BITCODE_BD;
          word_break : BITCODE_B;
          unknown : BITCODE_B;
        end;
      Dwg_MLEADER_Content_MText = _dwg_MLEADER_Content_MText;

      _dwg_MLEADER_Content_Block = record
          CMLContent_fields;
          block_table : BITCODE_H;
          scale : BITCODE_3BD;
          color : BITCODE_CMC;
          transform : ^BITCODE_BD;
        end;
      Dwg_MLEADER_Content_Block = _dwg_MLEADER_Content_Block;

      _dwg_MLEADER_Content = record
          case longint of
            0 : ( txt : Dwg_MLEADER_Content_MText );
            1 : ( blk : Dwg_MLEADER_Content_Block );
          end;
      Dwg_MLEADER_Content = _dwg_MLEADER_Content;
    { The MLeaderAnnotContext object (par 20.4.86), embedded into an MLEADER  }
    { AcDbObjectContextData: }
    { BITCODE_BS class_version;  /*!< r2010+ DXF 70 4 */ }
    { BITCODE_B is_default;      /*!< r2010+ DXF 290 1 */ }
    { BITCODE_B has_xdic;        /*!< r2010+  */ }
    { AcDbAnnotScaleObjectContextData: }
    { BITCODE_H scale;           /*!< DXF 340 hard ptr to AcDbScale */ }
    { union txt/blk }

      _dwg_MLEADER_AnnotContext = record
          num_leaders : BITCODE_BL;
          leaders : ^Dwg_LEADER_Node;
          attach_dir : BITCODE_BS;
          scale_factor : BITCODE_BD;
          content_base : BITCODE_3BD;
          text_height : BITCODE_BD;
          arrow_size : BITCODE_BD;
          landing_gap : BITCODE_BD;
          text_left : BITCODE_BS;
          text_right : BITCODE_BS;
          text_angletype : BITCODE_BS;
          text_alignment : BITCODE_BS;
          has_content_txt : BITCODE_B;
          has_content_blk : BITCODE_B;
          content : Dwg_MLEADER_Content;
          base : BITCODE_3BD;
          base_dir : BITCODE_3BD;
          base_vert : BITCODE_3BD;
          is_normal_reversed : BITCODE_B;
          text_top : BITCODE_BS;
          text_bottom : BITCODE_BS;
        end;
      Dwg_MLEADER_AnnotContext = _dwg_MLEADER_AnnotContext;
    { dbmleader.h }
    {!< r2010+ =2  }
    { DXF  340  }
    { override. DXF 90  }
    { the default  }
    { internal blocks mostly, _TagSlot, _TagHexagon, }
    { _DetailCallout, ... }
    { 0 = center extents, 1 = insertion point }
    { until r2007:  }
    {!< r2010+ (0 = horizontal, 1 = vertical)  }
    {!< r2010+  }
    {!< r2010+  }
    {!< r2013+  }

      _dwg_entity_MULTILEADER = record
          parent : ^_dwg_object_entity;
          class_version : BITCODE_BS;
          ctx : Dwg_MLEADER_AnnotContext;
          mleaderstyle : BITCODE_H;
          flags : BITCODE_BL;
          _type : BITCODE_BS;
          color : BITCODE_CMC;
          ltype : BITCODE_H;
          linewt : BITCODE_BLd;
          has_landing : BITCODE_B;
          has_dogleg : BITCODE_B;
          landing_dist : BITCODE_BD;
          arrow_handle : BITCODE_H;
          arrow_size : BITCODE_BD;
          style_content : BITCODE_BS;
          text_style : BITCODE_H;
          text_left : BITCODE_BS;
          text_right : BITCODE_BS;
          text_angletype : BITCODE_BS;
          text_alignment : BITCODE_BS;
          text_color : BITCODE_CMC;
          has_text_frame : BITCODE_B;
          block_style : BITCODE_H;
          block_color : BITCODE_CMC;
          block_scale : BITCODE_3BD;
          block_rotation : BITCODE_BD;
          style_attachment : BITCODE_BS;
          is_annotative : BITCODE_B;
          num_arrowheads : BITCODE_BL;
          arrowheads : ^Dwg_LEADER_ArrowHead;
          num_blocklabels : BITCODE_BL;
          blocklabels : ^Dwg_LEADER_BlockLabel;
          is_neg_textdir : BITCODE_B;
          ipe_alignment : BITCODE_BS;
          justification : BITCODE_BS;
          scale_factor : BITCODE_BD;
          attach_dir : BITCODE_BS;
          attach_top : BITCODE_BS;
          attach_bottom : BITCODE_BS;
          is_text_extended : BITCODE_B;
        end;
      Dwg_Entity_MULTILEADER = _dwg_entity_MULTILEADER;
    {*
     * Object MLEADERSTYLE (varies)
     * R2000+
      }
    {!< DXF 179, r2010+ =2  }
    {!< r2010+ (0 = horizontal, 1 = vertical)  }
    {!< r2010+  }
    {!< r2010+  }
    {!< r2013+  }

      _dwg_object_MLEADERSTYLE = record
          parent : ^_dwg_object_object;
          class_version : BITCODE_BS;
          content_type : BITCODE_BS;
          mleader_order : BITCODE_BS;
          leader_order : BITCODE_BS;
          max_points : BITCODE_BL;
          first_seg_angle : BITCODE_BD;
          second_seg_angle : BITCODE_BD;
          _type : BITCODE_BS;
          line_color : BITCODE_CMC;
          line_type : BITCODE_H;
          linewt : BITCODE_BLd;
          has_landing : BITCODE_B;
          has_dogleg : BITCODE_B;
          landing_gap : BITCODE_BD;
          landing_dist : BITCODE_BD;
          description : BITCODE_TV;
          arrow_head : BITCODE_H;
          arrow_head_size : BITCODE_BD;
          text_default : BITCODE_TV;
          text_style : BITCODE_H;
          attach_left : BITCODE_BS;
          attach_right : BITCODE_BS;
          text_angle_type : BITCODE_BS;
          text_align_type : BITCODE_BS;
          text_color : BITCODE_CMC;
          text_height : BITCODE_BD;
          has_text_frame : BITCODE_B;
          text_always_left : BITCODE_B;
          align_space : BITCODE_BD;
          block : BITCODE_H;
          block_color : BITCODE_CMC;
          block_scale : BITCODE_3BD;
          use_block_scale : BITCODE_B;
          block_rotation : BITCODE_BD;
          use_block_rotation : BITCODE_B;
          block_connection : BITCODE_BS;
          scale : BITCODE_BD;
          is_changed : BITCODE_B;
          is_annotative : BITCODE_B;
          break_size : BITCODE_BD;
          attach_dir : BITCODE_BS;
          attach_top : BITCODE_BS;
          attach_bottom : BITCODE_BS;
          text_extended : BITCODE_B;
        end;
      Dwg_Object_MLEADERSTYLE = _dwg_object_MLEADERSTYLE;
    {*
     VBA_PROJECT (81 + varies) object
     Has its own optional section? section[5]?
      }

      _dwg_object_VBA_PROJECT = record
          parent : ^_dwg_object_object;
          data_size : BITCODE_BL;
          data : BITCODE_TF;
        end;
      Dwg_Object_VBA_PROJECT = _dwg_object_VBA_PROJECT;
    {*
     Object PLOTSETTINGS (varies)
     See also LAYOUT.
      }
    {!< DXF 1  }
    {!< DXF 2  }
    {!< DXF 4  }
    {!< DXF 70
                                     1 = PlotViewportBorders
                                     2 = ShowPlotStyles
                                     4 = PlotCentered
                                     8 = PlotHidden
                                     16 = UseStandardScale
                                     32 = PlotPlotStyles
                                     64 = ScaleLineweights
                                     128 = PrintLineweights
                                     512 = DrawViewportsFirst
                                     1024 = ModelType
                                     2048 = UpdatePaper
                                     4096 = ZoomToPaperOnUpdate
                                     8192 = Initializing
                                     16384 = PrevPlotInit  }
    {!< DXF 6, r2004+  }
    {!< DXF 6, until r2000  }
    {!< DXF 40, margins in mm  }
    {!< DXF 42  }
    {!< DXF 43  }
    {!< DXF 44  }
    {!< DXF 44, in mm  }
    {!< DXF 45, in mm  }
    {!< DXF 46,47  }
    {!< DXF 48,49  }
    {!< DXF 140,141  }
    {!< DXF 72,  0 inches, 1 mm, 2 pixel  }
    {!< DXF 73,  0 normal, 1 90, 2 180, 3 270 deg  }
    {!< DXF 74,  0 display, 1 extents, 2 limits, 3 view
                               (see DXF 6), 4 window (see 48-140), 5 layout  }
    {!< DXF 142  }
    {!< DXF 143  }
    {!< DXF 7  }
    {!< DXF 75, 0 = scaled to fit,
                                          1 = 1/128"=1', 2 = 1/64"=1', 3 = 1/32"=1'
                                          4 = 1/16"=1', 5 = 3/32"=1', 6 = 1/8"=1'
                                          7 = 3/16"=1', 8 = 1/4"=1', 9 = 3/8"=1'
                                          10 = 1/2"=1', 11 = 3/4"=1', 12 = 1"=1'
                                          13 = 3"=1', 14 = 6"=1', 15 = 1'=1'
                                          16 = 1:1, 17= 1:2, 18 = 1:4 19 = 1:8, 20 = 1:10, 21=
                                          1:16               22 = 1:20, 23 = 1:30, 24 = 1:40, 25 = 1:50, 26 =
                                          1:100               27 = 2:1, 28 = 4:1, 29 = 8:1, 30 = 10:1, 31 =
                                          100:1, 32 = 1000:1
                                         }
    {!< DXF 147, value of 75  }
    {!< DXF 148 + 149  }
    {!< DXF 76, 0 display, 1 wireframe, 2 hidden, 3
                                    rendered, 4 visualstyle, 5 renderPreset  }
    {!< DXF 77, 0 draft, 1 preview, 2 nomal,
                                                   3 presentation, 4 maximum, 5 custom  }
    {!< DXF 78, 100-32767  }
    {!< DXF 333 optional. As in VIEWPORT  }

      _dwg_object_PLOTSETTINGS = record
          parent : ^_dwg_object_object;
          printer_cfg_file : BITCODE_T;
          paper_size : BITCODE_T;
          canonical_media_name : BITCODE_T;
          plot_flags : BITCODE_BS;
          plotview : BITCODE_H;
          plotview_name : BITCODE_T;
          left_margin : BITCODE_BD;
          bottom_margin : BITCODE_BD;
          right_margin : BITCODE_BD;
          top_margin : BITCODE_BD;
          paper_width : BITCODE_BD;
          paper_height : BITCODE_BD;
          plot_origin : BITCODE_2BD_1;
          plot_window_ll : BITCODE_2BD_1;
          plot_window_ur : BITCODE_2BD_1;
          plot_paper_unit : BITCODE_BS;
          plot_rotation_mode : BITCODE_BS;
          plot_type : BITCODE_BS;
          paper_units : BITCODE_BD;
          drawing_units : BITCODE_BD;
          stylesheet : BITCODE_T;
          std_scale_type : BITCODE_BS;
          std_scale_factor : BITCODE_BD;
          paper_image_origin : BITCODE_2BD_1;
          shadeplot_type : BITCODE_BS;
          shadeplot_reslevel : BITCODE_BS;
          shadeplot_customdpi : BITCODE_BS;
          shadeplot : BITCODE_H;
        end;
      Dwg_Object_PLOTSETTINGS = _dwg_object_PLOTSETTINGS;
    {*
     LAYOUT (82 + varies) object
      }
    { AcDbPlotSettings: }
    { AcDbLayout: }
    { 1: PSLTSCALE, 2: LIMCHECK  }
    { r2004+ }
    { r2004+ }

      _dwg_object_LAYOUT = record
          parent : ^_dwg_object_object;
          plotsettings : Dwg_Object_PLOTSETTINGS;
          layout_name : BITCODE_T;
          tab_order : BITCODE_BS;
          layout_flags : BITCODE_BS;
          INSBASE : BITCODE_3DPOINT;
          LIMMIN : BITCODE_2DPOINT;
          LIMMAX : BITCODE_2DPOINT;
          UCSORG : BITCODE_3DPOINT;
          UCSXDIR : BITCODE_3DPOINT;
          UCSYDIR : BITCODE_3DPOINT;
          ucs_elevation : BITCODE_BD;
          UCSORTHOVIEW : BITCODE_BS;
          EXTMIN : BITCODE_3DPOINT;
          EXTMAX : BITCODE_3DPOINT;
          block_header : BITCODE_H;
          active_viewport : BITCODE_H;
          base_ucs : BITCODE_H;
          named_ucs : BITCODE_H;
          num_viewports : BITCODE_BL;
          viewports : ^BITCODE_H;
        end;
      Dwg_Object_LAYOUT = _dwg_object_LAYOUT;
    {*
     * And the non-fixed types, classes, only
      }
    {*
     Class DICTIONARYVAR (varies)
      }

      _dwg_object_DICTIONARYVAR = record
          parent : ^_dwg_object_object;
          schema : BITCODE_RC;
          strvalue : BITCODE_T;
        end;
      Dwg_Object_DICTIONARYVAR = _dwg_object_DICTIONARYVAR;
    {*
     Class TABLE (varies)
      }
    { 20.4.99. also for FIELD }
    { DXF 90  }
    { DXF 93, r2007+  }

      _dwg_TABLE_value = record
          flags : BITCODE_BL;
          format_flags : BITCODE_BL;
          data_type : BITCODE_BL;
          data_size : BITCODE_BL;
          data_long : BITCODE_BL;
          data_double : BITCODE_BD;
          data_string : BITCODE_T;
          data_date : BITCODE_TF;
          data_point : BITCODE_2RD;
          data_3dpoint : BITCODE_3RD;
          data_handle : BITCODE_H;
          unit_type : BITCODE_BL;
          format_string : BITCODE_T;
          value_string : BITCODE_T;
        end;
      Dwg_TABLE_value = _dwg_TABLE_value;
    { 20.4.100 Custom data collection for table cells, cols, rows }

      _dwg_TABLE_CustomDataItem = record
          name : BITCODE_T;
          value : Dwg_TABLE_value;
          cell_parent : ^_dwg_TableCell;
          row_parent : ^_dwg_TableRow;
        end;
      Dwg_TABLE_CustomDataItem = _dwg_TABLE_CustomDataItem;

      _dwg_TABLE_AttrDef = record
          parent : ^_dwg_TABLE_Cell;
          attdef : BITCODE_H;
          index : BITCODE_BS;
          text : BITCODE_T;
        end;
      Dwg_TABLE_AttrDef = _dwg_TABLE_AttrDef;
    { BITCODE_H text_style_override; }

      _dwg_TABLE_Cell = record
          parent : ^_dwg_entity_TABLE;
          _type : BITCODE_BS;
          flags : BITCODE_RC;
          is_merged_value : BITCODE_B;
          is_autofit_flag : BITCODE_B;
          merged_width_flag : BITCODE_BL;
          merged_height_flag : BITCODE_BL;
          rotation : BITCODE_BD;
          text_value : BITCODE_T;
          text_style : BITCODE_H;
          block_handle : BITCODE_H;
          block_scale : BITCODE_BD;
          additional_data_flag : BITCODE_B;
          cell_flag_override : BITCODE_BL;
          virtual_edge_flag : BITCODE_RC;
          cell_alignment : BITCODE_RS;
          bg_fill_none : BITCODE_B;
          bg_color : BITCODE_CMC;
          content_color : BITCODE_CMC;
          text_height : BITCODE_BD;
          top_grid_color : BITCODE_CMC;
          top_grid_linewt : BITCODE_BS;
          top_visibility : BITCODE_BS;
          right_grid_color : BITCODE_CMC;
          right_grid_linewt : BITCODE_BS;
          right_visibility : BITCODE_BS;
          bottom_grid_color : BITCODE_CMC;
          bottom_grid_linewt : BITCODE_BS;
          bottom_visibility : BITCODE_BS;
          left_grid_color : BITCODE_CMC;
          left_grid_linewt : BITCODE_BS;
          left_visibility : BITCODE_BS;
          unknown : BITCODE_BL;
          value : Dwg_TABLE_value;
          num_attr_defs : BITCODE_BL;
          attr_defs : ^Dwg_TABLE_AttrDef;
        end;
      Dwg_TABLE_Cell = _dwg_TABLE_Cell;

      _dwg_TABLE_BreakHeight = record
          parent : ^_dwg_entity_TABLE;
          position : BITCODE_3BD;
          height : BITCODE_BD;
          flag : BITCODE_BL;
        end;
      Dwg_TABLE_BreakHeight = _dwg_TABLE_BreakHeight;

      _dwg_TABLE_BreakRow = record
          parent : ^_dwg_entity_TABLE;
          position : BITCODE_3BD;
          start : BITCODE_BL;
          &end : BITCODE_BL;
        end;
      Dwg_TABLE_BreakRow = _dwg_TABLE_BreakRow;
    { max 16, dxf 1 }
    { max 24, dxf 300 }

      _dwg_LinkedData = record
          name : BITCODE_T;
          description : BITCODE_T;
        end;
      Dwg_LinkedData = _dwg_LinkedData;

      _dwg_TableCellContent_Attr = record
          parent : ^_dwg_TableCellContent;
          attdef : BITCODE_H;
          value : BITCODE_TV;
          index : BITCODE_BL;
        end;
      Dwg_TableCellContent_Attr = _dwg_TableCellContent_Attr;
    { Content format 20.4.101.3 }
    { see 20.4.98  }
    { see 20.4.98  }

      _dwg_ContentFormat = record
          property_override_flags : BITCODE_BL;
          property_flags : BITCODE_BL;
          value_data_type : BITCODE_BL;
          value_unit_type : BITCODE_BL;
          value_format_string : BITCODE_TV;
          rotation : BITCODE_BD;
          block_scale : BITCODE_BD;
          cell_alignment : BITCODE_BL;
          content_color : BITCODE_CMC;
          text_style : BITCODE_H;
          text_height : BITCODE_BD;
        end;
      Dwg_ContentFormat = _dwg_ContentFormat;
    { 20.4.99 Value }

      _dwg_TableCellContent = record
          parent : ^_dwg_TableCell;
          _type : BITCODE_BL;
          value : Dwg_TABLE_value;
          handle : BITCODE_H;
          num_attrs : BITCODE_BL;
          attrs : ^Dwg_TableCellContent_Attr;
          has_content_format_overrides : BITCODE_BS;
          content_format : Dwg_ContentFormat;
        end;
      Dwg_TableCellContent = _dwg_TableCellContent;
    { 20.4.98 }
    { ODA bug, BD there. DXF 95  }

      _dwg_CellContentGeometry = record
          dist_top_left : BITCODE_3BD;
          dist_center : BITCODE_3BD;
          content_width : BITCODE_BD;
          content_height : BITCODE_BD;
          width : BITCODE_BD;
          height : BITCODE_BD;
          unknown : BITCODE_BL;
          cell_parent : ^_dwg_TableCell;
          geom_parent : ^_dwg_TABLEGEOMETRY_Cell;
        end;
      Dwg_CellContentGeometry = _dwg_CellContentGeometry;

      _dwg_TableCell = record
          flag : BITCODE_BL;
          tooltip : BITCODE_TV;
          customdata : BITCODE_BL;
          num_customdata_items : BITCODE_BL;
          customdata_items : ^Dwg_TABLE_CustomDataItem;
          has_linked_data : BITCODE_BL;
          data_link : BITCODE_H;
          num_rows : BITCODE_BL;
          num_cols : BITCODE_BL;
          unknown : BITCODE_BL;
          num_cell_contents : BITCODE_BL;
          cell_contents : ^Dwg_TableCellContent;
          style_id : BITCODE_BL;
          has_geom_data : BITCODE_BL;
          geom_data_flag : BITCODE_BL;
          width_w_gap : BITCODE_BD;
          height_w_gap : BITCODE_BD;
          tablegeometry : BITCODE_H;
          num_geometry : BITCODE_BL;
          geometry : ^Dwg_CellContentGeometry;
          style_parent : ^_dwg_CellStyle;
          row_parent : ^_dwg_TableRow;
        end;
      Dwg_TableCell = _dwg_TableCell;
    { almost like GridLine/TABLESTYLE_border }
    { in ODA named OdTableGridLine, was BorderStyle }
    { 95. ie: 1,2,4,8,16,32  }

      _dwg_GridFormat = record
          parent : ^_dwg_CellStyle;
          index_mask : BITCODE_BL;
          border_overrides : BITCODE_BL;
          border_type : BITCODE_BL;
          color : BITCODE_CMC;
          linewt : BITCODE_BLd;
          ltype : BITCODE_H;
          visible : BITCODE_B;
          double_line_spacing : BITCODE_BD;
        end;
      Dwg_GridFormat = _dwg_GridFormat;
    {*
      Cell style 20.4.101.4
      for TABLE, TABLECONTENT, CELLSTYLEMAP
     }
    { 1 cell, 2 row, 3 col, 4 fmt data, 5 table  }
    { 0-6, number of edge_flags set  }

      _dwg_CellStyle = record
          _type : BITCODE_BL;
          data_flags : BITCODE_BS;
          property_override_flags : BITCODE_BL;
          merge_flags : BITCODE_BL;
          bg_color : BITCODE_CMC;
          content_layout : BITCODE_BL;
          content_format : Dwg_ContentFormat;
          margin_override_flags : BITCODE_BS;
          vert_margin : BITCODE_BD;
          horiz_margin : BITCODE_BD;
          bottom_margin : BITCODE_BD;
          right_margin : BITCODE_BD;
          margin_horiz_spacing : BITCODE_BD;
          margin_vert_spacing : BITCODE_BD;
          num_borders : BITCODE_BL;
          borders : ^Dwg_GridFormat;
          tablerow_parent : ^_dwg_TableRow;
          tabledatacolumn_parent : ^_dwg_TableDataColumn;
        end;
      Dwg_CellStyle = _dwg_CellStyle;

      _dwg_TableRow = record
          parent : ^_dwg_LinkedTableData;
          num_cells : BITCODE_BL;
          cells : ^Dwg_TableCell;
          custom_data : BITCODE_BL;
          num_customdata_items : BITCODE_BL;
          customdata_items : ^Dwg_TABLE_CustomDataItem;
          cellstyle : Dwg_CellStyle;
          style_id : BITCODE_BL;
          height : BITCODE_BL;
        end;
      Dwg_TableRow = _dwg_TableRow;
    { BITCODE_TV data; }

      _dwg_TableDataColumn = record
          parent : ^_dwg_LinkedTableData;
          name : BITCODE_T;
          custom_data : BITCODE_BL;
          cellstyle : Dwg_CellStyle;
          cellstyle_id : BITCODE_BL;
          width : BITCODE_BL;
        end;
      Dwg_TableDataColumn = _dwg_TableDataColumn;

      _dwg_LinkedTableData = record
          num_cols : BITCODE_BL;
          cols : ^Dwg_TableDataColumn;
          num_rows : BITCODE_BL;
          rows : ^Dwg_TableRow;
          num_field_refs : BITCODE_BL;
          field_refs : ^BITCODE_H;
        end;
      Dwg_LinkedTableData = _dwg_LinkedTableData;

      _dwg_FormattedTableMerged = record
          parent : ^_dwg_FormattedTableData;
          top_row : BITCODE_BL;
          left_col : BITCODE_BL;
          bottom_row : BITCODE_BL;
          right_col : BITCODE_BL;
        end;
      Dwg_FormattedTableMerged = _dwg_FormattedTableMerged;

      _dwg_FormattedTableData = record
          parent : ^_dwg_object_TABLECONTENT;
          cellstyle : Dwg_CellStyle;
          num_merged_cells : BITCODE_BL;
          merged_cells : ^Dwg_FormattedTableMerged;
        end;
      Dwg_FormattedTableData = _dwg_FormattedTableData;

      {$define TABLECONTENT_fields:=ldata:Dwg_LinkedData;tdata:Dwg_LinkedTableData;fdata:Dwg_FormattedTableData;tablestyle:BITCODE_H}

      _dwg_object_TABLECONTENT = record
          parent : ^_dwg_object_object;
          TABLECONTENT_fields;
        end;
      Dwg_Object_TABLECONTENT = _dwg_object_TABLECONTENT;


    {!< DXF 10  }
    {!< DXF 41  }
    {!< DXF 50  }
    {!< DXF 210  }
    {!< DXF 66  }
    {!< DXF 90.
                                         Bit flags, 0x06 (0x02 + 0x04): has block,
                                         0x10: table direction, 0 = up, 1 = down,
                                         0x20: title suppressed.
                                         Normally 0x06 is always set.  }
    {!< DXF 11  }
    {!< DXF 90  }
    {!< DXF 91  }
    {!< computed  }
    {!< DXF 142  }
    {!< DXF 141  }
    {!< DXF 93  }
    {!< DXF 280  }
    {!< DXF 281  }
    {!< DXF 70  }
    {!< DXF 40  }
    {!< DXF 41  }
    {!< DXF 64  }
    {!< DXF 64  }
    {!< DXF 64  }
    {!< DXF 283  }
    {!< DXF 283  }
    {!< DXF 283  }
    {!< DXF 63  }
    {!< DXF 63  }
    {!< DXF 63  }
    {!< DXF 170  }
    {!< DXF 170  }
    {!< DXF 170  }
    {!< DXF 7  }
    {!< DXF 7  }
    {!< DXF 7  }
    {!< DXF 140  }
    {!< DXF 140  }
    {!< DXF 140  }
    {!< if DXF 94 > 0  }
    {!< DXF 94  }
    {!< DXF 64 if DXF 94 & 0x1  }
    {!< DXF 65 if DXF 94 & 0x2  }
    {!< DXF 66 if DXF 94 & 0x4  }
    {!< DXF 63 if DXF 94 & 0x8  }
    {!< DXF 68 if DXF 94 & 0x10  }
    {!< DXF 69 if DXF 94 & 0x20  }
    {!< DXF 64 if DXF 94 & 0x40  }
    {!< DXF 65  }
    {!< DXF 66  }
    {!< DXF 63  }
    {!< DXF 68  }
    {!< DXF 69  }
    {!< DXF 64  }
    {!< DXF 65  }
    {!< DXF 66  }
    {!< DXF 63  }
    {!< DXF 68  }
    {!< DXF 69  }
    {!< if DXF 95 > 0  }
    {!< DXF 95  }
    {!< DXF 96  }

      _dwg_entity_TABLE = record
          parent : ^_dwg_object_entity;
          {r2010+ TABLECONTENT: }
          TABLECONTENT_fields;
          unknown_rc : BITCODE_RC;
          unknown_h : BITCODE_H;
          unknown_bl : BITCODE_BL;
          unknown_b : BITCODE_B;
          unknown_bl1 : BITCODE_BL;
          ins_pt : BITCODE_3BD;
          scale : BITCODE_3BD;
          scale_flag : BITCODE_BB;
          rotation : BITCODE_BD;
          extrusion : BITCODE_BE;
          has_attribs : BITCODE_B;
          num_owned : BITCODE_BL;
          flag_for_table_value : BITCODE_BS;
          horiz_direction : BITCODE_3BD;
          num_cols : BITCODE_BL;
          num_rows : BITCODE_BL;
          num_cells : dword;
          col_widths : ^BITCODE_BD;
          row_heights : ^BITCODE_BD;
          cells : ^Dwg_TABLE_Cell;
          has_table_overrides : BITCODE_B;
          table_flag_override : BITCODE_BL;
          title_suppressed : BITCODE_B;
          header_suppressed : BITCODE_B;
          flow_direction : BITCODE_BS;
          horiz_cell_margin : BITCODE_BD;
          vert_cell_margin : BITCODE_BD;
          title_row_color : BITCODE_CMC;
          header_row_color : BITCODE_CMC;
          data_row_color : BITCODE_CMC;
          title_row_fill_none : BITCODE_B;
          header_row_fill_none : BITCODE_B;
          data_row_fill_none : BITCODE_B;
          title_row_fill_color : BITCODE_CMC;
          header_row_fill_color : BITCODE_CMC;
          data_row_fill_color : BITCODE_CMC;
          title_row_alignment : BITCODE_BS;
          header_row_alignment : BITCODE_BS;
          data_row_alignment : BITCODE_BS;
          title_text_style : BITCODE_H;
          header_text_style : BITCODE_H;
          data_text_style : BITCODE_H;
          title_row_height : BITCODE_BD;
          header_row_height : BITCODE_BD;
          data_row_height : BITCODE_BD;
          has_border_color_overrides : BITCODE_B;
          border_color_overrides_flag : BITCODE_BL;
          title_horiz_top_color : BITCODE_CMC;
          title_horiz_ins_color : BITCODE_CMC;
          title_horiz_bottom_color : BITCODE_CMC;
          title_vert_left_color : BITCODE_CMC;
          title_vert_ins_color : BITCODE_CMC;
          title_vert_right_color : BITCODE_CMC;
          header_horiz_top_color : BITCODE_CMC;
          header_horiz_ins_color : BITCODE_CMC;
          header_horiz_bottom_color : BITCODE_CMC;
          header_vert_left_color : BITCODE_CMC;
          header_vert_ins_color : BITCODE_CMC;
          header_vert_right_color : BITCODE_CMC;
          data_horiz_top_color : BITCODE_CMC;
          data_horiz_ins_color : BITCODE_CMC;
          data_horiz_bottom_color : BITCODE_CMC;
          data_vert_left_color : BITCODE_CMC;
          data_vert_ins_color : BITCODE_CMC;
          data_vert_right_color : BITCODE_CMC;
          has_border_lineweight_overrides : BITCODE_B;
          border_lineweight_overrides_flag : BITCODE_BL;
          title_horiz_top_linewt : BITCODE_BS;
          title_horiz_ins_linewt : BITCODE_BS;
          title_horiz_bottom_linewt : BITCODE_BS;
          title_vert_left_linewt : BITCODE_BS;
          title_vert_ins_linewt : BITCODE_BS;
          title_vert_right_linewt : BITCODE_BS;
          header_horiz_top_linewt : BITCODE_BS;
          header_horiz_ins_linewt : BITCODE_BS;
          header_horiz_bottom_linewt : BITCODE_BS;
          header_vert_left_linewt : BITCODE_BS;
          header_vert_ins_linewt : BITCODE_BS;
          header_vert_right_linewt : BITCODE_BS;
          data_horiz_top_linewt : BITCODE_BS;
          data_horiz_ins_linewt : BITCODE_BS;
          data_horiz_bottom_linewt : BITCODE_BS;
          data_vert_left_linewt : BITCODE_BS;
          data_vert_ins_linewt : BITCODE_BS;
          data_vert_right_linewt : BITCODE_BS;
          has_border_visibility_overrides : BITCODE_B;
          border_visibility_overrides_flag : BITCODE_BL;
          title_horiz_top_visibility : BITCODE_BS;
          title_horiz_ins_visibility : BITCODE_BS;
          title_horiz_bottom_visibility : BITCODE_BS;
          title_vert_left_visibility : BITCODE_BS;
          title_vert_ins_visibility : BITCODE_BS;
          title_vert_right_visibility : BITCODE_BS;
          header_horiz_top_visibility : BITCODE_BS;
          header_horiz_ins_visibility : BITCODE_BS;
          header_horiz_bottom_visibility : BITCODE_BS;
          header_vert_left_visibility : BITCODE_BS;
          header_vert_ins_visibility : BITCODE_BS;
          header_vert_right_visibility : BITCODE_BS;
          data_horiz_top_visibility : BITCODE_BS;
          data_horiz_ins_visibility : BITCODE_BS;
          data_horiz_bottom_visibility : BITCODE_BS;
          data_vert_left_visibility : BITCODE_BS;
          data_vert_ins_visibility : BITCODE_BS;
          data_vert_right_visibility : BITCODE_BS;
          block_header : BITCODE_H;
          first_attrib : BITCODE_H;
          last_attrib : BITCODE_H;
          attribs : ^BITCODE_H;
          seqend : BITCODE_H;
          title_row_style_override : BITCODE_H;
          header_row_style_override : BITCODE_H;
          data_row_style_override : BITCODE_H;
          unknown_bs : BITCODE_BS;
          hor_dir : BITCODE_3BD;
          has_break_data : BITCODE_BL;
          break_flag : BITCODE_BL;
          break_flow_direction : BITCODE_BL;
          break_spacing : BITCODE_BD;
          break_unknown1 : BITCODE_BL;
          break_unknown2 : BITCODE_BL;
          num_break_heights : BITCODE_BL;
          break_heights : ^Dwg_TABLE_BreakHeight;
          num_break_rows : BITCODE_BL;
          break_rows : ^Dwg_TABLE_BreakRow;
        end;
      Dwg_Entity_TABLE = _dwg_entity_TABLE;
     {$undef TABLECONTENT_fields}
    {*
     Class TABLESTYLE (varies)
      }
    { 1=title, 2=header, 3=data, 4=table.
                          ref TABLESTYLE. custom IDs > 100  }
    { 1=data, 2=label  }

      _dwg_TABLESTYLE_CellStyle = record
          parent : ^_dwg_object_TABLESTYLE;
          id : BITCODE_BL;
          _type : BITCODE_BL;
          name : BITCODE_T;
          cellstyle : _dwg_CellStyle;
        end;
      Dwg_TABLESTYLE_CellStyle = _dwg_TABLESTYLE_CellStyle;
    { very similar to GridLine, or GridFormat. but no overrides, type, ltype, ... }
    {TODO }
    { BITCODE_H ltype; }
    { BITCODE_BD double_line_spacing; }

      _dwg_TABLESTYLE_border = record
          linewt : BITCODE_BSd;
          visible : BITCODE_B;
          color : BITCODE_CMC;
        end;
      Dwg_TABLESTYLE_border = _dwg_TABLESTYLE_border;
    { child of TABLE/TABLESTYLE/... }
    { 6: top, horizontal inside, bottom, left, vertical inside, right }
    { always 6 }
    { r2007+ }

      _dwg_TABLESTYLE_rowstyles = record
          parent : ^_dwg_object_TABLESTYLE;
          text_style : BITCODE_H;
          text_height : BITCODE_BD;
          text_alignment : BITCODE_BS;
          text_color : BITCODE_CMC;
          fill_color : BITCODE_CMC;
          has_bgcolor : BITCODE_B;
          num_borders : BITCODE_BL;
          borders : ^Dwg_TABLESTYLE_border;
          data_type : BITCODE_BL;
          unit_type : BITCODE_BL;
          format_string : BITCODE_TU;
        end;
      Dwg_TABLESTYLE_rowstyles = _dwg_TABLESTYLE_rowstyles;
    {r2007+ signed }
    {r2007+. was called template }
    {r2007+. Note: embedded struct }
    { ?? }
    { ?? }
    { 0: data, 1: title, 2: header }
    { always 3 }

      _dwg_object_TABLESTYLE = record
          parent : ^_dwg_object_object;
          class_version : BITCODE_BS;
          name : BITCODE_T;
          flags : BITCODE_BS;
          flow_direction : BITCODE_BS;
          horiz_cell_margin : BITCODE_BD;
          vert_cell_margin : BITCODE_BD;
          is_title_suppressed : BITCODE_B;
          is_header_suppressed : BITCODE_B;
          unknown_rc : BITCODE_RC;
          unknown_bl1 : BITCODE_BL;
          unknown_bl2 : BITCODE_BL;
          cellstyle : BITCODE_H;
          sty : Dwg_TABLESTYLE_CellStyle;
          numoverrides : BITCODE_BL;
          unknown_bl3 : BITCODE_BL;
          ovr : Dwg_TABLESTYLE_CellStyle;
          num_rowstyles : BITCODE_BL;
          rowstyles : ^Dwg_TABLESTYLE_rowstyles;
        end;
      Dwg_Object_TABLESTYLE = _dwg_object_TABLESTYLE;
    {*
     Class CELLSTYLEMAP (varies)
     R2008+ TABLESTYLE extension class
      }

      _dwg_object_CELLSTYLEMAP = record
          parent : ^_dwg_object_object;
          num_cells : BITCODE_BL;
          cells : ^Dwg_TABLESTYLE_CellStyle;
        end;
      Dwg_Object_CELLSTYLEMAP = _dwg_object_CELLSTYLEMAP;
    { 20.4.103 TABLEGEOMETRY
     r2008+ optional, == 20.4.98
      }

      _dwg_TABLEGEOMETRY_Cell = record
          parent : ^_dwg_object_TABLEGEOMETRY;
          geom_data_flag : BITCODE_BL;
          width_w_gap : BITCODE_BD;
          height_w_gap : BITCODE_BD;
          tablegeometry : BITCODE_H;
          num_geometry : BITCODE_BL;
          geometry : ^Dwg_CellContentGeometry;
        end;
      Dwg_TABLEGEOMETRY_Cell = _dwg_TABLEGEOMETRY_Cell;
    { = num_rows * num_cols  }

      _dwg_object_TABLEGEOMETRY = record
          parent : ^_dwg_object_object;
          numrows : BITCODE_BL;
          numcols : BITCODE_BL;
          num_cells : BITCODE_BL;
          cells : ^Dwg_TABLEGEOMETRY_Cell;
        end;
      Dwg_Object_TABLEGEOMETRY = _dwg_object_TABLEGEOMETRY;
    {*
      Abstract class UNDERLAYDEFINITION (varies)
      Parent of PDF,DGN,DWFDEFINITION
      }
    {!< DXF 1, relative or absolute path to the image file  }
    {!< DXF 2, pdf: page number, dgn: default, dwf: ?  }

      _dwg_abstractobject_UNDERLAYDEFINITION = record
          parent : ^_dwg_object_object;
          filename : BITCODE_T;
          name : BITCODE_T;
        end;
      Dwg_Object_UNDERLAYDEFINITION = _dwg_abstractobject_UNDERLAYDEFINITION;

      Dwg_Object_PDFDEFINITION = _dwg_abstractobject_UNDERLAYDEFINITION;
      Dwg_Object_DGNDEFINITION = _dwg_abstractobject_UNDERLAYDEFINITION;
      Dwg_Object_DWFDEFINITION = _dwg_abstractobject_UNDERLAYDEFINITION;
    {*
     Abstract entity UNDERLAY, the reference (varies)
     As IMAGE or WIPEOUT but snappable, and with holes.
     Parent of PDF,DGN,DWFUNDERLAY
     In C++ as UnderlayReference
      }
    {!< DXF 210 normal  }
    {!< DXF 10  }
    {!< DXF 41  }
    {!< DXF 50  }
    {!< DXF 280: 1 is_clipped, 2 is_on, 4 is_monochrome,
                                8 is_adjusted_for_background, 16 is_clip_inverted,
                                ? is_frame_visible, ? is_frame_plottable  }
    {!< DXF 281 20-100, def: 100  }
    {!< DXF 282 0-80, def: 0  }
    {!< DXF 11: if 2 rectangle, > polygon  }
    { Note that neither Wipeout nor RasterImage has these inverted clips, allowing one hole.
         They just have an clip_mode flag for is_inverted.
         GeoJSON/GIS has multiple polygons, allowing multiple nested holes.  }
    {!< DXF 170  }
    {!< DXF 12   }
    {!< DXF 340  }

      _dwg_abstractentity_UNDERLAY = record
          parent : ^_dwg_object_entity;
          extrusion : BITCODE_BE;
          ins_pt : BITCODE_3BD;
          scale : BITCODE_3BD;
          angle : BITCODE_BD;
          flag : BITCODE_RC;
          contrast : BITCODE_RC;
          fade : BITCODE_RC;
          num_clip_verts : BITCODE_BL;
          clip_verts : ^BITCODE_2RD;
          num_clip_inverts : BITCODE_BS;
          clip_inverts : ^BITCODE_2RD;
          definition_id : BITCODE_H;
        end;
      Dwg_Entity_UNDERLAY = _dwg_abstractentity_UNDERLAY;
      Dwg_Entity_PDFUNDERLAY = _dwg_abstractentity_UNDERLAY;
      Dwg_Entity_DGNUNDERLAY = _dwg_abstractentity_UNDERLAY;
      Dwg_Entity_DWFUNDERLAY = _dwg_abstractentity_UNDERLAY;
    {*
     Class DBCOLOR (varies)
      }
    {62,420,430 }

      _dwg_object_DBCOLOR = record
          parent : ^_dwg_object_object;
          color : BITCODE_CMC;
        end;
      Dwg_Object_DBCOLOR = _dwg_object_DBCOLOR;
    {*
     Class FIELDLIST AcDbField (varies)
     R2018+
      }
    {!< DXF 6  }

      _dwg_FIELD_ChildValue = record
          parent : ^_dwg_object_FIELD;
          key : BITCODE_TV;
          value : Dwg_TABLE_value;
        end;
      Dwg_FIELD_ChildValue = _dwg_FIELD_ChildValue;
    { dxf group code  }
    { 1  }
    { 2,3  }
    { 90  }
    { code:3, 360  }
    { 97  }
    { code:5, 331  }
    { 4, until r2004 only  }
    { 91  }
    { 92  }
    { 94  }
    { 95  }
    { 96  }
    { 300  }
    { 301,9  }
    { 98 ODA bug: TV  }
    { 93  }

      _dwg_object_FIELD = record
          parent : ^_dwg_object_object;
          id : BITCODE_TV;
          code : BITCODE_TV;
          num_childs : BITCODE_BL;
          childs : ^BITCODE_H;
          num_objects : BITCODE_BL;
          objects : ^BITCODE_H;
          format : BITCODE_TV;
          evaluation_option : BITCODE_BL;
          filing_option : BITCODE_BL;
          field_state : BITCODE_BL;
          evaluation_status : BITCODE_BL;
          evaluation_error_code : BITCODE_BL;
          evaluation_error_msg : BITCODE_TV;
          value : Dwg_TABLE_value;
          value_string : BITCODE_TV;
          value_string_length : BITCODE_BL;
          num_childval : BITCODE_BL;
          childval : ^Dwg_FIELD_ChildValue;
        end;
      Dwg_Object_FIELD = _dwg_object_FIELD;
    {*
     * Object FIELDLIST (varies)
      }

      _dwg_object_FIELDLIST = record
          parent : ^_dwg_object_object;
          num_fields : BITCODE_BL;
          unknown : BITCODE_B;
          fields : ^BITCODE_H;
        end;
      Dwg_Object_FIELDLIST = _dwg_object_FIELDLIST;
    {*
     Class GEODATA (varies)
     R2009+
      }

      _dwg_GEODATA_meshpt = record
          source_pt : BITCODE_2RD;
          dest_pt : BITCODE_2RD;
        end;
      Dwg_GEODATA_meshpt = _dwg_GEODATA_meshpt;

      _dwg_GEODATA_meshface = record
          face1 : BITCODE_BL;
          face2 : BITCODE_BL;
          face3 : BITCODE_BL;
        end;
      Dwg_GEODATA_meshface = _dwg_GEODATA_meshface;
    { dxf group code  }
    { 0 unknown, 1 local grid, 2 projected grid,
                                3 geographic defined by latitude/longitude)  }
    { always 1.0,1.0,1.0 }
    { enum 0-20 }
    { enum 0-20 }
    { None = 1, User specified scale factor = 2,
                               Grid scale at reference point = 3, Prismodial = 4  }
    { obsolete  }
    { obsolete  }
    { (y, x) of ref_pt reversed }

      _dwg_object_GEODATA = record
          parent : ^_dwg_object_object;
          class_version : BITCODE_BL;
          host_block : BITCODE_H;
          coord_type : BITCODE_BS;
          design_pt : BITCODE_3BD;
          ref_pt : BITCODE_3BD;
          obs_pt : BITCODE_3BD;
          scale_vec : BITCODE_3BD;
          unit_scale_horiz : BITCODE_BD;
          units_value_horiz : BITCODE_BL;
          unit_scale_vert : BITCODE_BD;
          units_value_vert : BITCODE_BL;
          up_dir : BITCODE_3BD;
          north_dir : BITCODE_3BD;
          scale_est : BITCODE_BL;
          user_scale_factor : BITCODE_BD;
          do_sea_level_corr : BITCODE_B;
          sea_level_elev : BITCODE_BD;
          coord_proj_radius : BITCODE_BD;
          coord_system_def : BITCODE_T;
          geo_rss_tag : BITCODE_T;
          coord_system_datum : BITCODE_T;
          coord_system_wkt : BITCODE_T;
          observation_from_tag : BITCODE_T;
          observation_to_tag : BITCODE_T;
          observation_coverage_tag : BITCODE_T;
          num_geomesh_pts : BITCODE_BL;
          geomesh_pts : ^Dwg_GEODATA_meshpt;
          num_geomesh_faces : BITCODE_BL;
          geomesh_faces : ^Dwg_GEODATA_meshface;
          has_civil_data : BITCODE_B;
          obsolete_false : BITCODE_B;
          ref_pt2d : BITCODE_2RD;
          zero1 : BITCODE_3BD;
          zero2 : BITCODE_3BD;
          unknown1 : BITCODE_BL;
          unknown2 : BITCODE_BL;
          unknown_b : BITCODE_B;
          north_dir_angle_deg : BITCODE_BD;
          north_dir_angle_rad : BITCODE_BD;
        end;
      Dwg_Object_GEODATA = _dwg_object_GEODATA;
    {*
     Class IDBUFFER (varies)
      }

      _dwg_object_IDBUFFER = record
          parent : ^_dwg_object_object;
          unknown : BITCODE_RC;
          num_obj_ids : BITCODE_BL;
          obj_ids : ^BITCODE_H;
        end;
      Dwg_Object_IDBUFFER = _dwg_object_IDBUFFER;
    {*
     Classes for IMAGE (varies)
      }
    { also used in WIPEOUT }
    {!< DXF 13/23; width, height in pixel  }
    { 0 outside, 1 inside (inverted) }
    { 1 rect, 2 polygon }

      _dwg_entity_IMAGE = record
          parent : ^_dwg_object_entity;
          class_version : BITCODE_BL;
          pt0 : BITCODE_3BD;
          uvec : BITCODE_3BD;
          vvec : BITCODE_3BD;
          size : BITCODE_2RD;
          display_props : BITCODE_BS;
          clipping : BITCODE_B;
          brightness : BITCODE_RC;
          contrast : BITCODE_RC;
          fade : BITCODE_RC;
          clip_mode : BITCODE_B;
          clip_boundary_type : BITCODE_BS;
          num_clip_verts : BITCODE_BL;
          clip_verts : ^BITCODE_2RD;
          imagedef : BITCODE_H;
          imagedefreactor : BITCODE_H;
        end;
      Dwg_Entity_IMAGE = _dwg_entity_IMAGE;
    {*
     Class IMAGEDEF (varies)
      }
    { resolution MM/pixel }
    {BITCODE_H xrefctrl;    /*!< r2010+ */ }

      _dwg_object_IMAGEDEF = record
          parent : ^_dwg_object_object;
          class_version : BITCODE_BL;
          image_size : BITCODE_2RD;
          file_path : BITCODE_T;
          is_loaded : BITCODE_B;
          resunits : BITCODE_RC;
          pixel_size : BITCODE_2RD;
        end;
      Dwg_Object_IMAGEDEF = _dwg_object_IMAGEDEF;
    {*
     Class IMAGEDEF_REACTOR (varies)
      }

      _dwg_object_IMAGEDEF_REACTOR = record
          parent : ^_dwg_object_object;
          class_version : BITCODE_BL;
        end;
      Dwg_Object_IMAGEDEF_REACTOR = _dwg_object_IMAGEDEF_REACTOR;
    {*
     Class INDEX (varies)
     Registered as "AutoCAD 2000", but not seen in the wild.
      }

      _dwg_object_INDEX = record
          parent : ^_dwg_object_object;
          last_updated : BITCODE_TIMEBLL;
        end;
      Dwg_Object_INDEX = _dwg_object_INDEX;
    {*
     Class LAYER_INDEX (varies)
      }

      _dwg_LAYER_entry = record
          parent : ^_dwg_object_LAYER_INDEX;
          numlayers : BITCODE_BL;
          name : BITCODE_T;
          handle : BITCODE_H;
        end;
      Dwg_LAYER_entry = _dwg_LAYER_entry;

      _dwg_object_LAYER_INDEX = record
          parent : ^_dwg_object_object;
          last_updated : BITCODE_TIMEBLL;
          num_entries : BITCODE_BL;
          entries : ^Dwg_LAYER_entry;
        end;
      Dwg_Object_LAYER_INDEX = _dwg_object_LAYER_INDEX;
    {*
     Class LWPOLYLINE (77 + varies)
      }
    {!< DXF 70
                                      512 closed, 128 plinegen, 4 constwidth, 8 elevation, 2 thickness
                                      1 extrusion, 16 num_bulges, 1024 vertexidcount, 32 has_widths  }
    {!< DXF 43  }
    {!< DXF 38  }
    {!< DXF 39  }
    {!< DXF 210  }
    {!< DXF 90  }
    {!< DXF 10,20  }
    {!< DXF 42  }
    {!< r2010+, same as num_points  }
    {!< r2010+ DXF 91  }
    {!< DXF 40,41  }

      _dwg_entity_LWPOLYLINE = record
          parent : ^_dwg_object_entity;
          flag : BITCODE_BS;
          const_width : BITCODE_BD;
          elevation : BITCODE_BD;
          thickness : BITCODE_BD;
          extrusion : BITCODE_BE;
          num_points : BITCODE_BL;
          points : ^BITCODE_2RD;
          num_bulges : BITCODE_BL;
          bulges : ^BITCODE_BD;
          num_vertexids : BITCODE_BL;
          vertexids : ^BITCODE_BL;
          num_widths : BITCODE_BL;
          widths : ^Dwg_LWPOLYLINE_width;
        end;
      Dwg_Entity_LWPOLYLINE = _dwg_entity_LWPOLYLINE;
    {*
     Class RASTERVARIABLES (varies)
     (used in conjunction with IMAGE entities)
      }
    { DXF 72, i.e. user_scale }

      _dwg_object_RASTERVARIABLES = record
          parent : ^_dwg_object_object;
          class_version : BITCODE_BL;
          image_frame : BITCODE_BS;
          image_quality : BITCODE_BS;
          units : BITCODE_BS;
        end;
      Dwg_Object_RASTERVARIABLES = _dwg_object_RASTERVARIABLES;
    {*
     Object SCALE (varies)
      }
    { 1: is_temporary  }

      _dwg_object_SCALE = record
          parent : ^_dwg_object_object;
          flag : BITCODE_BS;
          name : BITCODE_TV;
          paper_units : BITCODE_BD;
          drawing_units : BITCODE_BD;
          is_unit_scale : BITCODE_B;
        end;
      Dwg_Object_SCALE = _dwg_object_SCALE;
    {*
     Class SORTENTSTABLE (varies)
      }
    { mspace or pspace }

      _dwg_object_SORTENTSTABLE = record
          parent : ^_dwg_object_object;
          num_ents : BITCODE_BL;
          sort_ents : ^BITCODE_H;
          block_owner : BITCODE_H;
          ents : ^BITCODE_H;
        end;
      Dwg_Object_SORTENTSTABLE = _dwg_object_SORTENTSTABLE;
    {*
     Class SPATIAL_FILTER (varies)
      }

      _dwg_object_SPATIAL_FILTER = record
          parent : ^_dwg_object_object;
          num_clip_verts : BITCODE_BS;
          clip_verts : ^BITCODE_2RD;
          extrusion : BITCODE_BE;
          origin : BITCODE_3BD;
          display_boundary_on : BITCODE_BS;
          front_clip_on : BITCODE_BS;
          front_clip_z : BITCODE_BD;
          back_clip_on : BITCODE_BS;
          back_clip_z : BITCODE_BD;
          inverse_transform : ^BITCODE_BD;
          transform : ^BITCODE_BD;
        end;
      Dwg_Object_SPATIAL_FILTER = _dwg_object_SPATIAL_FILTER;
    {*
     Class SPATIAL_INDEX (varies)
     ODA only covers the AcDbFilter class, but misses the rest.
      }

      _dwg_object_SPATIAL_INDEX = record
          parent : ^_dwg_object_object;
          last_updated : BITCODE_TIMEBLL;
          num1 : BITCODE_BD;
          num2 : BITCODE_BD;
          num3 : BITCODE_BD;
          num4 : BITCODE_BD;
          num5 : BITCODE_BD;
          num6 : BITCODE_BD;
          num_hdls : BITCODE_BL;
          hdls : ^BITCODE_H;
          bindata_size : BITCODE_BL;
          bindata : BITCODE_TF;
        end;
      Dwg_Object_SPATIAL_INDEX = _dwg_object_SPATIAL_INDEX;
    {*
     WIPEOUT (varies, 504)
     R2000+, undocumented = IMAGE layover
      }
    { 0 outside, 1 inside (inverted) }
    { 1 rect, 2 polygon }

      _dwg_entity_WIPEOUT = record
          parent : ^_dwg_object_entity;
          class_version : BITCODE_BL;
          pt0 : BITCODE_3BD;
          uvec : BITCODE_3BD;
          vvec : BITCODE_3BD;
          size : BITCODE_2RD;
          display_props : BITCODE_BS;
          clipping : BITCODE_B;
          brightness : BITCODE_RC;
          contrast : BITCODE_RC;
          fade : BITCODE_RC;
          clip_mode : BITCODE_B;
          clip_boundary_type : BITCODE_BS;
          num_clip_verts : BITCODE_BL;
          clip_verts : ^BITCODE_2RD;
          imagedef : BITCODE_H;
          imagedefreactor : BITCODE_H;
        end;
      Dwg_Entity_WIPEOUT = _dwg_entity_WIPEOUT;
    {*
     Class WIPEOUTVARIABLES (varies, 505)
     R2000+, Object bitsize: 96
      }
    {BITCODE_BL class_version;  /*!< DXF 90 NY */ }
    {!< DXF 70   }

      _dwg_object_WIPEOUTVARIABLES = record
          parent : ^_dwg_object_object;
          display_frame : BITCODE_BS;
        end;
      Dwg_Object_WIPEOUTVARIABLES = _dwg_object_WIPEOUTVARIABLES;
    { SECTIONPLANE, r2007+
     * Looks like the livesection ptr from VIEW
      }
    {!< DXF 90. Plane=1, Boundary=2, Volume=4  }
    {!< DXF 91. hitflags: sectionline=1, sectionlinetop=2, sectionlinebottom=4,
                                      backline=8, backlinetop=16, backlinebottom=32, verticallinetop=64,
                                      verticallinebottom=128.
                                      heightflags: HeightAboveSectionLine=1, HeightBelowSectionLine=2
                                      }
    {!< DXF 1  }
    {BITCODE_3BD viewing_dir;	/*!< normal of the 1st segment plane */ }
    {!< DXF 10. normal to the segment line, on the plane  }
    {!< DXF 40  }
    {!< DXF 41  }
    {!< DXF 70  }
    {!< DXF 62/420 (but documented as 63/411)  }
    {!< DXF 92  }
    {!< DXF 11  }
    {!< DXF 93  }
    {!< DXF 12  }
    {!< DXF 360  }

      _dwg_entity_SECTIONOBJECT = record
          parent : ^_dwg_object_entity;
          state : BITCODE_BL;
          flags : BITCODE_BL;
          name : BITCODE_T;
          vert_dir : BITCODE_3BD;
          top_height : BITCODE_BD;
          bottom_height : BITCODE_BD;
          indicator_alpha : BITCODE_BS;
          indicator_color : BITCODE_CMC;
          num_verts : BITCODE_BL;
          verts : ^BITCODE_3BD;
          num_blverts : BITCODE_BL;
          blverts : ^BITCODE_3BD;
          section_settings : BITCODE_H;
        end;
      Dwg_Entity_SECTIONOBJECT = _dwg_entity_SECTIONOBJECT;
    {*
     Unstable
     Class VISUALSTYLE (varies)
     R2007+
    
     32 types, with 3 categories: Face, Edge, Display, plus 58 props r2013+
      }
    {!< DXF 2   }
    {!< DXF 70 enum 0-32: (kFlat-kEmptyStyle acgivisualstyle.h)  }
    {!< DXF 177, r2010+ ? required on has_xdata  }
    {!< DXF 291, has internal_use_only flags  }
    {!< DXF 71 0:Invisible 1:Visible 2:Phong 3:Gooch  }
    {!< DXF 176 r2010+  }
    {!< DXF 72 0:No lighting 1:Per face 2:Per vertex  }
    {!< DXF 176 r2010+  }
    {!< DXF 73 0 = No color
                                                1 = Object color
                                                2 = Background color
                                                3 = Custom color
                                                4 = Mono color
                                                5 = Tinted
                                                6 = Desaturated  }
    {!< DXF 176 r2010+  }
    {!< DXF 40   }
    {!< DXF 176 r2010+  }
    {!< DXF 41   }
    {!< DXF 176 r2010+  }
    {!< DXF 90 0:No modifiers 1:Opacity 2:Specular  }
    {!< DXF 176 r2010+  }
    {!< DXF 63 + 421  }
    {!< DXF 176 r2010+  }
    {!< DXF 74 0:No edges 1:Isolines 2:Facet edges  }
    {!< DXF 176 r2010+  }
    {!< DXF 91   }
    {!< DXF 176 r2010+  }
    {!< DXF 64   }
    {!< DXF 176 r2010+  }
    {!< DXF 65   }
    {!< DXF 176 r2010+  }
    {!< DXF 75    }
    {!< DXF 176 r2010+  }
    {!< DXF 175   }
    {!< DXF 176 r2010+  }
    {!< DXF 42   }
    {!< DXF 176 r2010+  }
    {!< DXF 92   }
    {!< DXF 176 r2010+  }
    {!< DXF 66   }
    {!< DXF 176 r2010+  }
    {!< DXF 43   }
    {!< DXF 176 r2010+  }
    {!< DXF 76   }
    {!< DXF 176 r2010+  }
    {!< DXF 77   }
    {!< DXF 176 r2010+  }
    {!< DXF 78   }
    {!< DXF 176 r2010+  }
    {!< DXF 67   }
    {!< DXF 176 r2010+  }
    {!< DXF 79   }
    {!< DXF 176 r2010+  }
    {!< DXF 170   }
    {!< DXF 176 r2010+  }
    {!< DXF 171   }
    {!< DXF 176 r2010+  }
    {!< DXF 290   }
    {!< DXF 176 r2010+  }
    {!< DXF 174   }
    {!< DXF 176 r2010+   }
    {!< DXF 93 flags   }
    {!< DXF 176 r2010+  }
    {!< DXF 44 <=r2007  }
    {!< DXF 44  r2010+  }
    {!< DXF 176 r2010+  }
    {!< DXF 173   }
    {!< DXF 176 r2010+  }
    {!< DXF 45 r2007-only 0.0  }
    {!< r2013+ version3 58x  }
    { the rest of the props:
         all bool are 290, all BS/BL are 90, all BD are 40, colors 62, text 1  }

      _dwg_object_VISUALSTYLE = record
          parent : ^_dwg_object_object;
          description : BITCODE_T;
          style_type : BITCODE_BL;
          ext_lighting_model : BITCODE_BS;
          internal_only : BITCODE_B;
          face_lighting_model : BITCODE_BL;
          face_lighting_model_int : BITCODE_BS;
          face_lighting_quality : BITCODE_BL;
          face_lighting_quality_int : BITCODE_BS;
          face_color_mode : BITCODE_BL;
          face_color_mode_int : BITCODE_BS;
          face_opacity : BITCODE_BD;
          face_opacity_int : BITCODE_BS;
          face_specular : BITCODE_BD;
          face_specular_int : BITCODE_BS;
          face_modifier : BITCODE_BL;
          face_modifier_int : BITCODE_BS;
          face_mono_color : BITCODE_CMC;
          face_mono_color_int : BITCODE_BS;
          edge_model : BITCODE_BS;
          edge_model_int : BITCODE_BS;
          edge_style : BITCODE_BL;
          edge_style_int : BITCODE_BS;
          edge_intersection_color : BITCODE_CMC;
          edge_intersection_color_int : BITCODE_BS;
          edge_obscured_color : BITCODE_CMC;
          edge_obscured_color_int : BITCODE_BS;
          edge_obscured_ltype : BITCODE_BL;
          edge_obscured_ltype_int : BITCODE_BS;
          edge_intersection_ltype : BITCODE_BL;
          edge_intersection_ltype_int : BITCODE_BS;
          edge_crease_angle : BITCODE_BD;
          edge_crease_angle_int : BITCODE_BS;
          edge_modifier : BITCODE_BL;
          edge_modifier_int : BITCODE_BS;
          edge_color : BITCODE_CMC;
          edge_color_int : BITCODE_BS;
          edge_opacity : BITCODE_BD;
          edge_opacity_int : BITCODE_BS;
          edge_width : BITCODE_BL;
          edge_width_int : BITCODE_BS;
          edge_overhang : BITCODE_BL;
          edge_overhang_int : BITCODE_BS;
          edge_jitter : BITCODE_BL;
          edge_jitter_int : BITCODE_BS;
          edge_silhouette_color : BITCODE_CMC;
          edge_silhouette_color_int : BITCODE_BS;
          edge_silhouette_width : BITCODE_BL;
          edge_silhouette_width_int : BITCODE_BS;
          edge_halo_gap : BITCODE_BL;
          edge_halo_gap_int : BITCODE_BS;
          edge_isolines : BITCODE_BL;
          edge_isolines_int : BITCODE_BS;
          edge_do_hide_precision : BITCODE_B;
          edge_do_hide_precision_int : BITCODE_BS;
          edge_style_apply : BITCODE_BL;
          edge_style_apply_int : BITCODE_BS;
          display_settings : BITCODE_BL;
          display_settings_int : BITCODE_BS;
          display_brightness_bl : BITCODE_BLd;
          display_brightness : BITCODE_BD;
          display_brightness_int : BITCODE_BS;
          display_shadow_type : BITCODE_BL;
          display_shadow_type_int : BITCODE_BS;
          bd2007_45 : BITCODE_BD;
          num_props : BITCODE_BS;
          b_prop1c : BITCODE_B;
          b_prop1c_int : BITCODE_BS;
          b_prop1d : BITCODE_B;
          b_prop1d_int : BITCODE_BS;
          b_prop1e : BITCODE_B;
          b_prop1e_int : BITCODE_BS;
          b_prop1f : BITCODE_B;
          b_prop1f_int : BITCODE_BS;
          b_prop20 : BITCODE_B;
          b_prop20_int : BITCODE_BS;
          b_prop21 : BITCODE_B;
          b_prop21_int : BITCODE_BS;
          b_prop22 : BITCODE_B;
          b_prop22_int : BITCODE_BS;
          b_prop23 : BITCODE_B;
          b_prop23_int : BITCODE_BS;
          b_prop24 : BITCODE_B;
          b_prop24_int : BITCODE_BS;
          bl_prop25 : BITCODE_BL;
          bl_prop25_int : BITCODE_BS;
          bd_prop26 : BITCODE_BD;
          bd_prop26_int : BITCODE_BS;
          bd_prop27 : BITCODE_BD;
          bd_prop27_int : BITCODE_BS;
          bl_prop28 : BITCODE_BL;
          bl_prop28_int : BITCODE_BS;
          c_prop29 : BITCODE_CMC;
          c_prop29_int : BITCODE_BS;
          bl_prop2a : BITCODE_BL;
          bl_prop2a_int : BITCODE_BS;
          bl_prop2b : BITCODE_BL;
          bl_prop2b_int : BITCODE_BS;
          c_prop2c : BITCODE_CMC;
          c_prop2c_int : BITCODE_BS;
          b_prop2d : BITCODE_B;
          b_prop2d_int : BITCODE_BS;
          bl_prop2e : BITCODE_BL;
          bl_prop2e_int : BITCODE_BS;
          bl_prop2f : BITCODE_BL;
          bl_prop2f_int : BITCODE_BS;
          bl_prop30 : BITCODE_BL;
          bl_prop30_int : BITCODE_BS;
          b_prop31 : BITCODE_B;
          b_prop31_int : BITCODE_BS;
          bl_prop32 : BITCODE_BL;
          bl_prop32_int : BITCODE_BS;
          c_prop33 : BITCODE_CMC;
          c_prop33_int : BITCODE_BS;
          bd_prop34 : BITCODE_BD;
          bd_prop34_int : BITCODE_BS;
          edge_wiggle : BITCODE_BL;
          edge_wiggle_int : BITCODE_BS;
          strokes : BITCODE_T;
          strokes_int : BITCODE_BS;
          b_prop37 : BITCODE_B;
          b_prop37_int : BITCODE_BS;
          bd_prop38 : BITCODE_BD;
          bd_prop38_int : BITCODE_BS;
          bd_prop39 : BITCODE_BD;
          bd_prop39_int : BITCODE_BS;
        end;
      Dwg_Object_VISUALSTYLE = _dwg_object_VISUALSTYLE;
    {*
     Object LIGHTLIST (varies)
     R2010+
      }

      _dwg_LIGHTLIST_light = record
          parent : ^_dwg_object_LIGHTLIST;
          name : BITCODE_T;
          handle : BITCODE_H;
        end;
      Dwg_LIGHTLIST_light = _dwg_LIGHTLIST_light;
    { 2010+  }

      _dwg_object_LIGHTLIST = record
          parent : ^_dwg_object_object;
          class_version : BITCODE_BL;
          num_lights : BITCODE_BL;
          lights : ^Dwg_LIGHTLIST_light;
        end;
      Dwg_Object_LIGHTLIST = _dwg_object_LIGHTLIST;
    {!< 0 Use current color, 1 Override  }
    {!< 0.0 - 1.0  }

      _dwg_MATERIAL_color = record
          parent : ^_dwg_object_object;
          flag : BITCODE_RC;
          factor : BITCODE_BD;
          rgb : BITCODE_BL;
        end;
      Dwg_MATERIAL_color = _dwg_MATERIAL_color;
    {!< DXF 42  def: 1.0  }
    {!< DXF 43: 16x BD  }
    {!< DXF 3   if NULL no diffuse map  }
    {!< DXF 72  0 current, 1 image file (def), 2 2nd map?  }
    {!< DXF 73  1 Planar (def), 2 Box, 3 Cylinder, 4 Sphere  }
    {!< DXF 74  1 = Tile (def), 2 = Crop, 3 = Clamp  }
    {!< DXF 75  1 no, 2: scale to curr ent,
                                             4: w/ current block transform  }
    { marble, wood and procedural modes  }

      _dwg_MATERIAL_mapper = record
          parent : ^_dwg_object_object;
          blendfactor : BITCODE_BD;
          transmatrix : ^BITCODE_BD;
          filename : BITCODE_T;
          color1 : Dwg_MATERIAL_color;
          color2 : Dwg_MATERIAL_color;
          source : BITCODE_RC;
          projection : BITCODE_RC;
          tiling : BITCODE_RC;
          autotransform : BITCODE_RC;
          texturemode : BITCODE_BS;
        end;
      Dwg_MATERIAL_mapper = _dwg_MATERIAL_mapper;

      _dwg_MATERIAL_gentexture = record
          parent : ^_dwg_object_MATERIAL;
          genprocname : BITCODE_T;
          material : ^_dwg_object_MATERIAL;
        end;
      Dwg_MATERIAL_gentexture = _dwg_MATERIAL_gentexture;
    {*
     Object MATERIAL (varies)
     Acad Naming: e.g. Materials/assetlibrary_base.fbm/shaders/AdskShaders.mi
                      Materials/assetlibrary_base.fbm/Mats/SolidGlass/Generic.xml
      }
    {!< DXF 1  }
    {!< DXF 2 optional  }
    {!< DXF 70, 40, 90  }
    {!< DXF 71, 41, 91  }
    {!< DXF 42, 72, 3, 73, 74, 75, 43  }
    {!< DXF 44 def: 0.5  }
    {!< DXF 76, 45, 92  }
    {!< DXF 46, 77, 4, 78, 79, 170, 47  }
    {?? BD reflection_depth }
    {reflection_glossy_samples }
    {!< DXF 48, 171, 6, 172, 173, 174, 49  }
    {!< DXF 140 def: 1.0  }
    {!< DXF 141, 175, 7, 176, 177, 178, 142  }
    {BITCODE_B bump_enable }
    {?BD bump_amount }
    {!< DXF 143, 179, 8, 270, 271, 272, 144  }
    {!< DXF 145 def: 1.0  }
    {?? BD refraction_depth }
    {?? BD refraction_translucency_weight }
    {?? refraction_glossy_samples }
    {!< DXF 146, 273, 9, 274, 275, 276, 147  }
    {!< DXF 460  }
    {!< DXF 461  }
    {!< DXF 462  }
    {!< DXF 463  }
    {!< DXF 290  }
    {!< DXF 464  }
    {!< DXF 270  }
    {!< DXF 148  }
    {!< DXF 149  }
    {!< DXF 468  }
    {!< DXF 93  }
    {!< DXF 94  }
    {!< DXF 282  }
    {!< DXF 300  }
    {!< DXF 291  }
    {!< DXF 271  }
    {!< DXF 469  }
    {!< DXF 301  }
    {!< DXF 62  }
    {!< DXF 292  }
{$if 0}
    {!< DXF 271  }
    {!< DXF 465 def: 1.0  }
    {!< DXF 42, 72, 3, 73, 74, 75, 43  }
    {!< DXF 293  }
    {!< DXF 272  }
    {!< DXF 273  }
{$endif}
    {? BD backface_cull }
    {? BD self_illum_luminance }
    {? BD self_illum_color_temperature }

      _dwg_object_MATERIAL = record
          parent : ^_dwg_object_object;
          name : BITCODE_T;
          description : BITCODE_T;
          ambient_color : Dwg_MATERIAL_color;
          diffuse_color : Dwg_MATERIAL_color;
          diffusemap : Dwg_MATERIAL_mapper;
          specular_gloss_factor : BITCODE_BD;
          specular_color : Dwg_MATERIAL_color;
          specularmap : Dwg_MATERIAL_mapper;
          reflectionmap : Dwg_MATERIAL_mapper;
          opacity_percent : BITCODE_BD;
          opacitymap : Dwg_MATERIAL_mapper;
          bumpmap : Dwg_MATERIAL_mapper;
          refraction_index : BITCODE_BD;
          refractionmap : Dwg_MATERIAL_mapper;
          color_bleed_scale : BITCODE_BD;
          indirect_bump_scale : BITCODE_BD;
          reflectance_scale : BITCODE_BD;
          transmittance_scale : BITCODE_BD;
          two_sided_material : BITCODE_B;
          luminance : BITCODE_BD;
          luminance_mode : BITCODE_BS;
          translucence : BITCODE_BD;
          self_illumination : BITCODE_BD;
          reflectivity : BITCODE_BD;
          illumination_model : BITCODE_BL;
          channel_flags : BITCODE_BL;
          mode : BITCODE_BL;
          genprocname : BITCODE_T;
          genproctype : BITCODE_BS;
          genprocvalbool : BITCODE_B;
          genprocvalint : BITCODE_BS;
          genprocvalreal : BITCODE_BD;
          genprocvaltext : BITCODE_T;
          genprocvalcolor : BITCODE_CMC;
          genproctableend : BITCODE_B;
          num_gentextures : BITCODE_BS;
          gentextures : ^Dwg_MATERIAL_gentexture;
          {$ifdef undefined}
          normalmap_method : BITCODE_BS;
          normalmap_strength : BITCODE_BD;
          normalmap : Dwg_MATERIAL_mapper;
          is_anonymous : BITCODE_B;
          global_illumination : BITCODE_BS;
          final_gather : BITCODE_BS;
          {$endif}
        end;
      Dwg_Object_MATERIAL = _dwg_object_MATERIAL;
    {*
     Object OBJECT_PTR (varies) UNKNOWN FIELDS
     yet unsorted, and unused.
      }

      _dwg_object_OBJECT_PTR = record
          parent : ^_dwg_object_object;
        end;
      Dwg_Object_OBJECT_PTR = _dwg_object_OBJECT_PTR;
    {*
     Entity LIGHT (varies)
     UNSTABLE, now complete
      }
    {!< DXF 90  }
    {!< DXF 1  }
    {!< DXF 70, distant = 1; point = 2; spot = 3  }
    {!< DXF 290, on or off  }
    {!< DXF 63 + 421. r2000: 90 for the rgb value  }
    {!< DXF 291  }
    {!< DXF 40  }
    {!< DXF 10  }
    {!< DXF 11  }
    {!< DXF 72. None=0, Inverse Linear=1,
                                                       Inverse Square=2  }
    {!< DXF 292  }
    {!< DXF 41  }
    {!< DXF 42  }
    {!< DXF 50  }
    {!< DXF 51, with type=spot  }
    {!< DXF 293  }
    {!< DXF 73, ray_traced=0, shadow_maps=1  }
    {!< DXF 91 in pixel: 64,128,256,...4096  }
    {!< DXF 280 1-10 (num pixels blend into)  }
    { if LIGHTINGUNITS == "2"  }
    {!< DXF 290  }
    {!< DXF 300 IES file  }
    {!< DXF 70  }
    {!< DXF 40  }
    {!< DXF 41  }
    {!< DXF 71 0: in kelvin, 1: as preset  }
    {!< DXF 42 Temperature in Kelvin  }
    {!< DXF 72  }
    {!< if lamp_color_preset is Custom  }
    {!< DXF 43-45 rotation offset in XYZ Euler angles  }
    {!< DXF 73: 0 linear, 1 rect, 2 disk, 3 cylinder, 4 sphere  }
    {!< DXF 46  }
    {!< DXF 47  }
    {!< DXF 48  }
    {!< DXF 74  }
    {!< DXF 75  }
    {!< DXF 76
                                           if the light displays a target grip for orienting
                                           the light  }
    {!< DXF 49  }
    {!< DXF 50  }
    {!< DXF 51  }
    {!< DXF 52  }
    {!< DXF 53  }
    {!< DXF 54  }
    {!< DXF 77 0:auto, 1:on, 2:off  }

      _dwg_entity_LIGHT = record
          parent : ^_dwg_object_entity;
          class_version : BITCODE_BL;
          name : BITCODE_T;
          _type : BITCODE_BL;
          status : BITCODE_B;
          color : BITCODE_CMC;
          plot_glyph : BITCODE_B;
          intensity : BITCODE_BD;
          position : BITCODE_3BD;
          target : BITCODE_3BD;
          attenuation_type : BITCODE_BL;
          use_attenuation_limits : BITCODE_B;
          attenuation_start_limit : BITCODE_BD;
          attenuation_end_limit : BITCODE_BD;
          hotspot_angle : BITCODE_BD;
          falloff_angle : BITCODE_BD;
          cast_shadows : BITCODE_B;
          shadow_type : BITCODE_BL;
          shadow_map_size : BITCODE_BS;
          shadow_map_softness : BITCODE_RC;
          is_photometric : BITCODE_B;
          has_photometric_data : BITCODE_B;
          has_webfile : BITCODE_B;
          webfile : BITCODE_T;
          physical_intensity_method : BITCODE_BS;
          physical_intensity : BITCODE_BD;
          illuminance_dist : BITCODE_BD;
          lamp_color_type : BITCODE_BS;
          lamp_color_temp : BITCODE_BD;
          lamp_color_preset : BITCODE_BS;
          lamp_color_rgb : BITCODE_BL;
          web_rotation : BITCODE_3BD;
          extlight_shape : BITCODE_BS;
          extlight_length : BITCODE_BD;
          extlight_width : BITCODE_BD;
          extlight_radius : BITCODE_BD;
          webfile_type : BITCODE_BS;
          web_symetry : BITCODE_BS;
          has_target_grip : BITCODE_BS;
          web_flux : BITCODE_BD;
          web_angle1 : BITCODE_BD;
          web_angle2 : BITCODE_BD;
          web_angle3 : BITCODE_BD;
          web_angle4 : BITCODE_BD;
          web_angle5 : BITCODE_BD;
          glyph_display_type : BITCODE_BS;
        end;
      Dwg_Entity_LIGHT = _dwg_entity_LIGHT;
    {*
     Entity CAMERA (varies) UNKNOWN FIELDS
     not DWG persistent. yet unsorted, and unused.
      }

      _dwg_entity_CAMERA = record
          parent : ^_dwg_object_entity;
          view : BITCODE_H;
        end;
      Dwg_Entity_CAMERA = _dwg_entity_CAMERA;
    {*
     Entity GEOPOSITIONMARKER (varies)
     }
    {!< DXF 90 point, lat_lon, mylocation  }
    {!< DXF 10  }
    {!< DXF 40  }
    {!< DXF 40  }
    {!< DXF 1  }
    {!< DXF 70  0 left, 1 center, 2 right  }
    {!< DXF 290  }
    {!< DXF 290  }

      _dwg_entity_GEOPOSITIONMARKER = record
          parent : ^_dwg_object_entity;
          class_version : BITCODE_BS;
          position : BITCODE_3BD;
          radius : BITCODE_BD;
          landing_gap : BITCODE_BD;
          notes : BITCODE_T;
          text_alignment : BITCODE_RC;
          mtext_visible : BITCODE_B;
          enable_frame_text : BITCODE_B;
          mtext : ^_dwg_object;
        end;
      Dwg_Entity_GEOPOSITIONMARKER = _dwg_entity_GEOPOSITIONMARKER;
    {*
     Object GEOMAPIMAGE (varies), LiveMap image overlay.
     yet unsorted, and unused.
     }
    { 90 }
    { 10 }
    { 13 }
    { 70 }
    { 280 i.e. clipping_enabled }
    { 281 }
    { 282 }
    { 283 }
    {? }
    {BITCODE_3BD origin; }

      _dwg_object_GEOMAPIMAGE = record
          parent : ^_dwg_object_object;
          class_version : BITCODE_BL;
          pt0 : BITCODE_3BD;
          size : BITCODE_2RD;
          display_props : BITCODE_BS;
          clipping : BITCODE_B;
          brightness : BITCODE_RC;
          contrast : BITCODE_RC;
          fade : BITCODE_RC;
          rotation : BITCODE_BD;
          image_width : BITCODE_BD;
          image_height : BITCODE_BD;
          name : BITCODE_T;
          image_file : BITCODE_BD;
          image_visibility : BITCODE_BD;
          transparency : BITCODE_BS;
          height : BITCODE_BD;
          width : BITCODE_BD;
          show_rotation : BITCODE_B;
          scale_factor : BITCODE_BD;
          geoimage_brightness : BITCODE_BS;
          geoimage_contrast : BITCODE_BS;
          geoimage_fade : BITCODE_BS;
          geoimage_position : BITCODE_BS;
          geoimage_width : BITCODE_BS;
          geoimage_height : BITCODE_BS;
        end;
      Dwg_Object_GEOMAPIMAGE = _dwg_object_GEOMAPIMAGE;
    {*
     Entity HELIX (varies) UNSTABLE
     subclass of SPLINE
     }
    { AcDbSpline }
    { computed  }
    { 1 spline, 2 bezier  }
    { 2013+: method fit points = 1, CV frame show = 2, closed = 4  }
    { 2013+: Chord = 0, Square root = 1, Uniform = 2, Custom = 15  }
    { bit 4 of 70  }
    { AcDbHelix }
    {!< DXF 90: 27  }
    {!< DXF 91: 1  }
    {!< DXF 10  }
    {!< DXF 11  }
    {!< DXF 12  }
    {!< DXF 40  }
    {!< DXF 41  }
    {!< DXF 42  }
    {!< DXF 290: 0: left, 1: right (twist)  }
    {!< DXF 280: 0: turn_height, 1: turns, 2: height  }

      _dwg_entity_HELIX = record
          parent : ^_dwg_object_entity;
          flag : BITCODE_BS;
          scenario : BITCODE_BS;
          degree : BITCODE_BS;
          splineflags1 : BITCODE_BL;
          knotparam : BITCODE_BL;
          fit_tol : BITCODE_BD;
          beg_tan_vec : BITCODE_3BD;
          end_tan_vec : BITCODE_3BD;
          rational : BITCODE_B;
          closed_b : BITCODE_B;
          periodic : BITCODE_B;
          weighted : BITCODE_B;
          knot_tol : BITCODE_BD;
          ctrl_tol : BITCODE_BD;
          num_fit_pts : BITCODE_BS;
          fit_pts : ^BITCODE_3DPOINT;
          num_knots : BITCODE_BL;
          knots : ^BITCODE_BD;
          num_ctrl_pts : BITCODE_BL;
          ctrl_pts : ^Dwg_SPLINE_control_point;
          major_version : BITCODE_BL;
          maint_version : BITCODE_BL;
          axis_base_pt : BITCODE_3BD;
          start_pt : BITCODE_3BD;
          axis_vector : BITCODE_3BD;
          radius : BITCODE_BD;
          turns : BITCODE_BD;
          turn_height : BITCODE_BD;
          handedness : BITCODE_B;
          constraint_type : BITCODE_RC;
        end;
      Dwg_Entity_HELIX = _dwg_entity_HELIX;

      { TODO ACSH_SWEEP_CLASS has different names, }
    { ACIS (sweep:options) even more so. ACIS key names are weird though, Acad didnt take them. }

      {$define SWEEPOPTIONS_fields:=draft_angle:BITCODE_BD;(*!< DXF 42*)draft_start_distance:BITCODE_BD;(*!< DXF 43*)draft_end_distance:BITCODE_BD;(*!< DXF 44*)twist_angle:BITCODE_BD;(*!< DXF 45*)scale_factor:BITCODE_BD;(*!< DXF 48*)align_angle:BITCODE_BD;(*!< DXF 49*)sweep_entity_transmatrix:^BITCODE_BD;(*!< DXF 46: 16x BD*)path_entity_transmatrix:^BITCODE_BD;(*!< DXF 47: 16x BD*)is_solid:BITCODE_B;(*!< DXF 290*)sweep_alignment_flags:BITCODE_BS;(*!< DXF 70.0=No alignment, 1=Align sweep entity to path,2=Translate sweep entity to path,3=Translate path to sweep entity*)path_flags:BITCODE_BS;(*DXF 71*)align_start:BITCODE_B;(*!< DXF 292*)bank:BITCODE_B;(*!< DXF 293*)base_point_set:BITCODE_B;(*!< DXF 294*)sweep_entity_transform_computed:BITCODE_B;(*!< DXF 295*)path_entity_transform_computed:BITCODE_B;(*!< DXF 296*)reference_vector_for_controlling_twist:BITCODE_3BD;(*!< DXF 11*)sweep_entity:BITCODE_H;path_entity:BITCODE_H}

    {*
     Entity EXTRUDEDSURFACE (varies)
     in DXF encrypted.
     }
     _dwg_entity_EXTRUDEDSURFACE = record
          parent:^_dwg_object_entity;
          _3DSOLID_FIELDS;
          modeler_format_version : BITCODE_BS;{!< DXF 70  }
          bindata_size : BITCODE_BL;{ 90 }
          bindata : BITCODE_TF;{ 310|1 }
          u_isolines : BITCODE_BS;{!< DXF 71  }
          v_isolines : BITCODE_BS;{!< DXF 72  }
          class_version : BITCODE_BL;{!< DXF 90  }
          SWEEPOPTIONS_fields;
          {BITCODE_BD height; }
          sweep_vector : BITCODE_3BD;{!< DXF 10  }
          sweep_transmatrix : ^BITCODE_BD;{!< DXF 40: 16x BD  }
       end;
     Dwg_Entity_EXTRUDEDSURFACE = _dwg_entity_EXTRUDEDSURFACE;
    {*
     Entity SWEPTSURFACE (varies)
     }
    {!< DXF 70  }
    {!< DXF 71  }
    {!< DXF 72  }
    {!< DXF 90  }
    { 90 }
      _dwg_entity_SWEPTSURFACE = record
          parent : ^_dwg_object_entity;
          _3DSOLID_FIELDS;
          modeler_format_version : BITCODE_BS;
          u_isolines : BITCODE_BS;
          v_isolines : BITCODE_BS;
          class_version : BITCODE_BL;
          sweep_entity_id : BITCODE_BL;
          sweepdata_size : BITCODE_BL;
          sweepdata : BITCODE_TF;
          path_entity_id : BITCODE_BL;
          pathdata_size : BITCODE_BL;
          pathdata : BITCODE_TF;
          SWEEPOPTIONS_fields;
        end;
      Dwg_Entity_SWEPTSURFACE = _dwg_entity_SWEPTSURFACE;
    {*
     Entity LOFTEDSURFACE (varies)
     }
    {!< DXF 70  }
    {!< DXF 71  }
    {!< DXF 72  }
    {BITCODE_BL class_version;      /*!< DXF 90 */ }
    {!< DXF 40: 16x BD  }
    {!< DXF 70  }
    {!< DXF 41  }
    {!< DXF 42  }
    {!< DXF 43  }
    {!< DXF 44  }
    { 290 }
    { 291 }
    { 292 }
    { 293 }
    { 294 }
    { 295 }
    { 296 }
    { 297 }

      _dwg_entity_LOFTEDSURFACE = record
          parent : ^_dwg_object_entity;
          _3DSOLID_FIELDS;
          modeler_format_version : BITCODE_BS;
          u_isolines : BITCODE_BS;
          v_isolines : BITCODE_BS;
          loft_entity_transmatrix : ^BITCODE_BD;
          plane_normal_lofting_type : BITCODE_BL;
          start_draft_angle : BITCODE_BD;
          end_draft_angle : BITCODE_BD;
          start_draft_magnitude : BITCODE_BD;
          end_draft_magnitude : BITCODE_BD;
          arc_length_parameterization : BITCODE_B;
          no_twist : BITCODE_B;
          align_direction : BITCODE_B;
          simple_surfaces : BITCODE_B;
          closed_surfaces : BITCODE_B;
          solid : BITCODE_B;
          ruled_surface : BITCODE_B;
          virtual_guide : BITCODE_B;
          num_cross_sections : BITCODE_BS;
          num_guide_curves : BITCODE_BS;
          cross_sections : ^BITCODE_H;
          guide_curves : ^BITCODE_H;
          path_curve : BITCODE_H;
        end;
      Dwg_Entity_LOFTEDSURFACE = _dwg_entity_LOFTEDSURFACE;
    {*
     Entity NURBSURFACE (varies)
     }
    { AcDbSurface }
    {!< DXF 71  }
    {!< DXF 72  }
    { AcDbNurbSurface }
    { DXF 170  }
    { DXF 290  }
    { DXF 10  }
    { DXF 11  }
    { DXF 12  }
    { DXF 13  }

      _dwg_entity_NURBSURFACE = record
          parent : ^_dwg_object_entity;
          _3DSOLID_FIELDS;
          u_isolines : BITCODE_BS;
          v_isolines : BITCODE_BS;
          short170 : BITCODE_BS;
          cv_hull_display : BITCODE_B;
          uvec1 : BITCODE_3BD;
          vvec1 : BITCODE_3BD;
          uvec2 : BITCODE_3BD;
          vvec2 : BITCODE_3BD;
        end;
      Dwg_Entity_NURBSURFACE = _dwg_entity_NURBSURFACE;
    {*
     Entity PLANESURFACE (varies)
     }
    {!< DXF 70  }
    {!< DXF 71  }
    {!< DXF 72  }
    {!< DXF 90  }

      _dwg_entity_PLANESURFACE = record
          parent : ^_dwg_object_entity;
          _3DSOLID_FIELDS;
          modeler_format_version : BITCODE_BS;
          u_isolines : BITCODE_BS;
          v_isolines : BITCODE_BS;
          class_version : BITCODE_BL;
        end;
      Dwg_Entity_PLANESURFACE = _dwg_entity_PLANESURFACE;
    {*
     Entity REVOLVEDSURFACE (varies)
     }
    {!< DXF 70  }
    {!< DXF 71  }
    {!< DXF 72  }
    {!< DXF 90  }
    { 90 }
    { 10 }
    { 11 }
    { 40 }
    { 41 }
    { 42 }
    { 43 }
    { 44 }
    { 45 }
    { 46 }
    { 290 }
    { 291 }

      _dwg_entity_REVOLVEDSURFACE = record
          parent : ^_dwg_object_entity;
          _3DSOLID_FIELDS;
          modeler_format_version : BITCODE_BS;
          u_isolines : BITCODE_BS;
          v_isolines : BITCODE_BS;
          class_version : BITCODE_BL;
          id : BITCODE_BL;
          axis_point : BITCODE_3BD;
          axis_vector : BITCODE_3BD;
          revolve_angle : BITCODE_BD;
          start_angle : BITCODE_BD;
          revolved_entity_transmatrix : ^BITCODE_BD;
          draft_angle : BITCODE_BD;
          draft_start_distance : BITCODE_BD;
          draft_end_distance : BITCODE_BD;
          twist_angle : BITCODE_BD;
          solid : BITCODE_B;
          close_to_axis : BITCODE_B;
        end;
      Dwg_Entity_REVOLVEDSURFACE = _dwg_entity_REVOLVEDSURFACE;
    {*
     Entity MESH (varies)
     Types: Sphere|Cylinder|Cone|Torus|Box|Wedge|Pyramid
     }
    { index from }
    { index to }

      _dwg_MESH_edge = record
          parent : ^_dwg_entity_MESH;
          idxfrom : BITCODE_BL;
          idxto : BITCODE_BL;
        end;
      Dwg_MESH_edge = _dwg_MESH_edge;
    {!< DXF 71 (2)  }
    {!< DXF 72 (0)  }
    {!< DXF 91 (0)  }
    {!< DXF 10 ??  }
    {!< DXF 92 (14)  }
    {!< DXF 10  }
    {!< DXF 93 (30)  }
    {!< DXF 90  }
    {!< DXF 94 (19)  }
    {!< DXF 90  }
    {!< DXF 95 (19)  }
    {!< DXF 140  }

      _dwg_entity_MESH = record
          parent : ^_dwg_object_entity;
          dlevel : BITCODE_BS;
          is_watertight : BITCODE_B;
          num_subdiv_vertex : BITCODE_BL;
          subdiv_vertex : ^BITCODE_3DPOINT;
          num_vertex : BITCODE_BL;
          vertex : ^BITCODE_3DPOINT;
          num_faces : BITCODE_BL;
          faces : ^BITCODE_BL;
          num_edges : BITCODE_BL;
          edges : ^Dwg_MESH_edge;
          num_crease : BITCODE_BL;
          crease : ^BITCODE_BD;
        end;
      Dwg_Entity_MESH = _dwg_entity_MESH;
    {*
     Object SUN (varies), unstable
     wrongly documented by ACAD DXF as entity
      }
    {!< DXF 90  }
    {!< DXF 290  }
    {!< DXF 60, 421  }
    {!< DXF 40  }
    {!< DXF 291  }
    {!< DXF 91  }
    {!< DXF 92  }
    {!< DXF 292  }
    {!< DXF 70  }
    {!< DXF 71  }
    {!< DXF 280  }

      _dwg_object_SUN = record
          parent : ^_dwg_object_object;
          class_version : BITCODE_BL;
          is_on : BITCODE_B;
          color : BITCODE_CMC;
          intensity : BITCODE_BD;
          has_shadow : BITCODE_B;
          julian_day : BITCODE_BL;
          msecs : BITCODE_BL;
          is_dst : BITCODE_B;
          shadow_type : BITCODE_BL;
          shadow_mapsize : BITCODE_BS;
          shadow_softness : BITCODE_RC;
        end;
      Dwg_Object_SUN = _dwg_object_SUN;
    {seconds past midnight }

      _dwg_SUNSTUDY_Dates = record
          julian_day : BITCODE_BL;
          msecs : BITCODE_BL;
        end;
      Dwg_SUNSTUDY_Dates = _dwg_SUNSTUDY_Dates;
    {*
     Object SUNSTUDY (varies)
     --enable-debug only
      }
    {!< DXF 90  }
    {!< DXF 1  }
    {!< DXF 2  }
    {!< DXF 70  }
    {!< DXF 3  }
    {!< DXF 290  }
    {!< DXF 3  }
    {!< DXF 291  }
    {!< DXF 91  }
    {!< DXF 90[]  }
    {!< DXF 292  }
    {!< DXF 93  }
    {!< DXF 94  }
    {!< DXF 95  }
    {!< DXF 73  }
    {!< DXF 290  }
    {!< DXF 74  }
    {!< DXF 75  }
    {!< DXF 76  }
    {!< DXF 77  }
    {!< DXF 40  }
    {!< DXF 293  }
    {!< DXF 294  }
    {!< 5 DXF 340  }
    {!< DXF 341  }
    {!< DXF 342  }
    {!< DXF 343  }

      _dwg_object_SUNSTUDY = record
          parent : ^_dwg_object_object;
          class_version : BITCODE_BL;
          setup_name : BITCODE_T;
          description : BITCODE_T;
          output_type : BITCODE_BL;
          sheet_set_name : BITCODE_T;
          use_subset : BITCODE_B;
          sheet_subset_name : BITCODE_T;
          select_dates_from_calendar : BITCODE_B;
          num_dates : BITCODE_BL;
          dates : ^Dwg_SUNSTUDY_Dates;
          select_range_of_dates : BITCODE_B;
          start_time : BITCODE_BL;
          end_time : BITCODE_BL;
          interval : BITCODE_BL;
          num_hours : BITCODE_BL;
          hours : ^BITCODE_B;
          shade_plot_type : BITCODE_BL;
          numvports : BITCODE_BL;
          numrows : BITCODE_BL;
          numcols : BITCODE_BL;
          spacing : BITCODE_BD;
          lock_viewports : BITCODE_B;
          label_viewports : BITCODE_B;
          page_setup_wizard : BITCODE_H;
          view : BITCODE_H;
          visualstyle : BITCODE_H;
          text_style : BITCODE_H;
        end;
      Dwg_Object_SUNSTUDY = _dwg_object_SUNSTUDY;

      _dwg_DATATABLE_row = record
          parent : ^_dwg_DATATABLE_column;
          value : Dwg_TABLE_value;
        end;
      Dwg_DATATABLE_row = _dwg_DATATABLE_row;
    { DXF 92  }
    { DXF 2  }

      _dwg_DATATABLE_column = record
          parent : ^_dwg_object_DATATABLE;
          _type : BITCODE_BL;
          text : BITCODE_T;
          rows : ^Dwg_DATATABLE_row;
        end;
      Dwg_DATATABLE_column = _dwg_DATATABLE_column;
    {*
     Object DATATABLE (varies)
     --enable-debug only
      }
    { DXF 70  }
    { DXF 90  }
    { DXF 91  }
    { DXF 1  }

      _dwg_object_DATATABLE = record
          parent : ^_dwg_object_object;
          flags : BITCODE_BS;
          num_cols : BITCODE_BL;
          num_rows : BITCODE_BL;
          table_name : BITCODE_T;
          cols : ^Dwg_DATATABLE_column;
        end;
      Dwg_Object_DATATABLE = _dwg_object_DATATABLE;
    {*
     Object DATALINK (varies)
      }
    { 330 }
    { 304 }

      _dwg_DATALINK_customdata = record
          parent : ^_dwg_object_DATALINK;
          target : BITCODE_H;
          text : BITCODE_T;
        end;
      Dwg_DATALINK_customdata = _dwg_DATALINK_customdata;
    {<! DXF 70 1  }
    {<! DXF 1   }
    {<! DXF 300   }
    {<! DXF 301   }
    {<! DXF 302   }
    {<! DXF 90  2  }
    {<! DXF 91  1179649  }
    {<! DXF 92  1  }
    {<! DXF 170   }
    {<! DXF 171   }
    {<! DXF 172   }
    {<! DXF 173   }
    {<! DXF 174   }
    {<! DXF 175   }
    {<! DXF 176   }
    {<! DXF 177  1  }
    {<! DXF 93   0  }
    {<! DXF 304   }
    { 94 }
    { 330 + 304 }
    {<! DXF 360   }

      _dwg_object_DATALINK = record
          parent : ^_dwg_object_object;
          class_version : BITCODE_BS;
          data_adapter : BITCODE_T;
          description : BITCODE_T;
          tooltip : BITCODE_T;
          connection_string : BITCODE_T;
          option : BITCODE_BL;
          update_option : BITCODE_BL;
          bl92 : BITCODE_BL;
          year : BITCODE_BS;
          month : BITCODE_BS;
          day : BITCODE_BS;
          hour : BITCODE_BS;
          minute : BITCODE_BS;
          seconds : BITCODE_BS;
          msec : BITCODE_BS;
          path_option : BITCODE_BS;
          bl93 : BITCODE_BL;
          update_status : BITCODE_T;
          num_customdata : BITCODE_BL;
          customdata : ^Dwg_DATALINK_customdata;
          hardowner : BITCODE_H;
        end;
      Dwg_Object_DATALINK = _dwg_object_DATALINK;
    {*
     Object DIMASSOC (varies) DEBUGGING
     --enable-debug only
      }
    {!< DXF 1 constant  }
    {!< DXF 72  }
    {!< DXF 40  }
    {!< DXF 10-30  }
    {!< DXF 331 the geometry objects, 1 or 2  }    {!< DXF 73  }
    {!< DXF 91  }
    {!< DXF 301  }
    {!< DXF 75  }
    {!< DXF ??  }
    {!< DXF 74  }
    {!< DXF 332 the intersection objects, 1 or 2  }

      _dwg_DIMASSOC_Ref = record
          parent : ^_dwg_object_DIMASSOC;
          classname : BITCODE_T;
          osnap_type : BITCODE_RC;
          osnap_dist : BITCODE_BD;
          osnap_pt : BITCODE_3BD;
          num_xrefs : BITCODE_BS;
          xrefs : ^BITCODE_H;
          main_subent_type : BITCODE_BS;
          main_gsmarker : BITCODE_BL;
          num_xrefpaths : BITCODE_BS;
          xrefpaths : ^BITCODE_T;
          has_lastpt_ref : BITCODE_B;
          lastpt_ref : BITCODE_3BD;
          num_intsectobj : BITCODE_BL;
          intsectobj : ^BITCODE_H;
        end;
      Dwg_DIMASSOC_Ref = _dwg_DIMASSOC_Ref;
    {!< DXF 90, bitmask 0-15 }
    {!< DXF 70 boolean  }
    {!< DXF 71  }
    { 1-4x, with possible holes,
                                      depend. on associativity bitmask  }

      _dwg_object_DIMASSOC = record
          parent : ^_dwg_object_object;
          dimensionobj : BITCODE_H;
          associativity : BITCODE_BL;
          trans_space_flag : BITCODE_B;
          rotated_type : BITCODE_RC;
          ref : ^Dwg_DIMASSOC_Ref;
        end;
      Dwg_Object_DIMASSOC = _dwg_object_DIMASSOC;
    {resbuf }

      _dwg_ACTIONBODY = record
          parent : ^_dwg_object_ASSOCNETWORK;
          evaluatorid : BITCODE_T;
          expression : BITCODE_T;
          value : BITCODE_BL;
        end;
      Dwg_ACTIONBODY = _dwg_ACTIONBODY;
    { the DXF code  }

      _dwg_EvalVariant = record
          code : BITCODE_BS;
          u : record
              case longint of
                0 : ( bd : BITCODE_BD );
                1 : ( bl : BITCODE_BL );
                2 : ( bs : BITCODE_BS );
                3 : ( rc : BITCODE_RC );
                4 : ( text : BITCODE_T );
                5 : ( handle : BITCODE_H );
              end;
        end;
      Dwg_EvalVariant = _dwg_EvalVariant;
    {struct _dwg_VALUEPARAM *parent; }

      _dwg_VALUEPARAM_vars = record
          value : Dwg_EvalVariant;
          handle : BITCODE_H;
        end;
      Dwg_VALUEPARAM_vars = _dwg_VALUEPARAM_vars;
    { AcDbAssocParamBasedActionBody  }
    { 90 0  }
    { 90 0  }
    { 90 1  }
    { 360  }
    { 90: 0  }
    { 90  }
    { 330  }
    { 90  }

      _dwg_ASSOCPARAMBASEDACTIONBODY = record
          parent : ^_dwg_object_object;
          version : BITCODE_BL;
          minor : BITCODE_BL;
          num_deps : BITCODE_BL;
          deps : ^BITCODE_H;
          l4 : BITCODE_BL;
          l5 : BITCODE_BL;
          assocdep : BITCODE_H;
          num_values : BITCODE_BL;
          values : ^_dwg_VALUEPARAM;
        end;
      Dwg_ASSOCPARAMBASEDACTIONBODY = _dwg_ASSOCPARAMBASEDACTIONBODY;
    { with AssocNewtwork means code 3 (hardowned) or 4 (softptr) }

      _dwg_ASSOCACTION_Deps = record
          parent : ^_dwg_object_ASSOCACTION;
          is_owned : BITCODE_B;
          dep : BITCODE_H;
        end;
      Dwg_ASSOCACTION_Deps = _dwg_ASSOCACTION_Deps;

      {$define ASSOCACTION_fields:=(*until r2010: 1, 2013+: 2*)class_version:BITCODE_BS;(*90*)(*0 WellDefined, 1 UnderConstrained, 2 OverConstrained, 3 Inconsistent, 4 NotEvaluated, 5 NotAvailable, 6 RejectedByClient*)geometry_status:BITCODE_BL;(*90*)owningnetwork:BITCODE_H;(*330*)actionbody:BITCODE_H;(*360*)action_index:BITCODE_BL;(*90*)max_assoc_dep_index:BITCODE_BL;(*90*)num_deps:BITCODE_BL;(*90*)deps:^Dwg_ASSOCACTION_Deps;(*330 or 360*)num_owned_params:BITCODE_BL;(*90*)owned_params:^BITCODE_H;(*360*)num_values:BITCODE_BL;(*90*)values:^_dwg_VALUEPARAM}

      // AcDbAssocDependency
      _dwg_object_ASSOCDEPENDENCY = record
          parent:^_dwg_object_object;
          class_version : BITCODE_BS;
    {<! DXF 90  }
          status : BITCODE_BL;
    {<! DXF 90  }
          is_read_dep : BITCODE_B;
    {<! DXF 290  }
          is_write_dep : BITCODE_B;
    {<! DXF 290  }
          is_attached_to_object : BITCODE_B;
    {<! DXF 290  }
          is_delegating_to_owning_action : BITCODE_B;
    {<! DXF 290  }
          order : BITCODE_BLd;
    {<! DXF 90  }
          dep_on : BITCODE_H;
    {<! DXF 330  }
          has_name : BITCODE_B;
    {<! DXF 290  }
          name : BITCODE_T;
    {<! DXF 1  }
          depbodyid : BITCODE_BLd;
    {<! DXF 90  }
          readdep : BITCODE_H;
    {<! DXF 330  }
          dep_body : BITCODE_H;
    {<! DXF 360  }
          node : BITCODE_H;
    {<! DXF 330  }
        end;
    Dwg_Object_ASSOCDEPENDENCY = _dwg_object_ASSOCDEPENDENCY;

    {$define ASSOCPERSSUBENTID_fields:=classname:BITCODE_T;(*DXF  1*)dependent_on_compound_object:BITCODE_B(*DXF 290*)}

    {$define ASSOCEDGEPERSSUBENTID_fields:=classname:BITCODE_T;(*DXF  1*)has_classname:BITCODE_B;bl1:BITCODE_BL;class_version:BITCODE_BS;index1:BITCODE_BL;index2:BITCODE_BL;dependent_on_compound_object:BITCODE_B(*DXF 290*)}

    {$define ASSOCINDEXPERSSUBENTID_fields:=classname:BITCODE_T;(*DXF  1*)has_classname:BITCODE_B;bl1:BITCODE_BL;class_version:BITCODE_BS;subent_type:BITCODE_BL;subent_index:BITCODE_BL;dependent_on_compound_object:BITCODE_B(*DXF 290*)}

      _dwg_object_ASSOCVALUEDEPENDENCY = record
          parent : ^_dwg_object_object;
          assocdep : Dwg_Object_ASSOCDEPENDENCY;
        end;
      Dwg_Object_ASSOCVALUEDEPENDENCY = _dwg_object_ASSOCVALUEDEPENDENCY;

    { stable }
    { AcDbAssocGeomDependency }
    {<! DXF 90 0  }
    {<! DXF 290 1  }
      _dwg_object_ASSOCGEOMDEPENDENCY = record
          parent : ^_dwg_object_object;
          assocdep : Dwg_Object_ASSOCDEPENDENCY;
          class_version : BITCODE_BS;
          enabled : BITCODE_B;
          ASSOCPERSSUBENTID_fields;
        end;
      Dwg_Object_ASSOCGEOMDEPENDENCY = _dwg_object_ASSOCGEOMDEPENDENCY;

      _dwg_object_ASSOCACTION = record
          parent : ^_dwg_object_object;
          ASSOCACTION_fields;
        end;
      Dwg_Object_ASSOCACTION = _dwg_object_ASSOCACTION;
    {*
     Object ASSOCNETWORK (varies)
     subclass of AcDbAssocAction
     Object1 --ReadDep--> Action1 --WriteDep1--> Object2 --ReadDep--> Action2 ...
     extdict: ACAD_ASSOCNETWORK
      }
    { DXF 90, always 0 }
    { 90 }
    { 90 }
    { 330 or 360 }
    { 4. 330 }

      _dwg_object_ASSOCNETWORK = record
          parent : ^_dwg_object_object;
          ASSOCACTION_fields;
          network_version : BITCODE_BS;
          network_action_index : BITCODE_BL;
          num_actions : BITCODE_BL;
          actions : ^Dwg_ASSOCACTION_Deps;
          num_owned_actions : BITCODE_BL;
          owned_actions : ^BITCODE_H;
        end;
      Dwg_Object_ASSOCNETWORK = _dwg_object_ASSOCNETWORK;
    {  BITCODE_BS status;90: 0 uptodate, 1 changed_directly, 2 changed_transitive,
                              3 ChangedNoDifference, 4 FailedToEvaluate, 5 Erased, 6 Suppressed
                              7 Unresolved  }

      {$define ASSOCACTIONPARAM_fields:=is_r2013:BITCODE_BS;aap_version:BITCODE_BL;(*DXF 90*)name:BITCODE_T(*DXF 1*)}

      {$define ASSOCACTIONBODY_fields:=aab_version:BITCODE_BL(*DXF 90. r2013+: 2, earlier 1*)}

    { Constraints still in work:  }

      _dwg_CONSTRAINTGROUPNODE = record
          parent : ^_dwg_object_ASSOC2DCONSTRAINTGROUP;
          nodeid : BITCODE_BL;
          status : BITCODE_RC;
          num_connections : BITCODE_BL;
          connections : ^BITCODE_BL;
        end;
      Dwg_CONSTRAINTGROUPNODE = _dwg_CONSTRAINTGROUPNODE;

      {$define ACGEOMCONSTRAINT_fields:=node:Dwg_CONSTRAINTGROUPNODE;ownerid:BITCODE_BL;(*DXF 90*)is_implied:BITCODE_B;(*DXF 290*)is_active:BITCODE_B;(*DXF 290*)}

      {define node:=}
      {$define ACCONSTRAINTGEOMETRY_fields:=node:Dwg_CONSTRAINTGROUPNODE;geom_dep:BITCODE_H;(*4, 330*)nodeid:BITCODE_BL(*90*)}
      {undef node}

      {define node:=}
      {define SUBCLASSAcConstraintPoint:=}
      {$define ACCONSTRAINTPOINT_fields:=ACCONSTRAINTGEOMETRY_fields;SUBCLASSAcConstraintPoint;point:BITCODE_3BD(*10*)}
      {udef SUBCLASSAcConstraintPoint:=}
      {undef node}

      {define node:=}
      {define SUBCLASSAcConstraintPoint:=}
      {$define ACCONSTRAINTIMPLICITPOINT_fields(node):=ACCONSTRAINTPOINT_fields;(*SUBCLASS (AcConstraintImplicitPoint);*)point_type:BITCODE_RC;(*280*)point_idx:BITCODE_BLd;(*90 default: -1*)curve_id:BITCODE_BLd(*90 default: 0*)}
      {udef SUBCLASSAcConstraintPoint:=}
      {undef node}

      {$define ACEXPLICITCONSTRAINT_fields:=ACGEOMCONSTRAINT_fields;value_dep:BITCODE_H;(*3, 340*)dim_dep:BITCODE_H(*3, 340*)}

      {$define ACANGLECONSTRAINT_fields:=ACEXPLICITCONSTRAINT_fields;sector_type:BITCODE_RC(*280*)}

      {$define ACPARALLELCONSTRAINT_fields:=ACGEOMCONSTRAINT_fields;datum_line_idx:BITCODE_BLd(*90*)}

      {$define ACDISTANCECONSTRAINT_fields:=ACEXPLICITCONSTRAINT_fields;dir_type:BITCODE_RC;(*280 if has_distance*)distance:BITCODE_3BD(*10*)}

      {$define ACCONSTRAINEDELLIPSE_fields:=ACGEOMCONSTRAINT_fields;center:BITCODE_3BD;(*10*)sm_axis:BITCODE_3BD;(*11*)axis_ratio:BITCODE_BD(*40 i.e RadiusRatio*)}

      {$define ACCONSTRAINEDBOUNDEDELLIPSE_fields:=ACCONSTRAINEDELLIPSE_fields;start_pt:BITCODE_3BD;(*10*)end_pt:BITCODE_3BD(*11*)}

      _dwg_object_ASSOC2DCONSTRAINTGROUP = record
          parent:^_dwg_object_object;
          ASSOCACTION_fields;
          version : BITCODE_BL;
    { 90 1 }
          b1 : BITCODE_B;
    { 70 0 }
          workplane : array[0..2] of BITCODE_3BD;
    { 3x10 workplane }
          h1 : BITCODE_H;
    { 360 }
          num_actions : BITCODE_BL;
    { 90 }
          actions : ^BITCODE_H;
    { 360 }
          num_nodes : BITCODE_BL;
    { 90 9 }
          nodes : ^Dwg_CONSTRAINTGROUPNODE;
        end;
      Dwg_Object_ASSOC2DCONSTRAINTGROUP = _dwg_object_ASSOC2DCONSTRAINTGROUP;

      _dwg_object_ASSOCVARIABLE = record
          parent : ^_dwg_object_object;
          av_class_version : BITCODE_BS;
          ASSOCACTION_fields;
          name : BITCODE_T;
          t58 : BITCODE_T;
          evaluator : BITCODE_T;
          desc : BITCODE_T;
          value : Dwg_EvalVariant;
          has_t78 : BITCODE_B;
          t78 : BITCODE_T;
          b290 : BITCODE_B;
        end;
      Dwg_Object_ASSOCVARIABLE = _dwg_object_ASSOCVARIABLE;

    { 0  }
    { input vars }
      _dwg_VALUEPARAM = record
          parent : ^_dwg_object_object;
          class_version : BITCODE_BL;
          name : BITCODE_T;
          unit_type : BITCODE_BL;
          num_vars : BITCODE_BL;
          vars : ^Dwg_VALUEPARAM_vars;
          controlled_objdep : BITCODE_H;
        end;
      Dwg_VALUEPARAM = _dwg_VALUEPARAM;
    { NodeInfo }
    { 91  }
    { 93, always 32 }
    { 95 }
    { 360 }
    { 4x 92, def: 4x -1 }

      _dwg_EVAL_Node = record
          parent : ^_dwg_object_EVALUATION_GRAPH;
          id : BITCODE_BL;
          edge_flags : BITCODE_BL;
          nextid : BITCODE_BLd;
          evalexpr : BITCODE_H;
          node : array[0..3] of BITCODE_BLd;
          active_cycles : BITCODE_B;
        end;
      Dwg_EVAL_Node = _dwg_EVAL_Node;
    { EdgeInfo }
    { 92  }
    { 93  }
    { 94  }
    { 91  }
    { 91  }
    { 5x 92  }

      _dwg_EVAL_Edge = record
          parent : ^_dwg_object_EVALUATION_GRAPH;
          id : BITCODE_BL;
          nextid : BITCODE_BLd;
          e1 : BITCODE_BLd;
          e2 : BITCODE_BLd;
          e3 : BITCODE_BLd;
          out_edge : array[0..4] of BITCODE_BLd;
        end;
      Dwg_EVAL_Edge = _dwg_EVAL_Edge;
    { 96 }
    { 97 }

      _dwg_object_EVALUATION_GRAPH = record
          parent : ^_dwg_object_object;
          major : BITCODE_BL;
          minor : BITCODE_BL;
          first_nodeid : BITCODE_BLd;
          first_nodeid_copy : BITCODE_BLd;
          num_nodes : BITCODE_BL;
          nodes : ^Dwg_EVAL_Node;
          has_graph : BITCODE_B;
          num_edges : BITCODE_BL;
          edges : ^Dwg_EVAL_Edge;
        end;
      Dwg_Object_EVALUATION_GRAPH = _dwg_object_EVALUATION_GRAPH;
    { stable }
    {!< DXF 70 0  }

      _dwg_object_DYNAMICBLOCKPURGEPREVENTER = record
          parent : ^_dwg_object_object;
          flag : BITCODE_BS;
          block : BITCODE_H;
        end;
      Dwg_Object_DYNAMICBLOCKPURGEPREVENTER = _dwg_object_DYNAMICBLOCKPURGEPREVENTER;
    {!< DXF 90 2  }
    {!< DXF 90 0  }
    {!< DXF 90 2  }
    {!< DXF 90 3 from ASSOCPERSSUBENTMANAGER  }
    {!< DXF 90 0 from ASSOCPERSSUBENTMANAGER  }
    {!< DXF 90 1  }
    {!< DXF 90  }
    {!< DXF 90  }
    {!< DXF 90 types/handles?  }

      _dwg_object_PERSUBENTMGR = record
          parent : ^_dwg_object_object;
          class_version : BITCODE_BL;
          unknown_0 : BITCODE_BL;
          unknown_2 : BITCODE_BL;
          numassocsteps : BITCODE_BL;
          numassocsubents : BITCODE_BL;
          num_steps : BITCODE_BL;
          steps : ^BITCODE_BL;
          num_subents : BITCODE_BL;
          subents : ^BITCODE_BL;
        end;
      Dwg_Object_PERSUBENTMGR = _dwg_object_PERSUBENTMGR;
    { The dynamic variant of above. May be frozen as static PERSUBENTMGR }
    { TODO subentities }
    {!< DXF 90 1 or r2013+ 2  }
    {!< DXF 90 always 3  }
    {!< DXF 90 always 0  }
    {!< DXF 90 always 2  }
    {!< DXF 90 3  }
    {!< DXF 90 5  }
    {!< DXF 90  }
    {!< FIXME: subent struct  }
    {!< DXF 90 5  }
    {!< DXF 90 0  }
    {!< DXF 90 3  }
    {!< DXF 90 2  }
    {!< DXF 90 2  }
    {!< DXF 90 2  }
    {!< DXF 90 21  }
    {!< DXF 90 0  }
    {!< DXF 90 0  }
    {!< DXF 90 0  }
    {!< DXF 90 0  }
    {!< DXF 90 1  }
    {!< DXF 90 3  }
    {!< DXF 90 1  }
    {!< DXF 90 1000000000  }
    {!< DXF 90 1001  }
    {!< DXF 90 1  }
    {!< DXF 90 1000000000  }
    {!< DXF 90 51001  }
    {!< DXF 90 1  }
    {!< DXF 90 1000000000  }
    {!< DXF 90 351001  }
    {!< DXF 90 0  }
    {!< DXF 90 0  }
    {!< DXF 90 0  }
    {!< DXF 90 900  }
    {!< DXF 90 0  }
    {!< DXF 90 900  }
    {!< DXF 90 0  }
    {!< DXF 90 2  }
    {!< DXF 90 2  }
    {!< DXF 90 3 0100000011  }
    {!< DXF 90 0  }
    {!< DXF 290 0  }

      _dwg_object_ASSOCPERSSUBENTMANAGER = record
          parent : ^_dwg_object_object;
          class_version : BITCODE_BL;
          unknown_3 : BITCODE_BL;
          unknown_0 : BITCODE_BL;
          unknown_2 : BITCODE_BL;
          num_steps : BITCODE_BL;
          num_subents : BITCODE_BL;
          steps : ^BITCODE_BL;
          subents : ^BITCODE_BL;
          unknown_bl6 : BITCODE_BL;
          unknown_bl6a : BITCODE_BL;
          unknown_bl7a : BITCODE_BL;
          unknown_bl7 : BITCODE_BL;
          unknown_bl8 : BITCODE_BL;
          unknown_bl9 : BITCODE_BL;
          unknown_bl10 : BITCODE_BL;
          unknown_bl11 : BITCODE_BL;
          unknown_bl12 : BITCODE_BL;
          unknown_bl13 : BITCODE_BL;
          unknown_bl14 : BITCODE_BL;
          unknown_bl15 : BITCODE_BL;
          unknown_bl16 : BITCODE_BL;
          unknown_bl17 : BITCODE_BL;
          unknown_bl18 : BITCODE_BL;
          unknown_bl19 : BITCODE_BL;
          unknown_bl20 : BITCODE_BL;
          unknown_bl21 : BITCODE_BL;
          unknown_bl22 : BITCODE_BL;
          unknown_bl23 : BITCODE_BL;
          unknown_bl24 : BITCODE_BL;
          unknown_bl25 : BITCODE_BL;
          unknown_bl26 : BITCODE_BL;
          unknown_bl27 : BITCODE_BL;
          unknown_bl28 : BITCODE_BL;
          unknown_bl29 : BITCODE_BL;
          unknown_bl30 : BITCODE_BL;
          unknown_bl31 : BITCODE_BL;
          unknown_bl32 : BITCODE_BL;
          unknown_bl33 : BITCODE_BL;
          unknown_bl34 : BITCODE_BL;
          unknown_bl35 : BITCODE_BL;
          unknown_bl36 : BITCODE_BL;
          unknown_b37 : BITCODE_B;
        end;
      Dwg_Object_ASSOCPERSSUBENTMANAGER = _dwg_object_ASSOCPERSSUBENTMANAGER;

      {$define ASSOCPARAMBASEDACTIONBODY_fields:=pab:Dwg_ASSOCPARAMBASEDACTIONBODY}

      {$define ASSOCCOMPOUNDACTIONPARAM_fields:=class_version:BITCODE_BS;bs1:BITCODE_BS;num_params:BITCODE_BL;params:^BITCODE_H;has_child_param:BITCODE_B;child_status:BITCODE_BS;child_id:BITCODE_BL;child_param:BITCODE_H;h330_2:BITCODE_H;bl2:BITCODE_BL;h330_3:BITCODE_H}

      _dwg_object_ASSOCACTIONPARAM = record
          parent:^_dwg_object_object;
          ASSOCACTIONPARAM_fields;
        end;
      Dwg_Object_ASSOCACTIONPARAM = _dwg_object_ASSOCACTIONPARAM;

    {*
     Object ASSOCOSNAPPOINTREFACTIONPARAM (varies)
     Action parameter that owns other AcDbAssocActionParameters,
     allowing the representation of hierarchical structures of action parameters.
      }
    { 40 -1.0 }
      _dwg_object_ASSOCOSNAPPOINTREFACTIONPARAM = record
          parent : ^_dwg_object_object;
          ASSOCACTIONPARAM_fields;
          ASSOCCOMPOUNDACTIONPARAM_fields;
          status : BITCODE_BS;
          osnap_mode : BITCODE_RC;
          param : BITCODE_BD;
        end;
      Dwg_Object_ASSOCOSNAPPOINTREFACTIONPARAM = _dwg_object_ASSOCOSNAPPOINTREFACTIONPARAM;

      _dwg_object_ASSOCPOINTREFACTIONPARAM = record
          parent : ^_dwg_object_object;
          ASSOCACTIONPARAM_fields;
          ASSOCCOMPOUNDACTIONPARAM_fields
        end;
      Dwg_Object_ASSOCPOINTREFACTIONPARAM = _dwg_object_ASSOCPOINTREFACTIONPARAM;

    { AcDbAssocSingleDependencyActionParam  }    { 0 }
    { AcDbAssocAsmbodyActionParam  }
      _dwg_object_ASSOCASMBODYACTIONPARAM = record
          parent : ^_dwg_object_object;
          ASSOCACTIONPARAM_fields;
          asdap_class_version : BITCODE_BL;
          dep : BITCODE_H;
          class_version : BITCODE_BL;
          _3DSOLID_FIELDS;
        end;
      Dwg_Object_ASSOCASMBODYACTIONPARAM = _dwg_object_ASSOCASMBODYACTIONPARAM;

      _dwg_object_ASSOCCOMPOUNDACTIONPARAM = record
          parent : ^_dwg_object_object;
          ASSOCACTIONPARAM_fields;
          ASSOCCOMPOUNDACTIONPARAM_fields;
        end;
      Dwg_Object_ASSOCCOMPOUNDACTIONPARAM = _dwg_object_ASSOCCOMPOUNDACTIONPARAM;

    { AcDbAssocSingleDependencyActionParam  }
    { 0 }
    { AcDbAssocObjectActionParam  }
    { DXF 90: 0  }

      _dwg_object_ASSOCOBJECTACTIONPARAM = record
          parent : ^_dwg_object_object;
          ASSOCACTIONPARAM_fields;
          asdap_class_version : BITCODE_BL;
          dep : BITCODE_H;
          class_version : BITCODE_BS;
        end;
      Dwg_Object_ASSOCOBJECTACTIONPARAM = _dwg_object_ASSOCOBJECTACTIONPARAM;

    { AcDbAssocSingleDependencyActionParam  }
    { 0 }
    { AcDbAssocEdgeActionParam  }

      _dwg_object_ASSOCEDGEACTIONPARAM = record
          parent : ^_dwg_object_object;
          ASSOCACTIONPARAM_fields;
          asdap_class_version : BITCODE_BL;
          dep : BITCODE_H;
          class_version : BITCODE_BL;
          param : BITCODE_H;
          has_action : BITCODE_B;
          action_type : BITCODE_BL;
          subent : BITCODE_H;
        end;
      Dwg_Object_ASSOCEDGEACTIONPARAM = _dwg_object_ASSOCEDGEACTIONPARAM;

    { AcDbAssocSingleDependencyActionParam  }
    { 0 }
    { AcDbAssocFaceActionParam  }
      _dwg_object_ASSOCFACEACTIONPARAM = record
          parent : ^_dwg_object_object;
          ASSOCACTIONPARAM_fields;
          asdap_class_version : BITCODE_BL;
          dep : BITCODE_H;
          class_version : BITCODE_BL;
          index : BITCODE_BL;
        end;
      Dwg_Object_ASSOCFACEACTIONPARAM = _dwg_object_ASSOCFACEACTIONPARAM;

    { AcDbAssocPathActionParam  }
    {!< DXF 90  }
      _dwg_object_ASSOCPATHACTIONPARAM = record
          parent : ^_dwg_object_object;
          ASSOCACTIONPARAM_fields;
          ASSOCCOMPOUNDACTIONPARAM_fields;
          version : BITCODE_BL;
        end;
      Dwg_Object_ASSOCPATHACTIONPARAM = _dwg_object_ASSOCPATHACTIONPARAM;

    { AcDbAssocSingleDependencyActionParam  }
    { 0 }
    { AcDbAssocFaceActionParam  }
      _dwg_object_ASSOCVERTEXACTIONPARAM = record
          parent : ^_dwg_object_object;
          ASSOCACTIONPARAM_fields;
          asdap_class_version : BITCODE_BL;
          dep : BITCODE_H;
          class_version : BITCODE_BL;
          pt : BITCODE_3BD;
        end;
      Dwg_Object_ASSOCVERTEXACTIONPARAM = _dwg_object_ASSOCVERTEXACTIONPARAM;
    { inlined }
    { 0 }
    { 2: has_relative_transform
                           16: has_h2
                          }
    { computed  }
    { DXF 11  }
    { 16x BD 40  }
    { 16x BD 40  }
    { computed  }

      _dwg_ASSOCARRAYITEM = record
          parent : ^_dwg_abstractobject_ASSOCARRAYPARAMETERS;
          class_version : BITCODE_BL;
          itemloc : array[0..2] of BITCODE_BL;
          flags : BITCODE_BL;
          is_default_transmatrix : longint;
          x_dir : BITCODE_3BD;
          transmatrix : ^BITCODE_BD;
          rel_transform : ^BITCODE_BD;
          has_h1 : longint;
          h1 : BITCODE_H;
          h2 : BITCODE_H;
        end;
      Dwg_ASSOCARRAYITEM = _dwg_ASSOCARRAYITEM;

      {$define ASSOCARRAYPARAMETERS_fields:=aap_version:BITCODE_BL;num_items:BITCODE_BL;classname:BITCODE_T;items:^Dwg_ASSOCARRAYITEM}

      _dwg_abstractobject_ASSOCARRAYPARAMETERS = record
          parent:^_dwg_object_object;
          ASSOCARRAYPARAMETERS_fields;
          numitems : BITCODE_BL;
          numrows : BITCODE_BL;
          numlevels : BITCODE_BL;
        end;
      Dwg_Object_ASSOCARRAYPARAMETERS = _dwg_abstractobject_ASSOCARRAYPARAMETERS;

      Dwg_Object_ASSOCARRAYMODIFYPARAMETERS = _dwg_abstractobject_ASSOCARRAYPARAMETERS;
      Dwg_Object_ASSOCARRAYPATHPARAMETERS = _dwg_abstractobject_ASSOCARRAYPARAMETERS;
      Dwg_Object_ASSOCARRAYPOLARPARAMETERS = _dwg_abstractobject_ASSOCARRAYPARAMETERS;
      Dwg_Object_ASSOCARRAYRECTANGULARPARAMETERS = _dwg_abstractobject_ASSOCARRAYPARAMETERS;

    { AcDbAssocRestoreEntityStateActionBody  }
      _dwg_object_ASSOCRESTOREENTITYSTATEACTIONBODY = record
          parent : ^_dwg_object_object;
          ASSOCACTIONBODY_fields;
          class_version : BITCODE_BL;
          entity : BITCODE_H;
        end;
      Dwg_Object_ASSOCRESTOREENTITYSTATEACTIONBODY = _dwg_object_ASSOCRESTOREENTITYSTATEACTIONBODY;
    { AcDbAssocSurfaceActionBody  }
    {!< DXF 90  }
    {!< DXF 290  }
    {!< DXF 90  }
    {!< DXF 290 is_semi_associativity_satisfied_override  }
    {!< DXF 70  }
    { ASSOCDEPENDENCY  }

      _dwg_ASSOCSURFACEACTIONBODY = record
          parent : ^_dwg_object_object;
          version : BITCODE_BL;
          is_semi_assoc : BITCODE_B;
          l2 : BITCODE_BL;
          is_semi_ovr : BITCODE_B;
          grip_status : BITCODE_BS;
          assocdep : BITCODE_H;
        end;
      Dwg_ASSOCSURFACEACTIONBODY = _dwg_ASSOCSURFACEACTIONBODY;

      {$define ASSOCPATHBASEDSURFACEACTIONBODY_fields:=ASSOCACTIONBODY_fields;pab:Dwg_ASSOCPARAMBASEDACTIONBODY;sab:Dwg_ASSOCSURFACEACTIONBODY;(*AcDbAssocPathBasedSurfaceActionBody*)pbsab_status:BITCODE_BL(*!< DXF 90*)}

      _dwg_object_ASSOCEXTENDSURFACEACTIONBODY = record
          parent:^_dwg_object_object;
          ASSOCPATHBASEDSURFACEACTIONBODY_fields;
          { AcDbAssocPathBasedSurfaceActionBody  }
          class_version : BITCODE_BL;
    {!< DXF 90   }
          option : BITCODE_RC;
    {!< DXF 280 edge_extension_type  }
        end;
      Dwg_Object_ASSOCEXTENDSURFACEACTIONBODY = _dwg_object_ASSOCEXTENDSURFACEACTIONBODY;

      _dwg_object_ASSOCEXTRUDEDSURFACEACTIONBODY = record
          parent : ^_dwg_object_object;
          ASSOCPATHBASEDSURFACEACTIONBODY_fields;
          class_version : BITCODE_BL;
        end;
      Dwg_Object_ASSOCEXTRUDEDSURFACEACTIONBODY = _dwg_object_ASSOCEXTRUDEDSURFACEACTIONBODY;

    { AcDbAssocPlaneSurfaceActionBody }
    {!< DXF 90   }

      _dwg_object_ASSOCPLANESURFACEACTIONBODY = record
          parent : ^_dwg_object_object;
          ASSOCPATHBASEDSURFACEACTIONBODY_fields;
          class_version : BITCODE_BL;
        end;
      Dwg_Object_ASSOCPLANESURFACEACTIONBODY = _dwg_object_ASSOCPLANESURFACEACTIONBODY;

    { AcDbAssocLoftedSurfaceActionBody }
    {!< DXF 90   }

      _dwg_object_ASSOCLOFTEDSURFACEACTIONBODY = record
          parent : ^_dwg_object_object;
          ASSOCPATHBASEDSURFACEACTIONBODY_fields;
          class_version : BITCODE_BL;
        end;
      Dwg_Object_ASSOCLOFTEDSURFACEACTIONBODY = _dwg_object_ASSOCLOFTEDSURFACEACTIONBODY;

    { AcDbAssocNetworkSurfaceActionBody }
    {!< DXF 90   }

      _dwg_object_ASSOCNETWORKSURFACEACTIONBODY = record
          parent : ^_dwg_object_object;
          ASSOCPATHBASEDSURFACEACTIONBODY_fields;
          class_version : BITCODE_BL;
        end;
      Dwg_Object_ASSOCNETWORKSURFACEACTIONBODY = _dwg_object_ASSOCNETWORKSURFACEACTIONBODY;

    { AcDbAssocOffsetSurfaceActionBody }
    {!< DXF 90   }
    {!< DXF 290   }

      _dwg_object_ASSOCOFFSETSURFACEACTIONBODY = record
          parent : ^_dwg_object_object;
          ASSOCPATHBASEDSURFACEACTIONBODY_fields;
          class_version : BITCODE_BL;
          b1 : BITCODE_B;
        end;
      Dwg_Object_ASSOCOFFSETSURFACEACTIONBODY = _dwg_object_ASSOCOFFSETSURFACEACTIONBODY;

    { AcDbAssocRevolvedSurfaceActionBody }
    {!< DXF 90   }

      _dwg_object_ASSOCREVOLVEDSURFACEACTIONBODY = record
          parent : ^_dwg_object_object;
          ASSOCPATHBASEDSURFACEACTIONBODY_fields;
          class_version : BITCODE_BL;
        end;
      Dwg_Object_ASSOCREVOLVEDSURFACEACTIONBODY = _dwg_object_ASSOCREVOLVEDSURFACEACTIONBODY;

    { AcDbAssocSweptSurfaceActionBody }
    {!< DXF 90   }

      _dwg_object_ASSOCSWEPTSURFACEACTIONBODY = record
          parent : ^_dwg_object_object;
          ASSOCPATHBASEDSURFACEACTIONBODY_fields;
          class_version : BITCODE_BL;
        end;
      Dwg_Object_ASSOCSWEPTSURFACEACTIONBODY = _dwg_object_ASSOCSWEPTSURFACEACTIONBODY;


      _dwg_object_ASSOCEDGECHAMFERACTIONBODY = record
          parent : ^_dwg_object_object;
          ASSOCPATHBASEDSURFACEACTIONBODY_fields;
        end;
      Dwg_Object_ASSOCEDGECHAMFERACTIONBODY = _dwg_object_ASSOCEDGECHAMFERACTIONBODY;


      _dwg_object_ASSOCEDGEFILLETACTIONBODY = record
          parent : ^_dwg_object_object;
          ASSOCPATHBASEDSURFACEACTIONBODY_fields;
        end;
      Dwg_Object_ASSOCEDGEFILLETACTIONBODY = _dwg_object_ASSOCEDGEFILLETACTIONBODY;

    { AcDbAssocTrimSurfaceActionBody }
    {!< DXF 90   }
    {!< DXF 290  }
    {!< DXF 290  }
    {!< DXF 40   }

      _dwg_object_ASSOCTRIMSURFACEACTIONBODY = record
          parent : ^_dwg_object_object;
          ASSOCPATHBASEDSURFACEACTIONBODY_fields;
          class_version : BITCODE_BL;
          b1 : BITCODE_B;
          b2 : BITCODE_B;
          distance : BITCODE_BD;
        end;
      Dwg_Object_ASSOCTRIMSURFACEACTIONBODY = _dwg_object_ASSOCTRIMSURFACEACTIONBODY;

    { AcDbAssocBlendSurfaceActionBody }
    {!< DXF 90   }
    {!< DXF 290  }
    {!< DXF 291  }
    {!< DXF 292  }
    {!< DXF 293  }
    {!< DXF 294  }
    {!< DXF 72   }
    {!< DXF 73   }

      _dwg_object_ASSOCBLENDSURFACEACTIONBODY = record
          parent : ^_dwg_object_object;
          ASSOCPATHBASEDSURFACEACTIONBODY_fields;
          class_version : BITCODE_BL;
          b1 : BITCODE_B;
          b2 : BITCODE_B;
          b3 : BITCODE_B;
          b4 : BITCODE_B;
          b5 : BITCODE_B;
          blend_options : BITCODE_BS;
          bs2 : BITCODE_BS;
        end;
      Dwg_Object_ASSOCBLENDSURFACEACTIONBODY = _dwg_object_ASSOCBLENDSURFACEACTIONBODY;

    { AcDbAssocFilletSurfaceActionBody }
    {!< DXF 90   }
    {!< DXF 70   }
    {!< DXF 10   }
    {!< DXF 10   }

      _dwg_object_ASSOCFILLETSURFACEACTIONBODY = record
          parent : ^_dwg_object_object;
          ASSOCPATHBASEDSURFACEACTIONBODY_fields;
          class_version : BITCODE_BL;
          status : BITCODE_BS;
          pt1 : BITCODE_2RD;
          pt2 : BITCODE_2RD;
        end;
      Dwg_Object_ASSOCFILLETSURFACEACTIONBODY = _dwg_object_ASSOCFILLETSURFACEACTIONBODY;

    { AcDbAssocPatchSurfaceActionBody }
    {!< DXF 90   }

      _dwg_object_ASSOCPATCHSURFACEACTIONBODY = record
          parent : ^_dwg_object_object;
          ASSOCPATHBASEDSURFACEACTIONBODY_fields;
          class_version : BITCODE_BL;
        end;
      Dwg_Object_ASSOCPATCHSURFACEACTIONBODY = _dwg_object_ASSOCPATCHSURFACEACTIONBODY;


      {$define ASSOCANNOTATIONACTIONBODY_fields:=aaab_version:BITCODE_BS;assoc_dep:BITCODE_H;aab_version:BITCODE_BS;actionbody:BITCODE_H}


      _dwg_ASSOCACTIONBODY_action = record
          parent:^_dwg_object_ASSOCMLEADERACTIONBODY;
          depid : BITCODE_BL;
          dep : BITCODE_H;
        end;
      Dwg_ASSOCACTIONBODY_action = _dwg_ASSOCACTIONBODY_action;

    { 90 0 }
      _dwg_object_ASSOCMLEADERACTIONBODY = record
          parent : ^_dwg_object_object;
          ASSOCANNOTATIONACTIONBODY_fields;
          pab : Dwg_ASSOCPARAMBASEDACTIONBODY;
          class_version : BITCODE_BL;
          num_actions : BITCODE_BL;
          actions : ^Dwg_ASSOCACTIONBODY_action;
        end;
      Dwg_Object_ASSOCMLEADERACTIONBODY = _dwg_object_ASSOCMLEADERACTIONBODY;

    { 90 0 }
    { 330 }
    { 330 }

      _dwg_object_ASSOCALIGNEDDIMACTIONBODY = record
          parent : ^_dwg_object_object;
          ASSOCANNOTATIONACTIONBODY_fields;
          pab : Dwg_ASSOCPARAMBASEDACTIONBODY;
          class_version : BITCODE_BL;
          r_node : BITCODE_H;
          d_node : BITCODE_H;
        end;
      Dwg_Object_ASSOCALIGNEDDIMACTIONBODY = _dwg_object_ASSOCALIGNEDDIMACTIONBODY;

    {!< DXF 90   }
    {!< DXF 330   }
    {!< DXF 330   }
    {!< DXF 330   }

      _dwg_object_ASSOC3POINTANGULARDIMACTIONBODY = record
          parent : ^_dwg_object_object;
          ASSOCANNOTATIONACTIONBODY_fields;
          pab : Dwg_ASSOCPARAMBASEDACTIONBODY;
          class_version : BITCODE_BS;
          r_node : BITCODE_H;
          d_node : BITCODE_H;
          assocdep : BITCODE_H;
        end;
      Dwg_Object_ASSOC3POINTANGULARDIMACTIONBODY = _dwg_object_ASSOC3POINTANGULARDIMACTIONBODY;

    {!< DXF 90   }
    {!< DXF 330  }
    {!< DXF 330  }

      _dwg_object_ASSOCORDINATEDIMACTIONBODY = record
          parent : ^_dwg_object_object;
          ASSOCANNOTATIONACTIONBODY_fields;
          pab : Dwg_ASSOCPARAMBASEDACTIONBODY;
          class_version : BITCODE_BL;
          r_node : BITCODE_H;
          d_node : BITCODE_H;
        end;
      Dwg_Object_ASSOCORDINATEDIMACTIONBODY = _dwg_object_ASSOCORDINATEDIMACTIONBODY;

    {!< DXF 90   }
    {!< DXF 330  }
    {!< DXF 330  }

      _dwg_object_ASSOCROTATEDDIMACTIONBODY = record
          parent : ^_dwg_object_object;
          ASSOCANNOTATIONACTIONBODY_fields;
          pab : Dwg_ASSOCPARAMBASEDACTIONBODY;
          class_version : BITCODE_BS;
          r_node : BITCODE_H;
          d_node : BITCODE_H;
        end;
      Dwg_Object_ASSOCROTATEDDIMACTIONBODY = _dwg_object_ASSOCROTATEDDIMACTIONBODY;
    { 90 1 }
    { 90 1 }
    { 1 }
    { 90 1 }

      _dwg_object_ASSOCDIMDEPENDENCYBODY = record
          parent : ^_dwg_object_object;
          adb_version : BITCODE_BS;
          dimbase_version : BITCODE_BS;
          name : BITCODE_T;
          class_version : BITCODE_BS;
        end;
      Dwg_Object_ASSOCDIMDEPENDENCYBODY = _dwg_object_ASSOCDIMDEPENDENCYBODY;
    { 90 1 }
    { 90 1 }
    { 1 }
    { 90 0 }

      _dwg_object_BLOCKPARAMDEPENDENCYBODY = record
          parent : ^_dwg_object_object;
          adb_version : BITCODE_BS;
          dimbase_version : BITCODE_BS;
          name : BITCODE_T;
          class_version : BITCODE_BS;
        end;
      Dwg_Object_BLOCKPARAMDEPENDENCYBODY = _dwg_object_BLOCKPARAMDEPENDENCYBODY;
    { BITCODE_BL *itemloc; 3x DXF 90, FIXME dynapi: "itemloc[3]" => "itemloc"  }

      _dwg_ARRAYITEMLOCATOR = record
          parent : ^_dwg_object_ASSOCARRAYMODIFYACTIONBODY;
          itemloc1 : BITCODE_BL;
          itemloc2 : BITCODE_BL;
          itemloc3 : BITCODE_BL;
        end;
      Dwg_ARRAYITEMLOCATOR = _dwg_ARRAYITEMLOCATOR;


      {$define ASSOCARRAYACTIONBODY_fields:=ASSOCACTIONBODY_fields;pab:Dwg_ASSOCPARAMBASEDACTIONBODY;aaab_version:BITCODE_BL;paramblock:BITCODE_T;(*classname, i.e. AcDbAssocArrayPolarParameters*)transmatrix:^BITCODE_BD}

      _dwg_object_ASSOCARRAYACTIONBODY = record
          parent:^_dwg_object_object;
          ASSOCARRAYACTIONBODY_fields;
        end;
      Dwg_Object_ASSOCARRAYACTIONBODY =  _dwg_object_ASSOCARRAYACTIONBODY;


      _dwg_object_ASSOCARRAYMODIFYACTIONBODY = record
          parent : ^_dwg_object_object;
          ASSOCARRAYACTIONBODY_fields;
          status : BITCODE_BS;
          num_items : BITCODE_BL;
          items : ^Dwg_ARRAYITEMLOCATOR;
        end;
      Dwg_Object_ASSOCARRAYMODIFYACTIONBODY = _dwg_object_ASSOCARRAYMODIFYACTIONBODY;

    { A node in the EVALUATION_GRAPH  }
    { -1 if none  }
    { compare to EvalVariant }

      _dwg_EvalExpr = record
          parentid : BITCODE_BLd;
          major : BITCODE_BL;
          minor : BITCODE_BL;
          value_code : BITCODE_BSd;
          value : record
              case longint of
                0 : ( num40 : BITCODE_BD );
                1 : ( pt2d : BITCODE_2RD );
                2 : ( pt3d : BITCODE_3BD );
                3 : ( text1 : BITCODE_T );
                4 : ( long90 : BITCODE_BL );
                5 : ( handle91 : BITCODE_H );
                6 : ( short70 : BITCODE_BS );
              end;
          nodeid : BITCODE_BL;
        end;
      Dwg_EvalExpr = _dwg_EvalExpr;

      _dwg_ACSH_SubentMaterial = record
          major : BITCODE_BL;
          minor : BITCODE_BL;
          reflectance : BITCODE_BL;
          displacement : BITCODE_BL;
        end;
      Dwg_ACSH_SubentMaterial = _dwg_ACSH_SubentMaterial;
    { on body, face or edge }

      _dwg_ACSH_SubentColor = record
          major : BITCODE_BL;
          minor : BITCODE_BL;
          transparency : BITCODE_BL;
          bl93 : BITCODE_BL;
          is_face_variable : BITCODE_B;
        end;
      Dwg_ACSH_SubentColor = _dwg_ACSH_SubentColor;
    {33 }
    {29 }
    {last 16x nums 40-55 }
    {!< DXF 62  }
    {!< DXF 92  }
    {!< DXF 347  }

      _dwg_ACSH_HistoryNode = record
          major : BITCODE_BL;
          minor : BITCODE_BL;
          trans : ^BITCODE_BD;
          color : BITCODE_CMC;
          step_id : BITCODE_BL;
          material : BITCODE_H;
        end;
      Dwg_ACSH_HistoryNode = _dwg_ACSH_HistoryNode;
    {#define Dwg_EvalExpr evalexpr Dwg_EvalExpr evalexpr }
    { the last nodeid, i.e. num_nodes }

      _dwg_object_ACSH_HISTORY_CLASS = record
          parent : ^_dwg_object_object;
          major : BITCODE_BL;
          minor : BITCODE_BL;
          owner : BITCODE_H;
          h_nodeid : BITCODE_BL;
          show_history : BITCODE_B;
          record_history : BITCODE_B;
        end;
      Dwg_Object_ACSH_HISTORY_CLASS = _dwg_object_ACSH_HISTORY_CLASS;
    { i.e. planesurf? }
    { AcDbShPrimitive }
    { AcDbShBox }
    {!< DXF 90 (33)  }
    {!< DXF 91 (29)  }
    {!< DXF 40 1300.0 (length?)  }
    {!< DXF 41 20.0 (width?)  }
    {!< DXF 42 420.0 (height?)  }

      _dwg_object_ACSH_BOX_CLASS = record
          parent : ^_dwg_object_object;
          evalexpr : Dwg_EvalExpr;
          history_node : Dwg_ACSH_HistoryNode;
          major : BITCODE_BL;
          minor : BITCODE_BL;
          length : BITCODE_BD;
          width : BITCODE_BD;
          height : BITCODE_BD;
        end;
      Dwg_Object_ACSH_BOX_CLASS = _dwg_object_ACSH_BOX_CLASS;
    { AcDbShPrimitive }
    { AcDbShWedge }
    {!< DXF 90 (33)  }
    {!< DXF 91 (29)  }
    {!< DXF 40 1300.0 (length?)  }
    {!< DXF 41 20.0 (width?)  }
    {!< DXF 42 420.0 (height?)  }

      _dwg_object_ACSH_WEDGE_CLASS = record
          parent : ^_dwg_object_object;
          evalexpr : Dwg_EvalExpr;
          history_node : Dwg_ACSH_HistoryNode;
          major : BITCODE_BL;
          minor : BITCODE_BL;
          length : BITCODE_BD;
          width : BITCODE_BD;
          height : BITCODE_BD;
        end;
      Dwg_Object_ACSH_WEDGE_CLASS = _dwg_object_ACSH_WEDGE_CLASS;
    { AcDbShPrimitive }
    { AcDbShBoolean }
    {!< DXF 90  }
    {!< DXF 91  }
    {!< DXF 280  }
    {!< DXF 92  }
    {!< DXF 93  }

      _dwg_object_ACSH_BOOLEAN_CLASS = record
          parent : ^_dwg_object_object;
          evalexpr : Dwg_EvalExpr;
          history_node : Dwg_ACSH_HistoryNode;
          major : BITCODE_BL;
          minor : BITCODE_BL;
          operation : BITCODE_RCd;
          operand1 : BITCODE_BL;
          operand2 : BITCODE_BL;
        end;
      Dwg_Object_ACSH_BOOLEAN_CLASS = _dwg_object_ACSH_BOOLEAN_CLASS;

    { AcDbShPrimitive }
    { AcDbShBrep }
    {!< DXF 90  }
    {!< DXF 91  }

      _dwg_object_ACSH_BREP_CLASS = record
          parent : ^_dwg_object_object;
          _3DSOLID_FIELDS;
          evalexpr : Dwg_EvalExpr;
          history_node : Dwg_ACSH_HistoryNode;
          major : BITCODE_BL;
          minor : BITCODE_BL;
        end;
      Dwg_Object_ACSH_BREP_CLASS = _dwg_object_ACSH_BREP_CLASS;
    { AcDbShPrimitive }
    { AcDbShSweepBase }
    {!< DXF 90  }
    {!< DXF 91  }
    {!< DXF 10  }
    {!< DXF 92  }
    {!< DXF 90  }
    {!< DXF 310  }
    {!< DXF 93  }
    {!< DXF 90  }
    {!< DXF 310  }
    { compare to SWEEPOPTIONS_fields }
    {!< DXF 42 0.0  }
    {!< DXF 43 0.0  }
    {!< DXF 44 0.0  }
    {!< DXF 45 1.0  }
    {!< DXF 48 0.0  }
    {!< DXF 49 0.0  }
    {!< DXF 46 16x  }
    {!< DXF 47 16x  }
    {!< DXF 70 2  }
    {!< DXF 71 2  }
    {!< DXF 290 1  }
    {!< DXF 292 1  }
    {!< DXF 293 0  }
    {!< DXF 294  1  }
    {!< DXF 295  1  }
    {!< DXF 296  1  }
    {!< DXF 11 0,0,0  }
    { AcDbShSweep }

      _dwg_object_ACSH_SWEEP_CLASS = record
          parent : ^_dwg_object_object;
          evalexpr : Dwg_EvalExpr;
          history_node : Dwg_ACSH_HistoryNode;
          major : BITCODE_BL;
          minor : BITCODE_BL;
          direction : BITCODE_3BD;
          bl92 : BITCODE_BL;
          shsw_text_size : BITCODE_BL;
          shsw_text : BITCODE_TF;
          shsw_bl93 : BITCODE_BL;
          shsw_text2_size : BITCODE_BL;
          shsw_text2 : BITCODE_TF;
          draft_angle : BITCODE_BD;
          start_draft_dist : BITCODE_BD;
          end_draft_dist : BITCODE_BD;
          scale_factor : BITCODE_BD;
          twist_angle : BITCODE_BD;
          align_angle : BITCODE_BD;
          sweepentity_transform : ^BITCODE_BD;
          pathentity_transform : ^BITCODE_BD;
          align_option : BITCODE_RC;
          miter_option : BITCODE_RC;
          has_align_start : BITCODE_B;
          bank : BITCODE_B;
          check_intersections : BITCODE_B;
          shsw_b294 : BITCODE_B;
          shsw_b295 : BITCODE_B;
          shsw_b296 : BITCODE_B;
          pt2 : BITCODE_3BD;
        end;
      Dwg_Object_ACSH_SWEEP_CLASS = _dwg_object_ACSH_SWEEP_CLASS;
    { AcDbShPrimitive }
    { AcDbShSweepBase }
    {!< DXF 90  }
    {!< DXF 91  }
    {!< DXF 10  }
    {!< DXF 92  }
    {!< DXF 90  }
    {!< DXF 310  }
    {!< DXF 93  }
    {!< DXF 90  }
    {!< DXF 310  }
    { compare to SWEEPOPTIONS_fields }
    {!< DXF 42 0.0  }
    {!< DXF 43 0.0  }
    {!< DXF 44 0.0  }
    {!< DXF 45 1.0  }
    {!< DXF 48 0.0  }
    {!< DXF 49 0.0  }
    {!< DXF 46 16x  }
    {!< DXF 47 16x  }
    {!< DXF 70 2  }
    {!< DXF 71 2  }
    {!< DXF 290 1  }
    {!< DXF 292 1  }
    {!< DXF 293 0  }
    {!< DXF 294  1  }
    {!< DXF 295  1  }
    {!< DXF 296  1  }
    {!< DXF 11 0,0,0  }
    { AcDbShExtrusion }

      _dwg_object_ACSH_EXTRUSION_CLASS = record
          parent : ^_dwg_object_object;
          evalexpr : Dwg_EvalExpr;
          history_node : Dwg_ACSH_HistoryNode;
          major : BITCODE_BL;
          minor : BITCODE_BL;
          direction : BITCODE_3BD;
          bl92 : BITCODE_BL;
          shsw_text_size : BITCODE_BL;
          shsw_text : BITCODE_TF;
          shsw_bl93 : BITCODE_BL;
          shsw_text2_size : BITCODE_BL;
          shsw_text2 : BITCODE_TF;
          draft_angle : BITCODE_BD;
          start_draft_dist : BITCODE_BD;
          end_draft_dist : BITCODE_BD;
          scale_factor : BITCODE_BD;
          twist_angle : BITCODE_BD;
          align_angle : BITCODE_BD;
          sweepentity_transform : ^BITCODE_BD;
          pathentity_transform : ^BITCODE_BD;
          align_option : BITCODE_RC;
          miter_option : BITCODE_RC;
          has_align_start : BITCODE_B;
          bank : BITCODE_B;
          check_intersections : BITCODE_B;
          shsw_b294 : BITCODE_B;
          shsw_b295 : BITCODE_B;
          shsw_b296 : BITCODE_B;
          pt2 : BITCODE_3BD;
        end;
      Dwg_Object_ACSH_EXTRUSION_CLASS = _dwg_object_ACSH_EXTRUSION_CLASS;
    { AcDbShPrimitive }
    { AcDbShLoft }
    {!< DXF 90  }
    {!< DXF 91  }
    {!< DXF 92  }
    {!< DXF 95  }

      _dwg_object_ACSH_LOFT_CLASS = record
          parent : ^_dwg_object_object;
          evalexpr : Dwg_EvalExpr;
          history_node : Dwg_ACSH_HistoryNode;
          major : BITCODE_BL;
          minor : BITCODE_BL;
          num_crosssects : BITCODE_BL;
          crosssects : ^BITCODE_H;
          num_guides : BITCODE_BL;
          guides : ^BITCODE_H;
        end;
      Dwg_Object_ACSH_LOFT_CLASS = _dwg_object_ACSH_LOFT_CLASS;
    { AcDbShPrimitive }
    { AcDbShFillet }
    {!< DXF 90  }
    {!< DXF 91  }
    {!< DXF 92  }
    {!< DXF 93  }
    {!< DXF 94  }
    {!< DXF 95  }
    {!< DXF 96  }
    {!< DXF 97  }
    {!< DXF 41  }
    {!< DXF 42  }
    {!< DXF 43  }

      _dwg_object_ACSH_FILLET_CLASS = record
          parent : ^_dwg_object_object;
          evalexpr : Dwg_EvalExpr;
          history_node : Dwg_ACSH_HistoryNode;
          major : BITCODE_BL;
          minor : BITCODE_BL;
          bl92 : BITCODE_BL;
          num_edges : BITCODE_BL;
          edges : ^BITCODE_BL;
          num_radiuses : BITCODE_BL;
          num_startsetbacks : BITCODE_BL;
          num_endsetbacks : BITCODE_BL;
          radiuses : ^BITCODE_BD;
          startsetbacks : ^BITCODE_BD;
          endsetbacks : ^BITCODE_BD;
        end;
      Dwg_Object_ACSH_FILLET_CLASS = _dwg_object_ACSH_FILLET_CLASS;
    { AcDbShPrimitive }
    { AcDbShChamfer }
    {!< DXF 90  }
    {!< DXF 91  }
    {!< DXF 92, flat or edge chamfer options?  }
    {!< DXF 41 (left_range?)  }
    {!< DXF 42 (right_range or -1)?  }
    {!< DXF 93  }
    {!< DXF 94  }
    {!< DXF 95 probably our nodeid  }

      _dwg_object_ACSH_CHAMFER_CLASS = record
          parent : ^_dwg_object_object;
          evalexpr : Dwg_EvalExpr;
          history_node : Dwg_ACSH_HistoryNode;
          major : BITCODE_BL;
          minor : BITCODE_BL;
          bl92 : BITCODE_BL;
          base_dist : BITCODE_BD;
          other_dist : BITCODE_BD;
          num_edges : BITCODE_BL;
          edges : ^BITCODE_BL;
          bl95 : BITCODE_BL;
        end;
      Dwg_Object_ACSH_CHAMFER_CLASS = _dwg_object_ACSH_CHAMFER_CLASS;
    { AcDbShPrimitive }
    { AcDbShCylinder }
    {!< DXF 90  }
    {!< DXF 91  }
    {!< DXF 40  }
    {!< DXF 41  }
    {!< DXF 42  }
    {!< DXF 43  }

      _dwg_object_ACSH_CYLINDER_CLASS = record
          parent : ^_dwg_object_object;
          evalexpr : Dwg_EvalExpr;
          history_node : Dwg_ACSH_HistoryNode;
          major : BITCODE_BL;
          minor : BITCODE_BL;
          height : BITCODE_BD;
          major_radius : BITCODE_BD;
          minor_radius : BITCODE_BD;
          x_radius : BITCODE_BD;
        end;
      Dwg_Object_ACSH_CYLINDER_CLASS = _dwg_object_ACSH_CYLINDER_CLASS;
    { AcDbShPrimitive }
    { AcDbShCone }
    {!< DXF 90  }
    {!< DXF 91  }
    {!< DXF 40  }
    {!< DXF 41  }
    {!< DXF 42  }
    {!< DXF 43  }

      _dwg_object_ACSH_CONE_CLASS = record
          parent : ^_dwg_object_object;
          evalexpr : Dwg_EvalExpr;
          history_node : Dwg_ACSH_HistoryNode;
          major : BITCODE_BL;
          minor : BITCODE_BL;
          height : BITCODE_BD;
          major_radius : BITCODE_BD;
          minor_radius : BITCODE_BD;
          x_radius : BITCODE_BD;
        end;
      Dwg_Object_ACSH_CONE_CLASS = _dwg_object_ACSH_CONE_CLASS;
    { AcDbShPrimitive }
    { AcDbShPyramid }
    {!< DXF 90  }
    {!< DXF 91  }
    {!< DXF 40  }
    {!< DXF 92  }
    {!< DXF 41  }
    {!< DXF 42  }

      _dwg_object_ACSH_PYRAMID_CLASS = record
          parent : ^_dwg_object_object;
          evalexpr : Dwg_EvalExpr;
          history_node : Dwg_ACSH_HistoryNode;
          major : BITCODE_BL;
          minor : BITCODE_BL;
          height : BITCODE_BD;
          sides : BITCODE_BL;
          radius : BITCODE_BD;
          topradius : BITCODE_BD;
        end;
      Dwg_Object_ACSH_PYRAMID_CLASS = _dwg_object_ACSH_PYRAMID_CLASS;
    { AcDbShPrimitive }
    { AcDbShTorus }
    {!< DXF 90  }
    {!< DXF 91  }
    {!< DXF 40  }

      _dwg_object_ACSH_SPHERE_CLASS = record
          parent : ^_dwg_object_object;
          evalexpr : Dwg_EvalExpr;
          history_node : Dwg_ACSH_HistoryNode;
          major : BITCODE_BL;
          minor : BITCODE_BL;
          radius : BITCODE_BD;
        end;
      Dwg_Object_ACSH_SPHERE_CLASS = _dwg_object_ACSH_SPHERE_CLASS;
    { AcDbShPrimitive }
    { AcDbShTorus }
    {!< DXF 90  }
    {!< DXF 91  }
    {!< DXF 40  }
    {!< DXF 41  }

      _dwg_object_ACSH_TORUS_CLASS = record
          parent : ^_dwg_object_object;
          evalexpr : Dwg_EvalExpr;
          history_node : Dwg_ACSH_HistoryNode;
          major : BITCODE_BL;
          minor : BITCODE_BL;
          major_radius : BITCODE_BD;
          minor_radius : BITCODE_BD;
        end;
      Dwg_Object_ACSH_TORUS_CLASS = _dwg_object_ACSH_TORUS_CLASS;
    { AcDbShPrimitive }
    { AcDbShRevolve? }
    {!< DXF 90  }
    {!< DXF 91  }
    {!< DXF 10  }
    {!< DXF 11  }
    {!< DXF 40  }
    {!< DXF 41  }
    {!< DXF 43  }
    {!< DXF 44  }
    {!< DXF 45  }
    {!< DXF 46  }
    {!< DXF 290  }
    {!< DXF 291  }

      _dwg_object_ACSH_REVOLVE_CLASS = record
          parent : ^_dwg_object_object;
          evalexpr : Dwg_EvalExpr;
          history_node : Dwg_ACSH_HistoryNode;
          major : BITCODE_BL;
          minor : BITCODE_BL;
          axis_pt : BITCODE_3BD;
          direction : BITCODE_2RD;
          revolve_angle : BITCODE_BD;
          start_angle : BITCODE_BD;
          draft_angle : BITCODE_BD;
          bd44 : BITCODE_BD;
          bd45 : BITCODE_BD;
          twist_angle : BITCODE_BD;
          b290 : BITCODE_B;
          is_close_to_axis : BITCODE_B;
          sweep_entity : BITCODE_H;
        end;
      Dwg_Object_ACSH_REVOLVE_CLASS = _dwg_object_ACSH_REVOLVE_CLASS;
    { called COORDINATION_MODEL in the DXF docs }
    { AcDbNavisworksModel }
    {!< DXF 70  }
    {!< DXF 340  }
    {!< DXF 40  }
    {!< DXF 40  }

      _dwg_entity_NAVISWORKSMODEL = record
          parent : ^_dwg_object_entity;
          flags : BITCODE_BS;
          definition : BITCODE_H;
          transmatrix : ^BITCODE_BD;
          unitfactor : BITCODE_BD;
        end;
      Dwg_Entity_NAVISWORKSMODEL = _dwg_entity_NAVISWORKSMODEL;
    { AcDbNavisworksModelDef }
    {!< DXF 70  }
    {!< DXF 1  }
    {!< DXF 290  }
    {!< DXF 10  }
    {!< DXF 11  }
    {!< DXF 290  }

      _dwg_object_NAVISWORKSMODELDEF = record
          parent : ^_dwg_object_object;
          flags : BITCODE_BS;
          path : BITCODE_T;
          status : BITCODE_B;
          min_extent : BITCODE_3BD;
          max_extent : BITCODE_3BD;
          host_drawing_visibility : BITCODE_B;
        end;
      Dwg_Object_NAVISWORKSMODELDEF = _dwg_object_NAVISWORKSMODELDEF;

      {$define RENDERSETTINGS_fields:=(*AcDbRenderSettings*)class_version:BITCODE_BL;(*!< DXF 90, default: 1*)name:BITCODE_T;(*!< DXF 1*)fog_enabled:BITCODE_B;(*!< DXF 290*)fog_background_enabled:BITCODE_B;(*!< DXF 290*)backfaces_enabled:BITCODE_B;(*!< DXF 290*)environ_image_enabled:BITCODE_B;(*!< DXF 290*)environ_image_filename:BITCODE_T;(*!< DXF 1*)description:BITCODE_T;(*!< DXF 1*)display_index:BITCODE_BL;(*!< DXF 290*)has_predefined:BITCODE_B(*!< DXF 290, r2013 only*)}

    {*
     Class RENDERSETTINGS (varies)
      }
      _dwg_object_RENDERSETTINGS = record
          parent:^_dwg_object_object;
          RENDERSETTINGS_fields;
        end;
      Dwg_Object_RENDERSETTINGS = _dwg_object_RENDERSETTINGS;

    {*
     Class MENTALRAYRENDERSETTINGS (varies)
     Unstable
      }
    { AcDbMentalRayRenderSettings }
    {!< DXF 90, always 2  }
    {!< DXF 90  }
    {!< DXF 90  }
    {!< DXF 70  }
    {!< DXF 40  }
    {!< DXF 40  }
    {!< DXF 40  }
    {!< DXF 40  }
    {!< DXF 40  }
    {!< DXF 40  }
    {!< DXF 70  }
    {!< DXF 290  }
    {!< DXF 290  }
    {!< DXF 90  }
    {!< DXF 90  }
    {!< DXF 90  }
    {!< DXF 290  }
    {!< DXF 90  }
    {!< DXF 290  }
    {!< DXF 40  }
    {!< DXF 90  }
    {!< DXF 90  }
    {!< DXF 90  }
    {!< DXF 90  }
    {!< DXF 290  }
    {!< DXF 90  }
    {!< DXF 290  }
    {!< DXF 290  }
    {!< DXF 290  }
    {!< DXF 40  }
    {!< DXF 40  }
    {!< DXF 40  }
    {!< DXF 70  }
    {!< DXF 70  }
    {!< DXF 40  }
    {!< DXF 70  }
    {!< DXF 70  }
    {!< DXF 290  }
    {!< DXF 1  }
    {!< DXF 90  }
    {!< DXF 70  }
    {!< DXF 90  }
    {!< DXF 290  }
    {!< DXF 40  }

      _dwg_object_MENTALRAYRENDERSETTINGS = record
          parent : ^_dwg_object_object;
          RENDERSETTINGS_fields;
          mr_version : BITCODE_BL;
          sampling1 : BITCODE_BL;
          sampling2 : BITCODE_BL;
          sampling_mr_filter : BITCODE_BS;
          sampling_filter1 : BITCODE_BD;
          sampling_filter2 : BITCODE_BD;
          sampling_contrast_color1 : BITCODE_BD;
          sampling_contrast_color2 : BITCODE_BD;
          sampling_contrast_color3 : BITCODE_BD;
          sampling_contrast_color4 : BITCODE_BD;
          shadow_mode : BITCODE_BS;
          shadow_maps_enabled : BITCODE_B;
          ray_tracing_enabled : BITCODE_B;
          ray_trace_depth1 : BITCODE_BL;
          ray_trace_depth2 : BITCODE_BL;
          ray_trace_depth3 : BITCODE_BL;
          global_illumination_enabled : BITCODE_B;
          gi_sample_count : BITCODE_BL;
          gi_sample_radius_enabled : BITCODE_B;
          gi_sample_radius : BITCODE_BD;
          gi_photons_per_light : BITCODE_BL;
          photon_trace_depth1 : BITCODE_BL;
          photon_trace_depth2 : BITCODE_BL;
          photon_trace_depth3 : BITCODE_BL;
          final_gathering_enabled : BITCODE_B;
          fg_ray_count : BITCODE_BL;
          fg_sample_radius_state1 : BITCODE_B;
          fg_sample_radius_state2 : BITCODE_B;
          fg_sample_radius_state3 : BITCODE_B;
          fg_sample_radius1 : BITCODE_BD;
          fg_sample_radius2 : BITCODE_BD;
          light_luminance_scale : BITCODE_BD;
          diagnostics_mode : BITCODE_BS;
          diagnostics_grid_mode : BITCODE_BS;
          diagnostics_grid_float : BITCODE_BD;
          diagnostics_photon_mode : BITCODE_BS;
          diagnostics_bsp_mode : BITCODE_BS;
          export_mi_enabled : BITCODE_B;
          mr_description : BITCODE_T;
          tile_size : BITCODE_BL;
          tile_order : BITCODE_BS;
          memory_limit : BITCODE_BL;
          diagnostics_samples_mode : BITCODE_B;
          energy_multiplier : BITCODE_BD;
        end;
      Dwg_Object_MENTALRAYRENDERSETTINGS = _dwg_object_MENTALRAYRENDERSETTINGS;
    {*
     Class RAPIDRTRENDERSETTINGS (varies)
      }
    { AcDbRapidRTRenderSettings }
    {!< DXF 90  }
    {!< DXF 70  }
    {!< DXF 90  }
    {!< DXF 90  }
    {!< DXF 70  }
    {!< DXF 70  }
    {!< DXF 40  }
    {!< DXF 40  }

      _dwg_object_RAPIDRTRENDERSETTINGS = record
          parent : ^_dwg_object_object;
          RENDERSETTINGS_fields;
          rapidrt_version : BITCODE_BL;
          render_target : BITCODE_BL;
          render_level : BITCODE_BL;
          render_time : BITCODE_BL;
          lighting_model : BITCODE_BL;
          filter_type : BITCODE_BL;
          filter_width : BITCODE_BD;
          filter_height : BITCODE_BD;
        end;
      Dwg_Object_RAPIDRTRENDERSETTINGS = _dwg_object_RAPIDRTRENDERSETTINGS;
    {*
     Class RENDERENVIRONMENT (varies)
      }
    {!< DXF 90, default: 1  }
    {!< DXF 290  }
    {!< DXF 290  }
    {!< DXF 280  }
    {!< DXF 40  }
    {!< DXF 40  }
    {!< DXF 40  }
    {!< DXF 40  }
    {!< DXF 290  }
    {!< DXF 1  }

      _dwg_object_RENDERENVIRONMENT = record
          parent : ^_dwg_object_object;
          class_version : BITCODE_BL;
          fog_enabled : BITCODE_B;
          fog_background_enabled : BITCODE_B;
          fog_color : BITCODE_CMC;
          fog_density_near : BITCODE_BD;
          fog_density_far : BITCODE_BD;
          fog_distance_near : BITCODE_BD;
          fog_distance_far : BITCODE_BD;
          environ_image_enabled : BITCODE_B;
          environ_image_filename : BITCODE_T;
        end;
      Dwg_Object_RENDERENVIRONMENT = _dwg_object_RENDERENVIRONMENT;
    {*
     Class RENDERGLOBAL (varies)
      }
    {!< DXF 90  }
    {!< DXF 90  }
    {!< DXF 90  }
    {!< DXF 290  }
    {!< DXF 1  }
    {!< DXF 90  }
    {!< DXF 90  }
    {!< DXF 290  }
    {!< DXF 290  }

      _dwg_object_RENDERGLOBAL = record
          parent : ^_dwg_object_object;
          class_version : BITCODE_BL;
          _procedure : BITCODE_BL;
          destination : BITCODE_BL;
          save_enabled : BITCODE_B;
          save_filename : BITCODE_T;
          image_width : BITCODE_BL;
          image_height : BITCODE_BL;
          predef_presets_first : BITCODE_B;
          highlevel_info : BITCODE_B;
        end;
      Dwg_Object_RENDERGLOBAL = _dwg_object_RENDERGLOBAL;
    {*
     Class RENDERENTRY (varies)
      }
    {!< DXF 90  }
    {!< DXF 1  }
    {!< DXF 1  }
    {!< DXF 1  }
    {!< DXF 90  }
    {!< DXF 90  }
    {!< DXF 70  }
    {!< DXF 70  }
    {!< DXF 70  }
    {!< DXF 70  }
    {!< DXF 70  }
    {!< DXF 70  }
    {!< DXF 40  }
    {!< DXF 90  }
    {!< DXF 90  }
    {!< DXF 90  }
    {!< DXF 90  }
    {!< DXF 90  }

      _dwg_object_RENDERENTRY = record
          parent : ^_dwg_object_object;
          class_version : BITCODE_BL;
          image_file_name : BITCODE_T;
          preset_name : BITCODE_T;
          view_name : BITCODE_T;
          dimension_x : BITCODE_BL;
          dimension_y : BITCODE_BL;
          start_year : BITCODE_BS;
          start_month : BITCODE_BS;
          start_day : BITCODE_BS;
          start_minute : BITCODE_BS;
          start_second : BITCODE_BS;
          start_msec : BITCODE_BS;
          render_time : BITCODE_BD;
          memory_amount : BITCODE_BL;
          material_count : BITCODE_BL;
          light_count : BITCODE_BL;
          triangle_count : BITCODE_BL;
          display_index : BITCODE_BL;
        end;
      Dwg_Object_RENDERENTRY = _dwg_object_RENDERENTRY;
    {*
     Class MOTIONPATH (varies)
     Maybe all the Camera paths are under ACAD_NAMEDPATH, but there's also ACAD_MOTION
      }
    { AcDbMotionPath }
    {!< DXF 90, default: 1  }
    {!< DXF 340  }
    {!< DXF 340  }
    {!< DXF 340  }
    {!< DXF 90  number of frames? default 30  }
    {!< DXF 90  per second, default 30  }
    {!< DXF 290  }

      _dwg_object_MOTIONPATH = record
          parent : ^_dwg_object_object;
          class_version : BITCODE_BS;
          camera_path : BITCODE_H;
          target_path : BITCODE_H;
          viewtable : BITCODE_H;
          frames : BITCODE_BS;
          frame_rate : BITCODE_BS;
          corner_decel : BITCODE_B;
        end;
      Dwg_Object_MOTIONPATH = _dwg_object_MOTIONPATH;
    {*
     Class ACDBCURVEPATH (varies)
      }
    { AcDbCurvePath, child of AcDbNamedPath }
    {!< DXF 90, default: 1  }
    {!< DXF 340  }

      _dwg_object_CURVEPATH = record
          parent : ^_dwg_object_object;
          class_version : BITCODE_BS;
          entity : BITCODE_H;
        end;
      Dwg_Object_CURVEPATH = _dwg_object_CURVEPATH;
    {*
     Class ACDBPOINTPATH (varies)
      }
    { AcDbPointPath, child of AcDbNamedPath }
    {!< DXF 90, default: 1  }
    {!< DXF 10  }

      _dwg_object_POINTPATH = record
          parent : ^_dwg_object_object;
          class_version : BITCODE_BS;
          point : BITCODE_3BD;
        end;
      Dwg_Object_POINTPATH = _dwg_object_POINTPATH;
    { not in DXF }
    { 1: double_buffer, 2: blocks_cache, 4: multithreaded, 8: sw_hlr
                           16: discard_backfaces, 32: ttf_cache, 64: dyn_subenthlt, 128: force_partial_update
                           256: clear_screen, 512: use_visual_styles (bit 9) 1024: use_overlay_buffers,
                           2048: scene_graph, 4096: composite_meta_files, ??: create_gl_context (bit 13)
                           delay_scenegraphproc (bit 14),
                         }
    { ver > 3 }
    {ver 2 or >4: }

      _dwg_object_TVDEVICEPROPERTIES = record
          parent : ^_dwg_object_object;
          flags : BITCODE_BL;
          max_regen_threads : BITCODE_BS;
          use_lut_palette : BITCODE_BL;
          alt_hlt : BITCODE_BLL;
          alt_hltcolor : BITCODE_BLL;
          geom_shader_usage : BITCODE_BLL;
          blending_mode : BITCODE_BL;
          antialiasing_level : BITCODE_BD;
          bd2 : BITCODE_BD;
        end;
      Dwg_Object_TVDEVICEPROPERTIES = _dwg_object_TVDEVICEPROPERTIES;
    {!< DXF 90, default 1  }
    {!< DXF 340  }

      _dwg_object_SKYLIGHT_BACKGROUND = record
          parent : ^_dwg_object_object;
          class_version : BITCODE_BL;
          sunid : BITCODE_H;
        end;
      Dwg_Object_SKYLIGHT_BACKGROUND = _dwg_object_SKYLIGHT_BACKGROUND;
    {!< DXF 90, default 1  }
    {!< DXF 90  }

      _dwg_object_SOLID_BACKGROUND = record
          parent : ^_dwg_object_object;
          class_version : BITCODE_BL;
          color : BITCODE_BLx;
        end;
      Dwg_Object_SOLID_BACKGROUND = _dwg_object_SOLID_BACKGROUND;
    {!< DXF 90, default 1  }
    {!< DXF 300  }
    {!< DXF 290  }
    {!< DXF 291  }
    {!< DXF 292  }
    {!< DXF 140,141  }
    {!< DXF 142,143  }

      _dwg_object_IMAGE_BACKGROUND = record
          parent : ^_dwg_object_object;
          class_version : BITCODE_BL;
          filename : BITCODE_T;
          fit_to_screen : BITCODE_B;
          maintain_aspect_ratio : BITCODE_B;
          use_tiling : BITCODE_B;
          offset : BITCODE_2BD;
          scale : BITCODE_2BD;
        end;
      Dwg_Object_IMAGE_BACKGROUND = _dwg_object_IMAGE_BACKGROUND;
    { Image Based Lightning }
    {!< DXF 90, default 2  }
    {!< DXF 290  }
    {!< DXF 1  }
    {!< DXF 40, normalized -180 +180, in degrees  }
    {!< DXF 290  }
    {!< DXF 340  }

      _dwg_object_IBL_BACKGROUND = record
          parent : ^_dwg_object_object;
          class_version : BITCODE_BL;
          enable : BITCODE_B;
          name : BITCODE_T;
          rotation : BITCODE_BD;
          display_image : BITCODE_B;
          secondary_background : BITCODE_H;
        end;
      Dwg_Object_IBL_BACKGROUND = _dwg_object_IBL_BACKGROUND;
    {!< DXF 90, default 1  }
    {!< DXF 90  }
    {!< DXF 91  }
    {!< DXF 91  }
    {!< DXF 140  }
    {!< DXF 141  }
    {!< DXF 142  }

      _dwg_object_GRADIENT_BACKGROUND = record
          parent : ^_dwg_object_object;
          class_version : BITCODE_BL;
          color_top : BITCODE_BLx;
          color_middle : BITCODE_BLx;
          color_bottom : BITCODE_BLx;
          horizon : BITCODE_BD;
          height : BITCODE_BD;
          rotation : BITCODE_BD;
        end;
      Dwg_Object_GRADIENT_BACKGROUND = _dwg_object_GRADIENT_BACKGROUND;
    {!< DXF 90, default 1  }
    {!< DXF 90  }
    {!< DXF 91  }
    {!< DXF 92  }
    {!< DXF 93  }
    {!< DXF 94 groundplane  }
    {!< DXF 95 groundplane  }

      _dwg_object_GROUND_PLANE_BACKGROUND = record
          parent : ^_dwg_object_object;
          class_version : BITCODE_BL;
          color_sky_zenith : BITCODE_BLx;
          color_sky_horizon : BITCODE_BLx;
          color_underground_horizon : BITCODE_BLx;
          color_underground_azimuth : BITCODE_BLx;
          color_near : BITCODE_BLx;
          color_far : BITCODE_BLx;
        end;
      Dwg_Object_GROUND_PLANE_BACKGROUND = _dwg_object_GROUND_PLANE_BACKGROUND;

    {*
     * Class AcDbAnnotScaleObjectContextData (varies)
     * for MTEXT, TEXT, MLEADER, LEADER, BLKREF, ALDIM (AlignedDimension), MTEXTATTRIBUTE, ...
     * R2010+
     * 20.4.89 SubClass AcDbObjectContextData (varies)
      }
      {$define OBJECTCONTEXTDATA_fields:=parent:^_dwg_object_object;class_version:BITCODE_BS;(*!< r2010+ =4, before 3*)is_default:BITCODE_B(*290*)}

      {$define ANNOTSCALEOBJECTCONTEXTDATA_fields:=OBJECTCONTEXTDATA_fields;scale:BITCODE_H(*!< DXF 340*)}

      _dwg_object_ANNOTSCALEOBJECTCONTEXTDATA = record
          ANNOTSCALEOBJECTCONTEXTDATA_fields;
        end;
      Dwg_Object_ANNOTSCALEOBJECTCONTEXTDATA = _dwg_object_ANNOTSCALEOBJECTCONTEXTDATA;

      _dwg_CONTEXTDATA_dict = record
          parent : ^_dwg_CONTEXTDATA_submgr;
          text : BITCODE_T;
          itemhandle : BITCODE_H;
        end;
      Dwg_CONTEXTDATA_dict = _dwg_CONTEXTDATA_dict;

      _dwg_CONTEXTDATA_submgr = record
          parent : ^_dwg_object_CONTEXTDATAMANAGER;
          handle : BITCODE_H;
          num_entries : BITCODE_BL;
          entries : ^Dwg_CONTEXTDATA_dict;
        end;
      Dwg_CONTEXTDATA_submgr = _dwg_CONTEXTDATA_submgr;
    {*
     * R2010+
     * A special DICTIONARY
      }

      _dwg_object_CONTEXTDATAMANAGER = record
          parent : ^_dwg_object_object;
          objectcontext : BITCODE_H;
          num_submgrs : BITCODE_BL;
          submgrs : ^Dwg_CONTEXTDATA_submgr;
        end;
      Dwg_Object_CONTEXTDATAMANAGER = _dwg_object_CONTEXTDATAMANAGER;


      {$define TEXTOBJECTCONTEXTDATA_fields:=horizontal_mode:BITCODE_BS;(*<! DXF 70, default 0*)rotation:BITCODE_BD;(*!< DXF 50, default 0.0 or 90.0*)ins_pt:BITCODE_2RD;(*!< DXF 10-20*)alignment_pt:BITCODE_2RD(*!< DXF 11-21*)}

    {*
     * R2010+
      }
      _dwg_object_TEXTOBJECTCONTEXTDATA = record
          ANNOTSCALEOBJECTCONTEXTDATA_fields;
          TEXTOBJECTCONTEXTDATA_fields;
        end;
      Dwg_Object_TEXTOBJECTCONTEXTDATA = _dwg_object_TEXTOBJECTCONTEXTDATA;

    {*
     * R2010+
      }
    {<! DXF 70  }
    {!< DXF 10  }
    {!< DXF 11  }
    {!< DXF 40  }
    {!< DXF 41  }
    {!< DXF 42  }
    {!< DXF 43  }
    {!< DXF 71 0: none, 1: static, 2: dynamic. Note: BS in MTEXT!  }
    {!< DXF 44  }
    {!< DXF 45  }
    {!< DXF 73  }
    {!< DXF 74  }
    {!< DXF 72 or numfragments  }
    {!< DXF 46 if dynamic and not auto_height  }

      _dwg_object_MTEXTOBJECTCONTEXTDATA = record
          ANNOTSCALEOBJECTCONTEXTDATA_fields;
          attachment : BITCODE_BL;
          ins_pt : BITCODE_3BD;
          x_axis_dir : BITCODE_3BD;
          rect_height : BITCODE_BD;
          rect_width : BITCODE_BD;
          extents_width : BITCODE_BD;
          extents_height : BITCODE_BD;
          column_type : BITCODE_BL;
          column_width : BITCODE_BD;
          gutter : BITCODE_BD;
          auto_height : BITCODE_B;
          flow_reversed : BITCODE_B;
          num_column_heights : BITCODE_BL;
          column_heights : ^BITCODE_BD;
        end;
      Dwg_Object_MTEXTOBJECTCONTEXTDATA = _dwg_object_MTEXTOBJECTCONTEXTDATA;
    { subclass AcDbDimensionObjectContextData }
    {!< DXF 293  }
    {!< DXF 10-30  }
    {<! DXF 294 if def_pt is default  }
    {!< DXF 140  }
    {!< DXF 2  }
    {!< DXF 298  }
    {!< DXF 291  }
    {!< DXF 70   }
    {!< DXF 292  }
    {!< DXF 71   }
    {!< DXF 280  }
    {!< DXF 295  }
    {!< DXF 296  }
    {!< DXF 297  }

      _dwg_OCD_Dimension = record
          b293 : BITCODE_B;
          def_pt : BITCODE_2RD;
          is_def_textloc : BITCODE_B;
          text_rotation : BITCODE_BD;
          block : BITCODE_H;
          dimtofl : BITCODE_B;
          dimosxd : BITCODE_B;
          dimatfit : BITCODE_B;
          dimtix : BITCODE_B;
          dimtmove : BITCODE_B;
          override_code : BITCODE_RC;
          has_arrow2 : BITCODE_B;
          flip_arrow2 : BITCODE_B;
          flip_arrow1 : BITCODE_B;
        end;
      Dwg_OCD_Dimension = _dwg_OCD_Dimension;
    {*
     * for ALDIM (AlignedDimension)
     * R2010+
      }
    { AcDbAlignedDimensionObjectContextData }
    {!< DXF 11-31  }

      _dwg_object_ALDIMOBJECTCONTEXTDATA = record
          ANNOTSCALEOBJECTCONTEXTDATA_fields;
          dimension : Dwg_OCD_Dimension;
          dimline_pt : BITCODE_3BD;
        end;
      Dwg_Object_ALDIMOBJECTCONTEXTDATA = _dwg_object_ALDIMOBJECTCONTEXTDATA;
    {*
     * for ANGDIM (AngularDimension)
     * R2010+
      }
    { AcDbAngularDimensionObjectContextData }
    {!< DXF 11-31  }

      _dwg_object_ANGDIMOBJECTCONTEXTDATA = record
          ANNOTSCALEOBJECTCONTEXTDATA_fields;
          dimension : Dwg_OCD_Dimension;
          arc_pt : BITCODE_3BD;
        end;
      Dwg_Object_ANGDIMOBJECTCONTEXTDATA = _dwg_object_ANGDIMOBJECTCONTEXTDATA;
    {*
     * for DMDIM (DiametricDimension)
     * R2010+
      }
    { AcDbDiametricDimensionObjectContextData }
    {!< DXF 11-31  }
    {!< DXF 12-32  }

      _dwg_object_DMDIMOBJECTCONTEXTDATA = record
          ANNOTSCALEOBJECTCONTEXTDATA_fields;
          dimension : Dwg_OCD_Dimension;
          first_arc_pt : BITCODE_3BD;
          def_pt : BITCODE_3BD;
        end;
      Dwg_Object_DMDIMOBJECTCONTEXTDATA = _dwg_object_DMDIMOBJECTCONTEXTDATA;
    {*
     * for ORDDIM (OrdinateDimension)
     * R2010+
      }
    { AcDbOrdinateDimensionObjectContextData }
    {!< DXF 11-31 = origin  }
    {!< DXF 12-32  }

      _dwg_object_ORDDIMOBJECTCONTEXTDATA = record
          ANNOTSCALEOBJECTCONTEXTDATA_fields;
          dimension : Dwg_OCD_Dimension;
          feature_location_pt : BITCODE_3BD;
          leader_endpt : BITCODE_3BD;
        end;
      Dwg_Object_ORDDIMOBJECTCONTEXTDATA = _dwg_object_ORDDIMOBJECTCONTEXTDATA;
    {*
     * for RADIM (Radial Dimension)
     * R2010+
      }
    { AcDbRadialDimensionObjectContextData }
    {!< DXF 11-31  }

      _dwg_object_RADIMOBJECTCONTEXTDATA = record
          ANNOTSCALEOBJECTCONTEXTDATA_fields;
          dimension : Dwg_OCD_Dimension;
          first_arc_pt : BITCODE_3BD;
        end;
      Dwg_Object_RADIMOBJECTCONTEXTDATA = _dwg_object_RADIMOBJECTCONTEXTDATA;
    {*
     * for RADIMLG (Large Radial Dimension)
     * R2010+
      }
    { AcDbRadialDimensionLargeObjectContextData }
    {!< DXF 12-32  }
    {!< DXF 13-33  }

      _dwg_object_RADIMLGOBJECTCONTEXTDATA = record
          ANNOTSCALEOBJECTCONTEXTDATA_fields;
          dimension : Dwg_OCD_Dimension;
          ovr_center : BITCODE_3BD;
          jog_point : BITCODE_3BD;
        end;
      Dwg_Object_RADIMLGOBJECTCONTEXTDATA = _dwg_object_RADIMLGOBJECTCONTEXTDATA;

    { MTEXTATTR }

      _dwg_object_MTEXTATTRIBUTEOBJECTCONTEXTDATA = record
          ANNOTSCALEOBJECTCONTEXTDATA_fields;
          TEXTOBJECTCONTEXTDATA_fields;
          enable_context : BITCODE_B;
          context : ^_dwg_object;
        end;
      Dwg_Object_MTEXTATTRIBUTEOBJECTCONTEXTDATA = _dwg_object_MTEXTATTRIBUTEOBJECTCONTEXTDATA;

    { ...?? }

      _dwg_object_MLEADEROBJECTCONTEXTDATA = record
          ANNOTSCALEOBJECTCONTEXTDATA_fields;
        end;
      Dwg_Object_MLEADEROBJECTCONTEXTDATA = _dwg_object_MLEADEROBJECTCONTEXTDATA;

    {< DXF 70  }
    {!< DXF 10  }
    {!< DXF 290  }
    {!< DXF 11  }
    {!< DXF 12  }
    {!< DXF 13  }

      _dwg_object_LEADEROBJECTCONTEXTDATA = record
          ANNOTSCALEOBJECTCONTEXTDATA_fields;
          num_points : BITCODE_BL;
          points : ^BITCODE_3DPOINT;
          b290 : BITCODE_B;
          x_direction : BITCODE_3DPOINT;
          inspt_offset : BITCODE_3DPOINT;
          endptproj : BITCODE_3DPOINT;
        end;
      Dwg_Object_LEADEROBJECTCONTEXTDATA = _dwg_object_LEADEROBJECTCONTEXTDATA;

    { 50  }
    { 10  }
    { 42-44  }

      _dwg_object_BLKREFOBJECTCONTEXTDATA = record
          ANNOTSCALEOBJECTCONTEXTDATA_fields;
          rotation : BITCODE_BD;
          ins_pt : BITCODE_3BD;
          scale_factor : BITCODE_3BD;
        end;
      Dwg_Object_BLKREFOBJECTCONTEXTDATA = _dwg_object_BLKREFOBJECTCONTEXTDATA;

    {!< DXF 10-30  }
    {!< DXF 11-31  }

      _dwg_object_FCFOBJECTCONTEXTDATA = record
          ANNOTSCALEOBJECTCONTEXTDATA_fields;
          location : BITCODE_3BD;
          horiz_dir : BITCODE_3BD;
        end;
      Dwg_Object_FCFOBJECTCONTEXTDATA = _dwg_object_FCFOBJECTCONTEXTDATA;
    { AcDbModelDocViewStyle }
    {!< DXF 70 0  }
    { DXF 90. 1: cannot_rename  }
    { AcDbDetailViewStyle }
    {!< DXF 70 0  }

      _dwg_object_DETAILVIEWSTYLE = record
          parent : ^_dwg_object_object;
          mdoc_class_version : BITCODE_BS;
          desc : BITCODE_T;
          is_modified_for_recompute : BITCODE_B;
          display_name : BITCODE_T;
          viewstyle_flags : BITCODE_BL;
          class_version : BITCODE_BS;
          flags : BITCODE_BL;
          identifier_style : BITCODE_H;
          identifier_color : BITCODE_CMC;
          identifier_height : BITCODE_BD;
          identifier_exclude_characters : BITCODE_T;
          identifier_offset : BITCODE_BD;
          identifier_placement : BITCODE_RC;
          arrow_symbol : BITCODE_H;
          arrow_symbol_color : BITCODE_CMC;
          arrow_symbol_size : BITCODE_BD;
          boundary_ltype : BITCODE_H;
          boundary_linewt : BITCODE_BLd;
          boundary_line_color : BITCODE_CMC;
          viewlabel_text_style : BITCODE_H;
          viewlabel_text_color : BITCODE_CMC;
          viewlabel_text_height : BITCODE_BD;
          viewlabel_attachment : BITCODE_BL;
          viewlabel_offset : BITCODE_BD;
          viewlabel_alignment : BITCODE_BL;
          viewlabel_pattern : BITCODE_T;
          connection_ltype : BITCODE_H;
          connection_linewt : BITCODE_BLd;
          connection_line_color : BITCODE_CMC;
          borderline_ltype : BITCODE_H;
          borderline_linewt : BITCODE_BLd;
          borderline_color : BITCODE_CMC;
          model_edge : BITCODE_RC;
        end;
      Dwg_Object_DETAILVIEWSTYLE = _dwg_object_DETAILVIEWSTYLE;
    { AcDbModelDocViewStyle }
    {!< DXF 70 0  }
    { DXF 90. 1: cannot_rename  }
    { AcDbSectionViewStyle }
    {!< DXF 70 0  }
    { DXF 90. 1: cont_labeling, 2: show_arrowheads, 4: show_viewlabel, 
                           8: show_allplanelines, 0x10: show_allbendids, 0x20 show_end+bendlines
                           0x40: show_hatch ...  }
    { see flags: }
    {BITCODE_B is_continuous_labeling; }
    {BITCODE_B show_arrowheads; }
    {BITCODE_B show_viewlabel; }
    {BITCODE_B show_end_and_bend_lines; }
    {BITCODE_B show_hatching; }

      _dwg_object_SECTIONVIEWSTYLE = record
          parent : ^_dwg_object_object;
          mdoc_class_version : BITCODE_BS;
          desc : BITCODE_T;
          is_modified_for_recompute : BITCODE_B;
          display_name : BITCODE_T;
          viewstyle_flags : BITCODE_BL;
          class_version : BITCODE_BS;
          flags : BITCODE_BL;
          identifier_style : BITCODE_H;
          identifier_color : BITCODE_CMC;
          identifier_height : BITCODE_BD;
          arrow_start_symbol : BITCODE_H;
          arrow_end_symbol : BITCODE_H;
          arrow_symbol_color : BITCODE_CMC;
          arrow_symbol_size : BITCODE_BD;
          identifier_exclude_characters : BITCODE_T;
          identifier_position : BITCODE_BLd;
          identifier_offset : BITCODE_BD;
          arrow_position : BITCODE_BLd;
          arrow_symbol_extension_length : BITCODE_BD;
          plane_ltype : BITCODE_H;
          plane_linewt : BITCODE_BLd;
          plane_line_color : BITCODE_CMC;
          bend_ltype : BITCODE_H;
          bend_linewt : BITCODE_BLd;
          bend_line_color : BITCODE_CMC;
          bend_line_length : BITCODE_BD;
          end_line_overshoot : BITCODE_BD;
          end_line_length : BITCODE_BD;
          viewlabel_text_style : BITCODE_H;
          viewlabel_text_color : BITCODE_CMC;
          viewlabel_text_height : BITCODE_BD;
          viewlabel_attachment : BITCODE_BL;
          viewlabel_offset : BITCODE_BD;
          viewlabel_alignment : BITCODE_BL;
          viewlabel_pattern : BITCODE_T;
          hatch_color : BITCODE_CMC;
          hatch_bg_color : BITCODE_CMC;
          hatch_pattern : BITCODE_T;
          hatch_scale : BITCODE_BD;
          hatch_transparency : BITCODE_BLd;
          unknown_b1 : BITCODE_B;
          unknown_b2 : BITCODE_B;
          num_hatch_angles : BITCODE_BL;
          hatch_angles : ^BITCODE_BD;
        end;
      Dwg_Object_SECTIONVIEWSTYLE = _dwg_object_SECTIONVIEWSTYLE;
    {!< DXF 70  }
    {!< DXF 90  }
    {!< DXF 330  }

      _dwg_object_SECTION_MANAGER = record
          parent : ^_dwg_object_object;
          is_live : BITCODE_B;
          num_sections : BITCODE_BS;
          sections : ^BITCODE_H;
        end;
      Dwg_Object_SECTION_MANAGER = _dwg_object_SECTION_MANAGER;
    { DXF 90  }
    { DXF 91  }
    { DXF 92. 2: hatchvisible, 4: is_hiddenline, 8: has_division_lines  }
    { DXF 62  }
    { DXF 8 Default: 0  }
    { DXF 6 Default: Continuous  }
    { DXF 40  }
    { DXF 1 Default: ByColor  }
    { DXF 370  }
    { DXF 70  }
    { DXF 71  }
    { DXF 72  }
    { DXF 2  }
    { DXF 41  }
    { DXF 42  }
    { DXF 43  }

      _dwg_SECTION_geometrysettings = record
          parent : ^_dwg_SECTION_typesettings;
          num_geoms : BITCODE_BL;
          hexindex : BITCODE_BL;
          flags : BITCODE_BL;
          color : BITCODE_CMC;
          layer : BITCODE_T;
          ltype : BITCODE_T;
          ltype_scale : BITCODE_BD;
          plotstyle : BITCODE_T;
          linewt : BITCODE_BLd;
          face_transparency : BITCODE_BS;
          edge_transparency : BITCODE_BS;
          hatch_type : BITCODE_BS;
          hatch_pattern : BITCODE_T;
          hatch_angle : BITCODE_BD;
          hatch_spacing : BITCODE_BD;
          hatch_scale : BITCODE_BD;
        end;
      Dwg_SECTION_geometrysettings = _dwg_SECTION_geometrysettings;
    {!< DXF 90: type: live=1, 2d=2, 3d=4  }
    {!< DXF 91: source and destination flags.
                                         sourceall=1, sourceselected=2.
                                         destnewblock=16, destreplaceblock=32, destfile=64
                                      }
    { or geometry: intersectionboundary=1, intersectionfill=2, fg_geom=4, bg_geom=8
                      curvetangencylines=16  }

      _dwg_SECTION_typesettings = record
          parent : ^_dwg_object_SECTION_SETTINGS;
          _type : BITCODE_BS;
          generation : BITCODE_BS;
          num_sources : BITCODE_BL;
          sources : ^BITCODE_H;
          destblock : BITCODE_H;
          destfile : BITCODE_T;
          num_geom : BITCODE_BL;
          geom : ^Dwg_SECTION_geometrysettings;
        end;
      Dwg_SECTION_typesettings = _dwg_SECTION_typesettings;
    { Unstable }
    { DXF 90  }
    { DXF 91  }

      _dwg_object_SECTION_SETTINGS = record
          parent : ^_dwg_object_object;
          curr_type : BITCODE_BS;
          num_types : BITCODE_BL;
          types : ^Dwg_SECTION_typesettings;
        end;
      Dwg_Object_SECTION_SETTINGS = _dwg_object_SECTION_SETTINGS;

      _dwg_object_LAYERFILTER = record
          parent : ^_dwg_object_object;
          num_names : BITCODE_BL;
          names : ^BITCODE_T;
        end;
      Dwg_Object_LAYERFILTER = _dwg_object_LAYERFILTER;
    {!< DXF 42  }
    {!< DXF 41  }
    {!< DXF 43  }
    {!< DXF 7  }
    {!< DXF 2  }
    {!< DXF 3  }
    {!< DXF 1  }
    {!< DXF 44  }
    {!< DXF 45  }
    {!< DXF 46  }
    {!< DXF 10  }
    {!< DXF 40  }
    {!< DXF 50  }
    {!< DXF 51  }
    {!< DXF 210  }
    {!< DXF 90  }
    {!< DXF 70  }
    {!< DXF 71  }
    {!< DXF 72  }
    {!< DXF 73  }
    {!< DXF 74  }
    {!< DXF 75  }
    {!< DXF 76  }
    {!< DXF 77  }
    {!< DXF 78  }
    {!< DXF 79  }
    {!< DXF 280  }
    {!< DXF 330  }

      _dwg_entity_ARCALIGNEDTEXT = record
          parent : ^_dwg_object_entity;
          text_size : BITCODE_D2T;
          xscale : BITCODE_D2T;
          char_spacing : BITCODE_D2T;
          style : BITCODE_T;
          t2 : BITCODE_T;
          t3 : BITCODE_T;
          text_value : BITCODE_T;
          offset_from_arc : BITCODE_D2T;
          right_offset : BITCODE_D2T;
          left_offset : BITCODE_D2T;
          center : BITCODE_3BD;
          radius : BITCODE_BD;
          start_angle : BITCODE_BD;
          end_angle : BITCODE_BD;
          extrusion : BITCODE_3BD;
          color : BITCODE_BL;
          is_reverse : BITCODE_BS;
          text_direction : BITCODE_BS;
          alignment : BITCODE_BS;
          text_position : BITCODE_BS;
          font_19 : BITCODE_BS;
          bs2 : BITCODE_BS;
          is_underlined : BITCODE_BS;
          bs1 : BITCODE_BS;
          font : BITCODE_BS;
          is_shx : BITCODE_BS;
          wizard_flag : BITCODE_BS;
          arc_handle : BITCODE_H;
        end;
      Dwg_Entity_ARCALIGNEDTEXT = _dwg_entity_ARCALIGNEDTEXT;
    { Remote Text with external src or Diesel expr }
    {!< DXF 10  }
    {!< DXF 210  }
    {!< DXF 50  }
    {!< DXF 50  }
    {!< DXF 70  }
    {!< DXF 1  }
    {!< DXF 7  }

      _dwg_entity_RTEXT = record
          parent : ^_dwg_object_entity;
          pt : BITCODE_3BD;
          extrusion : BITCODE_BE;
          rotation : BITCODE_BD;
          height : BITCODE_BD;
          flags : BITCODE_BS;
          text_value : BITCODE_T;
          style : BITCODE_H;
        end;
      Dwg_Entity_RTEXT = _dwg_entity_RTEXT;
    { 2  }
    { ... }
    {!< DXF 93 0  }

      _dwg_object_LAYOUTPRINTCONFIG = record
          parent : ^_dwg_object_object;
          class_version : BITCODE_BS;
          flag : BITCODE_BS;
        end;
      Dwg_Object_LAYOUTPRINTCONFIG = _dwg_object_LAYOUTPRINTCONFIG;
    {? }

      _dwg_object_ACMECOMMANDHISTORY = record
          parent : ^_dwg_object_object;
          class_version : BITCODE_BS;
        end;
      Dwg_Object_ACMECOMMANDHISTORY = _dwg_object_ACMECOMMANDHISTORY;
    {? }

      _dwg_object_ACMESCOPE = record
          parent : ^_dwg_object_object;
          class_version : BITCODE_BS;
        end;
      Dwg_Object_ACMESCOPE = _dwg_object_ACMESCOPE;
    {? }

      _dwg_object_ACMESTATEMGR = record
          parent : ^_dwg_object_object;
          class_version : BITCODE_BS;
        end;
      Dwg_Object_ACMESTATEMGR = _dwg_object_ACMESTATEMGR;
    {? }

      _dwg_object_CSACDOCUMENTOPTIONS = record
          parent : ^_dwg_object_object;
          class_version : BITCODE_BS;
        end;
      Dwg_Object_CSACDOCUMENTOPTIONS = _dwg_object_CSACDOCUMENTOPTIONS;
    { dynamic blocks: }

    {$define BLOCKELEMENT_fields:=evalexpr:Dwg_EvalExpr;name:BITCODE_T;be_major:BITCODE_BL;be_minor:BITCODE_BL;eed1071:BITCODE_BL}

    {$define BLOCKPARAMETER_fields:=BLOCKELEMENT_fields;show_properties:BITCODE_B;(*DXF 280*)chain_actions:BITCODE_B(*DXF 281*)}

    {$define BLOCKACTION_fields:=BLOCKELEMENT_fields;display_location:BITCODE_3BD;num_actions:BITCODE_BL;actions:^BITCODE_BL;num_deps:BITCODE_BL;deps:^BITCODE_H}

    // XY action params
    {$define BLOCKACTION_doubles_fields:=action_offset_x:BITCODE_BD;action_offset_y:BITCODE_BD;angle_offset:BITCODE_BD}

    {$define BLOCKGRIP_fields:=BLOCKELEMENT_fields;bg_bl91:BITCODE_BL;bg_bl92:BITCODE_BL;bg_location:BITCODE_3BD;bg_insert_cycling:BITCODE_B;bg_insert_cycling_weight:BITCODE_BLd}


      // same as BLOCKACTION_connectionpts
      _dwg_BLOCKPARAMETER_connection = record
          code:BITCODE_BL;
          name:BITCODE_T;
        end;
      Dwg_BLOCKPARAMETER_connection = _dwg_BLOCKPARAMETER_connection;

      _dwg_BLOCKPARAMETER_PropInfo = record
          num_connections : BITCODE_BL;
          connections : ^Dwg_BLOCKPARAMETER_connection;
        end;
      Dwg_BLOCKPARAMETER_PropInfo = _dwg_BLOCKPARAMETER_PropInfo;

      _dwg_BLOCKPARAMVALUESET = record
          desc : BITCODE_T;
          flags : BITCODE_BL;
          minimum : BITCODE_BD;
          maximum : BITCODE_BD;
          increment : BITCODE_BD;
          num_valuelist : BITCODE_BS;
          valuelist : ^BITCODE_BD;
        end;
      Dwg_BLOCKPARAMVALUESET = _dwg_BLOCKPARAMVALUESET;

      {$define BLOCK1PTPARAMETER_fields:=BLOCKPARAMETER_fields;def_pt:BITCODE_3BD;num_propinfos:BITCODE_BL;(*2*)prop1:Dwg_BLOCKPARAMETER_PropInfo;prop2:Dwg_BLOCKPARAMETER_PropInfo}

      {$define BLOCK2PTPARAMETER_fields:=BLOCKPARAMETER_fields;def_basept:BITCODE_3BD;def_endpt:BITCODE_3BD;prop1:Dwg_BLOCKPARAMETER_PropInfo;prop2:Dwg_BLOCKPARAMETER_PropInfo;prop3:Dwg_BLOCKPARAMETER_PropInfo;prop4:Dwg_BLOCKPARAMETER_PropInfo;prop_states:^BITCODE_BL;parameter_base_location:BITCODE_BS;upd_basept:BITCODE_3BD;basept:BITCODE_3BD;upd_endpt:BITCODE_3BD;endpt:BITCODE_3BD}

      _dwg_BLOCKACTION_connectionpts = record
          code:BITCODE_BL;
          name:BITCODE_T;
        end;
      Dwg_BLOCKACTION_connectionpts = _dwg_BLOCKACTION_connectionpts;

      {define ANum:=10}
      {$define BLOCKACTION_WITHBASEPT_fields:=BLOCKACTION_fields;offset:BITCODE_3BD;conn_pts:array [0..ANum-1] of Dwg_BLOCKACTION_connectionpts;dependent:BITCODE_B;base_pt:BITCODE_3BD}
        {BITCODE_3BD stretch_pt}
      {undef ANum}

      {$define BLOCKPARAMVALUESET_fields:=value_set:Dwg_BLOCKPARAMVALUESET}

      {$define BLOCKCONSTRAINTPARAMETER_fields:=BLOCK2PTPARAMETER_fields;dependency:BITCODE_H}

      {$define BLOCKLINEARCONSTRAINTPARAMETER_fields:=BLOCKCONSTRAINTPARAMETER_fields;expr_name:BITCODE_T;expr_description:BITCODE_T;value:BITCODE_BD;BLOCKPARAMVALUESET_fields}


      _dwg_BLOCKVISIBILITYPARAMETER_state = record
          parent:^_dwg_object_BLOCKVISIBILITYPARAMETER;
          name : BITCODE_T;
    { DXF 301  }
          num_blocks : BITCODE_BL;
    { DXF 94  }
          blocks : ^BITCODE_H;
    { DXF 332  }
          num_params : BITCODE_BL;
    { DXF 95  }
          params : ^BITCODE_H;
    { DXF 333 BLOCKVISIBILITYPARAMETER objects  }
        end;
      Dwg_BLOCKVISIBILITYPARAMETER_state = _dwg_BLOCKVISIBILITYPARAMETER_state;

    { DXF 281 }
    { DXF 91, history_compression, history_required or is_visible? }
    { DXF 301 }
    { DXF 302 }
    { DXF 93 }
    { DXF 331 }
    { DXF 92 }
    {BITCODE_T cur_state_name; }
    {BITCODE_BL cur_state; }
      _dwg_object_BLOCKVISIBILITYPARAMETER = record
          parent : ^_dwg_object_object;
          BLOCK1PTPARAMETER_fields;
          is_initialized : BITCODE_B;
          unknown_bool : BITCODE_B;
          blockvisi_name : BITCODE_T;
          blockvisi_desc : BITCODE_T;
          num_blocks : BITCODE_BL;
          blocks : ^BITCODE_H;
          num_states : BITCODE_BL;
          states : ^Dwg_BLOCKVISIBILITYPARAMETER_state;
        end;
      Dwg_Object_BLOCKVISIBILITYPARAMETER = _dwg_object_BLOCKVISIBILITYPARAMETER;

    { AcDbBlockVisibilityGrip }

      _dwg_object_BLOCKVISIBILITYGRIP = record
          parent : ^_dwg_object_object;
          BLOCKGRIP_fields;
        end;
      Dwg_Object_BLOCKVISIBILITYGRIP = _dwg_object_BLOCKVISIBILITYGRIP;
    { AcDbBlockGripExpr }
    { one of: X Y UpdatedX UpdatedY DisplacementX DisplacementY }

      _dwg_object_BLOCKGRIPLOCATIONCOMPONENT = record
          parent : ^_dwg_object_object;
          evalexpr : Dwg_EvalExpr;
          grip_type : BITCODE_BL;
          grip_expr : BITCODE_T;
        end;
      Dwg_Object_BLOCKGRIPLOCATIONCOMPONENT = _dwg_object_BLOCKGRIPLOCATIONCOMPONENT;

      _dwg_object_BREAKDATA = record
          parent : ^_dwg_object_object;
          num_pointrefs : BITCODE_BL;
          pointrefs : ^BITCODE_H;
          dimref : BITCODE_H;
        end;
      Dwg_Object_BREAKDATA = _dwg_object_BREAKDATA;
    { XrefFullSubendPath ?? }

      _dwg_object_BREAKPOINTREF = record
          parent : ^_dwg_object_object;
        end;
      Dwg_Object_BREAKPOINTREF = _dwg_object_BREAKPOINTREF;
    { ?? }

      _dwg_entity_FLIPGRIPENTITY = record
          parent : ^_dwg_object_entity;
        end;
      Dwg_Entity_FLIPGRIPENTITY = _dwg_entity_FLIPGRIPENTITY;
    { ?? }

      _dwg_entity_LINEARGRIPENTITY = record
          parent : ^_dwg_object_entity;
        end;
      Dwg_Entity_LINEARGRIPENTITY = _dwg_entity_LINEARGRIPENTITY;
    { ?? }

      _dwg_entity_POLARGRIPENTITY = record
          parent : ^_dwg_object_entity;
        end;
      Dwg_Entity_POLARGRIPENTITY = _dwg_entity_POLARGRIPENTITY;
    { ?? }

      _dwg_entity_ROTATIONGRIPENTITY = record
          parent : ^_dwg_object_entity;
        end;
      Dwg_Entity_ROTATIONGRIPENTITY = _dwg_entity_ROTATIONGRIPENTITY;
    { ?? }

      _dwg_entity_VISIBILITYGRIPENTITY = record
          parent : ^_dwg_object_entity;
        end;
      Dwg_Entity_VISIBILITYGRIPENTITY = _dwg_entity_VISIBILITYGRIPENTITY;
    { ?? }

      _dwg_entity_XYGRIPENTITY = record
          parent : ^_dwg_object_entity;
        end;
      Dwg_Entity_XYGRIPENTITY = _dwg_entity_XYGRIPENTITY;
    { ?? }

      _dwg_entity_ALIGNMENTPARAMETERENTITY = record
          parent : ^_dwg_object_entity;
        end;
      Dwg_Entity_ALIGNMENTPARAMETERENTITY = _dwg_entity_ALIGNMENTPARAMETERENTITY;
    { ?? }

      _dwg_entity_BASEPOINTPARAMETERENTITY = record
          parent : ^_dwg_object_entity;
        end;
      Dwg_Entity_BASEPOINTPARAMETERENTITY = _dwg_entity_BASEPOINTPARAMETERENTITY;
    { ?? }

      _dwg_entity_FLIPPARAMETERENTITY = record
          parent : ^_dwg_object_entity;
        end;
      Dwg_Entity_FLIPPARAMETERENTITY = _dwg_entity_FLIPPARAMETERENTITY;
    { ?? }

      _dwg_entity_LINEARPARAMETERENTITY = record
          parent : ^_dwg_object_entity;
        end;
      Dwg_Entity_LINEARPARAMETERENTITY = _dwg_entity_LINEARPARAMETERENTITY;
    { ?? }

      _dwg_entity_POINTPARAMETERENTITY = record
          parent : ^_dwg_object_entity;
        end;
      Dwg_Entity_POINTPARAMETERENTITY = _dwg_entity_POINTPARAMETERENTITY;
    { ?? }

      _dwg_entity_ROTATIONPARAMETERENTITY = record
          parent : ^_dwg_object_entity;
        end;
      Dwg_Entity_ROTATIONPARAMETERENTITY = _dwg_entity_ROTATIONPARAMETERENTITY;
    { ?? }

      _dwg_entity_VISIBILITYPARAMETERENTITY = record
          parent : ^_dwg_object_entity;
        end;
      Dwg_Entity_VISIBILITYPARAMETERENTITY = _dwg_entity_VISIBILITYPARAMETERENTITY;
    { ?? }

      _dwg_entity_XYPARAMETERENTITY = record
          parent : ^_dwg_object_entity;
        end;
      Dwg_Entity_XYPARAMETERENTITY = _dwg_entity_XYPARAMETERENTITY;

      _dwg_object_BLOCKALIGNMENTGRIP = record
          parent : ^_dwg_object_object;
          BLOCKGRIP_fields;
          orientation : BITCODE_3BD;
        end;
      Dwg_Object_BLOCKALIGNMENTGRIP = _dwg_object_BLOCKALIGNMENTGRIP;

    { DXF 280  }

      _dwg_object_BLOCKALIGNMENTPARAMETER = record
          parent : ^_dwg_object_object;
          BLOCK2PTPARAMETER_fields;
          align_perpendicular : BITCODE_B;
        end;
      Dwg_Object_BLOCKALIGNMENTPARAMETER = _dwg_object_BLOCKALIGNMENTPARAMETER;

    { DXF 1011  }
    { DXF 1012  }
    { DXF 305  }
    { DXF 306  }
    { DXF 140, offset is the result  }
    { DXF 280  }
      _dwg_object_BLOCKANGULARCONSTRAINTPARAMETER = record
          parent : ^_dwg_object_object;
          BLOCKCONSTRAINTPARAMETER_fields;
          center_pt : BITCODE_3BD;
          end_pt : BITCODE_3BD;
          expr_name : BITCODE_T;
          expr_description : BITCODE_T;
          angle : BITCODE_BD;
          orientation_on_both_grips : BITCODE_B;
          BLOCKPARAMVALUESET_fields;
        end;
      Dwg_Object_BLOCKANGULARCONSTRAINTPARAMETER = _dwg_object_BLOCKANGULARCONSTRAINTPARAMETER;

    { DXF 305, a copy of the EvalExpr name  }
    { DXF 306  }
    { DXF 140  }
    { DXF 280  }
      _dwg_object_BLOCKDIAMETRICCONSTRAINTPARAMETER = record
          parent : ^_dwg_object_object;
          BLOCKCONSTRAINTPARAMETER_fields;
          expr_name : BITCODE_T;
          expr_description : BITCODE_T;
          distance : BITCODE_BD;
          orientation_on_both_grips : BITCODE_B;
          BLOCKPARAMVALUESET_fields;
        end;
      Dwg_Object_BLOCKDIAMETRICCONSTRAINTPARAMETER = _dwg_object_BLOCKDIAMETRICCONSTRAINTPARAMETER;

    { DXF 305, a copy of the EvalExpr name  }
    { DXF 306  }
    { DXF 140  }

      _dwg_object_BLOCKRADIALCONSTRAINTPARAMETER = record
          parent : ^_dwg_object_object;
          BLOCKCONSTRAINTPARAMETER_fields;
          expr_name : BITCODE_T;
          expr_description : BITCODE_T;
          distance : BITCODE_BD;
          BLOCKPARAMVALUESET_fields;
        end;
      Dwg_Object_BLOCKRADIALCONSTRAINTPARAMETER = _dwg_object_BLOCKRADIALCONSTRAINTPARAMETER;

    {!< DXF 92-95, 301-304  }
    {!< DXF 140  }
    {!< DXF 141  }

      _dwg_object_BLOCKARRAYACTION = record
          parent : ^_dwg_object_object;
          BLOCKACTION_fields;
          conn_pts : array[0..3] of Dwg_BLOCKACTION_connectionpts;
          column_offset : BITCODE_BD;
          row_offset : BITCODE_BD;
        end;
      Dwg_Object_BLOCKARRAYACTION = _dwg_object_BLOCKARRAYACTION;

    { DXF 1011  }
    { DXF 1012  }

      _dwg_object_BLOCKBASEPOINTPARAMETER = record
          parent : ^_dwg_object_object;
          BLOCK1PTPARAMETER_fields;
          pt : BITCODE_3BD;
          base_pt : BITCODE_3BD;
        end;
      Dwg_Object_BLOCKBASEPOINTPARAMETER = _dwg_object_BLOCKBASEPOINTPARAMETER;

    {!< DXF 92-95, 301-304  }
      _dwg_object_BLOCKFLIPACTION = record
          parent : ^_dwg_object_object;
          BLOCKACTION_fields;
          conn_pts : array[0..3] of Dwg_BLOCKACTION_connectionpts;
          BLOCKACTION_doubles_fields;
        end;
      Dwg_Object_BLOCKFLIPACTION = _dwg_object_BLOCKFLIPACTION;

      _dwg_object_BLOCKFLIPGRIP = record
          parent : ^_dwg_object_object;
          BLOCKGRIP_fields;
          combined_state : BITCODE_BL;
          orientation : BITCODE_3BD;
          upd_state : BITCODE_BS;
          state : BITCODE_BS;
        end;
      Dwg_Object_BLOCKFLIPGRIP = _dwg_object_BLOCKFLIPGRIP;

    {!< DXF 305  }
    {!< DXF 306  }
    {!< DXF 307  }
    {!< DXF 308  }
    {!< DXF 1012  }
    {!< DXF 96  }
    {!< DXF 309  }

      _dwg_object_BLOCKFLIPPARAMETER = record
          parent : ^_dwg_object_object;
          BLOCK2PTPARAMETER_fields;
          flip_label : BITCODE_T;
          flip_label_desc : BITCODE_T;
          base_state_label : BITCODE_T;
          flipped_state_label : BITCODE_T;
          def_label_pt : BITCODE_3BD;
          bl96 : BITCODE_BL;
          tooltip : BITCODE_T;
        end;
      Dwg_Object_BLOCKFLIPPARAMETER = _dwg_object_BLOCKFLIPPARAMETER;

      _dwg_object_BLOCKALIGNEDCONSTRAINTPARAMETER = record
          parent : ^_dwg_object_object;
          BLOCKLINEARCONSTRAINTPARAMETER_fields;
        end;
      Dwg_Object_BLOCKALIGNEDCONSTRAINTPARAMETER = _dwg_object_BLOCKALIGNEDCONSTRAINTPARAMETER;

      _dwg_object_BLOCKLINEARCONSTRAINTPARAMETER = record
          parent : ^_dwg_object_object;
          BLOCKLINEARCONSTRAINTPARAMETER_fields;
        end;
      Dwg_Object_BLOCKLINEARCONSTRAINTPARAMETER = _dwg_object_BLOCKLINEARCONSTRAINTPARAMETER;

      _dwg_object_BLOCKHORIZONTALCONSTRAINTPARAMETER = record
          parent : ^_dwg_object_object;
          BLOCKLINEARCONSTRAINTPARAMETER_fields;
        end;
      Dwg_Object_BLOCKHORIZONTALCONSTRAINTPARAMETER = _dwg_object_BLOCKHORIZONTALCONSTRAINTPARAMETER;

      _dwg_object_BLOCKVERTICALCONSTRAINTPARAMETER = record
          parent : ^_dwg_object_object;
          BLOCKLINEARCONSTRAINTPARAMETER_fields;
        end;
      Dwg_Object_BLOCKVERTICALCONSTRAINTPARAMETER = _dwg_object_BLOCKVERTICALCONSTRAINTPARAMETER;

    { DXF 140,141,142  }

      _dwg_object_BLOCKLINEARGRIP = record
          parent : ^_dwg_object_object;
          BLOCKGRIP_fields;
          orientation : BITCODE_3BD;
        end;
      Dwg_Object_BLOCKLINEARGRIP = _dwg_object_BLOCKLINEARGRIP;

    {!< DXF 305  }
    {!< DXF 306  }
    {!< DXF 306  }
      _dwg_object_BLOCKLINEARPARAMETER = record
          parent : ^_dwg_object_object;
          BLOCK2PTPARAMETER_fields;
          distance_name : BITCODE_T;
          distance_desc : BITCODE_T;
          distance : BITCODE_BD;
          BLOCKPARAMVALUESET_fields;
        end;
      Dwg_Object_BLOCKLINEARPARAMETER = _dwg_object_BLOCKLINEARPARAMETER;
    {!< DXF 94-96, 303-305 }

      _dwg_BLOCKLOOKUPACTION_lut = record
          parent : ^_dwg_object_BLOCKLOOKUPACTION;
          conn_pts : array[0..2] of Dwg_BLOCKACTION_connectionpts;
          b282 : BITCODE_B;
          b281 : BITCODE_B;
        end;
      Dwg_BLOCKLOOKUPACTION_lut = _dwg_BLOCKLOOKUPACTION_lut;

    { computed  }
    { DXF 92  }
    { DXF 93  }

      _dwg_object_BLOCKLOOKUPACTION = record
          parent : ^_dwg_object_object;
          BLOCKACTION_fields;
          numelems : BITCODE_BL;
          numrows : BITCODE_BL;
          numcols : BITCODE_BL;
          lut : ^Dwg_BLOCKLOOKUPACTION_lut;
          exprs : ^BITCODE_T;
          b280 : BITCODE_B;
        end;
      Dwg_Object_BLOCKLOOKUPACTION = _dwg_object_BLOCKLOOKUPACTION;


      _dwg_object_BLOCKLOOKUPGRIP = record
          parent : ^_dwg_object_object;
          BLOCKGRIP_fields;
        end;
      Dwg_Object_BLOCKLOOKUPGRIP = _dwg_object_BLOCKLOOKUPGRIP;

    {!< DXF 303  }
    {!< DXF 304  }
    {!< DXF 94 ??  }

      _dwg_object_BLOCKLOOKUPPARAMETER = record
          parent : ^_dwg_object_object;
          BLOCK1PTPARAMETER_fields;
          lookup_name : BITCODE_T;
          lookup_desc : BITCODE_T;
          index : BITCODE_BL;
          unknown_t : BITCODE_T;
        end;
      Dwg_Object_BLOCKLOOKUPPARAMETER = _dwg_object_BLOCKLOOKUPPARAMETER;

    {!< DXF 92-93, 301-302  }
      _dwg_object_BLOCKMOVEACTION = record
          parent : ^_dwg_object_object;
          BLOCKACTION_fields;
          conn_pts : array[0..1] of Dwg_BLOCKACTION_connectionpts;
          BLOCKACTION_doubles_fields;
        end;
      Dwg_Object_BLOCKMOVEACTION = _dwg_object_BLOCKMOVEACTION;

    { DXF 303  }
    { DXF 304  }
    { DXF 1011  }
      _dwg_object_BLOCKPOINTPARAMETER = record
          parent : ^_dwg_object_object;
          BLOCK1PTPARAMETER_fields;
          position_name : BITCODE_T;
          position_desc : BITCODE_T;
          def_label_pt : BITCODE_3BD;
        end;
      Dwg_Object_BLOCKPOINTPARAMETER = _dwg_object_BLOCKPOINTPARAMETER;

      _dwg_object_BLOCKPOLARGRIP = record
          parent : ^_dwg_object_object;
          BLOCKGRIP_fields;
        end;
      Dwg_Object_BLOCKPOLARGRIP = _dwg_object_BLOCKPOLARGRIP;

    {!< DXF 305  }
    {!< DXF 306  }
    {!< DXF 305  }
    {!< DXF 306  }
    {!< DXF 140  }
    {BITCODE_3BD base_angle_pt; }
      _dwg_object_BLOCKPOLARPARAMETER = record
          parent : ^_dwg_object_object;
          BLOCK2PTPARAMETER_fields;
          angle_name : BITCODE_T;
          angle_desc : BITCODE_T;
          distance_name : BITCODE_T;
          distance_desc : BITCODE_T;
          offset : BITCODE_BD;
          angle_value_set : Dwg_BLOCKPARAMVALUESET;
          distance_value_set : Dwg_BLOCKPARAMVALUESET;
        end;
      Dwg_Object_BLOCKPOLARPARAMETER = _dwg_object_BLOCKPOLARPARAMETER;

    {!< DXF 92-97, 301-306  }
    { 72 }
    { 10 }
    { 72 }
    { 331 }
    { 74 }
    { 75 }
    { 76 }
    { ?? }

      _dwg_object_BLOCKPOLARSTRETCHACTION = record
          parent : ^_dwg_object_object;
          BLOCKACTION_fields;
          conn_pts : array[0..5] of Dwg_BLOCKACTION_connectionpts;
          num_pts : BITCODE_BL;
          pts : ^BITCODE_2RD;
          num_hdls : BITCODE_BL;
          hdls : ^BITCODE_H;
          shorts : ^BITCODE_BS;
          num_codes : BITCODE_BL;
          codes : ^BITCODE_BL;
        end;
      Dwg_Object_BLOCKPOLARSTRETCHACTION = _dwg_object_BLOCKPOLARSTRETCHACTION;
    { ?? }

      _dwg_object_BLOCKPROPERTIESTABLE = record
          parent : ^_dwg_object_object;
        end;
      Dwg_Object_BLOCKPROPERTIESTABLE = _dwg_object_BLOCKPROPERTIESTABLE;

      _dwg_object_BLOCKPROPERTIESTABLEGRIP = record
          parent : ^_dwg_object_object;
          BLOCKGRIP_fields;
        end;
      Dwg_Object_BLOCKPROPERTIESTABLEGRIP = _dwg_object_BLOCKPROPERTIESTABLEGRIP;

      _dwg_object_BLOCKREPRESENTATION = record
          parent : ^_dwg_object_object;
          flag : BITCODE_BS;
          block : BITCODE_H;
        end;
      Dwg_Object_BLOCKREPRESENTATION = _dwg_object_BLOCKREPRESENTATION;

      {$define ANum:=3}
      _dwg_object_BLOCKROTATEACTION = record
          parent : ^_dwg_object_object;
          BLOCKACTION_WITHBASEPT_fields;
        end;
      Dwg_Object_BLOCKROTATEACTION = _dwg_object_BLOCKROTATEACTION;
      {$undef ANum}

      _dwg_object_BLOCKROTATIONGRIP = record
          parent : ^_dwg_object_object;
          BLOCKGRIP_fields;
        end;
      Dwg_Object_BLOCKROTATIONGRIP = _dwg_object_BLOCKROTATIONGRIP;

    {!< DXF 305  }
    {!< DXF 306  }
    {!< DXF 306  }
    {BITCODE_3BD base_angle_pt; }

      _dwg_object_BLOCKROTATIONPARAMETER = record
          parent : ^_dwg_object_object;
          BLOCK2PTPARAMETER_fields;
          def_base_angle_pt : BITCODE_3BD;
          angle_name : BITCODE_T;
          angle_desc : BITCODE_T;
          angle : BITCODE_BD;
          angle_value_set : Dwg_BLOCKPARAMVALUESET;
        end;
      Dwg_Object_BLOCKROTATIONPARAMETER = _dwg_object_BLOCKROTATIONPARAMETER;

      {$define ANum:=5}
      _dwg_object_BLOCKSCALEACTION = record
          parent : ^_dwg_object_object;
          BLOCKACTION_WITHBASEPT_fields
        end;
      Dwg_Object_BLOCKSCALEACTION = _dwg_object_BLOCKSCALEACTION;
      {$undef ANum}

    {!< DXF 92-93, 301-302  }
    { 72 }
    { 10 }
    { 72 }
    { 331 }
    { 74 }
    { 75 }
    { 76 }
    { ?? }
      _dwg_object_BLOCKSTRETCHACTION = record
          parent : ^_dwg_object_object;
          BLOCKACTION_fields;
          conn_pts : array[0..1] of Dwg_BLOCKACTION_connectionpts;
          num_pts : BITCODE_BL;
          pts : ^BITCODE_2RD;
          num_hdls : BITCODE_BL;
          hdls : ^BITCODE_H;
          shorts : ^BITCODE_BS;
          num_codes : BITCODE_BL;
          codes : ^BITCODE_BL;
          BLOCKACTION_doubles_fields;
        end;
      Dwg_Object_BLOCKSTRETCHACTION = _dwg_object_BLOCKSTRETCHACTION;

    {!< DXF 90  }
    {!< DXF 305  }
    {!< DXF 301  }
    {!< DXF 170 (already value.code)?  }

      _dwg_object_BLOCKUSERPARAMETER = record
          parent : ^_dwg_object_object;
          BLOCK1PTPARAMETER_fields;
          flag : BITCODE_BS;
          assocvariable : BITCODE_H;
          expr : BITCODE_T;
          value : Dwg_EvalVariant;
          _type : BITCODE_BS;
        end;
      Dwg_Object_BLOCKUSERPARAMETER = _dwg_object_BLOCKUSERPARAMETER;

      _dwg_object_BLOCKXYGRIP = record
          parent : ^_dwg_object_object;
          BLOCKGRIP_fields;
        end;
      Dwg_Object_BLOCKXYGRIP = _dwg_object_BLOCKXYGRIP;

    { DXF 305 }
    { DXF 306 }
    { DXF 307 }
    { DXF 308 }
    { DXF 141 }
    { DXF 142 }

      _dwg_object_BLOCKXYPARAMETER = record
          parent : ^_dwg_object_object;
          BLOCK2PTPARAMETER_fields;
          x_label : BITCODE_T;
          x_label_desc : BITCODE_T;
          y_label : BITCODE_T;
          y_label_desc : BITCODE_T;
          x_value : BITCODE_BD;
          y_value : BITCODE_BD;
          x_value_set : Dwg_BLOCKPARAMVALUESET;
          y_value_set : Dwg_BLOCKPARAMVALUESET;
        end;
      Dwg_Object_BLOCKXYPARAMETER = _dwg_object_BLOCKXYPARAMETER;
    { ?? }

      _dwg_object_DYNAMICBLOCKPROXYNODE = record
          parent : ^_dwg_object_object;
          evalexpr : Dwg_EvalExpr;
        end;
      Dwg_Object_DYNAMICBLOCKPROXYNODE = _dwg_object_DYNAMICBLOCKPROXYNODE;
    { DXF 40  }
    { DXF 41  }
    { DXF 42  }
    { DXF 43  }

      _dwg_POINTCLOUD_IntensityStyle = record
          parent : ^_dwg_entity_POINTCLOUD;
          min_intensity : BITCODE_BD;
          max_intensity : BITCODE_BD;
          intensity_low_treshold : BITCODE_BD;
          intensity_high_treshold : BITCODE_BD;
        end;
      Dwg_POINTCLOUD_IntensityStyle = _dwg_POINTCLOUD_IntensityStyle;

      _dwg_POINTCLOUD_Clippings = record
          parent : ^_dwg_entity_POINTCLOUD;
          is_inverted : BITCODE_B;
          _type : BITCODE_BS;
          num_vertices : BITCODE_BL;
          vertices : ^BITCODE_2RD;
          z_min : BITCODE_BD;
          z_max : BITCODE_BD;
        end;
      Dwg_POINTCLOUD_Clippings = _dwg_POINTCLOUD_Clippings;

      _dwg_POINTCLOUDEX_Croppings = record
          parent : ^_dwg_entity_POINTCLOUDEX;
          _type : BITCODE_BS;
          is_inside : BITCODE_B;
          is_inverted : BITCODE_B;
          crop_plane : BITCODE_3BD;
          crop_x_dir : BITCODE_3BD;
          crop_y_dir : BITCODE_3BD;
          num_pts : BITCODE_BL;
          pts : ^BITCODE_3BD;
        end;
      Dwg_POINTCLOUDEX_Croppings = _dwg_POINTCLOUDEX_Croppings;
    { 1 or 2 r2013+, DXF 70 }
    {!< DXF 10  }
    { DXF 1  }
    { DXF 90  }
    {!< DXF 2  }
    {!< DXF 11  }
    {!< DXF 12  }
    {!< DXF 92  }
    {!< DXF 3  }
    {!< DXF 13  }
    {!< DXF 210  }
    {!< DXF 211  }
    {!< DXF 212  }
    { r2013+: }
    {!< DXF 330  }
    {!< DXF 360  }
    {!< DXF ?  }
    {!< DXF 71  }
    {!< DXF ?  }
    {!< DXF ?  }

      _dwg_entity_POINTCLOUD = record
          parent : ^_dwg_object_entity;
          class_version : BITCODE_BS;
          origin : BITCODE_3BD;
          saved_filename : BITCODE_T;
          num_source_files : BITCODE_BL;
          source_files : ^BITCODE_T;
          extents_min : BITCODE_3BD;
          extents_max : BITCODE_3BD;
          numpoints : BITCODE_RLL;
          ucs_name : BITCODE_T;
          ucs_origin : BITCODE_3BD;
          ucs_x_dir : BITCODE_3BD;
          ucs_y_dir : BITCODE_3BD;
          ucs_z_dir : BITCODE_3BD;
          pointclouddef : BITCODE_H;
          reactor : BITCODE_H;
          show_intensity : BITCODE_B;
          intensity_scheme : BITCODE_BS;
          intensity_style : Dwg_POINTCLOUD_IntensityStyle;
          show_clipping : BITCODE_B;
          num_clippings : BITCODE_BL;
          clippings : ^Dwg_POINTCLOUD_Clippings;
        end;
      Dwg_Entity_POINTCLOUD = _dwg_entity_POINTCLOUD;
    { 1, DXF 70 }
    {!< DXF 10  }
    {!< DXF 11  }
    {!< DXF 13  }
    {!< DXF 210  }
    {!< DXF 211  }
    {!< DXF 212  }
    {!< DXF 290  }
    {!< DXF 330  }
    {!< DXF 360  }
    { DXF 1  }
    {!< DXF 291  }
    {!< DXF 71  }
    {!< ? DXF 1  }
    {!< DXF 1  }
    {!< ? DXF 1  }
    { DXF 40  }
    { DXF 41  }
    { DXF 90  }
    { DXF 91  }
    { DXF 70  }
    { DXF 71  }
    { DXF 292  }
    { DXF 293  }
    { DXF 294  }
    {!< DXF 295  }
    {!< ? DXF 93  }
    {!< ? DXF 93  }
    {!< DXF 92  }

      _dwg_entity_POINTCLOUDEX = record
          parent : ^_dwg_object_entity;
          class_version : BITCODE_BS;
          extents_min : BITCODE_3BD;
          extents_max : BITCODE_3BD;
          ucs_origin : BITCODE_3BD;
          ucs_x_dir : BITCODE_3BD;
          ucs_y_dir : BITCODE_3BD;
          ucs_z_dir : BITCODE_3BD;
          is_locked : BITCODE_B;
          pointclouddefex : BITCODE_H;
          reactor : BITCODE_H;
          name : BITCODE_T;
          show_intensity : BITCODE_B;
          stylization_type : BITCODE_BS;
          intensity_colorscheme : BITCODE_T;
          cur_colorscheme : BITCODE_T;
          classification_colorscheme : BITCODE_T;
          elevation_min : BITCODE_BD;
          elevation_max : BITCODE_BD;
          intensity_min : BITCODE_BL;
          intensity_max : BITCODE_BL;
          intensity_out_of_range_behavior : BITCODE_BS;
          elevation_out_of_range_behavior : BITCODE_BS;
          elevation_apply_to_fixed_range : BITCODE_B;
          intensity_as_gradient : BITCODE_B;
          elevation_as_gradient : BITCODE_B;
          show_cropping : BITCODE_B;
          unknown_bl0 : BITCODE_BL;
          unknown_bl1 : BITCODE_BL;
          num_croppings : BITCODE_BL;
          croppings : ^Dwg_POINTCLOUDEX_Croppings;
        end;
      Dwg_Entity_POINTCLOUDEX = _dwg_entity_POINTCLOUDEX;
    { 1 or 2 r2013+, DXF 90 }
    { DXF 1  }
    { DXF 280  }
    {!< DXF 91 (hi) + 92 (lo) / 160  }
    {!< DXF 10  }
    {!< DXF 11  }

      _dwg_object_POINTCLOUDDEF = record
          parent : ^_dwg_object_object;
          class_version : BITCODE_BL;
          source_filename : BITCODE_T;
          is_loaded : BITCODE_B;
          numpoints : BITCODE_RLL;
          extents_min : BITCODE_3BD;
          extents_max : BITCODE_3BD;
        end;
      Dwg_Object_POINTCLOUDDEF = _dwg_object_POINTCLOUDDEF;
    { 1 or 2 r2013+, DXF 90 }
    { DXF 1  }
    { DXF 280  }
    {!< DXF 169  }
    {!< DXF 10  }
    {!< DXF 11  }

      _dwg_object_POINTCLOUDDEFEX = record
          parent : ^_dwg_object_object;
          class_version : BITCODE_BL;
          source_filename : BITCODE_T;
          is_loaded : BITCODE_B;
          numpoints : BITCODE_RLL;
          extents_min : BITCODE_3BD;
          extents_max : BITCODE_3BD;
        end;
      Dwg_Object_POINTCLOUDDEFEX = _dwg_object_POINTCLOUDDEFEX;
    { 1 }

      _dwg_object_POINTCLOUDDEF_REACTOR = record
          parent : ^_dwg_object_object;
          class_version : BITCODE_BL;
        end;
      Dwg_Object_POINTCLOUDDEF_REACTOR = _dwg_object_POINTCLOUDDEF_REACTOR;
    { 1 }

      _dwg_object_POINTCLOUDDEF_REACTOR_EX = record
          parent : ^_dwg_object_object;
          class_version : BITCODE_BL;
        end;
      Dwg_Object_POINTCLOUDDEF_REACTOR_EX = _dwg_object_POINTCLOUDDEF_REACTOR_EX;
    { FIXME either }
    { DXF 1 }
    {/ or }
    { DXF 91 }
    { DXF 290 }

      _dwg_ColorRamp = record
          parent : ^_dwg_POINTCLOUDCOLORMAP_Ramp;
          colorscheme : BITCODE_T;
          unknown_bl : BITCODE_BL;
          unknown_b : BITCODE_B;
        end;
      Dwg_ColorRamp = _dwg_ColorRamp;
    { DXF 70: 1 }
    { DXF 90 }

      _dwg_POINTCLOUDCOLORMAP_Ramp = record
          parent : ^_dwg_object_POINTCLOUDCOLORMAP;
          class_version : BITCODE_BS;
          num_ramps : BITCODE_BL;
          ramps : ^Dwg_ColorRamp;
        end;
      Dwg_POINTCLOUDCOLORMAP_Ramp = _dwg_POINTCLOUDCOLORMAP_Ramp;
    {!< DXF 1  }
    {!< DXF 1  }
    {!< DXF 1  }

      _dwg_object_POINTCLOUDCOLORMAP = record
          parent : ^_dwg_object_object;
          class_version : BITCODE_BS;
          def_intensity_colorscheme : BITCODE_T;
          def_elevation_colorscheme : BITCODE_T;
          def_classification_colorscheme : BITCODE_T;
          num_colorramps : BITCODE_BL;
          colorramps : ^Dwg_POINTCLOUDCOLORMAP_Ramp;
          num_classification_colorramps : BITCODE_BL;
          classification_colorramps : ^Dwg_POINTCLOUDCOLORMAP_Ramp;
        end;
      Dwg_Object_POINTCLOUDCOLORMAP = _dwg_object_POINTCLOUDCOLORMAP;
    { unhandled. some subclass }

      _dwg_COMPOUNDOBJECTID = record
          parent : ^_dwg_object_object;
          has_object : BITCODE_B;
          name : BITCODE_T;
          &object : BITCODE_H;
        end;
      Dwg_COMPOUNDOBJECTID = _dwg_COMPOUNDOBJECTID;
    { ODA Arx }
    {typedef Dwg_Object_LAYERFILTER Dwg_Object_PARTIAL_VIEWING_FILTER; }

      _dwg_PARTIAL_VIEWING_INDEX_Entry = record
          parent : ^_dwg_object_PARTIAL_VIEWING_INDEX;
          extents_min : BITCODE_3BD;
          extents_max : BITCODE_3BD;
          &object : BITCODE_H;
        end;
      Dwg_PARTIAL_VIEWING_INDEX_Entry = _dwg_PARTIAL_VIEWING_INDEX_Entry;

      _dwg_object_PARTIAL_VIEWING_INDEX = record
          parent : ^_dwg_object_object;
          num_entries : BITCODE_BL;
          has_entries : BITCODE_B;
          entries : ^Dwg_PARTIAL_VIEWING_INDEX_Entry;
        end;
      Dwg_Object_PARTIAL_VIEWING_INDEX = _dwg_object_PARTIAL_VIEWING_INDEX;
    {*
     -----------------------------------
      }
    {*
     Unknown Class entity, a blob
      }

      _dwg_entity_UNKNOWN_ENT = record
          parent : ^_dwg_object_entity;
        end;
      Dwg_Entity_UNKNOWN_ENT = _dwg_entity_UNKNOWN_ENT;
    {*
     Unknown Class object, a blob
      }

      _dwg_object_UNKNOWN_OBJ = record
          parent : ^_dwg_object_object;
        end;
      Dwg_Object_UNKNOWN_OBJ = _dwg_object_UNKNOWN_OBJ;
    {*
     REPEAT (none/5) entity
      }

      _dwg_entity_REPEAT = record
          parent : ^_dwg_object_entity;
        end;
      Dwg_Entity_REPEAT = _dwg_entity_REPEAT;
    {*
     ENDREP (none/6) entity
      }
    { DXF 70 }
    { DXF 71 }
    { DXF 40 }
    { DXF 41 }

      _dwg_entity_ENDREP = record
          parent : ^_dwg_object_entity;
          num_cols : BITCODE_RS;
          num_rows : BITCODE_RS;
          col_spacing : BITCODE_RD;
          row_spacing : BITCODE_RD;
        end;
      Dwg_Entity_ENDREP = _dwg_entity_ENDREP;
    {*
     LOAD (none/10) entity
      }

      _dwg_entity_LOAD = record
          parent : ^_dwg_object_entity;
          file_name : BITCODE_TV;
        end;
      Dwg_Entity_LOAD = _dwg_entity_LOAD;
    {*
     3DLINE (none/21) entity
      }
    { DXF 10|20|30 }
    { DXF 11|21|31 }
    { DXF 210 }
    { DXF 39 }

      _dwg_entity_3DLINE = record
          parent : ^_dwg_object_entity;
          start : BITCODE_3RD;
          &end : BITCODE_3RD;
          extrusion : BITCODE_3RD;
          thickness : BITCODE_RD;
        end;
      Dwg_Entity__3DLINE = _dwg_entity_3DLINE;
    { OBJECTS - END *********************************************************** }
    {*
     Extended entity data: dxf group - value pairs, similar to xdata
      }
(** unsupported pragma#pragma pack(1)*)
    { 0 (1000) string  }
    { RC  }
    { RS_LE  }
    { inlined  }
    { R2007+ 0 (1000) string  }
    { inlined  }
    { 1 (1001) handle, not in data  }
    { set the eed[0].handle to the used APPID instead }
    { 2 (1002) "" => 0 open, or "" => 1 close  }
    { 3 (1003) layer (8-byte handle value)  }
    { 4 (1004) binary  }
    { inlined }
    { 5 (1005) entity  }
    { 10-13 point  }
    { 40-42 real  }
    { 70 short int  }
    { 71 long int  }

      _dwg_entity_eed_data = record
          code : BITCODE_RC;
          u : record
              case longint of
                0 : ( eed_0 : record
                    length : BITCODE_RS;
                    flag0 : word;
                    _string : array[0..0] of char;
                  end );
                1 : ( eed_0_r2007 : record
                    length : BITCODE_RS;
                    flag0 : word;
                    _string : array[0..0] of DWGCHAR;
                  end );
                2 : ( eed_1 : record
                    invalid : array[0..0] of char;
                  end );
                3 : ( eed_2 : record
                    close : BITCODE_RC;
                  end );
                4 : ( eed_3 : record
                    layer : BITCODE_RLL;
                  end );
                5 : ( eed_4 : record
                    length : BITCODE_RC;
                    data : array[0..0] of byte;
                  end );
                6 : ( eed_5 : record
                    entity : dword;
                  end );
                7 : ( eed_10 : record
                    point : BITCODE_3RD;
                  end );
                8 : ( eed_40 : record
                    real : BITCODE_RD;
                  end );
                9 : ( eed_70 : record
                    rs : BITCODE_RS;
                  end );
                10 : ( eed_71 : record
                    rl : BITCODE_RL;
                  end );
              end;
        end;
      Dwg_Eed_Data = _dwg_entity_eed_data;

(** unsupported pragma#pragma pack()*)
    {*
     Extended entity data
      }
    { a binary copy of the data  }

      _dwg_entity_eed = record
          size : BITCODE_BS;
          handle : Dwg_Handle;
          data : ^Dwg_Eed_Data;
          raw : BITCODE_TF;
        end;
      Dwg_Eed = _dwg_entity_eed;
(* error 
enum {
    { 16 }
    { 128 }
in declaration at line 8044 *)
(* error 
enum {
    { 1 }
    { 2 }
    { 4 }
    { 8 }
in declaration at line 8055 *)
    {*
     Common entity attributes
      }
    {!< link to the parent  }
    { Start auto-generated entity-union. Do not touch.  }
    { untyped > 500  }
    { unstable  }
    { debugging  }
    { End auto-generated entity-union  }
    { see also Dwg_Resbuf* xdata  }
    { Common Entity Data  }
    { calculated  }
    {!< DXF 160 for bitmaps, DXF 92 for PROXY vector data.
                                      e.g. INSERT, MULTILEADER  }
    {!< DXF 310  }
    {!< has no owner handle:
                                      0 has no ownerhandle, 1 is PSPACE, 2 is MSPACE
                                      3 has ownerhandle.  }
    {!< r2004+  }
    {!< r13-r14  }
    {!< r13-r2000  }
    {!< r2013+ AcDs datastore  }
    {!< r2000+  }
    {!< r2000+  }
    {!< r2007+  }
    {!< r2007+: 0 both, 1 casts, 2, receives,
                                      3 has handle. DXF 284  }
    {!< r2010+  }
    {!< r2010+  }
    {!< r2010+  }
    {!< r2000+, see dxf_cvt_lweight()  }
    { preR13 entity fields. TODO a union with above  }
    { TODO: move to the entities }
    { TODO: move to the entities }
    { TODO handling_r11; */ }
    { preR13 in the obj: eed, elevation/pt.z, thickness, paper  }
    { Common Entity Handle Data  }
    {!< code 5, DXF 330 mspace, pspace or owner of subentity  }
    {!< r13+ code 4, DXF 102 ACAD_XDICTIONARY, 330  }
    {!< r13+ code 3, DXF 102 ACAD_REACTORS, 360  }
    {!< r13-r2000 code 4  }
    {!< r13-r2000 code 4  }
    {!< code 5, DXF 8  }
    {!< code 5, DXF 6  }
    {!< r2007+ code 5, DXF 347  }
    {!< r2007+ code 5 no DXF  }
    {!< r2000+ code 5, DXF 390  }
    {!< r2010+ code 5, DXF 348  }

      _dwg_object_entity = record
          objid : BITCODE_BL;
          tio : record
              case longint of
                0 : ( UNUSED : ^Dwg_Entity_UNUSED );
                1 : ( DIMENSION_commonU : ^Dwg_DIMENSION_common );
                2 : ( _3DFACE : ^Dwg_Entity__3DFACE );
                3 : ( _3DSOLID : ^Dwg_Entity__3DSOLID );
                4 : ( ARC : ^Dwg_Entity_ARC );
                5 : ( ATTDEF : ^Dwg_Entity_ATTDEF );
                6 : ( ATTRIB : ^Dwg_Entity_ATTRIB );
                7 : ( BLOCK : ^Dwg_Entity_BLOCK );
                8 : ( BODY : ^Dwg_Entity_BODY );
                9 : ( CIRCLE : ^Dwg_Entity_CIRCLE );
                10 : ( DIMENSION_ALIGNED : ^Dwg_Entity_DIMENSION_ALIGNED );
                11 : ( DIMENSION_ANG2LN : ^Dwg_Entity_DIMENSION_ANG2LN );
                12 : ( DIMENSION_ANG3PT : ^Dwg_Entity_DIMENSION_ANG3PT );
                13 : ( DIMENSION_DIAMETER : ^Dwg_Entity_DIMENSION_DIAMETER );
                14 : ( DIMENSION_LINEAR : ^Dwg_Entity_DIMENSION_LINEAR );
                15 : ( DIMENSION_ORDINATE : ^Dwg_Entity_DIMENSION_ORDINATE );
                16 : ( DIMENSION_RADIUS : ^Dwg_Entity_DIMENSION_RADIUS );
                17 : ( ELLIPSE : ^Dwg_Entity_ELLIPSE );
                18 : ( ENDBLK : ^Dwg_Entity_ENDBLK );
                19 : ( INSERT : ^Dwg_Entity_INSERT );
                20 : ( LEADER : ^Dwg_Entity_LEADER );
                21 : ( LINE : ^Dwg_Entity_LINE );
                22 : ( LOAD : ^Dwg_Entity_LOAD );
                23 : ( MINSERT : ^Dwg_Entity_MINSERT );
                24 : ( MLINE : ^Dwg_Entity_MLINE );
                25 : ( MTEXT : ^Dwg_Entity_MTEXT );
                26 : ( OLEFRAME : ^Dwg_Entity_OLEFRAME );
                27 : ( POINT : ^Dwg_Entity_POINT );
                28 : ( POLYLINE_2D : ^Dwg_Entity_POLYLINE_2D );
                29 : ( POLYLINE_3D : ^Dwg_Entity_POLYLINE_3D );
                30 : ( POLYLINE_MESH : ^Dwg_Entity_POLYLINE_MESH );
                31 : ( POLYLINE_PFACE : ^Dwg_Entity_POLYLINE_PFACE );
                32 : ( PROXY_ENTITY : ^Dwg_Entity_PROXY_ENTITY );
                33 : ( RAY : ^Dwg_Entity_RAY );
                34 : ( REGION : ^Dwg_Entity_REGION );
                35 : ( SEQEND : ^Dwg_Entity_SEQEND );
                36 : ( SHAPE : ^Dwg_Entity_SHAPE );
                37 : ( SOLID : ^Dwg_Entity_SOLID );
                38 : ( SPLINE : ^Dwg_Entity_SPLINE );
                39 : ( TEXT : ^Dwg_Entity_TEXT );
                40 : ( TOLERANCE : ^Dwg_Entity_TOLERANCE );
                41 : ( TRACE : ^Dwg_Entity_TRACE );
                42 : ( UNKNOWN_ENT : ^Dwg_Entity_UNKNOWN_ENT );
                43 : ( VERTEX_2D : ^Dwg_Entity_VERTEX_2D );
                44 : ( VERTEX_3D : ^Dwg_Entity_VERTEX_3D );
                45 : ( VERTEX_MESH : ^Dwg_Entity_VERTEX_MESH );
                46 : ( VERTEX_PFACE : ^Dwg_Entity_VERTEX_PFACE );
                47 : ( VERTEX_PFACE_FACE : ^Dwg_Entity_VERTEX_PFACE_FACE );
                48 : ( VIEWPORT : ^Dwg_Entity_VIEWPORT );
                49 : ( XLINE : ^Dwg_Entity_XLINE );
                50 : ( CAMERA : ^Dwg_Entity_CAMERA );
                51 : ( DGNUNDERLAY : ^Dwg_Entity_DGNUNDERLAY );
                52 : ( DWFUNDERLAY : ^Dwg_Entity_DWFUNDERLAY );
                53 : ( HATCH : ^Dwg_Entity_HATCH );
                54 : ( IMAGE : ^Dwg_Entity_IMAGE );
                55 : ( LIGHT : ^Dwg_Entity_LIGHT );
                56 : ( LWPOLYLINE : ^Dwg_Entity_LWPOLYLINE );
                57 : ( MESH : ^Dwg_Entity_MESH );
                58 : ( MULTILEADER : ^Dwg_Entity_MULTILEADER );
                59 : ( OLE2FRAME : ^Dwg_Entity_OLE2FRAME );
                60 : ( PDFUNDERLAY : ^Dwg_Entity_PDFUNDERLAY );
                61 : ( SECTIONOBJECT : ^Dwg_Entity_SECTIONOBJECT );
                62 : ( _3DLINE : ^Dwg_Entity__3DLINE );
                63 : ( ARC_DIMENSION : ^Dwg_Entity_ARC_DIMENSION );
                64 : ( ENDREP : ^Dwg_Entity_ENDREP );
                65 : ( HELIX : ^Dwg_Entity_HELIX );
                66 : ( LARGE_RADIAL_DIMENSION : ^Dwg_Entity_LARGE_RADIAL_DIMENSION );
                67 : ( PLANESURFACE : ^Dwg_Entity_PLANESURFACE );
                68 : ( POINTCLOUD : ^Dwg_Entity_POINTCLOUD );
                69 : ( POINTCLOUDEX : ^Dwg_Entity_POINTCLOUDEX );
                70 : ( _REPEAT : ^Dwg_Entity_REPEAT );
                71 : ( WIPEOUT : ^Dwg_Entity_WIPEOUT );
                72 : ( ALIGNMENTPARAMETERENTITY : ^Dwg_Entity_ALIGNMENTPARAMETERENTITY );
                73 : ( ARCALIGNEDTEXT : ^Dwg_Entity_ARCALIGNEDTEXT );
                74 : ( BASEPOINTPARAMETERENTITY : ^Dwg_Entity_BASEPOINTPARAMETERENTITY );
                75 : ( EXTRUDEDSURFACE : ^Dwg_Entity_EXTRUDEDSURFACE );
                76 : ( FLIPGRIPENTITY : ^Dwg_Entity_FLIPGRIPENTITY );
                77 : ( FLIPPARAMETERENTITY : ^Dwg_Entity_FLIPPARAMETERENTITY );
                78 : ( GEOPOSITIONMARKER : ^Dwg_Entity_GEOPOSITIONMARKER );
                79 : ( LINEARGRIPENTITY : ^Dwg_Entity_LINEARGRIPENTITY );
                80 : ( LINEARPARAMETERENTITY : ^Dwg_Entity_LINEARPARAMETERENTITY );
                81 : ( LOFTEDSURFACE : ^Dwg_Entity_LOFTEDSURFACE );
                82 : ( MPOLYGON : ^Dwg_Entity_MPOLYGON );
                83 : ( NAVISWORKSMODEL : ^Dwg_Entity_NAVISWORKSMODEL );
                84 : ( NURBSURFACE : ^Dwg_Entity_NURBSURFACE );
                85 : ( POINTPARAMETERENTITY : ^Dwg_Entity_POINTPARAMETERENTITY );
                86 : ( POLARGRIPENTITY : ^Dwg_Entity_POLARGRIPENTITY );
                87 : ( REVOLVEDSURFACE : ^Dwg_Entity_REVOLVEDSURFACE );
                88 : ( ROTATIONGRIPENTITY : ^Dwg_Entity_ROTATIONGRIPENTITY );
                89 : ( ROTATIONPARAMETERENTITY : ^Dwg_Entity_ROTATIONPARAMETERENTITY );
                90 : ( RTEXT : ^Dwg_Entity_RTEXT );
                91 : ( SWEPTSURFACE : ^Dwg_Entity_SWEPTSURFACE );
                92 : ( TABLE : ^Dwg_Entity_TABLE );
                93 : ( VISIBILITYGRIPENTITY : ^Dwg_Entity_VISIBILITYGRIPENTITY );
                94 : ( VISIBILITYPARAMETERENTITY : ^Dwg_Entity_VISIBILITYPARAMETERENTITY );
                95 : ( XYGRIPENTITY : ^Dwg_Entity_XYGRIPENTITY );
                96 : ( XYPARAMETERENTITY : ^Dwg_Entity_XYPARAMETERENTITY );
              end;
          dwg : ^_dwg_struct;
          num_eed : BITCODE_BL;
          eed : ^Dwg_Eed;
          preview_exists : BITCODE_B;
          preview_is_proxy : BITCODE_B;
          preview_size : BITCODE_BLL;
          preview : BITCODE_TF;
          entmode : BITCODE_BB;
          num_reactors : BITCODE_BL;
          is_xdic_missing : BITCODE_B;
          isbylayerlt : BITCODE_B;
          nolinks : BITCODE_B;
          has_ds_data : BITCODE_B;
          color : BITCODE_CMC;
          ltype_scale : BITCODE_BD;
          ltype_flags : BITCODE_BB;
          plotstyle_flags : BITCODE_BB;
          material_flags : BITCODE_BB;
          shadow_flags : BITCODE_RC;
          has_full_visualstyle : BITCODE_B;
          has_face_visualstyle : BITCODE_B;
          has_edge_visualstyle : BITCODE_B;
          invisible : BITCODE_BS;
          linewt : BITCODE_RC;
          flag_r11 : BITCODE_RC;
          opts_r11 : BITCODE_RS;
          extra_r11 : BITCODE_RC;
          color_r11 : BITCODE_RCd;
          elevation_r11 : BITCODE_RD;
          thickness_r11 : BITCODE_RD;
          paper_r11 : BITCODE_RS;
          __iterator : BITCODE_BL;
          ownerhandle : BITCODE_H;
          reactors : ^BITCODE_H;
          xdicobjhandle : BITCODE_H;
          prev_entity : BITCODE_H;
          next_entity : BITCODE_H;
          layer : BITCODE_H;
          ltype : BITCODE_H;
          material : BITCODE_H;
          shadow : BITCODE_H;
          plotstyle : BITCODE_H;
          full_visualstyle : BITCODE_H;
          face_visualstyle : BITCODE_H;
          edge_visualstyle : BITCODE_H;
        end;
      Dwg_Object_Entity = _dwg_object_entity;
    {*
     Ordinary object attributes
      }
    {!< link to the parent  }
    { Start auto-generated object-union. Do not touch.  }
    { untyped > 500  }
    { unstable  }
    { debugging  }
    {    Dwg_Object_ACDSRECORD *ACDSRECORD; }
    {    Dwg_Object_ACDSSCHEMA *ACDSSCHEMA; }
    {    Dwg_Object_NPOCOLLECTION *NPOCOLLECTION; }
    {    Dwg_Object_RAPIDRTRENDERENVIRONMENT *RAPIDRTRENDERENVIRONMENT; }
    {    Dwg_Object_XREFPANELOBJECT *XREFPANELOBJECT; }
    { End auto-generated object-union  }
    { Common Object Data  }
    {!< code 5, DXF 330  }
    {!< r13+ code 4, DXF 102 ACAD_XDICTIONARY, 330  }
    {!< r13+ code 3, DXF 102 ACAD_REACTORS, 360  }
    {!< r2004+  }
    {!< r2013+  AcDs datastore  }
    {unsigned int num_handles; }
    {?? }

      _dwg_object_object = record
          objid : BITCODE_BL;
          tio : record
              case longint of
                0 : ( APPID : ^Dwg_Object_APPID );
                1 : ( APPID_CONTROL : ^Dwg_Object_APPID_CONTROL );
                2 : ( BLOCK_CONTROL : ^Dwg_Object_BLOCK_CONTROL );
                3 : ( BLOCK_HEADER : ^Dwg_Object_BLOCK_HEADER );
                4 : ( DICTIONARY : ^Dwg_Object_DICTIONARY );
                5 : ( DIMSTYLE : ^Dwg_Object_DIMSTYLE );
                6 : ( DIMSTYLE_CONTROL : ^Dwg_Object_DIMSTYLE_CONTROL );
                7 : ( DUMMY : ^Dwg_Object_DUMMY );
                8 : ( LAYER : ^Dwg_Object_LAYER );
                9 : ( LAYER_CONTROL : ^Dwg_Object_LAYER_CONTROL );
                10 : ( LONG_TRANSACTION : ^Dwg_Object_LONG_TRANSACTION );
                11 : ( LTYPE : ^Dwg_Object_LTYPE );
                12 : ( LTYPE_CONTROL : ^Dwg_Object_LTYPE_CONTROL );
                13 : ( MLINESTYLE : ^Dwg_Object_MLINESTYLE );
                14 : ( STYLE : ^Dwg_Object_STYLE );
                15 : ( STYLE_CONTROL : ^Dwg_Object_STYLE_CONTROL );
                16 : ( UCS : ^Dwg_Object_UCS );
                17 : ( UCS_CONTROL : ^Dwg_Object_UCS_CONTROL );
                18 : ( UNKNOWN_OBJ : ^Dwg_Object_UNKNOWN_OBJ );
                19 : ( VIEW : ^Dwg_Object_VIEW );
                20 : ( VIEW_CONTROL : ^Dwg_Object_VIEW_CONTROL );
                21 : ( VPORT : ^Dwg_Object_VPORT );
                22 : ( VPORT_CONTROL : ^Dwg_Object_VPORT_CONTROL );
                23 : ( VX_CONTROL : ^Dwg_Object_VX_CONTROL );
                24 : ( VX_TABLE_RECORD : ^Dwg_Object_VX_TABLE_RECORD );
                25 : ( ACSH_BOOLEAN_CLASS : ^Dwg_Object_ACSH_BOOLEAN_CLASS );
                26 : ( ACSH_BOX_CLASS : ^Dwg_Object_ACSH_BOX_CLASS );
                27 : ( ACSH_CONE_CLASS : ^Dwg_Object_ACSH_CONE_CLASS );
                28 : ( ACSH_CYLINDER_CLASS : ^Dwg_Object_ACSH_CYLINDER_CLASS );
                29 : ( ACSH_FILLET_CLASS : ^Dwg_Object_ACSH_FILLET_CLASS );
                30 : ( ACSH_HISTORY_CLASS : ^Dwg_Object_ACSH_HISTORY_CLASS );
                31 : ( ACSH_SPHERE_CLASS : ^Dwg_Object_ACSH_SPHERE_CLASS );
                32 : ( ACSH_TORUS_CLASS : ^Dwg_Object_ACSH_TORUS_CLASS );
                33 : ( ACSH_WEDGE_CLASS : ^Dwg_Object_ACSH_WEDGE_CLASS );
                34 : ( BLOCKALIGNMENTGRIP : ^Dwg_Object_BLOCKALIGNMENTGRIP );
                35 : ( BLOCKALIGNMENTPARAMETER : ^Dwg_Object_BLOCKALIGNMENTPARAMETER );
                36 : ( BLOCKBASEPOINTPARAMETER : ^Dwg_Object_BLOCKBASEPOINTPARAMETER );
                37 : ( BLOCKFLIPACTION : ^Dwg_Object_BLOCKFLIPACTION );
                38 : ( BLOCKFLIPGRIP : ^Dwg_Object_BLOCKFLIPGRIP );
                39 : ( BLOCKFLIPPARAMETER : ^Dwg_Object_BLOCKFLIPPARAMETER );
                40 : ( BLOCKGRIPLOCATIONCOMPONENT : ^Dwg_Object_BLOCKGRIPLOCATIONCOMPONENT );
                41 : ( BLOCKLINEARGRIP : ^Dwg_Object_BLOCKLINEARGRIP );
                42 : ( BLOCKLOOKUPGRIP : ^Dwg_Object_BLOCKLOOKUPGRIP );
                43 : ( BLOCKMOVEACTION : ^Dwg_Object_BLOCKMOVEACTION );
                44 : ( BLOCKROTATEACTION : ^Dwg_Object_BLOCKROTATEACTION );
                45 : ( BLOCKROTATIONGRIP : ^Dwg_Object_BLOCKROTATIONGRIP );
                46 : ( BLOCKSCALEACTION : ^Dwg_Object_BLOCKSCALEACTION );
                47 : ( BLOCKVISIBILITYGRIP : ^Dwg_Object_BLOCKVISIBILITYGRIP );
                48 : ( CELLSTYLEMAP : ^Dwg_Object_CELLSTYLEMAP );
                49 : ( DETAILVIEWSTYLE : ^Dwg_Object_DETAILVIEWSTYLE );
                50 : ( DICTIONARYVAR : ^Dwg_Object_DICTIONARYVAR );
                51 : ( DICTIONARYWDFLT : ^Dwg_Object_DICTIONARYWDFLT );
                52 : ( DYNAMICBLOCKPURGEPREVENTER : ^Dwg_Object_DYNAMICBLOCKPURGEPREVENTER );
                53 : ( FIELD : ^Dwg_Object_FIELD );
                54 : ( FIELDLIST : ^Dwg_Object_FIELDLIST );
                55 : ( GEODATA : ^Dwg_Object_GEODATA );
                56 : ( GROUP : ^Dwg_Object_GROUP );
                57 : ( IDBUFFER : ^Dwg_Object_IDBUFFER );
                58 : ( IMAGEDEF : ^Dwg_Object_IMAGEDEF );
                59 : ( IMAGEDEF_REACTOR : ^Dwg_Object_IMAGEDEF_REACTOR );
                60 : ( INDEX : ^Dwg_Object_INDEX );
                61 : ( LAYERFILTER : ^Dwg_Object_LAYERFILTER );
                62 : ( LAYER_INDEX : ^Dwg_Object_LAYER_INDEX );
                63 : ( LAYOUT : ^Dwg_Object_LAYOUT );
                64 : ( MLEADERSTYLE : ^Dwg_Object_MLEADERSTYLE );
                65 : ( PLACEHOLDER : ^Dwg_Object_PLACEHOLDER );
                66 : ( PLOTSETTINGS : ^Dwg_Object_PLOTSETTINGS );
                67 : ( RASTERVARIABLES : ^Dwg_Object_RASTERVARIABLES );
                68 : ( SCALE : ^Dwg_Object_SCALE );
                69 : ( SECTIONVIEWSTYLE : ^Dwg_Object_SECTIONVIEWSTYLE );
                70 : ( SECTION_MANAGER : ^Dwg_Object_SECTION_MANAGER );
                71 : ( SORTENTSTABLE : ^Dwg_Object_SORTENTSTABLE );
                72 : ( SPATIAL_FILTER : ^Dwg_Object_SPATIAL_FILTER );
                73 : ( TABLEGEOMETRY : ^Dwg_Object_TABLEGEOMETRY );
                74 : ( VBA_PROJECT : ^Dwg_Object_VBA_PROJECT );
                75 : ( VISUALSTYLE : ^Dwg_Object_VISUALSTYLE );
                76 : ( WIPEOUTVARIABLES : ^Dwg_Object_WIPEOUTVARIABLES );
                77 : ( XRECORD : ^Dwg_Object_XRECORD );
                78 : ( PDFDEFINITION : ^Dwg_Object_PDFDEFINITION );
                79 : ( DGNDEFINITION : ^Dwg_Object_DGNDEFINITION );
                80 : ( DWFDEFINITION : ^Dwg_Object_DWFDEFINITION );
                81 : ( ACSH_BREP_CLASS : ^Dwg_Object_ACSH_BREP_CLASS );
                82 : ( ACSH_CHAMFER_CLASS : ^Dwg_Object_ACSH_CHAMFER_CLASS );
                83 : ( ACSH_PYRAMID_CLASS : ^Dwg_Object_ACSH_PYRAMID_CLASS );
                84 : ( ALDIMOBJECTCONTEXTDATA : ^Dwg_Object_ALDIMOBJECTCONTEXTDATA );
                85 : ( ASSOC2DCONSTRAINTGROUP : ^Dwg_Object_ASSOC2DCONSTRAINTGROUP );
                86 : ( ASSOCACTION : ^Dwg_Object_ASSOCACTION );
                87 : ( ASSOCACTIONPARAM : ^Dwg_Object_ASSOCACTIONPARAM );
                88 : ( ASSOCARRAYACTIONBODY : ^Dwg_Object_ASSOCARRAYACTIONBODY );
                89 : ( ASSOCASMBODYACTIONPARAM : ^Dwg_Object_ASSOCASMBODYACTIONPARAM );
                90 : ( ASSOCBLENDSURFACEACTIONBODY : ^Dwg_Object_ASSOCBLENDSURFACEACTIONBODY );
                91 : ( ASSOCCOMPOUNDACTIONPARAM : ^Dwg_Object_ASSOCCOMPOUNDACTIONPARAM );
                92 : ( ASSOCDEPENDENCY : ^Dwg_Object_ASSOCDEPENDENCY );
                93 : ( ASSOCDIMDEPENDENCYBODY : ^Dwg_Object_ASSOCDIMDEPENDENCYBODY );
                94 : ( ASSOCEXTENDSURFACEACTIONBODY : ^Dwg_Object_ASSOCEXTENDSURFACEACTIONBODY );
                95 : ( ASSOCEXTRUDEDSURFACEACTIONBODY : ^Dwg_Object_ASSOCEXTRUDEDSURFACEACTIONBODY );
                96 : ( ASSOCFACEACTIONPARAM : ^Dwg_Object_ASSOCFACEACTIONPARAM );
                97 : ( ASSOCFILLETSURFACEACTIONBODY : ^Dwg_Object_ASSOCFILLETSURFACEACTIONBODY );
                98 : ( ASSOCGEOMDEPENDENCY : ^Dwg_Object_ASSOCGEOMDEPENDENCY );
                99 : ( ASSOCLOFTEDSURFACEACTIONBODY : ^Dwg_Object_ASSOCLOFTEDSURFACEACTIONBODY );
                100 : ( ASSOCNETWORK : ^Dwg_Object_ASSOCNETWORK );
                101 : ( ASSOCNETWORKSURFACEACTIONBODY : ^Dwg_Object_ASSOCNETWORKSURFACEACTIONBODY );
                102 : ( ASSOCOBJECTACTIONPARAM : ^Dwg_Object_ASSOCOBJECTACTIONPARAM );
                103 : ( ASSOCOFFSETSURFACEACTIONBODY : ^Dwg_Object_ASSOCOFFSETSURFACEACTIONBODY );
                104 : ( ASSOCOSNAPPOINTREFACTIONPARAM : ^Dwg_Object_ASSOCOSNAPPOINTREFACTIONPARAM );
                105 : ( ASSOCPATCHSURFACEACTIONBODY : ^Dwg_Object_ASSOCPATCHSURFACEACTIONBODY );
                106 : ( ASSOCPATHACTIONPARAM : ^Dwg_Object_ASSOCPATHACTIONPARAM );
                107 : ( ASSOCPLANESURFACEACTIONBODY : ^Dwg_Object_ASSOCPLANESURFACEACTIONBODY );
                108 : ( ASSOCPOINTREFACTIONPARAM : ^Dwg_Object_ASSOCPOINTREFACTIONPARAM );
                109 : ( ASSOCREVOLVEDSURFACEACTIONBODY : ^Dwg_Object_ASSOCREVOLVEDSURFACEACTIONBODY );
                110 : ( ASSOCTRIMSURFACEACTIONBODY : ^Dwg_Object_ASSOCTRIMSURFACEACTIONBODY );
                111 : ( ASSOCVALUEDEPENDENCY : ^Dwg_Object_ASSOCVALUEDEPENDENCY );
                112 : ( ASSOCVARIABLE : ^Dwg_Object_ASSOCVARIABLE );
                113 : ( ASSOCVERTEXACTIONPARAM : ^Dwg_Object_ASSOCVERTEXACTIONPARAM );
                114 : ( BLKREFOBJECTCONTEXTDATA : ^Dwg_Object_BLKREFOBJECTCONTEXTDATA );
                115 : ( BLOCKALIGNEDCONSTRAINTPARAMETER : ^Dwg_Object_BLOCKALIGNEDCONSTRAINTPARAMETER );
                116 : ( BLOCKANGULARCONSTRAINTPARAMETER : ^Dwg_Object_BLOCKANGULARCONSTRAINTPARAMETER );
                117 : ( BLOCKARRAYACTION : ^Dwg_Object_BLOCKARRAYACTION );
                118 : ( BLOCKDIAMETRICCONSTRAINTPARAMETER : ^Dwg_Object_BLOCKDIAMETRICCONSTRAINTPARAMETER );
                119 : ( BLOCKHORIZONTALCONSTRAINTPARAMETER : ^Dwg_Object_BLOCKHORIZONTALCONSTRAINTPARAMETER );
                120 : ( BLOCKLINEARCONSTRAINTPARAMETER : ^Dwg_Object_BLOCKLINEARCONSTRAINTPARAMETER );
                121 : ( BLOCKLINEARPARAMETER : ^Dwg_Object_BLOCKLINEARPARAMETER );
                122 : ( BLOCKLOOKUPACTION : ^Dwg_Object_BLOCKLOOKUPACTION );
                123 : ( BLOCKLOOKUPPARAMETER : ^Dwg_Object_BLOCKLOOKUPPARAMETER );
                124 : ( BLOCKPARAMDEPENDENCYBODY : ^Dwg_Object_BLOCKPARAMDEPENDENCYBODY );
                125 : ( BLOCKPOINTPARAMETER : ^Dwg_Object_BLOCKPOINTPARAMETER );
                126 : ( BLOCKPOLARGRIP : ^Dwg_Object_BLOCKPOLARGRIP );
                127 : ( BLOCKPOLARPARAMETER : ^Dwg_Object_BLOCKPOLARPARAMETER );
                128 : ( BLOCKPOLARSTRETCHACTION : ^Dwg_Object_BLOCKPOLARSTRETCHACTION );
                129 : ( BLOCKRADIALCONSTRAINTPARAMETER : ^Dwg_Object_BLOCKRADIALCONSTRAINTPARAMETER );
                130 : ( BLOCKREPRESENTATION : ^Dwg_Object_BLOCKREPRESENTATION );
                131 : ( BLOCKROTATIONPARAMETER : ^Dwg_Object_BLOCKROTATIONPARAMETER );
                132 : ( BLOCKSTRETCHACTION : ^Dwg_Object_BLOCKSTRETCHACTION );
                133 : ( BLOCKUSERPARAMETER : ^Dwg_Object_BLOCKUSERPARAMETER );
                134 : ( BLOCKVERTICALCONSTRAINTPARAMETER : ^Dwg_Object_BLOCKVERTICALCONSTRAINTPARAMETER );
                135 : ( BLOCKVISIBILITYPARAMETER : ^Dwg_Object_BLOCKVISIBILITYPARAMETER );
                136 : ( BLOCKXYGRIP : ^Dwg_Object_BLOCKXYGRIP );
                137 : ( BLOCKXYPARAMETER : ^Dwg_Object_BLOCKXYPARAMETER );
                138 : ( DATALINK : ^Dwg_Object_DATALINK );
                139 : ( DBCOLOR : ^Dwg_Object_DBCOLOR );
                140 : ( EVALUATION_GRAPH : ^Dwg_Object_EVALUATION_GRAPH );
                141 : ( FCFOBJECTCONTEXTDATA : ^Dwg_Object_FCFOBJECTCONTEXTDATA );
                142 : ( GRADIENT_BACKGROUND : ^Dwg_Object_GRADIENT_BACKGROUND );
                143 : ( GROUND_PLANE_BACKGROUND : ^Dwg_Object_GROUND_PLANE_BACKGROUND );
                144 : ( IBL_BACKGROUND : ^Dwg_Object_IBL_BACKGROUND );
                145 : ( IMAGE_BACKGROUND : ^Dwg_Object_IMAGE_BACKGROUND );
                146 : ( LEADEROBJECTCONTEXTDATA : ^Dwg_Object_LEADEROBJECTCONTEXTDATA );
                147 : ( LIGHTLIST : ^Dwg_Object_LIGHTLIST );
                148 : ( MATERIAL : ^Dwg_Object_MATERIAL );
                149 : ( MENTALRAYRENDERSETTINGS : ^Dwg_Object_MENTALRAYRENDERSETTINGS );
                150 : ( MTEXTOBJECTCONTEXTDATA : ^Dwg_Object_MTEXTOBJECTCONTEXTDATA );
                151 : ( OBJECT_PTR : ^Dwg_Object_OBJECT_PTR );
                152 : ( PARTIAL_VIEWING_INDEX : ^Dwg_Object_PARTIAL_VIEWING_INDEX );
                153 : ( POINTCLOUDCOLORMAP : ^Dwg_Object_POINTCLOUDCOLORMAP );
                154 : ( POINTCLOUDDEF : ^Dwg_Object_POINTCLOUDDEF );
                155 : ( POINTCLOUDDEFEX : ^Dwg_Object_POINTCLOUDDEFEX );
                156 : ( POINTCLOUDDEF_REACTOR : ^Dwg_Object_POINTCLOUDDEF_REACTOR );
                157 : ( POINTCLOUDDEF_REACTOR_EX : ^Dwg_Object_POINTCLOUDDEF_REACTOR_EX );
                158 : ( PROXY_OBJECT : ^Dwg_Object_PROXY_OBJECT );
                159 : ( RAPIDRTRENDERSETTINGS : ^Dwg_Object_RAPIDRTRENDERSETTINGS );
                160 : ( RENDERENTRY : ^Dwg_Object_RENDERENTRY );
                161 : ( RENDERENVIRONMENT : ^Dwg_Object_RENDERENVIRONMENT );
                162 : ( RENDERGLOBAL : ^Dwg_Object_RENDERGLOBAL );
                163 : ( RENDERSETTINGS : ^Dwg_Object_RENDERSETTINGS );
                164 : ( SECTION_SETTINGS : ^Dwg_Object_SECTION_SETTINGS );
                165 : ( SKYLIGHT_BACKGROUND : ^Dwg_Object_SKYLIGHT_BACKGROUND );
                166 : ( SOLID_BACKGROUND : ^Dwg_Object_SOLID_BACKGROUND );
                167 : ( SPATIAL_INDEX : ^Dwg_Object_SPATIAL_INDEX );
                168 : ( SUN : ^Dwg_Object_SUN );
                169 : ( TABLESTYLE : ^Dwg_Object_TABLESTYLE );
                170 : ( TEXTOBJECTCONTEXTDATA : ^Dwg_Object_TEXTOBJECTCONTEXTDATA );
                171 : ( ASSOCARRAYMODIFYPARAMETERS : ^Dwg_Object_ASSOCARRAYMODIFYPARAMETERS );
                172 : ( ASSOCARRAYPATHPARAMETERS : ^Dwg_Object_ASSOCARRAYPATHPARAMETERS );
                173 : ( ASSOCARRAYPOLARPARAMETERS : ^Dwg_Object_ASSOCARRAYPOLARPARAMETERS );
                174 : ( ASSOCARRAYRECTANGULARPARAMETERS : ^Dwg_Object_ASSOCARRAYRECTANGULARPARAMETERS );
                175 : ( ACMECOMMANDHISTORY : ^Dwg_Object_ACMECOMMANDHISTORY );
                176 : ( ACMESCOPE : ^Dwg_Object_ACMESCOPE );
                177 : ( ACMESTATEMGR : ^Dwg_Object_ACMESTATEMGR );
                178 : ( ACSH_EXTRUSION_CLASS : ^Dwg_Object_ACSH_EXTRUSION_CLASS );
                179 : ( ACSH_LOFT_CLASS : ^Dwg_Object_ACSH_LOFT_CLASS );
                180 : ( ACSH_REVOLVE_CLASS : ^Dwg_Object_ACSH_REVOLVE_CLASS );
                181 : ( ACSH_SWEEP_CLASS : ^Dwg_Object_ACSH_SWEEP_CLASS );
                182 : ( ANGDIMOBJECTCONTEXTDATA : ^Dwg_Object_ANGDIMOBJECTCONTEXTDATA );
                183 : ( ANNOTSCALEOBJECTCONTEXTDATA : ^Dwg_Object_ANNOTSCALEOBJECTCONTEXTDATA );
                184 : ( ASSOC3POINTANGULARDIMACTIONBODY : ^Dwg_Object_ASSOC3POINTANGULARDIMACTIONBODY );
                185 : ( ASSOCALIGNEDDIMACTIONBODY : ^Dwg_Object_ASSOCALIGNEDDIMACTIONBODY );
                186 : ( ASSOCARRAYMODIFYACTIONBODY : ^Dwg_Object_ASSOCARRAYMODIFYACTIONBODY );
                187 : ( ASSOCEDGEACTIONPARAM : ^Dwg_Object_ASSOCEDGEACTIONPARAM );
                188 : ( ASSOCEDGECHAMFERACTIONBODY : ^Dwg_Object_ASSOCEDGECHAMFERACTIONBODY );
                189 : ( ASSOCEDGEFILLETACTIONBODY : ^Dwg_Object_ASSOCEDGEFILLETACTIONBODY );
                190 : ( ASSOCMLEADERACTIONBODY : ^Dwg_Object_ASSOCMLEADERACTIONBODY );
                191 : ( ASSOCORDINATEDIMACTIONBODY : ^Dwg_Object_ASSOCORDINATEDIMACTIONBODY );
                192 : ( ASSOCPERSSUBENTMANAGER : ^Dwg_Object_ASSOCPERSSUBENTMANAGER );
                193 : ( ASSOCRESTOREENTITYSTATEACTIONBODY : ^Dwg_Object_ASSOCRESTOREENTITYSTATEACTIONBODY );
                194 : ( ASSOCROTATEDDIMACTIONBODY : ^Dwg_Object_ASSOCROTATEDDIMACTIONBODY );
                195 : ( ASSOCSWEPTSURFACEACTIONBODY : ^Dwg_Object_ASSOCSWEPTSURFACEACTIONBODY );
                196 : ( BLOCKPROPERTIESTABLE : ^Dwg_Object_BLOCKPROPERTIESTABLE );
                197 : ( BLOCKPROPERTIESTABLEGRIP : ^Dwg_Object_BLOCKPROPERTIESTABLEGRIP );
                198 : ( BREAKDATA : ^Dwg_Object_BREAKDATA );
                199 : ( BREAKPOINTREF : ^Dwg_Object_BREAKPOINTREF );
                200 : ( CONTEXTDATAMANAGER : ^Dwg_Object_CONTEXTDATAMANAGER );
                201 : ( CSACDOCUMENTOPTIONS : ^Dwg_Object_CSACDOCUMENTOPTIONS );
                202 : ( CURVEPATH : ^Dwg_Object_CURVEPATH );
                203 : ( DATATABLE : ^Dwg_Object_DATATABLE );
                204 : ( DIMASSOC : ^Dwg_Object_DIMASSOC );
                205 : ( DMDIMOBJECTCONTEXTDATA : ^Dwg_Object_DMDIMOBJECTCONTEXTDATA );
                206 : ( DYNAMICBLOCKPROXYNODE : ^Dwg_Object_DYNAMICBLOCKPROXYNODE );
                207 : ( GEOMAPIMAGE : ^Dwg_Object_GEOMAPIMAGE );
                208 : ( LAYOUTPRINTCONFIG : ^Dwg_Object_LAYOUTPRINTCONFIG );
                209 : ( MLEADEROBJECTCONTEXTDATA : ^Dwg_Object_MLEADEROBJECTCONTEXTDATA );
                210 : ( MOTIONPATH : ^Dwg_Object_MOTIONPATH );
                211 : ( MTEXTATTRIBUTEOBJECTCONTEXTDATA : ^Dwg_Object_MTEXTATTRIBUTEOBJECTCONTEXTDATA );
                212 : ( NAVISWORKSMODELDEF : ^Dwg_Object_NAVISWORKSMODELDEF );
                213 : ( ORDDIMOBJECTCONTEXTDATA : ^Dwg_Object_ORDDIMOBJECTCONTEXTDATA );
                214 : ( PERSUBENTMGR : ^Dwg_Object_PERSUBENTMGR );
                215 : ( POINTPATH : ^Dwg_Object_POINTPATH );
                216 : ( RADIMLGOBJECTCONTEXTDATA : ^Dwg_Object_RADIMLGOBJECTCONTEXTDATA );
                217 : ( RADIMOBJECTCONTEXTDATA : ^Dwg_Object_RADIMOBJECTCONTEXTDATA );
                218 : ( SUNSTUDY : ^Dwg_Object_SUNSTUDY );
                219 : ( TABLECONTENT : ^Dwg_Object_TABLECONTENT );
                220 : ( TVDEVICEPROPERTIES : ^Dwg_Object_TVDEVICEPROPERTIES );
              end;
          dwg : ^_dwg_struct;
          num_eed : BITCODE_BL;
          eed : ^Dwg_Eed;
          ownerhandle : BITCODE_H;
          num_reactors : BITCODE_BL;
          reactors : ^BITCODE_H;
          xdicobjhandle : BITCODE_H;
          is_xdic_missing : BITCODE_B;
          has_ds_data : BITCODE_B;
          handleref : ^Dwg_Handle;
        end;
      Dwg_Object_Object = _dwg_object_object;
    {*
     Classes
      }
    {!< starting with 500  }
    { see http://images.autodesk.com/adsk/files/autocad_2012_pdf_dxf-reference_enu.pdf  }
    {!<
          erase allowed = 1,
          transform allowed = 2,
          color change allowed = 4,
          layer change allowed = 8,
          LTYPE change allowed = 16,
          LTYPE.scale change allowed = 32,
          visibility change allowed = 64,
          cloning allowed = 128,
          Lineweight change allowed = 256,
          PLOTSTYLE Name change allowed = 512,
          Disables proxy warning dialog = 1024,
          is R13 format proxy = 32768  }
    {!< ASCII or UTF-8  }
    {!< r2007+, always transformed to dxfname as UTF-8  }
    {!< i.e. was_proxy, not loaded class  }
    {!< really is_entity. 1f2 for entities, 1f3 for objects  }
    {!< 91 instance count for a custom class  }
    {!< def: 0L  }
    {!< def: 0L  }

      _dwg_class = record
          number : BITCODE_BS;
          proxyflag : BITCODE_BS;
          appname : ^char;
          cppname : ^char;
          dxfname : ^char;
          dxfname_u : BITCODE_TU;
          is_zombie : BITCODE_B;
          item_class_id : BITCODE_BS;
          num_instances : BITCODE_BL;
          dwg_version : BITCODE_BL;
          maint_version : BITCODE_BL;
          unknown_1 : BITCODE_BL;
          unknown_2 : BITCODE_BL;
        end;
      Dwg_Class = _dwg_class;
    {*
     General DWG object with link to either entity or object, and as parent the DWG
      }
    {!< in bytes  }
    {!< byte offset in the file  }
    {!< fixed or variable (class - 500)  }
    {!< into dwg->object[]  }
    {!< into a global list  }
    {!< our public entity/object name  }
    {!< the internal dxf classname, often with a ACDB prefix  }
    { the optional class of a variable object  }
    {BITCODE_RC flag_r11; }
    { common + object fields, but no handles  }
    { bitsize offset in bits: r13-2007  }
    { relative offset, in bits  }
    { internally for encode only  }
    {!< r2007+  }
    {!< r2007+ in bits, unused  }
    {!< r2010+ in bits  }
    { relative offset from type ... end common_entity_data  }

      _dwg_object = record
          size : BITCODE_RL;
          address : dword;
          _type : dword;
          index : BITCODE_RL;
          fixedtype : DWG_OBJECT_TYPE;
          name : ^char;
          dxfname : ^char;
          supertype : Dwg_Object_Supertype;
          tio : record
              case longint of
                0 : ( entity : ^Dwg_Object_Entity );
                1 : ( &object : ^Dwg_Object_Object );
              end;
          handle : Dwg_Handle;
          parent : ^_dwg_struct;
          klass : ^Dwg_Class;
          bitsize : BITCODE_RL;
          bitsize_pos : dword;
          hdlpos : dword;
          was_bitsize_set : BITCODE_B;
          has_strings : BITCODE_B;
          stringstream_size : BITCODE_RL;
          handlestream_size : BITCODE_UMC;
          common_size : dword;
          num_unknown_bits : BITCODE_RL;
          unknown_bits : BITCODE_TF;
        end;
      Dwg_Object = _dwg_object;
    {*
     Dwg_Chain similar to Bit_Chain in "bits.h". Used only for the Thumbnail thumbnail
      }
      _dwg_chain = record
         {NOT:
          opts : byte;
          version : Dwg_Version_Type;
          from_version : Dwg_Version_Type;
          fh : pointer;}
          chain : Pointer;//unsigned char *chain;
          size : LongWord;//long unsigned int size;
          byte : LongWord;//long unsigned int byte;
          bit : byte;//unsigned char bit;

        end;
      Dwg_Chain = _dwg_chain;
    { since r2004+  }
    { The very first 160 byte?  }
    { AcDb:Header  }
    { AcDb:AuxHeader  }
    { AcDb:Classes  }
    { AcDb:Handles  }
    { AcDb:Template  }
    { AcDb:ObjFreeSpace  }
    { AcDb:AcDbObjects  }
    { AcDb:RevHistory  }
    { AcDb:SummaryInfo  }
    { AcDb:Preview  }
    { AcDb:AppInfo  }
    { AcDb:AppInfoHistory  }
    { AcDb:FileDepList  }
    { AcDb:Security, if stored with a password  }
    { AcDb:VBAProject  }
    { AcDb:Signature  }
    { AcDb:AcDsPrototype_1b = 12 (ACIS datastorage)  }
    { also called Data Section, or Section Page Map (ODA)  }

      DWG_SECTION_TYPE = (SECTION_UNKNOWN := 0,SECTION_HEADER := 1,
        SECTION_AUXHEADER := 2,SECTION_CLASSES := 3,
        SECTION_HANDLES := 4,SECTION_TEMPLATE := 5,
        SECTION_OBJFREESPACE := 6,SECTION_OBJECTS := 7,
        SECTION_REVHISTORY := 8,SECTION_SUMMARYINFO := 9,
        SECTION_PREVIEW := 10,SECTION_APPINFO := 11,
        SECTION_APPINFOHISTORY := 12,SECTION_FILEDEPLIST := 13,
        SECTION_SECURITY,SECTION_VBAPROJECT,
        SECTION_SIGNATURE,SECTION_ACDS,SECTION_INFO,
        SECTION_SYSTEM_MAP);

      DWG_SECTION_TYPE_R13 = (SECTION_HEADER_R13 := 0,SECTION_CLASSES_R13 := 1,
        SECTION_HANDLES_R13 := 2,SECTION_2NDHEADER_R13 := 3,
        SECTION_MEASUREMENT_R13 := 4,SECTION_AUXHEADER_R2000 := 5
        );
    { tables  }
    { since r11: }

      DWG_SECTION_TYPE_R11 = (SECTION_HEADER_R11 := 0,SECTION_BLOCK := 1,
        SECTION_LAYER := 2,SECTION_STYLE := 3,
        SECTION_LTYPE := 5,SECTION_VIEW := 6,
        SECTION_UCS := 7,SECTION_VPORT := 8,
        SECTION_APPID := 9,SECTION_DIMSTYLE := 10,
        SECTION_VX := 11);
    { preR13: num_entries, r2007: id  }
    { now unsigned  }
    { r2000+:  }
    { to be casted to Dwg_Section_Type_r11 preR13  }
    { => section_info?  }
    {!< r2004 section fields:  }
    { preR13  }

      _dwg_section = record
          number : int32_t;
          size : BITCODE_RL;
          address : uint64_t;
          objid_r11 : BITCODE_RL;
          parent : BITCODE_RL;
          left : BITCODE_RL;
          right : BITCODE_RL;
          x00 : BITCODE_RL;
          _type : Dwg_Section_Type;
          name : array[0..63] of char;
          section_type : BITCODE_RL;
          decomp_data_size : BITCODE_RL;
          comp_data_size : BITCODE_RL;
          compression_type : BITCODE_RL;
          checksum : BITCODE_RL;
          flags : BITCODE_RS;
        end;
      Dwg_Section = _dwg_section;
    { Dwg_R2007_Section:
      int64_t  data_size;    // max size of page
      int64_t  max_size;
      int64_t  encrypted;
      int64_t  hashcode;
      int64_t  name_length;  // 0x22
      int64_t  unknown;      // 0x00
      int64_t  encoded;
      int64_t  num_pages;
      DWGCHAR *name;
      r2007_section_page **pages;
      struct _r2007_section *nextsec;
      }
    { ODA 4.5 }
    { Compressed (1 = no, 2 = yes, normally 2)  }
    { (0 = no, 1 = yes, 2 = unknown)  }

      Dwg_Section_InfoHdr = record
          num_desc : BITCODE_RL;
          compressed : BITCODE_RL;
          max_size : BITCODE_RL;
          encrypted : BITCODE_RL;
          num_desc2 : BITCODE_RL;
        end;
    { Compressed (1 = no, 2 = yes, normally 2)  }
    { The dynamic index as read/written  }
    { (0 = no, 1 = yes, 2 = unknown)  }
    { to search for  }
      PDwg_Section=^Dwg_Section;
      Dwg_Section_Info = record
          size : int64_t;
          num_sections : BITCODE_RL;
          max_decomp_size : BITCODE_RL;
          unknown : BITCODE_RL;
          compressed : BITCODE_RL;
          _type : BITCODE_RL;
          encrypted : BITCODE_RL;
          name : array[0..63] of char;
          fixedtype : Dwg_Section_Type;
          sections : ^PDwg_Section;
        end;
    { CUSTOMPROPERTYTAG }
    { CUSTOMPROPERTY }

      _dwg_SummaryInfo_Property = record
          tag : BITCODE_TU;
          value : BITCODE_TU;
        end;
      Dwg_SummaryInfo_Property = _dwg_SummaryInfo_Property;

      _dwg_FileDepList_Files = record
          filename : BITCODE_T32;
          filepath : BITCODE_T32;
          fingerprint : BITCODE_T32;
          version : BITCODE_T32;
          feature_index : BITCODE_RL;
          timestamp : BITCODE_RL;
          filesize : BITCODE_RL;
          affects_graphics : BITCODE_RS;
          refcount : BITCODE_RL;
        end;
      Dwg_FileDepList_Files = _dwg_FileDepList_Files;

      _dwg_AcDs_SegmentIndex = record
          offset : BITCODE_RLL;
          size : BITCODE_RL;
        end;
      Dwg_AcDs_SegmentIndex = _dwg_AcDs_SegmentIndex;

      _dwg_AcDs_DataIndex_Entry = record
          segidx : BITCODE_RL;
          offset : BITCODE_RL;
          schidx : BITCODE_RL;
        end;
      Dwg_AcDs_DataIndex_Entry = _dwg_AcDs_DataIndex_Entry;
    { always 0, probably RLL above }

      _dwg_AcDs_DataIndex = record
          num_entries : BITCODE_RL;
          di_unknown : BITCODE_RL;
          entries : ^Dwg_AcDs_DataIndex_Entry;
        end;
      Dwg_AcDs_DataIndex = _dwg_AcDs_DataIndex;
    { mostly 1 }

      _dwg_AcDs_Data_RecordHdr = record
          entry_size : BITCODE_RL;
          unknown : BITCODE_RL;
          handle : BITCODE_RLL;
          offset : BITCODE_RL;
        end;
      Dwg_AcDs_Data_RecordHdr = _dwg_AcDs_Data_RecordHdr;

      _dwg_AcDs_Data_Record = record
          data_size : BITCODE_RL;
          blob : ^BITCODE_RC;
        end;
      Dwg_AcDs_Data_Record = _dwg_AcDs_Data_Record;

      _dwg_AcDs_Data = record
          record_hdrs : ^Dwg_AcDs_Data_RecordHdr;
          records : ^Dwg_AcDs_Data_Record;
        end;
      Dwg_AcDs_Data = _dwg_AcDs_Data;

      _dwg_AcDs_DataBlobRef_Page = record
          segidx : BITCODE_RL;
          size : BITCODE_RL;
        end;
      Dwg_AcDs_DataBlobRef_Page = _dwg_AcDs_DataBlobRef_Page;
    { ODA writes 1 }
    { ODA writes 0 }

      _dwg_AcDs_DataBlobRef = record
          total_data_size : BITCODE_RLL;
          num_pages : BITCODE_RL;
          record_size : BITCODE_RL;
          page_size : BITCODE_RL;
          unknown_1 : BITCODE_RL;
          unknown_2 : BITCODE_RL;
          pages : ^Dwg_AcDs_DataBlobRef_Page;
        end;
      Dwg_AcDs_DataBlobRef = _dwg_AcDs_DataBlobRef;
    { ODA writes 1 }
    { ODA writes 0 }
    { only one, optional }

      _dwg_AcDs_DataBlob = record
          data_size : BITCODE_RLL;
          page_count : BITCODE_RL;
          record_size : BITCODE_RL;
          page_size : BITCODE_RL;
          unknown_1 : BITCODE_RL;
          unknown_2 : BITCODE_RL;
          ref : ^Dwg_AcDs_DataBlobRef;
        end;
      Dwg_AcDs_DataBlob = _dwg_AcDs_DataBlob;

      _dwg_AcDs_DataBlob01 = record
          total_data_size : BITCODE_RLL;
          page_start_offset : BITCODE_RLL;
          page_index : int32_t;
          page_count : int32_t;
          page_data_size : BITCODE_RLL;
          page_data : ^BITCODE_RC;
        end;
      Dwg_AcDs_DataBlob01 = _dwg_AcDs_DataBlob01;
    { 24.2.2.5 }

      _dwg_AcDs_SchemaIndex_Prop = record
          index : BITCODE_RL;
          segidx : BITCODE_RL;
          offset : BITCODE_RL;
        end;
      Dwg_AcDs_SchemaIndex_Prop = _dwg_AcDs_SchemaIndex_Prop;
    { 24.2.2.5 }
    { or uint64 }
    { 0x0af10c  }
    { 0  }

      _dwg_AcDs_SchemaIndex = record
          num_props : BITCODE_RL;
          si_unknown_1 : BITCODE_RL;
          props : ^Dwg_AcDs_SchemaIndex_Prop;
          si_tag : BITCODE_RLL;
          num_prop_entries : BITCODE_RL;
          si_unknown_2 : BITCODE_RL;
          prop_entries : ^Dwg_AcDs_SchemaIndex_Prop;
        end;
      Dwg_AcDs_SchemaIndex = _dwg_AcDs_SchemaIndex;
    { 24.2.2.6.1.1 }
    {<! DXF 91  }
    {<! DXF 2  }
    {<! DXF 280, 0-15  }

      _dwg_AcDs_Schema_Prop = record
          flags : BITCODE_RL;
          namidx : BITCODE_RL;
          _type : BITCODE_RL;
          type_size : BITCODE_RL;
          unknown_1 : BITCODE_RL;
          unknown_2 : BITCODE_RL;
          num_values : BITCODE_RS;
          values : ^BITCODE_RC;
        end;
      Dwg_AcDs_Schema_Prop = _dwg_AcDs_Schema_Prop;
    { 24.2.2.6.1 }

      _dwg_AcDs_Schema = record
          num_index : BITCODE_RS;
          index : ^BITCODE_RLL;
          num_props : BITCODE_RS;
          props : ^Dwg_AcDs_Schema_Prop;
        end;
      Dwg_AcDs_Schema = _dwg_AcDs_Schema;
    { 24.2.2.6 }

      _dwg_AcDs_SchemaData_UProp = record
          size : BITCODE_RL;
          flags : BITCODE_RL;
        end;
      Dwg_AcDs_SchemaData_UProp = _dwg_AcDs_SchemaData_UProp;
    { computed, see schidx }
    { computed, see schidx }

      _dwg_AcDs_SchemaData = record
          num_uprops : BITCODE_RL;
          uprops : ^Dwg_AcDs_SchemaData_UProp;
          num_schemas : BITCODE_RL;
          schemas : ^Dwg_AcDs_Schema;
          num_propnames : BITCODE_RL;
          propnames : ^BITCODE_TV;
        end;
      Dwg_AcDs_SchemaData = _dwg_AcDs_SchemaData;

      _dwg_AcDs_Search_IdIdx = record
          handle : BITCODE_RLL;
          num_ididx : BITCODE_RL;
          ididx : ^BITCODE_RLL;
        end;
      Dwg_AcDs_Search_IdIdx = _dwg_AcDs_Search_IdIdx;

      _dwg_AcDs_Search_IdIdxs = record
          num_ididx : BITCODE_RL;
          ididx : ^Dwg_AcDs_Search_IdIdx;
        end;
      Dwg_AcDs_Search_IdIdxs = _dwg_AcDs_Search_IdIdxs;
    { 24.2.2.7.1 }

      _dwg_AcDs_Search_Data = record
          schema_namidx : BITCODE_RL;
          num_sortedidx : BITCODE_RL;
          sortedidx : ^BITCODE_RLL;
          num_ididxs : BITCODE_RL;
          unknown : BITCODE_RL;
          ididxs : ^Dwg_AcDs_Search_IdIdxs;
        end;
      Dwg_AcDs_Search_Data = _dwg_AcDs_Search_Data;

      _dwg_AcDs_Search = record
          num_search : BITCODE_RL;
          search : ^Dwg_AcDs_Search_Data;
        end;
      Dwg_AcDs_Search = _dwg_AcDs_Search;
    { always 0xd5ac  }
    { segidx, datidx, _data_, schidx, schdat, search, blob01  }
    { computed 0-6 or -1  }
    { datastorage revision }
    { always 8x 0x55 }

      _dwg_AcDs_Segment = record
          signature : BITCODE_RS;
          name : array[0..6] of BITCODE_RC;
          _type : BITCODE_RCd;
          segment_idx : BITCODE_RL;
          is_blob01 : BITCODE_RL;
          segsize : BITCODE_RL;
          unknown_2 : BITCODE_RL;
          ds_version : BITCODE_RL;
          unknown_3 : BITCODE_RL;
          data_algn_offset : BITCODE_RL;
          objdata_algn_offset : BITCODE_RL;
          padding : array[0..8] of BITCODE_RC;
        end;
      Dwg_AcDs_Segment = _dwg_AcDs_Segment;
    { header }
    { acis version? always 2  }
    { always 2  }
    { always 0  }
    { datastorage revision  }
    { computed }

      _dwg_AcDs = record
          file_signature : BITCODE_RL;
          file_header_size : BITCODE_RL;
          unknown_1 : BITCODE_RL;
          version : BITCODE_RL;
          unknown_2 : BITCODE_RL;
          ds_version : BITCODE_RL;
          segidx_offset : BITCODE_RL;
          segidx_unknown : BITCODE_RL;
          num_segidx : BITCODE_RL;
          schidx_segidx : BITCODE_RL;
          datidx_segidx : BITCODE_RL;
          search_segidx : BITCODE_RL;
          prvsav_segidx : BITCODE_RL;
          file_size : BITCODE_RL;
          total_segments : BITCODE_BL;
          segidx : ^Dwg_AcDs_SegmentIndex;
          datidx : Dwg_AcDs_DataIndex;
          data : ^Dwg_AcDs_Data;
          blob01 : Dwg_AcDs_DataBlob;
          schidx : Dwg_AcDs_SchemaIndex;
          schdat : Dwg_AcDs_SchemaData;
          search : Dwg_AcDs_Search;
          segments : ^Dwg_AcDs_Segment;
        end;
      Dwg_AcDs = _dwg_AcDs;
    { calculated from the header magic  }
    { option. set by --as (convert from)  }
    { < R13, always 3  }
    { < R13  }
    { THUMBNAIL or AdDb:Preview  }
    { R2004+  }
    { R2004+  }
    { R2004+  }
    { R2004+  }
    { R2004+ mostly 0  }
    { R2004+  }
    { R2004+  }
    { R2004+  }
    { R2004+  }

      _dwg_header = record
          version : Dwg_Version_Type;
          from_version : Dwg_Version_Type;
          zero_5 : array[0..4] of BITCODE_RC;
          is_maint : BITCODE_RC;
          zero_one_or_three : BITCODE_RC;
          unknown_3 : BITCODE_RS;
          numheader_vars : BITCODE_RS;
          thumbnail_address : BITCODE_RL;
          dwg_version : BITCODE_RC;
          maint_version : BITCODE_RC;
          codepage : BITCODE_RS;
          unknown_0 : BITCODE_RC;
          app_dwg_version : BITCODE_RC;
          app_maint_version : BITCODE_RC;
          security_type : BITCODE_RL;
          rl_1c_address : BITCODE_RL;
          summaryinfo_address : BITCODE_RL;
          vbaproj_address : BITCODE_RL;
          r2004_header_address : BITCODE_RL;
          numsections : BITCODE_RL;
          section : ^Dwg_Section;
          section_infohdr : Dwg_Section_InfoHdr;
          section_info : ^Dwg_Section_Info;
        end;
      Dwg_Header = _dwg_header;
(** unsupported pragma#pragma pack(1)*)
    { encrypted  }
    { p 2.14.2 32bit CRC 2004+  }
    { System Section: Section Page Map  }
    { 0x4163043b  }

      _dwg_R2004_Header = record
          file_ID_string : array[0..11] of BITCODE_RC;
          header_address : BITCODE_RLx;
          header_size : BITCODE_RL;
          x04 : BITCODE_RL;
          root_tree_node_gap : BITCODE_RLd;
          lowermost_left_tree_node_gap : BITCODE_RLd;
          lowermost_right_tree_node_gap : BITCODE_RLd;
          unknown_long : BITCODE_RL;
          last_section_id : BITCODE_RL;
          last_section_address : BITCODE_RLL;
          second_header_address : BITCODE_RLL;
          numgaps : BITCODE_RL;
          numsections : BITCODE_RL;
          x20 : BITCODE_RL;
          x80 : BITCODE_RL;
          x40 : BITCODE_RL;
          section_map_id : BITCODE_RL;
          section_map_address : BITCODE_RLL;
          section_info_id : BITCODE_RLd;
          section_array_size : BITCODE_RL;
          gap_array_size : BITCODE_RL;
          crc32 : BITCODE_RLx;
          padding : array[0..11] of BITCODE_RC;
          section_type : BITCODE_RL;
          decomp_data_size : BITCODE_RL;
          comp_data_size : BITCODE_RL;
          compression_type : BITCODE_RL;
          checksum : BITCODE_RLx;
        end;
      Dwg_R2004_Header = _dwg_R2004_Header;
(** unsupported pragma#pragma pack()*)
    { ff 77 01  }
    { ?? format TD  }
    { ??  }
    { R2018+  }

      _dwg_auxheader = record
          aux_intro : array[0..2] of BITCODE_RC;
          dwg_version : BITCODE_RS;
          maint_version : BITCODE_RL;
          numsaves : BITCODE_RL;
          minus_1 : BITCODE_RL;
          numsaves_1 : BITCODE_RS;
          numsaves_2 : BITCODE_RS;
          zero : BITCODE_RL;
          dwg_version_1 : BITCODE_RS;
          maint_version_1 : BITCODE_RL;
          dwg_version_2 : BITCODE_RS;
          maint_version_2 : BITCODE_RL;
          unknown_6rs : array[0..5] of BITCODE_RS;
          unknown_5rl : array[0..4] of BITCODE_RL;
          TDCREATE : BITCODE_RD;
          TDUPDATE : BITCODE_RD;
          HANDSEED : BITCODE_RL;
          plot_stamp : BITCODE_RL;
          zero_1 : BITCODE_RS;
          numsaves_3 : BITCODE_RS;
          zero_2 : BITCODE_RL;
          zero_3 : BITCODE_RL;
          zero_4 : BITCODE_RL;
          numsaves_4 : BITCODE_RL;
          zero_5 : BITCODE_RL;
          zero_6 : BITCODE_RL;
          zero_7 : BITCODE_RL;
          zero_8 : BITCODE_RL;
          zero_18 : array[0..2] of BITCODE_RS;
        end;
      Dwg_AuxHeader = _dwg_auxheader;
    { days + ms, fixed size!  }

      _dwg_summaryinfo = record
          TITLE : BITCODE_TU;
          SUBJECT : BITCODE_TU;
          AUTHOR : BITCODE_TU;
          KEYWORDS : BITCODE_TU;
          COMMENTS : BITCODE_TU;
          LASTSAVEDBY : BITCODE_TU;
          REVISIONNUMBER : BITCODE_TU;
          HYPERLINKBASE : BITCODE_TU;
          TDINDWG : BITCODE_TIMERLL;
          TDCREATE : BITCODE_TIMERLL;
          TDUPDATE : BITCODE_TIMERLL;
          num_props : BITCODE_RS;
          props : ^Dwg_SummaryInfo_Property;
          unknown1 : BITCODE_RL;
          unknown2 : BITCODE_RL;
        end;
      Dwg_SummaryInfo = _dwg_summaryinfo;
    { Contains information about the application that wrote
       the .dwg file (encrypted = 2).  }
    { 3 }
    { 2-3 }
    { AppInfoDataList }
    { "19.0.55.0.0", "Teigha(R) 4.3.2.0" }
    { "Autodesk DWG.  This file is a Trusted DWG "... }
    { XML ProductInformation }

      _dwg_appinfo = record
          class_version : BITCODE_RL;
          num_strings : BITCODE_RL;
          appinfo_name : BITCODE_TU;
          version_checksum : array[0..15] of BITCODE_RC;
          comment_checksum : array[0..15] of BITCODE_RC;
          product_checksum : array[0..15] of BITCODE_RC;
          version : BITCODE_TU;
          comment : BITCODE_TU;
          product_info : BITCODE_TU;
        end;
      Dwg_AppInfo = _dwg_appinfo;
    { File Dependencies, IMAGE files, fonts, xrefs, plotconfigs  }
    { Acad:XRef, Acad:Image, Acad:PlotConfig, Acad:Text }

      _dwg_filedeplist = record
          num_features : BITCODE_RL;
          features : ^BITCODE_TU32;
          num_files : BITCODE_RL;
          files : ^Dwg_FileDepList_Files;
        end;
      Dwg_FileDepList = _dwg_filedeplist;
    { password info  }
    { 0xc }
    { 0 }
    { 0xabcdabcd }
    { }
    { "Microsoft Base DSS and Diffie-Hellman }
    { Cryptographic Provider" }
    { RC4 }
    { 40 }
    { }

      _dwg_security = record
          unknown_1 : BITCODE_RL;
          unknown_2 : BITCODE_RL;
          unknown_3 : BITCODE_RL;
          crypto_id : BITCODE_RL;
          crypto_name : BITCODE_TV;
          algo_id : BITCODE_RL;
          key_len : BITCODE_RL;
          encr_size : BITCODE_RL;
          encr_buffer : BITCODE_TF;
        end;
      Dwg_Security = _dwg_security;

      _dwg_vbaproject = record
          size : longint;
          unknown_bits : BITCODE_TF;
        end;
      Dwg_VBAProject = _dwg_vbaproject;

      _dwg_appinfohistory = record
          size : longint;
          unknown_bits : BITCODE_TF;
        end;
      Dwg_AppInfoHistory = _dwg_appinfohistory;

      _dwg_revhistory = record
          class_version : BITCODE_RL;
          class_minor : BITCODE_RL;
          num_histories : BITCODE_RL;
          histories : ^BITCODE_RL;
        end;
      Dwg_RevHistory = _dwg_revhistory;
    { RLL (uint64_t) or uint128_t }
    { 0x32 }
    { 0x64 }
    { 0x200 }

      _dwg_objfreespace = record
          zero : BITCODE_RLL;
          num_handles : BITCODE_RLL;
          TDUPDATE : BITCODE_TIMERLL;
          objects_address : BITCODE_RL;
          num_nums : BITCODE_RC;
          max32 : BITCODE_RLL;
          max64 : BITCODE_RLL;
          maxtbl : BITCODE_RLL;
          maxrl : BITCODE_RLL;
          max32_hi : BITCODE_RLL;
          max64_hi : BITCODE_RLL;
          maxtbl_hi : BITCODE_RLL;
          maxrl_hi : BITCODE_RLL;
        end;
      Dwg_ObjFreeSpace = _dwg_objfreespace;

      _dwg_template = record
          description : BITCODE_T16;
          MEASUREMENT : BITCODE_RS;
        end;
      Dwg_Template = _dwg_template;
    {!< r14 only  }
    {!< r14 only  }

      _dwg_second_header = record
          size : BITCODE_RL;
          address : BITCODE_RL;
          version : array[0..11] of BITCODE_RC;
          null_b : array[0..3] of BITCODE_B;
          unknown_10 : BITCODE_RC;
          unknown_rc4 : array[0..3] of BITCODE_RC;
          num_sections : BITCODE_RC;
          section : array[0..5] of record
              nr : BITCODE_RC;
              address : BITCODE_BL;
              size : BITCODE_BL;
            end;
          num_handlers : BITCODE_BS;
          handlers : array[0..15] of record
              size : BITCODE_RC;
              nr : BITCODE_RC;
              data : ^BITCODE_RC;
            end;
          junk_r14_1 : BITCODE_RL;
          junk_r14_2 : BITCODE_RL;
        end;
      Dwg_Second_Header = _dwg_second_header;
    {*
     Main DWG struct
      }
    {!< number of classes  }
    {!< array of classes  }
    {!< number of objects  }
    {!< room for objects  }
    {!< list of all objects and entities  }
    {!< number of entities in object  }
    {!< number of object_ref's (resolved handles)  }
    {!< how many we have written currently  }
    {!< array of most handles  }
    {!< map of all handles  }
    { 1 if we added an entity, and invalidated all
                                        the internal ref->obj's  }
    { See DWG_OPTS_* below  }
    { encrypted, packed  }
    { Should only be initialized after the read/write is complete.  }
    { This TABLE might be empty with num_entries=0  }
    { #define DWG_AUXHEADER_SIZE 123  }
    { Contains information about the application that wrote
         the .dwg file (encrypted = 2).  }
    { File Dependencies, IMAGE files, fonts, xrefs, plotconfigs  }
    { password info  }
    { temporary, until we can parse acds for SAB data, r2013+ }
    { for add_document handle holes }
      PDwg_Object_Ref=^Dwg_Object_Ref;
      _dwg_struct = record
          header : Dwg_Header;
          num_classes : BITCODE_BS;
          dwg_class : ^Dwg_Class;
          num_objects : BITCODE_BL;
          num_alloced_objects : BITCODE_BL;
          &object : ^Dwg_Object;
          num_entities : BITCODE_BL;
          num_object_refs : BITCODE_BL;
          cur_index : BITCODE_BL;
          object_ref : ^PDwg_Object_Ref;
          object_map : {^_inthash}pointer;
          dirty_refs : longint;
          opts : dword;
          header_vars : Dwg_Header_Variables;
          thumbnail : Dwg_Chain;
          r2004_header : Dwg_R2004_Header;
          mspace_block : ^Dwg_Object;
          pspace_block : ^Dwg_Object;
          block_control : Dwg_Object_BLOCK_CONTROL;
          auxheader : Dwg_AuxHeader;
          summaryinfo : Dwg_SummaryInfo;
          appinfo : Dwg_AppInfo;
          filedeplist : Dwg_FileDepList;
          security : Dwg_Security;
          vbaproject : Dwg_VBAProject;
          appinfohistory : Dwg_AppInfoHistory;
          revhistory : Dwg_RevHistory;
          objfreespace : Dwg_ObjFreeSpace;
          Template : Dwg_Template;
          acds : Dwg_AcDs;
          second_header : Dwg_Second_Header;
          layout_type : dword;
          num_acis_sab_hdl : dword;
          acis_sab_hdl : ^BITCODE_H;
          next_hdl : dword;
        end;
      Dwg_Data = _dwg_struct;
      PDwg_Data=^Dwg_Data;

      RESBUF_VALUE_TYPE = (DWG_VT_INVALID := 0,DWG_VT_STRING := 1,
        DWG_VT_POINT3D := 2,DWG_VT_REAL := 3,
        DWG_VT_INT16 := 4,DWG_VT_INT32 := 5,
        DWG_VT_INT8 := 6,DWG_VT_BINARY := 7,
        DWG_VT_HANDLE := 8,DWG_VT_OBJECTID := 9,
        DWG_VT_BOOL := 10,DWG_VT_INT64 := 11
        );
      Dwg_Resbuf_Value_Type = RESBUF_VALUE_TYPE;
    {--------------------------------------------------
     * Exported Functions
      }
(* error 
EXPORT int dwg_read_file (const char *restrict filename,
in declaration at line 9224 *)
(* error 
EXPORT int dxf_read_file (const char *restrict filename,
in declaration at line 9226 *)
    { You might need to probe for that. }
(* error 
EXPORT int dwg_write_file (const char *restrict filename,
in declaration at line 9229 *)
(* error 
EXPORT unsigned char *dwg_bmp (const Dwg_Data *restrict, BITCODE_RL *restrict);
in declaration at line 9231 *)
    {* Converts the internal enum RC into 100th mm lineweight, with
     *  -1 BYLAYER, -2 BYBLOCK, -3 BYLWDEFAULT.
      }
(* error 
EXPORT int dxf_cvt_lweight (const BITCODE_BSd value);
in declaration at line 9236 *)
    {* Converts the 100th mm lineweight, with -1 BYLAYER, -2 BYBLOCK, -3 BYLWDEFAULT,
        into the internal enum RC.
      }
(* error 
EXPORT BITCODE_BSd dxf_revcvt_lweight (const int lw);
 in declarator_list *)
    { Return the matching _CONTROL table, or NULL
      }
(* error 
dwg_ctrl_table (Dwg_Data *restrict dwg, const char *restrict table);
(* error 
dwg_ctrl_table (Dwg_Data *restrict dwg, const char *restrict table);
 in declarator_list *)
 in declarator_list *)
    { Search for the name in the associated table, and return its handle. Search
     * is case-insensitive.
     * Both name and table are ascii.
      }
(* error 
EXPORT BITCODE_H dwg_find_tablehandle (Dwg_Data *restrict dwg,
(* error 
                                       const char *restrict name,
(* error 
                                       const char *restrict table);
 in declarator_list *)
 in declarator_list *)
 in declarator_list *)
    { Search for handle in associated table, and return its name (as UTF-8)  }
(* error 
EXPORT char *
in declaration at line 9260 *)
    {* Not checking the header_vars entry, only searching the objects
     *  Returning a hardowner or hardpointer (DICTIONARY) ref (code 3 or 5)
     *  to it, as stored in header_vars. table must contain the "_CONTROL" suffix.
     *  table is ascii.
      }
(* error 
EXPORT BITCODE_H dwg_find_table_control (Dwg_Data *restrict dwg,
(* error 
                                         const char *restrict table);
 in declarator_list *)
 in declarator_list *)
    {* Search for a dictionary ref.
     *  Returning a hardpointer ref (5) to it, as stored in header_vars.
     *  Name is ascii.
      }
(* error 
EXPORT BITCODE_H dwg_find_dictionary (Dwg_Data *restrict dwg,
(* error 
                                      const char *restrict name);
 in declarator_list *)
 in declarator_list *)
    {* Search for a named dictionary entry in the given dict.
     *  Search is case-sensitive. name is ASCII.  }
(* error 
EXPORT BITCODE_H dwg_find_dicthandle (Dwg_Data *restrict dwg, BITCODE_H dict,
(* error 
EXPORT BITCODE_H dwg_find_dicthandle (Dwg_Data *restrict dwg, BITCODE_H dict,
(* error 
                                      const char *restrict name);
 in declarator_list *)
 in declarator_list *)
 in declarator_list *)
    {* Search all dictionary entries in the given dict.
     *  Check for the matching name of the handle object. (Control lists).
     *  Search is case-insensitive  }
(* error 
EXPORT BITCODE_H dwg_find_dicthandle_objname (Dwg_Data *restrict dwg, BITCODE_H dict,
(* error 
EXPORT BITCODE_H dwg_find_dicthandle_objname (Dwg_Data *restrict dwg, BITCODE_H dict,
(* error 
                                              const char *restrict name);
 in declarator_list *)
 in declarator_list *)
 in declarator_list *)
    { Search for a table EXTNAME  }
(* error 
EXPORT char *dwg_find_table_extname (Dwg_Data *restrict dwg,
in declaration at line 9287 *)
    { Returns the string value of the member of the AcDbVariableDictionary.
       The name is ascii. E.g. LIGHTINGUNITS => "0"  }
(* error 
EXPORT char *dwg_variable_dict (Dwg_Data *restrict dwg,
in declaration at line 9291 *)
(* error 
EXPORT double dwg_model_x_min (const Dwg_Data *restrict);
 in declarator_list *)
(* error 
EXPORT double dwg_model_x_max (const Dwg_Data *restrict);
 in declarator_list *)
(* error 
EXPORT double dwg_model_y_min (const Dwg_Data *restrict);
 in declarator_list *)
(* error 
EXPORT double dwg_model_y_max (const Dwg_Data *restrict);
 in declarator_list *)
(* error 
EXPORT double dwg_model_z_min (const Dwg_Data *restrict);
 in declarator_list *)
(* error 
EXPORT double dwg_model_z_max (const Dwg_Data *restrict);
 in declarator_list *)
(* error 
EXPORT double dwg_page_x_min (const Dwg_Data *restrict);
 in declarator_list *)
(* error 
EXPORT double dwg_page_x_max (const Dwg_Data *restrict);
 in declarator_list *)
(* error 
EXPORT double dwg_page_y_min (const Dwg_Data *restrict);
 in declarator_list *)
(* error 
EXPORT double dwg_page_y_max (const Dwg_Data *restrict);
 in declarator_list *)
(* error 
EXPORT Dwg_Object_BLOCK_CONTROL * dwg_block_control (Dwg_Data *restrict dwg);
 in declarator_list *)
(* error 
EXPORT Dwg_Object_Ref * dwg_model_space_ref (Dwg_Data *restrict dwg);
 in declarator_list *)
(* error 
EXPORT Dwg_Object_Ref * dwg_paper_space_ref (Dwg_Data *restrict dwg);
 in declarator_list *)
(* error 
EXPORT Dwg_Object * dwg_model_space_object (Dwg_Data *restrict dwg);
 in declarator_list *)
(* error 
EXPORT Dwg_Object * dwg_paper_space_object (Dwg_Data *restrict dwg);
 in declarator_list *)
(* error 
EXPORT unsigned int dwg_get_layer_count (const Dwg_Data *restrict dwg);
in declaration at line 9311 *)
(* error 
EXPORT Dwg_Object_LAYER ** dwg_get_layers (const Dwg_Data *restrict dwg);
 in declarator_list *)
(* error 
EXPORT BITCODE_BL dwg_get_num_objects (const Dwg_Data *restrict dwg);
 in declarator_list *)
(* error 
EXPORT BITCODE_BL dwg_get_object_num_objects (const Dwg_Data *restrict dwg);
 in declarator_list *)
(* error 
EXPORT int dwg_class_is_entity (const Dwg_Class *restrict klass);
in declaration at line 9319 *)
(* error 
EXPORT int dwg_obj_is_control (const Dwg_Object *restrict obj);
in declaration at line 9321 *)
(* error 
EXPORT int dwg_obj_is_table (const Dwg_Object *restrict obj);
in declaration at line 9322 *)
(* error 
EXPORT int dwg_obj_is_subentity (const Dwg_Object *restrict obj);
in declaration at line 9323 *)
(* error 
EXPORT int dwg_obj_has_subentity (const Dwg_Object *restrict obj);
in declaration at line 9324 *)
(* error 
EXPORT int dwg_obj_is_3dsolid (const Dwg_Object *restrict obj);
in declaration at line 9325 *)
(* error 
EXPORT int dwg_obj_is_acsh (const Dwg_Object *restrict obj);
in declaration at line 9326 *)
(* error 
EXPORT BITCODE_BL dwg_get_num_entities (const Dwg_Data *restrict);
 in declarator_list *)
(* error 
EXPORT Dwg_Object_Entity **dwg_get_entities (const Dwg_Data *restrict);
 in declarator_list *)
(* error 
EXPORT Dwg_Object_LAYER *
 in declarator_list *)
(* error 
EXPORT Dwg_Object *dwg_next_object (const Dwg_Object *obj);
 in declarator_list *)
(* error 
EXPORT Dwg_Object *dwg_next_entity (const Dwg_Object *obj);
 in declarator_list *)
(* error 
EXPORT unsigned long dwg_next_handle (const Dwg_Data *dwg);
in declaration at line 9337 *)
(* error 
EXPORT Dwg_Object *dwg_ref_object (const Dwg_Data *restrict dwg,
(* error 
                                   Dwg_Object_Ref *restrict ref);
 in declarator_list *)
 in declarator_list *)
(* error 
EXPORT Dwg_Object *dwg_ref_object_relative (const Dwg_Data *restrict dwg,
(* error 
                                            Dwg_Object_Ref *restrict ref,
(* error 
                                            const Dwg_Object *restrict obj);
 in declarator_list *)
 in declarator_list *)
 in declarator_list *)
(* error 
EXPORT Dwg_Object *dwg_ref_object_silent (const Dwg_Data *restrict dwg,
(* error 
                                          Dwg_Object_Ref *restrict ref);
 in declarator_list *)
 in declarator_list *)
(* error 
EXPORT Dwg_Object *get_first_owned_entity (const Dwg_Object *restrict hdr);
 in declarator_list *)
(* error 
EXPORT Dwg_Object *get_next_owned_entity (const Dwg_Object *restrict hdr,
(* error 
                                          const Dwg_Object *restrict current);
 in declarator_list *)
 in declarator_list *)
(* error 
EXPORT Dwg_Object *get_first_owned_subentity (const Dwg_Object *restrict owner);
 in declarator_list *)
(* error 
EXPORT Dwg_Object *
(* error 
                          const Dwg_Object *restrict current);
 in declarator_list *)
 in declarator_list *)
(* error 
EXPORT Dwg_Object *get_first_owned_block (const Dwg_Object *hdr);
 in declarator_list *)
(* error 
EXPORT Dwg_Object *get_last_owned_block (const Dwg_Object *hdr);
 in declarator_list *)
(* error 
EXPORT Dwg_Object *get_next_owned_block (const Dwg_Object *restrict hdr,
(* error 
                                         const Dwg_Object *restrict current);
 in declarator_list *)
 in declarator_list *)
(* error 
EXPORT Dwg_Object *get_next_owned_block_entity (const Dwg_Object *restrict hdr,
(* error 
                                                const Dwg_Object *restrict current);
 in declarator_list *)
 in declarator_list *)
(* error 
EXPORT Dwg_Object *dwg_get_first_object (const Dwg_Data *dwg,
(* error 
                                         const Dwg_Object_Type type);
 in declarator_list *)
 in declarator_list *)
(* error 
EXPORT Dwg_Object *dwg_resolve_handle (const Dwg_Data *restrict dwg,
(* error 
                                       const unsigned long absref);
 in declarator_list *)
 in declarator_list *)
(* error 
EXPORT Dwg_Object *dwg_resolve_handle_silent (const Dwg_Data *restrict dwg,
(* error 
                                              const BITCODE_BL absref);
 in declarator_list *)
 in declarator_list *)
(* error 
EXPORT int dwg_resolve_handleref (Dwg_Object_Ref *restrict ref,
in declaration at line 9369 *)
(* error 
EXPORT Dwg_Section_Type dwg_section_type (const char *restrict name);
 in declarator_list *)
(* error 
EXPORT Dwg_Section_Type dwg_section_wtype (const DWGCHAR *restrict wname);
 in declarator_list *)
(* error 
EXPORT const char *dwg_section_name (const Dwg_Data *dwg, const unsigned int sec_id);
(* error 
EXPORT const char *dwg_section_name (const Dwg_Data *dwg, const unsigned int sec_id);
 in declarator_list *)
 in declarator_list *)
(* error 
EXPORT enum RESBUF_VALUE_TYPE dwg_resbuf_value_type (short gc);
in declaration at line 9375 *)
    {* Free the whole DWG. all tables, sections, objects, ...
     }
(* error 
EXPORT void dwg_free (Dwg_Data *restrict dwg);
in declaration at line 9379 *)
    {* Free the object (all three structs and its fields)
     }
(* error 
EXPORT void dwg_free_object (Dwg_Object *restrict obj);
in declaration at line 9383 *)
    {* Add the empty ref to the DWG (freshly malloc'ed), or NULL.
     }
(* error 
EXPORT Dwg_Object_Ref * dwg_new_ref (Dwg_Data *restrict dwg);
 in declarator_list *)
    {* For encode:
     *  May need obj to shorten the code to a relative offset, but not in header_vars.
     *  There obj is NULL.
      }
(* error 
EXPORT int dwg_add_handle (Dwg_Handle *restrict hdl, const BITCODE_RC code,
in declaration at line 9395 *)
    {* Returns an existing ref with the same ownership (hard/soft, owner/pointer)
        or creates it. With obj non-NULL it may return a relative offset, otherwise
        always absolute.
     }
(* error 
EXPORT Dwg_Object_Ref *dwg_add_handleref (Dwg_Data *restrict dwg,
(* error 
                                          const BITCODE_RC code,
(* error 
                                          const unsigned long value,
(* error 
                                          const Dwg_Object *restrict obj);
 in declarator_list *)
 in declarator_list *)
 in declarator_list *)
 in declarator_list *)
    {* Return a link to the global ref or a new one. Or a NULLHDL.  }
(* error 
EXPORT Dwg_Object_Ref *
(* error 
dwg_dup_handleref (Dwg_Data *restrict dwg, const Dwg_Object_Ref *restrict ref);
 in declarator_list *)
 in declarator_list *)
    {* Creates a non-global, free'able handle ref. Never relative  }
(* error 
EXPORT Dwg_Object_Ref *
(* error 
dwg_add_handleref_free (const BITCODE_RC code, const unsigned long absref);
 in declarator_list *)
 in declarator_list *)
(* error 
EXPORT const char *dwg_version_type (const Dwg_Version_Type version);
 in declarator_list *)
(* error 
EXPORT Dwg_Version_Type dwg_version_as (const char *version);
 in declarator_list *)
(* error 
EXPORT Dwg_Version_Type dwg_version_hdr_type (const char* hdr);
 in declarator_list *)
(* error 
EXPORT void dwg_errstrings (int error);
in declaration at line 9416 *)
(* error 
EXPORT char *dwg_encrypt_SAT1 (BITCODE_BL blocksize,
in declaration at line 9420 *)
    { Converts v2 SAB acis_data in-place to SAT v1 encr_sat_data[].
       Sets _obj->_dxf_sab_converted to 1, denoting that encr_sat_data is NOT the
       encrypted acis_data anymore, rather the converted from SAB for DXF  }
(* error 
EXPORT int dwg_convert_SAB_to_SAT1 (Dwg_Entity_3DSOLID *restrict _obj);
in declaration at line 9424 *)
    { The old color.index 0-256  }

      rgbpalette = record
          r : byte;
          g : byte;
          b : byte;
        end;
      Dwg_RGB_Palette = rgbpalette;
(* error 
EXPORT const Dwg_RGB_Palette *dwg_rgb_palette (void);
 in declarator_list *)
    { Returns the RGB value for the palette index.
      }
(* error 
EXPORT BITCODE_BL dwg_rgb_palette_index (BITCODE_BS index);
 in declarator_list *)
    { find a matching color index (0-255) for a truecolor rgb value.
       returns 256 if not found, i.e. the default ByLayer.
      }
(* error 
EXPORT BITCODE_BS dwg_find_color_index (BITCODE_BL rgb);
 in declarator_list *)
    {* Add the empty object to the DWG.
        Returns DWG_ERR_OUTOFMEM, -1 for realloced or 0 if not.
        objects are allocated in bulk, and all old obj pointers may become invalid.
        The new object is at &dwg->object[dwg->num_objects - 1].
     }
(* error 
EXPORT int dwg_add_object (Dwg_Data *restrict dwg);
in declaration at line 9445 *)
    { Find if an object name (our internal name, not anything used elsewhere)
       is defined, and return our fixed type, the public dxfname and if it's an entity.  }
(* error 
EXPORT int dwg_object_name (const char *const restrict name, // in
    { in }
    { out, maybe NULL }
    { out, maybe NULL }
    { out, maybe NULL }
in declaration at line 9453 *)
    { out, maybe NULL }
    {* Initialize the empty entity or object with its three structs.
        All fields are zero'd, some are initialized with default values, as
        defined in dwg.spec. obj->fixedtype is set, obj->type only for static types.
        Use dwg_encode_get_class for the variable types.
        Returns 0 or DWG_ERR_OUTOFMEM.
     }
    { Start auto-generated content. Do not touch.  }
(* error 
EXPORT int dwg_setup__3DFACE (Dwg_Object *obj);
in declaration at line 9462 *)
(* error 
EXPORT int dwg_setup__3DSOLID (Dwg_Object *obj);
in declaration at line 9463 *)
(* error 
EXPORT int dwg_setup_ARC (Dwg_Object *obj);
in declaration at line 9464 *)
(* error 
EXPORT int dwg_setup_ATTDEF (Dwg_Object *obj);
in declaration at line 9465 *)
(* error 
EXPORT int dwg_setup_ATTRIB (Dwg_Object *obj);
in declaration at line 9466 *)
(* error 
EXPORT int dwg_setup_BLOCK (Dwg_Object *obj);
in declaration at line 9467 *)
(* error 
EXPORT int dwg_setup_BODY (Dwg_Object *obj);
in declaration at line 9468 *)
(* error 
EXPORT int dwg_setup_CIRCLE (Dwg_Object *obj);
in declaration at line 9469 *)
(* error 
EXPORT int dwg_setup_DIMENSION_ALIGNED (Dwg_Object *obj);
in declaration at line 9470 *)
(* error 
EXPORT int dwg_setup_DIMENSION_ANG2LN (Dwg_Object *obj);
in declaration at line 9471 *)
(* error 
EXPORT int dwg_setup_DIMENSION_ANG3PT (Dwg_Object *obj);
in declaration at line 9472 *)
(* error 
EXPORT int dwg_setup_DIMENSION_DIAMETER (Dwg_Object *obj);
in declaration at line 9473 *)
(* error 
EXPORT int dwg_setup_DIMENSION_LINEAR (Dwg_Object *obj);
in declaration at line 9474 *)
(* error 
EXPORT int dwg_setup_DIMENSION_ORDINATE (Dwg_Object *obj);
in declaration at line 9475 *)
(* error 
EXPORT int dwg_setup_DIMENSION_RADIUS (Dwg_Object *obj);
in declaration at line 9476 *)
(* error 
EXPORT int dwg_setup_ELLIPSE (Dwg_Object *obj);
in declaration at line 9477 *)
(* error 
EXPORT int dwg_setup_ENDBLK (Dwg_Object *obj);
in declaration at line 9478 *)
(* error 
EXPORT int dwg_setup_INSERT (Dwg_Object *obj);
in declaration at line 9479 *)
(* error 
EXPORT int dwg_setup_LEADER (Dwg_Object *obj);
in declaration at line 9480 *)
(* error 
EXPORT int dwg_setup_LINE (Dwg_Object *obj);
in declaration at line 9481 *)
(* error 
EXPORT int dwg_setup_LOAD (Dwg_Object *obj);
in declaration at line 9482 *)
(* error 
EXPORT int dwg_setup_MINSERT (Dwg_Object *obj);
in declaration at line 9483 *)
(* error 
EXPORT int dwg_setup_MLINE (Dwg_Object *obj);
in declaration at line 9484 *)
(* error 
EXPORT int dwg_setup_MTEXT (Dwg_Object *obj);
in declaration at line 9485 *)
(* error 
EXPORT int dwg_setup_OLEFRAME (Dwg_Object *obj);
in declaration at line 9486 *)
(* error 
EXPORT int dwg_setup_POINT (Dwg_Object *obj);
in declaration at line 9487 *)
(* error 
EXPORT int dwg_setup_POLYLINE_2D (Dwg_Object *obj);
in declaration at line 9488 *)
(* error 
EXPORT int dwg_setup_POLYLINE_3D (Dwg_Object *obj);
in declaration at line 9489 *)
(* error 
EXPORT int dwg_setup_POLYLINE_MESH (Dwg_Object *obj);
in declaration at line 9490 *)
(* error 
EXPORT int dwg_setup_POLYLINE_PFACE (Dwg_Object *obj);
in declaration at line 9491 *)
(* error 
EXPORT int dwg_setup_PROXY_ENTITY (Dwg_Object *obj);
in declaration at line 9492 *)
(* error 
EXPORT int dwg_setup_RAY (Dwg_Object *obj);
in declaration at line 9493 *)
(* error 
EXPORT int dwg_setup_REGION (Dwg_Object *obj);
in declaration at line 9494 *)
(* error 
EXPORT int dwg_setup_SEQEND (Dwg_Object *obj);
in declaration at line 9495 *)
(* error 
EXPORT int dwg_setup_SHAPE (Dwg_Object *obj);
in declaration at line 9496 *)
(* error 
EXPORT int dwg_setup_SOLID (Dwg_Object *obj);
in declaration at line 9497 *)
(* error 
EXPORT int dwg_setup_SPLINE (Dwg_Object *obj);
in declaration at line 9498 *)
(* error 
EXPORT int dwg_setup_TEXT (Dwg_Object *obj);
in declaration at line 9499 *)
(* error 
EXPORT int dwg_setup_TOLERANCE (Dwg_Object *obj);
in declaration at line 9500 *)
(* error 
EXPORT int dwg_setup_TRACE (Dwg_Object *obj);
in declaration at line 9501 *)
(* error 
EXPORT int dwg_setup_UNKNOWN_ENT (Dwg_Object *obj);
in declaration at line 9502 *)
(* error 
EXPORT int dwg_setup_VERTEX_2D (Dwg_Object *obj);
in declaration at line 9503 *)
(* error 
EXPORT int dwg_setup_VERTEX_3D (Dwg_Object *obj);
in declaration at line 9504 *)
(* error 
EXPORT int dwg_setup_VERTEX_MESH (Dwg_Object *obj);
in declaration at line 9505 *)
(* error 
EXPORT int dwg_setup_VERTEX_PFACE (Dwg_Object *obj);
in declaration at line 9506 *)
(* error 
EXPORT int dwg_setup_VERTEX_PFACE_FACE (Dwg_Object *obj);
in declaration at line 9507 *)
(* error 
EXPORT int dwg_setup_VIEWPORT (Dwg_Object *obj);
in declaration at line 9508 *)
(* error 
EXPORT int dwg_setup_XLINE (Dwg_Object *obj);
in declaration at line 9509 *)
(* error 
EXPORT int dwg_setup_APPID (Dwg_Object *obj);
in declaration at line 9510 *)
(* error 
EXPORT int dwg_setup_APPID_CONTROL (Dwg_Object *obj);
in declaration at line 9511 *)
(* error 
EXPORT int dwg_setup_BLOCK_CONTROL (Dwg_Object *obj);
in declaration at line 9512 *)
(* error 
EXPORT int dwg_setup_BLOCK_HEADER (Dwg_Object *obj);
in declaration at line 9513 *)
(* error 
EXPORT int dwg_setup_DICTIONARY (Dwg_Object *obj);
in declaration at line 9514 *)
(* error 
EXPORT int dwg_setup_DIMSTYLE (Dwg_Object *obj);
in declaration at line 9515 *)
(* error 
EXPORT int dwg_setup_DIMSTYLE_CONTROL (Dwg_Object *obj);
in declaration at line 9516 *)
(* error 
EXPORT int dwg_setup_DUMMY (Dwg_Object *obj);
in declaration at line 9517 *)
(* error 
EXPORT int dwg_setup_LAYER (Dwg_Object *obj);
in declaration at line 9518 *)
(* error 
EXPORT int dwg_setup_LAYER_CONTROL (Dwg_Object *obj);
in declaration at line 9519 *)
(* error 
EXPORT int dwg_setup_LONG_TRANSACTION (Dwg_Object *obj);
in declaration at line 9520 *)
(* error 
EXPORT int dwg_setup_LTYPE (Dwg_Object *obj);
in declaration at line 9521 *)
(* error 
EXPORT int dwg_setup_LTYPE_CONTROL (Dwg_Object *obj);
in declaration at line 9522 *)
(* error 
EXPORT int dwg_setup_MLINESTYLE (Dwg_Object *obj);
in declaration at line 9523 *)
(* error 
EXPORT int dwg_setup_STYLE (Dwg_Object *obj);
in declaration at line 9524 *)
(* error 
EXPORT int dwg_setup_STYLE_CONTROL (Dwg_Object *obj);
in declaration at line 9525 *)
(* error 
EXPORT int dwg_setup_UCS (Dwg_Object *obj);
in declaration at line 9526 *)
(* error 
EXPORT int dwg_setup_UCS_CONTROL (Dwg_Object *obj);
in declaration at line 9527 *)
(* error 
EXPORT int dwg_setup_UNKNOWN_OBJ (Dwg_Object *obj);
in declaration at line 9528 *)
(* error 
EXPORT int dwg_setup_VIEW (Dwg_Object *obj);
in declaration at line 9529 *)
(* error 
EXPORT int dwg_setup_VIEW_CONTROL (Dwg_Object *obj);
in declaration at line 9530 *)
(* error 
EXPORT int dwg_setup_VPORT (Dwg_Object *obj);
in declaration at line 9531 *)
(* error 
EXPORT int dwg_setup_VPORT_CONTROL (Dwg_Object *obj);
in declaration at line 9532 *)
(* error 
EXPORT int dwg_setup_VX_CONTROL (Dwg_Object *obj);
in declaration at line 9533 *)
(* error 
EXPORT int dwg_setup_VX_TABLE_RECORD (Dwg_Object *obj);
in declaration at line 9534 *)
    { untyped > 500  }
(* error 
EXPORT int dwg_setup_CAMERA (Dwg_Object *obj);
in declaration at line 9536 *)
(* error 
EXPORT int dwg_setup_DGNUNDERLAY (Dwg_Object *obj);
in declaration at line 9537 *)
(* error 
EXPORT int dwg_setup_DWFUNDERLAY (Dwg_Object *obj);
in declaration at line 9538 *)
(* error 
EXPORT int dwg_setup_HATCH (Dwg_Object *obj);
in declaration at line 9539 *)
(* error 
EXPORT int dwg_setup_IMAGE (Dwg_Object *obj);
in declaration at line 9540 *)
(* error 
EXPORT int dwg_setup_LIGHT (Dwg_Object *obj);
in declaration at line 9541 *)
(* error 
EXPORT int dwg_setup_LWPOLYLINE (Dwg_Object *obj);
in declaration at line 9542 *)
(* error 
EXPORT int dwg_setup_MESH (Dwg_Object *obj);
in declaration at line 9543 *)
(* error 
EXPORT int dwg_setup_MULTILEADER (Dwg_Object *obj);
in declaration at line 9544 *)
(* error 
EXPORT int dwg_setup_OLE2FRAME (Dwg_Object *obj);
in declaration at line 9545 *)
(* error 
EXPORT int dwg_setup_PDFUNDERLAY (Dwg_Object *obj);
in declaration at line 9546 *)
(* error 
EXPORT int dwg_setup_SECTIONOBJECT (Dwg_Object *obj);
in declaration at line 9547 *)
(* error 
EXPORT int dwg_setup_ACSH_BOOLEAN_CLASS (Dwg_Object *obj);
in declaration at line 9548 *)
(* error 
EXPORT int dwg_setup_ACSH_BOX_CLASS (Dwg_Object *obj);
in declaration at line 9549 *)
(* error 
EXPORT int dwg_setup_ACSH_CONE_CLASS (Dwg_Object *obj);
in declaration at line 9550 *)
(* error 
EXPORT int dwg_setup_ACSH_CYLINDER_CLASS (Dwg_Object *obj);
in declaration at line 9551 *)
(* error 
EXPORT int dwg_setup_ACSH_FILLET_CLASS (Dwg_Object *obj);
in declaration at line 9552 *)
(* error 
EXPORT int dwg_setup_ACSH_HISTORY_CLASS (Dwg_Object *obj);
in declaration at line 9553 *)
(* error 
EXPORT int dwg_setup_ACSH_SPHERE_CLASS (Dwg_Object *obj);
in declaration at line 9554 *)
(* error 
EXPORT int dwg_setup_ACSH_TORUS_CLASS (Dwg_Object *obj);
in declaration at line 9555 *)
(* error 
EXPORT int dwg_setup_ACSH_WEDGE_CLASS (Dwg_Object *obj);
in declaration at line 9556 *)
(* error 
EXPORT int dwg_setup_BLOCKALIGNMENTGRIP (Dwg_Object *obj);
in declaration at line 9557 *)
(* error 
EXPORT int dwg_setup_BLOCKALIGNMENTPARAMETER (Dwg_Object *obj);
in declaration at line 9558 *)
(* error 
EXPORT int dwg_setup_BLOCKBASEPOINTPARAMETER (Dwg_Object *obj);
in declaration at line 9559 *)
(* error 
EXPORT int dwg_setup_BLOCKFLIPACTION (Dwg_Object *obj);
in declaration at line 9560 *)
(* error 
EXPORT int dwg_setup_BLOCKFLIPGRIP (Dwg_Object *obj);
in declaration at line 9561 *)
(* error 
EXPORT int dwg_setup_BLOCKFLIPPARAMETER (Dwg_Object *obj);
in declaration at line 9562 *)
(* error 
EXPORT int dwg_setup_BLOCKGRIPLOCATIONCOMPONENT (Dwg_Object *obj);
in declaration at line 9563 *)
(* error 
EXPORT int dwg_setup_BLOCKLINEARGRIP (Dwg_Object *obj);
in declaration at line 9564 *)
(* error 
EXPORT int dwg_setup_BLOCKLOOKUPGRIP (Dwg_Object *obj);
in declaration at line 9565 *)
(* error 
EXPORT int dwg_setup_BLOCKMOVEACTION (Dwg_Object *obj);
in declaration at line 9566 *)
(* error 
EXPORT int dwg_setup_BLOCKROTATEACTION (Dwg_Object *obj);
in declaration at line 9567 *)
(* error 
EXPORT int dwg_setup_BLOCKROTATIONGRIP (Dwg_Object *obj);
in declaration at line 9568 *)
(* error 
EXPORT int dwg_setup_BLOCKSCALEACTION (Dwg_Object *obj);
in declaration at line 9569 *)
(* error 
EXPORT int dwg_setup_BLOCKVISIBILITYGRIP (Dwg_Object *obj);
in declaration at line 9570 *)
(* error 
EXPORT int dwg_setup_CELLSTYLEMAP (Dwg_Object *obj);
in declaration at line 9571 *)
(* error 
EXPORT int dwg_setup_DETAILVIEWSTYLE (Dwg_Object *obj);
in declaration at line 9572 *)
(* error 
EXPORT int dwg_setup_DICTIONARYVAR (Dwg_Object *obj);
in declaration at line 9573 *)
(* error 
EXPORT int dwg_setup_DICTIONARYWDFLT (Dwg_Object *obj);
in declaration at line 9574 *)
(* error 
EXPORT int dwg_setup_DYNAMICBLOCKPURGEPREVENTER (Dwg_Object *obj);
in declaration at line 9575 *)
(* error 
EXPORT int dwg_setup_FIELD (Dwg_Object *obj);
in declaration at line 9576 *)
(* error 
EXPORT int dwg_setup_FIELDLIST (Dwg_Object *obj);
in declaration at line 9577 *)
(* error 
EXPORT int dwg_setup_GEODATA (Dwg_Object *obj);
in declaration at line 9578 *)
(* error 
EXPORT int dwg_setup_GROUP (Dwg_Object *obj);
in declaration at line 9579 *)
(* error 
EXPORT int dwg_setup_IDBUFFER (Dwg_Object *obj);
in declaration at line 9580 *)
(* error 
EXPORT int dwg_setup_IMAGEDEF (Dwg_Object *obj);
in declaration at line 9581 *)
(* error 
EXPORT int dwg_setup_IMAGEDEF_REACTOR (Dwg_Object *obj);
in declaration at line 9582 *)
(* error 
EXPORT int dwg_setup_INDEX (Dwg_Object *obj);
in declaration at line 9583 *)
(* error 
EXPORT int dwg_setup_LAYERFILTER (Dwg_Object *obj);
in declaration at line 9584 *)
(* error 
EXPORT int dwg_setup_LAYER_INDEX (Dwg_Object *obj);
in declaration at line 9585 *)
(* error 
EXPORT int dwg_setup_LAYOUT (Dwg_Object *obj);
in declaration at line 9586 *)
(* error 
EXPORT int dwg_setup_MLEADERSTYLE (Dwg_Object *obj);
in declaration at line 9587 *)
(* error 
EXPORT int dwg_setup_PLACEHOLDER (Dwg_Object *obj);
in declaration at line 9588 *)
(* error 
EXPORT int dwg_setup_PLOTSETTINGS (Dwg_Object *obj);
in declaration at line 9589 *)
(* error 
EXPORT int dwg_setup_RASTERVARIABLES (Dwg_Object *obj);
in declaration at line 9590 *)
(* error 
EXPORT int dwg_setup_SCALE (Dwg_Object *obj);
in declaration at line 9591 *)
(* error 
EXPORT int dwg_setup_SECTIONVIEWSTYLE (Dwg_Object *obj);
in declaration at line 9592 *)
(* error 
EXPORT int dwg_setup_SECTION_MANAGER (Dwg_Object *obj);
in declaration at line 9593 *)
(* error 
EXPORT int dwg_setup_SORTENTSTABLE (Dwg_Object *obj);
in declaration at line 9594 *)
(* error 
EXPORT int dwg_setup_SPATIAL_FILTER (Dwg_Object *obj);
in declaration at line 9595 *)
(* error 
EXPORT int dwg_setup_TABLEGEOMETRY (Dwg_Object *obj);
in declaration at line 9596 *)
(* error 
EXPORT int dwg_setup_VBA_PROJECT (Dwg_Object *obj);
in declaration at line 9597 *)
(* error 
EXPORT int dwg_setup_VISUALSTYLE (Dwg_Object *obj);
in declaration at line 9598 *)
(* error 
EXPORT int dwg_setup_WIPEOUTVARIABLES (Dwg_Object *obj);
in declaration at line 9599 *)
(* error 
EXPORT int dwg_setup_XRECORD (Dwg_Object *obj);
in declaration at line 9600 *)
(* error 
EXPORT int dwg_setup_PDFDEFINITION (Dwg_Object *obj);
in declaration at line 9601 *)
(* error 
EXPORT int dwg_setup_DGNDEFINITION (Dwg_Object *obj);
in declaration at line 9602 *)
(* error 
EXPORT int dwg_setup_DWFDEFINITION (Dwg_Object *obj);
in declaration at line 9603 *)
    { unstable  }
(* error 
EXPORT int dwg_setup__3DLINE (Dwg_Object *obj);
in declaration at line 9605 *)
(* error 
EXPORT int dwg_setup_ARC_DIMENSION (Dwg_Object *obj);
in declaration at line 9606 *)
(* error 
EXPORT int dwg_setup_ENDREP (Dwg_Object *obj);
in declaration at line 9607 *)
(* error 
EXPORT int dwg_setup_HELIX (Dwg_Object *obj);
in declaration at line 9608 *)
(* error 
EXPORT int dwg_setup_LARGE_RADIAL_DIMENSION (Dwg_Object *obj);
in declaration at line 9609 *)
(* error 
EXPORT int dwg_setup_PLANESURFACE (Dwg_Object *obj);
in declaration at line 9610 *)
(* error 
EXPORT int dwg_setup_POINTCLOUD (Dwg_Object *obj);
in declaration at line 9611 *)
(* error 
EXPORT int dwg_setup_POINTCLOUDEX (Dwg_Object *obj);
in declaration at line 9612 *)
(* error 
EXPORT int dwg_setup_REPEAT (Dwg_Object *obj);
in declaration at line 9613 *)
(* error 
EXPORT int dwg_setup_WIPEOUT (Dwg_Object *obj);
in declaration at line 9614 *)
(* error 
EXPORT int dwg_setup_ACSH_BREP_CLASS (Dwg_Object *obj);
in declaration at line 9615 *)
(* error 
EXPORT int dwg_setup_ACSH_CHAMFER_CLASS (Dwg_Object *obj);
in declaration at line 9616 *)
(* error 
EXPORT int dwg_setup_ACSH_PYRAMID_CLASS (Dwg_Object *obj);
in declaration at line 9617 *)
(* error 
EXPORT int dwg_setup_ALDIMOBJECTCONTEXTDATA (Dwg_Object *obj);
in declaration at line 9618 *)
(* error 
EXPORT int dwg_setup_ASSOC2DCONSTRAINTGROUP (Dwg_Object *obj);
in declaration at line 9619 *)
(* error 
EXPORT int dwg_setup_ASSOCACTION (Dwg_Object *obj);
in declaration at line 9620 *)
(* error 
EXPORT int dwg_setup_ASSOCACTIONPARAM (Dwg_Object *obj);
in declaration at line 9621 *)
(* error 
EXPORT int dwg_setup_ASSOCARRAYACTIONBODY (Dwg_Object *obj);
in declaration at line 9622 *)
(* error 
EXPORT int dwg_setup_ASSOCASMBODYACTIONPARAM (Dwg_Object *obj);
in declaration at line 9623 *)
(* error 
EXPORT int dwg_setup_ASSOCBLENDSURFACEACTIONBODY (Dwg_Object *obj);
in declaration at line 9624 *)
(* error 
EXPORT int dwg_setup_ASSOCCOMPOUNDACTIONPARAM (Dwg_Object *obj);
in declaration at line 9625 *)
(* error 
EXPORT int dwg_setup_ASSOCDEPENDENCY (Dwg_Object *obj);
in declaration at line 9626 *)
(* error 
EXPORT int dwg_setup_ASSOCDIMDEPENDENCYBODY (Dwg_Object *obj);
in declaration at line 9627 *)
(* error 
EXPORT int dwg_setup_ASSOCEXTENDSURFACEACTIONBODY (Dwg_Object *obj);
in declaration at line 9628 *)
(* error 
EXPORT int dwg_setup_ASSOCEXTRUDEDSURFACEACTIONBODY (Dwg_Object *obj);
in declaration at line 9629 *)
(* error 
EXPORT int dwg_setup_ASSOCFACEACTIONPARAM (Dwg_Object *obj);
in declaration at line 9630 *)
(* error 
EXPORT int dwg_setup_ASSOCFILLETSURFACEACTIONBODY (Dwg_Object *obj);
in declaration at line 9631 *)
(* error 
EXPORT int dwg_setup_ASSOCGEOMDEPENDENCY (Dwg_Object *obj);
in declaration at line 9632 *)
(* error 
EXPORT int dwg_setup_ASSOCLOFTEDSURFACEACTIONBODY (Dwg_Object *obj);
in declaration at line 9633 *)
(* error 
EXPORT int dwg_setup_ASSOCNETWORK (Dwg_Object *obj);
in declaration at line 9634 *)
(* error 
EXPORT int dwg_setup_ASSOCNETWORKSURFACEACTIONBODY (Dwg_Object *obj);
in declaration at line 9635 *)
(* error 
EXPORT int dwg_setup_ASSOCOBJECTACTIONPARAM (Dwg_Object *obj);
in declaration at line 9636 *)
(* error 
EXPORT int dwg_setup_ASSOCOFFSETSURFACEACTIONBODY (Dwg_Object *obj);
in declaration at line 9637 *)
(* error 
EXPORT int dwg_setup_ASSOCOSNAPPOINTREFACTIONPARAM (Dwg_Object *obj);
in declaration at line 9638 *)
(* error 
EXPORT int dwg_setup_ASSOCPATCHSURFACEACTIONBODY (Dwg_Object *obj);
in declaration at line 9639 *)
(* error 
EXPORT int dwg_setup_ASSOCPATHACTIONPARAM (Dwg_Object *obj);
in declaration at line 9640 *)
(* error 
EXPORT int dwg_setup_ASSOCPLANESURFACEACTIONBODY (Dwg_Object *obj);
in declaration at line 9641 *)
(* error 
EXPORT int dwg_setup_ASSOCPOINTREFACTIONPARAM (Dwg_Object *obj);
in declaration at line 9642 *)
(* error 
EXPORT int dwg_setup_ASSOCREVOLVEDSURFACEACTIONBODY (Dwg_Object *obj);
in declaration at line 9643 *)
(* error 
EXPORT int dwg_setup_ASSOCTRIMSURFACEACTIONBODY (Dwg_Object *obj);
in declaration at line 9644 *)
(* error 
EXPORT int dwg_setup_ASSOCVALUEDEPENDENCY (Dwg_Object *obj);
in declaration at line 9645 *)
(* error 
EXPORT int dwg_setup_ASSOCVARIABLE (Dwg_Object *obj);
in declaration at line 9646 *)
(* error 
EXPORT int dwg_setup_ASSOCVERTEXACTIONPARAM (Dwg_Object *obj);
in declaration at line 9647 *)
(* error 
EXPORT int dwg_setup_BLKREFOBJECTCONTEXTDATA (Dwg_Object *obj);
in declaration at line 9648 *)
(* error 
EXPORT int dwg_setup_BLOCKALIGNEDCONSTRAINTPARAMETER (Dwg_Object *obj);
in declaration at line 9649 *)
(* error 
EXPORT int dwg_setup_BLOCKANGULARCONSTRAINTPARAMETER (Dwg_Object *obj);
in declaration at line 9650 *)
(* error 
EXPORT int dwg_setup_BLOCKARRAYACTION (Dwg_Object *obj);
in declaration at line 9651 *)
(* error 
EXPORT int dwg_setup_BLOCKDIAMETRICCONSTRAINTPARAMETER (Dwg_Object *obj);
in declaration at line 9652 *)
(* error 
EXPORT int dwg_setup_BLOCKHORIZONTALCONSTRAINTPARAMETER (Dwg_Object *obj);
in declaration at line 9653 *)
(* error 
EXPORT int dwg_setup_BLOCKLINEARCONSTRAINTPARAMETER (Dwg_Object *obj);
in declaration at line 9654 *)
(* error 
EXPORT int dwg_setup_BLOCKLINEARPARAMETER (Dwg_Object *obj);
in declaration at line 9655 *)
(* error 
EXPORT int dwg_setup_BLOCKLOOKUPACTION (Dwg_Object *obj);
in declaration at line 9656 *)
(* error 
EXPORT int dwg_setup_BLOCKLOOKUPPARAMETER (Dwg_Object *obj);
in declaration at line 9657 *)
(* error 
EXPORT int dwg_setup_BLOCKPARAMDEPENDENCYBODY (Dwg_Object *obj);
in declaration at line 9658 *)
(* error 
EXPORT int dwg_setup_BLOCKPOINTPARAMETER (Dwg_Object *obj);
in declaration at line 9659 *)
(* error 
EXPORT int dwg_setup_BLOCKPOLARGRIP (Dwg_Object *obj);
in declaration at line 9660 *)
(* error 
EXPORT int dwg_setup_BLOCKPOLARPARAMETER (Dwg_Object *obj);
in declaration at line 9661 *)
(* error 
EXPORT int dwg_setup_BLOCKPOLARSTRETCHACTION (Dwg_Object *obj);
in declaration at line 9662 *)
(* error 
EXPORT int dwg_setup_BLOCKRADIALCONSTRAINTPARAMETER (Dwg_Object *obj);
in declaration at line 9663 *)
(* error 
EXPORT int dwg_setup_BLOCKREPRESENTATION (Dwg_Object *obj);
in declaration at line 9664 *)
(* error 
EXPORT int dwg_setup_BLOCKROTATIONPARAMETER (Dwg_Object *obj);
in declaration at line 9665 *)
(* error 
EXPORT int dwg_setup_BLOCKSTRETCHACTION (Dwg_Object *obj);
in declaration at line 9666 *)
(* error 
EXPORT int dwg_setup_BLOCKUSERPARAMETER (Dwg_Object *obj);
in declaration at line 9667 *)
(* error 
EXPORT int dwg_setup_BLOCKVERTICALCONSTRAINTPARAMETER (Dwg_Object *obj);
in declaration at line 9668 *)
(* error 
EXPORT int dwg_setup_BLOCKVISIBILITYPARAMETER (Dwg_Object *obj);
in declaration at line 9669 *)
(* error 
EXPORT int dwg_setup_BLOCKXYGRIP (Dwg_Object *obj);
in declaration at line 9670 *)
(* error 
EXPORT int dwg_setup_BLOCKXYPARAMETER (Dwg_Object *obj);
in declaration at line 9671 *)
(* error 
EXPORT int dwg_setup_DATALINK (Dwg_Object *obj);
in declaration at line 9672 *)
(* error 
EXPORT int dwg_setup_DBCOLOR (Dwg_Object *obj);
in declaration at line 9673 *)
(* error 
EXPORT int dwg_setup_EVALUATION_GRAPH (Dwg_Object *obj);
in declaration at line 9674 *)
(* error 
EXPORT int dwg_setup_FCFOBJECTCONTEXTDATA (Dwg_Object *obj);
in declaration at line 9675 *)
(* error 
EXPORT int dwg_setup_GRADIENT_BACKGROUND (Dwg_Object *obj);
in declaration at line 9676 *)
(* error 
EXPORT int dwg_setup_GROUND_PLANE_BACKGROUND (Dwg_Object *obj);
in declaration at line 9677 *)
(* error 
EXPORT int dwg_setup_IBL_BACKGROUND (Dwg_Object *obj);
in declaration at line 9678 *)
(* error 
EXPORT int dwg_setup_IMAGE_BACKGROUND (Dwg_Object *obj);
in declaration at line 9679 *)
(* error 
EXPORT int dwg_setup_LEADEROBJECTCONTEXTDATA (Dwg_Object *obj);
in declaration at line 9680 *)
(* error 
EXPORT int dwg_setup_LIGHTLIST (Dwg_Object *obj);
in declaration at line 9681 *)
(* error 
EXPORT int dwg_setup_MATERIAL (Dwg_Object *obj);
in declaration at line 9682 *)
(* error 
EXPORT int dwg_setup_MENTALRAYRENDERSETTINGS (Dwg_Object *obj);
in declaration at line 9683 *)
(* error 
EXPORT int dwg_setup_MTEXTOBJECTCONTEXTDATA (Dwg_Object *obj);
in declaration at line 9684 *)
(* error 
EXPORT int dwg_setup_OBJECT_PTR (Dwg_Object *obj);
in declaration at line 9685 *)
(* error 
EXPORT int dwg_setup_PARTIAL_VIEWING_INDEX (Dwg_Object *obj);
in declaration at line 9686 *)
(* error 
EXPORT int dwg_setup_POINTCLOUDCOLORMAP (Dwg_Object *obj);
in declaration at line 9687 *)
(* error 
EXPORT int dwg_setup_POINTCLOUDDEF (Dwg_Object *obj);
in declaration at line 9688 *)
(* error 
EXPORT int dwg_setup_POINTCLOUDDEFEX (Dwg_Object *obj);
in declaration at line 9689 *)
(* error 
EXPORT int dwg_setup_POINTCLOUDDEF_REACTOR (Dwg_Object *obj);
in declaration at line 9690 *)
(* error 
EXPORT int dwg_setup_POINTCLOUDDEF_REACTOR_EX (Dwg_Object *obj);
in declaration at line 9691 *)
(* error 
EXPORT int dwg_setup_PROXY_OBJECT (Dwg_Object *obj);
in declaration at line 9692 *)
(* error 
EXPORT int dwg_setup_RAPIDRTRENDERSETTINGS (Dwg_Object *obj);
in declaration at line 9693 *)
(* error 
EXPORT int dwg_setup_RENDERENTRY (Dwg_Object *obj);
in declaration at line 9694 *)
(* error 
EXPORT int dwg_setup_RENDERENVIRONMENT (Dwg_Object *obj);
in declaration at line 9695 *)
(* error 
EXPORT int dwg_setup_RENDERGLOBAL (Dwg_Object *obj);
in declaration at line 9696 *)
(* error 
EXPORT int dwg_setup_RENDERSETTINGS (Dwg_Object *obj);
in declaration at line 9697 *)
(* error 
EXPORT int dwg_setup_SECTION_SETTINGS (Dwg_Object *obj);
in declaration at line 9698 *)
(* error 
EXPORT int dwg_setup_SKYLIGHT_BACKGROUND (Dwg_Object *obj);
in declaration at line 9699 *)
(* error 
EXPORT int dwg_setup_SOLID_BACKGROUND (Dwg_Object *obj);
in declaration at line 9700 *)
(* error 
EXPORT int dwg_setup_SPATIAL_INDEX (Dwg_Object *obj);
in declaration at line 9701 *)
(* error 
EXPORT int dwg_setup_SUN (Dwg_Object *obj);
in declaration at line 9702 *)
(* error 
EXPORT int dwg_setup_TABLESTYLE (Dwg_Object *obj);
in declaration at line 9703 *)
(* error 
EXPORT int dwg_setup_TEXTOBJECTCONTEXTDATA (Dwg_Object *obj);
in declaration at line 9704 *)
(* error 
EXPORT int dwg_setup_ASSOCARRAYMODIFYPARAMETERS (Dwg_Object *obj);
in declaration at line 9705 *)
(* error 
EXPORT int dwg_setup_ASSOCARRAYPATHPARAMETERS (Dwg_Object *obj);
in declaration at line 9706 *)
(* error 
EXPORT int dwg_setup_ASSOCARRAYPOLARPARAMETERS (Dwg_Object *obj);
in declaration at line 9707 *)
(* error 
EXPORT int dwg_setup_ASSOCARRAYRECTANGULARPARAMETERS (Dwg_Object *obj);
in declaration at line 9708 *)
{$ifdef DEBUG_CLASSES}
(* error 
  EXPORT int dwg_setup_ALIGNMENTPARAMETERENTITY (Dwg_Object *obj);
in declaration at line 9710 *)
(* error 
  EXPORT int dwg_setup_ARCALIGNEDTEXT (Dwg_Object *obj);
in declaration at line 9711 *)
(* error 
  EXPORT int dwg_setup_BASEPOINTPARAMETERENTITY (Dwg_Object *obj);
in declaration at line 9712 *)
(* error 
  EXPORT int dwg_setup_EXTRUDEDSURFACE (Dwg_Object *obj);
in declaration at line 9713 *)
(* error 
  EXPORT int dwg_setup_FLIPGRIPENTITY (Dwg_Object *obj);
in declaration at line 9714 *)
(* error 
  EXPORT int dwg_setup_FLIPPARAMETERENTITY (Dwg_Object *obj);
in declaration at line 9715 *)
(* error 
  EXPORT int dwg_setup_GEOPOSITIONMARKER (Dwg_Object *obj);
in declaration at line 9716 *)
(* error 
  EXPORT int dwg_setup_LINEARGRIPENTITY (Dwg_Object *obj);
in declaration at line 9717 *)
(* error 
  EXPORT int dwg_setup_LINEARPARAMETERENTITY (Dwg_Object *obj);
in declaration at line 9718 *)
(* error 
  EXPORT int dwg_setup_LOFTEDSURFACE (Dwg_Object *obj);
in declaration at line 9719 *)
(* error 
  EXPORT int dwg_setup_MPOLYGON (Dwg_Object *obj);
in declaration at line 9720 *)
(* error 
  EXPORT int dwg_setup_NAVISWORKSMODEL (Dwg_Object *obj);
in declaration at line 9721 *)
(* error 
  EXPORT int dwg_setup_NURBSURFACE (Dwg_Object *obj);
in declaration at line 9722 *)
(* error 
  EXPORT int dwg_setup_POINTPARAMETERENTITY (Dwg_Object *obj);
in declaration at line 9723 *)
(* error 
  EXPORT int dwg_setup_POLARGRIPENTITY (Dwg_Object *obj);
in declaration at line 9724 *)
(* error 
  EXPORT int dwg_setup_REVOLVEDSURFACE (Dwg_Object *obj);
in declaration at line 9725 *)
(* error 
  EXPORT int dwg_setup_ROTATIONGRIPENTITY (Dwg_Object *obj);
in declaration at line 9726 *)
(* error 
  EXPORT int dwg_setup_ROTATIONPARAMETERENTITY (Dwg_Object *obj);
in declaration at line 9727 *)
(* error 
  EXPORT int dwg_setup_RTEXT (Dwg_Object *obj);
in declaration at line 9728 *)
(* error 
  EXPORT int dwg_setup_SWEPTSURFACE (Dwg_Object *obj);
in declaration at line 9729 *)
(* error 
  EXPORT int dwg_setup_TABLE (Dwg_Object *obj);
in declaration at line 9730 *)
(* error 
  EXPORT int dwg_setup_VISIBILITYGRIPENTITY (Dwg_Object *obj);
in declaration at line 9731 *)
(* error 
  EXPORT int dwg_setup_VISIBILITYPARAMETERENTITY (Dwg_Object *obj);
in declaration at line 9732 *)
(* error 
  EXPORT int dwg_setup_XYGRIPENTITY (Dwg_Object *obj);
in declaration at line 9733 *)
(* error 
  EXPORT int dwg_setup_XYPARAMETERENTITY (Dwg_Object *obj);
in declaration at line 9734 *)
(* error 
  EXPORT int dwg_setup_ACMECOMMANDHISTORY (Dwg_Object *obj);
in declaration at line 9735 *)
(* error 
  EXPORT int dwg_setup_ACMESCOPE (Dwg_Object *obj);
in declaration at line 9736 *)
(* error 
  EXPORT int dwg_setup_ACMESTATEMGR (Dwg_Object *obj);
in declaration at line 9737 *)
(* error 
  EXPORT int dwg_setup_ACSH_EXTRUSION_CLASS (Dwg_Object *obj);
in declaration at line 9738 *)
(* error 
  EXPORT int dwg_setup_ACSH_LOFT_CLASS (Dwg_Object *obj);
in declaration at line 9739 *)
(* error 
  EXPORT int dwg_setup_ACSH_REVOLVE_CLASS (Dwg_Object *obj);
in declaration at line 9740 *)
(* error 
  EXPORT int dwg_setup_ACSH_SWEEP_CLASS (Dwg_Object *obj);
in declaration at line 9741 *)
(* error 
  EXPORT int dwg_setup_ANGDIMOBJECTCONTEXTDATA (Dwg_Object *obj);
in declaration at line 9742 *)
(* error 
  EXPORT int dwg_setup_ANNOTSCALEOBJECTCONTEXTDATA (Dwg_Object *obj);
in declaration at line 9743 *)
(* error 
  EXPORT int dwg_setup_ASSOC3POINTANGULARDIMACTIONBODY (Dwg_Object *obj);
in declaration at line 9744 *)
(* error 
  EXPORT int dwg_setup_ASSOCALIGNEDDIMACTIONBODY (Dwg_Object *obj);
in declaration at line 9745 *)
(* error 
  EXPORT int dwg_setup_ASSOCARRAYMODIFYACTIONBODY (Dwg_Object *obj);
in declaration at line 9746 *)
(* error 
  EXPORT int dwg_setup_ASSOCEDGEACTIONPARAM (Dwg_Object *obj);
in declaration at line 9747 *)
(* error 
  EXPORT int dwg_setup_ASSOCEDGECHAMFERACTIONBODY (Dwg_Object *obj);
in declaration at line 9748 *)
(* error 
  EXPORT int dwg_setup_ASSOCEDGEFILLETACTIONBODY (Dwg_Object *obj);
in declaration at line 9749 *)
(* error 
  EXPORT int dwg_setup_ASSOCMLEADERACTIONBODY (Dwg_Object *obj);
in declaration at line 9750 *)
(* error 
  EXPORT int dwg_setup_ASSOCORDINATEDIMACTIONBODY (Dwg_Object *obj);
in declaration at line 9751 *)
(* error 
  EXPORT int dwg_setup_ASSOCPERSSUBENTMANAGER (Dwg_Object *obj);
in declaration at line 9752 *)
(* error 
  EXPORT int dwg_setup_ASSOCRESTOREENTITYSTATEACTIONBODY (Dwg_Object *obj);
in declaration at line 9753 *)
(* error 
  EXPORT int dwg_setup_ASSOCROTATEDDIMACTIONBODY (Dwg_Object *obj);
in declaration at line 9754 *)
(* error 
  EXPORT int dwg_setup_ASSOCSWEPTSURFACEACTIONBODY (Dwg_Object *obj);
in declaration at line 9755 *)
(* error 
  EXPORT int dwg_setup_BLOCKPROPERTIESTABLE (Dwg_Object *obj);
in declaration at line 9756 *)
(* error 
  EXPORT int dwg_setup_BLOCKPROPERTIESTABLEGRIP (Dwg_Object *obj);
in declaration at line 9757 *)
(* error 
  EXPORT int dwg_setup_BREAKDATA (Dwg_Object *obj);
in declaration at line 9758 *)
(* error 
  EXPORT int dwg_setup_BREAKPOINTREF (Dwg_Object *obj);
in declaration at line 9759 *)
(* error 
  EXPORT int dwg_setup_CONTEXTDATAMANAGER (Dwg_Object *obj);
in declaration at line 9760 *)
(* error 
  EXPORT int dwg_setup_CSACDOCUMENTOPTIONS (Dwg_Object *obj);
in declaration at line 9761 *)
(* error 
  EXPORT int dwg_setup_CURVEPATH (Dwg_Object *obj);
in declaration at line 9762 *)
(* error 
  EXPORT int dwg_setup_DATATABLE (Dwg_Object *obj);
in declaration at line 9763 *)
(* error 
  EXPORT int dwg_setup_DIMASSOC (Dwg_Object *obj);
in declaration at line 9764 *)
(* error 
  EXPORT int dwg_setup_DMDIMOBJECTCONTEXTDATA (Dwg_Object *obj);
in declaration at line 9765 *)
(* error 
  EXPORT int dwg_setup_DYNAMICBLOCKPROXYNODE (Dwg_Object *obj);
in declaration at line 9766 *)
(* error 
  EXPORT int dwg_setup_GEOMAPIMAGE (Dwg_Object *obj);
in declaration at line 9767 *)
(* error 
  EXPORT int dwg_setup_LAYOUTPRINTCONFIG (Dwg_Object *obj);
in declaration at line 9768 *)
(* error 
  EXPORT int dwg_setup_MLEADEROBJECTCONTEXTDATA (Dwg_Object *obj);
in declaration at line 9769 *)
(* error 
  EXPORT int dwg_setup_MOTIONPATH (Dwg_Object *obj);
in declaration at line 9770 *)
(* error 
  EXPORT int dwg_setup_MTEXTATTRIBUTEOBJECTCONTEXTDATA (Dwg_Object *obj);
in declaration at line 9771 *)
(* error 
  EXPORT int dwg_setup_NAVISWORKSMODELDEF (Dwg_Object *obj);
in declaration at line 9772 *)
(* error 
  EXPORT int dwg_setup_ORDDIMOBJECTCONTEXTDATA (Dwg_Object *obj);
in declaration at line 9773 *)
(* error 
  EXPORT int dwg_setup_PERSUBENTMGR (Dwg_Object *obj);
in declaration at line 9774 *)
(* error 
  EXPORT int dwg_setup_POINTPATH (Dwg_Object *obj);
in declaration at line 9775 *)
(* error 
  EXPORT int dwg_setup_RADIMLGOBJECTCONTEXTDATA (Dwg_Object *obj);
in declaration at line 9776 *)
(* error 
  EXPORT int dwg_setup_RADIMOBJECTCONTEXTDATA (Dwg_Object *obj);
in declaration at line 9777 *)
(* error 
  EXPORT int dwg_setup_SUNSTUDY (Dwg_Object *obj);
in declaration at line 9778 *)
(* error 
  EXPORT int dwg_setup_TABLECONTENT (Dwg_Object *obj);
in declaration at line 9779 *)
(* error 
  EXPORT int dwg_setup_TVDEVICEPROPERTIES (Dwg_Object *obj);
in declaration at line 9780 *)
    {EXPORT int dwg_setup_ACDSRECORD (Dwg_Object *obj); }
    {EXPORT int dwg_setup_ACDSSCHEMA (Dwg_Object *obj); }
    {EXPORT int dwg_setup_NPOCOLLECTION (Dwg_Object *obj); }
    {EXPORT int dwg_setup_RAPIDRTRENDERENVIRONMENT (Dwg_Object *obj); }
    {EXPORT int dwg_setup_XREFPANELOBJECT (Dwg_Object *obj); }
{$endif}
    { End auto-generated content  }
{ C++ end of extern C conditionnal removed }
{endif}



    const
      bm__dwg_binary_chunk_codepage = $7FFF;
      bp__dwg_binary_chunk_codepage = 0;
      bm__dwg_binary_chunk_is_tu = $8000;
      bp__dwg_binary_chunk_is_tu = 15;

    const
      //Dwg_Entity_3DSOLID = Dwg_Entity__3DSOLID;

      bm__dwg_entity_eed_data_codepage = $7FFF;
      bp__dwg_entity_eed_data_codepage = 0;
      bm__dwg_entity_eed_data_is_tu = $8000;
      bp__dwg_entity_eed_data_is_tu = 15;
      bm__dwg_entity_eed_data__padding = $7FFF;
      bp__dwg_entity_eed_data__padding = 0;
      //bm__dwg_entity_eed_data_is_tu = $8000;
      //bp__dwg_entity_eed_data_is_tu = 15;

    const
      DWG_OPTS_LOGLEVEL = $f;
      DWG_OPTS_MINIMAL = $10;
      DWG_OPTS_DXFB = $20;
    { can be safely shared  }
      DWG_OPTS_JSONFIRST = $20;
      DWG_OPTS_INDXF = $40;
      DWG_OPTS_INJSON = $80;
      DWG_OPTS_IN = DWG_OPTS_INDXF or DWG_OPTS_INJSON;
    { VT_BOOL clashes with /usr/x86_64-w64-mingw32/sys-root/mingw/include/wtypes.h }
    { RLL }



    function codepage(var a : _dwg_binary_chunk) : dword;
    procedure set_codepage(var a : _dwg_binary_chunk; __codepage : dword);
    function is_tu(var a : _dwg_binary_chunk) : dword;
    procedure set_is_tu(var a : _dwg_binary_chunk; __is_tu : dword);

implementation

    function DWG_VERSIONS : longint;
      begin
        DWG_VERSIONS:=longint(ord(R_AFTER)+1);
      end;

    function codepage(var a : _dwg_binary_chunk) : dword;
      begin
        codepage:=(a.flag0 and bm__dwg_binary_chunk_codepage) shr bp__dwg_binary_chunk_codepage;
      end;

    procedure set_codepage(var a : _dwg_binary_chunk; __codepage : dword);
      begin
        a.flag0:=a.flag0 or ((__codepage shl bp__dwg_binary_chunk_codepage) and bm__dwg_binary_chunk_codepage);
      end;

    function is_tu(var a : _dwg_binary_chunk) : dword;
      begin
        is_tu:=(a.flag0 and bm__dwg_binary_chunk_is_tu) shr bp__dwg_binary_chunk_is_tu;
      end;

    procedure set_is_tu(var a : _dwg_binary_chunk; __is_tu : dword);
      begin
        a.flag0:=a.flag0 or ((__is_tu shl bp__dwg_binary_chunk_is_tu) and bm__dwg_binary_chunk_is_tu);
      end;

initialization
finalization
end.
