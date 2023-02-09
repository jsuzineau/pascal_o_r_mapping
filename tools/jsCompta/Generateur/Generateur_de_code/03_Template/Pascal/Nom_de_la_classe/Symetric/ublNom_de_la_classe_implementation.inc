function blNom_de_la_classe_from_sl( sl: TBatpro_StringList; Index: Integer): TblNom_de_la_classe;
begin
     _Classe_from_sl( Result, TblNom_de_la_classe, sl, Index);
end;

function blNom_de_la_classe_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TblNom_de_la_classe;
begin
     _Classe_from_sl_sCle( Result, TblNom_de_la_classe, sl, sCle);
end;

{ TIterateur_Nom_de_la_classe }

function TIterateur_Nom_de_la_classe.not_Suivant( out _Resultat: TblNom_de_la_classe): Boolean;
begin
     Result:= not_Suivant_interne( _Resultat);
end;

procedure TIterateur_Nom_de_la_classe.Suivant( out _Resultat: TblNom_de_la_classe);
begin
     Suivant_interne( _Resultat);
end;

{ TslNom_de_la_classe }

constructor TslNom_de_la_classe.Create( _Nom: String= '');
begin
     inherited CreateE( _Nom, TblNom_de_la_classe);
end;

destructor TslNom_de_la_classe.Destroy;
begin
     inherited;
end;

class function TslNom_de_la_classe.Classe_Iterateur: TIterateur_Class;
begin
     Result:= TIterateur_Nom_de_la_classe;
end;

function TslNom_de_la_classe.Iterateur: TIterateur_Nom_de_la_classe;
begin
     Result:= TIterateur_Nom_de_la_classe( Iterateur_interne);
end;

function TslNom_de_la_classe.Iterateur_Decroissant: TIterateur_Nom_de_la_classe;
begin
     Result:= TIterateur_Nom_de_la_classe( Iterateur_interne_Decroissant);
end;

//pattern_aggregation_classe_implementation

{ TblNom_de_la_classe }

constructor TblNom_de_la_classe.Create( _sl: TBatpro_StringList; _jsdc: TjsDataContexte; _pool: Tpool_Ancetre_Ancetre);
var
   CP: IblG_BECP;
begin
     CP:= Init_ClassParams;
     if Assigned( CP)
     then
         begin
         CP.Libelle:= 'Nom_de_la_classe';
         CP.Font.Name:= sys_Times_New_Roman;
         CP.Font.Size:= 12;
         end;

     inherited;

     Champs.ChampDefinitions.NomTable:= 'Nom_de_la_table';

     //champs persistants
//pattern_creation_champs
//Pascal_ubl_constructor_pas_detail
//pattern_Symetrics_Pascal_ubl_constructor_pas
end;

destructor TblNom_de_la_classe.Destroy;
begin

     inherited;
end;

//pattern_sCle_from__Implementation

function TblNom_de_la_classe.sCle: String;
begin
//pattern_sCle_Implementation_Body
end;

procedure TblNom_de_la_classe.Unlink( be: TBatpro_Element);
begin
     inherited Unlink( be);
//Pascal_ubl_unlink_body_pas_detail
//pattern_Symetrics_Pascal_ubl_unlink_body_pas
end;

//pattern_aggregation_Create_Aggregation_implementation

//pattern_aggregation_accesseurs_implementation

//Pascal_ubl_implementation_pas_detail
//pattern_Symetrics_Pascal_ubl_implementation_pas

var
   FpoolNom_de_la_classe: TpoolNom_de_la_classe;

function poolNom_de_la_classe: TpoolNom_de_la_classe;
begin
     TPool.class_Get( Result, FpoolNom_de_la_classe, TpoolNom_de_la_classe);
//Aggregations_Pascal_upool_affectation_pool_details_pas
end;

{ TpoolNom_de_la_classe }

procedure TpoolNom_de_la_classe.DataModuleCreate(Sender: TObject);
begin
     NomTable:= 'Nom_de_la_table';
     Classe_Elements:= TblNom_de_la_classe;
     Classe_Filtre:= ThfNom_de_la_classe;

     inherited;

     hfNom_de_la_classe:= hf as ThfNom_de_la_classe;
end;

function TpoolNom_de_la_classe.Get( _id: integer): TblNom_de_la_classe;
begin
     Get_Interne_from_id( _id, Result);
end;

function TpoolNom_de_la_classe.Nouveau: TblNom_de_la_classe;
begin
     Nouveau_Base( Result);
end;

//pattern_Get_by_Cle_Implementation

//pattern_Assure_Implementation

procedure TpoolNom_de_la_classe.To_Params( _Params: TParams);
begin
     with _Params
     do
       begin
//pattern_To_SQLQuery_Params_Body
       end;
end;

function TpoolNom_de_la_classe.SQLWHERE_ContraintesChamps: String;
begin
//pattern_SQLWHERE_ContraintesChamps_Body
end;

{Test_Implementation_Key}

//Details_Pascal_upool_charge_detail_implementation_pas
//pattern_Symetrics_Pascal_upool_charge_implementation_pas

class function TpoolNom_de_la_classe.Classe_Iterateur: TIterateur_Class;
begin
     Result:= TIterateur_Nom_de_la_classe;
end;

function TpoolNom_de_la_classe.Iterateur: TIterateur_Nom_de_la_classe;
begin
     Result:= TIterateur_Nom_de_la_classe( Iterateur_interne);
end;

function TpoolNom_de_la_classe.Iterateur_Decroissant: TIterateur_Nom_de_la_classe;
begin
     Result:= TIterateur_Nom_de_la_classe( Iterateur_interne_Decroissant);
end;

