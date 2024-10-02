unit uODBC_Access;
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            http://www.mars42.com                                               |
                                                                                |
    Copyright 2019 Jean SUZINEAU - MARS42                                       |
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
  odbcconn,
  SQLDB,
  {$ELSE}
  SQLExpr,
  {$ENDIF}
  SysUtils, Classes,IniFiles;

type

 { TiniFileDSN }

 TiniFileDSN
 =
  class( TINIFile)
  //Gestion du cycle de vie
  public
    constructor Create(const FileName: string);
    destructor Destroy; override;
  //DBQ
  private
    function GetDBQ: String;
    procedure SetDBQ( _DBQ: String);
  public
    property DBQ: String read GetDBQ write SetDBQ;
  end;

 { TODBC_Access }

 TODBC_Access
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
  //FileDSN
  private
    FFileDSN: String;
    procedure SetFileDSN( _FileDSN: String);
  public
    property FileDSN: String read FFileDSN write SetFileDSN;
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
  //Contexte
  protected
    function Classe_Contexte: TjsDataContexte_class; override;
  //iniFileDSN
  private
    FiniFileDSN: TiniFileDSN;
  public
    function iniFileDSN: TiniFileDSN;
  end;

 { TjsDataContexte_SQLQuery_ODBC_Access }

 TjsDataContexte_SQLQuery_ODBC_Access
 =
  class( TjsDataContexte_SQLQuery)
  //Gestion du cycle de vie
  public
    constructor Create( _Name: String); override;
    destructor Destroy; override;
  end;

const
     inis_odbc  = 'ODBC_Access';
     inik_FileDSN='FileDSN';

function Crypto(S: String): String;

implementation

function Crypto(S: String): String; // avec un XOR, cryptage et d�cryptage
var                                 // se font de la m�me fa�on
   I: Integer;
begin
     Result:= S;
     for I:= 1 to Length( Result)
     do
       Result[I]:= Chr( Ord(Result[I]) XOR $31);
end;

{ TiniFileDSN }

constructor TiniFileDSN.Create(const FileName: string);
begin
     inherited Create( FileName);
end;

destructor TiniFileDSN.Destroy;
begin
     inherited Destroy;
end;

const
     TiniFileDSN_inis_ODBC='ODBC';
     TiniFileDSN_inik_DBQ ='DBQ';

function TiniFileDSN.GetDBQ: String;
begin
     Result:= ReadString( TiniFileDSN_inis_ODBC, TiniFileDSN_inik_DBQ, 'etc\ODBC_Access.dsn');
end;

procedure TiniFileDSN.SetDBQ( _DBQ: String);
begin
     WriteString( TiniFileDSN_inis_ODBC, TiniFileDSN_inik_DBQ, _DBQ);
end;

{ TjsDataContexte_SQLQuery_ODBC_Access }

constructor TjsDataContexte_SQLQuery_ODBC_Access.Create(_Name: String);
begin
     inherited Create( _Name);
     //sqlq.UsePrimaryKeyAsKey:= False;
     //sqlq.ParseSQL:= False;
end;

destructor TjsDataContexte_SQLQuery_ODBC_Access.Destroy;
begin
     inherited Destroy;
end;

{ TODBC_Access }

constructor TODBC_Access.Create(_SGBD: TSGBD);
begin
     inherited Create( _SGBD);

     FileDSN:= '';
     FiniFileDSN:= nil;
     Initialized:= False;

     {$ifndef android}
     Assure_initialisation;
     {$endif}
end;

destructor TODBC_Access.Destroy;
begin
     FreeAndNil( FiniFileDSN);
     inherited;
end;

procedure TODBC_Access.Assure_initialisation;
begin
     if Initialized then exit;
     Lit( inik_FileDSN, FFileDSN);
     FreeAndNil( FiniFileDSN);//inutile, mais au cas o� ...

     if FileDSN = ''
     then
         begin
         FileDSN:= ChangeFileExt( uClean_EXE_Name, '.dsn');
         Ecrit( inik_FileDSN  , FileDSN);
         end;
     Initialized:= True;
end;

procedure TODBC_Access.Ecrire;
begin
     inherited Ecrire;

     Ecrit( inik_FileDSN  , FileDSN);
end;

function TODBC_Access.Cree_SQLConnection: TSQLConnection;
begin
     {$ifndef android}
     Log.PrintLn( 'Fichier ini:' +EXE_INI.FileName);
     {$endif}
     Log.PrintLn( 'uODBC param�tr� pour le dsn: '+FileDSN);
     {$IFDEF FPC}
     Result:= TODBCConnection.Create( nil);
     {$ELSE}
     Result:= nil;
     {$ENDIF}
     //if Assigned( Result)
     //then
         //Result.CharSet:= 'latin1';
         //Result.CharSet:= 'utf8';
         //Result.CharSet:= 'cp850';
end;

procedure TODBC_Access.SetFileDSN( _FileDSN: String);
begin
     FFileDSN:= _FileDSN;
     FreeAndNil( FiniFileDSN);
end;

procedure TODBC_Access.Prepare;
begin
     inherited Prepare;
     Database_indefinie:= not FileExists( FileDSN);

     Ouvrable:= not Database_indefinie;

     //(sqlc as TODBCConnection).FileDSN:= FileDSN;
     sqlc.Params.Values['FileDSN']:= FileDSN; // � confirmer
end;

procedure TODBC_Access.Ouvre_db;
begin
     inherited Ouvre_db;
end;

procedure TODBC_Access.Ferme_db;
begin
     inherited Ferme_db;
end;

procedure TODBC_Access.Keep_Connection;
begin
     inherited Keep_Connection;
end;

procedure TODBC_Access.Do_not_Keep_Connection;
begin
     inherited Do_not_Keep_Connection;
end;

function TODBC_Access.Last_Insert_id( _NomTable: String): Integer;
var
   SQL: String;
begin
     SQL:= 'select LAST_INSERT_ID()';
     Contexte.Integer_from( SQL, Result);
end;

function TODBC_Access.Classe_Contexte: TjsDataContexte_class;
begin
     Result:= TjsDataContexte_SQLQuery_ODBC_Access;
end;

function TODBC_Access.iniFileDSN: TiniFileDSN;
begin
     if nil = FiniFileDSN
     then
         FiniFileDSN:= TiniFileDSN.Create( FileDSN);
     Result:= FiniFileDSN;
end;

procedure TODBC_Access.Lit( NomValeur: String; out Valeur: String; _Mot_de_passe: Boolean= False);
var
   ValeurBrute: String;
begin
     ValeurBrute:= EXE_INI.ReadString( inis_odbc, NomValeur, sys_Vide);
     if _Mot_de_passe
     then
         Valeur:= Crypto( ValeurBrute)
     else
         Valeur:= ValeurBrute;
end;

procedure TODBC_Access.Ecrit( NomValeur: String; Valeur: String; _Mot_de_passe: Boolean= False);
var
   ValeurBrute: String;
begin
     if NomValeur = ''
     then
         fAccueil_Erreur(  'Erreur � signaler au d�veloppeur:'#13#10
                          +'   '+ClassName+'.Ecrit: NomValeur est vide');
     if _Mot_de_passe
     then
         ValeurBrute:= Crypto( Valeur)
     else
         ValeurBrute:= Valeur;

     EXE_INI.WriteString( inis_odbc, NomValeur, ValeurBrute);
end;

end.
