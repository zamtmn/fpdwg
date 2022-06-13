program dwg_test;
uses
  SysUtils,
  dwg;
type
  PDwg_Data=^Dwg_Data;

procedure load_dwg(filename:string);
var
  dwg:Dwg_Data;
  success:integer;
begin
  LoadLibreDWG;
  fillchar(dwg,sizeof(dwg),0);
  dwg.opts:=0;
  success:=dwg_read_file(pchar(filename),@dwg);
  writeln(success);
  dwg_free(@dwg);
  FreeLibreDWG;
end;
begin
  load_dwg(paramstr(1));
end.

