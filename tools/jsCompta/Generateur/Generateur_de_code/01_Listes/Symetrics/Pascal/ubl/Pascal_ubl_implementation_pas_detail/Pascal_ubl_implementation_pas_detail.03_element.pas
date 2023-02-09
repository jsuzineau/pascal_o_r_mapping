procedure TblClasse.Nom_de_la_classe.SetSymetric.NomSymetric_id(const Value: Integer);
begin
     if FSymetric.NomSymetric_id = Value then exit;
     FSymetric.NomSymetric_id:= Value;
     Symetric.NomSymetric_id_Change;
     Save_to_database;
end;

procedure TblClasse.Nom_de_la_classe.Symetric.NomSymetric_id_Change;
begin
     Symetric.NomSymetric_Aggrege;
end;

procedure TblClasse.Nom_de_la_classe.SetSymetric.NomSymetric_bl(const Value: TblSymetric.ClasseSymetric);
begin
     if FSymetric.NomSymetric_bl = Value then exit;

     Symetric.NomSymetric_Desaggrege;

     FSymetric.NomSymetric_bl:= Value;

     if Symetric.NomSymetric_id <> FSymetric.NomSymetric_bl.id
     then
         begin
         Symetric.NomSymetric_id:= FSymetric.NomSymetric_bl.id;
         Save_to_database;
         end;

     Symetric.NomSymetric_Connecte;
end;

procedure TblClasse.Nom_de_la_classe.Symetric.NomSymetric_Connecte;
begin
     if nil = Symetric.NomSymetric_bl then exit;

     if Assigned(Symetric.NomSymetric_bl)
     then
         Symetric.NomSymetric_bl #Vérifier_nom_détail.Classe.Nom_de_la_classe_bl:= Self;
     Connect_To( FSymetric.NomSymetric_bl);
end;

procedure TblClasse.Nom_de_la_classe.Symetric.NomSymetric_Aggrege;
var
   Symetric.NomSymetric_bl_New: TblSymetric.ClasseSymetric;
begin
     poolSymetric.ClasseSymetric.Get_Interne_from_id( Symetric.NomSymetric_id, Symetric.NomSymetric_bl_New);
     if Symetric.NomSymetric_bl = Symetric.NomSymetric_bl_New then exit;

     Symetric.NomSymetric_Desaggrege;
     FSymetric.NomSymetric_bl:= Symetric.NomSymetric_bl_New;

     Symetric.NomSymetric_Connecte;
end;

procedure TblClasse.Nom_de_la_classe.Symetric.NomSymetric_Desaggrege;
begin
     if Symetric.NomSymetric_bl = nil then exit;

     if Assigned(Symetric.NomSymetric_bl)
     then
         Symetric.NomSymetric_bl #Vérifier_nom_détail.Classe.Nom_de_la_classe_bl:= nil;
     Unconnect_To( FSymetric.NomSymetric_bl);
end;

procedure TblClasse.Nom_de_la_classe.Symetric.NomSymetric_Change;
begin
     if Assigned( FSymetric.NomSymetric_bl)
     then
         FSymetric.NomSymetric:= FSymetric.NomSymetric_bl.GetLibelle
     else
         FSymetric.NomSymetric:= '';
end;

function TblClasse.Nom_de_la_classe.Symetric.NomSymetric: String;
begin
     if Assigned( FSymetric.NomSymetric_bl)
     then
         Result:= FSymetric.NomSymetric_bl.GetLibelle
     else
         Result:= '';
end;


