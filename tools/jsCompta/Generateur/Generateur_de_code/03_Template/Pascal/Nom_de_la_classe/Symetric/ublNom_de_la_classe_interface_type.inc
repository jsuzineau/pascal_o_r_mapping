//pattern_aggregation_classe_declaration

 { TblNom_de_la_classe }

 TblNom_de_la_classe
 =
  class( TBatpro_Ligne)
  //Gestion du cycle de vie
  public
    constructor Create( _sl: TBatpro_StringList; _jsdc: TjsDataContexte; _pool: Tpool_Ancetre_Ancetre); override;
    destructor Destroy; override;
  //champs persistants
  public
//pattern_declaration_champs
//Pascal_ubl_declaration_pas_detail
//pattern_Symetrics_Pascal_ubl_declaration_pas
  //Gestion de la clé
  public
//pattern_sCle_from__Declaration
    function sCle: String; override;
  //Gestion des déconnexions
  public
    procedure Unlink(be: TBatpro_Element); override;
//pattern_aggregation_function_Create_Aggregation_declaration
  end;

 TIterateur_Nom_de_la_classe
 =
  class( TIterateur)
  //Iterateur
  public
    procedure Suivant( out _Resultat: TblNom_de_la_classe);
    function  not_Suivant( out _Resultat: TblNom_de_la_classe): Boolean;
  end;

 TslNom_de_la_classe
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
    function Iterateur: TIterateur_Nom_de_la_classe;
    function Iterateur_Decroissant: TIterateur_Nom_de_la_classe;
  end;

 { TpoolNom_de_la_classe }

 TpoolNom_de_la_classe
 =
  class( TPool)
    procedure DataModuleCreate(Sender: TObject);  override;
  //Filtre
  public
    hfNom_de_la_classe: ThfNom_de_la_classe;
  //Accés général
  public
    function Get( _id: integer): TblNom_de_la_classe;
  //Nouveau
  public
    function Nouveau: TblNom_de_la_classe;
  //Accés par clé
  protected
    procedure To_Params( _Params: TParams); override;
  public
//pattern_Declaration_cle
//pattern_Get_by_Cle_Declaration
//pattern_Assure_Declaration
  //Indépendance par rapport au SGBD Informix ou MySQL
  protected
    function SQLWHERE_ContraintesChamps: String; override;
  //Méthode de création de test
  public
{Test_Declaration_Key}
//Details_Pascal_upool_charge_detail_declaration_pas
//pattern_Symetrics_Pascal_upool_charge_declaration_pas
  //Création d'itérateur
  protected
    class function Classe_Iterateur: TIterateur_Class; override;
  public
    function Iterateur: TIterateur_Nom_de_la_classe;
    function Iterateur_Decroissant: TIterateur_Nom_de_la_classe;
  end;


