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
    ujsDataContexte,
    uSGBD,
    uDataUtilsF,
    ufAccueil_Erreur,
  {$IFDEF FPC}
  mysql50conn, mysql51conn, mysql55conn, SQLDB,
  {$ELSE}
  SQLExpr,
  {$ENDIF}
  SysUtils, Classes;

type

 { TMySQL }

 TMySQL
 =
  class( TjsDataConnexion_SQLQuery)
  //Gestion du cycle de vie
  public
    constructor Create( _SGBD: TSGBD); override;
    destructor Destroy; override;
  //Initialisation des paramètres
  protected
    procedure InitParams;override;
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
    Version  : String;
  private
    sqlqSHOW_DATABASES: TSQLQuery;
  public
    procedure Prepare; override;
    procedure Ouvre_db; override;
    procedure Ferme_db; override;
    procedure Keep_Connection; override;
    procedure Do_not_Keep_Connection; override;
  //Last_Insert_id
  public
    function Last_Insert_id( {%H-}_NomTable: String): Integer; override;
  //méthodes pour schémateur
  public
    function Table_Cherche( _Table               : String): Boolean; override;
    function Index_Cherche( _Table, _Index       : String): Boolean; override;
    function Champ_Cherche( _Table, _Champ       : String): Boolean; override;
    function Champ_Type_Cherche( _Table, _Champ, _Type: String): Boolean; override;
    function Champ_Type_Defaut_Cherche( _Table, _Champ, _Type, _Defaut: String): Boolean; override;
  end;

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

constructor TMySQL.Create(_SGBD: TSGBD);
begin
     inherited Create( _SGBD);

     sqlqSHOW_DATABASES:= TSQLQuery.Create(nil);
     sqlqSHOW_DATABASES.SQL.Text:= 'show databases';
end;

destructor TMySQL.Destroy;
begin
     FreeAndnil( sqlqSHOW_DATABASES);
     inherited;
end;

procedure TMySQL.InitParams;
begin
     inherited InitParams;
     Version  := '50';
     Initialized:= False;

     {$ifndef android}
     Assure_initialisation;
     {$endif}
end;

procedure TMySQL.Assure_initialisation;
begin
     if Initialized then exit;
     Lit( regv_HostName , FHostName );HostName:= FHostName;
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
     inherited Ecrire;

     Ecrit( regv_HostName , HostName );
     Ecrit( regv_Database , DataBase );
     Ecrit( regv_User_Name, User_Name);
     Ecrit( regv_PassWord , PassWord , True);
     Ecrit( inik_Version  , Version);
end;

function TMySQL.Cree_SQLConnection: TSQLConnection;
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
       else if '57' = Version then Result:= TMySQL57Connection.Create( nil)
       else if '80' = Version then Result:= TMySQL80Connection.Create( nil)
       else
           begin
           Log.PrintLn( 'Attention version MySQL invalide dans _Configuration.ini: Version='+Version);
           Log.PrintLn( 'Version=50 pris par défaut');
           Result:= TMySQL50Connection.Create( nil);
           end;
     {$ELSE}
       Result:= TSQLConnection.Create( nil);
       Result.Params.Text
       :=
          'DriverUnit=Data.DBXMySQL'                                             +#13#10
         +'DriverPackageLoader=TDBXDynalinkDriverLoader,DbxCommonDriver250.bpl'
         +'DriverAssemblyLoader'
         +'='
         +  'Borland.Data.TDBXDynalinkDriverLoader,Borland.Data.DbxCommonDriver,'
         +  'Version=24.0.0.0,Culture=neutral,PublicKeyToken=91d62ebb5b0d1b1b'   +#13#10
         +'MetaDataPackageLoader'
         +'='
         +  'TDBXMySqlMetaDataCommandFactory,DbxMySQLDriver250.bpl'              +#13#10
         +'MetaDataAssemblyLoader'
         +'='
         +  'Borland.Data.TDBXMySqlMetaDataCommandFactory,'
         +  'Borland.Data.DbxMySQLDriver,Version=24.0.0.0,'
         +  'Culture=neutral,PublicKeyToken=91d62ebb5b0d1b1b'                    +#13#10
         +'GetDriverFunc=getSQLDriverMYSQL'                                      +#13#10
         +'LibraryName=dbxmys.dll'                                               +#13#10
         +'LibraryNameOsx=libsqlmys.dylib'                                       +#13#10
         +'VendorLib=LIBMYSQL.dll'                                               +#13#10
         +'VendorLibWin64=libmysql.dll'                                          +#13#10
         +'VendorLibOsx=libmysqlclient.dylib'                                    +#13#10
         +'HostName=ServerName'                                                  +#13#10
         +'Database=DBNAME'                                                      +#13#10
         +'User_Name=user'                                                       +#13#10
         +'Password=password'                                                    +#13#10
         +'MaxBlobSize=-1'                                                       +#13#10
         +'LocaleCode=0000'                                                      +#13#10
         +'Compressed=False'                                                     +#13#10
         +'Encrypted=False'                                                      +#13#10
         +'BlobSize=-1'                                                          +#13#10
         +'ErrorResourceFile='                                                   +#13#10
         ;
     {$ENDIF}
     //if Assigned( Result)
     //then
     //    Result.CharSet:= 'latin1';
     //    //Result.CharSet:= 'utf8';
     //    //Result.CharSet:= 'cp850';
end;

procedure TMySQL.Prepare;
begin
		   inherited Prepare;
     Database_indefinie:= (DataBase = sys_Vide) or (DataBase='---');
     if Database_indefinie
     then
         DataBase:= 'mysql'
     else
         Database_indefinie:= DataBase = 'mysql';

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

procedure TMySQL.Ouvre_db;
begin
		   inherited Ouvre_db;

     Connecte_SQLQuery( sqlqSHOW_DATABASES);
     if RefreshQuery( sqlqSHOW_DATABASES) // liste des bases mysql
     then
         sqlqSHOW_DATABASES.Locate('Database', DataBase, []);
end;

procedure TMySQL.Ferme_db;
begin
     sqlqSHOW_DATABASES.Close;

     inherited Ferme_db;
end;

procedure TMySQL.Keep_Connection;
begin
		   inherited Keep_Connection;
end;

procedure TMySQL.Do_not_Keep_Connection;
begin
		   inherited Do_not_Keep_Connection;
end;

function TMySQL.Last_Insert_id( _NomTable: String): Integer;
var
   SQL: String;
begin
     SQL:= 'select LAST_INSERT_ID()';
     Contexte.Integer_from( SQL, Result);
end;

function TMySQL.Table_Cherche(_Table: String): Boolean;
var
   SQL: String;
begin
     SQL
     :=
        'select                               '+LineEnding
       +'      *                              '+LineEnding
       +'from                                 '+LineEnding
       +'    information_schema.tables        '+LineEnding
       +'where                                '+LineEnding
       +'         table_schema = :table_schema'+LineEnding
       +'     and table_name   = :table_name  '+LineEnding
       ;
     Contexte.SQL:= SQL;
     with Contexte.Params
     do
       begin
       ParamByName( 'table_schema').AsString:= DataBase;
       ParamByName( 'table_name'  ).AsString:= _Table  ;
       end;
     Result:= Contexte.Execute_and_Result_not_empty;
end;

function TMySQL.Index_Cherche(_Table, _Index: String): Boolean;
begin
     Contexte.SQL:= 'show index from '+_Table+' from '+DataBase;
     Result:= Contexte.Locate(['Key_name'], [_Index]);
end;

function TMySQL.Champ_Cherche( _Table, _Champ: String): Boolean;
begin
     Contexte.SQL:= 'describe '+_Table+' '+ _Champ;
     Result:= Contexte.Execute_and_Result_not_empty;
end;

function TMySQL.Champ_Type_Cherche(_Table, _Champ, _Type: String): Boolean;

begin
     Contexte.SQL:= 'describe '+_Table+' '+ _Champ;

     Result:= Contexte.Matches(['Type'], [_Type]);
end;

function TMySQL.Champ_Type_Defaut_Cherche(_Table, _Champ, _Type, _Defaut: String): Boolean;
var
   LengthDefaut: Integer;
begin
     Contexte.SQL:= 'describe '+_Table+' '+ _Champ;

     //enlève les quotes de Defaut.
     //ne marche pas s'il y a des quotes à l'intérieur (improbable)
     LengthDefaut:= Length( _Defaut);
     if LengthDefaut > 0
     then
         begin
         if    ((_Defaut[1]='''') and (_Defaut[LengthDefaut]=''''))
            or ((_Defaut[1]='''' ) and (_Defaut[LengthDefaut]='''' ))
         then
             _Defaut:= Copy(_Defaut, 2, LengthDefaut-2)
         end;

     _Defaut:= LowerCase( _Defaut);

     Result:= Contexte.Matches(['Type','Default'], [_Type, _Defaut]);
end;

procedure TMySQL.Lit( NomValeur: String; out Valeur: String; _Mot_de_passe: Boolean= False);
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

procedure TMySQL.Ecrit( NomValeur: String; Valeur: String; _Mot_de_passe: Boolean= False);
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

end.
