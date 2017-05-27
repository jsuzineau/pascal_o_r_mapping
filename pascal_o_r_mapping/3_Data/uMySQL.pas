unit uMySQL;
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
    uLog,
    u_sys_,
    uRegistry,
    uEXE_INI,
    uSGBD,
    ufAccueil_Erreur,
  {$IFDEF FPC}
  mysql50conn, mysql51conn, mysql55conn, mysql56conn, SQLDB,
  {$ELSE}
  SQLExpr,
  {$ENDIF}
  SysUtils, Classes;

type

 { TMySQL }

 TMySQL
 =
  class
  //Gestion du cycle de vie
  public
    constructor Create;
    destructor Destroy; override;
  //Persistance dans la base de registre
  private
    Initialized: Boolean;
    procedure Lit  (NomValeur: String; var Valeur: String; _Mot_de_passe: Boolean= False);
    procedure Ecrit(NomValeur: String; var Valeur: String; _Mot_de_passe: Boolean= False);
  public
    procedure Assure_initialisation;
    procedure Ecrire;
  //Attributs
  public
    HostName : String;
    DataBase : String;
    User_Name: String;
    Password : String;
    Version  : String;
    function Cree_Connection: TSQLConnection;
  end;

var
   MySQL: TMySQL;

const
     inis_mysql  = 'mysql';
     inik_Version='Version';

function Crypto(S: String): String;

implementation

function Crypto(S: String): String; // avec un XOR, cryptage et décryptage
var                                 // se font de la même façon
   I: Integer;
begin
     Result:= S;
     for I:= 1 to Length( Result)
     do
       Result[I]:= Chr( Ord(Result[I]) XOR $31);
end;

{ TMySQL }

constructor TMySQL.Create;
begin
     inherited;
     HostName := sys_Vide;
     DataBase := sys_Vide;
     User_Name:= sys_Vide;
     Password := sys_Vide;
     Version  := '50';
     Initialized:= False;

     {$ifndef android}
     Assure_initialisation;
     {$endif}
end;

destructor TMySQL.Destroy;
begin
     inherited;
end;

procedure TMySQL.Assure_initialisation;
begin
     if Initialized then exit;
     Lit( regv_HostName , HostName );
     Lit( regv_Database , DataBase );
     Lit( regv_User_Name, User_Name);
     Lit( regv_PassWord , PassWord , True);
     Lit( inik_Version  , Version);
     if Version = ''
     then
         begin
         Version:= '50';
         Ecrit( inik_Version  , Version);
         end;
     Initialized:= True;
end;

procedure TMySQL.Ecrire;
begin
     Ecrit( regv_HostName , HostName );
     Ecrit( regv_Database , DataBase );
     Ecrit( regv_User_Name, User_Name);
     Ecrit( regv_PassWord , PassWord , True);
     Ecrit( inik_Version  , Version);
end;

function TMySQL.Cree_Connection: TSQLConnection;
begin
     {$ifndef android}
     Log.PrintLn( 'Fichier ini:' +EXE_INI.FileName);
     {$endif}
     Log.PrintLn( 'uMySQL paramétré pour MySQL version : '+Version);
     {$IFDEF FPC}
          if '50' = Version then Result:= TMySQL50Connection.Create( nil)
     else if '51' = Version then Result:= TMySQL51Connection.Create( nil)
     else if '55' = Version then Result:= TMySQL55Connection.Create( nil)
     else if '56' = Version then Result:= TMySQL56Connection.Create( nil)
     else
         begin
         Log.PrintLn( 'Attention version MySQL invalide dans _Configuration.ini: Version='+Version);
         Log.PrintLn( 'Version=50 pris par défaut');
         Result:= TMySQL50Connection.Create( nil);
         end;
     {$ELSE}
     Result:= nil;
     {$ENDIF}
     if Assigned( Result)
     then
         Result.CharSet:= 'latin1';
         //Result.CharSet:= 'utf8';
         //Result.CharSet:= 'cp850';
end;

procedure TMySQL.Lit( NomValeur: String; var Valeur: String; _Mot_de_passe: Boolean= False);
var
   ValeurBrute: String;
begin
     ValeurBrute:= EXE_INI.ReadString( inis_mysql, NomValeur, sys_Vide);
     if _Mot_de_passe
     then
         Valeur:= Crypto( ValeurBrute)
     else
         Valeur:= ValeurBrute;
end;

procedure TMySQL.Ecrit( NomValeur: String; var Valeur: String; _Mot_de_passe: Boolean= False);
var
   ValeurBrute: String;
begin
     if NomValeur = ''
     then
         fAccueil_Erreur(  'Erreur à signaler au développeur:'#13#10
                          +'   TMySQL.Ecrit: NomValeur est vide');
     if _Mot_de_passe
     then
         ValeurBrute:= Crypto( Valeur)
     else
         ValeurBrute:= Valeur;

     EXE_INI.WriteString( inis_mysql, NomValeur, ValeurBrute);
end;

initialization
              MySQL:= TMySQL.Create;
finalization
              Free_nil( MySQL);
end.
