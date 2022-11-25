  //Detail.NomDetail
  private
    FidDetail.NomDetail: Integer;
    FblDetail.NomDetail: TBatpro_Ligne;
    FDetail.NomDetail: String;
    procedure SetblDetail.NomDetail(const Value: TBatpro_Ligne);
    procedure SetidDetail.NomDetail(const Value: Integer);
    procedure idDetail.NomDetail_Change;
    procedure Detail.NomDetail_Connecte;
    procedure Detail.NomDetail_Aggrege;
    procedure Detail.NomDetail_Desaggrege;
    procedure Detail.NomDetail_Change;
  public
    cidDetail.NomDetail: TChamp;
    property idDetail.NomDetail: Integer read FidDetail.NomDetail write SetidDetail.NomDetail;
    property blDetail.NomDetail: TBatpro_Ligne read FblDetail.NomDetail write SetblDetail.NomDetail;
    function Detail.NomDetail: String;

