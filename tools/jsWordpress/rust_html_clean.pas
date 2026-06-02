
unit rust_html_clean;
interface

{
  Automatically converted by H2Pas 1.0.0 from E:\01_Projets\01_pascal_o_r_mapping\tools\test_rust\rust_html_clean.tmp.h
  The following command line parameters were used:
    -e
    -p
    -D
    -w
    -l
    test_rust_lib
    -o
    E:\01_Projets\01_pascal_o_r_mapping\tools\test_rust\rust_html_clean.pas
    E:\01_Projets\01_pascal_o_r_mapping\tools\test_rust\rust_html_clean.tmp.h
}

  const
    External_library='test_rust_lib'; {Setup as you need}

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


{$include <stdarg.h>}
{$include <stdbool.h>}
{$include <stddef.h>}
{$include <stdint.h>}
{$include <stdlib.h>}
(* Const before type ignored *)
(* Const before type ignored *)

  function html_clean(_s:Pchar):Pchar;cdecl;external External_library name 'html_clean';

  procedure html_clean_free(ptr:Pchar);cdecl;external External_library name 'html_clean_free';


implementation


end.
