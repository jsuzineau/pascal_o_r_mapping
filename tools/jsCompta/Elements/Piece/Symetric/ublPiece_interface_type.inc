//pattern_aggregation_classe_declaration

 { TblPiece }

 TblPiece
 =
  class( TBatpro_Ligne)
  //Gestion du cycle de vie
  public
    constructor Create( _sl: TBatpro_StringList; _jsdc: TjsDataContexte; _pool: Tpool_Ancetre_Ancetre); override;
    destructor Destroy; override;
  //champs persistants
  public
    Date: TDateTime; cDate: TChamp;
    Numero: Integer;
  //Mois
  private
    FMois_bl: TBatpro_Ligne;
    FMois: String;
    procedure SetMois_bl(const Value: TBatpro_Ligne);
    procedure Mois_Connecte;
    procedure Mois_Desaggrege;
  public
    cMois: TChamp;
    property Mois_bl: TBatpro_Ligne read FMois_bl write SetMois_bl;
    function Mois: String;

  //Facture
  private
    FFacture_id: Integer;
    FFacture_bl: TblFacture;
    FFacture: String;
    function  GetFacture_bl: TblFacture;
    procedure SetFacture_bl(const Value: TblFacture);
    procedure SetFacture_id(const Value: Integer);
    procedure Facture_id_Change;
    procedure Facture_Connecte;
  public
    procedure Facture_Aggrege;
  private
    procedure Facture_Desaggrege;
    procedure Facture_Change;
  public
    cFacture_id: TChamp;
    cFacture: TChamp;
    property Facture_id: Integer    read FFacture_id write SetFacture_id;
    property Facture_bl: TblFacture read GetFacture_bl write SetFacture_bl;
    function Facture: String;

  //Gestion de la clé
  public
    class function sCle_from_( _Numero: Integer): String;

    function sCle: String; override;
  //Gestion des déconnexions
  public
    procedure Unlink(be: TBatpro_Element); override;
//pattern_aggregation_function_Create_Aggregation_declaration
  end;

 TIterateur_Piece
 =
  class( TIterateur)
  //Iterateur
  public
    procedure Suivant( out _Resultat: TblPiece);
    function  not_Suivant( out _Resultat: TblPiece): Boolean;
  end;

 TslPiece
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
    function Iterateur: TIterateur_Piece;
    function Iterateur_Decroissant: TIterateur_Piece;
  end;

 { TpoolPiece }

 TpoolPiece
 =
  class( TPool)
    procedure DataModuleCreate(Sender: TObject);  override;
  //Filtre
  public
    hfPiece: ThfPiece;
  //Accés général
  public
    function Get( _id: integer): TblPiece;
  //Nouveau
  public
    function Nouveau: TblPiece;
  //Accés par clé
  protected
    procedure To_Params( _Params: TParams); override;
  public
    Numero: Integer;

    function Get_by_Cle( _Numero: Integer): TblPiece;
    function Assure( _Numero: Integer): TblPiece;
  //Indépendance par rapport au SGBD Informix ou MySQL
  protected
    function SQLWHERE_ContraintesChamps: String; override;
  //Méthode de création de test
  public
    function Test( _Facture_id: Integer;  _Date: TDateTime;  _Numero: Integer):Integer;

  //Chargement d'un Mois
  public
    procedure Charge_Mois( _Annee, _Mois: Integer; _slLoaded: TBatpro_StringList = nil);

  //Chargement d'un Facture
  public
    procedure Charge_Facture( _Facture_id: Integer; _slLoaded: TBatpro_StringList = nil);

  //Création d'itérateur
  protected
    class function Classe_Iterateur: TIterateur_Class; override;
  public
    function Iterateur: TIterateur_Piece;
    function Iterateur_Decroissant: TIterateur_Piece;
  //Nouveau numéro à partir de la détermination de la dernière pièce
  public
    function MinNumero: Integer;
    function MaxNumero: Integer;
    function Numeros_Incoherents: Boolean;
    function Numeros_Incoherents_Message: Boolean;
    function Nouveau_Numero: Integer;
  end;


