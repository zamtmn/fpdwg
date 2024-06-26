program dwg_test;
uses
  SysUtils,
  dwg,dwgproc;
type
  PBITCODE_BS=^BITCODE_BS;

procedure load_dwg(filename:string);
var
  dwg:Dwg_Data;
  success:integer;
  i:BITCODE_BL;
  tl:BITCODE_BS;
begin
  LoadLibreDWG;
  fillchar(dwg,sizeof(dwg),0);
  dwg.opts:=0;
  success:=dwg_read_file(pchar(filename),@dwg);
  writeln('success           ',success);
  writeln('version           ',dwg.header.version);
  writeln('from_version      ',dwg.header.from_version);
  writeln('zero_5[0]         ',dwg.header.zero_5[0]);
  writeln('zero_5[1]         ',dwg.header.zero_5[1]);
  writeln('zero_5[2]         ',dwg.header.zero_5[2]);
  writeln('zero_5[3]         ',dwg.header.zero_5[3]);
  writeln('zero_5[4]         ',dwg.header.zero_5[4]);
  writeln('is_maint          ',dwg.header.is_maint);
  writeln('zero_one_or_three ',dwg.header.zero_one_or_three);
  writeln('unknown_3         ',dwg.header.unknown_3);
  writeln('numheader_vars    ',dwg.header.numheader_vars);
  writeln('thumbnail_address ',dwg.header.thumbnail_address);
  writeln('dwg_version       ',dwg.header.dwg_version);
  writeln('maint_version     ',dwg.header.maint_version);
  writeln('codepage          ',dwg.header.codepage);

  writeln('sizeof(dwg.header_vars)',sizeof(dwg.header_vars));
  writeln('dwg.header_vars.DWGCODEPAGE ',integer(dwg.header_vars.DWGCODEPAGE));

  if dwg.num_objects>0 then
    for i := 0 to dwg.num_objects-1 do begin
      case dwg.&object[i].fixedtype of
        DWG_TYPE_TEXT:begin
                        //writeln((PBITCODE_BS(dwg.&object[i].tio.entity^.tio.text^.text_value)^));
                        //writeln(UnicodeCharToString(punicodechar(dwg.&object[i].tio.entity^.tio.text^.text_value)));
                          writeln((pchar(dwg.&object[i].tio.entity^.tio.text^.text_value)));
                      end;
        //DWG_TYPE_TEXT:writeln({UnicodeCharToString}(pchar(dwg.&object[i].tio.entity^.tio.text^.text_value)^));
      end;
    end;
  dwg_free(@dwg);
  FreeLibreDWG;
  readln;
end;
begin
  load_dwg(paramstr(1));
end.

