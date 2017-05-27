unit uSQLite3;
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
  sqlite3conn, SQLDB,
  SysUtils, Classes;

type

 { TSQLite3 }

 TSQLite3
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
    DataBase: String;
    function Cree_Connection: TSQLite3Connection;
  end;

var
   SQLite3: TSQLite3;

const
     inis_sqlite3  = 'SQLite3';

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

{ TSQLite3 }

constructor TSQLite3.Create;
begin
     inherited;
     DataBase := sys_Vide;
     Initialized:= False;

     {$ifndef android}
     Assure_initialisation;
     {$endif}
end;

destructor TSQLite3.Destroy;
begin
     inherited;
end;

procedure TSQLite3.Assure_initialisation;
begin
     if Initialized then exit;
     Lit( regv_Database , DataBase);
     Initialized:= True;
end;

procedure TSQLite3.Ecrire;
begin
     Ecrit( regv_Database , DataBase );
end;

function TSQLite3.Cree_Connection: TSQLite3Connection;
begin
     Result:= TSQLite3Connection.Create(nil);
     if Assigned( Result)
     then
         Result.CharSet:= 'latin1';
         //Result.CharSet:= 'utf8';
         //Result.CharSet:= 'cp850';
end;

procedure TSQLite3.Lit( NomValeur: String; var Valeur: String; _Mot_de_passe: Boolean= False);
var
   ValeurBrute: String;
begin
     ValeurBrute:= EXE_INI.ReadString( inis_sqlite3, NomValeur, sys_Vide);
     if _Mot_de_passe
     then
         Valeur:= Crypto( ValeurBrute)
     else
         Valeur:= ValeurBrute;
end;

procedure TSQLite3.Ecrit( NomValeur: String; var Valeur: String; _Mot_de_passe: Boolean= False);
var
   ValeurBrute: String;
begin
     if NomValeur = ''
     then
         fAccueil_Erreur(  'Erreur à signaler au développeur:'#13#10
                          +'   TSQLite3.Ecrit: NomValeur est vide');
     if _Mot_de_passe
     then
         ValeurBrute:= Crypto( Valeur)
     else
         ValeurBrute:= Valeur;

     EXE_INI.WriteString( inis_sqlite3, NomValeur, ValeurBrute);
end;

initialization
              SQLite3:= TSQLite3.Create;
finalization
              Free_nil( SQLite3);
end.
