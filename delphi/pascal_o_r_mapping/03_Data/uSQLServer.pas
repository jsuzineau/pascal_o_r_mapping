unit uSQLServer;
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
    uBatpro_StringList,
    uEXE_INI,
    uSGBD,
    ujsDataContexte,
    ufAccueil_Erreur,
  {$IFDEF FPC}
    SQLDB,
    mssqlconn,
  {$ELSE}
     SQLExpr,
  {$ENDIF}
  SysUtils, Classes;

type

 { TSQLServer }

 TSQLServer
 =
  class( TjsDataConnexion_SQLQuery)
  //Gestion du cycle de vie
  public
    constructor Create( _SGBD: TSGBD); override;
    destructor Destroy; override;
  //Persistance dans la base de registre
  private
    Initialized: Boolean;
    procedure Lit  (NomValeur: String; out Valeur: String; _Mot_de_passe: Boolean= False);
    procedure Ecrit(NomValeur: String;     Valeur: String; _Mot_de_passe: Boolean= False);
  public
    procedure Assure_initialisation;
    procedure Ecrire; override;
  //Connexion
  protected
    function Cree_SQLConnection: TSQLConnection; override;
  //Attributs
  public
    procedure Prepare; override;
    procedure Ouvre_db; override;
    procedure Ferme_db; override;
    procedure Keep_Connection; override;
    procedure Do_not_Keep_Connection; override;
  //Last_Insert_id
  public
    function Last_Insert_id( {%H-}_NomTable: String): Integer; override;
  end;

const
     inis_SQLServer  = 'SQLServer';

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

{ TSQLServer }

constructor TSQLServer.Create( _SGBD: TSGBD);
begin
     inherited Create( _SGBD);
     Initialized:= False;

     {$ifndef android}
     Assure_initialisation;
     {$endif}
end;

destructor TSQLServer.Destroy;
begin
     inherited;
end;

procedure TSQLServer.Assure_initialisation;
begin
     if Initialized then exit;
     Lit( regv_HostName , FHostName );HostName:= FHostName;
     Lit( regv_Database , DataBase );
     Lit( regv_User_Name, User_Name);
     Lit( regv_PassWord , PassWord , True);

     Initialized:= True;
end;

procedure TSQLServer.Ecrire;
begin
     inherited Ecrire;

     Ecrit( regv_HostName , HostName );
     Ecrit( regv_Database , DataBase );
     Ecrit( regv_User_Name, User_Name);
     Ecrit( regv_PassWord , PassWord , True);
end;

function TSQLServer.Cree_SQLConnection: TSQLConnection;
begin
     Result:= TSQLConnection.Create(nil);
end;

procedure TSQLServer.Lit( NomValeur: String; out Valeur: String; _Mot_de_passe: Boolean= False);
var
   ValeurBrute: String;
begin
     ValeurBrute:= EXE_INI.ReadString( inis_SQLServer, NomValeur, sys_Vide);
     if _Mot_de_passe
     then
         Valeur:= Crypto( ValeurBrute)
     else
         Valeur:= ValeurBrute;
end;

procedure TSQLServer.Ecrit( NomValeur: String;     Valeur: String; _Mot_de_passe: Boolean= False);
var
   ValeurBrute: String;
begin
     if NomValeur = ''
     then
         fAccueil_Erreur(  'Erreur à signaler au développeur:'#13#10
                          +'   TSQLServer.Ecrit: NomValeur est vide');
     if _Mot_de_passe
     then
         ValeurBrute:= Crypto( Valeur)
     else
         ValeurBrute:= Valeur;

     EXE_INI.WriteString( inis_SQLServer, NomValeur, ValeurBrute);
end;

procedure TSQLServer.Prepare;
begin
     Database_indefinie:= (DataBase = sys_Vide) or (DataBase='---');
     if Database_indefinie
     then
         DataBase:= 'SQLServer'
     else
         Database_indefinie:= DataBase = 'SQLServer';

     Ouvrable
     :=
           (HostName  <> sys_Vide)
       and (User_Name <> sys_Vide)
       and (Database  <> sys_Vide);

     WriteParam( 'HostName' , HostName );
     WriteParam( 'User_Name', User_Name);
     WriteParam( 'Password' , Password );
     WriteParam( 'DataBase' , Database );
end;

procedure TSQLServer.Ouvre_db;
begin

end;

procedure TSQLServer.Ferme_db;
begin

end;

procedure TSQLServer.Keep_Connection;
begin

end;

procedure TSQLServer.Do_not_Keep_Connection;
begin

end;

function TSQLServer.Last_Insert_id( _NomTable: String): Integer;
begin
     raise Exception.Create(ClassName+'.Last_Insert_id non implémenté');
end;

end.
