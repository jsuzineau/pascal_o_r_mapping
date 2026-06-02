//généré par h2pas sous le nom de rust_html_clean.pas
unit urust_html_clean;
interface
  const
    External_library='rust_html_clean'; {Setup as you need}

  { Pointers to basic pascal types, inserted by h2pas conversion program.}
  Type
    PLongint  = ^Longint;
    PSmallInt = ^SmallInt;
    PByte     = ^Byte;
    PWord     = ^Word;
    PDWord    = ^DWord;
    PDouble   = ^Double;

  Type
  Pchar  = ^char;
{$IFDEF FPC}
{$PACKRECORDS C}
{$ENDIF}

(*
{$include <stdarg.h>}
{$include <stdbool.h>}
{$include <stddef.h>}
{$include <stdint.h>}
{$include <stdlib.h>}
*)
(* Const before type ignored *)
(* Const before type ignored *)

  function c_html_clean(_s:Pchar):Pchar;cdecl;external External_library name 'html_clean';

  procedure c_html_clean_free(ptr:Pchar);cdecl;external External_library name 'html_clean_free';

function html_clean( _s: String): String;

implementation

function html_clean( _s: String): String;
var
   cResult: PChar;
begin
     cResult:= c_html_clean( PChar( _s));
     Result:= cResult;
     c_html_clean_free( cResult);
end;

end.
