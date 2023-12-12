procedure TpoolClasse.Nom_de_la_classe.Charge_Detail.ClasseDetail( _Detail.ClasseDetail_id: Integer; _slLoaded: TBatpro_StringList = nil);
var
   SQL: String;
begin
     SQL:= 'select * from '+NomTable+' where Detail.ClasseDetail_id = '+IntToStr( _Detail.ClasseDetail_id);

     Load( SQL, _slLoaded);
end;

