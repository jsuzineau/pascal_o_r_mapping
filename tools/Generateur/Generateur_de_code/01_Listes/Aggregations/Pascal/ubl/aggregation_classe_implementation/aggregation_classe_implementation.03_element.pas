{ ThaClasse.Nom_de_la_classe__Aggregation.NomAggregation }

constructor ThaClasse.Nom_de_la_classe__Aggregation.NomAggregation.Create( _Parent: TBatpro_Element;
                               _Classe_Elements: TBatpro_Element_Class;
                               _pool_Ancetre_Ancetre: Tpool_Ancetre_Ancetre);
begin
     inherited;
     if Classe_Elements <> _Classe_Elements
     then
         fAccueil_Erreur(  'Erreur à signaler au développeur: '#13#10
                          +' '+ClassName+'.Create: Classe_Elements <> _Classe_Elements:'#13#10
                          +' Classe_Elements='+ Classe_Elements.ClassName+#13#10
                          +'_Classe_Elements='+_Classe_Elements.ClassName
                          );
     if Affecte_( blClasse.Nom_de_la_classe, TblClasse.Nom_de_la_classe, Parent) then exit;
end;

destructor ThaClasse.Nom_de_la_classe__Aggregation.NomAggregation.Destroy;
begin
     inherited;
end;

procedure ThaClasse.Nom_de_la_classe__Aggregation.NomAggregation.Charge;
begin
     poolAggregation.ClasseAggregation.Charge_Classe.Nom_de_la_classe( blClasse.Nom_de_la_classe.id);
end;

procedure ThaClasse.Nom_de_la_classe__Aggregation.NomAggregation.Delete_from_database;
var
   I: TIterateur_Aggregation.ClasseAggregation;
   bl: TblAggregation.ClasseAggregation;
begin
     I:= Iterateur_Decroissant;
     try
        while I.Continuer
        do
          begin
          if I.not_Suivant( bl) then Continue;

          bl.Delete_from_database;//enlève en même temps de cette liste
          end;
     finally
            FreeAndNil( I);
            end;
end;

class function ThaClasse.Nom_de_la_classe__Aggregation.NomAggregation.Classe_Iterateur: TIterateur_Class;
begin
     Result:= TIterateur_Aggregation.ClasseAggregation;
end;

function ThaClasse.Nom_de_la_classe__Aggregation.NomAggregation.Iterateur: TIterateur_Aggregation.ClasseAggregation;
begin
     Result:= TIterateur_Aggregation.ClasseAggregation(Iterateur_interne);
end;

function ThaClasse.Nom_de_la_classe__Aggregation.NomAggregation.Iterateur_Decroissant: TIterateur_Aggregation.ClasseAggregation;
begin
     Result:= TIterateur_Aggregation.ClasseAggregation(Iterateur_interne_Decroissant);
end;


