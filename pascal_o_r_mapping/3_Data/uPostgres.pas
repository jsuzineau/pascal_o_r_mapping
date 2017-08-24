unit uPostgres;
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
    uRegistry,
    uEXE_INI,
    ujsDataContexte,
    uSGBD,
    ufAccueil_Erreur,
  SysUtils, Classes;

type

	{ TPostgres }

 TPostgres
 =
  class( TjsDataConnexion_SQLQuery)
  //Gestion du cycle de vie
  public
    constructor Create( _SGBD: TSGBD); override;
    destructor Destroy; override;
  //Persistance dans la base de registre
  private
    Initialized: Boolean;
    procedure Lit  ( NomValeur: String; out Valeur: String; _Mot_de_passe: Boolean= False);
    procedure Ecrit( NomValeur: String;     Valeur: String; _Mot_de_passe: Boolean= False);
  public
    procedure Assure_initialisation;
    procedure Ecrire; override;
  //Attributs
  public
    SchemaName: String;
  public
    procedure Prepare; override;
    procedure Ouvre_db; override;
    procedure Ferme_db; override;
    procedure Keep_Connection; override;
    procedure Do_not_Keep_Connection; override;
  //Last_Insert_id
  public
    function Last_Insert_id( _NomTable: String): Integer; override;
  end;

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

constructor TPostgres.Create( _SGBD: TSGBD);
begin
     inherited Create( _SGBD);
     SchemaName:= 'public';
     Initialized:= False;

     {$ifndef android}
     Assure_initialisation;
     {$endif}
end;

destructor TPostgres.Destroy;
begin
     inherited;
end;

procedure TPostgres.Assure_initialisation;
begin
     if Initialized then exit;
     Lit( regv_HostName  , FHostName );HostName:= FHostName;
     Lit( regv_User_Name , User_Name);
     Lit( regv_PassWord  , PassWord , True);
     Lit( regv_Database  , DataBase );
     Lit( regv_SchemaName, SchemaName );
     Initialized:= True;
end;

procedure TPostgres.Ecrire;
begin
     inherited Ecrire;

     Ecrit( regv_HostName  , HostName );
     Ecrit( regv_User_Name , User_Name);
     Ecrit( regv_PassWord  , PassWord , True);
     Ecrit( regv_Database  , DataBase  );
     Ecrit( regv_SchemaName, SchemaName);
end;

procedure TPostgres.Lit( NomValeur: String; out Valeur: String; _Mot_de_passe: Boolean= False);
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

procedure TPostgres.Ecrit(NomValeur: String;     Valeur: String; _Mot_de_passe: Boolean= False);
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

procedure TPostgres.Prepare;
begin
		   inherited Prepare;
     Database_indefinie:= DataBase = sys_Vide;
     if Database_indefinie
     then
         DataBase:= 'postgres'
     else
         Database_indefinie:= DataBase = 'postgres';

     Ouvrable
     :=
           (HostName  <> sys_Vide)
       and (User_Name <> sys_Vide)
       and (Database  <> sys_Vide);

     WriteParam( 'HostName'  , HostName  );
     WriteParam( 'User_Name' , User_Name );
     WriteParam( 'Password'  , Password  );
     WriteParam( 'DataBase'  , Database  );
     WriteParam( 'SchemaName', SchemaName);
end;

procedure TPostgres.Ouvre_db;
begin
		   inherited Ouvre_db;
end;

procedure TPostgres.Ferme_db;
begin
		   inherited Ferme_db;
end;

procedure TPostgres.Keep_Connection;
begin
		   inherited Keep_Connection;
end;

procedure TPostgres.Do_not_Keep_Connection;
begin
		   inherited Do_not_Keep_Connection;
end;

function TPostgres.Last_Insert_id( _NomTable: String): Integer;
var
   SQL: String;
begin
     SQL:= 'select currval( '''+_NomTable+'_SEQ'')';
     Contexte.Integer_from( SQL, Result);
end;

end.
