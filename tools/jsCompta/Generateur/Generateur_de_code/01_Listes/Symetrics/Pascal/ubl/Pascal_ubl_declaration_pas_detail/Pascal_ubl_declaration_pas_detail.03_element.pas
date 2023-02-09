  //Symetric.NomSymetric
  private
    FSymetric.NomSymetric_id: Integer;
    FSymetric.NomSymetric_bl: TblSymetric.ClasseSymetric;
    FSymetric.NomSymetric: String;
    procedure SetSymetric.NomSymetric_bl(const Value: TblSymetric.ClasseSymetric);
    procedure SetSymetric.NomSymetric_id(const Value: Integer);
    procedure Symetric.NomSymetric_id_Change;
    procedure Symetric.NomSymetric_Connecte;
    procedure Symetric.NomSymetric_Aggrege;
    procedure Symetric.NomSymetric_Desaggrege;
    procedure Symetric.NomSymetric_Change;
  public
    cSymetric.NomSymetric_id: TChamp;
    cSymetric.NomSymetric: TChamp;
    property Symetric.NomSymetric_id: Integer       read FSymetric.NomSymetric_id write SetSymetric.NomSymetric_id;
    property Symetric.NomSymetric_bl: TblSymetric.ClasseSymetric read FSymetric.NomSymetric_bl write SetSymetric.NomSymetric_bl;
    function Symetric.NomSymetric: String;

