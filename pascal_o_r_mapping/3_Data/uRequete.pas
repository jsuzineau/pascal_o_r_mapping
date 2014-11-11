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
    uuStrings,
    uDataUtilsF,

    udmDatabase,

  SysUtils, Classes, SQLDB, DB;
type

 { TRequete }

 TRequete
 =
  class
  //Gestion du cycle de vie
  public
    constructor Create( _Connection: Tfunction_GetConnection);
    destructor Destroy; override;
  //Connection
  public
    Connection: Tfunction_GetConnection;
  //SQLQuery
  public
    sqlq: TSQLQuery;
  //Utilitaires
  public
    function Est_Vide( _SQL: String): Boolean;
  //Integer_from
  public
    function Integer_from(_SQL: String; var _Resultat: Integer): Boolean; overload;
    function Integer_from(_SQL, _NomChamp: String; var _Resultat: Integer): Boolean; overload;
    function Integer_from(_SQL, _NomChamp: String; _Params: TParams; var _Resultat: Integer): Boolean; overload;
  //Récupération d'une valeur chaine à partir d'une requete
  public
    function String_from( _SQL: String; var _Resultat: String): Boolean; overload;
    function String_from( _SQL, _NomChamp: String; var _Resultat: String): Boolean; overload;
  //Informix_ROWID_from_Serial
  public
    function Informix_ROWID_from_Serial( NomTable, NomSerial: String): Integer;
  //Last_Insert_Id Informix
  public
    function LAST_INSERT_ID_Informix: Integer;
  //MYSQL_storage_engine
  public
    function MYSQL_storage_engine: String;
    function MYSQL_storage_engine_Is_MyISAM: Boolean;
  //Last_Insert_Id MySQL
  public
    function LAST_INSERT_ID_MySQL: Integer;
  //MySQL codepage
  public
    procedure MySQL_codepage( _codepage: String);
    procedure MySQL_UTF8;
    procedure MySQL_latin1;
    procedure MySQL_cp850;
  //Last_Insert_Id Postgres
  public
    function LAST_INSERT_ID_Postgres( _NomTable: String): Integer;
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

function     Requete: TRequete;
function GED_Requete: TRequete;

implementation

var
       FRequete: TRequete= nil;
   FGED_Requete: TRequete= nil;

function Requete: TRequete;
begin
     if nil = FRequete
     then
         FRequete:= TRequete.Create( dmDatabase.Connection);
     Result:= FRequete;
end;

function GED_Requete: TRequete;
begin
     if nil = FGED_Requete
     then
         FGED_Requete:= TRequete.Create( dmDatabase.Connection_GED);
     Result:= FGED_Requete;
end;

{ TRequete }

constructor TRequete.Create( _Connection: Tfunction_GetConnection);
begin
     inherited Create;

     Connection:= _Connection;

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
     try
        sqlq.Database:= Connection();
        sqlq.SQL.Text:= _SQL;
        RefreshQuery( sqlq);
        sqlq.First;
        Result:= not sqlq.IsEmpty;
     finally
            sqlq.Close;
            end;
end;

function TRequete.Integer_from( _SQL: String; var _Resultat: Integer): Boolean;
begin
     try
        sqlq.Database:= Connection();
        sqlq.SQL.Text:= _SQL;
        RefreshQuery( sqlq);
        sqlq.First;
        Result:= sqlq.Fields.Count >= 1;
        if not Result
        then
            _Resultat:= 0
        else
            _Resultat:= sqlq.Fields.Fields[0].AsInteger;
     finally
            sqlq.Close;
            end;
end;

function TRequete.Integer_from( _SQL, _NomChamp: String; var _Resultat: Integer): Boolean;
var
   F: TField;
begin
     _Resultat:= 0;
     try
        sqlq.Database:= Connection();
        sqlq.SQL.Text:= _SQL;
        RefreshQuery( sqlq);
        sqlq.First;
        Result:= not SQLQ.IsEmpty;
        if  not Result then exit;

        F:= sqlq.FindField( _NomChamp);
        Result:= Assigned( F);
        if not Result then exit;

        _Resultat:= F.AsInteger;
     finally
            sqlq.Close;
            end;
end;

function TRequete.Integer_from( _SQL, _NomChamp: String; _Params: TParams;
                                var _Resultat: Integer): Boolean;
var
   F: TField;
begin
     _Resultat:= 0;
     try
        sqlq.Database:= Connection();
        sqlq.SQL.Text:= _SQL;
        sqlq.Params.AssignValues( _Params);
        RefreshQuery( sqlq);
        sqlq.First;
        Result:= not SQLQ.IsEmpty;
        if  not Result then exit;

        F:= sqlq.FindField( _NomChamp);
        Result:= Assigned( F);
        if not Result then exit;

        _Resultat:= F.AsInteger;
     finally
            sqlq.Close;
            end;
end;

function TRequete.Informix_ROWID_from_Serial( NomTable, NomSerial: String): Integer;
var
   nSerial: Integer;
   SQL: String;
begin
     nSerial:= LAST_INSERT_ID_Informix;
     SQL
     :=
       Format( 'select rowid from %s where %s = %d',
               [NomTable, NomSerial, nSerial]);
     Integer_from( SQL, Result);
end;

function TRequete.LAST_INSERT_ID_Informix: Integer;
var
   SQL: String;
begin
     SQL:=
 'select                                                                   '#13#10
+'      dbinfo(''sqlca.sqlerrd1'')                                         '#13#10
+'-- le from et le where sont là juste pour qu informix accepte la requete '#13#10
+'from                                                                     '#13#10
+'    systables                                                            '#13#10
+'where                                                                    '#13#10
+'     tabid =1                                                            '#13#10;
     Integer_from( SQL, Result);
end;

function TRequete.LAST_INSERT_ID_MySQL: Integer;
var
   SQL: String;
begin
     SQL:= 'select LAST_INSERT_ID()';
     Integer_from( SQL, Result);
end;

procedure TRequete.MySQL_codepage( _codepage: String);
begin
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

function TRequete.LAST_INSERT_ID_Postgres( _NomTable: String): Integer;
var
   SQL: String;
begin
     SQL:= 'select currval( '''+_NomTable+'_SEQ'')';
     Integer_from( SQL, Result);
end;

function TRequete.String_from( _SQL: String; var _Resultat: String): Boolean;
begin
     try
        sqlq.Database:= Connection();
        sqlq.SQL.Text:= _SQL;
        RefreshQuery( sqlq);
        sqlq.First;
        Result:= sqlq.Fields.Count >= 1;
        if not Result
        then
            _Resultat:= ''
        else
            _Resultat:= sqlq.Fields.Fields[0].AsString;
     finally
            sqlq.Close;
            end;
end;

function TRequete.String_from( _SQL, _NomChamp: String; var _Resultat: String): Boolean;
var
   F: TField;
begin
     _Resultat:= '';
     try
        sqlq.Database:= Connection();
        sqlq.SQL.Text:= _SQL;
        RefreshQuery( sqlq);
        sqlq.First;
        Result:= not sqlq.IsEmpty;
        if  not Result then exit;

        F:= sqlq.FindField( _NomChamp);
        Result:= Assigned( F);
        if not Result then exit;

        _Resultat:= F.AsString;
     finally
            sqlq.Close;
            end;
end;

function TRequete.MYSQL_storage_engine: String;
var
   F: TField;
begin
     Result:= '';
     try
        sqlq.Database:= Connection();
        sqlq.SQL.Text:= 'show variables like "storage_engine"';
        RefreshQuery( sqlq);
        sqlq.First;
        if sqlq.IsEmpty        then exit;
        if sqlq.FieldCount < 2 then exit;

        F:= sqlq.Fields.Fields[1];
        if not Assigned( F) then exit;

        Result:= F.AsString;
     finally
            sqlq.Close;
            end;
end;

function TRequete.MYSQL_storage_engine_Is_MyISAM: Boolean;
begin
     Result:= 'MyISAM' = MYSQL_storage_engine;
end;

procedure TRequete.Liste_Champ( _SQL, _NomChamp: String; _Resultat: TStrings);
var
   F: TField;
begin
     _Resultat.Clear;
     try
        sqlq.Database:= Connection();
        sqlq.SQL.Text:= _SQL;
        RefreshQuery( sqlq);
        sqlq.First;
        if sqlq.IsEmpty then exit;

        F:= sqlq.FindField( _NomChamp);
        if nil = F then exit;

        while not sqlq.Eof
        do
          begin
          _Resultat.Add( F.AsString);
          sqlq.Next;
          end;
     finally
            sqlq.Close;
            end;
end;


function TRequete.sResultat_from_Requete( _SQL: String): String;
var
   I: Integer;
   F: TField;
begin
     Result:=  _SQL+#13#10
              +'Résultat'+#13#10;
     try
        try
           sqlq.Database:= Connection();
           sqlq.SQL.Text:= _SQL;
           RefreshQuery( sqlq);
           sqlq.First;
           if sqlq.IsEmpty
           then
               Formate_Liste( Result, #13#10, 'Vide')
           else
               for I:= 0 to sqlq.FieldCount-1
               do
                 begin
                 F:= sqlq.Fields[I];
                 Formate_Liste( Result, #13#10, F.FieldName+'=>'+F.AsString+'<');
                 end;
        finally
               sqlq.Close;
               end;
     except
           on E: Exception
           do
             Formate_Liste( Result, #13#10, E.Message);
           end;
end;

function TRequete.GetSQL: String;
begin
     Result:= sqlq.SQL.Text;
end;

procedure TRequete.SetSQL(const Value: String);
begin
     sqlq.SQL.Text:= Value;
end;

function TRequete.GetParams: TParams;
begin
     Result:= sqlq.Params;
end;

procedure TRequete.SetParams(const Value: TParams);
begin
     sqlq.Params.AssignValues( Value);
end;

function TRequete.Execute: Boolean;
begin
     sqlq.Database:= Connection();
     Result:= ExecSQLQuery( sqlq);
end;

procedure TRequete.GetFieldNames( const _TableName: String; _List: TStrings);
begin
     {$IFNDEF FPC}
     Connection().GetFieldNames( _TableName, _List);
     {$ENDIF}
end;

procedure TRequete.GetTableNames( _List: TStrings);
begin
     {$IFNDEF FPC}
     Connection().GetTableNames( _List);
     {$ENDIF}
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
