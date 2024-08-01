unit ublMois;
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
    uPool,

    ublFacture,


    SysUtils, Classes, SqlDB, DB, DateUtils;

type
 TblMois= class;
  { ThaMois__Piece }
  ThaMois__Piece
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
     blMois: TblMois;  
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
   //Total des lignes
   public
     function CalculeTotal: Double;
     procedure Montant_from_Total;
   end;

  { ThaMois__Facture }
  ThaMois__Facture
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
     blMois: TblMois;  
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
     function Iterateur: TIterateur_Facture;
     function Iterateur_Decroissant: TIterateur_Facture;
   end;




 { TblMois }

 TblMois
 =
  class( TBatpro_Ligne)
  //Gestion du cycle de vie
  public
    constructor Create( _sl: TBatpro_StringList; _jsdc: TjsDataContexte; _pool: Tpool_Ancetre_Ancetre); override;
    destructor Destroy; override;
  //champs persistants
  public
    Annee  : Integer; cAnnee  : TChamp;
    Mois   : Integer; cMois   : TChamp;
    Montant: Double ; cMontant: TChamp;
    Declare: Integer;
    URSSAF : Integer;
  //Annee
  private
    FAnnee_bl: TBatpro_Ligne;
    FAnnee: String;
    procedure SetAnnee_bl(const Value: TBatpro_Ligne);
    procedure Annee_Connecte;
    procedure Annee_Desaggrege;
  public
    property Annee_bl: TBatpro_Ligne read FAnnee_bl write SetAnnee_bl;
  //Libelle
  private
    FLibelle: String;
    procedure Libelle_from_;
    function GetLibelle: String;
  public
    cLibelle: TChamp;
    property Libelle: String read GetLibelle;
  //URSSAF_evalue
  public
    URSSAF_evalue: Integer; cURSSAF_evalue: TChamp;
  //URSSAF_reste
  public
    URSSAF_reste: double; cURSSAF_reste: TChamp;
  //CAF_net
  public
    CAF_net: Integer; cCAF_net: TChamp;
  //Gestion de la clé
  public
    class function sCle_from_( _Annee: Integer;  _Mois: Integer): String;

    function sCle: String; override;
  //Gestion des déconnexions
  public
    procedure Unlink(be: TBatpro_Element); override;
  //Aggrégations
  protected
    procedure Create_Aggregation( Name: String; P: ThAggregation_Create_Params); override;
  //Aggrégation vers les Piece correspondants
  private
    FhaPiece: ThaMois__Piece;
    function GethaPiece: ThaMois__Piece;
  public
    property haPiece: ThaMois__Piece read GethaPiece;
  //Aggrégation vers les Facture correspondants
  private
    FhaFacture: ThaMois__Facture;
    function GethaFacture: ThaMois__Facture;
  public
    property haFacture: ThaMois__Facture read GethaFacture;

  end;

 TIterateur_Mois
 =
  class( TIterateur)
  //Iterateur
  public
    procedure Suivant( out _Resultat: TblMois);
    function  not_Suivant( out _Resultat: TblMois): Boolean;
  end;

 TslMois
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
    function Iterateur: TIterateur_Mois;
    function Iterateur_Decroissant: TIterateur_Mois;
  end;

function blMois_from_sl( sl: TBatpro_StringList; Index: Integer): TblMois;
function blMois_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TblMois;

var
   ublMois_poolAnnee: TPool = nil;


implementation

function blMois_from_sl( sl: TBatpro_StringList; Index: Integer): TblMois;
begin
     _Classe_from_sl( Result, TblMois, sl, Index);
end;

function blMois_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TblMois;
begin
     _Classe_from_sl_sCle( Result, TblMois, sl, sCle);
end;

{ TIterateur_Mois }

function TIterateur_Mois.not_Suivant( out _Resultat: TblMois): Boolean;
begin
     Result:= not_Suivant_interne( _Resultat);
end;

procedure TIterateur_Mois.Suivant( out _Resultat: TblMois);
begin
     Suivant_interne( _Resultat);
end;

{ TslMois }

constructor TslMois.Create( _Nom: String= '');
begin
     inherited CreateE( _Nom, TblMois);
end;

destructor TslMois.Destroy;
begin
     inherited;
end;

class function TslMois.Classe_Iterateur: TIterateur_Class;
begin
     Result:= TIterateur_Mois;
end;

function TslMois.Iterateur: TIterateur_Mois;
begin
     Result:= TIterateur_Mois( Iterateur_interne);
end;

function TslMois.Iterateur_Decroissant: TIterateur_Mois;
begin
     Result:= TIterateur_Mois( Iterateur_interne_Decroissant);
end;

{ ThaMois__Piece }

constructor ThaMois__Piece.Create( _Parent: TBatpro_Element;
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
     if Affecte_( blMois, TblMois, Parent) then exit;
end;

destructor ThaMois__Piece.Destroy;
begin
     inherited;
end;

procedure ThaMois__Piece.Charge;
var
   I: TIterateur_Piece;
   bl: TblPiece;
begin
     poolPiece.Charge_Mois( blMois.Annee, blMois.Mois, sl);
     I:= Iterateur;
     try
        while I.Continuer
        do
          begin
          if I.not_Suivant( bl) then Continue;

          bl.Mois_bl:= blMois;
          end;
     finally
            FreeAndNil( I);
            end;
     Montant_from_Total;
end;

procedure ThaMois__Piece.Delete_from_database;
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

class function ThaMois__Piece.Classe_Iterateur: TIterateur_Class;
begin
     Result:= TIterateur_Piece;
end;

function ThaMois__Piece.Iterateur: TIterateur_Piece;
begin
     Result:= TIterateur_Piece(Iterateur_interne);
end;

function ThaMois__Piece.Iterateur_Decroissant: TIterateur_Piece;
begin
     Result:= TIterateur_Piece(Iterateur_interne_Decroissant);
end;

function ThaMois__Piece.CalculeTotal: Double;
var
   I: TIterateur_Piece;
   bl: TblPiece;
   blFacture: TblFacture;
begin
     Result:= 0;
     I:= Iterateur;
     try
        while I.Continuer
        do
          begin
          if I.not_Suivant( bl) then continue;

          blFacture:= bl.Facture_bl;
          if nil = blFacture then continue;

          Result:= Result + blFacture.Montant;
          end;
     finally
            FreeAndNil( I);
            end;
     Result:= Arrondi_Arithmetique_00( Result);
end;

procedure ThaMois__Piece.Montant_from_Total;
var
   Total: double;
   Total_declare: double;
begin
     Total:= CalculeTotal;

     if         Reel_Zero( blMois.Montant)
        and not Reel_Zero( Total         )
     then
         blMois.cMontant.asDouble:= Total
     else
         if Total <> blMois.Montant
         then
             fAccueil_Erreur( 'Mois '+blMois.Libelle+', montant incohérent: '+blMois.cMontant.Chaine+' calculé: '+FloatToStr( Total));

    Total_declare:= Arrondi_Arithmetique_( Total);
    //2023 03 01
    // Cotisations URSSAF
    // Prestations de services (bnc et bic) et vente de marchandises (bic) 21,20 %
    // Versement liberatoire de l'impot sur le revenu (prestations bnc) 2,20 %
    // Formation prof.liberale obligatoire 0,20 %
    // total: 23,6 %

    //2024 08 01
    // Cotisations URSSAF
    // Prestations de services (bnc et bic) et vente de marchandises (bic) 23,20 %  (+2%)
    // Versement liberatoire de l'impot sur le revenu (prestations bnc) 2,20 %
    // Formation prof.liberale obligatoire 0,20 %
    // total: 25,6 %
    blMois.cURSSAF_evalue.asDouble:= Arrondi_Arithmetique_( Total_declare *    0.256 );
    blMois.cURSSAF_reste .asDouble:= Total - blMois.URSSAF_evalue;

    //CAF net from brut: 34%
    blMois.cCAF_net.asDouble:= Arrondi_Arithmetique_( Total_declare * (1-0.34));
end;

{ ThaMois__Facture }

constructor ThaMois__Facture.Create( _Parent: TBatpro_Element;
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
     if Affecte_( blMois, TblMois, Parent) then exit;
end;

destructor ThaMois__Facture.Destroy;
begin
     inherited;
end;

procedure ThaMois__Facture.Charge;
var
   I: TIterateur_Facture;
   bl: TblFacture;
begin
     poolFacture.Charge_Mois( StartOfAMonth(blMois.Annee, blMois.Mois), sl);
     I:= Iterateur;
     try
        while I.Continuer
        do
          begin
          if I.not_Suivant( bl) then Continue;

          bl.Mois_bl:= blMois;
          end;
     finally
            FreeAndNil( I);
            end;
end;

procedure ThaMois__Facture.Delete_from_database;
begin
end;

class function ThaMois__Facture.Classe_Iterateur: TIterateur_Class;
begin
     Result:= TIterateur_Facture;
end;

function ThaMois__Facture.Iterateur: TIterateur_Facture;
begin
     Result:= TIterateur_Facture(Iterateur_interne);
end;

function ThaMois__Facture.Iterateur_Decroissant: TIterateur_Facture;
begin
     Result:= TIterateur_Facture(Iterateur_interne_Decroissant);
end;



{ TblMois }

constructor TblMois.Create( _sl: TBatpro_StringList; _jsdc: TjsDataContexte; _pool: Tpool_Ancetre_Ancetre);
var
   CP: IblG_BECP;
begin
     CP:= Init_ClassParams;
     if Assigned( CP)
     then
         begin
         CP.Libelle:= 'Mois';
         CP.Font.Name:= sys_Times_New_Roman;
         CP.Font.Size:= 12;
         end;

     inherited;

     Champs.ChampDefinitions.NomTable:= 'Mois';

     //champs persistants
     cAnnee  := Integer_from_Integer( Annee  , 'Annee'  );
     cAnnee.OnChange.Abonne( Self, sCle_Change);
     cMois   := Integer_from_Integer( Mois   , 'Mois'   );
     cMois.OnChange.Abonne( Self, sCle_Change);
     cMontant:=  Double_from_       ( Montant, 'Montant');
                Integer_from_       ( Declare, 'Declare');
                Integer_from_       ( URSSAF , 'URSSAF' );


     //Détail Annee
     FAnnee_bl:= nil;

     //Libelle
     cLibelle:= Ajoute_String ( FLibelle, 'Libelle', False);
     cAnnee.OnChange.Abonne( Self, Libelle_from_);
     cMois .OnChange.Abonne( Self, Libelle_from_);
     Libelle_from_;

     cURSSAF_evalue:= Ajoute_Integer( URSSAF_evalue, 'URSSAF_evalue', False);
     cURSSAF_reste := Ajoute_Float  ( URSSAF_reste , 'URSSAF_reste' , False);
     cCAF_net      := Ajoute_Integer( CAF_net      , 'CAF_net'      , False);
end;

destructor TblMois.Destroy;
begin

     inherited;
end;

class function TblMois.sCle_from_( _Annee: Integer;  _Mois: Integer): String;
begin 
     Result:=  Format( '%.4d_%.2d', [_Annee, _Mois]);
end;  

function TblMois.sCle: String;
begin
     Result:= sCle_from_( Annee, Mois);
end;

procedure TblMois.Unlink( be: TBatpro_Element);
begin
     inherited Unlink( be);
     if Annee_bl = be then Annee_Desaggrege;

end;

procedure TblMois.Create_Aggregation( Name: String; P: ThAggregation_Create_Params);
begin
          if 'Piece'   = Name then P.Faible( ThaMois__Piece, TblPiece, poolPiece)
     else if 'Facture' = Name then P.Faible( ThaMois__Facture, TblFacture, poolFacture)
     else                  inherited Create_Aggregation( Name, P);
end;

function  TblMois.GethaPiece: ThaMois__Piece;
begin
     if FhaPiece = nil
     then
         FhaPiece:= Aggregations['Piece'] as ThaMois__Piece;

     Result:= FhaPiece;
end;

function  TblMois.GethaFacture: ThaMois__Facture;
begin
     if FhaFacture = nil
     then
         FhaFacture:= Aggregations['Facture'] as ThaMois__Facture;

     Result:= FhaFacture;
end;


procedure TblMois.SetAnnee_bl(const Value: TBatpro_Ligne);
begin
     if FAnnee_bl = Value then exit;

     Annee_Desaggrege;

     FAnnee_bl:= Value;

     Annee_Connecte;
end;

procedure TblMois.Annee_Connecte;
begin
     if nil = Annee_bl then exit;

     if Assigned(Annee_bl) 
     then 
         Annee_bl.Aggregations.by_Name[ 'Mois'].Ajoute(Self);
     Connect_To( FAnnee_bl);
end;

procedure TblMois.Annee_Desaggrege;
begin
     if Annee_bl = nil then exit;

     if Assigned(Annee_bl) 
     then 
         Annee_bl.Aggregations.by_Name[ 'Mois'].Enleve(Self);
     Unconnect_To( FAnnee_bl);
end;

procedure TblMois.Libelle_from_;
var
   D: TDateTime;
   S: String;
begin
     if TryEncodeDate(Annee, Mois, 01, D)
     then
         S:= FormatDateTime( 'yyyy mm mmmm ', D)
     else
         S:= sCle;
     cLibelle.Chaine:= S;
end;

function TblMois.GetLibelle: String;
begin
     Libelle_from_;
     Result:= FLibelle;
end;


initialization
finalization
end.


