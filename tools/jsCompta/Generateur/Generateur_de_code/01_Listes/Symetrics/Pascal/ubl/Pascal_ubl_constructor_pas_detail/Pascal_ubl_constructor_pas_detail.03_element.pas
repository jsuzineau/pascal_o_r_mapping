     //Symétrie Symetric.NomSymetric
     FSymetric.NomSymetric_bl:= nil;
     cSymetric.NomSymetric_id:= Integer_from_Integer( FSymetric.NomSymetric_id, 'Symetric.NomSymetric_id');
     cSymetric.NomSymetric:= Champs.String_Lookup( FSymetric.NomSymetric, 'Symetric.NomSymetric', cSymetric.NomSymetric_id, poolSymetric.ClasseSymetric.GetLookupListItems, '');
     cSymetric.NomSymetric_id.OnChange.Abonne( Self, Symetric.NomSymetric_id_Change);
