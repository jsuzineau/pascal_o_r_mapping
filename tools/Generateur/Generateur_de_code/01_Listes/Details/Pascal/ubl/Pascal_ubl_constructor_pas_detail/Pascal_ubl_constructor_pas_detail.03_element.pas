     FblDetail.NomDetail:= nil;
     cidDetail.NomDetail:= Integer_from_Integer( FidDetail.NomDetail, 'idDetail.NomDetail');
     Champs.String_Lookup( Detail.NomDetail, 'Detail.NomDetail', cidDetail.NomDetail, poolDetail.ClasseDetail.GetLookupListItems, '');
     idDetail.NomDetail_Change;
     cidDetail.NomDetail.OnChange.Abonne( Self, idDetail.NomDetail_Change);

