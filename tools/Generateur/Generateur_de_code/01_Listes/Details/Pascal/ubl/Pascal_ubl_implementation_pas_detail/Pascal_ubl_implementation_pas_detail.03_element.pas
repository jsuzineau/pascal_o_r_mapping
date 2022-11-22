procedure TblClasse.Nom_de_la_classe.SetidDetail.NomDetail(const Value: Integer);
begin
     if FidDetail.NomDetail = Value then exit;
     FidDetail.NomDetail:= Value;
     idDetail.NomDetail_Change;
     Save_to_database;
end;

procedure TblClasse.Nom_de_la_classe.idDetail.NomDetail_Change;
begin
     Detail.NomDetail_Aggrege;
end;

procedure TblClasse.Nom_de_la_classe.SetblDetail.NomDetail(const Value: TblDetail.ClasseDetail);
begin
     if FblDetail.NomDetail = Value then exit;

     Detail.NomDetail_Desaggrege;

     FblDetail.NomDetail:= Value;

     if idDetail.NomDetail <> FblDetail.NomDetail.id
     then
         begin
         idDetail.NomDetail:= FblDetail.NomDetail.id;
         Save_to_database;
         end;

     Detail.NomDetail_Connecte;
end;

procedure TblClasse.Nom_de_la_classe.Detail.NomDetail_Connecte;
begin
     if nil = blDetail.NomDetail then exit;

     if Assigned(blDetail.NomDetail) then blDetail.NomDetail.ha{ajouter nom}.Ajoute(Self);
     Connect_To( FblDetail.NomDetail);
end;

procedure TblClasse.Nom_de_la_classe.Detail.NomDetail_Aggrege;
var
   blDetail.NomDetail_New: TblDetail.ClasseDetail;
begin
     blDetail.NomDetail_New:= poolDetail.ClasseDetail.Get( idDetail.NomDetail);
     if blDetail.NomDetail = blDetail.NomDetail_New then exit;

     Detail.NomDetail_Desaggrege;
     FblDetail.NomDetail:= blDetail.NomDetail_New;

     Detail.NomDetail_Connecte;
end;

procedure TblClasse.Nom_de_la_classe.Detail.NomDetail_Desaggrege;
begin
     if blDetail.NomDetail = nil then exit;

     if Assigned(blDetail.NomDetail) then blDetail.NomDetail.ha{ajouter nom}.Enleve(Self);
     Unconnect_To( FblDetail.NomDetail);
end;

procedure TblClasse.Nom_de_la_classe.Detail.NomDetail_Change;
begin
     if Assigned( FblDetail.NomDetail)
     then
         Detail.NomDetail:= FblDetail.NomDetail.GetLibelle
     else
         Detail.NomDetail:= '';
end;


