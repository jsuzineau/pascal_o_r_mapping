     //Détail Detail.NomDetail
     FDetail.NomDetail_bl:= nil;
     cDetail.NomDetail_id:= Integer_from_Integer( FDetail.NomDetail_id, 'Detail.NomDetail_id');
     cDetail.NomDetail:= Champs.String_Lookup( FDetail.NomDetail, 'Detail.NomDetail', cDetail.NomDetail_id, ublClasse.Nom_de_la_classe_poolDetail.ClasseDetail.GetLookupListItems, '');
     Detail.NomDetail_id_Change;
     cDetail.NomDetail_id.OnChange.Abonne( Self, Detail.NomDetail_id_Change);
