unit ublFacture;
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            http://www.mars42.com                                               |
                                                                                |
    Copyright 2019 Jean SUZINEAU - MARS42                                       |
                                                                                |
    This program is free software: you can redistribute it and/or modify        |
    it under the terms of the GNU Lesser General Public License as published by |
    the Free Software Foundation, either version 3 of the License, or           |
    (at your option) any later version.                                         |
                                                                                |
    This program is distributed in the hope that it will be useful,             |
    but WITHOUT ANY WARRANTY; without even the implied warranty of              |
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the               |
    GNU Lesser General Public License for more details.                         |
                                                                                |
    You should have received a copy of the GNU Lesser General Public License    |
    along with this program.  If not, see <http://www.gnu.org/licenses/>.       |
                                                                                |
|                                                                               }

interface

uses
    uClean,
    ufAccueil_Erreur,
    uReels,
    uDataUtilsU,
    u_sys_,
    uuStrings,
    uBatpro_StringList,
    uChamp,

    uBatpro_Element,
    uBatpro_Ligne,

    udmDatabase,
    upool_Ancetre_Ancetre,
    upool,

    ublPiece,
    upoolPiece,
    ublFacture_Ligne,
    upoolFacture_Ligne,



    SysUtils, Classes, SqlDB, DB;

type
 TblFacture= class;
  { ThaFacture__Piece }
  ThaFacture__Piece
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
     blFacture: TblFacture;  
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
     function Iterateur: TIterateur_Piece;
     function Iterateur_Decroissant: TIterateur_Piece;
   end;


  { ThaFacture__Facture_Ligne }
  ThaFacture__Facture_Ligne
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
     blFacture: TblFacture;  
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
     function Iterateur: TIterateur_Facture_Ligne;
     function Iterateur_Decroissant: TIterateur_Facture_Ligne;
   //Total des lignes
   public
     function CalculeTotal: Double;
     procedure Montant_from_Total;
   end;




 { TblFacture }

 TblFacture
 =
  class( TBatpro_Ligne)
  //Gestion du cycle de vie
  public
    constructor Create( _sl: TBatpro_StringList; _jsdc: TjsDataContexte; _pool: Tpool_Ancetre_Ancetre); override;
    destructor Destroy; override;
  //champs persistants
  public
    Annee          : Integer; cAnnee: TChamp;
    NumeroDansAnnee: Integer; cNumeroDansAnnee: TChamp;
    NbHeures: String;
  //Montant
  public
    Montant: Double; cMontant: TChamp;
    Montant_s: String; cMontant_s: TChamp;
    procedure Montant_s_GetChaine( var _Chaine: String);
  //Numero
  public
    Numero: String; cNumero: TChamp;
    procedure Numero_from_;
  //Date
  public
    Date: TDateTime; cDate: TChamp;
    procedure Date_from_Now;
  //Nom
  public
    Nom: String; cNom: TChamp;
    procedure Nom_from_;
  //Client
  private
    FClient_id: Integer;
    FClient_bl: TBatpro_Ligne;
    FClient: String;
    procedure SetClient_bl(const Value: TBatpro_Ligne);
    procedure SetClient_id(const Value: Integer);
    procedure Client_id_Change;
    procedure Client_Connecte;
    procedure Client_Aggrege;
    procedure Client_Desaggrege;
    procedure Client_Change;
  public
    cClient_id: TChamp;
    cClient: TChamp;
    property Client_id: Integer       read FClient_id write SetClient_id;
    property Client_bl: TBatpro_Ligne read FClient_bl write SetClient_bl;
    function Client: String;

  //Gestion de la clé
  public
    class function sCle_from_( _Annee: Integer;  _NumeroDansAnnee: Integer): String;

    function sCle: String; override;
  //Gestion des déconnexions
  public
    procedure Unlink(be: TBatpro_Element); override;
  //Aggrégations
  protected
    procedure Create_Aggregation( Name: String; P: ThAggregation_Create_Params); override;
  //Aggrégation vers les Piece correspondants
  private
    FhaPiece: ThaFacture__Piece;
    function GethaPiece: ThaFacture__Piece;
  public
    property haPiece: ThaFacture__Piece read GethaPiece;
  //Aggrégation vers les Facture_Ligne correspondants
  private
    FhaFacture_Ligne: ThaFacture__Facture_Ligne;
    function GethaFacture_Ligne: ThaFacture__Facture_Ligne;
  public
    property haFacture_Ligne: ThaFacture__Facture_Ligne read GethaFacture_Ligne;
  //Pour impression
  public
    Label_Total: String;
    Label_TVA: String;
  end;

 TIterateur_Facture
 =
  class( TIterateur)
  //Iterateur
  public
    procedure Suivant( out _Resultat: TblFacture);
    function  not_Suivant( out _Resultat: TblFacture): Boolean;
  end;

 TslFacture
 =
  class( TBatpro_StringList)
  //Gestion du cycle de vie
  public
    constructor Create( _Nom: String= ''); override;
    destructor Destroy; override;
  //Création d'itérateur
  protected
    class function Classe_Iterateur: TIterateur_Class; override;
  public
    function Iterateur: TIterateur_Facture;
    function Iterateur_Decroissant: TIterateur_Facture;
  end;

function blFacture_from_sl( sl: TBatpro_StringList; Index: Integer): TblFacture;
function blFacture_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TblFacture;

var
   ublFacture_poolClient: TPool = nil;


implementation

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

{ ThaFacture__Piece }

constructor ThaFacture__Piece.Create( _Parent: TBatpro_Element;
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

destructor ThaFacture__Piece.Destroy;
begin
     inherited;
end;

procedure ThaFacture__Piece.Charge;
begin
     poolPiece.Charge_Facture( blFacture.id);
end;

procedure ThaFacture__Piece.Delete_from_database;
var
   I: TIterateur_Piece;
   bl: TblPiece;
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

class function ThaFacture__Piece.Classe_Iterateur: TIterateur_Class;
begin
     Result:= TIterateur_Piece;
end;

function ThaFacture__Piece.Iterateur: TIterateur_Piece;
begin
     Result:= TIterateur_Piece(Iterateur_interne);
end;

function ThaFacture__Piece.Iterateur_Decroissant: TIterateur_Piece;
begin
     Result:= TIterateur_Piece(Iterateur_interne_Decroissant);
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
begin
     Total:= CalculeTotal;

     if Reel_Zero( blFacture.Montant)
     then
         blFacture.Montant:= Total
     else
         if Total <> blFacture.Montant
         then
             fAccueil_Erreur( 'Facture '+blFacture.Nom+', montant incohérent');

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
     cDate.Definition.Typ:= ftDate;
     cDate.Definition.Format_DateTime:='dddd d mmmm yyyy';
     cNom:= String_from_String ( Nom            , 'Nom'            );
     cLibelle:= cNom;
     Champs.  String_from_String ( NbHeures       , 'NbHeures'       );

     //Montant
     cMontant:=          Double_from_( Montant  , 'Montant'  );
     cMontant_s:= Ajoute_String      ( Montant_s, 'Montant_s', False);
     cMontant_s.OnGetChaine:= Montant_s_GetChaine;

     //Détail Client
     FClient_bl:= nil;
     cClient_id:= Integer_from_Integer( FClient_id, 'Client_id');
     cClient  := Champs.String_Lookup( FClient, 'Client', cClient_id, ublFacture_poolClient.GetLookupListItems, '');
     Client_id_Change;
     cClient_id.OnChange.Abonne( Self, Client_id_Change);

     //Numéro de facture
     cNumero:= Ajoute_String ( Numero, 'Numero', False);
     cAnnee          .OnChange.Abonne( Self, Numero_from_);
     cNumeroDansAnnee.OnChange.Abonne( Self, Numero_from_);
     Numero_from_;

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
     cNumero.Chaine:= Format( '%.4d_%.2d', [Annee, NumeroDansAnnee]);
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
     Nom:= Format( '%s_%.2d_%.2d_', [Numero, M, D]);
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

end;

procedure TblFacture.Create_Aggregation( Name: String; P: ThAggregation_Create_Params);
begin
          if 'Piece' = Name then P.Faible( ThaFacture__Piece, TblPiece, poolPiece)
     else if 'Facture_Ligne' = Name then P.Faible( ThaFacture__Facture_Ligne, TblFacture_Ligne, poolFacture_Ligne)
     else                  inherited Create_Aggregation( Name, P);
end;


function  TblFacture.GethaPiece: ThaFacture__Piece;
begin
     if FhaPiece = nil
     then
         FhaPiece:= Aggregations['Piece'] as ThaFacture__Piece;

     Result:= FhaPiece;
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

 

initialization
finalization
end.


