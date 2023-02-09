procedure TpoolClasse.Nom_de_la_classe.Charge_Symetric.ClasseSymetric( _Symetric.ClasseSymetric_id: Integer; _slLoaded: TBatpro_StringList = nil);
var
   SQL: String;
begin
     SQL:= 'select * from '+NomTable+' where Symetric.ClasseSymetric_id = '+IntToStr( _Symetric.ClasseSymetric_id);

     Load( SQL, _slLoaded);
end;

