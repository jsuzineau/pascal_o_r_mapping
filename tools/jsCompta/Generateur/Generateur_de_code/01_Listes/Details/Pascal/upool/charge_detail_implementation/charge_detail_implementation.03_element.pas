procedure TpoolClasse.Nom_de_la_classe.Charge_Detail.ClasseDetail( _idDetail.ClasseDetail: Integer; slLoaded: TBatpro_StringList = nil);
var
   SQL: String;
begin
     SQL:= 'select * from '+NomTable+' where idDetail.ClasseDetail = '+IntToStr( _idDetail.ClasseDetail);

     Load( SQL, slLoaded);
end;

