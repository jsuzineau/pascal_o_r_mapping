     FblDetail.NomDetail:= nil;
     cidDetail.NomDetail:= Integer_from_Integer( FidDetail.NomDetail, 'idDetail.NomDetail');
     Champs.String_Lookup( FDetail.NomDetail, 'Detail.NomDetail', cidDetail.NomDetail, ublClasse.Nom_de_la_classe_poolDetail.ClasseDetail.GetLookupListItems, '');
     idDetail.NomDetail_Change;
     cidDetail.NomDetail.OnChange.Abonne( Self, idDetail.NomDetail_Change);

