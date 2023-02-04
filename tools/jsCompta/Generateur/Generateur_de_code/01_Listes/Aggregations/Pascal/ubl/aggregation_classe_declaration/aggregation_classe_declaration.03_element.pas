  { ThaClasse.Nom_de_la_classe__Aggregation.NomAggregation }
  ThaClasse.Nom_de_la_classe__Aggregation.NomAggregation
  =
   class( ThAggregation)
   //Gestion du cycle de vie
   public
     constructor Create( _Parent: TBatpro_Element;
                         _Classe_Elements: TBatpro_Element_Class;
                         _pool_Ancetre_Ancetre: Tpool_Ancetre_Ancetre); override;
     destructor  Destroy; override;
   //Parent
   public
     blClasse.Nom_de_la_classe: TblClasse.Nom_de_la_classe;  
   //Chargement de tous les détails
   public
     procedure Charge; override;
   //Suppression
   public
     procedure Delete_from_database; override;
   //Création d'itérateur
   protected
     class function Classe_Iterateur: TIterateur_Class; override;
   public
     function Iterateur: TIterateur_Aggregation.ClasseAggregation;
     function Iterateur_Decroissant: TIterateur_Aggregation.ClasseAggregation;
   end;



