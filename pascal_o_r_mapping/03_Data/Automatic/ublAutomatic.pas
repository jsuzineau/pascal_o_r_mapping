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

    uBatpro_Element,
    uBatpro_Ligne,
    ublPostgres_Foreign_Key,

    upoolPostgres_Foreign_Key,

    //Code generation
    uTemplateHandler,
    uMenuHandler,
    ucsMenuHandler,
    uAngular_TypeScript_ApplicationHandler,
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
    ujpPascal_aggregation_classe_declaration,
    ujpPascal_aggregation_declaration,
    ujpPascal_aggregation_classe_implementation,
    ujpPascal_aggregation_Create_Aggregation_implementation,
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

    SysUtils, Classes, DB, Inifiles, FileUtil;

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
  //jpfMembre
  public
    sljpfMembre: TsljpfMembre;
    function  Cree_jpfMembre( _nfKey: String): TjpFile;
  //Création des jpfMembre par lecture du répertoire de listes de membres
  private
    procedure sljpfMembre_from_sRepertoireListeMembres_FileFound( _FileIterator: TFileIterator);
  public
    procedure sljpfMembre_from_sRepertoireListeMembres;
    procedure sljpFile_Produit;
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
    MenuHandler                          : TMenuHandler;
    csMenuHandler                        : TcsMenuHandler;
    Angular_TypeScript_ApplicationHandler: TAngular_TypeScript_ApplicationHandler;
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

destructor TGenerateur_de_code.Destroy;
begin
     FreeAndNil( sljpfMembre);
     FreeAndNil( slApplicationJoinPointFile);
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
        sRepertoireListeTables        := iRead( 'sRepertoireListeTables',Path+'01_Listes'             +PathDelim+'Tables'+PathDelim);
        sRepertoireListeMembres       := iRead( 'sRepertoireListeMembres',Path+'01_Listes'             +PathDelim+'Champs'+PathDelim);
        sRepertoireTemplate           := iRead( 'sRepertoireTemplate'   ,Path+'03_Template'           +PathDelim);
        sRepertoireParametres         := iRead( 'sRepertoireParametres' ,Path+'04_Parametres'         +PathDelim);
        sRepertoireApplicationTemplate:= iRead( 'sApplicationTemplate'  ,Path+'05_ApplicationTemplate'+PathDelim);
        sRepertoireResultat           := iRead( 'sRepertoireResultat'   ,Path+'06_Resultat'           +PathDelim);
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

   //Gestion des détails
   NbDetails: Integer;
   nfDetails: String;
   slDetails:TStringList;

   //Gestion des aggrégations
   NbAggregations: Integer;
   nfAggregations: String;
   slAggregations:TStringList;

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
           sljpfMembre.VisiteMembre( cm);
        finally
               FreeAndNil( cm);
               end;
   end;
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
   procedure Visite;
   var
      I: TIterateur_Champ;
      J: Integer;
      C: TChamp;
   begin
        cc:= TContexteClasse.Create( Self, _Suffixe,
                                     bl.Champs.ChampDefinitions.Persistant_Count);
        try
           slApplicationJoinPointFile.VisiteClasse( cc);
           slParametres.Clear;

           uJoinPoint_Initialise( cc, a);
           sljpfMembre.Initialise( cc);

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
                begin
                uJoinPoint_VisiteDetail( slDetails.Names[J],
                                         slDetails.ValueFromIndex[J],
                                         a);
                sljpfMembre.VisiteDetail( slDetails.Names[J],
                                       slDetails.ValueFromIndex[J]);
                end;
           finally
                  slDetails.SaveToFile( nfDetails);
                  FreeAndNil( slDetails);
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
                begin
                uJoinPoint_VisiteAggregation( slAggregations.Names[J],
                                         slAggregations.ValueFromIndex[J],
                                         a);
                sljpfMembre.VisiteAggregation( slAggregations.Names[J],
                                            slAggregations.ValueFromIndex[J]);
                end;
           finally
                  slAggregations.SaveToFile( nfAggregations);
                  FreeAndNil( slAggregations);
                  end;

           //Fermeture des chaines
           uJoinPoint_Finalise( a);
           sljpfMembre.Finalise;

           uJoinPoint_To_Parametres( slParametres, a);
           sljpfMembre.To_Parametres( slParametres);

           slTemplateHandler_Produit;
           //Produit;
           slLog.Add( 'aprés Produit');
           MenuHandler                          .Add( cc.Nom_de_la_table, NbDetails = 0);
           csMenuHandler                        .Add( cc.Nom_de_la_table, NbDetails = 0, True(*cc.CalculeSaisi_*));
           Angular_TypeScript_ApplicationHandler.Add( cc, NbDetails = 0);
           slLog.Add( 'MenuHandler.Add');
        finally
               FreeAndNil( cc)
               end;
   end;
begin
     bl:= _bl;
     slLog.Clear;
     slParametres.Clear;
     sljpfMembre_from_sRepertoireListeMembres;
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

procedure ublAutomatic_EnumFiles( _sRepertoire: String; _ffe: TFileFoundEvent; _Mask: String= '*.*');
var
   fs: TFileSearcher;
begin
     fs:= TFileSearcher.Create;
     try
        fs.OnFileFound:= _ffe;
        fs.Search( _sRepertoire, _Mask);
     finally
            FreeAndNil( fs);
            end;
end;

function TGenerateur_de_code.Cree_jpfMembre(_nfKey: String): TjpFile;
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
     ublAutomatic_EnumFiles( sRepertoireListeMembres, sljpfMembre_from_sRepertoireListeMembres_FileFound, s_key_mask);
end;

procedure TGenerateur_de_code.sljpFile_Produit;
begin

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
     ublAutomatic_EnumFiles( sRepertoireListeTables, slApplicationJoinPointFile_from_sRepertoireListeTables_FileFound, s_key_mask);
end;

procedure TGenerateur_de_code.slApplicationJoinPointFile_Produit;
begin

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
     ublAutomatic_EnumFiles( sRepertoireTemplate, slTemplateHandler_from_sRepertoireTemplate_FileFound);
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
     ublAutomatic_EnumFiles( sRepertoireApplicationTemplate, slApplicationTemplateHandler_from_sRepertoireApplicationTemplate_FileFound);
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
     slApplicationJoinPointFile_from_sRepertoireListeTables;
     MenuHandler                          := TMenuHandler                          .Create( Self);
     csMenuHandler                        := TcsMenuHandler                        .Create( Self);
     Angular_TypeScript_ApplicationHandler:= TAngular_TypeScript_ApplicationHandler.Create( Self);

     slApplicationTemplateHandler_from_sRepertoireApplicationTemplate;

     Application_Created:= True;
     slApplicationJoinPointFile.Initialise;
end;

procedure TGenerateur_de_code.Application_Produit;
begin
     slApplicationJoinPointFile.Finalise;
     slApplicationJoinPointFile.To_Parametres( slParametres);
     MenuHandler                          .Produit;
     csMenuHandler                        .Produit;
     Angular_TypeScript_ApplicationHandler.Produit;
     slApplicationTemplateHandler_Produit;
end;

procedure TGenerateur_de_code.Application_Destroy;
begin
     Application_Created:= False;
     slApplicationJoinPointFile.Vide;
     FreeAndNil( MenuHandler                          );
     FreeAndNil( csMenuHandler                        );
     FreeAndNil( Angular_TypeScript_ApplicationHandler);
     slApplicationTemplateHandler.Vide;
end;

procedure TGenerateur_de_code.Parametres_from_Postgres_Foreign_Key( _slNomTables: TStringList);
var
   slDetails     : TStringList;
   slAggregations: TStringList;
   sl            : TslPostgres_Foreign_Key;

   nfDetails     : String;

   I: Integer;
   NomTable: String;

   procedure Postgres;
   var
      iPFK: TIterateur_Postgres_Foreign_Key;
      bl: TblPostgres_Foreign_Key;
      Detail_Nom, Detail_Type: String;
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

          poolPostgres_Foreign_Key.Charge_Table( NomTable, sl);
          Postgres;
          slDetails.SaveToFile( nfDetails);
          end;
     finally
            FreeAndNil( slDetails);
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


constructor TGenerateur_de_code.Create;
begin
     inherited Create;
     _From_INI;
     sljpfMembre                    := TsljpFile                  .Create( ClassName+'.sljpFile'         );
     slApplicationJoinPointFile  := TslApplicationJoinPointFile.Create( ClassName+'.slApplicationJoinPointFile'         );
     slTemplateHandler           := TslTemplateHandler         .Create( ClassName+'.slTemplateHandler');
     slParametres                := TBatpro_StringList         .Create;
     slApplicationTemplateHandler:= TslTemplateHandler         .Create( ClassName+'.slApplicationTemplateHandler');
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
                jpPascal_aggregation_classe_declaration,
                jpPascal_aggregation_declaration,
                jpPascal_aggregation_classe_implementation,
                jpPascal_aggregation_Create_Aggregation_implementation,
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

initialization
finalization
              FreeAndNil( FGenerateur_de_code);
end.
