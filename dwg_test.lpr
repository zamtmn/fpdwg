program dwg_test;
uses
  dwg;
type
  PDwg_Data=^Dwg_Data;
  {$MACRO ON}
  {$IFDEF Windows}
    {$DEFINE extdecl := stdcall}
  {$ELSE}
    {$DEFINE extdecl := cdecl}
  {$ENDIF}

function dwg_read_file (const filename:pchar;
                        dwg:PDwg_Data):integer;extdecl;external 'libredwg-0.dll';
procedure dwg_free (dwg:PDwg_Data);extdecl;external 'libredwg-0.dll';

  procedure load_dwg(filename:string);
var
  dwg:Dwg_Data;
  success:integer;
begin
  fillchar(dwg,sizeof(dwg),0);
  dwg.opts:=1;
  success:=dwg_read_file (pchar(filename), @dwg);
  writeln(success);
  dwg_free(@dwg);
end;
begin
  load_dwg(paramstr(1));
end.

