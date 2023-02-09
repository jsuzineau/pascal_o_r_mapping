function blFacture_from_sl( sl: TBatpro_StringList; Index: Integer): TblFacture;
function blFacture_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TblFacture;

var
   ublFacture_poolClient: TPool = nil;


function poolFacture: TpoolFacture;

