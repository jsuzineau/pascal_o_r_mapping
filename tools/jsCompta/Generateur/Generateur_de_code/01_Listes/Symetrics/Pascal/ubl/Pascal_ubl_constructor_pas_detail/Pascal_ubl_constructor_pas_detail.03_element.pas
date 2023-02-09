     //Symétrie Symetric.NomSymetric
     FSymetric.NomSymetric_bl:= nil;
     cSymetric.NomSymetric_id:= Integer_from_Integer( FSymetric.NomSymetric_id, 'Symetric.NomSymetric_id');
     Champs.String_Lookup( FSymetric.NomSymetric, 'Symetric.NomSymetric', cSymetric.NomSymetric_id, ublClasse.Nom_de_la_classe_poolSymetric.ClasseSymetric.GetLookupListItems, '');
     Symetric.NomSymetric_id_Change;
     cSymetric.NomSymetric_id.OnChange.Abonne( Self, Symetric.NomSymetric_id_Change);

