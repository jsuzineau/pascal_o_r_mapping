     if nil = ublDetail.ClasseDetail_poolClasse.Nom_de_la_classe
     then
         begin
         ublDetail.ClasseDetail_poolClasse.Nom_de_la_classe:= Result;
         ublDetail.ClasseDetail_poolClasse.Nom_de_la_classe_Charge_Detail.ClasseDetail:= Result.Charge_Detail.NomDetail;
         end;

