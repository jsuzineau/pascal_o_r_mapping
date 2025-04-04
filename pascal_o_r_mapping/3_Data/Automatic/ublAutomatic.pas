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

    SysUtils, Classes, DB, Inifiles;

type
 { TFieldBuffer }

 TFieldBuffer
 =
  class( TBatpro_Element)
  //Gestion du cycle de vie
  public
    constructor Create( _sl: TBatpro_StringList; _Champs: TChamps; _F: TField);
    destructor Destroy; override;
  //Attributs
  public
    Champs: TChamps;
    C: TChamp;
    F: TField;
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
    constructor Create( _sl: TBatpro_StringList; _q: TDataset; _pool: Tpool_Ancetre_Ancetre); override;
    destructor Destroy; override;
  //Attributs
  public
    q: TDataset;
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
                                 _F: TField);
begin
     inherited Create( _sl);
     Champs:= _Champs;
     F:= _F;
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
     C:= Champs.String_from_( Value, F.FieldName);
end;

{ TIntegerFieldBuffer }

procedure TIntegerFieldBuffer.Traite;
begin
     inherited Traite;
     C:= Champs.Integer_from_( Value, F.FieldName);
end;

{ TDateTimeFieldBuffer }

procedure TDateTimeFieldBuffer.Traite;
begin
     inherited Traite;
     C:= Champs.DateTime_from_( Value, F.FieldName);
end;

{ TDoubleFieldBuffer }

procedure TDoubleFieldBuffer.Traite;
begin
     inherited Traite;
     C:= Champs.Double_from_( Value, F.FieldName);
end;

{ TCurrencyFieldBuffer }

procedure TCurrencyFieldBuffer.Traite;
begin
     inherited Traite;
     C:= Champs.Currency_from_( Value, F.FieldName);
end;

{ TBooleanFieldBuffer }

procedure TBooleanFieldBuffer.Traite;
begin
     inherited Traite;
     C:= Champs.Boolean_from_( Value, F.FieldName);
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
                                 _q: TDataset;
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

     inherited Create(_sl, _q, _pool);

     q:= _q;
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
   I: Integer;
   F: TField;
   fb: TFieldBuffer;
begin
     if q = nil then exit;

     for I:= 0 to q.FieldCount-1
     do
       begin
       F:= q.Fields.Fields[I];
       if F = nil then continue;
       if     ('id'      = F.FieldName)
          and (
                 (ftInteger = F.DataType )
              or (ftAutoInc = F.DataType )
              )
       then
           continue;

       case F.DataType
       of
         ftFixedChar,
         ftString   ,
         ftMemo     ,
         ftGuid     ,
         ftBlob     : fb:= TStringFieldBuffer  .Create( sl, Champs, F);
         ftDate     : fb:= TDateTimeFieldBuffer.Create( sl, Champs, F);
         ftAutoInc  ,
         ftInteger  ,
         ftSmallint : fb:= TIntegerFieldBuffer .Create( sl, Champs, F);
         ftBCD      : fb:= TDoubleFieldBuffer  .Create( sl, Champs, F);
         ftDateTime ,
         ftTimeStamp: fb:= TDateTimeFieldBuffer.Create( sl, Champs, F);
         ftFloat    : fb:= TDoubleFieldBuffer  .Create( sl, Champs, F);
         ftCurrency : fb:= TCurrencyFieldBuffer.Create( sl, Champs, F);
         ftBoolean  : fb:= TBooleanFieldBuffer .Create( sl, Champs, F);
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
     inherited Destroy;
end;

procedure TGenerateur_de_code.Execute( _bl: TBatpro_Ligne; _Suffixe: String);
var
   NomFichierProjet: String;
   cc: TContexteClasse;
   sTaggedValues: String;

   phPAS_DMCRE,
   phPAS_POOL ,
   phPAS_F    ,
   phPAS_FCB  ,
   phPAS_DKD  ,

   phDFM_DMCRE,
   phDFM_POOL ,
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

   slParametres: TBatpro_StringList;

   MenuHandler: TMenuHandler;

   INI: TIniFile;

   //Gestion des détails
   NbDetails: Integer;
   nfDetails: String;
   slDetails:TStringList;

   //Gestion des aggrégations
   NbAggregations: Integer;
   nfAggregations: String;
   slAggregations:TStringList;

   procedure CreePatternHandler( var phPAS, phDFM: TPatternHandler; Racine: String);
   var
      sRepRacine: String;
   begin
        sRepRacine:= sRepSource+'u'+Racine+s_Nom_de_la_classe;
        phPAS:= TPatternHandler.Create( sRepRacine+'.pas',sRepCible,slParametres);
        phDFM:= TPatternHandler.Create( sRepRacine+'.dfm',sRepCible,slParametres);
   end;

   procedure CreePatternHandler_BL( var phPAS: TPatternHandler);
   var
      sRepRacine: String;
   begin
        sRepRacine:= sRepSource+'ubl'+s_Nom_de_la_classe;
        phPAS:= TPatternHandler.Create( sRepRacine+'.pas',sRepCible,slParametres);
   end;

   procedure CreePatternHandler_HF( var phPAS: TPatternHandler);
   var
      sRepRacine: String;
   begin
        sRepRacine:= sRepSource+'uhf'+s_Nom_de_la_classe;
        phPAS:= TPatternHandler.Create( sRepRacine+'.pas',sRepCible,slParametres);
   end;

   procedure CreePatternHandler_TC( var phPAS: TPatternHandler);
   var
      sRepRacine: String;
   begin
        sRepRacine:= sRepSource+'utc'+s_Nom_de_la_classe;
        phPAS:= TPatternHandler.Create( sRepRacine+'.pas',sRepCible+'dunit'+PathDelim,slParametres);
   end;

   procedure CreePatternHandler_DPK( var phDPK: TPatternHandler);
   var
      sRepRacine: String;
   begin
        sRepRacine:= sRepSource+'p'+s_Nom_de_la_classe;
        phDPK:= TPatternHandler.Create( sRepRacine+'.dpk',sRepCible,slParametres);
   end;

   procedure CreePatternHandler_ML( var phCS: TPatternHandler);
   var
      sRepRacine: String;
   begin
        sRepRacine:= sRepSource+'Tml'+s_Nom_de_la_table;
        phCS:= TPatternHandler.Create( sRepRacine+'.CS',sRepCible,slParametres);
   end;

   procedure CreePatternHandler_PHP_Doctrine( var phRecord, phTable: TPatternHandler);
   var
      sRepSource_PHP_Doctrine: String;
   begin
        sRepSource_PHP_Doctrine:= sRepSource+'PHP'+PathDelim+'Doctrine'+PathDelim;
        phRecord:= TPatternHandler.Create( sRepSource_PHP_Doctrine+s_Nom_de_la_table+'.class.php',sRepCible,slParametres);
        phTable := TPatternHandler.Create( sRepSource_PHP_Doctrine+'t'+s_Nom_de_la_table+'.class.php',sRepCible,slParametres);
   end;

   procedure CreePatternHandler_PHP_Perso( var phPHP_Perso_c, phPHP_Perso_Delete, phPHP_Perso_Insert, phPHP_Perso_Set: TPatternHandler);
   var
      sRepSource_PHP_Perso: String;
   begin
        sRepSource_PHP_Perso:= sRepSource+'PHP'+PathDelim+'Perso'+PathDelim;
        phPHP_Perso_c     := TPatternHandler.Create( sRepSource_PHP_Perso+'cpool'+s_Nom_de_la_table+       '.php',sRepCible,slParametres);
        phPHP_Perso_Delete:= TPatternHandler.Create( sRepSource_PHP_Perso+        s_Nom_de_la_table+'_Delete.php',sRepCible,slParametres);
        phPHP_Perso_Insert:= TPatternHandler.Create( sRepSource_PHP_Perso+        s_Nom_de_la_table+'_Insert.php',sRepCible,slParametres);
        phPHP_Perso_Set   := TPatternHandler.Create( sRepSource_PHP_Perso+        s_Nom_de_la_table+   '_Set.php',sRepCible,slParametres);
   end;

   procedure Traite_Champ( _C: TChamp);
   var
      d: TChampDefinition;
      sNomChamp: String;
      cm: TContexteMembre;
      sParametre: String;
      sDeclarationParametre: String;
   begin
        d:= _C.Definition;
        if not d.Persistant then exit;//pour éviter le champ Selected

        sNomChamp:= d.Nom;
        if 'id' = LowerCase( sNomChamp) then exit;

        cm:= TContexteMembre.Create( Self, cc, sNomChamp, d.sType, '');
        //cm:= TContexteMembre.Create( cc, _fb.F.FieldName, _fb.sType, '');
        try
           uJoinPoint_VisiteMembre( cm, a);

           sParametre:= ' _'+cm.sNomChamp;
           sDeclarationParametre:= sParametre+': '+cm.sTyp;
           finally
                  FreeAndNil( cm);
                  end;
   end;
   procedure Produit;
   var
      RepertoirePascal: String;
      RepertoireCSharp: String;
      RepertoirePHP_Doctrine: String;
      RepertoirePHP_Perso   : String;

      RepertoirePaquet: String;
   begin
        RepertoirePascal      := 'Pascal'                            +PathDelim;
        RepertoirePaquet      := RepertoirePascal+cc.Nom_de_la_classe+PathDelim;
        RepertoireCSharp      := 'CSharp'                            +PathDelim;
        RepertoirePHP_Doctrine:= 'PHP'+PathDelim+'Doctrine'          +PathDelim;
        RepertoirePHP_Perso   := 'PHP'+PathDelim+'Perso'             +PathDelim;

        phPAS_DMCRE.Produit( RepertoirePascal);
        phPAS_POOL .Produit( RepertoirePaquet);
        phPAS_F    .Produit( RepertoirePascal);
        phPAS_FCB  .Produit( RepertoirePascal);
        phPAS_DKD  .Produit( RepertoirePascal);

        phDFM_DMCRE.Produit( RepertoirePascal);
        phDFM_POOL .Produit( RepertoirePaquet);
        phDFM_F    .Produit( RepertoirePascal);
        phDFM_FCB  .Produit( RepertoirePascal);
        phDFM_DKD  .Produit( RepertoirePascal);

        phDFM_FD   .Produit( RepertoirePaquet);
        phPAS_FD   .Produit( RepertoirePaquet);

        phPAS_BL   .Produit( RepertoirePaquet);
        phPAS_HF   .Produit( RepertoirePaquet);
        phPAS_TC   .Produit( RepertoirePascal);
        phDPK      .Produit( RepertoirePaquet);

        phCS_ML    .Produit( RepertoireCSharp);

        phPHP_Doctrine_record.Produit(RepertoirePHP_Doctrine);
        phPHP_Doctrine_table .Produit(RepertoirePHP_Doctrine);

        phPHP_Perso_c     .Produit(RepertoirePHP_Perso);
        phPHP_Perso_Delete.Produit(RepertoirePHP_Perso);
        phPHP_Perso_Insert.Produit(RepertoirePHP_Perso);
        phPHP_Perso_Set.Produit(RepertoirePHP_Perso);
   end;
   procedure Visite;
   var
      I: TIterateur_Champ;
      J: Integer;
      fb: TFieldBuffer;
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

           Produit;
           //slLog.Add( 'aprés Produit');
           //csMenuHandler.Add( cc.NomTable, NbDetails = 0, cc.CalculeSaisi_);
           //slLog.Add( 'MenuHandler.Add');
        finally
               FreeAndNil( cc)
               end;
   end;
begin
     bl:= _bl;
     NomFichierProjet:= uOD_Forms_EXE_Name;
     INI
     :=
       TIniFile.Create( ChangeFileExt(NomFichierProjet,'_Dico_Delphi.ini'));
     try
        sRepSource    := INI.ReadString( 'Options', 'sRepSource'    ,ExtractFilePath(NomFichierProjet)+'Generateur_de_code'+PathDelim+'patterns'  +PathDelim);
        sRepParametres:= INI.ReadString( 'Options', 'sRepParametres',ExtractFilePath(NomFichierProjet)+'Generateur_de_code'+PathDelim+'Parametres'+PathDelim);
        sRepCible     := INI.ReadString( 'Options', 'sRepCible'     ,ExtractFilePath(NomFichierProjet)+'Generateur_de_code'+PathDelim+'Source'    +PathDelim);
        INI.WriteString( 'Options', 'sRepSource', sRepSource);
        INI.WriteString( 'Options', 'sRepCible' , sRepCible );

        slParametres:= TBatpro_StringList.Create;
        slLog.Clear;
        try
           CreePatternHandler( phPAS_DMCRE, phDFM_DMCRE, 'dmxcre');
           CreePatternHandler( phPAS_POOL , phDFM_POOL , 'pool'  );
           CreePatternHandler( phPAS_F    , phDFM_F    , 'f'     );
           CreePatternHandler( phPAS_FCB  , phDFM_FCB  , 'fcb'   );
           CreePatternHandler( phPAS_DKD  , phDFM_DKD  , 'dkd'   );
           CreePatternHandler( phPAS_FD  , phDFM_FD  , 'fd'   );
           CreePatternHandler_BL( phPAS_BL);
           CreePatternHandler_HF( phPAS_HF);
           CreePatternHandler_TC( phPAS_TC);
           CreePatternHandler_DPK( phDPK);
           CreePatternHandler_ML( phCS_ML);
           CreePatternHandler_PHP_Doctrine( phPHP_Doctrine_record, phPHP_Doctrine_table);
           CreePatternHandler_PHP_Perso( phPHP_Perso_c, phPHP_Perso_Delete, phPHP_Perso_Insert, phPHP_Perso_Set);
           MenuHandler:= TMenuHandler.Create( sRepSource, sRepCible);

           try
              S:= '';
              Premiere_Classe:= True;

              Visite;

              //csMenuHandler.Produit;
              slLog.Add( S);
           finally
                  FreeAndNil( MenuHandler);
                  FreeAndNil( phPAS_DMCRE);
                  FreeAndNil( phPAS_POOL );
                  FreeAndNil( phPAS_F    );
                  FreeAndNil( phPAS_FCB  );
                  FreeAndNil( phPAS_DKD  );

                  FreeAndNil( phDFM_DMCRE);
                  FreeAndNil( phDFM_POOL );
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
       end;
        finally
               slLog.SaveToFile( sRepCible+'suPatterns_from_MCD.log');
               FreeAndNil( slParametres);
               end;
     finally
            FreeAndNil( INI);
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
                jpPHP_Doctrine_HasOne
                ]
                );
end;

initialization
finalization
              FreeAndNil( FGenerateur_de_code);
end.
