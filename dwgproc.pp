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

unit dwgproc;

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
    SysUtils, ctypes, dynlibs, dwg;

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

  var
    dwg_read_file : function(const filename:pchar;
                             dwg:PDwg_Data):integer;extdecl;
    dxf_read_file : function(const filename:pchar;
                             dwg:PDwg_Data):integer;extdecl;
    dwg_free : procedure(dwg:PDwg_Data);extdecl;

    procedure FreeLibreDWG;
    procedure LoadLibreDWG(lib : pchar = LibreDWG_Lib; reloadlib : Boolean = False);


implementation
  var
    hlib : tlibhandle;

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
          raise Exception.Create(format('Could not load library: %s',[lib]));
      end;

initialization
  hlib:=0;
  FreeLibreDWG;
finalization
  FreeLibreDWG;
end.
