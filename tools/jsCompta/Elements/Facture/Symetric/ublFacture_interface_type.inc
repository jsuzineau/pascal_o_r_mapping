  { ThaFacture__Facture_Ligne }
  ThaFacture__Facture_Ligne
  =
   class( ThAggregation)
   //Gestion du cycle de vie
   public
     constructor Create( _Parent: TBatpro_Element;
                         _Classe_Elements: TBatpro_Element_Class;
                         _pool_Ancetre_Ancetre: Tpool_Ancetre_Ancetre); override;
     destructor  Destroy; override;
   //Parent
   public
     blFacture: TblFacture;  
   //Chargement de tous les détails
   public
     procedure Charge; override;
   //Suppression
   public
     procedure Delete_from_database; override;
   //Création d'itérateur
   protected
     class function Classe_Iterateur: TIterateur_Class; override;
   public
     function Iterateur: TIterateur_Facture_Ligne;
     function Iterateur_Decroissant: TIterateur_Facture_Ligne;
   //Total des lignes
   public
     function CalculeTotal: Double;
     procedure Montant_from_Total;
     function CalculeTotal_NbHeures: String;
     procedure NbHeures_from_Total_NbHeures;
   end;




 { TblFacture }

 TblFacture
 =
  class( TBatpro_Ligne)
  //Gestion du cycle de vie
  public
    constructor Create( _sl: TBatpro_StringList; _jsdc: TjsDataContexte; _pool: Tpool_Ancetre_Ancetre); override;
    destructor Destroy; override;
  //champs persistants
  public
    Annee          : Integer; cAnnee: TChamp;
    NumeroDansAnnee: Integer; cNumeroDansAnnee: TChamp;
    NbHeures: String; cNbHeures: TChamp;
  //Montant
  public
    Montant: Double; cMontant: TChamp;
    Montant_s: String; cMontant_s: TChamp;
    procedure Montant_s_GetChaine( var _Chaine: String);
  //Numero
  private
    FNumero: String;
    procedure Numero_from_;
    function GetNumero: String;
  public
    cNumero: TChamp;
    procedure Numero_GetChaine( var _Chaine: String);
    property Numero: String read GetNumero;
  //Date
  public
    Date: TDateTime; cDate: TChamp;
    procedure Date_from_Now;
  //Nom
  public
    Nom: String; cNom: TChamp;
    procedure Nom_from_;
  //Client
  private
    FClient_id: Integer;
    FClient_bl: TBatpro_Ligne;
    FClient: String;
    procedure SetClient_bl(const Value: TBatpro_Ligne);
    procedure SetClient_id(const Value: Integer);
    procedure Client_id_Change;
    procedure Client_Connecte;
    procedure Client_Aggrege;
    procedure Client_Desaggrege;
    procedure Client_Change;
  public
    cClient_id: TChamp;
    cClient: TChamp;
    property Client_id: Integer       read FClient_id write SetClient_id;
    property Client_bl: TBatpro_Ligne read FClient_bl write SetClient_bl;
    function Client: String;
  //Mois
  private
    FMois_id: Integer;
    FMois_bl: TBatpro_Ligne;
    FMois: String;
    procedure SetMois_bl(const Value: TBatpro_Ligne);
    procedure SetMois_id(const Value: Integer);
    procedure Mois_id_Change;
    procedure Mois_Connecte;
    procedure Mois_Aggrege;
    procedure Mois_Desaggrege;
    procedure Mois_Change;
  public
    cMois_id: TChamp;
    cMois: TChamp;
    property Mois_id: Integer       read FMois_id write SetMois_id;
    property Mois_bl: TBatpro_Ligne read FMois_bl write SetMois_bl;
    function Mois: String;

  //Piece
  private
    FPiece_id: Integer;
    FPiece_bl: TblPiece;
    FPiece: String;
    function  GetPiece_bl: TblPiece;
    procedure SetPiece_bl(const Value: TblPiece);
    procedure SetPiece_id(const Value: Integer);
    procedure Piece_id_Change;
    procedure Piece_Connecte;
  public
    procedure Piece_Aggrege;
  private
    procedure Piece_Desaggrege;
    procedure Piece_Change;
  public
    cPiece_id: TChamp;
    cPiece: TChamp;
    property Piece_id: Integer       read FPiece_id write SetPiece_id;
    property Piece_bl: TblPiece read GetPiece_bl write SetPiece_bl;
    function Piece: String;
    procedure Piece_Nouveau;
  //Gestion de la clé
  public
    class function sCle_from_( _Annee: Integer;  _NumeroDansAnnee: Integer): String;

    function sCle: String; override;
  //Gestion des déconnexions
  public
    procedure Unlink(be: TBatpro_Element); override;
  //Aggrégations
  protected
    procedure Create_Aggregation( Name: String; P: ThAggregation_Create_Params); override;
  //Aggrégation vers les Facture_Ligne correspondants
  private
    FhaFacture_Ligne: ThaFacture__Facture_Ligne;
    function GethaFacture_Ligne: ThaFacture__Facture_Ligne;
  public
    property haFacture_Ligne: ThaFacture__Facture_Ligne read GethaFacture_Ligne;
  //Pour impression
  public
    Label_Total: String;
    Label_TVA: String;

  end;

 TIterateur_Facture
 =
  class( TIterateur)
  //Iterateur
  public
    procedure Suivant( out _Resultat: TblFacture);
    function  not_Suivant( out _Resultat: TblFacture): Boolean;
  end;

 TslFacture
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
    function Iterateur: TIterateur_Facture;
    function Iterateur_Decroissant: TIterateur_Facture;
  end;

 { TpoolFacture }

 TpoolFacture
 =
  class( TPool)
    procedure DataModuleCreate(Sender: TObject);  override;
  //Filtre
  public
    hfFacture: ThfFacture;
  //Accés général
  public
    function Get( _id: integer): TblFacture;
  //Nouveau
  public
    function Nouveau: TblFacture;
  //Accés par clé
  protected
    procedure To_Params( _Params: TParams); override;
  public
    Annee: Integer;
    NumeroDansAnnee: Integer;

    function Get_by_Cle( _Annee: Integer;  _NumeroDansAnnee: Integer): TblFacture;
    function Assure( _Annee: Integer;  _NumeroDansAnnee: Integer): TblFacture;
  //Indépendance par rapport au SGBD Informix ou MySQL
  protected
    function SQLWHERE_ContraintesChamps: String; override;
  //Méthode de création de test
  public
    function Test( _Annee: Integer;  _NumeroDansAnnee: Integer;  _Date: TDatetime;  _Client_id: Integer;  _Nom: String;  _NbHeures:  String;   _Montant: Double):Integer;

  //Chargement d'un Client
  public
    procedure Charge_Client( _Client_id: Integer; _slLoaded: TBatpro_StringList = nil);
  //Chargement d'un Mois
  public
    procedure Charge_Mois( _Mois: TDateTime; _slLoaded: TBatpro_StringList = nil);

  //Chargement d'un Piece
  public
    procedure Charge_Piece( _Piece_id: Integer; _slLoaded: TBatpro_StringList = nil);

  //Chargement des factures sans Piece correspondante
  public
    procedure Charge_non_reglee( _slLoaded: TBatpro_StringList = nil);

  //Création d'itérateur
  protected
    class function Classe_Iterateur: TIterateur_Class; override;
  public
    function Iterateur: TIterateur_Facture;
    function Iterateur_Decroissant: TIterateur_Facture;
  //Nouveau numéro à partir de la détermination de la dernière facture
  public
    function MaxNumeroDansAnnee( _Annee: Integer=0): Integer;
    function Annee_Incoherente( _Annee: Integer=0): Boolean;
    function Annee_Incoherente_Message( _Annee: Integer=0): Boolean;
    function Nouveau_Numero( _Annee: Integer=0): Integer;
  end;


