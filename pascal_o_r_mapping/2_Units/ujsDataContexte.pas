unit ujsDataContexte;

{$mode delphi}

interface

uses
    uClean,
    uChrono,
    uBatpro_StringList,
    uDataUtilsF,
 Classes, SysUtils, db, sqldb, strutils;

type
  PtrBoolean= ^Boolean;
  TjsDataType
  =
   ( jsdt_String, jsdt_DateTime, jsdt_Integer, jsdt_Currency, jsdt_Double, jsdt_Boolean, jsdt_ShortString, jsdt_Unknown);

  { TjsDataContexte_Champ_Info }

  TjsDataContexte_Champ_Info
  =
   object
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
     function asDateTime: TDateTime; virtual;
     function asInteger : Integer  ; virtual;
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
     function asDateTime: TDateTime; override;
     function asInteger : Integer  ; override;
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
     constructor Create( _Name: String);
     destructor Destroy; override;
   //Name
   public
     Name: String;
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
     function   Find_Champ( _Champ_Nom: String): TjsDataContexte_Champ;
     function Assure_Champ( _Champ_Nom: String): TjsDataContexte_Champ; virtual;abstract;
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
   end;


  { TjsDataContexte_Dataset }

  TjsDataContexte_Dataset
  =
   class( TjsDataContexte)
   //Gestion du cycle de vie
   public
     constructor Create( _Name: String; _ds: TDataset);
     destructor Destroy; override;
   //SQL
   public
     procedure First;        override;
     function EoF: Boolean;  override;
     procedure Next;         override;
   //Contexte Dataset
   private
     ds: TDataset;
     function ds_FindField( _FieldName: String): TField;
   //Champs
   public
     function Assure_Champ( _Champ_Nom: String): TjsDataContexte_Champ; override;
   end;

  { TjsDataContexte_SQLQuery }

  TjsDataContexte_SQLQuery
  =
   class( TjsDataContexte_Dataset)
   //Gestion du cycle de vie
   public
     constructor Create( _Name: String);
     destructor Destroy; override;
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
   private
     sqlq: TSQLQuery;
     function GetConnection: TDatabase;
     procedure SetConnection(_Value: TDatabase);
   public
     property Connection: TDatabase read GetConnection write SetConnection;
   //Champ id
   private
     sqlqid: TLongintField;
     fID: TField;
   protected
     procedure Setid_FielName( _id_FielName: String);override;
   public
     function id: Integer; override;
     procedure Create_id_field;
   //spécial Gestion bases Microsoft Access en Freepascal
   private
     procedure SetUsePrimaryKeyAsKey( _Value: Boolean);
   public
     property UsePrimaryKeyAsKey: Boolean write SetUsePrimaryKeyAsKey;
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

implementation

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

function TjsDataContexte_Champ.asDateTime: TDateTime;
begin
     Result:= 0;
     Info.jsDataType:= jsdt_DateTime;
     Info.FieldType_Default( ftDateTime);
end;

function TjsDataContexte_Champ.asInteger: Integer;
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
begin
     Result:=inherited asString;

     if nil = F then exit;

          if Affecte( sf, TStringField, F) then Result:= TrimRight( sf.Value)
     else if Affecte( mf, TMemoField  , F) then Result:= IfThen( mf.IsNull, '', mf.Value)
     else if Affecte( bf, TBlobField  , F)
     then
         try
            Result:= IfThen( bf.IsNull, '', bf.Value);
         except
               on E: Exception do Result:= '';
               end;


end;

function TjsDataContexte_Champ_Dataset.asDateTime: TDateTime;
var
   df: TDateField;
   dtf: TDateTimeField;
   {$IF DEFINED(MSWINDOWS) AND NOT DEFINED(FPC)}
   sqltsf: TSQLTimeStampField;
   {$IFEND}
begin
     Result:=inherited asDateTime;

     if nil = F then exit;
          if Affecte(     df, TDateField        , F) then Result:=     df.Value
     else if Affecte(    dtf, TDateTimeField    , F) then Result:=    dtf.Value
     {$IF DEFINED(MSWINDOWS) AND NOT DEFINED(FPC)}
     else if Affecte( sqltsf, TSQLTimeStampField, F) then Result:= sqltsf.asDateTime
     {$IFEND}
     ;

end;

function TjsDataContexte_Champ_Dataset.asInteger: Integer;
var
   inf    : TLongintField ;
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
        if not TryStrToInt( S, Result)
        then
            Result:= -1;
   end;
begin
     Result:=inherited asInteger;

     if nil = F then exit;
          if Affecte(     inf, TLongintField , F) then Result:= inf.Value
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

function TjsDataContexte.Find_Champ( _Champ_Nom: String): TjsDataContexte_Champ;
begin
     Result:= jsDataContexte_Champ_from_sl_sCle( Champs, _Champ_Nom);
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

{ TjsDataContexte_Dataset }

constructor TjsDataContexte_Dataset.Create( _Name: String; _ds: TDataset);
begin
     inherited Create( _Name);
     ds:= _ds;
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

function TjsDataContexte_Dataset.Assure_Champ( _Champ_Nom: String): TjsDataContexte_Champ;
var
   F: TField;
begin
     Result:= Find_Champ( _Champ_Nom);
     if Assigned( Result) then exit;

     F:= ds_FindField( _Champ_Nom);
     Result:= TjsDataContexte_Champ_Dataset.Create( _Champ_Nom, F);
     if nil = Result
     then
         raise Exception.Create( ClassName+'.Assure_Champ: '
                                 +'Echec de TjsDataContexte_Champ_Dataset.Create');
end;

{ TjsDataContexte_SQLQuery }

constructor TjsDataContexte_SQLQuery.Create( _Name: String);
begin
     sqlq:= TSQLQuery.Create( nil);
     sqlq.Name:= 'sqlq';
     sqlqid:= nil;

     inherited Create( _Name, sqlq);
end;

destructor TjsDataContexte_SQLQuery.Destroy;
begin
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

function TjsDataContexte_SQLQuery.GetConnection: TDatabase;
begin
     Result:= sqlq.DataBase;
end;

procedure TjsDataContexte_SQLQuery.SetConnection(_Value: TDatabase);
begin
     sqlq.DataBase:= _Value;
end;

function TjsDataContexte_SQLQuery.RefreshQuery: Boolean;
begin
     Result:= uDataUtilsF.RefreshQuery( sqlq);
     if Result
     then
         fID:= sqlq.FindField( id_FielName)
     else
         fID:= nil;
end;

function TjsDataContexte_SQLQuery.ExecSQLQuery: Boolean;
begin
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
     sqlq.UsePrimaryKeyAsKey:= _Value;
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

