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
    uRegistry,
    uEXE_INI,
    ujsDataContexte,
    uSGBD,
    ufAccueil_Erreur,
  db, SQLDB, FmtBCD,dateutils,Laz_And_Controls,
  SysUtils, Classes;

type

 { TSQLite_Android }

 TSQLite_Android
 =
  class( TjsDataConnexion)
  //Gestion du cycle de vie
  public
    constructor Create; override;
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
    function asInteger : Integer  ; override;
    function asCurrency: Currency ; override;
    function asDouble  : double   ; override;
    function asBoolean : Boolean  ; override;
  end;

 { TjsDataContexte_SQLite_Android }

 TjsDataContexte_SQLite_Android
 =
  class( TjsDataContexte)
  //Gestion du cycle de vie
  public
    constructor Create( _Name: String);
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
    FNomFichierBase: String;
    sda: jSqliteDataAccess;
    sc: jSqliteCursor;
    FEOF: Boolean;
    IsFirst: Boolean;
    slNomColonnes: TStringList;
    ParamBinding: TParamBinding;
    Step_Index: Integer;
    procedure SetNomFichierBase( _NomFichierBase: String);
    function Ouvre_Base: Boolean;
    function Ferme_Base: Boolean;
    function Prepare: Boolean;
    function Bind: Boolean;
    function Step( _IsFirst: Boolean= False): Boolean;
    function Prepare_and_Bind_and_Step: Boolean;
    function Reset: Boolean;
    function Column_Count: Integer;
    function Column_Name( _i: Integer): String;
    procedure slNomColonnes_Remplit;
    function Column_Index_from_Name( _Column_Name: String): Integer;
    function Column_Type( _i: Integer): TSqliteFieldType;
    function Data_Count: Integer;
  public
    property NomFichierBase: String read FNomFichierBase write SetNomFichierBase;
  //Champs
  public
    function Assure_Champ( _Champ_Nom: String): TjsDataContexte_Champ; override;
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

{ TSQLite_Android }

constructor TSQLite_Android.Create;
begin
     inherited;
     DataBase := sys_Vide;
     Initialized:= False;

     {$ifndef android}
     Assure_initialisation;
     {$endif}
end;

destructor TSQLite_Android.Destroy;
begin
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
		   inherited DoCommande(Commande);
end;

function TSQLite_Android.ExecQuery(_SQL: String): Boolean;
begin
		   Result:=inherited ExecQuery(_SQL);
end;

procedure TSQLite_Android.DoScript(NomFichierScriptSQL: String);
begin
		   inherited DoScript(NomFichierScriptSQL);
end;

procedure TSQLite_Android.Reconnecte;
begin
		   inherited Reconnecte;
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

function TjsDataContexte_Champ_SQLite_Android.asInteger: Integer;
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

{ TjsDataContexte_SQLite_Android }

constructor TjsDataContexte_SQLite_Android.Create(_Name: String);
begin
     inherited Create( _Name);

     slErrorLog:= TStringList.Create;

     FConnection:= nil;
     sc := jSqliteCursor    .Create(nil);
     sda:= jSqliteDataAccess.Create(nil);
     sda.Cursor:= sc;

     FNomFichierBase:= '';
     FEOF:= False;

     FParams:= TParams.Create(nil);
     slNomColonnes:= TStringList.Create;
end;

destructor TjsDataContexte_SQLite_Android.Destroy;
begin
     FreeAndNil( slNomColonnes);
     FreeAndNil( FParams);
     Ferme_Base;
     FreeAndNil( slErrorLog);
     sda.Cursor:= nil;
     FreeAndNil( sda);
     FreeAndNil( sc);
     inherited Destroy;
end;

procedure TjsDataContexte_SQLite_Android.Log_Error(_Contexte: String);
begin
     slErrorLog.Add( _Contexte);
end;

procedure TjsDataContexte_SQLite_Android.SetConnection( _Value: TjsDataConnexion);
begin
     FConnection:= _Value;
     if Affecte( SQLite_Android, TSQLite_Android, FConnection)
     then
         NomFichierBase:= SQLite_Android.DataBase
     else
         NomFichierBase:= '';
end;

procedure TjsDataContexte_SQLite_Android.SetSQL(_SQL: String);
begin
     Params.Clear;
     FSQL:= Params.ParseSQL( _SQL, True, False, False, psInterbase, ParamBinding);
end;

function TjsDataContexte_SQLite_Android.GetSQL: String;
begin
     Result:= FSQL;
end;

procedure TjsDataContexte_SQLite_Android.SetNomFichierBase( _NomFichierBase: String);
begin
     if FNomFichierBase = _NomFichierBase then exit;

     Ferme_Base;
     FNomFichierBase:= _NomFichierBase;
     Ouvre_Base;
end;

function TjsDataContexte_SQLite_Android.Ouvre_Base: Boolean;
begin
     sda.DataBaseName:= NomFichierBase;
     sda.OpenOrCreate( NomFichierBase);
     Result:= True;
end;

function TjsDataContexte_SQLite_Android.Ferme_Base: Boolean;
begin
    sda.Close;
    Result:= True;
end;

function TjsDataContexte_SQLite_Android.Params: TParams;
begin
     Result:= FParams;
end;

function TjsDataContexte_SQLite_Android.Prepare: Boolean;
var
   Resultat: Integer;
begin
     Close;

     Result:= True;
end;

//provient de unit sqlite3conn.pp
procedure freebindstring(astring: pointer); cdecl;
begin
     StrDispose(AString);
end;

function TjsDataContexte_SQLite_Android.Bind: Boolean;
var
   iParamBinding: Integer;
   iParam: Integer;
   iBind: Integer;
   P: TParam;
begin
     SQL_Bind:= FSQL;
     Result:= True;
     for iParamBinding:= Low(ParamBinding) to High(ParamBinding)
     do
       begin
       iBind := iParamBinding+1;
       iParam:= ParamBinding[iParamBinding];
       P:= Params.Items[ iParam];
       SQL_Bind:= StringReplace( SQL_Bind, '?', P.AsString, []);
       end;
end;

function TjsDataContexte_SQLite_Android.Step( _IsFirst: Boolean= False): Boolean;
     procedure TraiteErreur;
     begin
          Log_Error( ClassName+'.Step: échec de sqlite3_step:');
     end;
begin
     Result:= True;
     IsFirst:= _IsFirst;
     if _IsFirst
     then
         begin
         Result:= sda.Select( SQL_Bind, False);
         if not Result then begin TraiteErreur; exit; end;
         slNomColonnes_Remplit;
         Step_Index:= 0;
         end
     else
         begin
         Inc( Step_Index);
         sc.MoveToPosition( Step_Index);
         end;

     FEOF:= Step_Index < sc.GetRowCount;
end;

function TjsDataContexte_SQLite_Android.Prepare_and_Bind_and_Step: Boolean;
begin
     Result:= Prepare;
     if not Result then exit;

     Result:= Bind;
     if not Result then exit;

     Result:= Step( True);
     if not Result then exit;
end;

function TjsDataContexte_SQLite_Android.Reset: Boolean;
begin
     sc.MoveToFirst;
     Step_Index:= 0;
     IsFirst:= True;
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
begin
     slNomColonnes.Clear;
     for I:= 0 to Column_Count-1
     do
       slNomColonnes.Add(Column_Name( I));
end;

function TjsDataContexte_SQLite_Android.Column_Index_from_Name( _Column_Name: String): Integer;
begin
     Result:= slNomColonnes.IndexOf( _Column_Name);
end;

function TjsDataContexte_SQLite_Android.Column_Type(_i: Integer): TSqliteFieldType;
begin
     Result:= sc.GetColType( _i);
end;

function TjsDataContexte_SQLite_Android.Data_Count: Integer;
begin
     Result:= sc.GetRowCount;
end;

function TjsDataContexte_SQLite_Android.RefreshQuery: Boolean;
begin
     Result:= Prepare_and_Bind_and_Step;
end;

function TjsDataContexte_SQLite_Android.ExecSQLQuery: Boolean;
begin
     Result:= Prepare_and_Bind_and_Step;
end;

function TjsDataContexte_SQLite_Android.IsEmpty: Boolean;
begin
     Result:= 0 = Data_Count;
end;

procedure TjsDataContexte_SQLite_Android.First;
begin
     if IsFirst then exit;

     Reset;
end;

function TjsDataContexte_SQLite_Android.EoF: Boolean;
begin
     Result:= FEOF;
end;

procedure TjsDataContexte_SQLite_Android.Next;
begin
     Step;
end;

procedure TjsDataContexte_SQLite_Android.Close;
begin
     FEOF:= False;

     //sc. ?
end;

function TjsDataContexte_SQLite_Android.Assure_Champ( _Champ_Nom: String): TjsDataContexte_Champ;
var
   jsdcc: TjsDataContexte_Champ_SQLite_Android;
   F: TField_SQLite_Android;
   procedure Cree_Champ;
   begin
        Result:= TjsDataContexte_Champ_SQLite_Android.Create( _Champ_Nom);
        if nil = Result
        then
            raise Exception.Create( ClassName+'.Assure_Champ: '
                                    +'Echec de TjsDataContexte_Champ_libsqlite3.Create');
   end;
begin
     Result:= Find_Champ( _Champ_Nom);
     if nil = Result
     then
         Cree_Champ;

     if Affecte_( jsdcc, TjsDataContexte_Champ_SQLite_Android, Result) then exit;

     F.sc:= sc;
     F.Index:= Column_Index_from_Name( _Champ_Nom);
     F.Typ  := Column_Type( F.Index);
     jsdcc.F:= F;
end;

end.
