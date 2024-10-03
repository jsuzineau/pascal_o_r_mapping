unit uClean;
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            partly as freelance: http://www.mars42.com                          |
        and partly as employee : http://www.batpro.com                          |
    Contact: gilles.doutre@batpro.com                                           |
                                                                                |
    Copyright 2014 Jean SUZINEAU - MARS42                                       |
    Copyright 2014 Cabinet Gilles DOUTRE - BATPRO                               |
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
  SysUtils, Classes;

(*
var
   Ff#: Tf#;

function f#: Tf#;

function f#: Tf#;
begin
     Clean_Get( Result, Tf#, Ff#);
end;
*)

// 2002 08 :
// Pour bien faire quand on utilise Clean_Get pour créer, il faudrait
// prévoir dans Clean_Destroy de détruire tous les objets ajoutés aprés l'objet
// courant. Mais cela pourrait générer d'autres problèmes.
// Le plus sûr est d'utiliser Clean_Create et Clean_Destroy en parties
// initialization / finalization des unités. Inconvénient: toutes les ressources
// sont toujours allouées/désallouées même si l'on ne les utilise pas.
//2002 09 23: Clean_Get/Clean_CreateD/Clean_Destroy
// on crée avec Clean_Get, on détruit avec Clean_Destroy (cas non créé géré)
// pour permettre un test des branchements à problèmes (TrepXXX.Dataset,
// TdmYYY.q.Datasource) on ajoute des Clean_CreateD en initialization qui
// appellent Clean_Create si l'on est en mode DEBUG.
// Pour les modules de données, il faut assurer leur création dés
// l'initialization pour qu'il puissent être utilisés dans les ressources des
// unités créées aprés.

procedure Clean_Create ( var Reference ; Classe: TComponentClass);
procedure Clean_CreateD( var Reference ; Classe: TComponentClass);//= si DEBUG
procedure Clean_Destroy( var O);

procedure Clean_Get( var Resultat; var Reference; Classe: TComponentClass);

procedure Free_nil( var O);

function uClean_Log_Repertoire_from_Date( _Date: TDateTime): String;
function uClean_Log_Repertoire: String;
function uClean_Log_Nom: String;
function uClean_Log_NomFichier: String;
procedure uClean_Log( S: String);
function uClean_HTML_Repertoire: String;

var uClean_Log_Started: String= '';
procedure uClean_Log_Start( S: String);
procedure uClean_Log_Stop ( Start, S: String; _Dot: Char='.');
procedure uClean_Log_Succes( Start: String; _Dot: Char='.');
procedure uClean_Log_Echec;

var
   uClean_NetWork_Nom_Hote: String= 'uClean';//mis à jour dans uNetwork

//Gestion OPN
var
   uClean_fMot_de_passe_OPN_OKFunction: function( _Contexte: String= ''): Boolean of object= nil;
   uClean_UsesCase_ExecuteFunction: function ( _UseCase: String; _Params: array of String): Boolean= nil;
   uClean_SGBD_OPN: procedure= nil;
   uClean_SGBD_OPN_Requeteur: procedure( _SQL: String = '') = nil;

function uClean_fMot_de_passe_OPN_OK( _Contexte: String= ''): Boolean;
function uClean_UsesCase_Execute( _UseCase: String; _Params: array of String): Boolean;

procedure uClean_OPN;
procedure uClean_OPN_Requeteur( _SQL: String = '');

function uClean_EXE_Name: String;

function Repertoire_from_( _NomFichier: String): String;

function uClean_BIN_from_FGL_LIB( _FGL_LIB: String): String;
function uClean_Racine_from_EXE( _EXE: String): String;
function uClean_ETC_from_EXE( _EXE: String): String;
function uClean_LOG_from_EXE( _EXE: String): String;
function uClean_HTML_from_EXE( _EXE: String): String;


implementation
uses
    uChrono, //référence circulaire
    uParametres_Ligne_de_commande;

function uClean_EXE_Name: String;
begin
     //Result:= GetModuleName(HINSTANCE); //retourne le BPL sous Delphi
     //if '' = Result // se produit sur Lazarus 2.0.0RC1 /FPC 3.0.4
     //then
     Result:= ParamStr( 0);
end;

function Repertoire_from_( _NomFichier: String): String;
begin
     Result:= ExcludeTrailingPathDelimiter( ExtractFilePath( _NomFichier));
end;

function uClean_BIN_from_FGL_LIB( _FGL_LIB: String): String;
var
   Repertoire_FGL: String;
   Repertoire_Batpro: String;
begin
     Repertoire_FGL   := Repertoire_from_( _FGL_LIB);

     //uClean_Log( 'Repertoire_FGL: ', Repertoire_FGL);
     Repertoire_Batpro:= Repertoire_from_( Repertoire_FGL);
     //uClean_Log( 'Repertoire_Batpro: ', Repertoire_Batpro);
     Result:= Repertoire_Batpro+PathDelim+'bin';
     //uClean_Log( 'Résultat uClean_BIN_from_FGL_LIB : ', Result);
end;

function uClean_Racine_from_EXE( _EXE: String): String;
var
   Repertoire_de_EXE: String;
   Nom_Repertoire_de_EXE: String;
begin
     Repertoire_de_EXE:= Repertoire_from_( _EXE);
     Nom_Repertoire_de_EXE:= ExtractFileName( Repertoire_de_EXE);

     if 'lib' = LowerCase( Nom_Repertoire_de_EXE)
     then
         Result:= uClean_BIN_from_FGL_LIB( Repertoire_de_EXE)
     else
         Result:= Repertoire_de_EXE;

     //uClean_Log( 'Résultat uClean_Racine_from_EXE : ', Result);
end;

function uClean_ETC_from_EXE( _EXE: String): String;
var
   Repertoire_racine: String;
begin
     Repertoire_racine:= uClean_Racine_from_EXE( _EXE);

     Result:= Repertoire_racine + PathDelim +'etc';
     //uClean_Log( 'Résultat uClean_ETC_from_EXE : ', Result);
end;

function uClean_LOG_from_EXE( _EXE: String): String;
var
   Repertoire_racine: String;
begin
     Repertoire_racine:= uClean_Racine_from_EXE( _EXE);

     Result:= Repertoire_racine + PathDelim +'log';
     //uClean_Log( 'Résultat uClean_LOG_from_EXE : ', Result);
end;

function uClean_HTML_from_EXE( _EXE: String): String;
var
   Repertoire_racine: String;
begin
     Repertoire_racine:= uClean_Racine_from_EXE( _EXE);

     Result:= Repertoire_racine + PathDelim +'html';
     //uClean_Log( 'Résultat uClean_LOG_from_EXE : ', Result);
end;

function uClean_HTML_Repertoire: String;
begin
     Result:= uClean_HTML_from_EXE( uClean_EXE_Name);
end;

var
   Finalize_OK: Boolean = False;
   Liste: TList;
   Noms: TStringList;

function uClean_Log_Repertoire_from_Date( _Date: TDateTime): String;
begin
     Result
     :=
         uClean_LOG_from_EXE( uClean_EXE_Name)+PathDelim
       + FormatDateTime( 'yyyy"_"mm"_"dd', _Date)+ PathDelim;
     ForceDirectories( Result);
end;

function uClean_Log_Repertoire: String;
begin
     Result:= uClean_Log_Repertoire_from_Date( Now);
end;

function uClean_Log_Nom: String;
begin
     Result
     :=
       ChangeFileExt( ExtractFileName(uClean_EXE_Name),
                      '.'+uClean_NetWork_Nom_Hote+'.uClean_log.txt');
end;

function uClean_Log_NomFichier: String;
var
   Repertoire: String;
begin
     Repertoire:= uClean_Log_Repertoire;
     Result:= Repertoire +uClean_Log_Nom;
end;

procedure uClean_Log( S: String);
var
   NomLog: String;
   T: Text;
begin
     NomLog:= uClean_Log_NomFichier;
     AssignFile( T, NomLog);
     if FileExists( NomLog)
     then
         Append( T)
     else
         ReWrite( T);
     S
     :=
        FormatDateTime( 'ddddd tt', Now)+#13#10
       +S;
     WriteLn( T,  S);
     Flush( T);
     CloseFile( T);
end;

procedure uClean_Log_append( S: String);
var
   NomLog: String;
   T: Text;
begin
     NomLog:= uClean_Log_NomFichier;
     AssignFile( T, NomLog);
     if FileExists( NomLog)
     then
         Append( T)
     else
         ReWrite( T);
     Write( T,  S);
     Flush( T);
     CloseFile( T);
end;

procedure uClean_Log_Echec;
begin
     uClean_Log_Stop ( uClean_Log_Started, 'Echec','#');
end;

procedure uClean_Log_Start( S: String);
begin
     if '' <> uClean_Log_Started
     then
         uClean_Log_Echec;

     uClean_Log_Started:= S;
     uClean_Log_append( S);
end;

procedure uClean_Log_Stop ( Start, S: String; _Dot: Char='.');
var
   Dots: String;
begin
     if Start <> uClean_Log_Started
     then
         uClean_Log_Echec;

     Dots:= StringOfChar( _Dot,80-Length(uClean_Log_Started)+Length(S));
     uClean_Log( Dots+S);
     uClean_Log_Started:= '';
end;

procedure uClean_Log_Succes( Start: String; _Dot: Char='.');
begin
     uClean_Log_Stop ( Start, 'Succés', _Dot);
end;

procedure Clean_Create ( var Reference ; Classe: TComponentClass);
var
   Nom: String;
begin
     //if Assigned(Chrono) then Chrono.Stop( 'Clean_Create , début');
     TComponent(Reference):= Classe.Create( nil);
     Liste.Add( @Reference);
     Nom:= TComponent(Reference).Name;
     Noms.Add( Nom);
     //if Assigned(Chrono) then Chrono.Stop( 'Clean_Create ( '+Nom+')');
end;

procedure Clean_CreateD( var Reference ; Classe: TComponentClass);//= si DEBUG
begin
     if ModeDEBUG_2
     then
         Clean_Create( Reference, Classe);
end;

procedure Clean_Destroy( var O);
var
   Trash: TObject;
   I: Integer;
begin
     if Finalize_OK then exit;

     if Assigned( Liste)
     then
         begin
         I:= Liste.IndexOf( @O);
         if I <> -1
         then
             Noms.Delete( I);

         Liste.Remove( @O);
         end;

     if TObject( O) = nil then exit;

     Trash:= TObject( O);
     TObject( O):= nil;
     Free_nil( Trash);
end;

procedure Clean_Get( var Resultat; var Reference; Classe: TComponentClass);
begin
     if not Assigned( TComponent( Reference))
     then
         Clean_Create( Reference, Classe);

     TComponent( Resultat):= TComponent( Reference);
end;

procedure Free_nil( var O);
begin
     //FreeAndNil( O);
     if Assigned( TObject( O))
     then
         begin
         try
            try
               TObject( O).Free;
            except
                  on Exception
                  do
                    TObject( O):= nil;
                  end;
         finally
                TObject( O):= nil;
                end;
         end;
end;

function uClean_fMot_de_passe_OPN_OK( _Contexte: String= ''): Boolean;
begin
     Result:= Assigned( uClean_fMot_de_passe_OPN_OKFunction);
     if not Result then exit;

     Result:= uClean_fMot_de_passe_OPN_OKFunction( 'OPN');
end;

function uClean_UsesCase_Execute( _UseCase: String; _Params: array of String): Boolean;
begin
     Result:= Assigned( uClean_UsesCase_ExecuteFunction);
     if not Result then exit;

     Result:= uClean_UsesCase_ExecuteFunction( _UseCase, _Params);
end;

procedure uClean_OPN;
begin
     if not Assigned(uClean_SGBD_OPN) then exit;

     uClean_SGBD_OPN;
end;

procedure uClean_OPN_Requeteur( _SQL: String = '');
begin
     if not Assigned( uClean_SGBD_OPN_Requeteur) then exit;

     uClean_SGBD_OPN_Requeteur( _SQL);
end;

procedure uClean_Finalize;
var
//   I,
   LC: Integer;
begin
     if Finalize_OK then exit;
     Finalize_OK:= True;

     LC:= Liste.Count;
     if LC > 0
     then
         uClean_Log( 'uClean.Finalize, objets non détruits: '+Noms.Text);

     //Code désactivé car
     // si les objets n'ont pas été détruits correctement, on a toutes les
     // chances de générer des exceptions en les détruisant ici
     //for I:= LC-1 downto 0
     //do
     //  Clean_Destroy( Liste.Items[ I]^);

     Free_nil( Noms );
     Free_nil( Liste);
end;

procedure uClean_Initialize;
begin
     Liste:= TList.Create;
     Noms := TStringList.Create;
end;

initialization
              uClean_Initialize;
finalization
              uClean_Finalize;
end.


