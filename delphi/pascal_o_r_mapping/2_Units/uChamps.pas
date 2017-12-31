unit uChamps;
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            partly as freelance: http://www.mars42.com                          |
        and partly as employee : http://www.adinfo.com                          |
                                 http://www.adi-bat.com                         |
    Copyright 2017 Jean SUZINEAU - MARS42                                       |
    Copyright 2017 GROUPE ADINFO SOFTWARE                                       |
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
    uForms,
    uBatpro_StringList,
    uClean,
    uLookupConnection_Ancetre,
    uDataUtilsU,
    u_sys_,
    uuStrings,
    uChamp,
    {$IF DEFINED(MSWINDOWS) AND NOT DEFINED(FPC)}
    udmf,
    {$IFEND}
    uChampDefinition,
    uChampDefinitions,
    ufAccueil_Erreur,
  {$IF DEFINED(MSWINDOWS) AND NOT DEFINED(FPC)}
  SQLTimSt,
  {$IFEND}
  {$IFDEF FPC}
  fpjson,
  jsonparser,
  {$ENDIF}
  SysUtils, Classes, DB,Types;

type
 TSave_to_database_Procedure= procedure of object;

 { TChamps }

 TChamps
 =
  class
  private
    FChampDefinitions: TChampDefinitions;
    Fq: TDataset;
    Fsl: TslChamp;

    function Ajoute( Memory: Pointer;
                      Field: String; _FieldType: TFieldType;
                      Persistant: Boolean; F: TField): TChamp;
    {$IF DEFINED(MSWINDOWS) AND NOT DEFINED(FPC)}
    function Ajoute_dmf_Lookup( Memory: Pointer;
                                Field: String;
                                _FieldType: TFieldType;
                                dmf: Tdmf;
                                _LookupKey: TChamp): TChamp;
    {$IFEND}
    function Ajoute_Lookup( Memory: Pointer;
                            Field: String;
                            _FieldType: TFieldType;
                            _LookupKey: TChamp;
                            _OnGetLookupListItems: TOnGetLookupListItems;
                            _Valeur_courante: String): TChamp;
    procedure Erreur_Champ( Field, TypeField: String; var _Persistant: Boolean);
  public
    constructor Create( _ClassName: String;
                        _q: TDataset;
                        _Save_to_database_Procedure: TSave_to_database_Procedure);
    destructor Destroy; override;

    //FChampDefinitions rajouté en write pour permettre l'amorçage
    property ChampDefinitions: TChampDefinitions read FChampDefinitions write FChampDefinitions;
    property q    : TDataset read Fq ;
    property sl   : TslChamp read Fsl;

    function   ShortString_from_   (var Memory:ShortString;Field:String;Persistant:Boolean=True): TChamp;
    function   String_from_String  (var Memory:   String;Field:String;Persistant:Boolean=True): TChamp;
    function   String_from_Memo    (var Memory:   String;Field:String;Persistant:Boolean=True): TChamp;
    function   String_from_Blob    (var Memory:   String;Field:String;Persistant:Boolean=True): TChamp;
    function   String_from_        (var Memory:   String;Field:String;Persistant:Boolean=True): TChamp;
    function  Integer_from_Integer (var Memory:  Integer;Field:String;Persistant:Boolean=True): TChamp;
    function  Integer_from_SmallInt(var Memory:  Integer;Field:String;Persistant:Boolean=True): TChamp;
    function  Integer_from_String  (var Memory:  Integer;Field:String;Persistant:Boolean=True): TChamp;
    function  Integer_from_FMTBCD  (var Memory:  Integer;Field:String;Persistant:Boolean=True): TChamp;
    function  Integer_from_        (var Memory:  Integer;Field:String;Persistant:Boolean=True): TChamp;
    function  Integer_from_Double  (var Memory:  Integer;Field:String;Persistant:Boolean=True): TChamp;
    function Currency_from_BCD     (var Memory: Currency;Field:String;Persistant:Boolean=True): TChamp;
    function   Double_from_        (var Memory:   Double;Field:String;Persistant:Boolean=True): TChamp;
    function DateTime_from_Date    (var Memory:TDateTime;Field:String;Persistant:Boolean=True): TChamp;
    function DateTime_from_        (var Memory:TDateTime;Field:String;Persistant:Boolean=True): TChamp;
    function Cree_Champ_ID         (var Memory:  Integer): TChamp;
    function Ajoute_ShortString    (var Memory:ShortString;Field:String;Persistant:Boolean=True): TChamp;
    function Ajoute_String         (var Memory:   String;Field:String;Persistant:Boolean=True): TChamp;
    function Ajoute_Integer        (var Memory:  Integer;Field:String;Persistant:Boolean=True): TChamp;
    function Ajoute_SmallInt       (var Memory:  Integer;Field:String;Persistant:Boolean=True): TChamp;
    function Ajoute_DateTime       (var Memory:TDatetime;Field:String;Persistant:Boolean=True): TChamp;
    function Ajoute_Date           (var Memory:TDatetime;Field:String;Persistant:Boolean=True): TChamp;
    function Ajoute_BCD            (var Memory:Currency ;Field:String;Persistant:Boolean=True): TChamp;
    function Ajoute_Float          (var Memory:Double   ;Field:String;Persistant:Boolean=True): TChamp;
    function Ajoute_Boolean        (var Memory:Boolean  ;Field:String;Persistant:Boolean=True): TChamp;
  // lookups
  public
    {$IF DEFINED(MSWINDOWS) AND NOT DEFINED(FPC)}
    function   String_dmf_Lookup   (var Memory:   String;Field:String; dmf: Tdmf; _LookupKey: TChamp): TChamp;
    {$IFEND}
    function   String_Lookup       (var Memory:   String;Field:String; _LookupKey: TChamp; _OnGetLookupListItems: TOnGetLookupListItems; _Valeur_courante: String): TChamp;
  //persistance
  private
    Save_to_database_Procedure: TSave_to_database_Procedure; //callback vers TBatproLigne
  public
    Insertion: Boolean; //à passer à True pour éviter la sauvegarde automatique
                        // lors de l'insertion d'une nouvelle ligne
    procedure To_Params_Update( Params: TParams);
    procedure To_Params_Insert( Params: TParams);
    procedure To_Params_Delete( Params: TParams);
    procedure Save_to_database;
    //note: équivalent informix du LAST_INSERTID de MySQL:
    //  select dbinfo('sqlca.sqlerrd1') from systables where tabid =1
  //Rechargement
  public
    procedure Recharge( _q: TDataset);
  // accés
  private
    procedure SetChamp_from_Field( Field: String; const Value: TChamp);
  public
    cID: TChamp;
    function Champ_from_Index( I: Integer): TChamp;
    function Field_from_Index( I: Integer): String;
    function Index_from_Field( Field: String): Integer;
    function Count: Integer;

    function Champ_from_Field( Field: String): TChamp;
    property Champ[ Field: String]: TChamp
             read  Champ_from_Field
             write SetChamp_from_Field;
  //Valeur[Field:String]:String
  private
    function  GetValeur_from_Field( _Field: String): String;
    procedure SetValeur_from_Field( _Field: String; _Value: String);
  public
    property Valeur_from_Field[Field: String]: String
       read  GetValeur_from_Field
       write SetValeur_from_Field;
  //Accés par pointeur sur la valeur
  public
    function Champ_from_Valeur( var _Valeur): TChamp;

  //Sérialisation
  public
    procedure Serialise  ( S: TStream);
    procedure DeSerialise( S: TStream);
  //Affichage de la liste des noms de champ
  public
    procedure Liste;
  //Export JSON, JavaScript Object Notation
  private
    function  GetJSON: String;
    {$IFDEF FPC}
    procedure SetJSON( _Value: String);
    {$ENDIF}
  public
    property JSON: String
             read GetJSON
             {$IFDEF FPC}
             write SetJSON
             {$ENDIF}
             ;
  //Champs aggrégés
  private
    slAggreges: TslChamp;
    procedure    Aggrege_interne( _NomChamp: String; _C: TChamp);
    procedure DesAggrege_interne( _NomChamp: String);
  public
    procedure    Aggrege( _NomChamp: String; _Champs: TChamps; _Champs_NomChamp: String= '');
    procedure DesAggrege( _NomChamp: String);
    procedure    AggregeChamps( _Prefixe: String; _Champs: TChamps);
    procedure DesAggregeChamps( _Prefixe: String; _Champs: TChamps);
  //Gestion du regroupement des mises à jour dans la base
  private
    Modified: Boolean;
  public
    procedure Modified_OR( _Modified: Boolean);
    procedure Save_to_database_if_modified;
  //Rejouer la dernière modification
  public
    function Refaire_Derniere_Modification: Boolean;
  //ReadOnly
  private
    procedure SetReadOnly( const _Value: Boolean);
  public
    property ReadOnly: Boolean write SetReadOnly;
  end;

 TChampsProvider
 =
  class( TJSONProvider)
    function  GetChamps: TChamps; virtual;
    function Champ_a_editer( Contexte: Integer): TChamp; virtual;
  //Valeur[Field:String]:String
  private
    function  GetValeur_from_Field( _Field: String): String;
    procedure SetValeur_from_Field( _Field: String; _Value: String);
  public
    property Valeur_from_Field[Field: String]: String
       read  GetValeur_from_Field
       write SetValeur_from_Field;
  end;
 IChampsComponent
 =
  interface
  ['{3BB7E479-F42C-4B47-93C7-9A562FD5B0A9}']//généré dans Delphi par(Maj+Ctrl+G)
    function  GetChamps: TChamps;
    procedure SetChamps( Value: TChamps);
    property Champs: TChamps read GetChamps write SetChamps;

    function GetComponent: TComponent;
    property Component: TComponent read GetComponent;
  end;

 TLookupConnection
 =
  class( TLookupConnection_Ancetre)
  //Gestion du cycle de vie
  public
    constructor Create( _Maitre_Champs: TChamps);
    destructor Destroy; override;
  //Attributs
  public
    Maitre_Champs: TChamps;
  //Méthodes
  public
    function Convient( blDetail: TChampsProvider): Boolean;
  end;

const
     dbf_rowid= 'rowid';

function Object_from_sl( sl: TBatpro_StringList; I: Integer): TObject;
function Champs_from_Object( O: TObject): TChamps;
function Champs_from_sl( sl: TBatpro_StringList; I: Integer): TChamps;

procedure Champs_Reset  ( Components: array of IChampsComponent);
procedure Champs_Affecte( Provider: TChampsProvider; Components: array of IChampsComponent);

function  Champs_GetValeur_from_Field( Provider: TChampsProvider; _Field: String): String;
procedure Champs_SetValeur_from_Field( Provider: TChampsProvider; _Field: String; _Value: String);

implementation

function Object_from_sl( sl: TBatpro_StringList; I: Integer): TObject;
begin
     Result:= nil;
     if sl = nil then exit;                            
     if (I < 0) or (sl.Count <= I) then exit;

     Result:= sl.Objects[ I];
end;

function Champs_from_Object( O: TObject): TChamps;
var
   ChampsProvider: TChampsProvider;
begin
     Result:= nil;

     ChampsProvider:= TChampsProvider( O);
     CheckClass( ChampsProvider, TChampsProvider);
     if ChampsProvider = nil then exit;

     Result:= ChampsProvider.GetChamps;
end;

function Champs_from_sl( sl: TBatpro_StringList; I: Integer): TChamps;
var
   O: TObject;
begin
     O:= Object_from_sl( sl, I);
     Result:= Champs_from_Object( O);
end;

procedure Champs_Reset  ( Components: array of IChampsComponent);
var
   I: Integer;
   ChampsComponent: IChampsComponent;
begin
     for I:= Low( Components) to High( Components)
     do
       begin
       ChampsComponent:= Components[I];
       if not Assigned( ChampsComponent) then continue;

       ChampsComponent.Champs:= nil;
       end;
end;

procedure Champs_Affecte( Provider: TChampsProvider;
                          Components: array of IChampsComponent);
var
   I: Integer;
   Champs: TChamps;
   ChampsComponent: IChampsComponent;
begin
     if Provider = nil
     then
         Champs_Reset( Components)
     else
         begin
         Champs:= Provider.GetChamps;
         for I:= Low( Components) to High( Components)
         do
           begin
           ChampsComponent:= Components[I];
           if not Assigned( ChampsComponent) then continue;

           Components[I].Champs:= Champs;
           end;
         end;
end;

{ TChamps }

constructor TChamps.Create( _ClassName: String;
                            _q: TDataset;
                            _Save_to_database_Procedure: TSave_to_database_Procedure);
begin
     FChampDefinitions:= ChampDefinitions_from_ClassName( _ClassName);
     Fq:= _q;
     Save_to_database_Procedure:= _Save_to_database_Procedure;
     Fsl:= TslChamp.Create( ClassName+'.sl');
     cID:= nil;
     slAggreges:= TslChamp.Create( ClassName+'.slAggreges');
end;

destructor TChamps.Destroy;
   procedure Enleve_Aggreges;
   var
      O: TObject;
      iChamp: Integer;
   begin
        while slAggreges.Count > 0
        do
          begin
          O:= slAggreges.Objects[ 0];
          slAggreges.Delete( 0);

          iChamp:= sl.IndexOfObject( O);
          if iChamp = -1 then continue;

          sl.Delete( iChamp);
          end;
   end;
   procedure Detruit_champs;
   var
      O: TObject;
   begin
        while sl.Count > 0
        do
          begin
          O:= sl.Objects[ 0];
          sl.Delete( 0);
          if O = nil then continue;

          Free_nil( O);
          end;
   end;
begin
     Enleve_Aggreges;

     Detruit_champs;

     Free_nil( slAggreges);
     Free_nil( Fsl       );
     inherited;
end;

function TChamps.Ajoute( Memory: Pointer;
                         Field: String;
                         _FieldType: TFieldType;
                         Persistant:Boolean;
                         F: TField): TChamp;
var
   Definition: TChampDefinition;
begin
     if Assigned( ChampDefinitions)
     then
         begin
         Definition:= ChampDefinitions.Definition_from_Field( Field);
         if Definition = nil
         then
             Definition
             :=
               ChampDefinitions.Ajoute( Field, _FieldType, Persistant, F);
         end
     else
         Definition:= nil;

     Result:= TChamp.Create( Self, Definition, Memory, Save_to_database);
     sl.AddObject( Field, Result);
end;

{$IF DEFINED(MSWINDOWS) AND NOT DEFINED(FPC)}
function TChamps.Ajoute_dmf_Lookup( Memory    : Pointer;
                                    Field     : String;
                                    _FieldType: TFieldType;
                                    dmf       : Tdmf;
                                    _LookupKey: TChamp): TChamp;
var
   Definition: TChampDefinition;
begin
     Definition:= ChampDefinitions.Definition_from_Field( Field);
     if Definition = nil
     then
         Definition
         :=
           ChampDefinitions.Ajoute_Lookup( Field, _FieldType, _LookupKey.Definition);
     Result:= TChamp.Create_dmf_Lookup( Self, Definition, Memory, dmf, _LookupKey, Save_to_database);
     Result.LookupConnection:= TLookupConnection.Create( Self);
     sl.AddObject( Field, Result);
end;
{$IFEND}

function TChamps.Ajoute_Lookup( Memory               : Pointer;
                                Field                : String;
                                _FieldType           : TFieldType;
                                _LookupKey           : TChamp;
                                _OnGetLookupListItems: TOnGetLookupListItems;
                                _Valeur_courante     : String): TChamp;
var
   Definition: TChampDefinition;
begin
     Definition:= ChampDefinitions.Definition_from_Field( Field);
     if Definition = nil
     then
         Definition
         :=
           ChampDefinitions.Ajoute_Lookup( Field, _FieldType, _LookupKey.Definition);
     Result:= TChamp.Create_Lookup( Self, Definition, Memory,
                                    _LookupKey, _OnGetLookupListItems,
                                    _Valeur_courante, Save_to_database);
     Result.LookupConnection:= TLookupConnection.Create( Self);
     sl.AddObject( Field, Result);
end;

procedure TChamps.Erreur_Champ( Field, TypeField: String; var _Persistant: Boolean);
begin
     _Persistant:= False;//rajouté le 20/12/2012 pour gérer la table P_PLE
                         //sans champ idFormule

     exit;//rajouté provisoirement le 31/05/2006 pour pouvoir fonctionner
          //sur des bases avec la table G_FRS sans champ Couleur
     uForms_ShowMessage( 'Erreur à signaler au développeur:'+sys_N+
                  '  table: '+ChampDefinitions.NomTable+sys_N+
                  '  dataset: '+Dataset_Owner_Name( q)+'.'+q.Name+sys_N+
                  '  TChamps : le champ '+Field+
                  ' de type '+TypeField+' n''a pas été trouvé');
end;

function TChamps.ShortString_from_ ( var Memory: ShortString; Field: String;
                                     Persistant: Boolean): TChamp;
begin
     Result:= Ajoute_ShortString( Memory, Field, Persistant);
end;

function TChamps.String_from_String   (var Memory:String   ;Field:String;Persistant:Boolean): TChamp;
var
   F: TField;
   sf: TStringField;
begin
     if (q = nil) //cas ajouté pour gérer la création hors base de donnée
        or not q.Active
     then
         Result:= Ajoute_String( Memory, Field, Persistant)
     else
         begin
         F:= q.FindField( Field);

         if Affecte( sf, TStringField, F)
         then
             Memory:= TrimRight( sf.Value)
         else
             Erreur_Champ( Field, 'TStringField', Persistant);

         Result:= Ajoute( @Memory, Field, ftString, Persistant, F);
         end;
end;

function TChamps.String_from_Memo     (var Memory:String   ;Field:String;Persistant:Boolean): TChamp;
var
   F: TField;
   mf: TMemoField;
begin
     if (q = nil) //cas ajouté pour gérer la création hors base de donnée
        or not q.Active
     then
         Result:= Ajoute_String( Memory, Field, Persistant)
     else
         begin
         F:= q.FindField( Field);
         if Affecte( mf, TMemoField, F)
         then
             if mf.IsNull
             then
                 Memory:= ''
             else
                 Memory:= mf.Value
         else
             Erreur_Champ( Field, 'TMemoField', Persistant);

         Result:= Ajoute( @Memory, Field, ftMemo, Persistant, F);
         end;
end;

function TChamps.String_from_Blob(var Memory: String; Field: String; Persistant: Boolean): TChamp;
var
   F: TField;
   bf: TBlobField;
begin
     if (q = nil) //cas ajouté pour gérer la création hors base de donnée
        or not q.Active
     then
         Result:= Ajoute_String( Memory, Field, Persistant)
     else
         begin
         F:= q.FindField( Field);
         if Affecte( bf, TBlobField, F)
         then
             if bf.IsNull
             then
                 Memory:= ''
             else
                 Memory:= bf.Value
         else
             Erreur_Champ( Field, 'TBlobField', Persistant);

         Result:= Ajoute( @Memory, Field, ftBlob, Persistant, F);
         end;
end;

function TChamps.String_from_( var Memory: String; Field: String; Persistant: Boolean): TChamp;
var
   F: TField;
   Typ: TFieldType;
   bf: TBlobField;
   mf: TMemoField;
   sf: TStringField;
   procedure T( _Valeur: String; _FieldType: TFieldType);
   begin
        Memory:= TrimRight( _Valeur);
        Typ:= _FieldType;
   end;
   procedure T_bf;
   var
      S: String;
   begin
        if bf.IsNull
        then
            S:= ''
        else
            //2014/01/20 suite à pb sur la base ATE / SITA requêtes de R_REQUETE
            //requêteur sécurisé
            try
               S:= bf.Value;
            except
                  on E: Exception do S:= '';
                  end;
        T( S, ftBlob);
   end;
   procedure T_mf;
   var
      S: String;
   begin
        if mf.IsNull
        then
            S:= ''
        else
            S:= mf.Value;
        T( S, ftMemo);
   end;
begin
     if (q = nil) //cas ajouté pour gérer la création hors base de donnée
        or not q.Active
     then
         Result:= Ajoute_String( Memory, Field, Persistant)
     else
         begin
         F:= q.FindField( Field);
         if Assigned( F)
         then
             begin
                  if Affecte( bf, TBlobField  , F) then T_bf
             else if Affecte( mf, TMemoField  , F) then T_mf
             else if Affecte( sf, TStringField, F) then T( sf.Value, ftString)
             else Erreur_Champ( Field, 'TBlobField', Persistant);
             end
         else
             Erreur_Champ( Field, '<champ introuvable>', Persistant);

         Result:= Ajoute( @Memory, Field, Typ, Persistant, F);
         end;
end;

function TChamps.DateTime_from_Date   (var Memory:TDateTime;Field:String;Persistant:Boolean): TChamp;
var
   F: TField;
   df: TDateField;
begin
     if (q = nil) //cas ajouté pour gérer la création hors base de donnée
        or not q.Active
     then
         Result:= Ajoute_Date( Memory, Field, Persistant)
     else
         begin
         F:= q.FindField( Field);
         if Affecte( df, TDateField, F)
         then
             Memory:= df.Value
         else
             Erreur_Champ( Field, 'TDateField', Persistant);

         Result:= Ajoute( @Memory, Field, ftDate, Persistant, F);
         end;
end;

function TChamps.Integer_from_Integer (var Memory:Integer  ;Field:String;Persistant:Boolean): TChamp;
var
   F: TField;
   inf: TIntegerField;
begin
     if (q = nil) //cas ajouté pour gérer la création hors base de donnée
        or not q.Active
     then
         Result:= Ajoute_Integer( Memory, Field, Persistant)
     else
         begin
         F:= q.FindField( Field);
         if Affecte( inf, TIntegerField, F)
         then
             Memory:= inf.Value
         else
             Erreur_Champ( Field, 'TIntegerField', Persistant);

         Result:= Ajoute( @Memory, Field, ftInteger, Persistant, F);
         end;
end;

function TChamps.Integer_from_SmallInt(var Memory:Integer  ;Field:String;Persistant:Boolean): TChamp;
var
   F: TField;
   sif: TSmallIntField;
begin
     if (q = nil) //cas ajouté pour gérer la création hors base de donnée
        or not q.Active
     then
         Result:= Ajoute_SmallInt( Memory, Field, Persistant)
     else
         begin
         F:= q.FindField( Field);
         if Affecte( sif, TSmallIntField, F)
         then
             Memory:= sif.Value
         else
             Erreur_Champ( Field, 'TSmallIntField', Persistant);

         Result:= Ajoute( @Memory, Field, ftSmallint, Persistant, F);
         end;
end;

function TChamps.Integer_from_String( var Memory: Integer; Field: String; Persistant: Boolean): TChamp;
var
   F: TField;
   sf: TStringField;
   S: String;
begin
     if (q = nil) //cas ajouté pour gérer la création hors base de donnée
        or not q.Active
     then
         Result:= Ajoute_Integer( Memory, Field, Persistant)
     else
         begin
         F:= q.FindField( Field);
         if Affecte( sf, TStringField, F)
         then
             begin
             S:= sf.Value;
             if not TryStrToInt( S, Memory)
             then
                 Memory:= -1;
             end
         else
             Erreur_Champ( Field, 'TStringField', Persistant);

         Result:= Ajoute( @Memory, Field, ftInteger, Persistant, F);
         end;
end;

function TChamps.Integer_from_FMTBCD( var Memory: Integer; Field: String; Persistant: Boolean): TChamp;
var
   F: TField;
   fmtbdcf: TFMTBCDField;
begin
     if (q = nil) //cas ajouté pour gérer la création hors base de donnée
        or not q.Active
     then
         Result:= Ajoute_Integer( Memory, Field, Persistant)
     else
         begin
         F:= q.FindField( Field);
         if Affecte( fmtbdcf, TFMTBCDField, F)
         then
             Memory:= fmtbdcf.AsInteger
         else
             Erreur_Champ( Field, 'TFMTBCDField', Persistant);

         Result:= Ajoute( @Memory, Field, ftInteger, Persistant, F);
         end;
end;

function TChamps.Integer_from_( var Memory: Integer; Field: String; Persistant: Boolean): TChamp;
var
   F: TField;
   inf    : TIntegerField ;
   sif    : TSmallIntField;
   fmtbcdf: TFMTBCDField  ;
   sf     : TStringField  ;
   S: String;
begin
     if (q = nil) //cas ajouté pour gérer la création hors base de donnée
        or not q.Active
     then
         Result:= Ajoute_Integer( Memory, Field, Persistant)
     else
         begin
         F:= q.FindField( Field);
         if Assigned( F)
         then
                  if Affecte( inf    , TIntegerField , F) then Memory:= inf    .Value
             else if Affecte( sif    , TSmallIntField, F) then Memory:= sif    .Value
             else if Affecte( fmtbcdf, TFMTBCDField  , F) then Memory:= fmtbcdf.AsInteger
             else if Affecte( sf     , TStringField  , F)
             then
                 begin
                 S:= sf.Value;
                 if not TryStrToInt( S, Memory)
                 then
                     Memory:= -1;
                 end
             else
                 Erreur_Champ( Field, 'TIntegerField ou TSmallIntField ou TFMTBCDField ou TStringField', Persistant)
         else
             Erreur_Champ( Field, 'TIntegerField ou TSmallIntField ou TFMTBCDField ou TStringField', Persistant);

         Result:= Ajoute( @Memory, Field, ftInteger, Persistant, F);
         end;
end;

function TChamps.Integer_from_Double( var Memory: Integer; Field: String; Persistant: Boolean): TChamp;
var
   F: TField;
   inf    : TIntegerField ;
   sif    : TSmallIntField;
   ff     : TFloatField ;
   bcdf   : TBCDField   ;
   fmtbcdf: TFMTBCDField  ;
   sf     : TStringField  ;
   S: String;
begin
     if (q = nil) //cas ajouté pour gérer la création hors base de donnée
        or not q.Active
     then
         Result:= Ajoute_Integer( Memory, Field, Persistant)
     else
         begin
         F:= q.FindField( Field);
         if Assigned( F)
         then
                  if Affecte( inf    , TIntegerField , F) then Memory:= inf    .Value
             else if Affecte( sif    , TSmallIntField, F) then Memory:= sif    .Value
             else if Affecte( ff     , TFloatField   , F) then Memory:= Trunc( ff     .Value  )
             else if Affecte( bcdf   , TBCDField     , F) then Memory:= Trunc( bcdf   .Value  )
             else if Affecte( fmtbcdf, TFMTBCDField  , F) then Memory:= Trunc( fmtbcdf.asFloat)
             else if Affecte( sf     , TStringField  , F)
             then
                 begin
                 S:= sf.Value;
                 if not TryStrToInt( S, Memory)
                 then
                     Memory:= -1;
                 end
             else
                 Erreur_Champ( Field, 'TIntegerField ou TSmallIntField ou TFMTBCDField ou TStringField', Persistant)
         else
             Erreur_Champ( Field, 'TIntegerField ou TSmallIntField ou TFMTBCDField ou TStringField', Persistant);

         Result:= Ajoute( @Memory, Field, ftInteger, Persistant, F);
         end;
end;

function TChamps.Currency_from_BCD( var Memory:Currency ;Field:String;Persistant:Boolean): TChamp;
var
   F: TField;
   bcdf: TBCDField;
begin
     if (q = nil) //cas ajouté pour gérer la création hors base de donnée
        or not q.Active
     then
         Result:= Ajoute_BCD( Memory, Field, Persistant)
     else
         begin
         F:= q.FindField( Field);
         if Affecte( bcdf, TBCDField, F)
         then
             Memory:= bcdf.Value
         else
             Erreur_Champ( Field, 'TBCDField', Persistant);

         Result:= Ajoute( @Memory, Field, ftBCD, Persistant, F);
         end;
end;

function TChamps.DateTime_from_       (var Memory:TDateTime;Field:String;Persistant:Boolean): TChamp;
var
   F: TField;
   dtf: TDateTimeField;
   {$IF DEFINED(MSWINDOWS) AND NOT DEFINED(FPC)}
   sqltsf: TSQLTimeStampField;
   {$IFEND}
begin
     if (q = nil) //cas ajouté pour gérer la création hors base de donnée
        or not q.Active
     then
         Result:= Ajoute_DateTime( Memory, Field, Persistant)
     else
         begin
         F:= q.FindField( Field);
         if Assigned( F)
         then
                  if Affecte( dtf   , TDateTimeField    , F) then Memory:= dtf   .Value
             else
             {$IF DEFINED(MSWINDOWS) AND NOT DEFINED(FPC)}
                  if Affecte( sqltsf, TSQLTimeStampField, F) then Memory:= sqltsf.asDateTime
             else
             {$IFEND}
                 Erreur_Champ( Field, 'TDateTimeField ou TSQLTimeStampField', Persistant)
         else
             Erreur_Champ( Field, 'TDateTimeField ou TSQLTimeStampField', Persistant);

         Result:= Ajoute( @Memory, Field, F.DataType, Persistant, F);
         end;
end;

function TChamps.Double_from_         (var Memory:Double   ;Field:String;Persistant:Boolean): TChamp;
var
   F: TField;
   ff     : TFloatField ;
   bcdf   : TBCDField   ;
   fmtbcdf: TFMTBCDField;
begin
     if (q = nil) //cas ajouté pour gérer la création hors base de donnée
        or not q.Active
     then
         Result:= Ajoute_Float( Memory, Field, Persistant)
     else
         begin
         F:= q.FindField( Field);
         if Assigned( F)
         then
                  if Affecte( ff     , TFloatField , F) then Memory:= ff     .Value
             else if Affecte( bcdf   , TBCDField   , F) then Memory:= bcdf   .Value
             else if Affecte( fmtbcdf, TFMTBCDField, F) then Memory:= fmtbcdf.AsFloat
             else
                 Erreur_Champ( Field, 'TFloatField, TBCDField ou TFMTBCDField', Persistant)
         else
             Erreur_Champ( Field, 'TFloatField, TBCDField ou TFMTBCDField', Persistant);

         Result:= Ajoute( @Memory, Field, ftFloat, Persistant, F);
         end;
end;

function TChamps.Ajoute_ShortString(var Memory: ShortString; Field: String; Persistant: Boolean): TChamp;
begin
     Result:= Ajoute( @Memory, Field, ftFixedChar, Persistant, nil);
end;

function TChamps.Ajoute_String(var Memory: String; Field: String; Persistant: Boolean): TChamp;
begin
     Result:= Ajoute( @Memory, Field, ftString, Persistant, nil);
end;

function TChamps.Ajoute_Integer(var Memory: Integer; Field: String; Persistant: Boolean): TChamp;
begin
     Result:= Ajoute( @Memory, Field, ftInteger, Persistant, nil);
end;

function TChamps.Ajoute_SmallInt(var Memory: Integer; Field: String; Persistant: Boolean): TChamp;
begin
     Result:= Ajoute( @Memory, Field, ftSmallInt, Persistant, nil);
end;

function TChamps.Ajoute_DateTime(var Memory: TDatetime; Field: String; Persistant: Boolean): TChamp;
begin
     Result:= Ajoute( @Memory, Field, ftDateTime, Persistant, nil);
end;

function TChamps.Ajoute_Date(var Memory: TDatetime; Field: String; Persistant: Boolean): TChamp;
begin
     Result:= Ajoute( @Memory, Field, ftDate, Persistant, nil);
end;

function TChamps.Ajoute_BCD(var Memory: Currency; Field: String; Persistant: Boolean): TChamp;
begin
     Result:= Ajoute( @Memory, Field, ftBCD, Persistant, nil);
end;

function TChamps.Ajoute_Float(var Memory: Double; Field: String; Persistant: Boolean): TChamp;
begin
     Result:= Ajoute( @Memory, Field, ftFloat, Persistant, nil);
end;

function TChamps.Ajoute_Boolean(var Memory: Boolean; Field: String; Persistant: Boolean): TChamp;
begin
     Result:= Ajoute( @Memory, Field, ftBoolean, Persistant, nil);
end;

procedure TChamps.To_Params_Update( Params: TParams);
type
    PDateTime= ^TDateTime;
var
   I: Integer;
   Champ: TChamp;
   Definition: TChampDefinition;
   FieldName: String;
   Valeur: Pointer;
begin
     for I:= 0 to sl.Count-1
     do
       begin
       Champ:= Champ_from_sl( sl, I);
       if     Assigned( Champ)
          and (Champ.Owner = Self)
       then
           begin
           Definition:= Champ.Definition;
           if Definition.Persistant
           then
               begin
               FieldName:= Definition.Nom;
               Valeur:= Champ.Valeur;

               with Params.ParamByName( FieldName)
               do
                 case Definition.Typ
                 of
                   ftString   : AsString  := PString  ( Valeur)^;
                   ftMemo     : AsMemo    := PString  ( Valeur)^;
                   ftBlob     : AsBlob    := PString  ( Valeur)^;
                   ftDate     : AsDate    := PDateTime( Valeur)^;
                   ftInteger  : AsInteger := PInteger ( Valeur)^;
                   ftSmallint : AsSmallInt:= PInteger ( Valeur)^;
                   {$IF DEFINED(MSWINDOWS) AND NOT DEFINED(FPC)}
                   ftBCD      : AsBCD     := PCurrency( Valeur)^;
                   {$IFEND}
                   ftDateTime : AsDateTime:= PDateTime( Valeur)^;
                   {$IF DEFINED(MSWINDOWS) AND NOT DEFINED(FPC)}
                   ftTimeStamp: AsSQLTimeStamp
                    :=DateTimeToSQLTimeStamp(PDateTime( Valeur)^);
                   {$IFEND}
                   ftFloat    : AsFloat   := PDouble  ( Valeur)^;
                   end;
               end;
           end;
       end;
end;

procedure TChamps.To_Params_Insert(Params: TParams);
type
    PDateTime= ^TDateTime;
var
   I: Integer;
   Champ: TChamp;
   Definition: TChampDefinition;
   Valeur: Pointer;
begin
     for I:= 0 to sl.Count-1
     do
       begin
       Champ:= Champ_from_sl( sl, I);
       if     Assigned( Champ)
          and (Champ.Owner = Self)
       then
           begin
           Definition:= Champ.Definition;
           if Definition.Persistant
           then
               begin
               Valeur:= Champ.Valeur;
               with Params.ParamByName( Definition.Nom)
               do
                 case Definition.Typ
                 of
                   ftString   : AsString  := PString  ( Valeur)^;
                   ftMemo     : AsMemo    := PString  ( Valeur)^;
                   ftBlob     : AsBlob    := PString  ( Valeur)^;
                   ftDate     : AsDate    := PDateTime( Valeur)^;
                   ftInteger  : AsInteger := PInteger ( Valeur)^;
                   ftSmallint : AsSmallInt:= PInteger ( Valeur)^;
                   {$IF DEFINED(MSWINDOWS) AND NOT DEFINED(FPC)}
                   ftBCD      : AsBCD     := PCurrency( Valeur)^;
                   {$IFEND}
                   ftDateTime : AsDateTime:= PDateTime( Valeur)^;
                   {$IF DEFINED(MSWINDOWS) AND NOT DEFINED(FPC)}
                   ftTimeStamp: AsSQLTimeStamp
                    :=DateTimeToSQLTimeStamp(PDateTime( Valeur)^);
                   {$IFEND}
                   ftFloat    : AsFloat   := PDouble  ( Valeur)^;
                   end;
               end;
           end;
       end;
end;

procedure TChamps.To_Params_Delete(Params: TParams);
var
   Valeur: Pointer;
begin
     if Assigned( cID)
     then
         begin
         Valeur:= cID.Valeur;
         Params.ParamByName( 'id').AsInteger:= PInteger ( Valeur)^;
         end;
end;

function TChamps.Champ_from_Index(I: Integer): TChamp;
begin
     Result:= Champ_from_sl( sl, I);
end;

function TChamps.Field_from_Index( I: Integer): String;
begin
     Result:= sys_Vide;
     if (I < 0)or(sl.Count<= I) then exit;
     Result:= sl.Strings[I];
end;

function TChamps.Index_from_Field( Field: String): Integer;
begin
     Result:= sl.IndexOf( Field);
end;

function TChamps.Champ_from_Field( Field: String): TChamp;
begin
     Result:= Champ_from_Index( Index_from_Field( Field));
end;

procedure TChamps.SetChamp_from_Field( Field: String; const Value: TChamp);
var
   I: Integer;
begin
     I:= sl.IndexOf( Field);
     if I = -1
     then
         begin
         if Assigned( Value)
         then
             sl.AddObject( Field, Value);
         end
     else
         begin
         if Assigned( Value)
         then
             sl.Objects[ I]:= Value
         else
             sl.Delete( I);
         end;
end;

function TChamps.Count: Integer;
begin
     try
        Result:= sl.Count;
     except
           on Exception do Result:= 0;
           end;
end;

procedure TChamps.Save_to_database;
begin
     if     not Insertion
        and Assigned( Save_to_database_Procedure)
     then
         begin
         Save_to_database_Procedure;
         Modified:= False;
         end;
end;

{$IF DEFINED(MSWINDOWS) AND NOT DEFINED(FPC)}
function TChamps.String_dmf_Lookup( var Memory: String;
                                    Field: String;
                                    dmf: Tdmf;
                                    _LookupKey: TChamp
                                    ): TChamp;
begin
     Memory:= sys_Vide;
     Result:= Ajoute_dmf_Lookup( @Memory, Field, ftString, dmf, _LookupKey);
end;
{$IFEND}

function TChamps.String_Lookup( var Memory: String;
                                Field: String;
                                _LookupKey: TChamp;
                                _OnGetLookupListItems: TOnGetLookupListItems;
                                _Valeur_courante: String): TChamp;
begin
     Result:= Ajoute_Lookup( @Memory, Field, ftString, _LookupKey,
                             _OnGetLookupListItems, _Valeur_courante);
end;

procedure TChamps.Recharge( _q: TDataset);
var
   I: Integer;
   C: TChamp;
begin
     Fq:= _q;
     for I:= 0 to Count-1
     do
       begin
       C:= Champ_from_Index( I);
       if Assigned( C)
       then
           C.Recharge( _q);
       end;
     for I:= 0 to Count-1
     do
       begin
       C:= Champ_from_Index( I);
       if     Assigned( C)
          and C.Definition.Persistant
       then
           C.Publie_Modifications( False);
       end;
end;

function TChamps.Cree_Champ_ID( var Memory: Integer): TChamp;
begin
     if Fq <> nil
     then          // pour bien faire dans le cas nil il faudrait créer
                   // un champ non persistant avec une valeur 0
         begin
         cID:= Integer_from_Integer( Memory, 'id', True);
         end;
     Result:= cID;
end;

procedure TChamps.Serialise(S: TStream);
var
   nCount, I: Integer;
   C: TChamp;
begin
     nCount:= Count;
     for I:= 0 to nCount - 1
     do
       begin
       C:= Champ_from_Index( I);
       C.Serialise( S);
       end;
end;

procedure TChamps.DeSerialise(S: TStream);
var
   nCount, I: Integer;
   C: TChamp;
begin
     nCount:= Count;
     for I:= 0 to nCount - 1
     do
       begin
       C:= Champ_from_Index( I);
       C.DeSerialise( S);
       end;
end;

procedure TChamps.Liste;
var
   nCount, I: Integer;
   C: TChamp;
   NomChamp: String;
   S: String;
begin
     S:= 'Liste des champs';

     nCount:= Count;
     for I:= 0 to nCount - 1
     do
       begin
       C       := Champ_from_Index( I);
       NomChamp:= Field_from_Index( I);
       S:= S + #13#10;
       S:= S + Fixe_Min( NomChamp, 20)+'->'+Fixe_Min( C.Definition.Nom, 20)+'= >'+C.Chaine+'<';
       end;
     fAccueil_Erreur( S);
end;

function TChamps.Champ_from_Valeur(var _Valeur): TChamp;
begin
     sl.Iterateur_Start;
     try
        while not sl.Iterateur_EOF
        do
          begin
          sl.Iterateur_Suivant( Result);
          if Result = nil then continue;
          if Result.Valeur = Pointer( _Valeur)
          then
              break
          else
              Result:= nil;
          end;
     finally
            sl.Iterateur_Stop;
            end;
end;

function TChamps.GetJSON: String;
var
   nCount, I: Integer;
   C: TChamp;
   NomChamp: String;
begin
     //Result:= '{';
     Result:= '';

     nCount:= Count;
     for I:= 0 to nCount - 1
     do
       begin
       C       := Champ_from_Index( I);
       NomChamp:= Field_from_Index( I);
       if I > 0
       then
           Result:= Result + ',';
       //Result:= Result + #13#10;
       {$IFDEF FPC}
       Result:= Result + Format( '"%s":"%s"',[NomChamp, StringToJSONString(C.Chaine)]);
       {$ELSE}
       Result:= Result + Format( '"%s":"%s"',[NomChamp, C.Chaine]);
       {$ENDIF}
       end;
     //Result:= Result + #13#10;
     //Result:= Result+'}';
end;

{$IFDEF FPC}
procedure TChamps.SetJSON( _Value: String);
var
   jsp: TJSONParser;
   jso: TJSONObject;

   nCount, I: Integer;
   C: TChamp;
   Champ_Nom: String;
   Champ_Valeur: String;
begin
     jsp:= TJSONParser.Create( _Value);
     try
        uChamp_Publier_Modifications:= False;

        jso:= jsp.Parse as TJSONObject;

        nCount:= Count;
        for I:= 0 to nCount - 1
        do
          begin
          C        := Champ_from_Index( I);
          Champ_Nom:= Field_from_Index( I);

          Champ_Valeur:= jso.Elements[Champ_Nom].AsString;

          C.Chaine:= Champ_Valeur;
          end;
     finally
            uChamp_Publier_Modifications:= True;
            Free_nil( jsp);
            end;
     Save_to_database;
end;
{$ENDIF}

procedure TChamps.Aggrege_interne( _NomChamp: String; _C: TChamp);
begin
     Champ[ _NomChamp]:= _C;
     slAggreges.AddObject( _NomChamp, _C);
end;

procedure TChamps.DesAggrege_interne(_NomChamp: String);
var
   I: Integer;
begin
     I:= slAggreges.IndexOf( _NomChamp);
     if -1 = I then exit;

     Champ[ _NomChamp]:= nil;
     slAggreges.Delete( I);
end;

procedure TChamps.Aggrege( _NomChamp: String; _Champs: TChamps; _Champs_NomChamp: String);
var
   C: TChamp;
begin
     if _Champs_NomChamp = sys_Vide then _Champs_NomChamp:= _NomChamp;

     if _Champs = nil
     then
         C:= nil
     else
         C:= _Champs.Champ[ _Champs_NomChamp];

     Aggrege_interne( _NomChamp, C);
end;

procedure TChamps.DesAggrege( _NomChamp: String);
begin
     DesAggrege_interne( _NomChamp);
end;

procedure TChamps.AggregeChamps( _Prefixe: String; _Champs: TChamps);
var
   I: TIterateur_Champ;
   C: TChamp;
   NomChamp: String;
begin
     if _Champs = nil then exit;

     _Prefixe:= _Prefixe+'_';

     I:= _Champs.sl.Iterateur;
     while I.Continuer
     do
       begin
       if I.not_Suivant( C) then continue;

       NomChamp:= C.Definition.Nom;
       Aggrege_interne( _Prefixe+NomChamp, C);
       end;
end;

procedure TChamps.DesAggregeChamps( _Prefixe: String; _Champs: TChamps);
var
   I: TIterateur_Champ;
   C: TChamp;
   NomChamp: String;
begin
     if _Champs = nil then exit;

     _Prefixe:= _Prefixe+'_';

     I:= _Champs.sl.Iterateur;
     while I.Continuer
     do
       begin
       if I.not_Suivant( C) then continue;

       NomChamp:= C.Definition.Nom;
       DesAggrege_interne( _Prefixe+NomChamp);
       end;
end;

procedure TChamps.Modified_OR( _Modified: Boolean);
begin             //Pour ne pas mettre à False si l'on à déjà une modif en cours
     if _Modified
     then
         Modified:= True;
end;

procedure TChamps.Save_to_database_if_modified;
begin
     if Modified
     then
         Save_to_database;
end;

function TChamps.Refaire_Derniere_Modification: Boolean;
var
   c: TChamp;
begin
     Result:= False;

     c:= Champ_from_Field( Derniere_Modification.Champ_Nom);
     if c = nil then exit;

     c.Chaine:= Derniere_Modification.Champ_Valeur;
     Result:= True;
end;

procedure TChamps.SetReadOnly(const _Value: Boolean);
var
   I: TIterateur_Champ;
   C: TChamp;
begin
     I:= sl.Iterateur;
     while I.Continuer
     do
       begin
       if I.not_Suivant( C) then continue;

       C.ReadOnly:= _Value;
       end;
end;

function TChamps.GetValeur_from_Field( _Field: String): String;
var
   C: TChamp;
begin
     C:= Champ_from_Field( _Field);
     if C = nil
     then
         Result:= ''
     else
         Result:= C.Chaine;
end;

procedure TChamps.SetValeur_from_Field( _Field, _Value: String);
var
   C: TChamp;
begin
     C:= Champ_from_Field( _Field);
     if C = nil then exit;

     C.Chaine:= _Value;
end;

{ TLookupConnection }

constructor TLookupConnection.Create( _Maitre_Champs: TChamps);
begin
     inherited Create;
     Maitre_Champs:= _Maitre_Champs;
end;

destructor TLookupConnection.Destroy;
begin

     inherited;
end;

function TLookupConnection.Convient( blDetail: TChampsProvider): Boolean;
var
   Detail_Champs: TChamps;
   function Liens_convient: Boolean;
   var
      I: Integer;
      NomChamp_Detail, NomChamp_Maitre: String;
      cDetail, cMaitre: TChamp;
   begin
        Result:= True;
        for I:= 0 to slLiens.Count-1
        do
          begin
          NomChamp_Detail:= slLiens.Names         [ I];
          NomChamp_Maitre:= slLiens.ValueFromIndex[ I];

          cDetail:= Detail_Champs.Champ_from_Field( NomChamp_Detail);
          cMaitre:= Maitre_Champs.Champ_from_Field( NomChamp_Maitre);
          Result:= Result and Assigned( cDetail) and Assigned( cMaitre);
          if not Result then break;

          Result:= Result and (cDetail.Chaine = cMaitre.Chaine);
          if not Result then break;
          end;
   end;
   function Contraintes_convient: Boolean;
   var
      I: Integer;
      NomChamp_Detail, Valeur: String;
      cDetail: TChamp;
   begin
        Result:= True;
        for I:= 0 to slContraintes.Count-1
        do
          begin
          NomChamp_Detail:= slContraintes.Names         [ I];
          Valeur         := slContraintes.ValueFromIndex[ I];

          cDetail:= Detail_Champs.Champ_from_Field( NomChamp_Detail);
          Result:= Result and Assigned( cDetail);
          if not Result then break;

          Result:= Result and (cDetail.Chaine = Valeur);
          if not Result then break;
          end;
   end;

begin
     Result:= Assigned( blDetail);
     if not Result then exit;

     Detail_Champs:= blDetail.GetChamps;
     Result:= Liens_convient;
     if not Result then exit;

     Result:= Contraintes_convient;
end;

{ TChampsProvider }

function TChampsProvider.Champ_a_editer(Contexte: Integer): TChamp;
begin
     Result:= nil;
end;

function TChampsProvider.GetChamps: TChamps;
begin
     Result:= nil;
end;

function TChampsProvider.GetValeur_from_Field(_Field: String): String;
var
   Cs: TChamps;
begin
     Cs:= GetChamps;
     if Cs = nil
     then
         Result:= ''
     else
         Result:= Cs.Valeur_from_Field[ _Field];
end;

procedure TChampsProvider.SetValeur_from_Field(_Field, _Value: String);
var
   Cs: TChamps;
begin
     Cs:= GetChamps;
     if Cs = nil then exit;

     Cs.Valeur_from_Field[ _Field]:= _Value;
end;

function  Champs_GetValeur_from_Field( Provider: TChampsProvider; _Field: String): String;
begin
     if Provider = nil
     then
         Result:= ''
     else
         Result:= Provider.Valeur_from_Field[ _Field];
end;

procedure Champs_SetValeur_from_Field( Provider: TChampsProvider; _Field: String; _Value: String);
begin
     if Provider = nil then exit;
     Provider.Valeur_from_Field[ _Field]:= _Value;
end;

end.

