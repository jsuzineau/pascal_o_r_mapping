unit ublAutomatic;
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            partly as freelance: http://www.mars42.com                          |
        and partly as employee : http://www.batpro.com                          |
    Contact: gilles.doutre@batpro.com                                           |
                                                                                |
    Copyright 2014 Jean SUZINEAU - MARS42                                       |
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
    u_sys_,
    uBatpro_StringList,
    uEXE_INI,
    uSGBD,
    ujsDataContexte,
    uChampDefinition,
    uChamp,
    uChamps,
    uVide,
    uOD_Forms,
    uOD_JCL,
    uXMI,
    uOpenAPI,
    uuStrings,
    udmDatabase,

    uBatpro_Element,
    uBatpro_Ligne,
    ublPostgres_Foreign_Key,

    upoolPostgres_Foreign_Key,

    //Code generation
    uTemplateHandler,
    uTypeMapping,
    uEnumString,
    uGenerateur_de_code_Ancetre,
    uContexteClasse,
    uContexteMembre,
    uJoinPoint,

    //General
    ujpNom_de_la_table ,
    ujpNom_de_la_classe,
    ujpNomTableMinuscule,

    //SQL
    ujpSQL_CREATE_TABLE,
    ujpSQL_Order_By_Key,

    //Pascal
    ujpPascal_LabelsDFM,
    ujpPascal_LabelsPAS,
    ujpPascal_Champ_EditDFM,
    ujpPascal_Champ_EditPAS,
    ujpPascal_Affecte,
    ujpPascal_declaration_champs,
    ujpPascal_sCle_from__Declaration,
    ujpPascal_creation_champs,
    ujpPascal_sCle_from__Implementation,
    ujpPascal_sCle_Implementation_Body,
    ujpPascal_Declaration_cle,
    ujpPascal_Get_by_Cle_Declaration,
    ujpPascal_Test_Declaration_Key,
    ujpPascal_Get_by_Cle_Implementation,
    ujpPascal_To_SQLQuery_Params_Body,
    ujpPascal_SQLWHERE_ContraintesChamps_Body,
    ujpPascal_Test_Implementation_Key,
    ujpPascal_QfieldsDFM,
    ujpPascal_QfieldsPAS,
    ujpPascal_QCalcFieldsKey,
    ujpPascal_Traite_Index_key,
    ujpPascal_uses_ubl,
    ujpPascal_uses_upool,
    ujpPascal_Ouverture_key,
    ujpPascal_Test_Call_Key,
    ujpPascal_f_implementation_uses_key,
    ujpPascal_f_Execute_Before_Key,
    ujpPascal_f_Execute_After_Key,
    ujpPascal_Detail_declaration,
    ujpPascal_Detail_pool_get,
    ujpPascal_aggregation_declaration,
    ujpPascal_aggregation_accesseurs_implementation,
    ujpPascal_Assure_Declaration,
    ujpPascal_Assure_Implementation,

    //CSharp
    ujpCSharp_Champs_persistants,
    ujpCSharp_Contenus,
    ujpCSharp_Conteneurs,
    ujpCSharp_Chargement_Conteneurs,
    ujpCSharp_DocksDetails,
    ujpCSharp_DocksDetails_Affiche,

    //PHP
    ujpPHP_Doctrine_Has_Column,
    ujpPHP_Doctrine_HasMany,
    ujpPHP_Doctrine_HasOne,

    //Angular_TypeScript
    ujpAngular_TypeScript_NomFichierElement,
    ujpAngular_TypeScript_NomClasseElement,
    ujpAngular_TypeScript_declaration_champs,
    ujpAngular_TypeScript_html_editeurs_champs,

    ujpFile,
    uApplicationJoinPointFile,

    SysUtils, Classes, DB, Inifiles, FileUtil, DOM,LazUTF8;

type
 { TFieldBuffer }

 TFieldBuffer
 =
  class( TBatpro_Element)
  //Gestion du cycle de vie
  public
    constructor Create( _sl: TBatpro_StringList; _Champs: TChamps; _jsdcc: TjsDataContexte_Champ);
    destructor Destroy; override;
  //Attributs
  public
    Champs: TChamps;
    C: TChamp;
    jsdcc: TjsDataContexte_Champ;
  //Méthodes
  public
    procedure Traite; virtual;
  end;

 { TStringFieldBuffer }

 TStringFieldBuffer
 =
  class( TFieldBuffer)
    Value: String;
  //Méthodes
  public
    procedure Traite; override;
  end;

 { TIntegerFieldBuffer }

 TIntegerFieldBuffer
 =
  class( TFieldBuffer)
    Value: Integer;
  //Méthodes
  public
    procedure Traite; override;
  end;

 { TDateTimeFieldBuffer }

 TDateTimeFieldBuffer
 =
  class( TFieldBuffer)
    Value: TDateTime;
  //Méthodes
  public
    procedure Traite; override;
  end;

 { TDoubleFieldBuffer }

 TDoubleFieldBuffer
 =
  class( TFieldBuffer)
    Value: double;
  //Méthodes
  public
    procedure Traite; override;
  end;

 { TCurrencyFieldBuffer }

 TCurrencyFieldBuffer
 =
  class( TFieldBuffer)
    Value: Currency;
  //Méthodes
  public
    procedure Traite; override;
  end;

 { TBooleanFieldBuffer }

 TBooleanFieldBuffer
 =
  class( TFieldBuffer)
    Value: Boolean;
  //Méthodes
  public
    procedure Traite; override;
  end;

 TIterateur_FieldBuffer
 =
  class( TIterateur)
  //Iterateur
  public
    procedure Suivant( var _Resultat: TFieldBuffer);
    function  not_Suivant( var _Resultat: TFieldBuffer): Boolean;
  end;

 TslFieldBuffer
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
    function Iterateur: TIterateur_FieldBuffer;
    function Iterateur_Decroissant: TIterateur_FieldBuffer;
  end;

 { TblAutomatic }
 TblAutomatic
 =
  class( TBatpro_Ligne)
  //Gestion du cycle de vie
  public
    constructor Create( _sl: TBatpro_StringList; _jsdc: TjsDataContexte; _pool: Tpool_Ancetre_Ancetre); override;
    destructor Destroy; override;
  //Attributs
  public
    jsdc: TjsDataContexte;
    slFields: TslFieldBuffer;
  //Import des champs depuis un dataset
  public
    procedure Ajoute_Champs;
  //Génération de code
  public
    procedure Genere_code( _Suffixe: String);
  end;

 TIterateur_Automatic
 =
  class( TIterateur)
  //Iterateur
  public
    procedure Suivant( var _Resultat: TblAutomatic);
    function  not_Suivant( var _Resultat: TblAutomatic): Boolean;
  end;

 TslAutomatic
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
    function Iterateur: TIterateur_Automatic;
    function Iterateur_Decroissant: TIterateur_Automatic;
  end;

type
 { TGenerateur_de_code }

 TGenerateur_de_code
 =
  class(TGenerateur_de_code_Ancetre)
  //Gestion du cycle de vie
  public
    constructor Create;
    destructor Destroy; override;
  //INI
  private
    procedure _From_INI;
  //Divers
  private
    a: array of TJoinPoint;
    procedure Initialise( _a: array of TJoinPoint);
  public
    bl: TBatpro_Ligne;
    procedure Execute( _bl: TBatpro_Ligne; _Suffixe: String);
  //Gestion fichiers paramètre détail/symétric/aggregation
  private
    procedure Parametre_set( _NomFichier, _Name, _Value: String);
    procedure Parametre_Detail_set( _Classe, _Name, _Value: String);
    procedure Parametre_Symetric_set( _Classe, _Name, _Value: String);
    procedure Parametre_Aggregation_set( _Classe, _Name, _Value: String);
  //Génération par fichier XMI
  private
    procedure Execute_XMI_Classe( _xmi: TXMI; _eClasse: TDomNode; _NomClasse: String);
    procedure Execute_XMI_Classes( _xmi: TXMI);
    procedure Execute_XMI_Association( _xmi: TXMI; _eAssociation: TDOMNode);
    procedure Execute_XMI_Associations( _xmi: TXMI);
  public
    procedure Execute_XMI( _xmi: TXMI);
  //Génération par fichier OpenAPI
  private
    procedure Execute_OpenAPI_EnumString( _OpenAPI: TOpenAPI; _e: TEnum);
    procedure Execute_OpenAPI_Schema( _OpenAPI: TOpenAPI; _s: TSchema);
    procedure Execute_OpenAPI_Schemas( _OpenAPI: TOpenAPI);
  public
    procedure Execute_OpenAPI( _OpenAPI: TOpenAPI);
  //jpfMembre
  public
    sljpfMembre: TsljpfMembre;
    function  Cree_jpfMembre( _nfKey: String): TjpfMembre;
  //Création des jpfMembre par lecture du répertoire de listes de membres
  private
    procedure sljpfMembre_from_sRepertoireListeMembres_FileFound( _FileIterator: TFileIterator);
  public
    procedure sljpfMembre_from_sRepertoireListeMembres;
  //jpfEnumString
  public
    sljpfEnumString: TsljpfEnumString;
    function  Cree_jpfEnumString( _nfKey: String): TjpfEnumString;
  //Création des jpfEnumString par lecture du répertoire de listes de EnumStrings
  private
    procedure sljpfEnumString_from_sRepertoireListeEnumStrings_FileFound( _FileIterator: TFileIterator);
  public
    procedure sljpfEnumString_from_sRepertoireListeEnumStrings;
  //jpf08_EnumString
  public
    sljpf08_EnumString: Tsljpf08_EnumString;
    function  Cree_jpf08_EnumString( _nfKey: String): Tjpf08_EnumString;
  //Création des jpf08_EnumString par lecture du répertoire de listes de 08_EnumStrings
  private
    procedure sljpf08_EnumString_from_sRepertoireListe08_EnumStrings_FileFound( _FileIterator: TFileIterator);
  public
    procedure sljpf08_EnumString_from_sRepertoireListe08_EnumStrings;
  //jpfDetail
  public
    sljpfDetail: TsljpfDetail;
    function  Cree_jpfDetail( _nfKey: String): TjpfDetail;
  //Création des jpfDetail par lecture du répertoire de listes de Details
  private
    procedure sljpfDetail_from_sRepertoireListeDetails_FileFound( _FileIterator: TFileIterator);
  public
    procedure sljpfDetail_from_sRepertoireListeDetails;
  //jpfSymetric
  public
    sljpfSymetric: TsljpfSymetric;
    function  Cree_jpfSymetric( _nfKey: String): TjpfSymetric;
  //Création des jpfSymetric par lecture du répertoire de listes de Symetrics
  private
    procedure sljpfSymetric_from_sRepertoireListeSymetrics_FileFound( _FileIterator: TFileIterator);
  public
    procedure sljpfSymetric_from_sRepertoireListeSymetrics;
  //jpfAggregation
  public
    sljpfAggregation: TsljpfAggregation;
    function  Cree_jpfAggregation( _nfKey: String): TjpfAggregation;
  //Création des jpfAggregation par lecture du répertoire de listes de Aggregations
  private
    procedure sljpfAggregation_from_sRepertoireListeAggregations_FileFound( _FileIterator: TFileIterator);
  public
    procedure sljpfAggregation_from_sRepertoireListeAggregations;
  //jpfLibelle
  public
    sljpfLibelle: TsljpfLibelle;
    function  Cree_jpfLibelle( _nfKey: String): TjpfLibelle;
  //Création des jpfLibelle par lecture du répertoire de listes de Libelles
  private
    procedure sljpfLibelle_from_sRepertoireListeLibelles_FileFound( _FileIterator: TFileIterator);
  public
    procedure sljpfLibelle_from_sRepertoireListeLibelles;
  //ApplicationJoinPointFile
  public
    slApplicationJoinPointFile: TslApplicationJoinPointFile;
    function  Cree_ApplicationJoinPointFile( _nfKey: String): TApplicationJoinPointFile;
  //Création des ApplicationJoinPointFile par lecture du répertoire de listes de tables
  private
    procedure slApplicationJoinPointFile_from_sRepertoireListeTables_FileFound( _FileIterator: TFileIterator);
  public
    procedure slApplicationJoinPointFile_from_sRepertoireListeTables;
    procedure slApplicationJoinPointFile_Produit;
  //ApplicationEnumJoinPointFile
  public
    slApplicationEnumJoinPointFile: TslApplicationEnumJoinPointFile;
    function  Cree_ApplicationEnumJoinPointFile( _nfKey: String): TApplicationEnumJoinPointFile;
  //Création des ApplicationEnumJoinPointFile par lecture du répertoire de listes de tables
  private
    procedure slApplicationEnumJoinPointFile_from_sRepertoireListeEnum_FileFound( _FileIterator: TFileIterator);
  public
    procedure slApplicationEnumJoinPointFile_from_sRepertoireListeEnum;
    procedure slApplicationEnumJoinPointFile_Produit;
  //EnumStrings
  public
    function Cree_EnumStrings( _nfEnumString: String): TEnumString;
  //Création des EnumStrings par lecture du répertoire de EnumStrings
  private
    procedure slEnumStrings_from_sRepertoireEnumStrings_FileFound( _FileIterator: TFileIterator);
  public
    procedure slEnumStrings_from_sRepertoireEnumStrings;
  //TypeMappings
  public
    function Cree_TypeMappings( _nfTypeMapping: String): TTypeMapping;
  //Création des TypeMappings par lecture du répertoire de TypeMappings
  private
    procedure slTypeMappings_from_sRepertoireTypeMappings_FileFound( _FileIterator: TFileIterator);
  public
    procedure slTypeMappings_from_sRepertoireTypeMappings;
  //TemplateHandler
  public
    slTemplateHandler: TslTemplateHandler;
    procedure Cree_TemplateHandler( var _Reference;
                                   _Source: String;
                                   _slParametres: TBatpro_StringList= nil); override; overload;
    function  Cree_TemplateHandler( _Source: String;
                                   _slParametres: TBatpro_StringList= nil): TTemplateHandler; overload;

  //Création des TemplateHandler par lecture du répertoire de modèles
  private
    procedure slTemplateHandler_from_sRepertoireTemplate_FileFound( _FileIterator: TFileIterator);
  public
    procedure slTemplateHandler_from_sRepertoireTemplate;
    procedure slTemplateHandler_Produit;
  //Paramètres
  private
    slParametres: TBatpro_StringList;
  //ApplicationTemplateHandler
  public
    slApplicationTemplateHandler: TslTemplateHandler;
    function  Cree_ApplicationTemplateHandler( _Source: String; _slParametres: TBatpro_StringList= nil): TTemplateHandler;
  //Création des TemplateHandler par lecture du répertoire de modèles
  private
    procedure slApplicationTemplateHandler_from_sRepertoireApplicationTemplate_FileFound( _FileIterator: TFileIterator);
  public
    procedure slApplicationTemplateHandler_from_sRepertoireApplicationTemplate;
    procedure slApplicationTemplateHandler_Produit;

  //Gestion de la génération au niveau global de l'application (basés sur liste des tables)
  public
    Application_Created: Boolean;
  private
    procedure Application_Create;
  public
    procedure Application_Produit;
    procedure Application_Destroy;
  //Alimentation des Parametres d'aprés les contraintes PostgreSQL
  public
    procedure Parametres_from_Postgres_Foreign_Key( _slNomTables: TStringList);
  end;

function Generateur_de_code: TGenerateur_de_code;

implementation

{ TIterateur_FieldBuffer }

function TIterateur_FieldBuffer.not_Suivant( var _Resultat: TFieldBuffer): Boolean;
begin
     Result:= not_Suivant_interne( _Resultat);
end;

procedure TIterateur_FieldBuffer.Suivant( var _Resultat: TFieldBuffer);
begin
     Suivant_interne( _Resultat);
end;

{ TslFieldBuffer }

constructor TslFieldBuffer.Create( _Nom: String= '');
begin
     inherited CreateE( _Nom, TFieldBuffer);
end;

destructor TslFieldBuffer.Destroy;
begin
     inherited;
end;

class function TslFieldBuffer.Classe_Iterateur: TIterateur_Class;
begin
     Result:= TIterateur_FieldBuffer;
end;

function TslFieldBuffer.Iterateur: TIterateur_FieldBuffer;
begin
     Result:= TIterateur_FieldBuffer( Iterateur_interne);
end;

function TslFieldBuffer.Iterateur_Decroissant: TIterateur_FieldBuffer;
begin
     Result:= TIterateur_FieldBuffer( Iterateur_interne_Decroissant);
end;

{ TFieldBuffer }

constructor TFieldBuffer.Create( _sl: TBatpro_StringList;
                                 _Champs: TChamps;
                                 _jsdcc: TjsDataContexte_Champ);
begin
     inherited Create( _sl);
     Champs:= _Champs;
     jsdcc:= _jsdcc;
     C:= nil;
     Traite;
end;

destructor TFieldBuffer.Destroy;
begin
     inherited Destroy;
end;

procedure TFieldBuffer.Traite;
begin

end;

{ TStringFieldBuffer }

procedure TStringFieldBuffer.Traite;
begin
     inherited Traite;
     C:= Champs.String_from_( Value, jsdcc.Nom);
end;

{ TIntegerFieldBuffer }

procedure TIntegerFieldBuffer.Traite;
begin
     inherited Traite;
     C:= Champs.Integer_from_( Value, jsdcc.Nom);
end;

{ TDateTimeFieldBuffer }

procedure TDateTimeFieldBuffer.Traite;
begin
     inherited Traite;
     C:= Champs.DateTime_from_( Value, jsdcc.Nom);
end;

{ TDoubleFieldBuffer }

procedure TDoubleFieldBuffer.Traite;
begin
     inherited Traite;
     C:= Champs.Double_from_( Value, jsdcc.Nom);
end;

{ TCurrencyFieldBuffer }

procedure TCurrencyFieldBuffer.Traite;
begin
     inherited Traite;
     C:= Champs.Currency_from_( Value, jsdcc.Nom);
end;

{ TBooleanFieldBuffer }

procedure TBooleanFieldBuffer.Traite;
begin
     inherited Traite;
     C:= Champs.Boolean_from_( Value, jsdcc.Nom);
end;

{ TIterateur_Automatic }

function TIterateur_Automatic.not_Suivant( var _Resultat: TblAutomatic): Boolean;
begin
     Result:= not_Suivant_interne( _Resultat);
end;

procedure TIterateur_Automatic.Suivant( var _Resultat: TblAutomatic);
begin
     Suivant_interne( _Resultat);
end;

{ TslAutomatic }

constructor TslAutomatic.Create( _Nom: String= '');
begin
     inherited CreateE( _Nom, TblAutomatic);
end;

destructor TslAutomatic.Destroy;
begin
     inherited;
end;

class function TslAutomatic.Classe_Iterateur: TIterateur_Class;
begin
     Result:= TIterateur_Automatic;
end;

function TslAutomatic.Iterateur: TIterateur_Automatic;
begin
     Result:= TIterateur_Automatic( Iterateur_interne);
end;

function TslAutomatic.Iterateur_Decroissant: TIterateur_Automatic;
begin
     Result:= TIterateur_Automatic( Iterateur_interne_Decroissant);
end;

{ TblAutomatic }

constructor TblAutomatic.Create( _sl: TBatpro_StringList;
                                 _jsdc: TjsDataContexte;
                                 _pool: Tpool_Ancetre_Ancetre);
var
   CP: IblG_BECP;
begin
     CP:= Init_ClassParams;
     if Assigned( CP)
     then
         begin
         CP.Libelle:= 'Automatic';
         CP.Font.Name:= sys_Times_New_Roman;
         CP.Font.Size:= 12;
         end;

     inherited Create(_sl, _jsdc, _pool);

     jsdc:= _jsdc;
     slFields:= TslFieldBuffer.Create( ClassName+'.slFields');
     Ajoute_Champs;
end;

destructor TblAutomatic.Destroy;
begin
     Vide_StringList( slFields);
     Free_nil( slFields);
     inherited Destroy;
end;

procedure TblAutomatic.Ajoute_Champs;
var
   I: TIterateur_jsDataContexte_Champ;
   jsdcc: TjsDataContexte_Champ;
   F: TField;
   fb: TFieldBuffer;
begin
     jsdc.Charge_Champs;
     I:= jsdc.Champs.Iterateur;
     while I.Continuer
     do
       begin
       if I.not_Suivant( jsdcc) then continue;
       if     ('id'      = jsdcc.Nom)
          and (
                 (ftInteger = jsdcc.Info.FieldType)
              or (ftAutoInc = jsdcc.Info.FieldType)
              )
       then
           continue;

       case jsdcc.Info.FieldType
       of
         ftFixedChar,
         ftString   ,
         ftMemo     ,
         ftGuid     ,
         ftBlob     : fb:= TStringFieldBuffer  .Create( sl, Champs, jsdcc);
         ftDate     : fb:= TDateTimeFieldBuffer.Create( sl, Champs, jsdcc);
         ftAutoInc  ,
         ftInteger  ,
         ftSmallint : fb:= TIntegerFieldBuffer .Create( sl, Champs, jsdcc);
         ftBCD      : fb:= TDoubleFieldBuffer  .Create( sl, Champs, jsdcc);
         ftDateTime ,
         ftTimeStamp: fb:= TDateTimeFieldBuffer.Create( sl, Champs, jsdcc);
         ftFloat    : fb:= TDoubleFieldBuffer  .Create( sl, Champs, jsdcc);
         ftCurrency : fb:= TCurrencyFieldBuffer.Create( sl, Champs, jsdcc);
         ftBoolean  : fb:= TBooleanFieldBuffer .Create( sl, Champs, jsdcc);
         else         fb:= nil;
         end;
       if fb = nil then continue;

       slFields.AddObject( fb.sCle, fb);
       end;
end;

procedure TblAutomatic.Genere_code( _Suffixe: String);
begin
     Generateur_de_code.Execute( Self, _Suffixe);
end;

{ TGenerateur_de_code }

var
   FGenerateur_de_code: TGenerateur_de_code= nil;

function Generateur_de_code: TGenerateur_de_code;
begin
     if nil = FGenerateur_de_code
     then
         FGenerateur_de_code:= TGenerateur_de_code.Create;
     Result:= FGenerateur_de_code;
end;

constructor TGenerateur_de_code.Create;
begin
     inherited Create;
     _From_INI;
     sljpfMembre                   := TsljpfMembre                   .Create( ClassName+'.sljpfMembre'                   );
     sljpfEnumString               := TsljpfEnumString               .Create( ClassName+'.sljpfEnumString'               );
     sljpf08_EnumString            := Tsljpf08_EnumString            .Create( ClassName+'.sljpf08_EnumString'            );
     sljpfDetail                   := TsljpfDetail                   .Create( ClassName+'.sljpfDetail'                   );
     sljpfSymetric                 := TsljpfSymetric                 .Create( ClassName+'.sljpfSymetric'                 );
     sljpfAggregation              := TsljpfAggregation              .Create( ClassName+'.sljpfAggregation'              );
     sljpfLibelle                  := TsljpfLibelle                  .Create( ClassName+'.sljpfLibelle'                  );
     slApplicationJoinPointFile    := TslApplicationJoinPointFile    .Create( ClassName+'.slApplicationJoinPointFile'    );
     slApplicationEnumJoinPointFile:= TslApplicationEnumJoinPointFile.Create( ClassName+'.slApplicationEnumJoinPointFile');
     slEnumStrings                 := TslEnumString                  .Create( ClassName+'.slEnumStrings'                 );
     slTypeMappings                := TslTypeMapping                 .Create( ClassName+'.slTypeMappings'                );
     slTemplateHandler             := TslTemplateHandler             .Create( ClassName+'.slTemplateHandler'             );
     slParametres                  := TBatpro_StringList             .Create;
     slApplicationTemplateHandler  := TslTemplateHandler             .Create( ClassName+'.slApplicationTemplateHandler'  );
     Initialise(
                [
                //General
                jpNom_de_la_table,
                jpNomTableMinuscule,
                jpNom_de_la_classe    ,

                //SQL
                jpSQL_CREATE_TABLE,
                jpSQL_Order_By_Key,

                //Pascal
                jpPascal_LabelsDFM,
                jpPascal_LabelsPAS,
                jpPascal_Champ_EditDFM,
                jpPascal_Champ_EditPAS,
                jpPascal_Affecte      ,
                jpPascal_declaration_champs,
                jpPascal_sCle_from__Declaration,
                jpPascal_creation_champs,
                jpPascal_sCle_from__Implementation,
                jpPascal_sCle_Implementation_Body,
                jpPascal_Declaration_cle,
                jpPascal_Get_by_Cle_Declaration,
                jpPascal_Test_Declaration_Key,
                jpPascal_Get_by_Cle_Implementation,
                jpPascal_To_SQLQuery_Params_Body,
                jpPascal_SQLWHERE_ContraintesChamps_Body,
                jpPascal_Test_Implementation_Key,
                jpPascal_QfieldsDFM,
                jpPascal_QfieldsPAS,
                jpPascal_QCalcFieldsKey,
                jpPascal_Traite_Index_key,
                jpPascal_uses_ubl,
                jpPascal_uses_upool,
                jpPascal_Ouverture_key,
                jpPascal_Test_Call_Key,
                jpPascal_f_implementation_uses_key,
                jpPascal_f_Execute_Before_Key,
                jpPascal_f_Execute_After_Key,
                jpPascal_Detail_declaration,
                jpPascal_aggregation_declaration,
                jpPascal_aggregation_accesseurs_implementation,
                jpPascal_Assure_Declaration,
                jpPascal_Assure_Implementation,

                //CSharp
                jpCSharp_Champs_persistants   ,
                jpCSharp_Contenus             ,
                jpCSharp_Conteneurs           ,
                jpCSharp_DocksDetails         ,
                jpCSharp_DocksDetails_Affiche ,
                jpCSharp_Chargement_Conteneurs,

                //PHP / Doctrine
                jpPHP_Doctrine_Has_Column,
                jpPHP_Doctrine_HasMany,
                jpPHP_Doctrine_HasOne,

                //Angular_TypeScript
                jpAngular_TypeScript_NomFichierElement,
                jpAngular_TypeScript_NomClasseElement,
                jpAngular_TypeScript_declaration_champs,
                jpAngular_TypeScript_html_editeurs_champs
                ]
                );
     Application_Created:= False;
end;

destructor TGenerateur_de_code.Destroy;
begin
     FreeAndNil( sljpfMembre);
     FreeAndNil( sljpfEnumString);
     FreeAndNil( sljpf08_EnumString);
     FreeAndNil( sljpfDetail);
     FreeAndNil( sljpfSymetric);
     FreeAndNil( sljpfAggregation);
     FreeAndNil( sljpfLibelle    );
     FreeAndNil( slApplicationJoinPointFile);
     FreeAndNil( slApplicationEnumJoinPointFile);
     FreeAndNil( slEnumStrings);
     FreeAndNil( slTypeMappings);
     FreeAndNil( slTemplateHandler);
     FreeAndNil( slParametres);
     FreeAndNil( slApplicationTemplateHandler);
     inherited Destroy;
end;

procedure TGenerateur_de_code._From_INI;
var
   NomFichierProjet: String;
   Path: String;
   INI: TIniFile;
   function iRead( _Key, _DefaultValue: String): String;
   begin
        Result:= INI.ReadString( 'Options', _Key, _DefaultValue);
        ForceDirectories( Result);
        INI.WriteString( 'Options', _Key, Result);
   end;
begin
     NomFichierProjet:= uOD_Forms_EXE_Name;
     Path:= ExtractFilePath(NomFichierProjet)+'Generateur_de_code'+PathDelim;
     INI:= TIniFile.Create( ChangeFileExt(EXE_INI.FileName,'_Generateur_de_code.ini'));
     try
        sRepertoireListeTables        :=iRead('sRepertoireListeTables'        ,Path+'01_Listes'             +PathDelim+'Tables'        +PathDelim);
        sRepertoireListeEnum          :=iRead('sRepertoireListeEnum'          ,Path+'01_Listes'             +PathDelim+'Enums'         +PathDelim);
        sRepertoireListeMembres       :=iRead('sRepertoireListeMembres'       ,Path+'01_Listes'             +PathDelim+'Membres'       +PathDelim);
        sRepertoireListeEnumStrings   :=iRead('sRepertoireListeEnumStrings'   ,Path+'01_Listes'             +PathDelim+'EnumStrings'   +PathDelim);
        sRepertoireListe08_EnumStrings:=iRead('sRepertoireListe08_EnumStrings',Path+'01_Listes'             +PathDelim+'08_EnumStrings'+PathDelim);
        sRepertoireListeDetails       :=iRead('sRepertoireListeDetails'       ,Path+'01_Listes'             +PathDelim+'Details'       +PathDelim);
        sRepertoireListeSymetrics     :=iRead('sRepertoireListeSymetrics'     ,Path+'01_Listes'             +PathDelim+'Symetrics'     +PathDelim);
        sRepertoireListeAggregations  :=iRead('sRepertoireListeAggregations'  ,Path+'01_Listes'             +PathDelim+'Aggregations'  +PathDelim);
        sRepertoireListeLibelles      :=iRead('sRepertoireListeLibelles'      ,Path+'01_Listes'             +PathDelim+'Libelles'      +PathDelim);
        sRepertoireTemplate           :=iRead('sRepertoireTemplate'           ,Path+'03_Template'           +PathDelim                           );
        sRepertoireParametres         :=iRead('sRepertoireParametres'         ,Path+'04_Parametres'         +PathDelim                           );
        sRepertoireApplicationTemplate:=iRead('sApplicationTemplate'          ,Path+'05_ApplicationTemplate'+PathDelim                           );
        sRepertoireResultat           :=iRead('sRepertoireResultat'           ,Path+'06_Resultat'           +PathDelim                           );
        sRepertoireTypeMappings       :=iRead('sRepertoireTypeMappings'       ,Path+'07_TypeMappings'       +PathDelim                           );
        sRepertoireEnumStrings        :=iRead('sRepertoireEnumStrings'        ,Path+'08_EnumStrings'        +PathDelim                           );
     finally
            FreeAndNil( INI);
            end;
end;

procedure TGenerateur_de_code.Execute( _bl: TBatpro_Ligne; _Suffixe: String);
var
   cc: TContexteClasse;

   {
   phPAS_DMCRE,
   phPAS_POOL ,
   phPAS_F    ,
   phPAS_FCB  ,
   phPAS_DKD  ,

   phDFM_DMCRE,
   phDFM_F    ,
   phDFM_FCB  ,
   phDFM_DKD  ,

   phDFM_FD   ,
   phPAS_FD   ,

   phPAS_BL   ,
   phPAS_HF   ,
   phPAS_TC   ,
   phDPK       : TTemplateHandler;

   phCS_ML     : TTemplateHandler;

   phPHP_Doctrine_record: TTemplateHandler;
   phPHP_Doctrine_table : TTemplateHandler;

   phPHP_Perso_c     : TTemplateHandler;
   phPHP_Perso_Delete: TTemplateHandler;
   phPHP_Perso_Insert: TTemplateHandler;
   phPHP_Perso_Set: TTemplateHandler;
   }

   {
   procedure CreeTemplateHandler( out phPAS, phDFM: TTemplateHandler; Racine: String);
   var
      sRepertoireRacine: String;
   begin
        sRepertoireRacine:= s_RepertoirePascal_paquet+'u'+Racine+s_Nom_de_la_classe;
        phPAS:= Cree_TemplateHandler(  sRepertoireRacine+'.pas',slParametres);
        phDFM:= Cree_TemplateHandler(  sRepertoireRacine+'.dfm',slParametres);
   end;

   procedure CreeTemplateHandler_pool( out phPAS: TTemplateHandler);
   var
      sRepertoireRacine: String;
   begin
        sRepertoireRacine:= s_RepertoirePascal_paquet+'upool'+s_Nom_de_la_classe;
        phPAS:= Cree_TemplateHandler(  sRepertoireRacine+'.pas',slParametres);
   end;

   procedure CreeTemplateHandler_BL( out phPAS: TTemplateHandler);
   var
      sRepertoireRacine: String;
   begin
        sRepertoireRacine:= s_RepertoirePascal_paquet+'ubl'+s_Nom_de_la_classe;
        phPAS:= Cree_TemplateHandler(  sRepertoireRacine+'.pas',slParametres);
   end;

   procedure CreeTemplateHandler_HF( out phPAS: TTemplateHandler);
   var
      sRepertoireRacine: String;
   begin
        sRepertoireRacine:= s_RepertoirePascal_paquet+'uhf'+s_Nom_de_la_classe;
        phPAS:= Cree_TemplateHandler(  sRepertoireRacine+'.pas',slParametres);
   end;

   procedure CreeTemplateHandler_TC( out phPAS: TTemplateHandler);
   var
      sRepertoireRacine: String;
   begin
        sRepertoireRacine:= s_RepertoirePascal_dunit+'utc'+s_Nom_de_la_classe;
        phPAS:= Cree_TemplateHandler(  sRepertoireRacine+'.pas',slParametres);
   end;

   procedure CreeTemplateHandler_DPK( out phDPK: TTemplateHandler);
   var
      sRepertoireRacine: String;
   begin
        sRepertoireRacine:= s_RepertoirePascal_paquet+'p'+s_Nom_de_la_classe;
        phDPK:= Cree_TemplateHandler(  sRepertoireRacine+'.dpk',slParametres);
   end;

   procedure CreeTemplateHandler_ML( out phCS: TTemplateHandler);
   var
      sRepertoireRacine: String;
   begin
        sRepertoireRacine:= s_RepertoireCSharp+'Tml'+s_Nom_de_la_table;
        phCS:= Cree_TemplateHandler(  sRepertoireRacine+'.CS',slParametres);
   end;

   procedure CreeTemplateHandler_PHP_Doctrine( out phRecord, phTable: TTemplateHandler);
   begin
        phRecord:= Cree_TemplateHandler(  s_RepertoirePHP_Doctrine+    s_Nom_de_la_table+'.class.php',slParametres);
        phTable := Cree_TemplateHandler(  s_RepertoirePHP_Doctrine+'t'+s_Nom_de_la_table+'.class.php',slParametres);
   end;

   procedure CreeTemplateHandler_PHP_Perso( out phPHP_Perso_c, phPHP_Perso_Delete, phPHP_Perso_Insert, phPHP_Perso_Set: TTemplateHandler);
   begin
        phPHP_Perso_c     := Cree_TemplateHandler(  s_RepertoirePHP_Perso+'cpool'+s_Nom_de_la_table+       '.php',slParametres);
        phPHP_Perso_Delete:= Cree_TemplateHandler(  s_RepertoirePHP_Perso+        s_Nom_de_la_table+'_Delete.php',slParametres);
        phPHP_Perso_Insert:= Cree_TemplateHandler(  s_RepertoirePHP_Perso+        s_Nom_de_la_table+'_Insert.php',slParametres);
        phPHP_Perso_Set   := Cree_TemplateHandler(  s_RepertoirePHP_Perso+        s_Nom_de_la_table+   '_Set.php',slParametres);
   end;
   }
   {
   procedure Produit;
   begin
        phPAS_DMCRE.Produit;
        phPAS_POOL .Produit;
        phPAS_F    .Produit;
        phPAS_FCB  .Produit;
        phPAS_DKD  .Produit;

        phDFM_DMCRE.Produit;
        phDFM_F    .Produit;
        phDFM_FCB  .Produit;
        phDFM_DKD  .Produit;

        phDFM_FD   .Produit;
        phPAS_FD   .Produit;

        phPAS_BL   .Produit;
        phPAS_HF   .Produit;
        phPAS_TC   .Produit;
        phDPK      .Produit;

        phCS_ML    .Produit;

        phPHP_Doctrine_record.Produit;
        phPHP_Doctrine_table .Produit;

        phPHP_Perso_c     .Produit;
        phPHP_Perso_Delete.Produit;
        phPHP_Perso_Insert.Produit;
        phPHP_Perso_Set   .Produit;
   end;
   }
   procedure Traite_Champ( _C: TChamp);
   var
      d: TChampDefinition;
      sNomChamp: String;
      cm: TContexteMembre;
   begin
        d:= _C.Definition;
        if not d.Persistant then exit;//pour éviter le champ Selected

        sNomChamp:= d.Nom;
        if 'id' = LowerCase( sNomChamp) then exit;

        cm:= TContexteMembre.Create( Self, cc, sNomChamp, d.sType, '');
        //cm:= TContexteMembre.Create( cc, _fb.jsdcc.Nom, _fb.sType, '');
        try
                 uJoinPoint_VisiteMembre( cm, a);
           sljpfMembre     .VisiteMembre( cm);
           sljpfEnumString .VisiteMembre( cm);
           sljpfDetail     .VisiteMembre( cm);
           sljpfSymetric   .VisiteMembre( cm);
           sljpfAggregation.VisiteMembre( cm);
           sljpfLibelle    .VisiteMembre( cm);
        finally
               FreeAndNil( cm);
               end;
   end;
   procedure Traite_EnumString( s_EnumString, sNomTableMembre: String);
   begin
        if '' = s_EnumString then exit;
        if '' = sNomTableMembre then sNomTableMembre:= s_EnumString;
              uJoinPoint_VisiteEnumString( s_EnumString, sNomTableMembre, a);
        sljpfMembre     .VisiteEnumString( s_EnumString, sNomTableMembre);
        sljpfEnumString .VisiteEnumString( s_EnumString, sNomTableMembre);
        sljpfDetail     .VisiteEnumString( s_EnumString, sNomTableMembre);
        sljpfSymetric   .VisiteEnumString( s_EnumString, sNomTableMembre);
        sljpfAggregation.VisiteEnumString( s_EnumString, sNomTableMembre);
        sljpfLibelle    .VisiteEnumString( s_EnumString, sNomTableMembre);
   end;
   procedure Traite_Detail( s_Detail, sNomTableMembre: String);
   begin
        if '' = s_Detail then exit;
        if '' = sNomTableMembre then sNomTableMembre:= s_Detail;
              uJoinPoint_VisiteDetail( s_Detail, sNomTableMembre, a);
        sljpfMembre     .VisiteDetail( s_Detail, sNomTableMembre);
        sljpfEnumString .VisiteDetail( s_Detail, sNomTableMembre);
        sljpfDetail     .VisiteDetail( s_Detail, sNomTableMembre);
        sljpfSymetric   .VisiteDetail( s_Detail, sNomTableMembre);
        sljpfAggregation.VisiteDetail( s_Detail, sNomTableMembre);
        sljpfLibelle    .VisiteDetail( s_Detail, sNomTableMembre);
   end;
   procedure Traite_Symetric( s_Symetric, sNomTableMembre: String);
   begin
        if '' = s_Symetric then exit;
        if '' = sNomTableMembre then sNomTableMembre:= s_Symetric;
              uJoinPoint_VisiteSymetric( s_Symetric, sNomTableMembre, a);
        sljpfMembre     .VisiteSymetric( s_Symetric, sNomTableMembre);
        sljpfEnumString .VisiteSymetric( s_Symetric, sNomTableMembre);
        sljpfDetail     .VisiteSymetric( s_Symetric, sNomTableMembre);
        sljpfSymetric   .VisiteSymetric( s_Symetric, sNomTableMembre);
        sljpfAggregation.VisiteSymetric( s_Symetric, sNomTableMembre);
        sljpfLibelle    .VisiteSymetric( s_Symetric, sNomTableMembre);
   end;
   procedure Traite_Aggregation( s_Aggregation, sNomTableMembre: String);
   begin
        if '' = s_Aggregation then exit;
        if '' = sNomTableMembre then sNomTableMembre:= s_Aggregation;
              uJoinPoint_VisiteAggregation( s_Aggregation, sNomTableMembre, a);
        sljpfMembre     .VisiteAggregation( s_Aggregation, sNomTableMembre);
        sljpfEnumString .VisiteAggregation( s_Aggregation, sNomTableMembre);
        sljpfDetail     .VisiteAggregation( s_Aggregation, sNomTableMembre);
        sljpfSymetric   .VisiteAggregation( s_Aggregation, sNomTableMembre);
        sljpfAggregation.VisiteAggregation( s_Aggregation, sNomTableMembre);
        sljpfLibelle    .VisiteAggregation( s_Aggregation, sNomTableMembre);
   end;
   procedure Visite;
   var
      I: TIterateur_Champ;
      J: Integer;
      C: TChamp;
      nfApplication_txt: String;

      //Gestion des EnumStrings
      NbEnumStrings: Integer;
      nfEnumStrings: String;
      slEnumStrings:TStringList;

      //Gestion des détails
      NbDetails: Integer;
      nfDetails: String;
      slDetails:TStringList;

      //Gestion des Symetrics
      NbSymetrics: Integer;
      nfSymetrics: String;
      slSymetrics:TStringList;

      //Gestion des aggrégations
      NbAggregations: Integer;
      nfAggregations: String;
      slAggregations:TStringList;
   begin
        cc:= TContexteClasse.Create( Self, _Suffixe,
                                     bl.Champs.ChampDefinitions.Persistant_Count,
                                     slParametres);
        try
           slParametres.Clear;
           nfApplication_txt:= sRepertoireParametres+'Application.txt';
           if FileExists(nfApplication_txt)
           then
               slParametres.LoadFromFile(nfApplication_txt)
           else
               slParametres.SaveToFile  (nfApplication_txt);

                 uJoinPoint_Initialise( cc, a);
           sljpfMembre     .Initialise( cc);
           sljpfEnumString .Initialise( cc);
           sljpfDetail     .Initialise( cc);
           sljpfSymetric   .Initialise( cc);
           sljpfAggregation.Initialise( cc);
           sljpfLibelle    .Initialise( cc);

           I:= bl.Champs.sl.Iterateur;
           try
              while I.Continuer
              do
                begin
                if I.not_Suivant_interne( C) then continue;
                Traite_Champ( C);
                end;
           finally
                  FreeAndNil( I);
                  end;

           //Gestion des EnumStrings
           slEnumStrings:= TStringList.Create;
           try
              nfEnumStrings:= sRepertoireParametres+cc.Nom_de_la_classe+'.EnumStrings.txt';
              if FileExists( nfEnumStrings)
              then
                  slEnumStrings.LoadFromFile( nfEnumStrings);
              NbEnumStrings:= slEnumStrings.Count;
              for J:= 0 to NbEnumStrings-1
              do
                Traite_EnumString( slEnumStrings.Names[J], slEnumStrings.ValueFromIndex[J]);
           finally
                  slEnumStrings.SaveToFile( nfEnumStrings);
                  FreeAndNil( slEnumStrings);
                  end;

           //Gestion des détails
           slDetails:= TStringList.Create;
           try
              nfDetails:= sRepertoireParametres+cc.Nom_de_la_classe+'.Details.txt';
              if FileExists( nfDetails)
              then
                  slDetails.LoadFromFile( nfDetails);
              NbDetails:= slDetails.Count;
              for J:= 0 to NbDetails-1
              do
                Traite_Detail( slDetails.Names[J], slDetails.ValueFromIndex[J]);
           finally
                  slDetails.SaveToFile( nfDetails);
                  FreeAndNil( slDetails);
                  end;

           //Gestion des Symetrics
           slSymetrics:= TStringList.Create;
           try
              nfSymetrics:= sRepertoireParametres+cc.Nom_de_la_classe+'.Symetrics.txt';
              if FileExists( nfSymetrics)
              then
                  slSymetrics.LoadFromFile( nfSymetrics);
              NbSymetrics:= slSymetrics.Count;
              for J:= 0 to NbSymetrics-1
              do
                Traite_Symetric( slSymetrics.Names[J], slSymetrics.ValueFromIndex[J]);
           finally
                  slSymetrics.SaveToFile( nfSymetrics);
                  FreeAndNil( slSymetrics);
                  end;

           //Gestion des aggrégations
           slAggregations:= TStringList.Create;
           try
              nfAggregations:= sRepertoireParametres+cc.Nom_de_la_classe+'.Aggregations.txt';
              if FileExists( nfAggregations)
              then
                  slAggregations.LoadFromFile( nfAggregations);
              NbAggregations:= slAggregations.Count;
              for J:= 0 to NbAggregations-1
              do
                Traite_Aggregation( slAggregations.Names[J], slAggregations.ValueFromIndex[J]);
           finally
                  slAggregations.SaveToFile( nfAggregations);
                  FreeAndNil( slAggregations);
                  end;

           //Fermeture des chaines
                 uJoinPoint_Finalise( a);
           sljpfMembre     .Finalise;
           sljpfEnumString .Finalise;
           sljpfDetail     .Finalise;
           sljpfSymetric   .Finalise;
           sljpfAggregation.Finalise;
           sljpfLibelle    .Finalise;

                 uJoinPoint_To_Parametres( slParametres, a);
           sljpfMembre     .To_Parametres( slParametres);
           sljpfEnumString .To_Parametres( slParametres);
           sljpfDetail     .To_Parametres( slParametres);
           sljpfSymetric   .To_Parametres( slParametres);
           sljpfAggregation.To_Parametres( slParametres);
           sljpfLibelle    .To_Parametres( slParametres);

           slTemplateHandler_Produit;
           //Produit;
           slLog.Add( 'aprés Produit');
           slApplicationJoinPointFile.VisiteClasse( cc);
           slLog.Add( 'slApplicationJoinPointFile.VisiteClasse( cc);');
        finally
               FreeAndNil( cc)
               end;
   end;
begin
     bl:= _bl;
     slLog.Clear;
     slParametres.Clear;
     sRepertoireResultatPrefixe:= dmDatabase.jsDataConnexion.Database_identifier;
     sljpfMembre_from_sRepertoireListeMembres;
     sljpfEnumString_from_sRepertoireListeEnumStrings;
     sljpf08_EnumString_from_sRepertoireListe08_EnumStrings;
     sljpfDetail_from_sRepertoireListeDetails;
     sljpfSymetric_from_sRepertoireListeSymetrics;
     sljpfAggregation_from_sRepertoireListeAggregations;
     sljpfLibelle_from_sRepertoireListeLibelles;
     slTemplateHandler_from_sRepertoireTemplate;

     {
     CreeTemplateHandler( phPAS_DMCRE, phDFM_DMCRE, 'dmxcre');
     CreeTemplateHandler( phPAS_F    , phDFM_F    , 'f'     );
     CreeTemplateHandler( phPAS_FCB  , phDFM_FCB  , 'fcb'   );
     CreeTemplateHandler( phPAS_DKD  , phDFM_DKD  , 'dkd'   );
     CreeTemplateHandler( phPAS_FD  , phDFM_FD  , 'fd'   );
     CreeTemplateHandler_pool( phPAS_POOL);
     CreeTemplateHandler_BL( phPAS_BL);
     CreeTemplateHandler_HF( phPAS_HF);
     CreeTemplateHandler_TC( phPAS_TC);
     CreeTemplateHandler_DPK( phDPK);

     CreeTemplateHandler_ML( phCS_ML);

     CreeTemplateHandler_PHP_Doctrine( phPHP_Doctrine_record, phPHP_Doctrine_table);
     CreeTemplateHandler_PHP_Perso( phPHP_Perso_c, phPHP_Perso_Delete, phPHP_Perso_Insert, phPHP_Perso_Set);
     }
     if not Application_Created
     then
         Application_Create;
     try
        S:= '';
        Premiere_Classe:= True;

        Visite;

        slLog.Add( S);
     finally
            {
            FreeAndNil( phPAS_DMCRE);
            FreeAndNil( phPAS_POOL );
            FreeAndNil( phPAS_F    );
            FreeAndNil( phPAS_FCB  );
            FreeAndNil( phPAS_DKD  );

            FreeAndNil( phDFM_DMCRE);
            FreeAndNil( phDFM_F    );
            FreeAndNil( phDFM_FCB  );
            FreeAndNil( phDFM_DKD  );

            FreeAndNil( phDFM_FD  );
            FreeAndNil( phPAS_FD  );

            FreeAndNil( phPAS_BL   );
            FreeAndNil( phPAS_HF   );
            FreeAndNil( phPAS_TC   );

            FreeAndNil( phCS_ML   );

            FreeAndNil( phPHP_Doctrine_record);
            FreeAndNil( phPHP_Doctrine_table );

            FreeAndNil( phPHP_Perso_c     );
            FreeAndNil( phPHP_Perso_Delete);
            FreeAndNil( phPHP_Perso_Insert);
            FreeAndNil( phPHP_Perso_Set);
            }
            slTemplateHandler.Vide;
            sljpfMembre.Vide;
            end;
     slLog.SaveToFile( sRepertoireResultat+ChangeFileExt( ExtractFileName( uClean_EXE_Name), '.log'));
end;

procedure TGenerateur_de_code.Parametre_set( _NomFichier, _Name, _Value: String);
var
   sl: TStringList;
begin
     sl:= TStringList.Create;
     try
        if FileExists( _NomFichier)
        then
            sl.LoadFromFile( _NomFichier);
        sl.Values[_Name]:= _Value;
        sl.SaveToFile( _NomFichier);
     finally
            FreeAndNil( sl);
            end;
end;

procedure TGenerateur_de_code.Parametre_Detail_set( _Classe, _Name, _Value: String);
var
   NomFichier: String;
begin
     NomFichier:= sRepertoireParametres+_Classe+'.Details.txt';
     Parametre_set( NomFichier, _Name, _Value);
end;

procedure TGenerateur_de_code.Parametre_Symetric_set( _Classe, _Name, _Value: String);
var
   NomFichier: String;
begin
     NomFichier:= sRepertoireParametres+_Classe+'.Symetrics.txt';
     Parametre_set( NomFichier, _Name, _Value);
end;


procedure TGenerateur_de_code.Parametre_Aggregation_set( _Classe, _Name, _Value: String);
var
   NomFichier: String;
begin
     NomFichier:= sRepertoireParametres+_Classe+'.Aggregations.txt';
     Parametre_set( NomFichier, _Name, _Value);
end;

procedure TGenerateur_de_code.Execute_XMI_Classe( _xmi: TXMI; _eClasse: TDomNode; _NomClasse: String);
var
   cc: TContexteClasse;
   J: Integer;
   nfApplication_txt: String;

   //Gestion des EnumStrings
   NbEnumStrings: Integer;
   nfEnumStrings: String;
   slEnumStrings:TStringList;

   //Gestion des détails
   NbDetails: Integer;
   nfDetails: String;
   slDetails:TStringList;

   //Gestion des Symetrics
   NbSymetrics: Integer;
   nfSymetrics: String;
   slSymetrics:TStringList;

   //Gestion des aggrégations
   NbAggregations: Integer;
   nfAggregations: String;
   slAggregations:TStringList;

   NbLibelles: Integer;

   cirClass_Properties: TCherche_Items_Recursif;
   comment: String;

   procedure Traite_Properties;
   var
      eProperty: TDOMNode;
      Property_Name: String;
      type_id: String;
      eType: TDOMNode;
      sType: String;
      comment: String;
      procedure Type_not_found;
      begin
           sType:= '(non trouvé)';
      end;
      procedure Traite_Membre;
      var
         cm: TContexteMembre;
      begin
           cm:= TContexteMembre.Create( Self, cc, Property_Name, sType, '');
           try
              cm.description:= comment;
                    uJoinPoint_VisiteMembre( cm, a);
              sljpfMembre     .VisiteMembre( cm);
              sljpfEnumString .VisiteMembre( cm);
              sljpfDetail     .VisiteMembre( cm);
              sljpfSymetric   .VisiteMembre( cm);
              sljpfAggregation.VisiteMembre( cm);
              sljpfLibelle    .VisiteMembre( cm);
           finally
                  FreeAndNil( cm);
                  end;
      end;
      procedure Traite_Detail2;
      begin
           //if -1 = slDetails.IndexOfName( Property_Name)
           //then
               slDetails.Values[Property_Name]:= sType;
           //slSymetrics.Values[Property_Name]:= sType;

           //ici le nom pourrait être personnalisé
           Parametre_Aggregation_set( sType,
                                      LowerCase(_NomClasse){identificateur à personnaliser éventuellement},
                                      _NomClasse);
      end;
      procedure TraiteLibelle;
      begin
           if '''' <> Copy(Property_Name, 1,1) then exit;

           Delete(Property_Name, 1,1);
           cc.slLibelle.Add( Property_Name);
      end;
   begin
        cc.slLibelle.Clear;
        for eProperty in cirClass_Properties.l
        do
          begin
          if not_Get_Property( eProperty, 'name', Property_Name) then continue;
          if not_Get_Property( eProperty, 'type', type_id      ) then continue;
          eType:= _xmi.Get_type( type_id);
               if nil = eType                            then Type_not_found
          else if not_Get_Property( eType, 'name', sType)then Type_not_found;

          if not_Get_Property( eProperty, 'comment', comment) or ('' = comment)
          then
              comment:= Property_Name;

          TraiteLibelle;
          if nil = _xmi.Get_Classe_from_type( type_id)
          then
              Traite_Membre
          else
              Traite_Detail2;
          end;
        cc.slLibelle.SaveToFile( cc.nfLibelle);
   end;
   procedure Traite_EnumString( s_EnumString, sNomTableMembre: String);
   begin
        if '' = s_EnumString then exit;
        if '' = sNomTableMembre then sNomTableMembre:= s_EnumString;
              uJoinPoint_VisiteEnumString( s_EnumString, sNomTableMembre, a);
        sljpfMembre     .VisiteEnumString( s_EnumString, sNomTableMembre);
        sljpfEnumString .VisiteEnumString( s_EnumString, sNomTableMembre);
        sljpfDetail     .VisiteEnumString( s_EnumString, sNomTableMembre);
        sljpfSymetric   .VisiteEnumString( s_EnumString, sNomTableMembre);
        sljpfAggregation.VisiteEnumString( s_EnumString, sNomTableMembre);
        sljpfLibelle    .VisiteEnumString( s_EnumString, sNomTableMembre);
   end;
   procedure Traite_Detail( s_Detail, sNomTableMembre: String);
   begin
        if '' = s_Detail then exit;
        if '' = sNomTableMembre then sNomTableMembre:= s_Detail;
              uJoinPoint_VisiteDetail( s_Detail, sNomTableMembre, a);
        sljpfMembre     .VisiteDetail( s_Detail, sNomTableMembre);
        sljpfEnumString .VisiteDetail( s_Detail, sNomTableMembre);
        sljpfDetail     .VisiteDetail( s_Detail, sNomTableMembre);
        sljpfSymetric   .VisiteDetail( s_Detail, sNomTableMembre);
        sljpfAggregation.VisiteDetail( s_Detail, sNomTableMembre);
        sljpfLibelle    .VisiteDetail( s_Detail, sNomTableMembre);
   end;
   procedure Traite_Symetric( s_Symetric, sNomTableMembre: String);
   begin
        if '' = s_Symetric then exit;
        if '' = sNomTableMembre then sNomTableMembre:= s_Symetric;
              uJoinPoint_VisiteSymetric( s_Symetric, sNomTableMembre, a);
        sljpfMembre     .VisiteSymetric( s_Symetric, sNomTableMembre);
        sljpfEnumString .VisiteSymetric( s_Symetric, sNomTableMembre);
        sljpfDetail     .VisiteSymetric( s_Symetric, sNomTableMembre);
        sljpfSymetric   .VisiteSymetric( s_Symetric, sNomTableMembre);
        sljpfAggregation.VisiteSymetric( s_Symetric, sNomTableMembre);
        sljpfLibelle    .VisiteSymetric( s_Symetric, sNomTableMembre);
   end;
   procedure Traite_Aggregation( s_Aggregation, sNomTableMembre: String);
   begin
        if '' = s_Aggregation then exit;
        if '' = sNomTableMembre then sNomTableMembre:= s_Aggregation;
              uJoinPoint_VisiteAggregation( s_Aggregation, sNomTableMembre, a);
        sljpfMembre     .VisiteAggregation( s_Aggregation, sNomTableMembre);
        sljpfEnumString .VisiteAggregation( s_Aggregation, sNomTableMembre);
        sljpfDetail     .VisiteAggregation( s_Aggregation, sNomTableMembre);
        sljpfSymetric   .VisiteAggregation( s_Aggregation, sNomTableMembre);
        sljpfAggregation.VisiteAggregation( s_Aggregation, sNomTableMembre);
        sljpfLibelle    .VisiteAggregation( s_Aggregation, sNomTableMembre);
   end;
   procedure Traite_Libelle( s_Libelle: String);
   begin
        if '' = s_Libelle then exit;
              uJoinPoint_VisiteLibelle( s_Libelle, a);
        sljpfMembre     .VisiteLibelle( s_Libelle);
        sljpfEnumString .VisiteLibelle( s_Libelle);
        sljpfDetail     .VisiteLibelle( s_Libelle);
        sljpfSymetric   .VisiteLibelle( s_Libelle);
        sljpfAggregation.VisiteLibelle( s_Libelle);
        sljpfLibelle    .VisiteLibelle( s_Libelle);
   end;
begin
     cirClass_Properties:= _xmi.Get_Class_Properties( _eClasse);
     try
        cc:= TContexteClasse.Create( Self, _NomClasse,
                                     cirClass_Properties.l.Count,
                                     slParametres);
        if not_Get_Property( _eClasse, 'comment', comment) or ('' = comment)
        then
            comment:= _NomClasse;
        cc.description:= comment;
        slEnumStrings := TStringList.Create;
        slDetails:= TStringList.Create;
        slSymetrics:= TStringList.Create;
        slAggregations:= TStringList.Create;
        try
           slParametres.Clear;

           nfApplication_txt:= sRepertoireParametres+'Application.txt';
           if FileExists(nfApplication_txt)
           then
               slParametres.LoadFromFile(nfApplication_txt)
           else
               slParametres.SaveToFile  (nfApplication_txt);

           nfEnumStrings:= sRepertoireParametres+cc.Nom_de_la_classe+'.EnumStrings.txt';
           if FileExists( nfEnumStrings)
           then
               slEnumStrings.LoadFromFile( nfEnumStrings);

           nfDetails:= sRepertoireParametres+cc.Nom_de_la_classe+'.Details.txt';
           if FileExists( nfDetails)
           then
               slDetails.LoadFromFile( nfDetails);

           nfSymetrics:= sRepertoireParametres+cc.Nom_de_la_classe+'.Symetrics.txt';
           if FileExists( nfSymetrics)
           then
               slSymetrics.LoadFromFile( nfSymetrics);

           nfAggregations:= sRepertoireParametres+cc.Nom_de_la_classe+'.Aggregations.txt';
           if FileExists( nfAggregations)
           then
               slAggregations.LoadFromFile( nfAggregations);


                 uJoinPoint_Initialise( cc, a);
           sljpfMembre     .Initialise( cc);
           sljpfEnumString .Initialise( cc);
           sljpfDetail     .Initialise( cc);
           sljpfSymetric   .Initialise( cc);
           sljpfAggregation.Initialise( cc);
           sljpfLibelle    .Initialise( cc);

           Traite_Properties;

           //Gestion des détails
           NbEnumStrings:= slEnumStrings.Count;
           for J:= 0 to NbEnumStrings-1
           do
             Traite_EnumString( slEnumStrings.Names[J], slEnumStrings.ValueFromIndex[J]);
           slEnumStrings.SaveToFile( nfEnumStrings);

           //Gestion des détails
           NbDetails:= slDetails.Count;
           for J:= 0 to NbDetails-1
           do
             Traite_Detail( slDetails.Names[J], slDetails.ValueFromIndex[J]);
           slDetails.SaveToFile( nfDetails);

           //Gestion des Symetrics
           NbSymetrics:= slSymetrics.Count;
           for J:= 0 to NbSymetrics-1
           do
             Traite_Symetric( slSymetrics.Names[J], slSymetrics.ValueFromIndex[J]);
           slSymetrics.SaveToFile( nfSymetrics);

           //Gestion des aggrégations
           NbAggregations:= slAggregations.Count;
           for J:= 0 to NbAggregations-1
           do
             Traite_Aggregation( slAggregations.Names[J], slAggregations.ValueFromIndex[J]);
           slAggregations.SaveToFile( nfAggregations);

           //Gestion des aggrégations
           NbLibelles:= cc.slLibelle.Count;
           for J:= 0 to NbLibelles-1
           do
             Traite_Libelle( cc.slLibelle.Strings[J]);

           //Fermeture des chaines
                 uJoinPoint_Finalise( a);
           sljpfMembre     .Finalise;
           sljpfEnumString .Finalise;
           sljpfDetail     .Finalise;
           sljpfSymetric   .Finalise;
           sljpfAggregation.Finalise;
           sljpfLibelle    .Finalise;

                 uJoinPoint_To_Parametres( slParametres, a);
           sljpfMembre     .To_Parametres( slParametres);
           sljpfEnumString .To_Parametres( slParametres);
           sljpfDetail     .To_Parametres( slParametres);
           sljpfSymetric   .To_Parametres( slParametres);
           sljpfAggregation.To_Parametres( slParametres);
           sljpfLibelle    .To_Parametres( slParametres);

           slTemplateHandler_Produit;
           //Produit;
           slLog.Add( 'aprés Produit');
           slApplicationJoinPointFile.VisiteClasse( cc);
           slLog.Add( 'slApplicationJoinPointFile.VisiteClasse( cc);');
        finally
               FreeAndNil( slDetails);
               FreeAndNil( slSymetrics);
               FreeAndNil( slAggregations);
               FreeAndNil( cc)
               end;
     finally
            FreeAndNil( cirClass_Properties);
            end;
end;

procedure TGenerateur_de_code.Execute_XMI_Classes(_xmi: TXMI);
var
   cirClasses: TCherche_Items_Recursif;
   eClasse: TDOMNode;
   NomClasse: String;
begin
     cirClasses:= _xmi.Get_Classes;
     try
        for eClasse in cirClasses.l
        do
          begin
          if not_Get_Property( eClasse, 'name', NomClasse) then continue;
          Execute_XMI_Classe( _xmi, eClasse, NomClasse);
          end;
     finally
            FreeAndNil( cirClasses);
            end;
end;

procedure TGenerateur_de_code.Execute_XMI_Association( _xmi: TXMI; _eAssociation: TDOMNode);
{
var
   nfDetails     : String;
   nfSymetrics   : String;
   nfAggregations: String;

   slDetails     : TStringList;
   slSymetrics   : TStringList;
   slAggregations: TStringList;

   cirAssociation_Ends: TCherche_Items_Recursif;
   eAssociation_End: TDOMNode;
   sAggregation: String;
   type_id: String;
   eType: TDOMNode;
   sType: String;

   Detail_Nom, Detail_Type: String;
   Symetric_Nom, Symetric_Type: String;

   procedure cas_aggregate;
   var
      Aggregation_Nom, Aggregation_Type: String;
   begin
        Aggregation_Nom := NomTable+'_'+bl.FOREIGN_KEY;
        Aggregation_Type:= NomTable;
        slAggregations.Values[Aggregation_Nom]:= Aggregation_Type;
   end;
   procedure cas_none;
   begin

   end;
}
begin
{
     slDetails     := TStringList            .Create;
     slSymetrics   := TStringList            .Create;
     slAggregations:= TStringList            .Create;
     try
        cirAssociation_Ends:= _xmi.Get_Association_ends( _eAssociation);
        try
           for eAssociation_End in cirAssociation_Ends.l
           do
             begin
             type_id:= '';
             if not_Get_Property( eAssociation_End, 'aggregation', sAggregation) then continue;
             if not_Get_Property( eAssociation_End, 'type'       , type_id     ) then continue;

             eType:= _xmi.Get_type( type_id);
                  if nil = eType                            then continue
             else if not_Get_Property( eType, 'name', sType)then continue;

             nfDetails:= sRepertoireParametres+sType+'.Details.txt';
             if FileExists( nfDetails)
             then
                 slDetails.LoadFromFile( nfDetails)
             else
                 slDetails.Clear;

             nfSymetrics:= sRepertoireParametres+sType+'.Symetrics.txt';
             if FileExists( nfSymetrics)
             then
                 slSymetrics.LoadFromFile( nfSymetrics)
             else
                 slSymetrics.Clear;

             nfAggregations:= sRepertoireParametres+sType+'.Aggregations.txt';
             if FileExists( nfAggregations)
             then
                 slAggregations.LoadFromFile( nfAggregations)
             else
                 slAggregations.Clear;

             {
             Detail_Nom := bl.FOREIGN_KEY;
             Detail_Type:= bl.Reference_Table;
             slDetails.Values[Detail_Nom]:= Detail_Type;

             Symetric_Nom := bl.FOREIGN_KEY;
             Symetric_Type:= bl.Reference_Table;
             slSymetrics.Values[Symetric_Nom]:= Symetric_Type;
             }
{
                  if 'aggregate' = sAggregation then cas_aggregate
             else if 'none'      = sAggregation then cas_none;

             slDetails.SaveToFile( nfDetails);
             slSymetrics.SaveToFile( nfSymetrics);
             slAggregations.SaveToFile( nfAggregations);
             end;
        finally
               FreeAndNil( cirAssociation_Ends);
               end;
     finally
            FreeAndNil( slDetails);
            FreeAndNil( slSymetrics);
            FreeAndNil( slAggregations);
            end;
}
end;

procedure TGenerateur_de_code.Execute_XMI_Associations(_xmi: TXMI);
var
   cirAssociations: TCherche_Items_Recursif;
   eAssociation: TDOMNode;
begin
     cirAssociations:= _xmi.Get_Associations;
     try
        for eAssociation in cirAssociations.l
        do
          Execute_XMI_Association( _xmi, eAssociation);
     finally
            FreeAndNil( cirAssociations);
            end;
end;

procedure TGenerateur_de_code.Execute_XMI(_xmi: TXMI);
begin
     slLog.Clear;
     slParametres.Clear;
     sRepertoireResultatPrefixe:= ExtractFileName( _xmi.Filename);
     sRepertoireResultatPrefixe:= StringReplace( sRepertoireResultatPrefixe, '.','_',[rfReplaceAll]);
     sljpfMembre_from_sRepertoireListeMembres;
     sljpfEnumString_from_sRepertoireListeEnumStrings;
     sljpf08_EnumString_from_sRepertoireListe08_EnumStrings;
     sljpfDetail_from_sRepertoireListeDetails;
     sljpfSymetric_from_sRepertoireListeSymetrics;
     sljpfAggregation_from_sRepertoireListeAggregations;
     sljpfLibelle_from_sRepertoireListeLibelles;
     slTemplateHandler_from_sRepertoireTemplate;

     if not Application_Created
     then
         Application_Create;
     try
        S:= '';
        Premiere_Classe:= True;

        Execute_XMI_Associations( _xmi);
        Execute_XMI_Classes     ( _xmi);
        Application_Produit;
        slLog.Add( S);
     finally
            Application_Destroy;
            slTemplateHandler.Vide;
            sljpfMembre.Vide;
            end;
     slLog.SaveToFile( sRepertoireResultat+ChangeFileExt( ExtractFileName( uClean_EXE_Name), '.log'));
end;

procedure TGenerateur_de_code.Execute_OpenAPI_EnumString( _OpenAPI: TOpenAPI; _e: TEnum);
var
   cc: TContexteClasse;
   el: TEnumValue_List;
   ev: TEnumValue;
   NomFichier: String;
   sl: TStringList;
   sIdentifier: String;
   function Identifier_from_String( _s: String): String;
   var   // from https://wiki.freepascal.org/UTF8_strings_and_characters
      pCur, pEnd: PChar;
      Len: Integer;
      CodePoint: String;
      cp: String;
      C: String;
   begin
        Result:= '';
        pCur := PChar(_s);        // if _s='' then PChar(_s) returns a pointer to #0
        pEnd := pCur + length(_s);
        while pCur < pEnd
        do
          begin
          Len := UTF8CodepointSize(pCur);
          SetLength(CodePoint, Len);
          Move(pCur^, CodePoint[1], Len);
          // A single codepoint is copied from the string. Do your thing with it.
          //ShowMessageFmt('CodePoint=%s, Len=%d', [CodePoint, Len]);
          // ...
          cp:= LowerCase( CodePoint);
               if 'é' = cp then C:= 'E'
          else if 'è' = cp then C:= 'E'
          else if 'ê' = cp then C:= 'E'
          else if 'ë' = cp then C:= 'E'
          else if 'î' = cp then C:= 'I'
          else if 'ï' = cp then C:= 'I'
          else if 'à' = cp then C:= 'A'
          else if 'ç' = cp then C:= 'C'
          else if 'ô' = cp then C:= 'O'
          else
          case CodePoint[1]
          of
            '0'..'9','A'..'Z','a'..'z': C:= UpCase(CodePoint[1]);
            else                        C:= '_';
            end;
          Result:= Result + C;
          inc(pCur, Len);
          end;
   end;
begin
     cc:= TContexteClasse.Create( Self, _e.name,
                                  1,
                                  slParametres);
     try
        slParametres.Clear;
        sljpf08_EnumString .Initialise( cc);
        NomFichier:= sRepertoireEnumStrings+_e.name+'.txt';
        sl:= TStringList.Create;
        try
           el:= _e.Get_EnumValue_List;
           try
              for ev in el
              do
                begin
                sl.Values[ev.name]:= ev.libelle;
                sIdentifier:= 'C_'+Identifier_from_String( ev.name);
                sljpf08_EnumString .Visite08_EnumString( sIdentifier, ev.name, ev.libelle);
                end;
           finally
                  FreeAndNil( el);
                  end;
        finally
               sl.SaveToFile( NomFichier);
               FreeAndNil( sl);
               end;
        sljpf08_EnumString .Finalise;
        sljpf08_EnumString .To_Parametres( slParametres);
        slApplicationEnumJoinPointFile.VisiteClasse( cc);
     finally
            FreeAndNil( cc);
            end;
end;

procedure TGenerateur_de_code.Execute_OpenAPI_Schema( _OpenAPI: TOpenAPI; _s: TSchema);
var
   cc: TContexteClasse;
   J: Integer;
   nfApplication_txt: String;

   //Gestion des EnumString
   NbEnumStrings: Integer;
   nfEnumStrings: String;
   slEnumStrings:TStringList;

   //Gestion des détails
   NbDetails: Integer;
   nfDetails: String;
   slDetails:TStringList;

   //Gestion des Symetrics
   NbSymetrics: Integer;
   nfSymetrics: String;
   slSymetrics:TStringList;

   //Gestion des aggrégations
   NbAggregations: Integer;
   nfAggregations: String;
   slAggregations:TStringList;

   NbLibelles: Integer;

   pl: TProperties_List;

   procedure Traite_Properties;
   var
      p: TProperty;
      procedure Traite_Membre;
      var
         cm: TContexteMembre;
         sType: String;
      begin
           sType:= p.typ;
           if p.typ_is_array then sType:= 'array of '+sType;
           cm:= TContexteMembre.Create( Self, cc, p.name, sType, '', False, p.nullable);
           try
              cm.description:= p.description;
                    uJoinPoint_VisiteMembre( cm, a);
              sljpfMembre     .VisiteMembre( cm);
              sljpfEnumString .VisiteMembre( cm);
              sljpfDetail     .VisiteMembre( cm);
              sljpfSymetric   .VisiteMembre( cm);
              sljpfAggregation.VisiteMembre( cm);
              sljpfLibelle    .VisiteMembre( cm);
           finally
                  FreeAndNil( cm);
                  end;
      end;
      procedure Traite_class;
      begin
           if p.typ_is_array
           then
               slAggregations.Values[p.name]:= p.typ
           else
               if p.typ_is_enum
               then
                   slEnumStrings.Values[p.name]:= p.typ
               else
                   slDetails.Values[p.name]:= p.typ;

           if not p.typ_is_enum
           then
               Parametre_Aggregation_set( p.typ,
                                          _s.name{identificateur à personnaliser éventuellement},
                                          _s.name);
      end;
   begin
        for p in pl
        do
          begin

          if p.typ_is_class
          then
              Traite_class
          else
              Traite_Membre;
          end;
   end;
   procedure Traite_EnumString( s_EnumString, sNomTableMembre: String);
   begin
        if '' = s_EnumString then exit;
        if '' = sNomTableMembre then sNomTableMembre:= s_EnumString;
              uJoinPoint_VisiteEnumString( s_EnumString, sNomTableMembre, a);
        sljpfMembre     .VisiteEnumString( s_EnumString, sNomTableMembre);
        sljpfEnumString .VisiteEnumString( s_EnumString, sNomTableMembre);
        sljpfDetail     .VisiteEnumString( s_EnumString, sNomTableMembre);
        sljpfSymetric   .VisiteEnumString( s_EnumString, sNomTableMembre);
        sljpfAggregation.VisiteEnumString( s_EnumString, sNomTableMembre);
        sljpfLibelle    .VisiteEnumString( s_EnumString, sNomTableMembre);
   end;
   procedure Traite_Detail( s_Detail, sNomTableMembre: String);
   begin
        if '' = s_Detail then exit;
        if '' = sNomTableMembre then sNomTableMembre:= s_Detail;
              uJoinPoint_VisiteDetail( s_Detail, sNomTableMembre, a);
        sljpfMembre     .VisiteDetail( s_Detail, sNomTableMembre);
        sljpfEnumString .VisiteDetail( s_Detail, sNomTableMembre);
        sljpfDetail     .VisiteDetail( s_Detail, sNomTableMembre);
        sljpfSymetric   .VisiteDetail( s_Detail, sNomTableMembre);
        sljpfAggregation.VisiteDetail( s_Detail, sNomTableMembre);
        sljpfLibelle    .VisiteDetail( s_Detail, sNomTableMembre);
   end;
   procedure Traite_Symetric( s_Symetric, sNomTableMembre: String);
   begin
        if '' = s_Symetric then exit;
        if '' = sNomTableMembre then sNomTableMembre:= s_Symetric;
              uJoinPoint_VisiteSymetric( s_Symetric, sNomTableMembre, a);
        sljpfMembre     .VisiteSymetric( s_Symetric, sNomTableMembre);
        sljpfEnumString .VisiteSymetric( s_Symetric, sNomTableMembre);
        sljpfDetail     .VisiteSymetric( s_Symetric, sNomTableMembre);
        sljpfSymetric   .VisiteSymetric( s_Symetric, sNomTableMembre);
        sljpfAggregation.VisiteSymetric( s_Symetric, sNomTableMembre);
        sljpfLibelle    .VisiteSymetric( s_Symetric, sNomTableMembre);
   end;
   procedure Traite_Aggregation( s_Aggregation, sNomTableMembre: String);
   begin
        if '' = s_Aggregation then exit;
        if '' = sNomTableMembre then sNomTableMembre:= s_Aggregation;
              uJoinPoint_VisiteAggregation( s_Aggregation, sNomTableMembre, a);
        sljpfMembre     .VisiteAggregation( s_Aggregation, sNomTableMembre);
        sljpfEnumString .VisiteAggregation( s_Aggregation, sNomTableMembre);
        sljpfDetail     .VisiteAggregation( s_Aggregation, sNomTableMembre);
        sljpfSymetric   .VisiteAggregation( s_Aggregation, sNomTableMembre);
        sljpfAggregation.VisiteAggregation( s_Aggregation, sNomTableMembre);
        sljpfLibelle    .VisiteAggregation( s_Aggregation, sNomTableMembre);
   end;
   procedure Traite_Libelle( s_Libelle: String);
   begin
        if '' = s_Libelle then exit;
              uJoinPoint_VisiteLibelle( s_Libelle, a);
        sljpfMembre     .VisiteLibelle( s_Libelle);
        sljpfEnumString .VisiteLibelle( s_Libelle);
        sljpfDetail     .VisiteLibelle( s_Libelle);
        sljpfSymetric   .VisiteLibelle( s_Libelle);
        sljpfAggregation.VisiteLibelle( s_Libelle);
        sljpfLibelle    .VisiteLibelle( s_Libelle);
   end;
begin
     pl:= _s.Get_Properties_List;
     try
        cc:= TContexteClasse.Create( Self, _s.name,
                                     pl.Count,
                                     slParametres);
        cc.description:= _s.description;
        slEnumStrings := TStringList.Create;
        slDetails     := TStringList.Create;
        slSymetrics   := TStringList.Create;
        slAggregations:= TStringList.Create;
        try
           slParametres.Clear;

           nfApplication_txt:= sRepertoireParametres+'Application.txt';
           if FileExists(nfApplication_txt)
           then
               slParametres.LoadFromFile(nfApplication_txt)
           else
               slParametres.SaveToFile  (nfApplication_txt);

           nfEnumStrings:= sRepertoireParametres+cc.Nom_de_la_classe+'.EnumStrings.txt';
           if FileExists( nfEnumStrings)
           then
               slEnumStrings.LoadFromFile( nfEnumStrings);

           nfDetails:= sRepertoireParametres+cc.Nom_de_la_classe+'.Details.txt';
           if FileExists( nfDetails)
           then
               slDetails.LoadFromFile( nfDetails);

           nfSymetrics:= sRepertoireParametres+cc.Nom_de_la_classe+'.Symetrics.txt';
           if FileExists( nfSymetrics)
           then
               slSymetrics.LoadFromFile( nfSymetrics);

           nfAggregations:= sRepertoireParametres+cc.Nom_de_la_classe+'.Aggregations.txt';
           if FileExists( nfAggregations)
           then
               slAggregations.LoadFromFile( nfAggregations);


                 uJoinPoint_Initialise( cc, a);
           sljpfMembre     .Initialise( cc);
           sljpfEnumString .Initialise( cc);
           sljpfDetail     .Initialise( cc);
           sljpfSymetric   .Initialise( cc);
           sljpfAggregation.Initialise( cc);
           sljpfLibelle    .Initialise( cc);

           Traite_Properties;

           //Gestion des EnumString
           NbEnumStrings:= slEnumStrings.Count;
           for J:= 0 to NbEnumStrings-1
           do
             Traite_EnumString( slEnumStrings.Names[J], slEnumStrings.ValueFromIndex[J]);
           slEnumStrings.SaveToFile( nfEnumStrings);

           //Gestion des détails
           NbDetails:= slDetails.Count;
           for J:= 0 to NbDetails-1
           do
             Traite_Detail( slDetails.Names[J], slDetails.ValueFromIndex[J]);
           slDetails.SaveToFile( nfDetails);

           //Gestion des Symetrics
           NbSymetrics:= slSymetrics.Count;
           for J:= 0 to NbSymetrics-1
           do
             Traite_Symetric( slSymetrics.Names[J], slSymetrics.ValueFromIndex[J]);
           slSymetrics.SaveToFile( nfSymetrics);

           //Gestion des aggrégations
           NbAggregations:= slAggregations.Count;
           for J:= 0 to NbAggregations-1
           do
             Traite_Aggregation( slAggregations.Names[J], slAggregations.ValueFromIndex[J]);
           slAggregations.SaveToFile( nfAggregations);

           //Gestion des aggrégations
           NbLibelles:= cc.slLibelle.Count;
           for J:= 0 to NbLibelles-1
           do
             Traite_Libelle( cc.slLibelle.Strings[J]);

           //Fermeture des chaines
                 uJoinPoint_Finalise( a);
           sljpfMembre     .Finalise;
           sljpfEnumString .Finalise;
           sljpfDetail     .Finalise;
           sljpfSymetric   .Finalise;
           sljpfAggregation.Finalise;
           sljpfLibelle    .Finalise;

                 uJoinPoint_To_Parametres( slParametres, a);
           sljpfMembre     .To_Parametres( slParametres);
           sljpfEnumString .To_Parametres( slParametres);
           sljpfDetail     .To_Parametres( slParametres);
           sljpfSymetric   .To_Parametres( slParametres);
           sljpfAggregation.To_Parametres( slParametres);
           sljpfLibelle    .To_Parametres( slParametres);

           slTemplateHandler_Produit;
           //Produit;
           slLog.Add( 'aprés Produit');
           slApplicationJoinPointFile.VisiteClasse( cc);
           slLog.Add( 'slApplicationJoinPointFile.VisiteSchema( cc);');
        finally
               FreeAndNil( slEnumStrings );
               FreeAndNil( slDetails     );
               FreeAndNil( slSymetrics   );
               FreeAndNil( slAggregations);
               FreeAndNil( cc)
               end;
     finally
            FreeAndNil( pl);
            end;
end;

procedure TGenerateur_de_code.Execute_OpenAPI_Schemas(_OpenAPI: TOpenAPI);
   procedure Traite_Enums;
   var
      sl: TEnum_List;
      e: TEnum;
   begin
        sl:= _OpenAPI.Get_Enums_List;
        try
           for e in sl
           do
             Execute_OpenAPI_EnumString( _OpenAPI, e);
        finally
               FreeAndNil( sl);
               end;
   end;
   procedure Traite_Schemas;
   var
      sl: TSchema_List;
      s: TSchema;
   begin
        sl:= _OpenAPI.Get_Schemas_List;
        try
           for s in sl
           do
             Execute_OpenAPI_Schema( _OpenAPI, s);
        finally
               FreeAndNil( sl);
               end;
   end;
begin
     Traite_Enums;
     Traite_Schemas;
end;

procedure TGenerateur_de_code.Execute_OpenAPI(_OpenAPI: TOpenAPI);
begin
     slLog.Clear;
     slParametres.Clear;
     sRepertoireResultatPrefixe:= ExtractFileName( _OpenAPI.Filename);
     sRepertoireResultatPrefixe:= StringReplace( sRepertoireResultatPrefixe, '.','_',[rfReplaceAll]);
     sljpfMembre_from_sRepertoireListeMembres;
     sljpfEnumString_from_sRepertoireListeEnumStrings;
     sljpf08_EnumString_from_sRepertoireListe08_EnumStrings;
     sljpfDetail_from_sRepertoireListeDetails;
     sljpfSymetric_from_sRepertoireListeSymetrics;
     sljpfAggregation_from_sRepertoireListeAggregations;
     sljpfLibelle_from_sRepertoireListeLibelles;
     slTemplateHandler_from_sRepertoireTemplate;

     if not Application_Created
     then
         Application_Create;
     try
        S:= '';
        Premiere_Classe:= True;

        Execute_OpenAPI_Schemas     ( _OpenAPI);
        Application_Produit;
        slLog.Add( S);
     finally
            Application_Destroy;
            slTemplateHandler.Vide;
            sljpfMembre.Vide;
            end;
     slLog.SaveToFile( sRepertoireResultat+ChangeFileExt( ExtractFileName( uClean_EXE_Name), '.log'));
end;

function TGenerateur_de_code.Cree_jpfMembre(_nfKey: String): TjpfMembre;
begin
     Result:= jpfMembre_from_sl_sCle( sljpfMembre, _nfKey);
     if nil <> Result then exit;

     Result:= TjpfMembre.Create( _nfKey);
     sljpfMembre.AddObject( _nfKey, Result);
end;

procedure TGenerateur_de_code.sljpfMembre_from_sRepertoireListeMembres_FileFound( _FileIterator: TFileIterator);
var
   NomFichier_Key: String;
begin
     if _FileIterator.IsDirectory then exit;

     NomFichier_Key:= _FileIterator.FileName;

     Cree_jpfMembre( NomFichier_Key);
end;

procedure TGenerateur_de_code.sljpfMembre_from_sRepertoireListeMembres;
begin
     ujpFile_EnumFiles( sRepertoireListeMembres, sljpfMembre_from_sRepertoireListeMembres_FileFound, s_key_mask);
end;

function TGenerateur_de_code.Cree_jpfEnumString(_nfKey: String): TjpfEnumString;
begin
     Result:= jpfEnumString_from_sl_sCle( sljpfEnumString, _nfKey);
     if nil <> Result then exit;

     Result:= TjpfEnumString.Create( _nfKey);
     sljpfEnumString.AddObject( _nfKey, Result);
end;

procedure TGenerateur_de_code.sljpfEnumString_from_sRepertoireListeEnumStrings_FileFound( _FileIterator: TFileIterator);
var
   NomFichier_Key: String;
begin
     if _FileIterator.IsDirectory then exit;

     NomFichier_Key:= _FileIterator.FileName;

     Cree_jpfEnumString( NomFichier_Key);
end;

procedure TGenerateur_de_code.sljpfEnumString_from_sRepertoireListeEnumStrings;
begin
     ujpFile_EnumFiles( sRepertoireListeEnumStrings, sljpfEnumString_from_sRepertoireListeEnumStrings_FileFound, s_key_mask);
end;

function TGenerateur_de_code.Cree_jpf08_EnumString(_nfKey: String): Tjpf08_EnumString;
begin
     Result:= jpf08_EnumString_from_sl_sCle( sljpf08_EnumString, _nfKey);
     if nil <> Result then exit;

     Result:= Tjpf08_EnumString.Create( _nfKey);
     sljpf08_EnumString.AddObject( _nfKey, Result);
end;

procedure TGenerateur_de_code.sljpf08_EnumString_from_sRepertoireListe08_EnumStrings_FileFound( _FileIterator: TFileIterator);
var
   NomFichier_Key: String;
begin
     if _FileIterator.IsDirectory then exit;

     NomFichier_Key:= _FileIterator.FileName;

     Cree_jpf08_EnumString( NomFichier_Key);
end;

procedure TGenerateur_de_code.sljpf08_EnumString_from_sRepertoireListe08_EnumStrings;
begin
     ujpFile_EnumFiles( sRepertoireListe08_EnumStrings, sljpf08_EnumString_from_sRepertoireListe08_EnumStrings_FileFound, s_key_mask);
end;

function TGenerateur_de_code.Cree_jpfDetail(_nfKey: String): TjpfDetail;
begin
     Result:= jpfDetail_from_sl_sCle( sljpfDetail, _nfKey);
     if nil <> Result then exit;

     Result:= TjpfDetail.Create( _nfKey);
     sljpfDetail.AddObject( _nfKey, Result);
end;

procedure TGenerateur_de_code.sljpfDetail_from_sRepertoireListeDetails_FileFound( _FileIterator: TFileIterator);
var
   NomFichier_Key: String;
begin
     if _FileIterator.IsDirectory then exit;

     NomFichier_Key:= _FileIterator.FileName;

     Cree_jpfDetail( NomFichier_Key);
end;

procedure TGenerateur_de_code.sljpfDetail_from_sRepertoireListeDetails;
begin
     ujpFile_EnumFiles( sRepertoireListeDetails, sljpfDetail_from_sRepertoireListeDetails_FileFound, s_key_mask);
end;

function TGenerateur_de_code.Cree_jpfSymetric(_nfKey: String): TjpfSymetric;
begin
     Result:= jpfSymetric_from_sl_sCle( sljpfSymetric, _nfKey);
     if nil <> Result then exit;

     Result:= TjpfSymetric.Create( _nfKey);
     sljpfSymetric.AddObject( _nfKey, Result);
end;

procedure TGenerateur_de_code.sljpfSymetric_from_sRepertoireListeSymetrics_FileFound( _FileIterator: TFileIterator);
var
   NomFichier_Key: String;
begin
     if _FileIterator.IsDirectory then exit;

     NomFichier_Key:= _FileIterator.FileName;

     Cree_jpfSymetric( NomFichier_Key);
end;

procedure TGenerateur_de_code.sljpfSymetric_from_sRepertoireListeSymetrics;
begin
     ujpFile_EnumFiles( sRepertoireListeSymetrics, sljpfSymetric_from_sRepertoireListeSymetrics_FileFound, s_key_mask);
end;

function TGenerateur_de_code.Cree_jpfAggregation(_nfKey: String): TjpfAggregation;
begin
     Result:= jpfAggregation_from_sl_sCle( sljpfAggregation, _nfKey);
     if nil <> Result then exit;

     Result:= TjpfAggregation.Create( _nfKey);
     sljpfAggregation.AddObject( _nfKey, Result);
end;

procedure TGenerateur_de_code.sljpfAggregation_from_sRepertoireListeAggregations_FileFound( _FileIterator: TFileIterator);
var
   NomFichier_Key: String;
begin
     if _FileIterator.IsDirectory then exit;

     NomFichier_Key:= _FileIterator.FileName;

     Cree_jpfAggregation( NomFichier_Key);
end;

procedure TGenerateur_de_code.sljpfAggregation_from_sRepertoireListeAggregations;
begin
     ujpFile_EnumFiles( sRepertoireListeAggregations, sljpfAggregation_from_sRepertoireListeAggregations_FileFound, s_key_mask);
end;

function TGenerateur_de_code.Cree_jpfLibelle(_nfKey: String): TjpfLibelle;
begin
     Result:= jpfLibelle_from_sl_sCle( sljpfLibelle, _nfKey);
     if nil <> Result then exit;

     Result:= TjpfLibelle.Create( _nfKey);
     sljpfLibelle.AddObject( _nfKey, Result);
end;

procedure TGenerateur_de_code.sljpfLibelle_from_sRepertoireListeLibelles_FileFound( _FileIterator: TFileIterator);
var
   NomFichier_Key: String;
begin
     if _FileIterator.IsDirectory then exit;

     NomFichier_Key:= _FileIterator.FileName;

     Cree_jpfLibelle( NomFichier_Key);
end;

procedure TGenerateur_de_code.sljpfLibelle_from_sRepertoireListeLibelles;
begin
     ujpFile_EnumFiles( sRepertoireListeLibelles, sljpfLibelle_from_sRepertoireListeLibelles_FileFound, s_key_mask);
end;

function TGenerateur_de_code.Cree_ApplicationJoinPointFile(_nfKey: String): TApplicationJoinPointFile;
begin
     Result:= ApplicationJoinPointFile_from_sl_sCle( slApplicationJoinPointFile, _nfKey);
     if nil <> Result then exit;

     Result:= TApplicationJoinPointFile.Create( _nfKey);
     slApplicationJoinPointFile.AddObject( _nfKey, Result);
end;

procedure TGenerateur_de_code.slApplicationJoinPointFile_from_sRepertoireListeTables_FileFound( _FileIterator: TFileIterator);
var
   NomFichier_Key: String;
begin
     if _FileIterator.IsDirectory then exit;

     NomFichier_Key:= _FileIterator.FileName;

     Cree_ApplicationJoinPointFile( NomFichier_Key);
end;

procedure TGenerateur_de_code.slApplicationJoinPointFile_from_sRepertoireListeTables;
begin
     ujpFile_EnumFiles( sRepertoireListeTables, slApplicationJoinPointFile_from_sRepertoireListeTables_FileFound, s_key_mask);
end;

procedure TGenerateur_de_code.slApplicationJoinPointFile_Produit;
begin

end;

function TGenerateur_de_code.Cree_ApplicationEnumJoinPointFile(_nfKey: String): TApplicationEnumJoinPointFile;
begin
     Result:= ApplicationEnumJoinPointFile_from_sl_sCle( slApplicationEnumJoinPointFile, _nfKey);
     if nil <> Result then exit;

     Result:= TApplicationEnumJoinPointFile.Create( _nfKey);
     slApplicationEnumJoinPointFile.AddObject( _nfKey, Result);
end;

procedure TGenerateur_de_code.slApplicationEnumJoinPointFile_from_sRepertoireListeEnum_FileFound( _FileIterator: TFileIterator);
var
   NomFichier_Key: String;
begin
     if _FileIterator.IsDirectory then exit;

     NomFichier_Key:= _FileIterator.FileName;

     Cree_ApplicationEnumJoinPointFile( NomFichier_Key);
end;

procedure TGenerateur_de_code.slApplicationEnumJoinPointFile_from_sRepertoireListeEnum;
begin
     ujpFile_EnumFiles( sRepertoireListeEnum, slApplicationEnumJoinPointFile_from_sRepertoireListeEnum_FileFound, s_key_mask);
end;

procedure TGenerateur_de_code.slApplicationEnumJoinPointFile_Produit;
begin

end;

function TGenerateur_de_code.Cree_EnumStrings(_nfEnumString: String): TEnumString;
begin
     Result:= EnumString_from_sl_sCle( slEnumStrings, _nfEnumString);
     if nil <> Result then exit;

     Result:= TEnumString.Create( _nfEnumString);
     slEnumStrings.AddObject( Result.sEnumString, Result);
     //Mapped_Type_
end;

procedure TGenerateur_de_code.slEnumStrings_from_sRepertoireEnumStrings_FileFound( _FileIterator: TFileIterator);
var
   NomFichier_Key: String;
begin
     if _FileIterator.IsDirectory then exit;

     NomFichier_Key:= _FileIterator.FileName;

     Cree_EnumStrings( NomFichier_Key);
end;

procedure TGenerateur_de_code.slEnumStrings_from_sRepertoireEnumStrings;
begin
     ujpFile_EnumFiles( sRepertoireEnumStrings, slEnumStrings_from_sRepertoireEnumStrings_FileFound, '*.txt');
end;

function TGenerateur_de_code.Cree_TypeMappings(_nfTypeMapping: String): TTypeMapping;
begin
     Result:= TypeMapping_from_sl_sCle( slTypeMappings, _nfTypeMapping);
     if nil <> Result then exit;

     Result:= TTypeMapping.Create( _nfTypeMapping);
     slTypeMappings.AddObject( Result.sTypeMapping, Result);
     //Mapped_Type_
end;

procedure TGenerateur_de_code.slTypeMappings_from_sRepertoireTypeMappings_FileFound( _FileIterator: TFileIterator);
var
   NomFichier_Key: String;
begin
     if _FileIterator.IsDirectory then exit;

     NomFichier_Key:= _FileIterator.FileName;

     Cree_TypeMappings( NomFichier_Key);
end;

procedure TGenerateur_de_code.slTypeMappings_from_sRepertoireTypeMappings;
begin
     ujpFile_EnumFiles( sRepertoireTypeMappings, slTypeMappings_from_sRepertoireTypeMappings_FileFound, '*.txt');
end;


function TGenerateur_de_code.Cree_TemplateHandler( _Source: String;
                                                  _slParametres: TBatpro_StringList= nil): TTemplateHandler;
var
   slParametres_local: TBatpro_StringList;
begin
     if nil = _slParametres
     then
         slParametres_local:= slParametres
     else
         slParametres_local:= _slParametres;

     Result
     :=
       TemplateHandler_from_sl_sCle( slTemplateHandler, _Source);
     if nil = Result
     then
         begin
         Result:= TTemplateHandler.Create( Self, _Source, slParametres_local);
         slTemplateHandler.AddObject( _Source, Result);
         end
     else
         Result.slParametres:= slParametres_local;
end;

procedure TGenerateur_de_code.Cree_TemplateHandler( var _Reference;
                                                   _Source: String;
                                                   _slParametres: TBatpro_StringList= nil);
begin
     TTemplateHandler(_Reference):= Cree_TemplateHandler( _Source, _slParametres);
end;

procedure TGenerateur_de_code.slTemplateHandler_from_sRepertoireTemplate_FileFound( _FileIterator: TFileIterator);
var
   Source: String;
begin
     if _FileIterator.IsDirectory then exit;

     Source:= _FileIterator.FileName;
     if 0 <> Pos( PathDelim+'backup'+PathDelim, Source) then exit;

     Delete( Source, 1, Length( sRepertoireTemplate));

     Cree_TemplateHandler( Source);
end;

procedure TGenerateur_de_code.slTemplateHandler_from_sRepertoireTemplate;
begin
     ujpFile_EnumFiles( sRepertoireTemplate, slTemplateHandler_from_sRepertoireTemplate_FileFound);
end;

procedure TGenerateur_de_code.slTemplateHandler_Produit;
var
   I: TIterateur_TemplateHandler;
   ph: TTemplateHandler;
begin
     I:= slTemplateHandler.Iterateur;
     try
        while I.Continuer
        do
          begin
          if I.not_Suivant( ph) then continue;
          ph.Produit;
          end;
     finally
            FreeAndNil( I);
            end;
end;

function TGenerateur_de_code.Cree_ApplicationTemplateHandler( _Source: String; _slParametres: TBatpro_StringList): TTemplateHandler;
var
   slParametres_local: TBatpro_StringList;
begin
     if nil = _slParametres
     then
         slParametres_local:= slParametres
     else
         slParametres_local:= _slParametres;

     Result
     :=
       TemplateHandler_from_sl_sCle( slTemplateHandler, _Source);
     if nil = Result
     then
         begin
         Result:= TApplicationTemplateHandler.Create( Self, _Source, slParametres_local);
         slApplicationTemplateHandler.AddObject( _Source, Result);
         end
     else
         Result.slParametres:= slParametres_local;
end;

procedure TGenerateur_de_code.slApplicationTemplateHandler_from_sRepertoireApplicationTemplate_FileFound( _FileIterator: TFileIterator);
var
   Source: String;
begin
     if _FileIterator.IsDirectory then exit;

     Source:= _FileIterator.FileName;
     Delete( Source, 1, Length( sRepertoireApplicationTemplate));

     Cree_ApplicationTemplateHandler( Source);
end;

procedure TGenerateur_de_code.slApplicationTemplateHandler_from_sRepertoireApplicationTemplate;
begin
     ujpFile_EnumFiles( sRepertoireApplicationTemplate, slApplicationTemplateHandler_from_sRepertoireApplicationTemplate_FileFound);
end;

procedure TGenerateur_de_code.slApplicationTemplateHandler_Produit;
var
   I: TIterateur_TemplateHandler;
   ph: TTemplateHandler;
begin
     I:= slApplicationTemplateHandler.Iterateur;
     try
        while I.Continuer
        do
          begin
          if I.not_Suivant( ph) then continue;
          ph.Produit;
          end;
     finally
            FreeAndNil( I);
            end;
end;


procedure TGenerateur_de_code.Application_Create;
begin
     slEnumStrings_from_sRepertoireEnumStrings;
     slTypeMappings_from_sRepertoireTypeMappings;
     slApplicationJoinPointFile_from_sRepertoireListeTables;
     slApplicationEnumJoinPointFile_from_sRepertoireListeEnum;

     slApplicationTemplateHandler_from_sRepertoireApplicationTemplate;

     Application_Created:= True;
     slApplicationJoinPointFile.Initialise;
     slApplicationEnumJoinPointFile.Initialise;
end;

procedure TGenerateur_de_code.Application_Produit;
begin
     slApplicationJoinPointFile.Finalise;
     slApplicationJoinPointFile.To_Parametres( slParametres);

     slApplicationEnumJoinPointFile.Finalise;
     slApplicationEnumJoinPointFile.To_Parametres( slParametres);

     slApplicationTemplateHandler_Produit;
end;

procedure TGenerateur_de_code.Application_Destroy;
begin
     Application_Created:= False;
     slApplicationJoinPointFile.Vide;
     slApplicationEnumJoinPointFile.Vide;
     slApplicationTemplateHandler.Vide;
end;

procedure TGenerateur_de_code.Parametres_from_Postgres_Foreign_Key( _slNomTables: TStringList);
var
   slDetails     : TStringList;
   slSymetrics     : TStringList;
   slAggregations: TStringList;
   sl            : TslPostgres_Foreign_Key;

   nfDetails     : String;
   nfSymetrics     : String;

   I: Integer;
   NomTable: String;

   procedure Postgres;
   var
      iPFK: TIterateur_Postgres_Foreign_Key;
      bl: TblPostgres_Foreign_Key;
      Detail_Nom, Detail_Type: String;
      Symetric_Nom, Symetric_Type: String;
      nfAggregations: String;
      Aggregation_Nom, Aggregation_Type: String;
   begin
        iPFK:= sl.Iterateur;
        while iPFK.Continuer
        do
          begin
          if iPFK.not_Suivant( bl) then continue;

          Detail_Nom := bl.FOREIGN_KEY;
          Detail_Type:= bl.Reference_Table;
          slDetails.Values[Detail_Nom]:= Detail_Type;

          Symetric_Nom := bl.FOREIGN_KEY;
          Symetric_Type:= bl.Reference_Table;
          slSymetrics.Values[Symetric_Nom]:= Symetric_Type;

          nfAggregations:= sRepertoireParametres+bl.Reference_Table+'.Aggregations.txt';
          if FileExists( nfAggregations)
          then
              slAggregations.LoadFromFile( nfAggregations)
          else
              slAggregations.Clear;

          Aggregation_Nom := NomTable+'_'+bl.FOREIGN_KEY;
          Aggregation_Type:= NomTable;
          slAggregations.Values[Aggregation_Nom]:= Aggregation_Type;

          slAggregations.SaveToFile( nfAggregations);
          end;
   end;
begin
     if not sgbdPOSTGRES then exit;

     slDetails     := TStringList            .Create;
     slSymetrics   := TStringList            .Create;
     slAggregations:= TStringList            .Create;
     sl            := TslPostgres_Foreign_Key.Create( ClassName+'.Parametres_from_Postgres_Foreign_Key::sl');
     try
        for I:= 0 to _slNomTables.Count -1
        do
          begin
          NomTable:= _slNomTables[I];
          nfDetails:= sRepertoireParametres+NomTable+'.Details.txt';
          if FileExists( nfDetails)
          then
              slDetails.LoadFromFile( nfDetails)
          else
              slDetails.Clear;

          nfSymetrics:= sRepertoireParametres+NomTable+'.Symetrics.txt';
          if FileExists( nfSymetrics)
          then
              slSymetrics.LoadFromFile( nfSymetrics)
          else
              slSymetrics.Clear;

          poolPostgres_Foreign_Key.Charge_Table( NomTable, sl);
          Postgres;
          slDetails.SaveToFile( nfDetails);
          slSymetrics.SaveToFile( nfSymetrics);
          end;
     finally
            FreeAndNil( slDetails);
            FreeAndNil( slSymetrics);
            FreeAndNil( slAggregations);
            Free_nil( sl);
            end;

end;

procedure TGenerateur_de_code.Initialise(_a: array of TJoinPoint);
var
   I: Integer;
begin
     SetLength( a, Length(_a));
     for I:= Low( _a) to High( _a)
     do
       a[I]:= _a[I];
end;

initialization
finalization
              FreeAndNil( FGenerateur_de_code);
end.

