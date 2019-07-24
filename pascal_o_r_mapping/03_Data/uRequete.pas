unit uRequete;
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
    uBatpro_StringList,
    uuStrings,
    uDataUtilsF,
    uSGBD,
    ujsDataContexte,

    udmDatabase,

  SysUtils, Classes, SQLDB, DB;
type

 { TRequete }

 TRequete
 =
  class
  //Gestion du cycle de vie
  public
    constructor Create( _Connexion: Tfunction_GetConnexion);
    destructor Destroy; override;
  //Connection
  public
    Connexion: Tfunction_GetConnexion;
  //SQLQuery
  public
    sqlq: TSQLQuery;
  //Utilitaires
  public
    function Est_Vide( _SQL: String): Boolean;
  //Integer_from
  public
    function Integer_from(_SQL: String; out _Resultat: Integer): Boolean; overload;
    function Integer_from(_SQL, _NomChamp: String; out _Resultat: Integer): Boolean; overload;
    function Integer_from(_SQL, _NomChamp: String; _Params: TParams; out _Resultat: Integer): Boolean; overload;
  //Récupération d'une valeur chaine à partir d'une requete
  public
    function String_from( _SQL: String; var _Resultat: String; _Index: Integer= 0): Boolean; overload;
    function String_from( _SQL, _NomChamp: String; var _Resultat: String): Boolean; overload;
    function String_from( _SQL, _NomChamp: String; _Params: TParams; out _Resultat: String): Boolean; overload;
  //Informix_ROWID_from_Serial
  public
    function Informix_ROWID_from_Serial( NomTable, NomSerial: String): Integer;
  //MYSQL_storage_engine
  public
    function MYSQL_storage_engine: String;
    function MYSQL_storage_engine_Is_MyISAM: Boolean;
  //MySQL codepage
  public
    procedure MySQL_codepage( _codepage: String);
    procedure MySQL_UTF8;
    procedure MySQL_latin1;
    procedure MySQL_cp850;
  //Listage d'un champ vers une liste
  public
    procedure Liste_Champ( _SQL, _NomChamp: String; _Resultat: TStrings);
  //Liste des noms des champs d'une table
  public
    procedure GetFieldNames(const _TableName:String; _List:TStrings);
  //Liste des tables
  private
    FNomsTables: TStringList;
    function GetNomsTables: TStringList;
  public
    procedure GetTableNames( _List:TStrings);
    property NomsTables: TStringList read GetNomsTables;
    function Table_Existe( _NomTable: String): Boolean;
  //Liste des schemas
  public
    procedure GetSchemaNames( _List:TStrings);
  //Requete SQL pour message erreur
  public
    function sResultat_from_Requete( _SQL: String): String;
  //SQL
  private
    function GetSQL: String;
    procedure SetSQL(const Value: String);
  public
    property SQL: String read GetSQL write SetSQL;
  //Params
  private
    function GetParams: TParams;
    procedure SetParams(const Value: TParams);
  public
    property Params: TParams read GetParams write SetParams;
  //Execute
  public
    function Execute: Boolean;
  end;

function Requete: TRequete;

implementation

var
   FRequete: TRequete= nil;

function Requete: TRequete;
begin
     if nil = FRequete
     then
         FRequete:= TRequete.Create( dmDatabase.Get_jsDataConnexion);
     Result:= FRequete;
end;

{ TRequete }

constructor TRequete.Create(_Connexion: Tfunction_GetConnexion);
begin
     inherited Create;

     Connexion:= _Connexion;

     sqlq:= TSQLQuery.Create( nil);
     sqlq.Name:= 'sqlq';

     FNomsTables:= nil;
end;

destructor TRequete.Destroy;
begin

  inherited;
end;

function TRequete.Est_Vide( _SQL: String): Boolean;
begin
     Result:= Connexion.Contexte.Est_Vide( _SQL);
end;

function TRequete.Integer_from( _SQL: String; out _Resultat: Integer): Boolean;
begin
     Result:= Connexion.Contexte.Integer_from( _SQL, _Resultat);
end;

function TRequete.Integer_from( _SQL, _NomChamp: String; out _Resultat: Integer): Boolean;
begin
     Result:= Connexion.Contexte.Integer_from( _SQL, _NomChamp, _Resultat);
end;

function TRequete.Integer_from( _SQL, _NomChamp: String; _Params: TParams;
                                out _Resultat: Integer): Boolean;
begin
     Result:= Connexion.Contexte.Integer_from( _SQL, _NomChamp, _Params, _Resultat);
end;

function TRequete.Informix_ROWID_from_Serial( NomTable, NomSerial: String): Integer;
var
   nSerial: Integer;
   SQL: String;
begin
     nSerial:= Connexion.LAST_INSERT_ID( NomTable);
     SQL
     :=
       Format( 'select rowid from %s where %s = %d',
               [NomTable, NomSerial, nSerial]);
     Integer_from( SQL, Result);
end;

procedure TRequete.MySQL_codepage( _codepage: String);
begin
     if not sgbdMYSQL then exit;

     SQL:= 'SET CHARACTER SET `'+_codepage+'`';
     Execute;
     SQL:= 'SET NAMES `'+_codepage+'`';
     Execute;
end;

procedure TRequete.MySQL_UTF8;
begin
     MySQL_codepage( 'utf8');
end;

procedure TRequete.MySQL_latin1;
begin
     MySQL_codepage( 'latin1');
end;

procedure TRequete.MySQL_cp850;
begin
     MySQL_codepage( 'cp850');
end;

function TRequete.String_from( _SQL: String; var _Resultat: String; _Index: Integer= 0): Boolean;
begin
     Result:= Connexion.Contexte.String_from( _SQL, _Resultat, _Index);
end;

function TRequete.String_from( _SQL, _NomChamp: String; var _Resultat: String): Boolean;
begin
     Result:= Connexion.Contexte.String_from( _SQL, _NomChamp, _Resultat);
end;

function TRequete.String_from( _SQL, _NomChamp: String; _Params: TParams;
                               out _Resultat: String): Boolean;
begin
     Result:= Connexion.Contexte.String_from( _SQL, _NomChamp, _Params, _Resultat);
end;

function TRequete.MYSQL_storage_engine: String;
begin
     String_from( 'show variables like "storage_engine"', Result, 1);
end;

function TRequete.MYSQL_storage_engine_Is_MyISAM: Boolean;
begin
     Result:= 'MyISAM' = MYSQL_storage_engine;
end;

procedure TRequete.Liste_Champ( _SQL, _NomChamp: String; _Resultat: TStrings);
begin
     Connexion.Contexte.Liste_Champ( _SQL, _NomChamp, _Resultat);
end;

function TRequete.sResultat_from_Requete( _SQL: String): String;
begin
     Result:= Connexion.Contexte.sResultat_from_Requete( _SQL);
end;

function TRequete.GetSQL: String;
begin
     Result:= Connexion.Contexte.SQL;
end;

procedure TRequete.SetSQL(const Value: String);
begin
     Connexion.Contexte.SQL:= Value;
end;

function TRequete.GetParams: TParams;
begin
     Result:= Connexion.Contexte.Params;
end;

procedure TRequete.SetParams(const Value: TParams);
begin
     Connexion.Contexte.Params.AssignValues( Value);
end;

function TRequete.Execute: Boolean;
begin
     Result:= Connexion.Contexte.ExecSQLQuery;
end;

procedure TRequete.GetFieldNames( const _TableName: String; _List: TStrings);
begin
     Connexion.GetFieldNames( _TableName, _List);
end;

procedure TRequete.GetTableNames( _List: TStrings);
begin
     Connexion.GetTableNames( _List);
end;

procedure TRequete.GetSchemaNames(_List: TStrings);
begin
     Connexion.GetSchemaNames( _List);
end;

function TRequete.GetNomsTables: TStringList;
begin
     if FNomsTables = nil
     then
         begin
         FNomsTables:= TStringList.Create;
         GetTableNames( FNomsTables);
         end;

     Result:= FNomsTables;
end;

function TRequete.Table_Existe( _NomTable: String): Boolean;
begin
     Result:= -1 <> NomsTables.IndexOf( _NomTable);
end;

initialization

finalization
            Free_nil( FRequete);
end.
