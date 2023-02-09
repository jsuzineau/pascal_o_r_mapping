function blPiece_from_sl( sl: TBatpro_StringList; Index: Integer): TblPiece;
begin
     _Classe_from_sl( Result, TblPiece, sl, Index);
end;

function blPiece_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TblPiece;
begin
     _Classe_from_sl_sCle( Result, TblPiece, sl, sCle);
end;

{ TIterateur_Piece }

function TIterateur_Piece.not_Suivant( out _Resultat: TblPiece): Boolean;
begin
     Result:= not_Suivant_interne( _Resultat);
end;

procedure TIterateur_Piece.Suivant( out _Resultat: TblPiece);
begin
     Suivant_interne( _Resultat);
end;

{ TslPiece }

constructor TslPiece.Create( _Nom: String= '');
begin
     inherited CreateE( _Nom, TblPiece);
end;

destructor TslPiece.Destroy;
begin
     inherited;
end;

class function TslPiece.Classe_Iterateur: TIterateur_Class;
begin
     Result:= TIterateur_Piece;
end;

function TslPiece.Iterateur: TIterateur_Piece;
begin
     Result:= TIterateur_Piece( Iterateur_interne);
end;

function TslPiece.Iterateur_Decroissant: TIterateur_Piece;
begin
     Result:= TIterateur_Piece( Iterateur_interne_Decroissant);
end;

//pattern_aggregation_classe_implementation

{ TblPiece }

constructor TblPiece.Create( _sl: TBatpro_StringList; _jsdc: TjsDataContexte; _pool: Tpool_Ancetre_Ancetre);
var
   CP: IblG_BECP;
begin
     CP:= Init_ClassParams;
     if Assigned( CP)
     then
         begin
         CP.Libelle:= 'Piece';
         CP.Font.Name:= sys_Times_New_Roman;
         CP.Font.Size:= 12;
         end;

     inherited;

     Champs.ChampDefinitions.NomTable:= 'Piece';

     //champs persistants
     cDate:= Champs.  String_from_String ( Date           , 'Date'           );
     cDate.Definition.Typ:= ftDate;
     cDate.Definition.Format_DateTime:='dddd d mmmm yyyy';
     Champs. Integer_from_Integer( Numero         , 'Numero'         );


     //Symétrie Facture
     FFacture_bl:= nil;
     cFacture_id:= Integer_from_Integer( FFacture_id, 'Facture_id');
     cFacture:= Champs.String_Lookup( FFacture, 'Facture', cFacture_id, poolFacture.GetLookupListItems, '');
     //Facture_id_Change; //tentative de désactivation pour éviter récursion
     cFacture_id.OnChange.Abonne( Self, Facture_id_Change);
end;

destructor TblPiece.Destroy;
begin

     inherited;
end;

class function TblPiece.sCle_from_( _Numero: Integer): String;
begin 
     Result:=  sCle_ID_from_( _Numero);
end;  

function TblPiece.sCle: String;
begin
     Result:= sCle_from_( Numero);
end;

procedure TblPiece.Unlink( be: TBatpro_Element);
begin
     inherited Unlink( be);
     ;

     if Facture_bl = be then Facture_Desaggrege;

end;

(*
procedure TblPiece.Create_Aggregation( Name: String; P: ThAggregation_Create_Params);
begin
          
     else                  inherited Create_Aggregation( Name, P);
end;
*)

//pattern_aggregation_accesseurs_implementation

//Pascal_ubl_implementation_pas_detail
procedure TblPiece.SetFacture_id(const Value: Integer);
begin
     if FFacture_id = Value then exit;
     FFacture_id:= Value;
     Facture_id_Change;
     Save_to_database;
end;

procedure TblPiece.Facture_id_Change;
begin
     Facture_Aggrege;
end;

procedure TblPiece.SetFacture_bl(const Value: TblFacture);
begin
     if FFacture_bl = Value then exit;

     Facture_Desaggrege;

     FFacture_bl:= Value;

     if Facture_id <> FFacture_bl.id
     then
         begin
         Facture_id:= FFacture_bl.id;
         Save_to_database;
         end;

     Facture_Connecte;
end;

procedure TblPiece.Facture_Connecte;
begin
     if nil = Facture_bl then exit;

     if Assigned(Facture_bl)
     then
         Facture_bl.Piece_bl:= Self;
     Connect_To( FFacture_bl);
end;

procedure TblPiece.Facture_Aggrege;
var
   Facture_bl_New: TblFacture;
begin
     poolFacture.Get_Interne_from_id( Facture_id, Facture_bl_New);
     if Facture_bl = Facture_bl_New then exit;

     Facture_Desaggrege;
     FFacture_bl:= Facture_bl_New;

     Facture_Connecte;
end;

procedure TblPiece.Facture_Desaggrege;
begin
     if Facture_bl = nil then exit;

     if Assigned(Facture_bl)
     then
         Facture_bl.Piece_bl:= nil;
     Unconnect_To( FFacture_bl);
end;

procedure TblPiece.Facture_Change;
begin
     if Assigned( FFacture_bl)
     then
         FFacture:= FFacture_bl.GetLibelle
     else
         FFacture:= '';
end;

function TblPiece.Facture: String;
begin
     if Assigned( FFacture_bl)
     then
         Result:= FFacture_bl.GetLibelle
     else
         Result:= '';
end;

 

var
   FpoolPiece: TpoolPiece;

function poolPiece: TpoolPiece;
begin
     TPool.class_Get( Result, FpoolPiece, TpoolPiece);
//Aggregations_Pascal_upool_affectation_pool_details_pas
end;

{ TpoolPiece }

procedure TpoolPiece.DataModuleCreate(Sender: TObject);
begin
     NomTable:= 'Piece';
     Classe_Elements:= TblPiece;
     Classe_Filtre:= ThfPiece;

     inherited;

     hfPiece:= hf as ThfPiece;
end;

function TpoolPiece.Get( _id: integer): TblPiece;
begin
     Get_Interne_from_id( _id, Result);
end;

function TpoolPiece.Nouveau: TblPiece;
begin
     Result:= nil;
     if Numeros_Incoherents_Message then exit;

     Nouveau_Base( Result);
     Result.Numero:= Nouveau_Numero;
     Result.Save_to_database;
end;

function TpoolPiece.Get_by_Cle( _Numero: Integer): TblPiece;
begin                               
     Numero:=  _Numero;
     sCle:= TblPiece.sCle_from_( Numero);
     Get_Interne( Result);       
end;                             


function TpoolPiece.Assure( _Numero: Integer): TblPiece;
begin                               
     Result:= Get_by_Cle(  _Numero);
     if Assigned( Result) then exit;

     Nouveau_Base( Result);                        
       Result.Numero         := _Numero       ;
     Result.Save_to_database;
end;


procedure TpoolPiece.To_Params( _Params: TParams);
begin
     with _Params
     do
       begin
       ParamByName( 'Numero'    ).AsInteger:= Numero;
       end;
end;

function TpoolPiece.SQLWHERE_ContraintesChamps: String;
begin
     Result                                    
     :=                                        
       'where                        '#13#10+
       '         Numero          = :Numero         ';
end;

function TpoolPiece.Test( _Facture_id: Integer;  _Date: String;  _Numero: Integer):Integer;
var                                                 
   bl: TblPiece;                          
begin                                               
          Nouveau_Base( bl);                        
       bl.Facture_id     := _Facture_id   ;
       bl.Date           := _Date         ;
       bl.Numero         := _Numero       ;
     bl.Save_to_database;                            
     Result:= bl.id;                                 
end;                                                 


//Details_Pascal_upool_charge_detail_implementation_pas
procedure TpoolPiece.Charge_Facture( _Facture_id: Integer; _slLoaded: TBatpro_StringList = nil);
var
   SQL: String;
begin
     SQL:= 'select * from '+NomTable+' where Facture_id = '+IntToStr( _Facture_id);

     Load( SQL, _slLoaded);
end;


class function TpoolPiece.Classe_Iterateur: TIterateur_Class;
begin
     Result:= TIterateur_Piece;
end;

function TpoolPiece.Iterateur: TIterateur_Piece;
begin
     Result:= TIterateur_Piece( Iterateur_interne);
end;

function TpoolPiece.Iterateur_Decroissant: TIterateur_Piece;
begin
     Result:= TIterateur_Piece( Iterateur_interne_Decroissant);
end;

function TpoolPiece.MaxNumero: Integer;
var
   SQL: String;
begin
     SQL
     :=
        'select                        '+LineEnding
       +'      max(Numero) as MaxNumero'+LineEnding
       +'from                          '+LineEnding
       +'    Piece                     '+LineEnding;
     if not Requete.Integer_from( SQL, 'MaxNumero', Result)
     then
         Result:= -1;
end;

function TpoolPiece.Numeros_Incoherents: Boolean;
var
   Fin: Integer;
   I: Integer;
   bl: TblPiece;
begin
     Result:= False;
     Fin:= MaxNumero;
     for I:= Fin-1 downto 1
     do
       begin
       bl:= Get_by_Cle( I);
       Result:= nil = bl;
       if Result then break;
       end;
end;

function TpoolPiece.Numeros_Incoherents_Message: Boolean;
begin
     Result:= Numeros_Incoherents;
     if Result
     then
         fAccueil_Erreur( 'Incohérence de numérotation des pièces');

end;

function TpoolPiece.Nouveau_Numero: Integer;
begin
     Result:= MaxNumero + 1;
end;

