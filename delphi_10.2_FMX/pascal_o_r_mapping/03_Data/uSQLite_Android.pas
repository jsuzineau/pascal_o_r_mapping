unit uSQLite_Android;
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            http://www.mars42.com                          |
                                                                                |
    Copyright 2017 Jean SUZINEAU - MARS42                                       |
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
    uBatpro_StringList,
    u_sys_,
    uDataUtilsU,
    uRegistry,
    uEXE_INI,
    ujsDataContexte,
    uSGBD,
    ufAccueil_Erreur,
  db, SQLDB, FmtBCD,dateutils,
  {$ifdef android}
    Laz_And_Controls,AndroidWidget,And_jni,
  {$endif}
  SysUtils, Classes;

{$ifdef android}
type

 { TSQLite_Android }
 TjsDataContexte_SQLite_Android= class;

 TSQLite_Android
 =
  class( TjsDataConnexion)
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
  //Attributs
  public
    procedure Prepare; override;
    procedure Ouvre_db; override;
    procedure Ferme_db; override;
    procedure Keep_Connection; override;
    procedure Do_not_Keep_Connection; override;
    procedure Fill_with_databases( _s: TStrings); override;
    procedure DoCommande( Commande: String);      override;
    function  ExecQuery( _SQL: String): Boolean;  override;
    procedure DoScript  ( NomFichierScriptSQL: String); override;
    procedure Reconnecte; override;
  //Contexte
  protected
    function Classe_Contexte: TjsDataContexte_class; override;
  public
    jsdc: TjsDataContexte_SQLite_Android;
  //Last_Insert_id
  public
    function Last_Insert_id( {%H-}_NomTable: String): Integer; override;
  end;

 { TSQLITE3_StorageType }
  //provient de unit sqlite3conn.pp TStorageType
  TSQLITE3_StorageType = (sqltst_None,sqltst_Integer,sqltst_Float,sqltst_Text,sqltst_Blob,sqltst_Null);

 { TField_SQLite_Android }

 TField_SQLite_Android
 =
  object
    sc: jSqliteCursor;
    Index: Integer;
    Typ: TSqliteFieldType;
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

 { TjsDataContexte_Champ_SQLite_Android }

 TjsDataContexte_Champ_SQLite_Android
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
    FF: TField_SQLite_Android;
    procedure SetF( _F: TField_SQLite_Android);
  public
    property F: TField_SQLite_Android read FF write SetF;
  //Accesseurs
  public
    function asString  : String   ; override;
    function asDate    : TDateTime; override;
    function asDateTime: TDateTime; override;
    function asInteger : LargeInt ; override;
    function asCurrency: Currency ; override;
    function asDouble  : double   ; override;
    function asBoolean : Boolean  ; override;
  end;

	{ TjSqliteDataAccess }

 TjSqliteDataAccess
 =
  class( jSqliteDataAccess)
   function ExecSQL_Last_insert_rowid( execQuery: String): Integer;
  end;

 { TjsDataContexte_SQLite_Android }

 TjsDataContexte_SQLite_Android
 =
  class( TjsDataContexte)
  //Gestion du cycle de vie
  public
    constructor Create( _Name: String); override;
    destructor Destroy; override;
  //ErrorLog
  private
    procedure Log_Error( _Contexte: String);
  public
    slErrorLog: TStringList;
  //Connection
  private
    SQLite_Android: TSQLite_Android;
  protected
    procedure SetConnection(_Value: TjsDataConnexion); override;
  //SQL
  private
    FParams: TParams;
  protected
    FSQL: String;
    SQL_Bind: String;
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
  //Contexte SQLite_Android
  private
    sda: jSqliteDataAccess;
    sc: jSqliteCursor;
    FEOF: Boolean;
    IsFirst: Boolean;
    slNomColonnes: TStringList;
    ParamBinding: TParamBinding;
    Step_Index: Integer;
    function NomFichierBase: String;
    procedure Assure_Ouverture;
    procedure Bind;
    function Column_Count: Integer;
    function Column_Name( _i: Integer): String;
    procedure slNomColonnes_Remplit;
    function Column_Index_from_Name( _Column_Name: String): Integer;
    function Column_Type( _i: Integer): TSqliteFieldType;
  //Champs                                             :
  public
    function Assure_Champ( _Champ_Nom: String): TjsDataContexte_Champ; override;
  //last_insert_rowid
  public
    last_insert_rowid: integer;
  //Last_Insert_id
  public
    function Last_Insert_id( _NomTable: String): Integer; override;
  end;

const
     inis_sqlite3  = 'SQLite3';

var
   uSQLite_Android_jForm: jForm            = nil;
   uSQLite_Android_sc   : jSqliteCursor    = nil;
   uSQLite_Android_sda  : jSqliteDataAccess= nil;
{$endif}

implementation

{$ifdef android}

function Crypto(S: String): String; // avec un XOR, cryptage et décryptage
var                                 // se font de la même façon
   I: Integer;
begin
     Result:= S;
     for I:= 1 to Length( Result)
     do
       Result[I]:= Chr( Ord(Result[I]) XOR $31);
end;

{ TSQLite_Android }

constructor TSQLite_Android.Create(_SGBD: TSGBD);
begin
     inherited Create( _SGBD);

     DataBase := sys_Vide;
     Initialized:= False;

     {$ifndef android}
     Assure_initialisation;
     {$endif}
     jsdc:= TjsDataContexte_SQLite_Android.Create( ClassName+'.jsdc');
     Contexte:= jsdc;
     jsdc.SetConnection( Self);
end;

destructor TSQLite_Android.Destroy;
begin
     Contexte:= nil;
     FreeAndNil( jsdc);
     inherited;
end;

procedure TSQLite_Android.Assure_initialisation;
begin
     if Initialized then exit;
     Lit( regv_Database , DataBase);
     Initialized:= True;
end;

procedure TSQLite_Android.Ecrire;
begin
     inherited Ecrire;
     Ecrit( regv_Database , DataBase );
end;

procedure TSQLite_Android.Lit( NomValeur: String; var Valeur: String; _Mot_de_passe: Boolean= False);
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

procedure TSQLite_Android.Ecrit( NomValeur: String; var Valeur: String; _Mot_de_passe: Boolean= False);
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

procedure TSQLite_Android.Prepare;
begin
     inherited Prepare;
end;

procedure TSQLite_Android.Ouvre_db;
begin
     inherited Ouvre_db;
end;

procedure TSQLite_Android.Ferme_db;
begin
     inherited Ferme_db;
end;

procedure TSQLite_Android.Keep_Connection;
begin
     inherited Keep_Connection;
end;

procedure TSQLite_Android.Do_not_Keep_Connection;
begin
     inherited Do_not_Keep_Connection;
end;

procedure TSQLite_Android.Fill_with_databases(_s: TStrings);
begin
     inherited Fill_with_databases(_s);
end;

procedure TSQLite_Android.DoCommande(Commande: String);
begin

end;

function TSQLite_Android.ExecQuery(_SQL: String): Boolean;
begin
     Result:= False;
end;

procedure TSQLite_Android.DoScript(NomFichierScriptSQL: String);
begin
     inherited DoScript(NomFichierScriptSQL);
end;

procedure TSQLite_Android.Reconnecte;
begin
     inherited Reconnecte;
end;

function TSQLite_Android.Classe_Contexte: TjsDataContexte_class;
begin
     Result:= TjsDataContexte_SQLite_Android;
end;

function TSQLite_Android.Last_Insert_id( _NomTable: String): Integer;
var
   SQL: String;
begin
     SQL:= 'select last_insert_rowid()';
     Contexte.Integer_from( SQL, Result);
     WriteLn( ClassName+'.Last_Insert_id = ', Result);
end;

{ TField_SQLite_Android }

procedure TField_SQLite_Android.Reset;
begin
     sc:= nil;
     Index:= -1;
     Typ  := ftNull;
end;

function TField_SQLite_Android.asInteger: Integer;
begin
     Result:= sc.GetValueAsInteger( Index);
end;

function TField_SQLite_Android.asFloat: double;
begin
     Result:= sc.GetValueAsDouble( Index);
end;

function TField_SQLite_Android.asString: String;
begin
     Result:= sc.GetValueAsString( Index);
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

function TField_SQLite_Android.asDateTime_interne(_jsdt: TjsDataType): TDateTime;
   procedure Traite_Float;
   begin
        Result:= asFloat;
        if Result > 1721059.5 {Julian 01/01/0000}
        then
            Result:= Result+ JulianEpoch;
   end;
   procedure Traite_String ;
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
     Result:= 0;
     case Typ
     of
       ftFloat : Traite_Float;
       ftString: Traite_String ;
       end;
end;

function TField_SQLite_Android.asDateTime: TDateTime;
begin
     Result:= asDateTime_interne( jsdt_DateTime);
end;

function TField_SQLite_Android.asDate: TDateTime;
begin
     Result:= asDateTime_interne( jsdt_Date);
end;

(*
function TField_SQLite_Android.asTime: TDateTime;
begin
    Result:= asDateTime_interne( jsdt_Time);
end;
*)

{ TjsDataContexte_Champ_SQLite_Android }

constructor TjsDataContexte_Champ_SQLite_Android.Create( _Nom: String);
begin
     F.Reset;
     inherited Create( _Nom);
end;

destructor TjsDataContexte_Champ_SQLite_Android.Destroy;
begin
     inherited Destroy;
end;

procedure TjsDataContexte_Champ_SQLite_Android.Info_Init;
begin
     inherited Info_Init;
     case F.Typ
     of
       ftInteger: Info.FieldType:= db.ftInteger;
       ftFloat  : Info.FieldType:= db.ftFloat  ;
       ftString : Info.FieldType:= db.ftString ;
       ftBlob   : Info.FieldType:= db.ftString ;
       ftNull   : Info.FieldType:= db.ftUnknown;
       else       Info.FieldType:= db.ftUnknown;
       end;
end;

procedure TjsDataContexte_Champ_SQLite_Android.SetF( _F: TField_SQLite_Android);
begin
     FF:= _F;
     Info_Init;
end;

function TjsDataContexte_Champ_SQLite_Android.asString: String;
begin
     inherited;
     Result:= F.asString;
end;

function TjsDataContexte_Champ_SQLite_Android.asDate: TDateTime;
begin
     inherited;
     Result:= F.asDate;
 end;

function TjsDataContexte_Champ_SQLite_Android.asDateTime: TDateTime;
begin
     inherited;
     Result:= F.asDateTime;
end;

function TjsDataContexte_Champ_SQLite_Android.asInteger: LargeInt;
begin
     inherited;
     Result:= F.asInteger;
end;

function TjsDataContexte_Champ_SQLite_Android.asCurrency: Currency;
begin
     inherited;
     Result:= F.asFloat;
end;

function TjsDataContexte_Champ_SQLite_Android.asDouble: double;
begin
     inherited;
     Result:= F.asFloat;
end;

function TjsDataContexte_Champ_SQLite_Android.asBoolean: Boolean;
begin
     inherited;
     Result:= Boolean( F.asInteger);
end;

{ TjSqliteDataAccess }
(* inséré ligne 742 dans C:\lamw\lazandroidmodulewizard\java\lamwdesigner\jSqliteDataAccess.java
//2017/08/24 by jsuzineau
public int ExecSQL_Last_insert_rowid(String execQuery)
 {
 int Resultat= 0;
 SQLiteDatabase mydb = getWritableDatabase();
 Cursor c;
 //Log.i("Showmessage execsql", execQuery);
 try
    {
	   mydb.beginTransaction();
	   try
       {
			    mydb.execSQL(execQuery); //Execute a single SQL statement that is NOT a SELECT or any other SQL statement that returns data.
			    //Set the transaction flag is successful, the transaction will be submitted when the end of the transaction
       c= mydb.rawQuery( "select last_insert_rowid()", null);
       if (c.moveToFirst())
         {
         Resultat= c.getInt(0);
         c.close();
         }
			    }
    catch (Exception e)
          {
			       e.printStackTrace();
			       }
    finally
           {
							    // transaction over
							    mydb.setTransactionSuccessful();
							    mydb.endTransaction();
           if (0 == Resultat)
             {
				         c= mydb.rawQuery( "select last_insert_rowid()", null);
				         if (c.moveToFirst())
				           {
				           Resultat= c.getInt(0);
               c.close();
				           }
             }
							    mydb.close();
			        }
			  }
 catch (SQLiteException e)
       {
			    Log.e(getClass().getSimpleName(), "Could not execute: " + execQuery);
	      }
 Log.i("jSqliteDataAccess", "last_insert_rowid() = "+Integer.toString( Resultat));
 return Resultat;
 }

*)

//java: public void ExecSQL(String execQuery)
function jSqliteDataAccess_ExecSQL_Last_insert_rowid(env:PJNIEnv; SqliteDataBase : jObject; execQuery: string): Integer;
var
	  cls     : jClass;
   _jMethod: jMethodID = nil;
	  _jParams: array[0..0] of jValue;
begin
     WriteLn( 'jSqliteDataAccess_ExecSQL_Last_insert_rowid, avant NewStringUTF, execQuery = '+execQuery);
			  _jParams[0].l:= env^.NewStringUTF(env, pchar(execQuery));
     WriteLn( 'jSqliteDataAccess_ExecSQL_Last_insert_rowid, avant GetObjectClass');
			  cls          := env^.GetObjectClass(env, SqliteDataBase);
     WriteLn( 'jSqliteDataAccess_ExecSQL_Last_insert_rowid, avant GetMethodID');
			  _jMethod     := env^.GetMethodID(env, cls, 'ExecSQL_Last_insert_rowid', '(Ljava/lang/String;)I');
     WriteLn( 'jSqliteDataAccess_ExecSQL_Last_insert_rowid, avant CallIntMethod');
			  Result       := env^.CallIntMethodA(env,SqliteDataBase,_jMethod, @_jParams);
     WriteLn( 'jSqliteDataAccess_ExecSQL_Last_insert_rowid, avant DeleteLocalRef(env,_jParams[0].l)');
			  env^.DeleteLocalRef(env,_jParams[0].l);
     WriteLn( 'jSqliteDataAccess_ExecSQL_Last_insert_rowid, avant DeleteLocalRef(env, cls);');
			  env^.DeleteLocalRef(env, cls);
     WriteLn( 'jSqliteDataAccess_ExecSQL_Last_insert_rowid, Fin');
end;

function TjSqliteDataAccess.ExecSQL_Last_insert_rowid( execQuery: String): Integer;
begin
     WriteLn( ClassName+'.ExecSQL_Last_insert_rowid, début, execQuery = '+execQuery);
     Result:= 0;
     if not FInitialized
     then
         begin
         WriteLn( ClassName+'.ExecSQL_Last_insert_rowid, FInitialized = False, execQuery = '+execQuery);
         exit;
         end;

     WriteLn( ClassName+'.ExecSQL_Last_insert_rowid, avant jSqliteDataAccess_ExecSQL_Last_insert_rowid');
     Result:= jSqliteDataAccess_ExecSQL_Last_insert_rowid( gApp.jni.jEnv, FjObject , execQuery);
     WriteLn( ClassName+'.ExecSQL_Last_insert_rowid, avant if Cursor <> nil then Cursor.SetCursor(Self.GetCursor);');
     if Cursor <> nil then Cursor.SetCursor(Self.GetCursor);
     WriteLn( ClassName+'.ExecSQL_Last_insert_rowid, fin');
end;

{ TjsDataContexte_SQLite_Android }

constructor TjsDataContexte_SQLite_Android.Create(_Name: String);
     procedure Cas_local;
     begin
         sc := jSqliteCursor     .Create( uSQLite_Android_jForm);
         sc.Init;
         sda:= TjSqliteDataAccess.Create( uSQLite_Android_jForm);
         sda.Init;
         sda.Cursor:= sc;
         sda.DataBaseName:= '';
     end;
     procedure Cas_global;
     begin
          sda:= uSQLite_Android_sda;
          sc := uSQLite_Android_sc ;
     end;
begin
     inherited Create( _Name);

     slErrorLog:= TStringList.Create;

     FConnection:= nil;
     Cas_local;
     //Cas_global;

     FEOF:= False;

     FParams:= TParams.Create;
     slNomColonnes:= TStringList.Create;
end;

destructor TjsDataContexte_SQLite_Android.Destroy;
begin
     FreeAndNil( slNomColonnes);
     FreeAndNil( FParams);
     FreeAndNil( slErrorLog);
     //sda.Close;
     //sda.Cursor:= nil;
     //FreeAndNil( sda);
     //FreeAndNil( sc);
     inherited Destroy;
end;

procedure TjsDataContexte_SQLite_Android.Log_Error(_Contexte: String);
begin
     slErrorLog.Add( _Contexte);
end;

procedure TjsDataContexte_SQLite_Android.SetConnection( _Value: TjsDataConnexion);
begin
     FConnection:= _Value;
     Affecte( SQLite_Android, TSQLite_Android, FConnection);
end;

function TjsDataContexte_SQLite_Android.NomFichierBase: String;
begin
     Result:= '';
     if nil = SQLite_Android
     then
         begin
         Writeln( ClassName+'.NomFichierBase, SQLite_Android = nil');
         exit;
         end;
     Result:= SQLite_Android.DataBase;
     Writeln( ClassName+'.NomFichierBase, NomFichierBase =',Result);
end;

procedure TjsDataContexte_SQLite_Android.Assure_Ouverture;
begin
     if '' <> sda.DataBaseName then exit;

     sda.DataBaseName:= NomFichierBase;
     sda.OpenOrCreate( NomFichierBase);
end;

procedure TjsDataContexte_SQLite_Android.SetSQL(_SQL: String);
begin
     try
	       Params.Clear;
	       FSQL:= Params.ParseSQL( _SQL, True, False, False, psInterbase, ParamBinding);
				 except
           on E: Exception
           do
             begin
             WriteLn( 'Exception : '#13#10
                      +E.Message+#13#10
                      +DumpCallStack);
             end;
				       end;
end;

function TjsDataContexte_SQLite_Android.GetSQL: String;
begin
     Result:= FSQL;
end;

function TjsDataContexte_SQLite_Android.Params: TParams;
begin
     Result:= FParams;
end;

procedure TjsDataContexte_SQLite_Android.Bind;
var
   iParamBinding: Integer;
   iParam: Integer;
   P: TParam;
   sValue: String;
begin
     SQL_Bind:= FSQL;
     for iParamBinding:= Low(ParamBinding) to High(ParamBinding)
     do
       begin
       iParam:= ParamBinding[iParamBinding];
       P:= Params.Items[ iParam];
       sValue:= P.AsString;
       WriteLn( ClassName+'.Bind: P.Name:',P.Name,': ',P.DataType,'= ', sValue);
       case P.DataType
       of
         db.ftDateTime: sValue:= DateTimeSQL( P.AsDateTime);
         db.ftString  : sValue:= QuotedStr  ( P.AsString  );
         else           sValue:= P.AsString;
         end;

       SQL_Bind:= StringReplace( SQL_Bind, '?', sValue, []);
       end;
end;

function TjsDataContexte_SQLite_Android.IsEmpty: Boolean;
begin
     Result:= 0 = sc.GetRowCount;
end;

procedure TjsDataContexte_SQLite_Android.First;
begin
     if IsFirst then exit;

     WriteLn(ClassName+'.First:: avant MoveToFirst');
     sc.MoveToFirst;
     Step_Index:= 0;
     IsFirst:= True;
     WriteLn(ClassName+'.First:: Fin');
end;

function TjsDataContexte_SQLite_Android.EoF: Boolean;
begin
     Result:= FEOF;
end;

procedure TjsDataContexte_SQLite_Android.Next;
begin
    IsFirst:= False;
    Inc( Step_Index);
    WriteLn(ClassName+'.Next:: avant MoveToPosition, Step_Index=',Step_Index,', sc.GetRowCount= ',sc.GetRowCount);
    sc.MoveToPosition( Step_Index);
    FEOF:= not( Step_Index < sc.GetRowCount);
    WriteLn(ClassName+'.Next:: Fin');
end;

procedure TjsDataContexte_SQLite_Android.Close;
begin
     FEOF:= False;
end;

function TjsDataContexte_SQLite_Android.Column_Count: Integer;
begin
     Result:= sc.GetColumnCount;
end;

function TjsDataContexte_SQLite_Android.Column_Name(_i: Integer): String;
begin
     Result:= sc.GetColumName( _i);
end;

procedure TjsDataContexte_SQLite_Android.slNomColonnes_Remplit;
var
   I: Integer;
   NomColonne: String;
begin
     slNomColonnes.Clear;
     WriteLn( ClassName+'.slNomColonnes_Remplit, Column_Count= ',Column_Count);
     for I:= 0 to Column_Count-1
     do
       begin
       NomColonne:= Column_Name( I);
       WriteLn( ClassName+'.slNomColonnes_Remplit, NomColonne= '+NomColonne);
       slNomColonnes.Add(NomColonne);
       Assure_Champ( NomColonne);
       end;
end;

function TjsDataContexte_SQLite_Android.Column_Index_from_Name( _Column_Name: String): Integer;
begin
     Result:= slNomColonnes.IndexOf( _Column_Name);
end;

function TjsDataContexte_SQLite_Android.Column_Type(_i: Integer): TSqliteFieldType;
begin
     Result:= sc.GetColType( _i);
end;

function TjsDataContexte_SQLite_Android.RefreshQuery: Boolean;
begin
     WriteLn( ClassName+'.RefreshQuery, SQL= '+SQL);
     Assure_Ouverture;

     Bind;
     Result:= sda.Select( SQL_Bind, False);
     if Result
     then
         begin
         slNomColonnes_Remplit;
         Step_Index:= 0;
         IsFirst:= True;
         FEOF:= sc.GetRowCount = 0;
         end
     else
         Log_Error( ClassName+'.RefreshQuery: échec');;
end;

function TjsDataContexte_SQLite_Android.ExecSQLQuery: Boolean;
   procedure Cas_Insert_old;
   var
      S: String;
   begin
       WriteLn( ClassName+'.ExecSQLQuery, Cas_Insert');
       sda.InsertIntoTable( SQL_Bind);
       s:= sda.Select( 'select last_insert_rowid()');
       WriteLn( ClassName+'.ExecSQLQuery, Cas_Insert: last_insert_rowid()=',s);
   end;
   procedure Cas_Insert;
   begin
       WriteLn( ClassName+'.ExecSQLQuery, Cas_Insert');
       last_insert_rowid:= TjSqliteDataAccess(sda).ExecSQL_Last_insert_rowid( SQL_Bind);
       WriteLn( ClassName+'.ExecSQLQuery, Cas_Insert: last_insert_rowid()=',last_insert_rowid);
   end;
   procedure CasGeneral;
   begin
        WriteLn( ClassName+'.ExecSQLQuery, CasGeneral;');
        sda.ExecSQL( SQL_Bind);
  end;
begin
     WriteLn( ClassName+'.ExecSQLQuery, SQL= '+SQL);
     Bind;
     WriteLn( ClassName+'.ExecSQLQuery, SQL_Bind= '+SQL_Bind);
     Assure_Ouverture;
     if 1 = Pos( 'INSERT', UpperCase( SQL_Bind))
     then
         Cas_Insert//_old
     else
         CasGeneral;
     Result:= True;
end;

function TjsDataContexte_SQLite_Android.Assure_Champ( _Champ_Nom: String): TjsDataContexte_Champ;
var
   jsdcc: TjsDataContexte_Champ_SQLite_Android;
   F: TField_SQLite_Android;
   procedure Cree_Champ;
   begin
        WriteLn( ClassName+'.Assure_Champ::Cree_Champ: _Champ_Nom= '+_Champ_Nom);
        Result:= TjsDataContexte_Champ_SQLite_Android.Create( _Champ_Nom);
        if nil = Result
        then
            raise Exception.Create( ClassName+'.Assure_Champ: '
                                    +'Echec de TjsDataContexte_Champ_libsqlite3.Create');
        Champs.AddObject( _Champ_Nom, Result);
   end;
begin
     WriteLn( ClassName+'.Assure_Champ, _Champ_Nom= '+_Champ_Nom);
     Result:= Find_Champ( _Champ_Nom);
     if nil = Result
     then
         Cree_Champ;

     if Affecte_( jsdcc, TjsDataContexte_Champ_SQLite_Android, Result) then exit;

     F.sc:= sc;
     F.Index:= Column_Index_from_Name( _Champ_Nom);
     F.Typ  := Column_Type( F.Index);
     jsdcc.F:= F;
     WriteLn( ClassName+'.Assure_Champ, initialisé ',
              ', _Champ_Nom= ',_Champ_Nom,
              ', F.Index= ',F.Index,
              ', F.Typ= ',F.Typ
              );
end;

function TjsDataContexte_SQLite_Android.Last_Insert_id( _NomTable: String): Integer;
begin
     Result:= last_insert_rowid;
end;
{$endif}

end.
