unit uSGBD;
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
    uClean,
    u_sys_,
    u_ini_,
    uDataUtilsU,
    uEXE_INI,
    uPublieur,
    uParametres_Ligne_de_commande,
    ufAccueil_Erreur,
  SysUtils;

type
    TSGBD
    =
     (
     sgbd_Informix,
     sgbd_MySQL   ,
     sgbd_Postgres,
     sgbd_SQLServer,
     sgbd_SQLite3
     );
const
     sSGBDs: array[Low(TSGBD)..High(TSGBD)] of String
     =
      (
      'Informix',
      'MySQL',
      'Postgres',
      'SQLServer',
      'SQLite3'
      );
     sBATPRO6_SGBD: array[Low(TSGBD)..High(TSGBD)] of String
     =
      (
      'INFX',
      'MYSQL',
      'POSTGR',
      'SQLServer',
      'SQLite3'
      );

var
   pSGBDChange: TPublieur;

function SGBD: TSGBD;

procedure SGBD_Set( _Value: TSGBD; _Enregistrer_dans_INI: Boolean= False);

function sSGBD: String;

procedure SGBD_non_gere( _Ou: String);

function sgbdINFORMIX: Boolean;
function sgbdMYSQL   : Boolean;
function sgbdPOSTGRES: Boolean;
function sgbdSQLServer: Boolean;
function sgbdSQLite3 : Boolean;

function sgbd_Substr( _NomChamp: String; _Debut, _Fin: Integer): String;

function sgbd_First( _NbLignes: Integer = 1): String;
function sgbd_Limit( _NbLignes: Integer = 1): String;

var
   sgbd_DateSQL_function: function ( D: TDateTime): String = nil;
function sgbd_DateSQL( D: TDateTime): String;

var
   sgbd_DateTimeSQL_function: function ( D: TDateTime): String = nil;
// fonctionne mal avec informix, mieux vaut cr�er un objet TParams
// 2016/05/10: mais TParams ne fonctionne pas pour les dates avec SQLite3
function sgbd_DateTimeSQL( D: TDateTime): String;

procedure uSGBD_Compute;

procedure uSGBD_OPN;
procedure uSGBD_OPN_Requeteur( _SQL: String = '');

//CallBack vers OPN
type
    TSGBD_OPN_CallBack= procedure;
var
   uSGBD_OPN_Informix : TSGBD_OPN_CallBack = nil;
   uSGBD_OPN_MySQL    : TSGBD_OPN_CallBack = nil;
   uSGBD_OPN_SQLServer: TSGBD_OPN_CallBack = nil;
   uSGBD_OPN_SQLite3  : TSGBD_OPN_CallBack = nil;

implementation

var
   FSGBD: TSGBD;

function BATPRO6( _SGBD: TSGBD): Boolean;
begin
     Result:= sBATPRO6_SGBD[ _SGBD] = autoexec_SGBD;
     if not Result then exit;

     SGBD_Set( _SGBD, True);
end;

procedure uSGBD_Compute;
   function Traite_AUTOEXEC: Boolean;
   begin
        Result:= ModeAUTOEXEC;
        if not Result then exit;

        if BATPRO6( sgbd_Informix ) then exit;
        if BATPRO6( sgbd_MySQL    ) then exit;
        if BATPRO6( sgbd_Postgres ) then exit;
        if BATPRO6( sgbd_SQLServer) then exit;
        if BATPRO6( sgbd_SQLite3  ) then exit;
   end;

   function Traite_INI: Boolean;
   var
      iSGBD: Integer;
   begin
        iSGBD:= EXE_INI.ReadInteger( ini_Options, 'SGBD', -1);
        Result:= iSGBD <> -1;
        if not Result then exit;

        SGBD_Set( TSGBD( iSGBD));
   end;
begin
     {$ifdef android}
     SGBD_Set( sgbd_SQLite3); exit;
     {$endif}

     if Traite_AUTOEXEC then exit;
     if Traite_INI      then exit;
     SGBD_Set( sgbd_MySQL   );
end;

function SGBD: TSGBD;
begin
     Result:= FSGBD;
end;

procedure SGBD_Set( _Value: TSGBD; _Enregistrer_dans_INI: Boolean= False);
begin
     FSGBD:= _Value;
     if _Enregistrer_dans_INI
     then
         begin
         //2014  01 14 :l'�criture syst�matique produisait une erreur
         //"impossible d'�crire le fichier _Config.ini" chez bataille
         if Integer( FSGBD) <> EXE_INI.ReadInteger( ini_Options, 'SGBD', Integer( -1))
         then
             EXE_INI.WriteInteger( ini_Options, 'SGBD', Integer( FSGBD));
         end;
     case SGBD
     of
       sgbd_Informix : begin sgbd_DateSQL_function:= DateSQL_DMY2_Point; sgbd_DateTimeSQL_function:= DateTimeSQL_sans_quotes_DMY2; end;
       sgbd_MySQL    : begin sgbd_DateSQL_function:= DateSQL_Y4MD_Tiret; sgbd_DateTimeSQL_function:= DateTimeSQL_sans_quotes     ; end;
       sgbd_Postgres : begin sgbd_DateSQL_function:= DateSQL_Y4MD_Tiret; sgbd_DateTimeSQL_function:= DateTimeSQL_sans_quotes     ; end;
       sgbd_SQLServer: begin sgbd_DateSQL_function:= DateSQL_ISO8601   ; sgbd_DateTimeSQL_function:= DateTime_ISO8601_sans_quotes; end;
       sgbd_SQLite3  : begin sgbd_DateSQL_function:= DateSQL_Y4MD_Tiret; sgbd_DateTimeSQL_function:= DateTimeSQL_sans_quotes     ; end;
       else           SGBD_non_gere( 'uSGBD.SGBD_Set');
       end;
     pSGBDChange.Publie;
end;

function sSGBD: String;
begin
     Result:= sSGBDs[ SGBD];
end;

procedure SGBD_non_gere( _Ou: String);
begin
     fAccueil_Erreur(  'Erreur � signaler au d�veloppeur:'#13#10
                      +'  '+_Ou+': '
                      +'valeur de SGBD non g�r�e: '+sSGBD);
end;

function sgbdINFORMIX: Boolean;
begin
     Result:= sgbd_Informix = SGBD;
end;

function sgbdMYSQL   : Boolean;
begin
     Result:= sgbd_MySQL = SGBD;
end;

function sgbdPOSTGRES: Boolean;
begin
     Result:= sgbd_Postgres = SGBD;
end;

function sgbdSQLServer: Boolean;
begin
     Result:= sgbd_SQLServer = SGBD;
end;

function sgbdSQLite3: Boolean;
begin
     Result:= sgbd_SQLite3 = SGBD;
end;

function sgbd_Substr( _NomChamp: String; _Debut, _Fin: Integer): String;
var
   Longueur: Integer;
begin
     Longueur:= _fin - _Debut + 1;
     case SGBD
     of
       sgbd_Informix : Result:= Format( '%s[%d,%d]'                    ,[_NomChamp, _Debut, _Fin    ]);
       sgbd_MySQL    : Result:= Format( 'substring( %s,%d,%d)'         ,[_NomChamp, _Debut, Longueur]);
       sgbd_Postgres : Result:= Format( 'substring( %s from %d for %d)',[_NomChamp, _Debut, Longueur]);
       sgbd_SQLServer: Result:= Format( 'substring( %s,%d,%d)'         ,[_NomChamp, _Debut, Longueur]);
       sgbd_SQLite3  : Result:= Format( 'substr( %s,%d,%d)'            ,[_NomChamp, _Debut, Longueur]);
       else SGBD_non_gere( 'uSGBD.sgbd_Substr');
       end;

end;

function sgbd_First( _NbLignes: Integer = 1): String;
begin
     case SGBD
     of
       sgbd_Informix : Result:= 'first '+IntToStr( _NbLignes);
       sgbd_SQLServer: Result:= 'top '  +IntToStr( _NbLignes);
       else            Result:= '';
       end;
end;

function sgbd_Limit( _NbLignes: Integer = 1): String;
begin
     case SGBD
     of
       sgbd_MYSQL  : Result:= 'limit '+IntToStr( _NbLignes);
       sgbd_SQLite3: Result:= 'limit '+IntToStr( _NbLignes);
       else          Result:= '';
       end;
end;

function sgbd_DateSQL( D: TDateTime): String;
begin
     if Assigned( sgbd_DateSQL_function)
     then
         Result:= sgbd_DateSQL_function( D)
     else
         begin
         fAccueil_Erreur(  'Erreur � signaler au d�veloppeur:'#13#10
                      +'uSGBD.sgbd_DateSQL_function n''est pas initialis�e');
         Result:= '';
         end;
end;

// fonctionne mal avec informix, mieux vaut cr�er un objet TParams
function sgbd_DateTimeSQL( D: TDateTime): String;
begin
     if Assigned( sgbd_DateTimeSQL_function)
     then
         Result:= sgbd_DateTimeSQL_function( D)
     else
         begin
         fAccueil_Erreur(  'Erreur � signaler au d�veloppeur:'#13#10
                      +'uSGBD.sgbd_DateTimeSQL_function n''est pas initialis�e');
         Result:= '';
         end;
end;

procedure Do_uSGBD_OPN_Informix;
begin
     if Assigned( uSGBD_OPN_Informix)
     then
         uSGBD_OPN_Informix;
end;

procedure Do_uSGBD_OPN_MySQL;
begin
     if Assigned( uSGBD_OPN_MySQL)
     then
         uSGBD_OPN_MySQL;
end;

procedure Do_uSGBD_OPN_SQLServer;
begin
     if Assigned( uSGBD_OPN_SQLServer)
     then
         uSGBD_OPN_SQLServer;
end;

procedure Do_uSGBD_OPN_SQLite3;
begin
     if Assigned( uSGBD_OPN_SQLite3)
     then
         uSGBD_OPN_SQLite3;
end;

procedure uSGBD_OPN;
begin
     if not uClean_fMot_de_passe_OPN_OK( 'OPN') then exit;

     case SGBD
     of
       sgbd_Informix : Do_uSGBD_OPN_Informix;
       sgbd_MySQL    : Do_uSGBD_OPN_MySQL;
       sgbd_Postgres : Do_uSGBD_OPN_MySQL;
       sgbd_SQLServer: Do_uSGBD_OPN_SQLServer;
       sgbd_SQLite3  : Do_uSGBD_OPN_SQLite3;
       else SGBD_non_gere( 'uSGBD_OPN');
       end;
end;

procedure uSGBD_OPN_Requeteur( _SQL: String = '');
begin
     if not uClean_fMot_de_passe_OPN_OK( 'OPN') then exit;

     case SGBD
     of
       sgbd_Informix: uClean_UsesCase_Execute( 'Requeteur_Informix',[_SQL]);
       sgbd_MySQL   : uClean_UsesCase_Execute( 'Requeteur_MySQL'   ,[_SQL]);
       sgbd_Postgres: uClean_UsesCase_Execute( 'OPN_Postgres'      ,[_SQL]);
       sgbd_SQLServer: uClean_UsesCase_Execute( 'Requeteur_SQLServer'   ,[_SQL]);
       sgbd_SQLite3 : uClean_UsesCase_Execute( 'Requeteur_SQLite3' ,[_SQL]);
       else SGBD_non_gere( 'uSGBD_OPN_Requeteur');
       end;
end;

initialization
              pSGBDChange:= TPublieur.Create( 'uSGBD.pSGBDChange');
              uSGBD_Compute;

              uClean_SGBD_OPN:= uSGBD_OPN;
              uClean_SGBD_OPN_Requeteur:= uSGBD_OPN_Requeteur;
finalization
              uClean_SGBD_OPN:= nil;
              uClean_SGBD_OPN_Requeteur:= nil;

              Free_nil( pSGBDChange);
end.
