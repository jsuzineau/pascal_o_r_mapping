unit ujsDataContexte;

interface

uses
    uClean,
    u_sys_,
    uChrono,
    ufAccueil_Erreur,
    uVide,
    uuStrings,
    uBatpro_StringList,
    uDataUtilsU,
    uDataUtilsF,
    uSGBD,
    uLog,
 Classes, SysUtils, db, SqlExpr, strutils, DateUtils, Data.DBXCommon, Data.DBCommonTypes, System.Types;

type

		{ TjsDataConnexion }
  TjsDataContexte=class;
  TjsDataContexte_class= class of TjsDataContexte;
  TjsDataConnexion
  =
   class
   //Gestion du cycle de vie
   public
     constructor Create( _SGBD: TSGBD); virtual;
     destructor Destroy; override;
   //SGBD
   private
    FSGBD: TSGBD;
    FsSGBD: String;
   public
     property SGBD: TSGBD   read FSGBD;
     property sSGBD: String read FsSGBD;
   //HostName
   protected
     FHostName : String;
     procedure SetHostName(const Value: String); virtual;
   public
     property HostName: String read FHostName write SetHostName;
   //User_Name
   public
     User_Name: String;
   //Password
   public
     Password : String;
   //Database
   public
     DataBase : String;
   //Initialisation des paramètres
   protected
     procedure InitParams;virtual;
   //Attributs
   public
     Database_indefinie: Boolean;
     Ouvrable: Boolean;
     Ouvert: Boolean;
     procedure Prepare; virtual;
     procedure Ouvre_db; virtual;
     procedure Ferme_db; virtual;
     procedure Keep_Connection; virtual;
     procedure Do_not_Keep_Connection; virtual;
     procedure Ecrire; virtual;
     function EmptyCommande( Commande: String): Boolean;
     procedure DoCommande( Commande: String);            virtual; abstract;
     function ExecQuery( _SQL: String): Boolean;         virtual; abstract;

     procedure DoScript  ( NomFichierScriptSQL: String); virtual;
     procedure DoLOAD_INTO_MarchesSystem( NomFichier, NomTable: String;
                                          NbLignesEntete: Integer = 0);virtual;
     procedure DoLOAD_INTO_INFORMIX     ( NomFichier, NomTable: String;
                                          LinuxWindows_: Boolean); virtual;
     function MySQLPath(NomFichier: String): String; virtual;
     procedure Reconnecte; virtual;
     function Base_sur: String; virtual;
   //Récupération du nom des bases
   public
     procedure Fill_with_databases( _s: TStrings); virtual;
     //    procedure Fill_with_databases( _cb: TComboBox); overload;
   //Gestion du log
   public
     procedure Start_SQLLog; virtual;
     procedure  Stop_SQLLog; virtual;
   //Récupération du nom du serveur et de la base
   public
     function sSGBD_Database: String;
   //Contexte
   protected
     function Classe_Contexte: TjsDataContexte_class; virtual; abstract;
   public
     Contexte: TjsDataContexte;
     function Cree_Contexte( _Name: String): TjsDataContexte;
   //Liste des noms des champs d'une table
   public
     procedure GetFieldNames(const _TableName: String; _List: TStrings); virtual; abstract;
   //Liste des tables
   public
     procedure GetTableNames( _List:TStrings); virtual; abstract;
   //Liste des schemas
   public
     procedure GetSchemaNames( _List:TStrings); virtual; abstract;
   //Last_Insert_id
   public
     function Last_Insert_id( _NomTable: String): Integer; virtual; abstract;
   //méthodes pour schémateur
   public
     function Table_Cherche( _Table               : String): Boolean; virtual; abstract;
     function Index_Cherche( _Table, _Index       : String): Boolean; virtual; abstract;
     function Champ_Cherche( _Table, _Champ       : String): Boolean; virtual; abstract;
     function Champ_Type_Cherche( _Table, _Champ, _Type: String): Boolean; virtual; abstract;
     function Champ_Type_Defaut_Cherche( _Table, _Champ, _Type, _Defaut: String): Boolean; virtual; abstract;
   end;
  TjsDataConnexion_Class= class of TjsDataConnexion;

  PtrBoolean= ^Boolean;
  TjsDataType // when modified update jsDataType_from_FieldType
  =
   ( jsdt_String, jsdt_Date, jsdt_DateTime, jsdt_Integer, jsdt_Currency, jsdt_Double, jsdt_Boolean, jsdt_ShortString, jsdt_Unknown);

  { TjsDataContexte_Champ_Info }

  TjsDataContexte_Champ_Info
  =
   record
     Visible   : Boolean;
     Libelle   : String;
     Longueur  : Integer;
   //Type
   public
     FieldType: TFieldType;
     procedure FieldType_Default( _FieldType: TFieldType);
   //jsDataType
   public
     jsDataType: TjsDataType;
   end;

  { TjsDataContexte_Champ }

  TjsDataContexte_Champ
  =
   class
   //Gestion du cycle de vie
   public
     constructor Create( _Nom: String);
     destructor Destroy; override;
   //Nom
   public
     Nom: String;
   //Info
   protected
     procedure Info_Init; virtual;
   public
     Info: TjsDataContexte_Champ_Info;
   //Accesseurs
   public
     function asString  : String   ; virtual;
     function asDate    : TDateTime; virtual;
     function asDateTime: TDateTime; virtual;
     function asInteger : LargeInt ; virtual;
     function asCurrency: Currency ; virtual;
     function asDouble  : double   ; virtual;
     function asBoolean : Boolean  ; virtual;
     procedure Charge( _jsDataType: TjsDataType; _Valeur: Pointer);
   end;

  { TjsDataContexte_Champ_Dataset }

  TjsDataContexte_Champ_Dataset
  =
   class( TjsDataContexte_Champ)
   //Gestion du cycle de vie
   public
     constructor Create( _Nom: String; _F: TField);
     destructor Destroy; override;
   //Info
   protected
     procedure Info_Init; override;
   //Contexte Dataset
   public
     F: TField;
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

  TIterateur_jsDataContexte_Champ
  =
   class( TIterateur)
   //Iterateur
   public
     procedure Suivant( out _Resultat: TjsDataContexte_Champ);
     function  not_Suivant( out _Resultat: TjsDataContexte_Champ): Boolean;
   end;

  TsljsDataContexte_Champ
  =
   class( TBatpro_StringList)
   //Gestion du cycle de vie
   public
     constructor Create( _Nom: String= ''); override;
     destructor Destroy; override;
   //Création d'itérateur
   protected
     class function Classe_Iterateur: TIterateur_Class; override;
   public
     function Iterateur: TIterateur_jsDataContexte_Champ;
     function Iterateur_Decroissant: TIterateur_jsDataContexte_Champ;
   end;

  { TjsDataContexte }

  TjsDataContexte
  =
   class
   //Gestion du cycle de vie
   public
     constructor Create( _Name: String); virtual;
     destructor Destroy; override;
   //Name
   public
     Name: String;
   //Connection
   protected
     FConnection: TjsDataConnexion;
     function GetConnection: TjsDataConnexion; virtual;
     procedure SetConnection(_Value: TjsDataConnexion); virtual;
   public
     property Connection: TjsDataConnexion read GetConnection;
   //SQL
   protected
     procedure SetSQL( _SQL: String); virtual;
     function  GetSQL: String; virtual;
   public
     property SQL: String read GetSQL write SetSQL;
     function Params: TParams;       virtual;
     function RefreshQuery: Boolean; virtual;
     function ExecSQLQuery: Boolean; virtual;
     function IsEmpty: Boolean;      virtual;
     procedure First;                virtual;
     function EoF: Boolean;          virtual;
     procedure Next;                 virtual;
     procedure Close;                virtual;
   //Champs
   public
     Champs: TsljsDataContexte_Champ;
     function Champ_by_Index( _Index    : Integer): TjsDataContexte_Champ;
     function     Find_Champ( _Champ_Nom: String ): TjsDataContexte_Champ;
     function   Assure_Champ( _Champ_Nom: String ): TjsDataContexte_Champ; virtual;abstract;
     procedure Charge_Champs; virtual;
     procedure Champs_Vide;
   //Accesseurs
   public
     function   String_from_( _Champ_Nom: String; var Memory: String   ): TjsDataContexte_Champ;
     function DateTime_from_( _Champ_Nom: String; var Memory: TDateTime): TjsDataContexte_Champ;
     function  Integer_from_( _Champ_Nom: String; var Memory: Integer  ): TjsDataContexte_Champ;
     function Currency_from_( _Champ_Nom: String; var Memory: Currency ): TjsDataContexte_Champ;
     function   Double_from_( _Champ_Nom: String; var Memory: Double   ): TjsDataContexte_Champ;
     function  Boolean_from_( _Champ_Nom: String; var Memory: Boolean  ): TjsDataContexte_Champ;
     procedure Charge( _Champ_Nom: String; _jsDataType: TjsDataType; _Valeur: Pointer);
   //Champ id
   protected
     Fid_FielName: String;
     procedure Setid_FielName( _id_FielName: String);virtual;
   public
     property id_FielName: String read Fid_FielName write Setid_FielName;
     function id: Integer; virtual;
     procedure Create_id_field; virtual;
   //spécial Gestion bases Microsoft Access en Freepascal
   protected
     procedure SetUsePrimaryKeyAsKey( _Value: Boolean); virtual;
   public
     property UsePrimaryKeyAsKey: Boolean write SetUsePrimaryKeyAsKey;
   //Utilitaires
   public
     function Est_Vide( _SQL: String): Boolean;
   //Request Result not empty (pour Schémateur, proche de Est_Vide, permet Params )
   public
     function Execute_and_Result_not_empty_dont_close: Boolean;
     function Execute_and_Result_not_empty: Boolean;
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
   //Test de valeurs chaines
   public
     function Matches( _Champs_Noms, _Champs_Valeurs: TStringDynArray): Boolean;//sur le premier enregistrement
     function Locate ( _Champs_Noms, _Champs_Valeurs: TStringDynArray): Boolean;//sur un des enregistrements
   //Listage d'un champ vers une liste
   protected
     procedure Liste_Champ_initialize; virtual;
   public
     procedure Liste_Champ( _SQL, _NomChamp: String; _Resultat: TStrings);
   //Requete SQL pour message erreur
   public
     function sResultat_from_Requete( _SQL: String): String;
   //Liste des noms des champs d'une table
   public
     procedure GetFieldNames(const _TableName: String; _List: TStrings);
   //Liste des tables
   public
     procedure GetTableNames( _List:TStrings); virtual;
   //Liste des bases de données
   public
     procedure Fill_with_databases( _s: TStrings); virtual;
   //Liste des schemas
   public
     procedure GetSchemaNames( _List:TStrings);
   //Last_Insert_id
   public
     function Last_Insert_id( _NomTable: String): Integer; virtual; abstract;
   end;


  { TjsDataContexte_Dataset }

  TjsDataContexte_Dataset
  =
   class( TjsDataContexte)
   //Gestion du cycle de vie
   public
     constructor Create( _Name: String);override;
     destructor Destroy; override;
   //SQL
   public
     procedure First;        override;
     function EoF: Boolean;  override;
     procedure Next;         override;
   //Champs
   public
     procedure Charge_Champs; override;
   //Contexte Dataset
   protected
     ds: TDataset;
     function ds_FindField( _FieldName: String): TField;
   //Champs
   public
     function Assure_Champ( _Champ_Nom: String): TjsDataContexte_Champ; override;
   end;

		{ TjsDataConnexion_SQLQuery }
  TjsDataContexte_SQLQuery= class;

  TjsDataConnexion_SQLQuery
  =
   class( TjsDataConnexion)
   //Gestion du cycle de vie
   public
     constructor Create( _SGBD: TSGBD); override;
     destructor Destroy; override;
   //Connexion
   protected
     function Cree_SQLConnection: TSQLConnection; virtual;
   public
     sqlc: TSQLConnection;
   //Méthodes
   public
     procedure Prepare; override;
     procedure Ouvre_db; override;
     procedure Ferme_db; override;
     procedure Keep_Connection; override;
     procedure Do_not_Keep_Connection; override;

     procedure Fill_with_databases( _s: TStrings); override;
     procedure Connecte_SQLQuery( _SQLQuery: TSQLQuery);

     procedure WriteParam(Key, Value: String);

     procedure    DoCommande( Commande: String);          override;
     function ExecQuery( _SQL: String): Boolean;          override;

     procedure DoScript  ( NomFichierScriptSQL: String); override;
     procedure DoLOAD_INTO_MarchesSystem( NomFichier, NomTable: String;
                                          NbLignesEntete: Integer = 0); override;
     procedure DoLOAD_INTO_INFORMIX     ( NomFichier, NomTable: String;
                                          LinuxWindows_: Boolean);      override;
     procedure Reconnecte; override;
     procedure CopieConnection( source, cible: TSQLConnection);
     procedure Init_Connection( _sqlc: TSQLConnection; _Database: String);
   //Gestion du log
   private
     function TraceEvent( _TraceInfo: TDBXTraceInfo): CBRType;
   public
     procedure Start_SQLLog; override;
     procedure  Stop_SQLLog; override;
   //Contexte
   protected
     function Classe_Contexte: TjsDataContexte_class; override;
   public
     jsdc: TjsDataContexte_SQLQuery;
   //Liste des noms des champs d'une table
   public
     procedure GetFieldNames(const _TableName: String; _List: TStrings); override;
   //Liste des tables
   public
     procedure GetTableNames( _List:TStrings); override;
   //Liste des schemas
   public
     procedure GetSchemaNames( _List:TStrings); override;
   end;

  { TjsDataContexte_SQLQuery }

  TjsDataContexte_SQLQuery
  =
   class( TjsDataContexte_Dataset)
   //Gestion du cycle de vie
   public
     constructor Create( _Name: String); override;
     destructor Destroy; override;
   //Connection
   private
     jsDataConnexion_SQLQuery: TjsDataConnexion_SQLQuery;
   protected
     procedure SetConnection(_Value: TjsDataConnexion); override;
   //Listage d'un champ vers une liste
   protected
     procedure Liste_Champ_initialize; override;
   //SQL
   protected
     procedure SetSQL( _SQL: String); override;
     function  GetSQL: String; override;
   public
     function Params: TParams;       override;
     function RefreshQuery: Boolean; override;
     function ExecSQLQuery: Boolean; override;
     function IsEmpty: Boolean;      override;
     procedure Close;                override;
   //Contexte SQLQuery
   protected
     sqlq: TSQLQuery;
   //Champ id
   private
     sqlqid: TIntegerField;
     fID: TField;
   protected
     procedure Setid_FielName( _id_FielName: String);override;
   public
     function id: Integer; override;
     procedure Create_id_field; override;
   //spécial Gestion bases Microsoft Access en Freepascal
   protected
     procedure SetUsePrimaryKeyAsKey( _Value: Boolean); override;
   //Last_Insert_id
   public
     function Last_Insert_id( _NomTable: String): Integer; override;
   end;

  { TjsDataContexte_Dataset_Null }

  TjsDataContexte_Dataset_Null
  =
   class( TjsDataContexte)
   //Gestion du cycle de vie
   public
     constructor Create( _Name: String);
     destructor Destroy; override;
   //Champs
   public
     function Assure_Champ( _Champ_Nom: String): TjsDataContexte_Champ; override;
   end;

  { TjsDataContexte_SQLite3 }

  (*TjsDataContexte_SQLite3
  =
   class( TjsDataContexte)
   //Gestion du cycle de vie
   public
     constructor Create;
     destructor Destroy; override;
   //Requete
   //Contexte Dataset
   private
     ds: TDataset;
     function ds_FindField( _FieldName: String): TField;
   //Champs
   public
     function Assure_Champ( _Champ_Nom: String): TjsDataContexte_Champ; override;
   end;
    *)
function jsDataContexte_Dataset_Null: TjsDataContexte_Dataset_Null;

function jsDataType_from_FieldType( _ft: TFieldType):TjsDataType;

implementation

(*
TFieldType = (ftUnknown, ftString, ftSmallint, ftInteger, ftWord,
  ftBoolean, ftFloat, ftCurrency, ftBCD, ftDate,  ftTime, ftDateTime,
  ftBytes, ftVarBytes, ftAutoInc, ftBlob, ftMemo, ftGraphic, ftFmtMemo,
  ftParadoxOle, ftDBaseOle, ftTypedBinary, ftCursor, ftFixedChar,
  ftWideString, ftLargeint, ftADT, ftArray, ftReference,
  ftDataSet, ftOraBlob, ftOraClob, ftVariant, ftInterface,
  ftIDispatch, ftGuid, ftTimeStamp, ftFMTBcd, ftFixedWideChar, ftWideMemo);
  TjsDataType
  =
   ( jsdt_String, jsdt_Date, jsdt_DateTime, jsdt_Integer, jsdt_Currency, jsdt_Double, jsdt_Boolean, jsdt_ShortString, jsdt_Unknown);
*)
function jsDataType_from_FieldType( _ft: TFieldType):TjsDataType;
begin
     case _ft
     of
       ftFixedChar: Result:= jsdt_ShortString;
       ftString   : Result:= jsdt_String;
       ftInteger  : Result:= jsdt_Integer;
       ftSmallInt : Result:= jsdt_Integer;
       ftDateTime : Result:= jsdt_DateTime;
       ftDate     : Result:= jsdt_Date;
       ftBCD      : Result:= jsdt_Currency;
       ftFloat    : Result:= jsdt_Double;
       ftCurrency : Result:= jsdt_Currency;
       ftBoolean  : Result:= jsdt_Boolean;
       (*
       ftUnknown,
       ftWord,
       ftTime,
       ftBytes,
       ftVarBytes,
       ftAutoInc,
       ftBlob,
       ftMemo,
       ftGraphic,
       ftFmtMemo,
       ftParadoxOle,
       ftDBaseOle,
       ftTypedBinary,
       ftCursor,
       ftWideString,
       ftLargeint,
       ftADT,
       ftArray,
       ftReference,
       ftDataSet,
       ftOraBlob,
       ftOraClob,
       ftVariant,
       ftInterface,
       ftIDispatch,
       ftGuid,
       ftTimeStamp,
       ftFMTBcd,
       ftFixedWideChar,
       ftWideMemo
       *)
       else Result:= jsdt_Unknown;
       end;
end;

{ TjsDataConnexion_SQLQuery }

constructor TjsDataConnexion_SQLQuery.Create( _SGBD: TSGBD);
begin
     inherited Create( _SGBD);
     sqlc:= Cree_SQLConnection;

     Contexte:= Cree_Contexte( ClassName+'.Contexte');
     Affecte( jsdc, TjsDataContexte_SQLQuery, Contexte);
end;

destructor TjsDataConnexion_SQLQuery.Destroy;
begin
     Contexte:= nil;
     FreeAndNil( jsdc);
     FreeAndnil( sqlc);
     inherited Destroy;
end;

function TjsDataConnexion_SQLQuery.Cree_SQLConnection: TSQLConnection;
begin
     Result:= nil;
     raise Exception.Create( ClassName+'.Cree_SQLConnection: appel d''une méthode abstraite');
end;

procedure TjsDataConnexion_SQLQuery.Prepare;
begin

end;

procedure TjsDataConnexion_SQLQuery.Ouvre_db;
begin
     inherited Ouvre_db;

     if nil = sqlc then exit;

     //Log.PrintLn( ClassName+'.Ouvre_db: Avant ouverture connection');
     Ouvert:= Ouvre_SQLConnection( sqlc);
     //Log.PrintLn( ClassName+'.Ouvre_db: Aprés ouverture connection');
     Log.PrintLn( Base_sur+' sqlc.ConnectionName='+sqlc.ConnectionName+' sqlc.DriverName='+sqlc.DriverName);
end;

procedure TjsDataConnexion_SQLQuery.Ferme_db;
begin
     inherited Ferme_db;
     if Assigned( sqlc) then sqlc.Close;
end;

procedure TjsDataConnexion_SQLQuery.Keep_Connection;
begin
     inherited Keep_Connection;
     sqlc.KeepConnection:= True;
     Ouvre_SQLConnection( sqlc);
end;

procedure TjsDataConnexion_SQLQuery.Do_not_Keep_Connection;
begin
     inherited Do_not_Keep_Connection;
     sqlc.KeepConnection:= False;
     sqlc.Connected     := False;
end;

procedure TjsDataConnexion_SQLQuery.Fill_with_databases(_s: TStrings);
begin
     inherited Fill_with_databases(_s);
     if _s = nil then exit;

     if not sqlc.Connected
     then
         Ouvre_SQLConnection( sqlc);

     sqlc.GetSchemaNames( _s);
end;

procedure TjsDataConnexion_SQLQuery.Connecte_SQLQuery(_SQLQuery: TSQLQuery);
begin
     _SQLQuery.SQLConnection:= sqlc;
end;

procedure TjsDataConnexion_SQLQuery.WriteParam(Key, Value: String);
begin
     sqlc.Params.Values[Key]:= Value;
end;

procedure TjsDataConnexion_SQLQuery.DoCommande(Commande: String);
begin
     if EmptyCommande( Commande) then exit;
     try
        sqlc.ExecuteDirect( Commande);
        Commande:= ChaineDe(80,'#')+ sys_N+ Commande + sys_N+ '---> Succés';
        fAccueil_Log( Commande);
     except
           on E: EDatabaseError
           do
             begin
             Commande:= ChaineDe(80,'#')+sys_N + Commande + sys_N+ '---> Echec:'+sys_N+
                        E.Message;
             fAccueil_Erreur( Commande);
             end;
           end;
end;

function TjsDataConnexion_SQLQuery.ExecQuery(_SQL: String): Boolean;
begin
     Result:= uDataUtilsF.ExecQuery( sqlc, _SQL);
end;

procedure TjsDataConnexion_SQLQuery.DoScript(NomFichierScriptSQL: String);
var
   sl: TBatpro_StringList;
   S: String;
   Commande: String;
begin
   		inherited DoScript(NomFichierScriptSQL);
     fAccueil_Log(   ChaineDe(80,'*')   +sys_N
                   + NomFichierScriptSQL+sys_N
                   + ChaineDe(80,'*')   +sys_N);
     sl:= TBatpro_StringList.Create;
     try
        sl.LoadFromFile( NomFichierScriptSQL);

        S:= sl.Text;
     finally
            Free_nil( sl);
            end;

     while S <> sys_Vide
     do
       begin
       Commande:= StrTok( ';', S);
       DoCommande( Commande);
       end;
end;

procedure TjsDataConnexion_SQLQuery.DoLOAD_INTO_MarchesSystem( NomFichier,
		                                                             NomTable: String;
                                                               NbLignesEntete: Integer);
begin
   		inherited DoLOAD_INTO_MarchesSystem(NomFichier, NomTable, NbLignesEntete);
     DoCommande( Format(  'LOAD DATA                             '+ sys_N
                         +'     INFILE ''%s''                      '+ sys_N
                         +'     REPLACE                          '+ sys_N
                         +'     INTO TABLE %s                    '+ sys_N
                         +'     FIELDS                           '+ sys_N
                         +'           TERMINATED BY ''\t''         '+ sys_N
                         +'           OPTIONALLY ENCLOSED BY ''|'' '+ sys_N
                         +'     LINES                            '+ sys_N
                         +'          TERMINATED BY ''\r\n''        '+ sys_N
                         +'     IGNORE %d LINES                  '+ sys_N,
                         [ MySQLPath( NomFichier), NomTable, NbLignesEntete]));
end;

procedure TjsDataConnexion_SQLQuery.DoLOAD_INTO_INFORMIX( NomFichier,
		                                                        NomTable: String;
                                                          LinuxWindows_: Boolean);
var
   FinLigne: String;
begin
   		inherited DoLOAD_INTO_INFORMIX(NomFichier, NomTable, LinuxWindows_);
     if LinuxWindows_
     then
         FinLigne:=   '\n'
     else
         FinLigne:= '\r\n';
     DoCommande( Format(  'LOAD DATA                             '+ sys_N
                         +'     INFILE ''%s''                      '+ sys_N
                         +'     REPLACE                          '+ sys_N
                         +'     INTO TABLE %s                    '+ sys_N
                         +'     FIELDS                           '+ sys_N
                         +'           TERMINATED BY ''|''          '+ sys_N
                         +'     LINES                            '+ sys_N
                         +'          TERMINATED BY ''%s''          '+ sys_N,
                         [ MySQLPath( NomFichier), NomTable, FinLigne]));
end;

procedure TjsDataConnexion_SQLQuery.Start_SQLLog;
begin
		   inherited Start_SQLLog;
     //sqlc.LogEvents:=LogAllEvents;
     sqlc.SetTraceEvent( TraceEvent);
end;

procedure TjsDataConnexion_SQLQuery.Stop_SQLLog;
begin
		   inherited Stop_SQLLog;
     //sqlc.LogEvents:=[];
     sqlc.SetTraceEvent( nil);
end;

function TjsDataConnexion_SQLQuery.Classe_Contexte: TjsDataContexte_class;
begin
     Result:= TjsDataContexte_SQLQuery;
end;

procedure TjsDataConnexion_SQLQuery.GetFieldNames( const _TableName: String;  _List: TStrings);
begin
     sqlc.GetFieldNames( _TableName, _List);
end;

procedure TjsDataConnexion_SQLQuery.GetTableNames(_List: TStrings);
begin
     sqlc.GetTableNames( _List);
end;

procedure TjsDataConnexion_SQLQuery.GetSchemaNames(_List: TStrings);
begin
     sqlc.GetSchemaNames( _List);
end;

procedure TjsDataConnexion_SQLQuery.Reconnecte;
begin
     inherited Reconnecte;
     sqlc.Connected:= False;
     sqlc.Connected:= True;
end;

procedure TjsDataConnexion_SQLQuery.CopieConnection(source, cible: TSQLConnection);
begin
     cible.Assign( source);
     (*cible.ConnectionName:= source.ConnectionName;
     cible.DriverName    := source.DriverName    ;
     cible.GetDriverFunc := source.GetDriverFunc ;
     cible.LibraryName   := source.LibraryName   ;
     cible.VendorLib     := source.VendorLib     ;*)
     cible.Params.Text   := source.Params.Text   ;
end;

procedure TjsDataConnexion_SQLQuery.Init_Connection( _sqlc: TSQLConnection;
		                                                   _Database: String);
begin
     CopieConnection( sqlc, _sqlc);
     _sqlc.Params.Values['DataBase']:= _Database;
end;

function TjsDataConnexion_SQLQuery.TraceEvent( _TraceInfo: TDBXTraceInfo): CBRType;
begin
     Log.PrintLn( _TraceInfo.Message);
     Result:= cbrUSEDEF;
end;

{ TjsDataConnexion }

constructor TjsDataConnexion.Create( _SGBD: TSGBD);
begin
     FSGBD := _SGBD;
     FsSGBD:= sSGBDs[ FSGBD];

     InitParams;

     Database_indefinie:= True;
     Ouvrable:= False;

     Contexte:= nil;
end;

destructor TjsDataConnexion.Destroy;
begin
		   inherited Destroy;
end;

procedure TjsDataConnexion.SetHostName( const Value: String);
begin
     FHostName:= Value;
end;

procedure TjsDataConnexion.InitParams;
begin
     DataBase := '';
     FHostName:= '';
     User_Name:= '';
     Password := '';
end;

procedure TjsDataConnexion.Prepare;
begin

end;

procedure TjsDataConnexion.Ouvre_db;
begin

end;

procedure TjsDataConnexion.Ferme_db;
begin
     Ouvert:= False;
end;

procedure TjsDataConnexion.Keep_Connection;
begin

end;

procedure TjsDataConnexion.Do_not_Keep_Connection;
begin

end;

procedure TjsDataConnexion.Ecrire;
begin

end;

procedure TjsDataConnexion.Fill_with_databases(_s: TStrings);
begin

end;

(*
procedure TjsDataConnexion.Fill_with_databases( _cb: TComboBox);
begin
     if _cb = nil then exit;

     Fill_with_databases( _cb.Items);
     _cb.Sorted:= True;
end;
*)

function TjsDataConnexion.EmptyCommande(Commande: String): Boolean;
var
   J: Integer;
begin
     Result:= True;
     for J:= 1 to Length( Commande)
     do
       begin
       Result:= Commande[J] in [' ', #13, #10];
       if not Result then break;
       end;
end;

procedure TjsDataConnexion.DoScript(NomFichierScriptSQL: String);
begin

end;

procedure TjsDataConnexion.DoLOAD_INTO_MarchesSystem(NomFichier,
		NomTable: String; NbLignesEntete: Integer);
begin

end;

procedure TjsDataConnexion.DoLOAD_INTO_INFORMIX(NomFichier, NomTable: String;
		LinuxWindows_: Boolean);
begin

end;

function TjsDataConnexion.MySQLPath(NomFichier: String): String;
var
   I: Integer;
begin
     Result:= NomFichier;
     for I:= 1 to Length(Result)
     do
       if Result[I] = '\' then Result[I]:= '/';
end;

procedure TjsDataConnexion.Start_SQLLog;
begin

end;

procedure TjsDataConnexion.Stop_SQLLog;
begin

end;

procedure TjsDataConnexion.Reconnecte;
begin

end;

function TjsDataConnexion.sSGBD_Database: String;
begin
     Result
     :=
       'base '+DataBase+' sur '+sSGBD;
end;

function TjsDataConnexion.Cree_Contexte( _Name: String): TjsDataContexte;
begin
     Result:= Classe_Contexte.Create( _Name);
     Result.SetConnection( Self);
end;

function TjsDataConnexion.Base_sur: String;
begin
     Result:= 'base '+sSGBD+' '+DataBase+' sur '+HostName;
end;

{ TjsDataContexte_Champ_Info }

procedure TjsDataContexte_Champ_Info.FieldType_Default( _FieldType: TFieldType);
begin
     if  ftUnknown <> FieldType then exit;

     FieldType:= _FieldType;
end;

{ TjsDataContexte_Champ }

constructor TjsDataContexte_Champ.Create( _Nom: String);
begin
     inherited Create;
     Nom:= _Nom;
     Info_Init;
end;

destructor TjsDataContexte_Champ.Destroy;
begin
     inherited Destroy;
end;

procedure TjsDataContexte_Champ.Info_Init;
begin
     Info.Visible := False;
     Info.Libelle := Nom;
     Info.Longueur:= Length(Nom);
     Info.FieldType:= ftUnknown;
     Info.jsDataType:= jsdt_Unknown;
end;

function TjsDataContexte_Champ.asString: String;
begin
     Result:= '';
     Info.jsDataType:= jsdt_String;
     Info.FieldType_Default( ftString);
end;

function TjsDataContexte_Champ.asDate: TDateTime;
begin
     Result:= 0;
     Info.jsDataType:= jsdt_Date;
     Info.FieldType_Default( ftDate);
end;

function TjsDataContexte_Champ.asDateTime: TDateTime;
begin
     Result:= 0;
     Info.jsDataType:= jsdt_DateTime;
     Info.FieldType_Default( ftDateTime);
end;

function TjsDataContexte_Champ.asInteger: LargeInt;
begin
     Result:= 0;
     Info.jsDataType:= jsdt_Integer;
     Info.FieldType_Default( ftInteger);
end;

function TjsDataContexte_Champ.asCurrency: Currency;
begin
     Result:= 0;
     Info.jsDataType:= jsdt_Currency;
     Info.FieldType_Default( ftCurrency);
end;

function TjsDataContexte_Champ.asDouble: double;
begin
     Result:= 0;
     Info.jsDataType:= jsdt_Double;
     Info.FieldType_Default( ftFloat);
end;

function TjsDataContexte_Champ.asBoolean: Boolean;
begin
     Result:= False;
     Info.jsDataType:= jsdt_Boolean;
     Info.FieldType_Default( ftBoolean);
end;

procedure TjsDataContexte_Champ.Charge( _jsDataType: TjsDataType; _Valeur: Pointer);
begin
     case _jsDataType
     of
       jsdt_ShortString: PShortString( _Valeur)^:= asString  ;
       jsdt_String     : PString     ( _Valeur)^:= asString  ;
       jsdt_Date       : PDateTime   ( _Valeur)^:= asDate    ;
       jsdt_DateTime   : PDateTime   ( _Valeur)^:= asDateTime;
       jsdt_Integer    : PInteger    ( _Valeur)^:= asInteger ;
       jsdt_Currency   : PCurrency   ( _Valeur)^:= asCurrency;
       jsdt_Double     : PDouble     ( _Valeur)^:= asDouble  ;
       jsdt_Boolean    : PtrBoolean  ( _Valeur)^:= asBoolean ;
       jsdt_Unknown    : begin end;
       end;
end;

function jsDataContexte_Champ_from_sl( sl: TBatpro_StringList; Index: Integer): TjsDataContexte_Champ;
begin
     _Classe_from_sl( Result, TjsDataContexte_Champ, sl, Index);
end;

function jsDataContexte_Champ_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TjsDataContexte_Champ;
begin
     _Classe_from_sl_sCle( Result, TjsDataContexte_Champ, sl, sCle);
end;

{ TjsDataContexte_Champ_Dataset }

constructor TjsDataContexte_Champ_Dataset.Create( _Nom: String; _F: TField);
begin
     F:= _F;
     inherited Create( _Nom);
end;

destructor TjsDataContexte_Champ_Dataset.Destroy;
begin
     inherited Destroy;
end;

procedure TjsDataContexte_Champ_Dataset.Info_Init;
begin
     inherited Info_Init;
     if Assigned(F)
     then
         begin
         Info.Visible  := F.Visible;
         Info.Libelle  := F.DisplayLabel;
         Info.Longueur := F.DisplayWidth;
         Info.FieldType:= F.DataType;
         end;
end;

function TjsDataContexte_Champ_Dataset.asString: String;
var
   sf: TStringField;
   mf: TMemoField;
   bf: TBlobField;
   procedure Traite_Memo;
   begin
        if mf.IsNull
        then
            Result:= ''
        else
            Result:= mf.Value;
   end;
   procedure Traite_Blob;
   begin
        try
           if bf.IsNull
           then
               Result:= ''
           else
               Result:= bf.AsString;
        except
              on E: Exception do Result:= '';
              end;
   end;
begin
     Result:=inherited asString;

     if nil = F then exit;

          if Affecte( sf, TStringField, F) then Result:= TrimRight( sf.Value)
     else if Affecte( mf, TMemoField  , F) then Traite_Memo
     else if Affecte( bf, TBlobField  , F) then Traite_Blob;
end;

function TjsDataContexte_Champ_Dataset.asDate: TDateTime;
var
   df: TDateField;
   dtf: TDateTimeField;
   {$IF DEFINED(MSWINDOWS) AND NOT DEFINED(FPC)}
   sqltsf: TSQLTimeStampField;
   {$IFEND}
begin
     Result:=inherited asDate;

     if nil = F then exit;
          if Affecte(     df, TDateField        , F) then Result:=     df.Value
     else if Affecte(    dtf, TDateTimeField    , F) then Result:=    dtf.Value
     {$IF DEFINED(MSWINDOWS) AND NOT DEFINED(FPC)}
     else if Affecte( sqltsf, TSQLTimeStampField, F) then Result:= sqltsf.asDateTime
     {$IFEND}
     ;
end;

function TjsDataContexte_Champ_Dataset.asDateTime: TDateTime;
var
   df: TDateField;
   dtf: TDateTimeField;
   {$IF DEFINED(MSWINDOWS) AND NOT DEFINED(FPC)}
   sqltsf: TSQLTimeStampField;
   {$IFEND}
   sf: TStringField;
   mf: TMemoField;
   bf: TBlobField;
   procedure Result_from( _s: String);
   const
        English_FormatSettings : TFormatSettings = (
{
    CurrencyString: string;
    CurrencyFormat: Byte;
    CurrencyDecimals: Byte;
    DateSeparator: Char;
    TimeSeparator: Char;
    ListSeparator: Char;
    ShortDateFormat: string;
    LongDateFormat: string;
    TimeAMString: string;
    TimePMString: string;
    ShortTimeFormat: string;
    LongTimeFormat: string;
    ShortMonthNames: array[1..12] of string;
    LongMonthNames: array[1..12] of string;
    ShortDayNames: array[1..7] of string;
    LongDayNames: array[1..7] of string;
    EraInfo: array of TEraInfo;
    ThousandSeparator: Char;
    DecimalSeparator: Char;
    TwoDigitYearCenturyWindow: Word;
    NegCurrFormat: Byte;
    /// <summary>
    /// This is a candidate to be removed or left to store the Locale that created the FormatSettings.
    /// </summary>
    NormalizedLocaleName: string;
}
          CurrencyString: '$';
          CurrencyFormat: 1;
          CurrencyDecimals: 2;
          DateSeparator: '-';
          TimeSeparator: ':';
          ListSeparator: ',';
          ShortDateFormat: 'd/m/y';
          LongDateFormat: 'dd" "mmmm" "yyyy';
          TimeAMString: 'AM';
          TimePMString: 'PM';
          ShortTimeFormat: 'hh:nn';
          LongTimeFormat: 'hh:nn:ss';
          ShortMonthNames: ('Jan','Feb','Mar','Apr','May','Jun',
                            'Jul','Aug','Sep','Oct','Nov','Dec');
          LongMonthNames: ('January','February','March','April','May','June',
                           'July','August','September','October','November','December');
          ShortDayNames: ('Sun','Mon','Tue','Wed','Thu','Fri','Sat');
          LongDayNames:  ('Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday');
          EraInfo:[];
          ThousandSeparator: ',';
          DecimalSeparator: '.';
          TwoDigitYearCenturyWindow: 50;
          NegCurrFormat: 5;
          NormalizedLocaleName:'';
        );
   var
      JourJulien: double;
   begin
        Result:= 0;
        if '' = _s then exit;

        if TryStrToFloat( _s, JourJulien, English_FormatSettings)
        then //En Float, SQLite3 stocke la date en jour julien
            begin
            Result:= JulianDateToDateTime( JourJulien);
            exit;
            end;
        if Try_DateTime_from_DateTimeSQL_sans_quotes( _s, Result) then exit;
   end;
   procedure Traite_String;
   begin
        if sf.IsNull
        then
            Result_from( '')
        else
            Result_from( TrimRight( sf.Value));
   end;
   procedure Traite_Memo;
   begin
        if mf.IsNull
        then
            Result_from( '')
        else
            Result_from( mf.Value);
   end;
   procedure Traite_Blob;
   begin
        try
           if bf.IsNull
           then
               Result_from( '')
           else
               Result_from( bf.AsString);
        except
              on E: Exception do Result_from( '');
              end;
   end;
begin
     Result:=inherited asDateTime;

     if nil = F then exit;
          if Affecte(     df, TDateField        , F) then Result:=     df.Value
     else if Affecte(    dtf, TDateTimeField    , F) then Result:=    dtf.Value
     {$IF DEFINED(MSWINDOWS) AND NOT DEFINED(FPC)}
     else if Affecte( sqltsf, TSQLTimeStampField, F) then Result:= sqltsf.asDateTime
     {$IFEND}
     else if Affecte( sf, TStringField, F) then Traite_String
     else if Affecte( mf, TMemoField  , F) then Traite_Memo
     else if Affecte( bf, TBlobField  , F) then Traite_Blob;
     ;

end;

function TjsDataContexte_Champ_Dataset.asInteger: LargeInt;
var
   linf   : TLargeintField;
   inf    : TIntegerField ;
   sif    : TSmallIntField;
   sf     : TStringField  ;
   ff     : TFloatField   ;
   bcdf   : TBCDField     ;
   fmtbdcf: TFMTBCDField  ;
   procedure Traite_StringField;
   var
      S: String;
   begin
        S:= sf.Value;
        if not TryStrToInt64( S, Result)
        then
            Result:= -1;
   end;
begin
     Result:=inherited asInteger;

     if nil = F then exit;
          if Affecte(    linf, TLargeintField, F) then Result:= linf.Value
     else if Affecte(     inf, TIntegerField , F) then Result:= inf.Value
     else if Affecte(     sif, TSmallIntField, F) then Result:= sif.Value
     else if Affecte(      sf, TStringField  , F) then Traite_StringField
     else if Affecte(      ff, TFloatField   , F) then Result:= Trunc(   ff.Value     )
     else if Affecte(    bcdf, TBCDField     , F) then Result:= Trunc( bcdf.Value     )
     else if Affecte( fmtbdcf, TFMTBCDField  , F) then Result:= Trunc( fmtbdcf.AsFloat);
end;

function TjsDataContexte_Champ_Dataset.asCurrency: Currency;
var
   ff     : TFloatField ;
   bcdf   : TBCDField   ;
   fmtbcdf: TFMTBCDField;
   cf     : TCurrencyField;
begin
     Result:=inherited asCurrency;

     if nil = F then exit;

          if Affecte(      ff, TFloatField   , F) then Result:=      ff.AsCurrency
     else if Affecte(    bcdf, TBCDField     , F) then Result:=    bcdf.Value
     else if Affecte( fmtbcdf, TFMTBCDField  , F) then Result:= fmtbcdf.AsCurrency
     else if Affecte(      cf, TCurrencyField, F) then Result:=      cf.AsCurrency;
end;

function TjsDataContexte_Champ_Dataset.asDouble: double;
var
   ff     : TFloatField ;
   bcdf   : TBCDField   ;
   fmtbcdf: TFMTBCDField;
begin
     Result:=inherited asDouble;

     if nil = F then exit;
          if Affecte( ff     , TFloatField , F) then Result:=      ff.Value
     else if Affecte( bcdf   , TBCDField   , F) then Result:=    bcdf.Value
     else if Affecte( fmtbcdf, TFMTBCDField, F) then Result:= fmtbcdf.AsFloat;
end;

function TjsDataContexte_Champ_Dataset.asBoolean: Boolean;
begin
     Result:=inherited asBoolean;

     if nil = F then exit;
     try
        Result:= F.AsBoolean;
     except
           on E: Exception do Result:= False;
           end;
end;

{ TIterateur_jsDataContexte_Champ }

function TIterateur_jsDataContexte_Champ.not_Suivant( out _Resultat: TjsDataContexte_Champ): Boolean;
begin
     Result:= not_Suivant_interne( _Resultat);
end;

procedure TIterateur_jsDataContexte_Champ.Suivant( out _Resultat: TjsDataContexte_Champ);
begin
     Suivant_interne( _Resultat);
end;

{ TsljsDataContexte_Champ }

constructor TsljsDataContexte_Champ.Create( _Nom: String= '');
begin
     inherited CreateE( _Nom, TjsDataContexte_Champ);
end;

destructor TsljsDataContexte_Champ.Destroy;
begin
     inherited;
end;

class function TsljsDataContexte_Champ.Classe_Iterateur: TIterateur_Class;
begin
     Result:= TIterateur_jsDataContexte_Champ;
end;

function TsljsDataContexte_Champ.Iterateur: TIterateur_jsDataContexte_Champ;
begin
     Result:= TIterateur_jsDataContexte_Champ( Iterateur_interne);
end;

function TsljsDataContexte_Champ.Iterateur_Decroissant: TIterateur_jsDataContexte_Champ;
begin
     Result:= TIterateur_jsDataContexte_Champ( Iterateur_interne_Decroissant);
end;

{ TjsDataContexte }

constructor TjsDataContexte.Create(_Name: String);
begin
     inherited Create;
     Name:= _Name;
     Champs:= TsljsDataContexte_Champ.Create( ClassName+'.Champs');
     id_FielName:= 'id';
end;

destructor TjsDataContexte.Destroy;
begin
     FreeAndNil( Champs);
     inherited Destroy;
end;

function TjsDataContexte.GetConnection: TjsDataConnexion;
begin
     Result:= FConnection;
end;

procedure TjsDataContexte.SetConnection(_Value: TjsDataConnexion);
begin
     FConnection:= _Value;
end;

procedure TjsDataContexte.SetSQL(_SQL: String);
begin
end;

function TjsDataContexte.GetSQL: String;
begin
     Result:= '';
end;

function TjsDataContexte.Params: TParams;
begin
     Result:= nil;
end;

function TjsDataContexte.RefreshQuery: Boolean;
begin
     Result:= False;
end;

function TjsDataContexte.ExecSQLQuery: Boolean;
begin
     Result:= False;
end;

function TjsDataContexte.IsEmpty: Boolean;
begin
     Result:= True;
end;

procedure TjsDataContexte.First;
begin
end;

function TjsDataContexte.EoF: Boolean;
begin
     Result:= True;
end;

procedure TjsDataContexte.Next;
begin
end;

procedure TjsDataContexte.Close;
begin
end;

function TjsDataContexte.Champ_by_Index( _Index: Integer): TjsDataContexte_Champ;
begin
     Result:= jsDataContexte_Champ_from_sl( Champs, _Index);
end;

function TjsDataContexte.Find_Champ( _Champ_Nom: String): TjsDataContexte_Champ;
begin
     Result:= jsDataContexte_Champ_from_sl_sCle( Champs, _Champ_Nom);
end;

procedure TjsDataContexte.Charge_Champs;
begin

end;

procedure TjsDataContexte.Champs_Vide;
begin
     Vide_StringList( Champs);
end;

function TjsDataContexte.  String_from_( _Champ_Nom: String; var Memory: String   ): TjsDataContexte_Champ;
begin
     Result:= Assure_Champ( _Champ_Nom);
     Memory:= Result.asString;
end;

function TjsDataContexte.DateTime_from_( _Champ_Nom: String; var Memory: TDateTime): TjsDataContexte_Champ;
begin
     Result:= Assure_Champ( _Champ_Nom);
     Memory:= Result.asDateTime;
end;

function TjsDataContexte.Integer_from_( _Champ_Nom: String; var Memory: Integer): TjsDataContexte_Champ;
begin
     Result:= Assure_Champ( _Champ_Nom);
     Memory:= Result.asInteger;
end;

function TjsDataContexte.Currency_from_( _Champ_Nom: String; var Memory: Currency): TjsDataContexte_Champ;
begin
     Result:= Assure_Champ( _Champ_Nom);
     Memory:= Result.asCurrency;
end;

function TjsDataContexte.Double_from_( _Champ_Nom: String; var Memory: Double): TjsDataContexte_Champ;
begin
     Result:= Assure_Champ( _Champ_Nom);
     Memory:= Result.asDouble;
end;

function TjsDataContexte.Boolean_from_( _Champ_Nom: String; var Memory: Boolean): TjsDataContexte_Champ;
begin
     Result:= Assure_Champ( _Champ_Nom);
     Memory:= Result.asBoolean;
end;

procedure TjsDataContexte.Charge( _Champ_Nom: String; _jsDataType: TjsDataType; _Valeur: Pointer);
var
   jsdcc: TjsDataContexte_Champ;
begin
     jsdcc:= Assure_Champ( _Champ_Nom);
     jsdcc.Charge( _jsDataType, _Valeur);
end;

procedure TjsDataContexte.Setid_FielName( _id_FielName: String);
begin
     Fid_FielName:= _id_FielName;
end;

function TjsDataContexte.id: Integer;
begin
     Result:= -1;
end;

procedure TjsDataContexte.Create_id_field;
begin
end;

procedure TjsDataContexte.SetUsePrimaryKeyAsKey(_Value: Boolean);
begin
end;

function TjsDataContexte.Est_Vide(_SQL: String): Boolean;
begin
     try
        SQL:= _SQL;
        RefreshQuery;
        First;
        Result:= not IsEmpty;
     finally
            Close;
            end;
end;

function TjsDataContexte.Execute_and_Result_not_empty_dont_close: Boolean;
begin
     RefreshQuery;
     First;
     Result:= not IsEmpty;
end;

function TjsDataContexte.Execute_and_Result_not_empty: Boolean;
begin
     try
        Result:= Execute_and_Result_not_empty_dont_close;
     finally
            Close;
            end;
end;

function TjsDataContexte.Integer_from( _SQL: String; out _Resultat: Integer): Boolean;
var
   c: TjsDataContexte_Champ;
begin
     _Resultat:= 0;
     Result:= False;
     try
        SQL:= _SQL;
        RefreshQuery;
        First;

        Result:= not IsEmpty;

        if not Result
        then
            begin
            uLog.Log.PrintLn( ClassName+'.Integer_from: IsEmpty ');
            exit;
            end;

        Result:= Champs.Count > 0;
        if not Result
        then
            begin
            uLog.Log.PrintLn( ClassName+'.Integer_from: Champs.Count = 0');
            exit;
            end;

        c:= Champ_by_Index( 0);
        Result:= Assigned( c);
        if not Result
        then
            begin
            uLog.Log.PrintLn( ClassName+'.Integer_from: Champ_by_Index( 0) = nil');
            exit;
            end;

        _Resultat:= c.asInteger;
     finally
            Close;
            end;
end;

function TjsDataContexte.Integer_from( _SQL, _NomChamp: String; out _Resultat: Integer): Boolean;
var
   c: TjsDataContexte_Champ;
begin
     _Resultat:= 0;
     try
        SQL:= _SQL;
        RefreshQuery;
        First;
        Result:= not IsEmpty;
        if  not Result then exit;

        c:= Find_Champ( _NomChamp);

        Result:= Assigned( c);
        if not Result then exit;

        _Resultat:= c.AsInteger;
     finally
            Close;
            end;
end;

function TjsDataContexte.Integer_from(_SQL, _NomChamp: String; _Params: TParams; out _Resultat: Integer): Boolean;
var
   C: TjsDataContexte_Champ;
begin
     _Resultat:= 0;
     try
        SQL:= _SQL;
        Params.AssignValues( _Params);
        RefreshQuery;
        First;
        Result:= not IsEmpty;
        if not Result then exit;

        C:= Find_Champ( _NomChamp);
        Result:= Assigned( C);
        if not Result then exit;

        _Resultat:= C.AsInteger;
     finally
            Close;
            end;
end;

function TjsDataContexte.String_from( _SQL: String; var _Resultat: String;
                                      _Index: Integer= 0): Boolean;
var
   C: TjsDataContexte_Champ;
begin
     _Resultat:= '';
     try
        SQL:= _SQL;
        RefreshQuery;
        First;
        Result:= Champs.Count >= _Index+1;
        if not Result then exit;

        C:= Champ_by_Index( _Index);
        Result:= Assigned( C);
        if not Result then exit;

        _Resultat:= C.AsString;
     finally
            Close;
            end;
end;

function TjsDataContexte.String_from( _SQL, _NomChamp: String; var _Resultat: String): Boolean;
var
   C: TjsDataContexte_Champ;
begin
     _Resultat:= '';
     try
        SQL:= _SQL;
        RefreshQuery;
        First;
        Result:= not IsEmpty;
        if not Result then exit;

        C:= Find_Champ( _NomChamp);
        Result:= Assigned( C);
        if not Result then exit;

        _Resultat:= C.AsString;
     finally
            Close;
            end;
end;

function TjsDataContexte.String_from( _SQL, _NomChamp: String; _Params: TParams;
		                                    out _Resultat: String): Boolean;
var
   C: TjsDataContexte_Champ;
begin
     _Resultat:= '';
     try
        SQL:= _SQL;
        Params.AssignValues( _Params);
        RefreshQuery;
        First;
        Result:= not IsEmpty;
        if not Result then exit;

        C:= Find_Champ( _NomChamp);
        Result:= Assigned( C);
        if not Result then exit;

        _Resultat:= C.asString;
     finally
            Close;
            end;
end;

function TjsDataContexte.Matches(_Champs_Noms, _Champs_Valeurs: TStringDynArray): Boolean;
var
   I: Integer;
   Champ_Nom   : String;
   Champ_Valeur: String;
   C: TjsDataContexte_Champ;
begin
     Result:= False;
     if Length( _Champs_Noms) <> Length( _Champs_Valeurs) then exit;

     try
        RefreshQuery;
        First;
        Result:= not IsEmpty;
        if not Result then exit;

        Result:= False;
        for I:= Low( _Champs_Noms) to High( _Champs_Noms)
        do
          begin
          Champ_Nom   := _Champs_Noms   [I];
          Champ_Valeur:= _Champs_Valeurs[I];
          C:= Find_Champ( Champ_Nom);
          if nil = C then exit;

          if Champ_Valeur <> C.asString then exit;
          end;

        Result:= True;
     finally
            Close;
            end;
end;

function TjsDataContexte.Locate( _Champs_Noms, _Champs_Valeurs: TStringDynArray): Boolean;
var
   I: Integer;
   Champ_Nom   : String;
   Champ_Valeur: String;
   C: TjsDataContexte_Champ;
begin
     Result:= False;
     if Length( _Champs_Noms) <> Length( _Champs_Valeurs) then exit;

     try
        RefreshQuery;
        First;
        Result:= not IsEmpty;
        if not Result then exit;

        repeat
              for I:= Low( _Champs_Noms) to High( _Champs_Noms)
              do
                begin
                Champ_Nom   := _Champs_Noms   [I];
                Champ_Valeur:= _Champs_Valeurs[I];
                C:= Find_Champ( Champ_Nom);
                Result:= Result and Assigned(C);
                if not Result then continue;

                Result:= Result and (Champ_Valeur = C.asString);
                end;
              if Result then exit;
              Next;
        until EoF;
     finally
            Close;
            end;
end;

procedure TjsDataContexte.Liste_Champ_initialize;
begin

end;

procedure TjsDataContexte.Liste_Champ( _SQL, _NomChamp: String;
		                                     _Resultat: TStrings);
var
   C: TjsDataContexte_Champ;
begin
     _Resultat.Clear;
     try
        SQL:= _SQL;
        RefreshQuery;
        First;
        if IsEmpty then exit;

        Liste_Champ_initialize;
        C:= Find_Champ( _NomChamp);
        if nil = C then exit;

        while not EoF
        do
          begin
          _Resultat.Add( C.AsString);
          Next;
          end;
     finally
            Close;
            end;
end;

function TjsDataContexte.sResultat_from_Requete(_SQL: String): String;
var
   I: Integer;
   C: TjsDataContexte_Champ;
begin
     Result:=  _SQL+#13#10
              +'Résultat'+#13#10;
     try
        try
           SQL:= _SQL;
           RefreshQuery;
           First;
           if IsEmpty
           then
               Formate_Liste( Result, #13#10, 'Vide')
           else
               for I:= 0 to Champs.Count-1
               do
                 begin
                 C:= Champ_by_Index( I);
                 if nil = C  then continue;

                 Formate_Liste( Result, #13#10, C.Nom+'=>'+C.asString+'<');
                 end;
        finally
               Close;
               end;
     except
           on E: Exception
           do
             Formate_Liste( Result, #13#10, E.Message);
           end;
end;

procedure TjsDataContexte.GetFieldNames( const _TableName: String; _List: TStrings);
begin
     Connection.GetFieldNames( _TableName, _List);
end;

procedure TjsDataContexte.GetTableNames( _List: TStrings);
begin
     Connection.GetTableNames( _List);
end;

procedure TjsDataContexte.Fill_with_databases(_s: TStrings);
begin
     Connection.Fill_with_databases( _s);
end;

procedure TjsDataContexte.GetSchemaNames( _List: TStrings);
begin
     Connection.GetSchemaNames( _List);
end;

{ TjsDataContexte_Dataset }

constructor TjsDataContexte_Dataset.Create( _Name: String);
begin
     inherited Create( _Name);
end;

destructor TjsDataContexte_Dataset.Destroy;
begin
     inherited Destroy;
end;

function TjsDataContexte_Dataset.ds_FindField( _FieldName: String): TField;
begin
     Result:= nil;
     if nil = ds      then exit;
     if not ds.Active then exit;

     Result:= ds.FindField( _FieldName);
end;

procedure TjsDataContexte_Dataset.First;
begin
     ds.First;
end;

function TjsDataContexte_Dataset.EoF: Boolean;
begin
     Result:= ds.EOF;
end;

procedure TjsDataContexte_Dataset.Next;
begin
     ds.Next;
end;

procedure TjsDataContexte_Dataset.Charge_Champs;
var
   I: Integer;
begin
     inherited Charge_Champs;
     for I:= 0 to ds.FieldCount-1
     do
       Assure_Champ( ds.Fields[I].FieldName);
end;

function TjsDataContexte_Dataset.Assure_Champ( _Champ_Nom: String): TjsDataContexte_Champ;
   procedure Cree_Champ;
   var
      F: TField;
   begin
        F:= ds_FindField( _Champ_Nom);
        Result:= TjsDataContexte_Champ_Dataset.Create( _Champ_Nom, F);
        if nil = Result
        then
            raise Exception.Create( ClassName+'.Assure_Champ: '
                                    +'Echec de TjsDataContexte_Champ_Dataset.Create');
        Champs.AddObject( _Champ_Nom, Result);
   end;
begin
     Result:= Find_Champ( _Champ_Nom);
     if Assigned( Result) then exit;

     Cree_Champ;
end;

{ TjsDataContexte_SQLQuery }

constructor TjsDataContexte_SQLQuery.Create( _Name: String);
begin
     inherited Create( _Name);

     jsDataConnexion_SQLQuery:= nil;

     sqlq:= TSQLQuery.Create( nil);
     sqlq.Name:= 'sqlq';
     sqlqid:= nil;

     ds:= sqlq;
end;

destructor TjsDataContexte_SQLQuery.Destroy;
begin
     ds:= nil;
     FreeAndNil( sqlq); //owner de sqlqid
     inherited Destroy;
end;

procedure TjsDataContexte_SQLQuery.SetSQL(_SQL: String);
begin
     sqlq.SQL.Text:= _SQL;
end;

function TjsDataContexte_SQLQuery.GetSQL: String;
begin
     Result:= sqlq.SQL.Text;
end;

procedure TjsDataContexte_SQLQuery.SetConnection(_Value: TjsDataConnexion);
begin
     if Affecte_( jsDataConnexion_SQLQuery, TjsDataConnexion_SQLQuery, _Value)
     then
         raise Exception.Create( ClassName+'.SetConnection: Wrong type');

     inherited;
     sqlq.SQLConnection:= jsDataConnexion_SQLQuery.sqlc;
end;

procedure TjsDataContexte_SQLQuery.Liste_Champ_initialize;
begin
     inherited Liste_Champ_initialize;
     Charge_Champs;
end;

function TjsDataContexte_SQLQuery.RefreshQuery: Boolean;
begin
     Champs_Vide;
     Result:= uDataUtilsF.RefreshQuery( sqlq);
     if Result
     then
         begin
         fID:= sqlq.FindField( id_FielName);
         Charge_Champs;
         end
     else
         fID:= nil;
end;

function TjsDataContexte_SQLQuery.ExecSQLQuery: Boolean;
begin
     Champs_Vide;
     Result:= uDataUtilsF.ExecSQLQuery( sqlq);
end;

procedure TjsDataContexte_SQLQuery.Close;
begin
     sqlq.Close;
end;

function TjsDataContexte_SQLQuery.IsEmpty: Boolean;
begin
     Result:= sqlq.IsEmpty;
end;

function TjsDataContexte_SQLQuery.Params: TParams;
begin
     Result:= sqlq.Params;
end;

procedure TjsDataContexte_SQLQuery.Setid_FielName(_id_FielName: String);
begin
     inherited Setid_FielName( _id_FielName);
     if nil = sqlqid then exit;
     sqlqid.FieldName:= id_FielName;
end;

function TjsDataContexte_SQLQuery.id: Integer;
begin
     if nil = fID
     then
         Result:=inherited id
     else
         Result:= fID.AsInteger;
end;

procedure TjsDataContexte_SQLQuery.Create_id_field;
begin
     sqlqid:= TIntegerField.Create( sqlq);
     sqlqid.FieldName:= id_FielName;
     sqlqid.DataSet:= sqlq;
end;

procedure TjsDataContexte_SQLQuery.SetUsePrimaryKeyAsKey( _Value: Boolean);
begin
     //sqlq.UsePrimaryKeyAsKey:= _Value;
end;

function TjsDataContexte_SQLQuery.Last_Insert_id(_NomTable: String): Integer;
begin
     Result:= Connection.Last_Insert_id( _NomTable);
end;

{ TjsDataContexte_Dataset_Null }
var
   FjsDataContexte_Dataset_Null: TjsDataContexte_Dataset_Null= nil;

function jsDataContexte_Dataset_Null: TjsDataContexte_Dataset_Null;
begin
     if nil = FjsDataContexte_Dataset_Null
     then
         FjsDataContexte_Dataset_Null:= TjsDataContexte_Dataset_Null.Create( 'ujsDataContexte.FjsDataContexte_Dataset_Null');
     Result:= FjsDataContexte_Dataset_Null;
end;

constructor TjsDataContexte_Dataset_Null.Create(_Name: String);
begin
     inherited Create( _Name);
end;

destructor TjsDataContexte_Dataset_Null.Destroy;
begin
     inherited Destroy;
end;

function TjsDataContexte_Dataset_Null.Assure_Champ( _Champ_Nom: String): TjsDataContexte_Champ;
begin
     Result:= Find_Champ( _Champ_Nom);
     if Assigned( Result) then exit;

     Result:= TjsDataContexte_Champ.Create( _Champ_Nom);
     if nil = Result
     then
         raise Exception.Create( ClassName+'.Assure_Champ: '
                                 +'Echec de TjsDataContexte_Champ.Create');
end;

end.

