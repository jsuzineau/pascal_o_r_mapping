procedure TodClasse.Nom_de_la_classe.Table_Aggregation.NomAggregation;
var
   tAggregation.NomAggregation: TOD_Batpro_Table;
   nRoot: TOD_Niveau;
   nAggregation.NomAggregation: TOD_Niveau;
begin
     blClasse.Nom_de_la_classe.haAggregation.NomAggregation.Charge;
     
     tAggregation.NomAggregation:= Ajoute_Table( 'tAggregation.NomAggregation');
     tAggregation.NomAggregation.Pas_de_persistance:= True;
     tAggregation.NomAggregation.AddColumn( 40, '  '      );

     nRoot:= tAggregation.NomAggregation.AddNiveau( 'Root');
     nRoot.Charge_sl( sl);
     nRoot.Ajoute_Column_Avant( 'D'                  , 0, 0);

     nAggregation.NomAggregation:= tAggregation.NomAggregation.AddNiveau( 'Aggregation.NomAggregation');
     nAggregation.NomAggregation.Ajoute_Column_Avant( 'D'                  , 0, 0);
end;


