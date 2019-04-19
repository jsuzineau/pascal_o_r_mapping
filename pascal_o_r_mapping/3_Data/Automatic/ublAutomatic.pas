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
    ujsDataContexte,
    uChampDefinition,
    uChamp,
    uChamps,
    uVide,
    uOD_Forms,

    uBatpro_Element,
    uBatpro_Ligne,

    //Code generation
    uPatternHandler,
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
  //Divers
  private
    a: array of TJoinPoint;
    procedure Initialise( _a: array of TJoinPoint);
  public
    bl: TBatpro_Ligne;
    procedure Execute( _bl: TBatpro_Ligne; _Suffixe: String);
  //Paramètres
  private
    slParametres: TBatpro_StringList;
  //PatternHandler
  public
    slPatternHandler: TslPatternHandler;
    procedure Cree_PatternHandler( var _Reference;
                                   _Source: String;
                                   _slParametres: TBatpro_StringList= nil); override; overload;
    function  Cree_PatternHandler( _Source: String;
                                   _slParametres: TBatpro_StringList= nil): TPatternHandler; overload;

  //Création des PatternHandler par lecture du répertoire de patterns
  private
    procedure slPatternHandler_from_sRepSource_FileFound( _FileIterator: TFileIterator);
  public
    procedure slPatternHandler_from_sRepSource;
    procedure slPatternHandler_Produit;
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
     FreeAndNil( slParametres);
     FreeAndNil( slPatternHandler);
     inherited Destroy;
end;

procedure TGenerateur_de_code.Execute( _bl: TBatpro_Ligne; _Suffixe: String);
var
   NomFichierProjet: String;
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
   phDPK       : TPatternHandler;

   phCS_ML     : TPatternHandler;

   phPHP_Doctrine_record: TPatternHandler;
   phPHP_Doctrine_table : TPatternHandler;

   phPHP_Perso_c     : TPatternHandler;
   phPHP_Perso_Delete: TPatternHandler;
   phPHP_Perso_Insert: TPatternHandler;
   phPHP_Perso_Set: TPatternHandler;
   }

   INI: TIniFile;

   //Gestion des détails
   NbDetails: Integer;
   nfDetails: String;
   slDetails:TStringList;

   //Gestion des aggrégations
   NbAggregations: Integer;
   nfAggregations: String;
   slAggregations:TStringList;

   {
   procedure CreePatternHandler( out phPAS, phDFM: TPatternHandler; Racine: String);
   var
      sRepRacine: String;
   begin
        sRepRacine:= s_RepertoirePascal_paquet+'u'+Racine+s_Nom_de_la_classe;
        phPAS:= Cree_PatternHandler(  sRepRacine+'.pas',slParametres);
        phDFM:= Cree_PatternHandler(  sRepRacine+'.dfm',slParametres);
   end;

   procedure CreePatternHandler_pool( out phPAS: TPatternHandler);
   var
      sRepRacine: String;
   begin
        sRepRacine:= s_RepertoirePascal_paquet+'upool'+s_Nom_de_la_classe;
        phPAS:= Cree_PatternHandler(  sRepRacine+'.pas',slParametres);
   end;

   procedure CreePatternHandler_BL( out phPAS: TPatternHandler);
   var
      sRepRacine: String;
   begin
        sRepRacine:= s_RepertoirePascal_paquet+'ubl'+s_Nom_de_la_classe;
        phPAS:= Cree_PatternHandler(  sRepRacine+'.pas',slParametres);
   end;

   procedure CreePatternHandler_HF( out phPAS: TPatternHandler);
   var
      sRepRacine: String;
   begin
        sRepRacine:= s_RepertoirePascal_paquet+'uhf'+s_Nom_de_la_classe;
        phPAS:= Cree_PatternHandler(  sRepRacine+'.pas',slParametres);
   end;

   procedure CreePatternHandler_TC( out phPAS: TPatternHandler);
   var
      sRepRacine: String;
   begin
        sRepRacine:= s_RepertoirePascal_dunit+'utc'+s_Nom_de_la_classe;
        phPAS:= Cree_PatternHandler(  sRepRacine+'.pas',slParametres);
   end;

   procedure CreePatternHandler_DPK( out phDPK: TPatternHandler);
   var
      sRepRacine: String;
   begin
        sRepRacine:= s_RepertoirePascal_paquet+'p'+s_Nom_de_la_classe;
        phDPK:= Cree_PatternHandler(  sRepRacine+'.dpk',slParametres);
   end;

   procedure CreePatternHandler_ML( out phCS: TPatternHandler);
   var
      sRepRacine: String;
   begin
        sRepRacine:= s_RepertoireCSharp+'Tml'+s_Nom_de_la_table;
        phCS:= Cree_PatternHandler(  sRepRacine+'.CS',slParametres);
   end;

   procedure CreePatternHandler_PHP_Doctrine( out phRecord, phTable: TPatternHandler);
   begin
        phRecord:= Cree_PatternHandler(  s_RepertoirePHP_Doctrine+    s_Nom_de_la_table+'.class.php',slParametres);
        phTable := Cree_PatternHandler(  s_RepertoirePHP_Doctrine+'t'+s_Nom_de_la_table+'.class.php',slParametres);
   end;

   procedure CreePatternHandler_PHP_Perso( out phPHP_Perso_c, phPHP_Perso_Delete, phPHP_Perso_Insert, phPHP_Perso_Set: TPatternHandler);
   begin
        phPHP_Perso_c     := Cree_PatternHandler(  s_RepertoirePHP_Perso+'cpool'+s_Nom_de_la_table+       '.php',slParametres);
        phPHP_Perso_Delete:= Cree_PatternHandler(  s_RepertoirePHP_Perso+        s_Nom_de_la_table+'_Delete.php',slParametres);
        phPHP_Perso_Insert:= Cree_PatternHandler(  s_RepertoirePHP_Perso+        s_Nom_de_la_table+'_Insert.php',slParametres);
        phPHP_Perso_Set   := Cree_PatternHandler(  s_RepertoirePHP_Perso+        s_Nom_de_la_table+   '_Set.php',slParametres);
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
           slParametres.Clear;

           uJoinPoint_Initialise( cc, a);

           I:= bl.Champs.sl.Iterateur;
           while I.Continuer
           do
             begin
             if I.not_Suivant_interne( C) then continue;
             Traite_Champ( C);
             end;

           //Gestion des détails
           slDetails:= TStringList.Create;
           try
              nfDetails:= sRepParametres+cc.Nom_de_la_classe+'.Details.txt';
              if FileExists( nfDetails)
              then
                  slDetails.LoadFromFile( nfDetails);
              NbDetails:= slDetails.Count;
              for J:= 0 to NbDetails-1
              do
                uJoinPoint_VisiteDetail( slDetails.Names[J],
                                         slDetails.ValueFromIndex[J],
                                         a);
           finally
                  slDetails.SaveToFile( nfDetails);
                  FreeAndNil( slDetails);
                  end;

           //Gestion des aggrégations
           slAggregations:= TStringList.Create;
           try
              nfAggregations:= sRepParametres+cc.Nom_de_la_classe+'.Aggregations.txt';
              if FileExists( nfAggregations)
              then
                  slAggregations.LoadFromFile( nfAggregations);
              NbAggregations:= slAggregations.Count;
              for J:= 0 to NbAggregations-1
              do
                uJoinPoint_VisiteAggregation( slAggregations.Names[J],
                                         slAggregations.ValueFromIndex[J],
                                         a);
           finally
                  slAggregations.SaveToFile( nfAggregations);
                  FreeAndNil( slAggregations);
                  end;

           //Fermeture des chaines
           uJoinPoint_Finalise( a);

           uJoinPoint_To_Parametres( slParametres, a);

           slPatternHandler_Produit;
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
     NomFichierProjet:= uOD_Forms_EXE_Name;
     INI
     :=
       TIniFile.Create( ChangeFileExt(EXE_INI.FileName,'_Generateur_de_code.ini'));
     try
        sRepSource     := INI.ReadString( 'Options', 'sRepSource'     ,ExtractFilePath(NomFichierProjet)+'Generateur_de_code'+PathDelim+'patterns'  +PathDelim);
        sRepParametres := INI.ReadString( 'Options', 'sRepParametres' ,ExtractFilePath(NomFichierProjet)+'Generateur_de_code'+PathDelim+'Parametres'+PathDelim);
        sRepCible      := INI.ReadString( 'Options', 'sRepCible'      ,ExtractFilePath(NomFichierProjet)+'Generateur_de_code'+PathDelim+'Source'    +PathDelim);
        sRepListeTables:= INI.ReadString( 'Options', 'sRepListeTables',ExtractFilePath(NomFichierProjet)+'Generateur_de_code'+PathDelim+'Listes'    +PathDelim+'Tables'+PathDelim);
        sRepListeChamps:= INI.ReadString( 'Options', 'sRepListeChamps',ExtractFilePath(NomFichierProjet)+'Generateur_de_code'+PathDelim+'Listes'    +PathDelim+'Champs'+PathDelim);
        ForceDirectories( sRepSource     );
        ForceDirectories( sRepParametres );
        ForceDirectories( sRepCible      );
        ForceDirectories( sRepListeTables);
        ForceDirectories( sRepListeChamps);
        INI.WriteString( 'Options', 'sRepSource', sRepSource);
        INI.WriteString( 'Options', 'sRepCible' , sRepCible );
        INI.WriteString( 'Options', 'sRepListeTables' , sRepListeTables);
        INI.WriteString( 'Options', 'sRepListeChamps' , sRepListeChamps);

        slLog.Clear;
        slParametres.Clear;
        slPatternHandler_from_sRepSource;

        {
        CreePatternHandler( phPAS_DMCRE, phDFM_DMCRE, 'dmxcre');
        CreePatternHandler( phPAS_F    , phDFM_F    , 'f'     );
        CreePatternHandler( phPAS_FCB  , phDFM_FCB  , 'fcb'   );
        CreePatternHandler( phPAS_DKD  , phDFM_DKD  , 'dkd'   );
        CreePatternHandler( phPAS_FD  , phDFM_FD  , 'fd'   );
        CreePatternHandler_pool( phPAS_POOL);
        CreePatternHandler_BL( phPAS_BL);
        CreePatternHandler_HF( phPAS_HF);
        CreePatternHandler_TC( phPAS_TC);
        CreePatternHandler_DPK( phDPK);

        CreePatternHandler_ML( phCS_ML);

        CreePatternHandler_PHP_Doctrine( phPHP_Doctrine_record, phPHP_Doctrine_table);
        CreePatternHandler_PHP_Perso( phPHP_Perso_c, phPHP_Perso_Delete, phPHP_Perso_Insert, phPHP_Perso_Set);
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
               slPatternHandler.Vide;
               end;
        slLog.SaveToFile( sRepCible+'suPatterns_from_MCD.log');
     finally
            FreeAndNil( INI);
            end;
end;

function TGenerateur_de_code.Cree_PatternHandler( _Source: String;
                                                  _slParametres: TBatpro_StringList= nil): TPatternHandler;
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
       PatternHandler_from_sl_sCle( slPatternHandler, _Source);
     if nil = Result
     then
         begin
         Result:= TPatternHandler.Create( Self, _Source, slParametres_local);
         slPatternHandler.AddObject( _Source, Result);
         end
     else
         Result.slParametres:= slParametres_local;
end;

procedure TGenerateur_de_code.Cree_PatternHandler( var _Reference;
                                                   _Source: String;
                                                   _slParametres: TBatpro_StringList= nil);
begin
     TPatternHandler(_Reference):= Cree_PatternHandler( _Source, _slParametres);
end;

procedure TGenerateur_de_code.slPatternHandler_from_sRepSource_FileFound( _FileIterator: TFileIterator);
var
   Source: String;
begin
     if _FileIterator.IsDirectory then exit;

     Source:= _FileIterator.FileName;
     Delete( Source, 1, Length( sRepSource));

     Cree_PatternHandler( Source);
end;

procedure TGenerateur_de_code.slPatternHandler_from_sRepSource;
var
   fs: TFileSearcher;
begin
     fs:= TFileSearcher.Create;
     try
        fs.OnFileFound:= slPatternHandler_from_sRepSource_FileFound;
        fs.Search( sRepSource, '*.*');
     finally
            FreeAndNil( fs);
            end;
end;

procedure TGenerateur_de_code.slPatternHandler_Produit;
var
   I: TIterateur_PatternHandler;
   ph: TPatternHandler;
begin
     I:= slPatternHandler.Iterateur;
     while I.Continuer
     do
       begin
       if I.not_Suivant( ph) then continue;
       ph.Produit;
       end;
end;

procedure TGenerateur_de_code.Application_Create;
begin
     MenuHandler                          := TMenuHandler                          .Create( Self);
     csMenuHandler                        := TcsMenuHandler                        .Create( Self);
     Angular_TypeScript_ApplicationHandler:= TAngular_TypeScript_ApplicationHandler.Create( Self);
     Application_Created:= True;
end;

procedure TGenerateur_de_code.Application_Produit;
begin
     MenuHandler                          .Produit;
     csMenuHandler                        .Produit;
     Angular_TypeScript_ApplicationHandler.Produit;
end;

procedure TGenerateur_de_code.Application_Destroy;
begin
     Application_Created:= False;
     FreeAndNil( MenuHandler                          );
     FreeAndNil( csMenuHandler                        );
     FreeAndNil( Angular_TypeScript_ApplicationHandler);
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
     slParametres:= TBatpro_StringList.Create;
     slPatternHandler:= TslPatternHandler.Create( ClassName+'.slPatternHandler');
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
