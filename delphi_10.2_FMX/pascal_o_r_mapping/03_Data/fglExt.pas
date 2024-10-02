unit fglExt;
//Interface vers 4js 4GL Genero créée au départ par H2Pas à partir de fglExt.h
//(Mis en commentaire pour pouvoir compiler quand non installé)
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            http://www.mars42.com                                               |
                                                                                |
    Copyright 2014,2018 Jean SUZINEAU - MARS42                                       |
                                                                                |
    This program is free software: you can redistribute it and/or modify        |
    it under the terms of the GNU Lesser General Public License as published by |
    the Free Software Foundation, either version 3 of the License, or           |
    (at your option) any later version.                                         |
                                                                                |
    This program is distributed in the hope that it will be useful,             |
    but WITHOUT ANY WARRANTY; without even the implied warranty of              |
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the               |
    GNU Lesser General Public License for more details.                         |
                                                                                |
    You should have received a copy of the GNU Lesser General Public License    |
    along with this program.  If not, see <http://www.gnu.org/licenses/>.       |
                                                                                |
|                                                                               }

interface

uses
    uLog,
    SysUtils, classes{, strings};
(* (Mis en commentaire pour pouvoir compiler quand non installé)
{$IFDEF FPC}
const
  {$IFDEF LINUX}
    //fglib= 'libfgl.so',
    fglib= '';
    {$LinkLib fgl}
  {$ELSE}
    fglib= 'libfgl.dll';
    //fglib= '';
    //{$LinkLib libfgl.dll}
  {$ENDIF}
{$ENDIF}
*)

{
  Automatically converted by H2Pas 1.0.0 from fglExt.h
  The following command line parameters were used:
    -o
    fglExt.pas
    -u
    fglExt
    fglExt.h
}

  Type
  bigint= Int64;
  int4= Int32;
  Pbigint  = ^bigint;
  Pchar  = ^char;
  Pdouble  = ^double;
  Pint4  = ^int4;
  Plongint  = ^longint;
  Psingle  = ^single;
  Psmallint  = ^smallint;
{$IFDEF FPC}
{$PACKRECORDS C}
{$ENDIF}

  {
   * Property of Four Js*
   * (c) Copyright Four Js 1995, 2014. All Rights Reserved.
   * * Trademark of Four Js Development Tools Europe Ltd
   *   in the United States and elsewhere
    }
  { *INDENT-OFF*  }
(* Const before type ignored *)

  type
    UsrFunction = record
        ident : PChar;
        _function : function (_para1:longint):longint;cdecl;
        nPar : longint;
        nRet : longint;
        accessFlags : longint;
      end;

  { 4GL Stack  }

  (* (Mis en commentaire pour pouvoir compiler quand non installé)
  {$IFDEF FPC}
  procedure fglcapi_popBoolean(d:Pchar           ); cdecl; external fglib;
  procedure fglcapi_popMInt   (d:Plongint        ); cdecl; external fglib;
  procedure fglcapi_popInt2   (d:Psmallint       ); cdecl; external fglib;
  procedure fglcapi_popInt4   (d:Pint4           ); cdecl; external fglib;
  procedure fglcapi_popBigint (d:Pbigint         ); cdecl; external fglib;
  procedure fglcapi_popQuote  (d:Pchar; l:longint); cdecl; external fglib;
  procedure fglcapi_popString (d:Pchar; l:longint); cdecl; external fglib;
  procedure fglcapi_popVarChar(d:Pchar; l:longint); cdecl; external fglib;
  {$ENDIF}
  *)
  procedure popBoolean(d:Pchar           );
  procedure popInt    (d:Plongint        ); overload;
  procedure popInt2   (d:Psmallint       );
  procedure popInt4   (d:Pint4           );
  procedure popBigint (d:Pbigint         );
  procedure popQuote  (d:Pchar; l:longint);
  procedure popString (d:Pchar; l:longint); overload;
  procedure popVarChar(d:Pchar; l:longint);

  function popInt: Longint; overload;
  function popString: String; overload;

  (* (Mis en commentaire pour pouvoir compiler quand non installé)
  {$IFDEF FPC}
  procedure fglcapi_pushDate   (v:int4            ); cdecl; external fglib;
  procedure fglcapi_pushDouble (v:Pdouble         ); cdecl; external fglib;
  procedure fglcapi_pushFloat  (v:Psingle         ); cdecl; external fglib;
  procedure fglcapi_pushBoolean(v:char            ); cdecl; external fglib;
  procedure fglcapi_pushMInt   (v:longint         ); cdecl; external fglib;
  procedure fglcapi_pushInt2   (v:smallint        ); cdecl; external fglib;
  procedure fglcapi_pushInt4   (v:int4            ); cdecl; external fglib;
  procedure fglcapi_pushBigint (v:bigint          ); cdecl; external fglib;
  procedure fglcapi_pushQuote  (v:Pchar; l:longint); cdecl; external fglib;
  procedure fglcapi_pushVarChar(v:Pchar; l:longint); cdecl; external fglib;
  {$ENDIF}
*)
  procedure pushDate   (v:int4            );
  procedure pushDouble (v:Pdouble         );
  procedure pushFloat  (v:Psingle         );
  procedure pushBoolean(v:char            );
  procedure pushint    (v:longint         );
  procedure pushInt2   (v:smallint        );
  procedure pushInt4   (v:int4            );
  procedure pushBigint (v:bigint          );
  procedure pushQuote  (v:Pchar; l:longint);
  procedure pushVarChar(v:Pchar; l:longint);

  procedure pushString ( _S: String);

  function fgl_call( _4GL_function_name:String; _Arguments_count:longint): longint;
  
  (* (Mis en commentaire pour pouvoir compiler quand non installé)

  {$IFDEF FPC}
  procedure fglcapi_retDate(v:longint); cdecl; external;

  procedure fglcapi_retDouble(v:Pdouble); cdecl; external;

  procedure fglcapi_retFloat(v:Psingle); cdecl; external;

  procedure fglcapi_retMInt(v:longint); cdecl; external;

  procedure fglcapi_retInt2(v:smallint); cdecl; external;

  procedure fglcapi_retInt4(v:longint); cdecl; external;

  // Const before type ignored
  procedure fglcapi_retQuote(val:Pchar); cdecl; external;

  // Const before type ignored
  procedure fglcapi_retVarChar(val:Pchar); cdecl; external;
  
  //int fglcapi_call4gl(const char *n, int ac);
  function fglcapi_call4gl( n:Pchar; ac:longint): longint; cdecl; external fglib;

  {$ENDIF}
*)

  procedure fgl_putfile( _NomFichier_cote_serveur, _NomFichier_cote_client: String);
  { *INDENT-ON*  }

  procedure lg_Traite_Fichier_Genere( _Fonction, _Fichier_genere: String);

  procedure lg_HTTP_Interface_Terminate;

implementation

{$IFDEF FPC}
// (Mis en commentaire pour pouvoir compiler quand non installé)
procedure popBoolean(d:Pchar           );begin {fglcapi_popBoolean(d   ); }end;
procedure popint    (d:Plongint        );begin {fglcapi_popMInt   (d   ); }end;
procedure popInt2   (d:Psmallint       );begin {fglcapi_popInt2   (d   ); }end;
procedure popInt4   (d:Pint4           );begin {fglcapi_popInt4   (d   ); }end;
procedure popBigint (d:Pbigint         );begin {fglcapi_popBigint (d   ); }end;
procedure popQuote  (d:Pchar; l:longint);begin {fglcapi_popQuote  (d, l); }end;
procedure popString (d:Pchar; l:longint);begin {fglcapi_popString (d, l); }end;
procedure popVarChar(d:Pchar; l:longint);begin {fglcapi_popVarChar(d, l); }end;

procedure pushDate   (v:int4            );begin {fglcapi_pushDate   (v   );}  end;
procedure pushDouble (v:Pdouble         );begin {fglcapi_pushDouble (v   );}  end;
procedure pushFloat  (v:Psingle         );begin {fglcapi_pushFloat  (v   );}  end;
procedure pushBoolean(v:char            );begin {fglcapi_pushBoolean(v   );}  end;
procedure pushint    (v:longint         );begin {fglcapi_pushMInt   (v   );}  end;
procedure pushInt2   (v:smallint        );begin {fglcapi_pushInt2   (v   );}  end;
procedure pushInt4   (v:int4            );begin {fglcapi_pushInt4   (v   );}  end;
procedure pushBigint (v:bigint          );begin {fglcapi_pushBigint (v   );}  end;
procedure pushQuote  (v:Pchar; l:longint);begin {fglcapi_pushQuote  (v, l);}  end;
procedure pushVarChar(v:Pchar; l:longint);begin {fglcapi_pushVarChar(v, l);}  end;


function popInt: Longint;
begin
     popint(@Result);
end;

function popString: String; overload;
const
     Taille= 2048;
var
   TailleAllouee: Integer;
   lpstrResult: PChar;
begin
     TailleAllouee:= Taille+1;

     lpstrResult:= stralloc( TailleAllouee);
     try
        popquote( lpstrResult, Taille);
        Result:= Trim( StrPas( lpstrResult));
     finally
            strdispose( lpstrResult);
            end;
end;

procedure pushString ( _S: String);
var
   TailleAllouee: Integer;
   Taille: Integer;
   lpstrS: PChar;
begin
     //à peaufiner, taillé large pour les soucis de #0 terminal
     Taille:= Length( _S)+1;
     TailleAllouee:= Taille+1;

     lpstrS:= stralloc( TailleAllouee);
     try
        StrPCopy( lpstrS, _S);
        pushquote( lpstrS, Taille);
     finally
            strdispose( lpstrS);
            end;
end;

// (Mis en commentaire pour pouvoir compiler quand non installé)
function fgl_call( _4GL_function_name:String; _Arguments_count:longint): longint;
begin
     //Result:= fglcapi_call4gl( PChar( _4GL_function_name), _Arguments_count);
end;

{$ELSE}
procedure popBoolean(d:Pchar           );begin                           end;
procedure popint    (d:Plongint        );begin                           end;
procedure popInt2   (d:Psmallint       );begin                           end;
procedure popInt4   (d:Pint4           );begin                           end;
procedure popBigint (d:Pbigint         );begin                           end;
procedure popQuote  (d:Pchar; l:longint);begin                           end;
procedure popString (d:Pchar; l:longint);begin                           end;
procedure popVarChar(d:Pchar; l:longint);begin                           end;
function popInt   : Longint;             begin                           end;
function popString: String ;             begin                           end;


procedure pushDate   (v:int4            );begin                             end;
procedure pushDouble (v:Pdouble         );begin                             end;
procedure pushFloat  (v:Psingle         );begin                             end;
procedure pushBoolean(v:char            );begin                             end;
procedure pushint    (v:longint         );begin                             end;
procedure pushInt2   (v:smallint        );begin                             end;
procedure pushInt4   (v:int4            );begin                             end;
procedure pushBigint (v:bigint          );begin                             end;
procedure pushQuote  (v:Pchar; l:longint);begin                             end;
procedure pushVarChar(v:Pchar; l:longint);begin                             end;
procedure pushString ( _S: String       );begin                             end;

function fgl_call( _4GL_function_name:String; _Arguments_count:longint): longint;begin end;

{$ENDIF}

procedure fgl_putfile( _NomFichier_cote_serveur, _NomFichier_cote_client: String);
begin
     Log.PrintLn( 'fglExt::fgl_putfile('+_NomFichier_cote_serveur+', '+_NomFichier_cote_client+')');
     pushString( _NomFichier_cote_serveur);
     pushString( _NomFichier_cote_client );
     //fgl_call( 'fgl_putfile', 2);
     fgl_call( 'serveur_to_client', 2);
end;

procedure lg_Traite_Fichier_Genere( _Fonction, _Fichier_genere: String);
{
FUNCTION lg_Traite_Fichier_Genere( _Fonction, _Fichier_genere)
# juste un nom plus explicite pour l'appel depuis le code pascal
#-----------------------------------------------------------------------------------#
  DEFINE _Fonction String
  DEFINE _Fichier_genere STRING
}
begin
     Log.PrintLn( 'fglExt::lg_Traite_Fichier_Genere('+_Fonction+', '+_Fichier_genere+')');
     pushString( _Fonction      );
     pushString( _Fichier_genere);
     fgl_call( 'lg_traite_fichier_genere', 2);
end;

procedure lg_HTTP_Interface_Terminate;
begin
     Log.PrintLn( 'fglExt::lg_HTTP_Interface_Terminate');
     fgl_call( 'lg_http_interface_terminate', 0);
end;

end.

