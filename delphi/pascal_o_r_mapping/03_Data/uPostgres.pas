unit uPostgres;
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            partly as freelance: http://www.mars42.com                          |
        and partly as employee : http://www.adinfo.com                          |
                                 http://www.adi-bat.com                         |
    Copyright 2017 Jean SUZINEAU - MARS42                                       |
    Copyright 2017 GROUPE ADINFO SOFTWARE                                       |
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
    uRegistry,
    uEXE_INI,
    uSGBD,
    ufAccueil_Erreur,
  SysUtils, Classes;

type
 TPostgres
 =
  class
  //Gestion du cycle de vie
  public
    constructor Create;
    destructor Destroy; override;
  //Persistance dans la base de registre
  private
    Initialized: Boolean;
    procedure Lit  ( NomValeur: String; var Valeur: String; _Mot_de_passe: Boolean= False);
    procedure Ecrit( NomValeur: String; var Valeur: String; _Mot_de_passe: Boolean= False);
  public
    procedure Assure_initialisation;
    procedure Ecrire;
  //Attributs
  public
    HostName : String;
    User_Name: String;
    Password : String;
    DataBase : String;
    SchemaName: String;
  end;

var
   Postgres: TPostgres;

const
     inis_Postgres= 'Postgres';

function Crypto( S: String): String;

implementation

function Crypto( S: String): String; // avec un XOR, cryptage et décryptage
var                                  // se font de la même façon
   I: Integer;
begin
     Result:= S;
     for I:= 1 to Length( Result)
     do
       Result[I]:= Chr( Ord(Result[I]) XOR $31);
end;

{ TPostgres }

constructor TPostgres.Create;
begin
     inherited;
     HostName := sys_Vide;
     User_Name:= sys_Vide;
     Password := sys_Vide;
     DataBase := sys_Vide;
     SchemaName:= 'public';
     Initialized:= False;

     Assure_initialisation;
end;

destructor TPostgres.Destroy;
begin
     inherited;
end;

procedure TPostgres.Assure_initialisation;
begin
     if Initialized then exit;
     Lit( regv_HostName  , HostName );
     Lit( regv_User_Name , User_Name);
     Lit( regv_PassWord  , PassWord , True);
     Lit( regv_Database  , DataBase );
     Lit( regv_SchemaName, SchemaName );
     Initialized:= True;
end;

procedure TPostgres.Ecrire;
begin
     Ecrit( regv_HostName  , HostName );
     Ecrit( regv_User_Name , User_Name);
     Ecrit( regv_PassWord  , PassWord , True);
     Ecrit( regv_Database  , DataBase  );
     Ecrit( regv_SchemaName, SchemaName);
end;

procedure TPostgres.Lit( NomValeur: String; var Valeur: String; _Mot_de_passe: Boolean= False);
var
   ValeurBrute: String;
begin
     ValeurBrute:= EXE_INI.ReadString( inis_Postgres, NomValeur, sys_Vide);
     if _Mot_de_passe
     then
         Valeur:= Crypto( ValeurBrute)
     else
         Valeur:= ValeurBrute;
end;

procedure TPostgres.Ecrit(NomValeur: String; var Valeur: String; _Mot_de_passe: Boolean= False);
var
   ValeurBrute: String;
begin
     if NomValeur = ''
     then
         fAccueil_Erreur(  'Erreur à signaler au développeur:'#13#10
                          +'   TInformix.Ecrit: NomValeur est vide');
     if _Mot_de_passe
     then
         ValeurBrute:= Crypto( Valeur)
     else
         ValeurBrute:= Valeur;

     EXE_INI.WriteString( inis_Postgres, NomValeur, ValeurBrute);
end;

initialization
              Postgres:= TPostgres.Create;
finalization
              Free_nil( Postgres);
end.
