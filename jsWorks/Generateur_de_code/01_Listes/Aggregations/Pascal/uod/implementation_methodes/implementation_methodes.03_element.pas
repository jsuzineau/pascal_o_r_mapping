procedure TodNom_de_la_classe.Table_Aggregation.NomAggregation;
var
   tAggregation.NomAggregation: TOD_Batpro_Table;
   nAggregation.NomAggregation: TOD_Niveau;
begin
     tAggregation.NomAggregation:= Ajoute_Table( 'tAggregation.NomAggregation');
     tAggregation.NomAggregation.Pas_de_persistance:= True;
     tAggregation.NomAggregation.AddColumn( 40, '  '      );

     nAggregation.NomAggregation:= tCalendrier.AddNiveau( 'Root');
     nAggregation.NomAggregation.Charge_ha( blNom_de_la_classe.haAggregation.NomAggregation);
     nAggregation.NomAggregation.Ajoute_Column_Avant( 'D'                  , 0, 0);
end;

