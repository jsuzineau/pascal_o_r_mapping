//note: ce fichier est regénéré par h2pas Wizard sous le nom test_rust_lib.pas
unit uTest_rust_lib;
interface
{$IFNDEF MSWINDOWS}
  uses unixtype;
{$ENDIF}
{
  Automatically converted by H2Pas 1.0.0 from E:\01_Projets\01_pascal_o_r_mapping\tools\test_rust\test_rust_lib.tmp.h
  The following command line parameters were used:
    -e
    -p
    -D
    -w
    -l
    test_rust_lib
    -o
    E:\01_Projets\01_pascal_o_r_mapping\tools\test_rust\test_rust_lib.pas
    E:\01_Projets\01_pascal_o_r_mapping\tools\test_rust\test_rust_lib.tmp.h
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

(*
{$include <stdarg.h>}
{$include <stdbool.h>}
{$include <stddef.h>}
{$include <stdint.h>}
{$include <stdlib.h>}
*)
  function Add(left:size_t; right:size_t):size_t;cdecl;external External_library name 'Add';

  procedure Hello_from_rust;cdecl;external External_library name 'Hello_from_rust';

(* Const before type ignored *)
(* Const before type ignored *)
  function Test_PChar(_s:Pchar):Pchar;cdecl;external External_library name 'Test_PChar';

  function Test_double(_d:double):double;cdecl;external External_library name 'Test_double';


implementation


end.
