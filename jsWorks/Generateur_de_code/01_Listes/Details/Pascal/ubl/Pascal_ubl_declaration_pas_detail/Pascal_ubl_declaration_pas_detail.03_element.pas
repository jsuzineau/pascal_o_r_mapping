  //Detail.NomDetail
  private
    FDetail.NomDetail_id: Integer;
    FDetail.NomDetail_bl: TBatpro_Ligne;
    FDetail.NomDetail: String;
    procedure SetDetail.NomDetail_bl(const Value: TBatpro_Ligne);
    procedure SetDetail.NomDetail_id(const Value: Integer);
    procedure Detail.NomDetail_id_Change;
    procedure Detail.NomDetail_Connecte;
    procedure Detail.NomDetail_Aggrege;
    procedure Detail.NomDetail_Desaggrege;
    procedure Detail.NomDetail_Change;
  public
    cDetail.NomDetail_id: TChamp;
    property Detail.NomDetail_id: Integer       read FDetail.NomDetail_id write SetDetail.NomDetail_id;
    property Detail.NomDetail_bl: TBatpro_Ligne read FDetail.NomDetail_bl write SetDetail.NomDetail_bl;
    function Detail.NomDetail: String;

