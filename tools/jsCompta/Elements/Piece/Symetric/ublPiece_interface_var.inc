function blPiece_from_sl( sl: TBatpro_StringList; Index: Integer): TblPiece;
function blPiece_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TblPiece;

var
   ublPiece_poolMois: TPool = nil;


function poolPiece: TpoolPiece;

