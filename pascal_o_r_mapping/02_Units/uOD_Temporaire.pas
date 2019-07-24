unit uOD_Temporaire;
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            partly as freelance: http://www.mars42.com                          |
        and partly as employee : http://www.batpro.com                          |
    Contact: gilles.doutre@batpro.com                                           |
                                                                                |
    Copyright 2011,2012,2014 Jean SUZINEAU - MARS42                             |
    Copyright 2011,2012,2014 Cabinet Gilles DOUTRE - BATPRO                     |
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
    along with this program.  If not, see <http://www.gnu.org/licenses/>. 1     |
                                                                                |
|                                                                               }

interface

uses
    uOD_Forms,
    uLog,
  {$IFNDEF FPC}
  Dialogs, ShellAPI,
  {$ELSE}
  LCLIntf,
  {$ENDIF}
  {$IFDEF WINDOWS}
  Windows,
  {$ENDIF}
  SysUtils, Classes,LazUTF8;

type
 TOD_Temporaire
 =
  class
  //Gestion du cycle de vie
  public
    constructor Create;
    destructor Destroy; override;
  //Répertoire temporaire de l'application
  public
    RepertoireTemp: String;
  //Répertoire temporaire du système
  public
    function RepertoireSysteme: String;
  //création d'un fichier OD_Temporaire
  public
    function Nouveau_Fichier  ( Prefixe: String): String;
    function Nouveau_Extension( Prefixe, Extension: String): String;
    function Nouveau_ODT( Prefixe: String): String;
    function Nouveau_ODS( Prefixe: String): String;
    function Nouveau_PDF( Prefixe: String): String;
  //création d'un répertoire OD_Temporaire
  public
    function Nouveau_Repertoire( Prefixe: String): String;
  //Existence d'un répertoire
  public
    function RepertoireExiste( _Repertoire: String): Boolean;
  //Destruction d'un répertoire
  private
    procedure TraiteLastError( Messag: String);
  public
    function DetruitRepertoire( _Repertoire: String): Boolean;
  end;

var
   OD_Temporaire: TOD_Temporaire;

function ShowURL( URL: String): Boolean;

implementation

function ShowURL( URL: String): Boolean;
begin
     {$IFNDEF FPC}
     //Result:= 32 < ShellExecute( 0, 'open', 'iexplore', PChar(URL),nil,SW_SHOWNORMAL);
     Result:= 32 < ShellExecute( 0, 'open', PChar(URL),nil,nil,SW_SHOWNORMAL);
     {$ELSE}
     Result:= OpenDocument( URL);
     {$ENDIF}
end;

{ TOD_Temporaire }

constructor TOD_Temporaire.Create;
begin
     inherited;
     RepertoireTemp:= RepertoireSysteme;
end;

destructor TOD_Temporaire.Destroy; 
begin
     inherited;
end;


function TOD_Temporaire.RepertoireSysteme: String;
{$IFDEF WINDOWS}
var
   buffer: array[0..MAX_PATH] of AnsiChar;
begin
     GetTempPath( length( buffer), buffer);
     Result:= StrPas( buffer);
end;
{$ELSE}
begin
     Result:= GetTempDir;
end;
{$ENDIF}

{$IFDEF WINDOWS}
function GetLongPathNameW(ShortPathName: PWideChar; LongPathName: PWideChar;
    cchBuffer: Integer): Integer; stdcall; external 'kernel32.dll' name 'GetLongPathNameW';

function ExtractLongPathName(const ShortName: WideString): string;
var
   ws: WideString;
begin
     SetLength( ws, GetLongPathNameW( PWideChar(ShortName), nil, 0));
     if 0 = Length(ws)
     then
         begin
         Result:= 'windows.GetLongPathNameW: '+sGetLastError;
         exit;
         end;
     SetLength(ws, GetLongPathNameW( PWideChar(ShortName), PWideChar(ws), Length(ws)));
     Result:= UTF16ToUTF8( ws);
end;
{$ENDIF}

function TOD_Temporaire.Nouveau_Fichier( Prefixe: String): String;
{$IFDEF WINDOWS}
var
   TempFileName: array[0..MAX_PATH] of AnsiChar;
begin
     GetTempFileName(  PAnsiChar( RepertoireTemp),
                       PAnsiChar( Prefixe       ), 0, TempFileName);
     Result:= StrPas( TempFileName);
     Result:= ExtractLongPathName( Result);
end;
{$ELSE}
var
   sl: TStringList;
begin
     Result:= GetTempFileName( RepertoireTemp, Prefixe);
     sl:= TStringList.Create;
     try
        sl.Text:= 'PlaceHolder';
        sl.SaveToFile( Result);
     finally
            FreeAndNil( sl);
            end;
     {$IFDEF WINDOWS}
     Result:= ExtractLongPathName( Result);
     {$ENDIF}
end;
{$ENDIF}

function TOD_Temporaire.Nouveau_Repertoire( Prefixe: String): String;
begin
     Result:= Nouveau_Fichier( Prefixe);
     Result:= ChangeFileExt( Result, '.DIR');
     CreateDir( Result);
end;

function TOD_Temporaire.Nouveau_Extension( Prefixe, Extension: String): String;
begin
     Result:= Nouveau_Fichier( Prefixe);
     Result:= ChangeFileExt( Result, Extension);
end;

function TOD_Temporaire.Nouveau_ODT( Prefixe: String): String;
begin
     Result:= Nouveau_Extension( Prefixe, '.odt');
end;

function TOD_Temporaire.Nouveau_ODS( Prefixe: String): String;
begin
     Result:= Nouveau_Extension( Prefixe, '.ods');
end;

function TOD_Temporaire.Nouveau_PDF(Prefixe: String): String;
begin
     Result:= Nouveau_Extension( Prefixe, '.pdf');
end;

function TOD_Temporaire.RepertoireExiste( _Repertoire: String): Boolean;
begin
     {$I-}
     ChDir( _Repertoire);
     Result:= IOResult = 0;
     {$I+}
end;

procedure TOD_Temporaire.TraiteLastError( Messag: String);
begin
     uLog.TraiteLastError( Messag);
end;

function TOD_Temporaire.DetruitRepertoire( _Repertoire: String): Boolean;
var
   SearchRec: TSearchRec;
   Found: Integer;
   NomFichier: String;
   NomTMP: String;
begin
     Result:= not RepertoireExiste( _Repertoire);
     if Result then exit;

     Result:= True;
     Found:= FindFirst( IncludeTrailingPathDelimiter(_Repertoire)+'*.*', faAnyFile, SearchRec);
     while (Found = 0) and Result
     do
       begin
       NomFichier:= ExtractFileName(SearchRec.Name);
       if     (NomFichier <> '.')
          and (NomFichier <> '..')
       then
           if 0 <> faDirectory and SearchRec.Attr
           then
               DetruitRepertoire( SearchRec.Name)
           else
               DeleteFile( SearchRec.Name);
       Found := FindNext(SearchRec);
       end;
     FindClose( SearchRec);

     RemoveDir( _Repertoire);
     //if not RemoveDir( _Repertoire)
     //then
     //    TraiteLastError( 'Echec à la suppression du répertoire '+_Repertoire+#13#10);
     NomTMP:= ChangeFileExt( _Repertoire, '.tmp');
     DeleteFile( NomTMP);
end;

initialization
              OD_Temporaire:= TOD_Temporaire.Create;
finalization
              FreeAndNil( OD_Temporaire);
end.
