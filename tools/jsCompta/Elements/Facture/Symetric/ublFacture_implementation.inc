function blFacture_from_sl( sl: TBatpro_StringList; Index: Integer): TblFacture;
begin
     _Classe_from_sl( Result, TblFacture, sl, Index);
end;

function blFacture_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TblFacture;
begin
     _Classe_from_sl_sCle( Result, TblFacture, sl, sCle);
end;

{ TIterateur_Facture }

function TIterateur_Facture.not_Suivant( out _Resultat: TblFacture): Boolean;
begin
     Result:= not_Suivant_interne( _Resultat);
end;

procedure TIterateur_Facture.Suivant( out _Resultat: TblFacture);
begin
     Suivant_interne( _Resultat);
end;

{ TslFacture }

constructor TslFacture.Create( _Nom: String= '');
begin
     inherited CreateE( _Nom, TblFacture);
end;

destructor TslFacture.Destroy;
begin
     inherited;
end;

class function TslFacture.Classe_Iterateur: TIterateur_Class;
begin
     Result:= TIterateur_Facture;
end;

function TslFacture.Iterateur: TIterateur_Facture;
begin
     Result:= TIterateur_Facture( Iterateur_interne);
end;

function TslFacture.Iterateur_Decroissant: TIterateur_Facture;
begin
     Result:= TIterateur_Facture( Iterateur_interne_Decroissant);
end;

{ ThaFacture__Facture_Ligne }

constructor ThaFacture__Facture_Ligne.Create( _Parent: TBatpro_Element;
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
     if Affecte_( blFacture, TblFacture, Parent) then exit;
end;

destructor ThaFacture__Facture_Ligne.Destroy;
begin
     inherited;
end;

procedure ThaFacture__Facture_Ligne.Charge;
begin
     poolFacture_Ligne.Charge_Facture( blFacture.id);
     Montant_from_Total;
     NbHeures_from_Total_NbHeures;
end;

procedure ThaFacture__Facture_Ligne.Delete_from_database;
var
   I: TIterateur_Facture_Ligne;
   bl: TblFacture_Ligne;
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

class function ThaFacture__Facture_Ligne.Classe_Iterateur: TIterateur_Class;
begin
     Result:= TIterateur_Facture_Ligne;
end;

function ThaFacture__Facture_Ligne.Iterateur: TIterateur_Facture_Ligne;
begin
     Result:= TIterateur_Facture_Ligne(Iterateur_interne);
end;

function ThaFacture__Facture_Ligne.Iterateur_Decroissant: TIterateur_Facture_Ligne;
begin
     Result:= TIterateur_Facture_Ligne(Iterateur_interne_Decroissant);
end;

function ThaFacture__Facture_Ligne.CalculeTotal: Double;
var
   I: TIterateur_Facture_Ligne;
   bl: TblFacture_Ligne;
begin
     Result:= 0;
     I:= Iterateur;
     try
        while I.Continuer
        do
          begin
          if I.not_Suivant( bl) then continue;

          Result:= Result + bl.Montant;
          end;
     finally
            FreeAndNil( I);
            end;
     Result:= Arrondi_Arithmetique_00( Result);
end;

procedure ThaFacture__Facture_Ligne.Montant_from_Total;
var
   Total: double;
   procedure Erreur;
   var
      S: String;
   begin
        S
        :=
           'Facture '+blFacture.Nom+LineEnding
          +'montant incohérent: '+blFacture.cMontant.Chaine+LineEnding
          +'calculé: '+FloatToStr( Total);
        fAccueil_Erreur( S, S);
   end;
begin
     Total:= CalculeTotal;

     if Reel_Zero( blFacture.Montant)
     then
         blFacture.cMontant.asDouble:= Total
     else
         if Total <> blFacture.Montant
         then
             Erreur;
end;

function ThaFacture__Facture_Ligne.CalculeTotal_NbHeures: String;
var
   I: TIterateur_Facture_Ligne;
   bl: TblFacture_Ligne;
   Total_NbHeures: double;
begin
     Total_NbHeures:= 0;
     I:= Iterateur;
     try
        while I.Continuer
        do
          begin
          if I.not_Suivant( bl) then continue;

          Total_NbHeures:= Total_NbHeures + bl.NbHeures;
          end;
     finally
            FreeAndNil( I);
            end;
     Total_NbHeures:= Arrondi_Arithmetique_00( Total_NbHeures);
     Result:= uReal_Formatter.Format_Float( Total_NbHeures,False,2);
end;

procedure ThaFacture__Facture_Ligne.NbHeures_from_Total_NbHeures;
var
   Total: String;
begin
     Total:= CalculeTotal_NbHeures;

     if '' = Trim(blFacture.NbHeures)
     then
         blFacture.cNbHeures.Chaine:= Total;
end;



{ TblFacture }

constructor TblFacture.Create( _sl: TBatpro_StringList; _jsdc: TjsDataContexte; _pool: Tpool_Ancetre_Ancetre);
var
   CP: IblG_BECP;
begin
     CP:= Init_ClassParams;
     if Assigned( CP)
     then
         begin
         CP.Libelle:= 'Facture';
         CP.Font.Name:= sys_Times_New_Roman;
         CP.Font.Size:= 12;
         end;

     inherited;

     Champs.ChampDefinitions.NomTable:= 'Facture';

     //champs persistants
     cAnnee          := Integer_from_Integer( Annee          , 'Annee'          );
     cNumeroDansAnnee:= Integer_from_Integer( NumeroDansAnnee, 'NumeroDansAnnee');

     cDate:= DateTime_from_( Date           , 'Date'           );
     cDate.Definition.Format_DateTime:='dddd d mmmm yyyy';
     cNom:= String_from_String ( Nom            , 'Nom'            );
     cLibelle:= cNom;
     cNbHeures:= String_from_String ( NbHeures       , 'NbHeures'       );

     //Montant
     cMontant:=          Double_from_( Montant  , 'Montant'  );
     cMontant_s:= Ajoute_String      ( Montant_s, 'Montant_s', False);
     cMontant_s.OnGetChaine:= Montant_s_GetChaine;

     //Détail Client
     FClient_bl:= nil;
     cClient_id:= Integer_from_Integer( FClient_id, 'Client_id');
     cClient:= Champs.String_Lookup( FClient, 'Client', cClient_id, ublFacture_poolClient.GetLookupListItems, '');
     Client_id_Change;
     cClient_id.OnChange.Abonne( Self, Client_id_Change);



     //Symétrie Piece
     FPiece_bl:= nil;
     cPiece_id:= Integer_from_Integer( FPiece_id, 'Piece_id');
     cPiece:= Champs.String_Lookup( FPiece, 'Piece', cPiece_id, poolPiece.GetLookupListItems, '');
     cPiece_id.OnChange.Abonne( Self, Piece_id_Change);

     //Numéro de facture
     cNumero:= Ajoute_String ( FNumero, 'Numero', False);
     cAnnee          .OnChange.Abonne( Self, Numero_from_);
     cNumeroDansAnnee.OnChange.Abonne( Self, Numero_from_);
     cNumero.OnGetChaine:= Numero_GetChaine;

     //Libellés pour ligne total de facture sur impression
     Ajoute_String ( Label_Total, 'Label_Total', False);
     Ajoute_String ( Label_TVA  , 'Label_TVA'  , False);
     Label_Total:= 'TOTAL HT';
     Label_TVA  := '(TVA non applicable, article 293 B du code général des impôts)';

end;

destructor TblFacture.Destroy;
begin

     inherited;
end;

procedure TblFacture.Montant_s_GetChaine(var _Chaine: String);
begin
     _Chaine:= cMontant.Chaine+' €';
end;

procedure TblFacture.Numero_from_;
begin
     cNumero.OnChange.Publie;
end;

function TblFacture.GetNumero: String;
begin
     Result:= cNumero.Chaine;
end;

procedure TblFacture.Numero_GetChaine(var _Chaine: String);
begin
     _Chaine:= Format( '%.4d_%.2d', [Annee, NumeroDansAnnee]);
end;

procedure TblFacture.Date_from_Now;
begin
     cDate.asDatetime:= SysUtils.Date;
end;

procedure TblFacture.Nom_from_;
var
   Y, M, D: Word;
begin
     if Nom <> '' then exit;

     DecodeDate( Date, Y, M, D);
     Nom:= Format( '%s_%.2d_%.2d_', [cNumero.Chaine, M, D]);
     if Assigned( Client_bl)
     then
         Nom:= Nom + Client_bl.GetLibelle;
     cNom.Chaine:= Nom;//juste pour les évènements de publication et sauvegarde
end;

class function TblFacture.sCle_from_( _Annee: Integer;  _NumeroDansAnnee: Integer): String;
begin 
     Result:=  Format('%.4d%.4d',[_Annee, _NumeroDansAnnee]);
end;  

function TblFacture.sCle: String;
begin
     Result:= sCle_from_( Annee, NumeroDansAnnee);
end;

procedure TblFacture.Unlink( be: TBatpro_Element);
begin
     inherited Unlink( be);
     if Client_bl = be then Client_Desaggrege;

     if FPiece_bl = be then Piece_Desaggrege;

end;

procedure TblFacture.Create_Aggregation( Name: String; P: ThAggregation_Create_Params);
begin
          if 'Facture_Ligne' = Name then P.Faible( ThaFacture__Facture_Ligne, TblFacture_Ligne, poolFacture_Ligne)
     else                  inherited Create_Aggregation( Name, P);
end;


function  TblFacture.GethaFacture_Ligne: ThaFacture__Facture_Ligne;
begin
     if FhaFacture_Ligne = nil
     then
         FhaFacture_Ligne:= Aggregations['Facture_Ligne'] as ThaFacture__Facture_Ligne;

     Result:= FhaFacture_Ligne;
end;


procedure TblFacture.SetClient_id(const Value: Integer);
begin
     if FClient_id = Value then exit;
     FClient_id:= Value;
     Client_id_Change;
     Save_to_database;
end;

procedure TblFacture.Client_id_Change;
begin
     Client_Aggrege;
end;

procedure TblFacture.SetClient_bl(const Value: TBatpro_Ligne);
begin
     if FClient_bl = Value then exit;

     Client_Desaggrege;

     FClient_bl:= Value;

     if Client_id <> FClient_bl.id
     then
         begin
         Client_id:= FClient_bl.id;
         Save_to_database;
         end;

     Client_Connecte;
end;

procedure TblFacture.Client_Connecte;
begin
     if nil = Client_bl then exit;

     if Assigned(Client_bl) 
     then 
         Client_bl.Aggregations.by_Name[ 'Facture'].Ajoute(Self);
     Connect_To( FClient_bl);

     Nom_from_;
end;

procedure TblFacture.Client_Aggrege;
var
   Client_bl_New: TBatpro_Ligne;
begin                                                        
     ublFacture_poolClient.Get_Interne_from_id( Client_id, Client_bl_New);
     if Client_bl = Client_bl_New then exit;

     Client_Desaggrege;
     FClient_bl:= Client_bl_New;

     Client_Connecte;
end;

procedure TblFacture.Client_Desaggrege;
begin
     if Client_bl = nil then exit;

     if Assigned(Client_bl) 
     then 
         Client_bl.Aggregations.by_Name[ 'Facture'].Enleve(Self);
     Unconnect_To( FClient_bl);
end;

procedure TblFacture.Client_Change;
begin
     if Assigned( FClient_bl)
     then
         FClient:= FClient_bl.GetLibelle
     else
         FClient:= '';
end;

function TblFacture.Client: String;
begin
     if Assigned( FClient_bl)
     then
         Result:= FClient_bl.GetLibelle
     else
         Result:= '';
end;

 
procedure TblFacture.SetPiece_id(const Value: Integer);
begin
     if FPiece_id = Value then exit;
     FPiece_id:= Value;
     Piece_id_Change;
     Save_to_database;
end;

function TblFacture.GetPiece_bl: TblPiece;
begin
     if nil = FPiece_bl
     then
         Piece_Aggrege;
     Result:= FPiece_bl;
end;

procedure TblFacture.Piece_id_Change;
begin
     Piece_Aggrege;
end;

procedure TblFacture.SetPiece_bl(const Value: TblPiece);
begin
     if FPiece_bl = Value then exit;

     Piece_Desaggrege;

     FPiece_bl:= Value;

     if Piece_id <> FPiece_bl.id
     then
         begin
         Piece_id:= FPiece_bl.id;
         Save_to_database;
         end;

     Piece_Connecte;
end;

procedure TblFacture.Piece_Connecte;
begin
     if nil = FPiece_bl then exit;

     FPiece_bl.Facture_bl:= Self;
     Connect_To( FPiece_bl);
end;

procedure TblFacture.Piece_Aggrege;
var
   Piece_bl_New: TblPiece;
begin
     poolPiece.Get_Interne_from_id( Piece_id, Piece_bl_New);
     if FPiece_bl = Piece_bl_New then exit;

     Piece_Desaggrege;
     FPiece_bl:= Piece_bl_New;
     AggregeLigne( 'Piece_', FPiece_bl);

     Piece_Connecte;
end;

procedure TblFacture.Piece_Desaggrege;
begin
     if FPiece_bl = nil then exit;

     DesaggregeLigne( 'Piece_', FPiece_bl);
     FPiece_bl.Facture_bl:= nil;
     Unconnect_To( FPiece_bl);
end;

procedure TblFacture.Piece_Change;
begin
     if Assigned( FPiece_bl)
     then
         FPiece:= FPiece_bl.GetLibelle
     else
         FPiece:= '';
end;

function TblFacture.Piece: String;
begin
     if Assigned( FPiece_bl)
     then
         Result:= FPiece_bl.GetLibelle
     else
         Result:= '';
end;

procedure TblFacture.Piece_Nouveau;
begin
     if Piece_id <> 0 then exit;

     Piece_bl:= poolPiece.Nouveau;
end;

 

var
   FpoolFacture: TpoolFacture;

function poolFacture: TpoolFacture;
begin
     TPool.class_Get( Result, FpoolFacture, TpoolFacture);

     if nil = ublFacture_Ligne_poolFacture
     then
         ublFacture_Ligne_poolFacture:= Result;

end;

{ TpoolFacture }

procedure TpoolFacture.DataModuleCreate(Sender: TObject);
begin
     NomTable:= 'Facture';
     Classe_Elements:= TblFacture;
     Classe_Filtre:= ThfFacture;

     inherited;

     hfFacture:= hf as ThfFacture;
     ChampTri[ 'Annee'          ]:= +1;
     ChampTri[ 'NumeroDansAnnee']:= +1;
end;

function TpoolFacture.Get( _id: integer): TblFacture;
begin
     Get_Interne_from_id( _id, Result);
end;

function TpoolFacture.Nouveau: TblFacture;
var
   Annee: Word;
begin
     Result:= nil;
     Annee:= CurrentYear;
     if Annee_Incoherente_Message(Annee) then exit;

     Nouveau_Base( Result);
     Result.Annee          := Annee;
     Result.NumeroDansAnnee:= Nouveau_Numero( Result.Annee);
     Result.Date           := SysUtils.Date;
     Result.Save_to_database;
end;

function TpoolFacture.Get_by_Cle( _Annee: Integer;  _NumeroDansAnnee: Integer): TblFacture;
begin                               
     Annee:=  _Annee;
     NumeroDansAnnee:=  _NumeroDansAnnee;
     sCle:= TblFacture.sCle_from_( Annee, NumeroDansAnnee);
     Get_Interne( Result);       
end;                             


function TpoolFacture.Assure( _Annee: Integer;  _NumeroDansAnnee: Integer): TblFacture;
begin                               
     Result:= Get_by_Cle(  _Annee,  _NumeroDansAnnee);
     if Assigned( Result) then exit;

     Nouveau_Base( Result);                        
       Result.Annee          := _Annee        ;
       Result.NumeroDansAnnee:= _NumeroDansAnnee;
     Result.Save_to_database;
end;


procedure TpoolFacture.To_Params( _Params: TParams);
begin
     with _Params
     do
       begin
       ParamByName( 'Annee'    ).AsInteger:= Annee;
       ParamByName( 'NumeroDansAnnee'    ).AsInteger:= NumeroDansAnnee;
       end;
end;

function TpoolFacture.SQLWHERE_ContraintesChamps: String;
begin
     Result                                    
     :=                                        
       'where                        '#13#10+
       '         Annee           = :Annee          '#13#10+
       '     and NumeroDansAnnee = :NumeroDansAnnee';
end;

function TpoolFacture.Test( _Annee: Integer; _NumeroDansAnnee: Integer;
                            _Date: TDatetime;
                            _Client_id: Integer; _Nom: String;
                            _NbHeures: String;  _Montant: Double): Integer;
var                                                 
   bl: TblFacture;                          
begin                                               
     Nouveau_Base( bl);
       bl.Annee          := _Annee        ;
       bl.NumeroDansAnnee:= _NumeroDansAnnee;
       bl.Date           := _Date         ;
       bl.Client_id      := _Client_id    ;
       bl.Nom            := _Nom          ;
       bl.NbHeures       := _NbHeures     ;
       bl.Montant        := _Montant      ;
     bl.Save_to_database;                            
     Result:= bl.id;                                 
end;                                                 


procedure TpoolFacture.Charge_Client( _Client_id: Integer; _slLoaded: TBatpro_StringList = nil);
var
   SQL: String;
begin
     SQL:= 'select * from '+NomTable+' where Client_id = '+IntToStr( _Client_id);

     Load( SQL, _slLoaded);
end;

procedure TpoolFacture.Charge_Piece( _Piece_id: Integer; _slLoaded: TBatpro_StringList = nil);
var
   SQL: String;
begin
     SQL:= 'select * from '+NomTable+' where Piece_id = '+IntToStr( _Piece_id);

     Load( SQL, _slLoaded);
end;

procedure TpoolFacture.Charge_non_reglee( _slLoaded: TBatpro_StringList);
var
   SQL: String;
begin
     SQL:= 'select * from '+NomTable+' where Piece_id = 0';

     Load( SQL, _slLoaded);
end;

class function TpoolFacture.Classe_Iterateur: TIterateur_Class;
begin
     Result:= TIterateur_Facture;
end;

function TpoolFacture.Iterateur: TIterateur_Facture;
begin
     Result:= TIterateur_Facture( Iterateur_interne);
end;

function TpoolFacture.Iterateur_Decroissant: TIterateur_Facture;
begin
     Result:= TIterateur_Facture( Iterateur_interne_Decroissant);
end;

function TpoolFacture.MaxNumeroDansAnnee(_Annee: Integer=0): Integer;
var
   SQL: String;
begin
     if 0 = _Annee then _Annee:= CurrentYear;
     SQL
     :=
        'select                                          '+LineEnding
       +'      max(NumeroDansAnnee) as MaxNumeroDansAnnee'+LineEnding
       +'from                                            '+LineEnding
       +'    Facture                                     '+LineEnding
       +'where                                           '+LineEnding
       +'     Annee='+IntToStr(_Annee);
     if not Requete.Integer_from( SQL, 'MaxNumeroDansAnnee', Result)
     then
         Result:= -1;
end;

function TpoolFacture.Annee_Incoherente(_Annee: Integer=0): Boolean;
var
   Fin: Integer;
   I: Integer;
   bl: TblFacture;
begin
     Result:= False;
     Fin:= MaxNumeroDansAnnee( _Annee);
     for I:= Fin-1 downto 1
     do
       begin
       bl:= Get_by_Cle( _Annee, I);
       Result:= nil = bl;
       if Result then break;
       end;
end;

function TpoolFacture.Annee_Incoherente_Message( _Annee: Integer=0): Boolean;
begin
     Result:= Annee_Incoherente( _Annee);
     if Result
     then
         fAccueil_Erreur( 'Incohérence de numérotation pour l''année '+IntToStr(_Annee));

end;


function TpoolFacture.Nouveau_Numero( _Annee: Integer=0): Integer;
begin
     Result:= MaxNumeroDansAnnee( _Annee) + 1;
end;

