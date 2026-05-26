procedure TblClasse.Nom_de_la_classe.SetDetail.NomDetail_id(const Value: Integer);
begin
     if FDetail.NomDetail_id = Value then exit;
     FDetail.NomDetail_id:= Value;
     Detail.NomDetail_id_Change;
     Save_to_database;
end;

procedure TblClasse.Nom_de_la_classe.Detail.NomDetail_id_Change;
begin
     Detail.NomDetail_Aggrege;
end;

procedure TblClasse.Nom_de_la_classe.SetDetail.NomDetail_bl(const Value: TBatpro_Ligne);
begin
     if FDetail.NomDetail_bl = Value then exit;

     Detail.NomDetail_Desaggrege;

     FDetail.NomDetail_bl:= Value;

     if Detail.NomDetail_id <> FDetail.NomDetail_bl.id
     then
         begin
         Detail.NomDetail_id:= FDetail.NomDetail_bl.id;
         Save_to_database;
         end;

     Detail.NomDetail_Connecte;
end;

procedure TblClasse.Nom_de_la_classe.Detail.NomDetail_Connecte;
begin
     if nil = Detail.NomDetail_bl then exit;

     if Assigned(Detail.NomDetail_bl) 
     then 
         Detail.NomDetail_bl.Aggregations.by_Name[ #vérifier_nom_aggregation'Classe.Nom_de_la_classe'].Ajoute(Self);
     Connect_To( FDetail.NomDetail_bl);
end;

procedure TblClasse.Nom_de_la_classe.Detail.NomDetail_Aggrege;
var
   Detail.NomDetail_bl_New: TBatpro_Ligne;
begin                                                        
     ublClasse.Nom_de_la_classe_poolDetail.ClasseDetail.Get_Interne_from_id( Detail.NomDetail_id, Detail.NomDetail_bl_New);
     if Detail.NomDetail_bl = Detail.NomDetail_bl_New then exit;

     Detail.NomDetail_Desaggrege;
     FDetail.NomDetail_bl:= Detail.NomDetail_bl_New;

     Detail.NomDetail_Connecte;
end;

procedure TblClasse.Nom_de_la_classe.Detail.NomDetail_Desaggrege;
begin
     if Detail.NomDetail_bl = nil then exit;

     if Assigned(Detail.NomDetail_bl) 
     then 
         Detail.NomDetail_bl.Aggregations.by_Name[ #vérifier_nom_aggregation'Classe.Nom_de_la_classe'].Enleve(Self);
     Unconnect_To( FDetail.NomDetail_bl);
end;

procedure TblClasse.Nom_de_la_classe.Detail.NomDetail_Change;
begin
     if Assigned( FDetail.NomDetail_bl)
     then
         FDetail.NomDetail:= FDetail.NomDetail_bl.GetLibelle
     else
         FDetail.NomDetail:= '';
end;

function TblClasse.Nom_de_la_classe.Detail.NomDetail: String;
begin
     if Assigned( FDetail.NomDetail_bl)
     then
         Result:= FDetail.NomDetail_bl.GetLibelle
     else
         Result:= '';
end;


