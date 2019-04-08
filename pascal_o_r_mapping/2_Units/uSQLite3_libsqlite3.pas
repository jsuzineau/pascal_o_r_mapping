unit uSQLite3_libsqlite3;
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            http://www.mars42.com                                               |
                                                                                |
    Copyright 2018 Jean SUZINEAU - MARS42                                       |
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
    along with this program.  If not, see <http://www.gnu.org/licenses/>. 1     |
                                                                                |
|                                                                               }
interface

uses
    uClean,
    uLog,
    uBatpro_StringList,
    u_sys_,
    uuStrings,
    uRegistry,
    uEXE_INI,
    ujsDataContexte,
    uSGBD,
    ufAccueil_Erreur,
  db, sqlite3conn_pour_test, SQLDB, sqlite3, FmtBCD,dateutils,
  SysUtils, Classes;

type

 { TSQLite3_libsqlite3 }
 TjsDataContexte_libsqlite3= class;

 TSQLite3_libsqlite3
 =
  class( TjsDataConnexion_SQLQuery)
  //Gestion du cycle de vie
  public
    constructor Create( _SGBD: TSGBD); override;
    destructor Destroy; override;
  //Persistance dans la base de registre
  private
    Initialized: Boolean;
    procedure Lit  (NomValeur: String; var Valeur: String; _Mot_de_passe: Boolean= False);
    procedure Ecrit(NomValeur: String; var Valeur: String; _Mot_de_passe: Boolean= False);
  public
    procedure Assure_initialisation;
    procedure Ecrire; override;
  //Connexion
  protected
    function Cree_SQLConnection: TSQLConnection; override;
  public
    sqlcSQLite3: TSQLite3Connection;
  //DataBase
  public
    DataBase: String;
  //Méthodes
  public
    procedure Prepare; override;
    procedure Ouvre_db; override;
    procedure Ferme_db; override;
    procedure Keep_Connection; override;
    procedure Do_not_Keep_Connection; override;

    procedure DoCommande( Commande: String);          override;
    function ExecQuery( _SQL: String): Boolean;          override;
 //Récupération du nom des bases
 public
   procedure Fill_with_databases( _s: TStrings); override;
 //Contexte
  protected
    function Classe_Contexte: TjsDataContexte_class; override;
  public
    jsdc: TjsDataContexte_libsqlite3;
  //Last_Insert_id
  public
    function Last_Insert_id( _NomTable: String): Integer; override;
  end;

 { TSQLITE3_StorageType }
  //provient de unit sqlite3conn.pp TStorageType
  TSQLITE3_StorageType = (sqltst_None,sqltst_Integer,sqltst_Float,sqltst_Text,sqltst_Blob,sqltst_Null);

 { TField_libsqlite3 }

 TField_libsqlite3
 =
  object
    pStmt: psqlite3_stmt;
    Index: Integer;
    Typ: TSQLITE3_StorageType;
    procedure Reset;
    function asInteger: Integer;
    function asFloat: double;
    function asString: String;
    function asDateTime: TDateTime;
    function asDate    : TDateTime;
    //function asTime    : TDateTime; (jsdt_Time non codé pour l'instant)
  private
    function asDateTime_interne( _jsdt: TjsDataType): TDateTime;
  end;

 { TjsDataContexte_Champ_libsqlite3 }

 TjsDataContexte_Champ_libsqlite3
 =
  class( TjsDataContexte_Champ)
  //Gestion du cycle de vie
  public
    constructor Create( _Nom: String);
    destructor Destroy; override;
  //Info
  protected
    procedure Info_Init; override;
  //Contexte libsqlite3
  private
    FF: TField_libsqlite3;
    procedure SetF( _F: TField_libsqlite3);
  public
    property F: TField_libsqlite3 read FF write SetF;
  //Accesseurs
  public
    function asString  : String   ; override;
    function asDate    : TDateTime; override;
    function asDateTime: TDateTime; override;
    function asInteger : Integer  ; override;
    function asCurrency: Currency ; override;
    function asDouble  : double   ; override;
    function asBoolean : Boolean  ; override;
  end;

 { TjsDataContexte_libsqlite3 }

 TjsDataContexte_libsqlite3
 =
  class( TjsDataContexte)
  //Gestion du cycle de vie
  public
    constructor Create( _Name: String); override;
    destructor Destroy; override;
  //ErrorLog
  private
    procedure Log_Error( _Contexte: String; _Error_Code: Integer);
    procedure Check_Error( _Contexte: String; _Error_Code: Integer);
  public
    slErrorLog: TStringList;
  //Connection
  private
    jsdc: TjsDataConnexion_SQLQuery;
  protected
    procedure SetConnection( _Value: TjsDataConnexion); override;
  //SQL
  private
    FParams: TParams;
  protected
    FSQL: String;
    procedure SetSQL( _SQL: String); override;
    function  GetSQL: String; override;
  public
    function Params: TParams;       override;
    function RefreshQuery: Boolean; override;
    function ExecSQLQuery: Boolean; override;
    function IsEmpty: Boolean;      override;
    procedure First;                override;
    function EoF: Boolean;          override;
    procedure Next;                 override;
    procedure Close;                override;
  //Contexte libsqlite3
  private
    pDb: psqlite3;
    pStmt: psqlite3_stmt;
    sqlite3_step_Result: Integer;
    FEOF: Boolean;
    IsFirst: Boolean;
    slNomColonnes: TStringList;
    ParamBinding: TParamBinding;
    procedure SetNomFichierBase( _NomFichierBase: String);
    function GetNomFichierBase: String;
    function Ouvre_Base: Boolean;
    function Ferme_Base: Boolean;
    function Prepare: Boolean;
    function Bind: Boolean;
    function Step( _IsFirst: Boolean= False; _rows_expected: Boolean= True): Boolean;
    function Prepare_and_Bind_and_Step( _rows_expected: Boolean= True): Boolean;
    function Reset: Boolean;
    function Column_Count: Integer;
    function Column_Name( _i: Integer): String;
    procedure slNomColonnes_Remplit;
    function Column_Index_from_Name( _Column_Name: String): Integer;
    function Column_Type( _i: Integer): TSQLITE3_StorageType;
    function Data_Count: Integer;
  public
    property NomFichierBase: String read GetNomFichierBase write SetNomFichierBase;
  //Champs
  public
    function Assure_Champ( _Champ_Nom: String): TjsDataContexte_Champ; override;
    procedure Charge_Champs; override;
  //Last_Insert_id
  public
    function last_insert_rowid: Integer;
    function Last_Insert_id( _NomTable: String): Integer; override;
  //Champ id
  protected
    procedure Setid_FielName( _id_FielName: String);override;
  public
    function id: Integer; override;
    procedure Create_id_field; override;
  end;

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

{ TSQLite3_libsqlite3 }

constructor TSQLite3_libsqlite3.Create(_SGBD: TSGBD);
begin
     inherited Create( _SGBD);
     Affecte( jsdc, TjsDataContexte_libsqlite3, Contexte);

     HostName:= 'local filesystem';
     DataBase := sys_Vide;
     Initialized:= False;

     {$ifndef android}
     Assure_initialisation;
     {$endif}

end;

destructor TSQLite3_libsqlite3.Destroy;
begin
     Contexte:= nil;
     FreeAndNil( jsdc);
     sqlcSQLite3:= nil;
     inherited;
end;

procedure TSQLite3_libsqlite3.Assure_initialisation;
begin
     if Initialized then exit;
     Lit( regv_Database , DataBase);
     sqlc.DatabaseName:= DataBase;
     jsdc.SetConnection( Self);
     Initialized:= True;
end;

procedure TSQLite3_libsqlite3.Ecrire;
begin
     inherited Ecrire;
     Ecrit( regv_Database , DataBase );
end;

procedure TSQLite3_libsqlite3.Lit( NomValeur: String; var Valeur: String; _Mot_de_passe: Boolean= False);
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

procedure TSQLite3_libsqlite3.Ecrit( NomValeur: String; var Valeur: String; _Mot_de_passe: Boolean= False);
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

function TSQLite3_libsqlite3.Cree_SQLConnection: TSQLConnection;
begin
     sqlcSQLite3:= TSQLite3Connection.Create( nil);
     Result:= sqlcSQLite3;
     if Assigned( Result)
     then
         Result.CharSet:= 'latin1';
         //Result.CharSet:= 'utf8';
         //Result.CharSet:= 'cp850';
end;

procedure TSQLite3_libsqlite3.Prepare;
var
   Default_Database: String;
begin
     Default_Database:= GetCurrentDir+DirectorySeparator+'SQLite3_database.db';

     Database_indefinie:= (DataBase = sys_Vide) or (DataBase='---');
     if Database_indefinie
     then
         DataBase:= Default_Database
     else
         Database_indefinie:= DataBase = Default_Database;

     Ouvrable
     :=
            (Database  <> sys_Vide)
        and FileExists(Database);

     sqlcSQLite3.DatabaseName:= Database;
     jsdc.NomFichierBase:= DataBase;
end;

procedure TSQLite3_libsqlite3.Ouvre_db;
begin
end;

procedure TSQLite3_libsqlite3.Ferme_db;
begin
end;

procedure TSQLite3_libsqlite3.Keep_Connection;
begin

end;

procedure TSQLite3_libsqlite3.Do_not_Keep_Connection;
begin

end;

procedure TSQLite3_libsqlite3.DoCommande(Commande: String);
    procedure Succes;
    begin
         Commande:= ChaineDe(80,'#')+ sys_N+ Commande + sys_N+ '---> Succés';
         fAccueil_Log( Commande);
    end;
    procedure Echec( _S: String);
    begin
         Commande:= ChaineDe(80,'#')+sys_N + Commande + sys_N+ '---> Echec:'+sys_N+_S;
         fAccueil_Erreur( Commande);
    end;
begin
     if EmptyCommande( Commande) then exit;
     try
        if ExecQuery( Commande)
        then
            Succes
        else
            Echec( 'Echec de ExecSQLQuery');
     except
           on E: EDatabaseError
           do
             Echec( E.Message);
           end;
end;

function TSQLite3_libsqlite3.ExecQuery( _SQL: String): Boolean;
begin                   //==> peut-être à déplacer dans TjsDataContexte
     Contexte.SQL:= _SQL;
     Result:= Contexte.ExecSQLQuery;
end;

procedure TSQLite3_libsqlite3.Fill_with_databases(_s: TStrings);
begin
     _s.Text:= Database;
end;

function TSQLite3_libsqlite3.Classe_Contexte: TjsDataContexte_class;
begin
     //Result:= inherited Classe_Contexte;
     Result:= TjsDataContexte_libsqlite3;
end;

function TSQLite3_libsqlite3.Last_Insert_id( _NomTable: String): Integer;
begin
     Result:= jsdc.last_insert_rowid;
end;

{ TField_libsqlite3 }

procedure TField_libsqlite3.Reset;
begin
     pStmt:= nil;
     Index:= -1;
     Typ  := sqltst_Null;
end;

function TField_libsqlite3.asInteger: Integer;
begin
     Result:= sqlite3_column_int( pStmt, Index);
end;

function TField_libsqlite3.asFloat: double;
begin
     Result:= sqlite3_column_double( pStmt, Index);
end;

function TField_libsqlite3.asString: String;
   procedure asText;
   var
      lpstr: PChar;
   begin
       lpstr:= sqlite3_column_text( pStmt, Index);
       Result:= StrPas( lpstr);
   end;
   procedure asBlob;
   var
      Taille: Integer;
      pBlob: PChar;
      procedure GetBlob;
      begin
           SetLength( Result, Taille);
           Move( pBlob^, Result[1], Taille);
      end;
   begin
        pBlob := sqlite3_column_blob ( pStmt, Index);
        Taille:= sqlite3_column_bytes( pStmt, Index);
        if 0 = Taille
        then
            Result:= ''
        else
            GetBlob;
   end;
begin
     asBlob;
end;

//provient de unit sqlite3conn.pp
{$IF NOT DECLARED(JulianEpoch)} // sysutils/datih.inc
const
  JulianEpoch = TDateTime(-2415018.5); // "julian day 0" is January 1, 4713 BC 12:00AM
{$ENDIF}

Function NextWord(Var S : ShortString; Sep : Char) : String;

Var
  P : Integer;

begin
  P:=Pos(Sep,S);
  If (P=0) then
    P:=Length(S)+1;
  Result:=Copy(S,1,P-1);
  Delete(S,1,P);
end;

//provient de unit sqlite3conn.pp
// Parses string-formatted date into TDateTime value
// Expected format: '2013-12-31 ' (without ')
Function ParseSQLiteDate(S : ShortString) : TDateTime;

Var
  Year, Month, Day : Integer;

begin
  Result:=0;
  If TryStrToInt(NextWord(S,'-'),Year) then
    if TryStrToInt(NextWord(S,'-'),Month) then
      if TryStrToInt(NextWord(S,' '),Day) then
        Result:=EncodeDate(Year,Month,Day);
end;

//provient de unit sqlite3conn.pp
// Parses string-formatted time into TDateTime value
// Expected formats
// 23:59
// 23:59:59
// 23:59:59.999
Function ParseSQLiteTime(S : ShortString; Interval: boolean) : TDateTime;

Var
  Hour, Min, Sec, MSec : Integer;

begin
  Result:=0;
  If TryStrToInt(NextWord(S,':'),Hour) then
    if TryStrToInt(NextWord(S,':'),Min) then
    begin
      if TryStrToInt(NextWord(S,'.'),Sec) then
        // 23:59:59 or 23:59:59.999
        MSec:=StrToIntDef(S,0)
      else // 23:59
      begin
        Sec:=0;
        MSec:=0;
      end;
      if Interval then
        Result:=EncodeTimeInterval(Hour,Min,Sec,MSec)
      else
        Result:=EncodeTime(Hour,Min,Sec,MSec);
    end;
end;

//provient de unit sqlite3conn.pp
// Parses string-formatted date/time into TDateTime value
Function ParseSQLiteDateTime(S : String) : TDateTime;

var
  P : Integer;
  DS,TS : ShortString;

begin
  DS:='';
  TS:='';
  P:=Pos('T',S); //allow e.g. YYYY-MM-DDTHH:MM
  if P=0 then
    P:=Pos(' ',S); //allow e.g. YYYY-MM-DD HH:MM
  If (P<>0) then
    begin
    DS:=Copy(S,1,P-1);
    TS:=S;
    Delete(TS,1,P);
    end
  else
    begin
    If (Pos('-',S)<>0) then
      DS:=S
    else if (Pos(':',S)<>0) then
      TS:=S;
    end;
  Result:=ComposeDateTime(ParseSQLiteDate(DS),ParseSQLiteTime(TS,False));
end;

function TField_libsqlite3.asDateTime_interne(_jsdt: TjsDataType): TDateTime;
   procedure Traite_Float;
   begin
        Result:= asFloat;
        if Result > 1721059.5 {Julian 01/01/0000}
        then
            Result:= Result+ JulianEpoch;
   end;
   procedure Traite_Text ;
   var
      S: String;
   begin
        S:= asString;
        case _jsdt
        of
          jsdt_DateTime: Result:= ParseSqliteDateTime( S);
          jsdt_Date    : Result:= ParseSqliteDate    ( S);
          //jsdt_Time  : Result:= ParseSqliteTime    ( S, True);
          end;
   end;
begin
    case Typ
    of
      sqltst_Float: Traite_Float;
      sqltst_Text : Traite_Text ;
      end;
end;

function TField_libsqlite3.asDateTime: TDateTime;
begin
     Result:= asDateTime_interne( jsdt_DateTime);
end;

function TField_libsqlite3.asDate: TDateTime;
begin
     Result:= asDateTime_interne( jsdt_Date);
end;

(*
function TField_libsqlite3.asTime: TDateTime;
begin
    Result:= asDateTime_interne( jsdt_Time);
end;
*)

{ TjsDataContexte_Champ_libsqlite3 }

constructor TjsDataContexte_Champ_libsqlite3.Create( _Nom: String);
begin
     F.Reset;
     inherited Create( _Nom);
end;

destructor TjsDataContexte_Champ_libsqlite3.Destroy;
begin
     inherited Destroy;
end;

procedure TjsDataContexte_Champ_libsqlite3.Info_Init;
begin
     inherited Info_Init;
     case F.Typ
     of
       sqltst_Integer: Info.FieldType:= ftInteger;
       sqltst_Float  : Info.FieldType:= ftFloat;
       sqltst_Text   : Info.FieldType:= ftString;
       sqltst_Blob   : Info.FieldType:= ftString;
       sqltst_Null   : Info.FieldType:= ftUnknown;
       else            Info.FieldType:= ftUnknown;
       end;
end;

procedure TjsDataContexte_Champ_libsqlite3.SetF( _F: TField_libsqlite3);
begin
     FF:= _F;
     Info_Init;
end;

function TjsDataContexte_Champ_libsqlite3.asString: String;
begin
     inherited;
     Result:= F.asString;
end;

function TjsDataContexte_Champ_libsqlite3.asDate: TDateTime;
begin
     inherited;
     Result:= F.asDate;
 end;

function TjsDataContexte_Champ_libsqlite3.asDateTime: TDateTime;
begin
     inherited;
     Result:= F.asDateTime;
end;

function TjsDataContexte_Champ_libsqlite3.asInteger: Integer;
begin
     inherited;
     Result:= F.asInteger;
end;

function TjsDataContexte_Champ_libsqlite3.asCurrency: Currency;
begin
     inherited;
     Result:= F.asFloat;
end;

function TjsDataContexte_Champ_libsqlite3.asDouble: double;
begin
     inherited;
     Result:= F.asFloat;
end;

function TjsDataContexte_Champ_libsqlite3.asBoolean: Boolean;
begin
     inherited;
     Result:= Boolean( F.asInteger);
end;

{ TjsDataContexte_libsqlite3 }

constructor TjsDataContexte_libsqlite3.Create(_Name: String);
begin
     slErrorLog:= TStringList.Create;

     jsdc:= nil;

     pDb:= nil;
     pStmt:= nil;
     FEOF:= False;

     FParams:= TParams.Create(nil);
     slNomColonnes:= TStringList.Create;

     inherited Create( _Name);
     //InitializeSQLite;
end;

destructor TjsDataContexte_libsqlite3.Destroy;
begin
     Ferme_Base;
     inherited Destroy;
     FreeAndNil( slNomColonnes);
     FreeAndNil( FParams);
     FreeAndNil( slErrorLog);
 end;

procedure TjsDataContexte_libsqlite3.Log_Error( _Contexte: String; _Error_Code: Integer);
var
   Error_Message: String;
begin
     Error_Message:= StrPas( sqlite3_errstr( _Error_Code));
     slErrorLog.Add( _Contexte+Error_Message);
end;

procedure TjsDataContexte_libsqlite3.Check_Error( _Contexte: String; _Error_Code: Integer);
begin
     if  SQLITE_OK = _Error_Code then exit;
     Log_Error( _Contexte, _Error_Code);
end;

procedure TjsDataContexte_libsqlite3.SetConnection( _Value: TjsDataConnexion);
begin
     Ferme_Base;
     if Affecte_( jsdc, TjsDataConnexion_SQLQuery, _Value)
     then
         raise Exception.Create( ClassName+'.SetConnection: Wrong type');
     Ouvre_Base;
end;

procedure TjsDataContexte_libsqlite3.SetSQL(_SQL: String);
begin
     Params.Clear;
     FSQL:= Params.ParseSQL( _SQL, True, False, False, psInterbase, ParamBinding);
end;

function TjsDataContexte_libsqlite3.GetSQL: String;
begin
     Result:= FSQL;
end;

procedure TjsDataContexte_libsqlite3.SetNomFichierBase( _NomFichierBase: String);
begin
     if jsdc.sqlc.DatabaseName = _NomFichierBase then exit;

     Ferme_Base;
     jsdc.sqlc.DatabaseName:= _NomFichierBase;
     Ouvre_Base;
end;

function TjsDataContexte_libsqlite3.GetNomFichierBase: String;
begin
    Result:= jsdc.sqlc.DatabaseName;
end;

function TjsDataContexte_libsqlite3.Ouvre_Base: Boolean;
var
   Resultat: Integer;
begin
     Resultat:= sqlite3_open_v2( PChar(NomFichierBase), @pDb, SQLITE_OPEN_READWRITE or SQLITE_OPEN_CREATE, nil);
     Result:= SQLITE_OK = Resultat;
     if  Result then exit;

     Log_Error( ClassName+'.Ouvre_Base: échec de sqlite3_open:', Resultat);
end;

function TjsDataContexte_libsqlite3.Ferme_Base: Boolean;
var
   Resultat: Integer;
begin
     if nil = pDb then exit;

     Resultat:= sqlite3_close( pDb);
     pDb:= nil;

     Result:= SQLITE_OK = Resultat;
     if  Result then exit;

     Log_Error( ClassName+'.Ferme_Base: échec de sqlite3_close:', Resultat);
end;

function TjsDataContexte_libsqlite3.Params: TParams;
begin
     Result:= FParams;
end;

function TjsDataContexte_libsqlite3.Prepare: Boolean;
var
   Resultat: Integer;
begin
     Close;

     Resultat:= sqlite3_prepare_v2( pDb, PChar(SQL), -1, @pStmt, nil);
     Result:= SQLITE_OK = Resultat;
     if Result then exit;

     Log_Error( ClassName+'.Prepare: échec de sqlite3_prepare_v2:', Resultat);
end;

//provient de unit sqlite3conn.pp
procedure freebindstring(astring: pointer); cdecl;
begin
     StrDispose(AString);
end;

function TjsDataContexte_libsqlite3.Bind: Boolean;
var
   iParamBinding: Integer;
   iParam: Integer;
   iBind: Integer;
   P: TParam;
   str1: string;
   wstr1: widestring;
   //provient de unit sqlite3conn.pp
   function PCharStr( const S: String): PChar;
   begin
        Result:=StrAlloc(Length(S)+1);
        if Assigned( Result)
        then
            StrPCopy( Result, S);
   end;
   procedure CheckError( _Error_Code: Integer);
   begin
        Check_Error( ClassName+'.Bind: échec :', _Error_Code);
        Result:= SQLITE_OK = _Error_Code;
   end;
begin
     Result:= True;
     for iParamBinding:= Low(ParamBinding) to High(ParamBinding)
     do
       begin
       iBind := iParamBinding+1;
       iParam:= ParamBinding[iParamBinding];
       P:= Params.Items[ iParam];
       //adapté depuis unit sqlite3conn.pp, TSQLite3Cursor.bindparams
       case P.DataType
       of
         ftInteger,
         ftAutoInc,
         ftSmallint: CheckError(sqlite3_bind_int   (pStmt, iBind, P.AsInteger      ));
         ftWord:     CheckError(sqlite3_bind_int   (pStmt, iBind, P.AsWord         ));
         ftBoolean:  CheckError(sqlite3_bind_int   (pStmt, iBind, Ord( P.AsBoolean)));
         ftLargeint: CheckError(sqlite3_bind_int64 (pStmt, iBind, P.AsLargeint     ));
         ftBcd,
         ftFloat,
         ftCurrency: CheckError(sqlite3_bind_double(pStmt, iBind, P.AsFloat        ));
         ftDateTime,
         ftDate,
         ftTime:     CheckError(sqlite3_bind_double(pStmt, iBind, P.AsFloat - JulianEpoch));
         ftFMTBcd:
                     begin
                     str1:=BCDToStr(P.AsFMTBCD);
                     CheckError(sqlite3_bind_text  (pStmt, iBind, PChar(str1), length(str1), sqlite3_destructor_type(SQLITE_TRANSIENT)));
                     end;
         ftString,
         ftFixedChar,
         ftMemo:
                     begin // According to SQLite documentation, CLOB's (ftMemo) have the Text affinity
                     str1:= p.asstring;
                     CheckError(sqlite3_bind_text  (pStmt,iBind,PCharStr(str1), length(str1),@freebindstring));
                     end;
         ftBytes,
         ftVarBytes,
         ftBlob:
                     begin
                     str1:= P.asstring;
                     CheckError(sqlite3_bind_blob  (pStmt,iBind,PCharStr(str1), length(str1),@freebindstring));
                     end;
         ftWideString,
         ftFixedWideChar,
         ftWideMemo :
                     begin
                     wstr1:=P.AsWideString;
                     CheckError(sqlite3_bind_text16(pStmt,iBind, PWideChar(wstr1), length(wstr1)*sizeof(WideChar), sqlite3_destructor_type(SQLITE_TRANSIENT)));
                     end;
         else
                     begin
                     Result:= False;
                     Log_Error( ClassName+'.Bind: échec : P.DataType non géré', -1);
                     end;
         end;
       if not Result then break;
       end;
end;

function TjsDataContexte_libsqlite3.Step( _IsFirst: Boolean= False; _rows_expected: Boolean= True): Boolean;
     procedure Traite_EOF;
     begin
          FEOF:= True;
          Result:= not _rows_expected;
     end;
     procedure Traite_ROW;
     begin
          Result:= True;

          IsFirst:= _IsFirst;
          if not IsFirst then exit;

          slNomColonnes_Remplit;
     end;
     procedure TraiteErreur;
     begin
          Log_Error( ClassName+'.Step: échec de sqlite3_step:', sqlite3_step_Result);
     end;
begin
     Result:= False;
     sqlite3_step_Result:= sqlite3_step( pStmt);

     case sqlite3_step_Result
     of
       SQLITE_DONE: Traite_EOF;
       SQLITE_ROW : Traite_ROW;
       else         TraiteErreur;
       end;
end;

function TjsDataContexte_libsqlite3.Prepare_and_Bind_and_Step( _rows_expected: Boolean= True): Boolean;
begin
     Result:= Prepare;
     if not Result then exit;

     Result:= Bind;
     if not Result then exit;

     Result:= Step( True, _rows_expected);
     if not Result then exit;
end;

function TjsDataContexte_libsqlite3.Reset: Boolean;
var
   Resultat: Integer;
begin
     Resultat:= sqlite3_reset( pStmt);
     Result:= SQLITE_OK = Resultat;
     IsFirst:= Result or IsFirst;
     if  Result
     then
         Log_Error( ClassName+'.Reset: échec de sqlite3_reset:', Resultat);
end;

function TjsDataContexte_libsqlite3.Column_Count: Integer;
begin
     Result:= sqlite3_column_count( pStmt);
end;

function TjsDataContexte_libsqlite3.Column_Name(_i: Integer): String;
var
   lpstr: PChar;
begin
     lpstr:= sqlite3_column_name( pStmt, _i);
     if nil = lpstr
     then
         Result:= ''
     else
         Result:= StrPas( lpstr);
end;

procedure TjsDataContexte_libsqlite3.slNomColonnes_Remplit;
var
   I: Integer;
begin
     slNomColonnes.Clear;
     for I:= 0 to Column_Count-1
     do
       slNomColonnes.Add(Column_Name( I));
end;

function TjsDataContexte_libsqlite3.Column_Index_from_Name( _Column_Name: String): Integer;
begin
     Result:= slNomColonnes.IndexOf( _Column_Name);
end;

function TjsDataContexte_libsqlite3.Column_Type( _i: Integer): TSQLITE3_StorageType;
begin
     Result:= TSQLITE3_StorageType( sqlite3_column_type( pStmt, _i));
end;

function TjsDataContexte_libsqlite3.Data_Count: Integer;
begin
     Result:= sqlite3_data_count( pStmt);
end;

function TjsDataContexte_libsqlite3.RefreshQuery: Boolean;
begin
     Champs_Vide;
     Result:= Prepare_and_Bind_and_Step;
end;

function TjsDataContexte_libsqlite3.ExecSQLQuery: Boolean;
begin
     Champs_Vide;
     Result:= Prepare_and_Bind_and_Step( False);
end;

function TjsDataContexte_libsqlite3.IsEmpty: Boolean;
begin
     Result:= 0 = Data_Count;
end;

procedure TjsDataContexte_libsqlite3.First;
begin
     if IsFirst then exit;

     Reset;
end;

function TjsDataContexte_libsqlite3.EoF: Boolean;
begin
     Result:= FEOF;
end;

procedure TjsDataContexte_libsqlite3.Next;
begin
     Step;
end;

procedure TjsDataContexte_libsqlite3.Close;
var
   Resultat: Integer;
begin
     FEOF:= False;

     Resultat:= sqlite3_finalize( pStmt);
     pStmt:= nil;
     if  SQLITE_OK = Resultat then exit;
     Log_Error( ClassName+'.Close: échec de sqlite3_finalize:', Resultat);
end;

function TjsDataContexte_libsqlite3.Assure_Champ( _Champ_Nom: String): TjsDataContexte_Champ;
var
   jsdcc: TjsDataContexte_Champ_libsqlite3;
   F: TField_libsqlite3;
   procedure Cree_Champ;
   begin
        Result:= TjsDataContexte_Champ_libsqlite3.Create( _Champ_Nom);
        if nil = Result
        then
            raise Exception.Create( ClassName+'.Assure_Champ: '
                                    +'Echec de TjsDataContexte_Champ_libsqlite3.Create');
        Champs.AddObject( _Champ_Nom, Result);
   end;
begin
     Result:= Find_Champ( _Champ_Nom);
     if nil = Result
     then
         Cree_Champ;

     if Affecte_( jsdcc, TjsDataContexte_Champ_libsqlite3, Result) then exit;

     F.pStmt:= pStmt;
     F.Index:= Column_Index_from_Name( _Champ_Nom);
     F.Typ  := Column_Type( F.Index);
     jsdcc.F:= F;
end;

procedure TjsDataContexte_libsqlite3.Charge_Champs;
var
   I: Integer;
begin
     inherited Charge_Champs;
     for I:= 0 to slNomColonnes.Count-1
     do
       Assure_Champ( slNomColonnes[I]);
end;

function TjsDataContexte_libsqlite3.last_insert_rowid: Integer;
begin
     Result:= sqlite3_last_insert_rowid( pDb);
end;

function TjsDataContexte_libsqlite3.Last_Insert_id(_NomTable: String): Integer;
begin
     Result:= last_insert_rowid;
end;

procedure TjsDataContexte_libsqlite3.Setid_FielName(_id_FielName: String);
begin
     inherited Setid_FielName(_id_FielName);
end;

function TjsDataContexte_libsqlite3.id: Integer;
var
   jsdccID: TjsDataContexte_Champ;
begin
    jsdccID:= Assure_Champ( id_FielName);
    if nil = jsdccID
    then
        Result:=inherited id
    else
        Result:= jsdccID.asInteger;
end;

procedure TjsDataContexte_libsqlite3.Create_id_field;
begin
     inherited Create_id_field;
end;

end.
