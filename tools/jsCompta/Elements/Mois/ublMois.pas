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
    u_sys_,
    uuStrings,
    uBatpro_StringList,
    uChamp,

    uBatpro_Element,
    uBatpro_Ligne,

    udmDatabase,
    upool_Ancetre_Ancetre,
    upool,

    ublFacture,


    SysUtils, Classes, SqlDB, DB;

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
    Annee: Integer;
    Mois: Integer;
    Montant: Double;
    Declare: Double;
    URSSAF: Double;
  //Annee
  private
    FAnnee_bl: TBatpro_Ligne;
    FAnnee: String;
    procedure SetAnnee_bl(const Value: TBatpro_Ligne);
    procedure Annee_Connecte;
    procedure Annee_Desaggrege;
  public
    property Annee_bl: TBatpro_Ligne read FAnnee_bl write SetAnnee_bl;

  //Gestion de la clé
  public
//pattern_sCle_from__Declaration
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
begin
     poolPiece.Charge_Mois( blMois.Annee, blMois.Mois);
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
     Champs. Integer_from_Integer( Annee          , 'Annee'          );
     Champs. Integer_from_Integer( Mois           , 'Mois'           );
     Champs.  Double_from_       ( Montant        , 'Montant'        );
     Champs.  Double_from_       ( Declare        , 'Declare'        );
     Champs.  Double_from_       ( URSSAF         , 'URSSAF'         );


     //Détail Annee
     FAnnee_bl:= nil;


end;

destructor TblMois.Destroy;
begin

     inherited;
end;

//pattern_sCle_from__Implementation

function TblMois.sCle: String;
begin
     Result:= sCle_ID;
end;

procedure TblMois.Unlink( be: TBatpro_Element);
begin
     inherited Unlink( be);
     if Annee_bl = be then Annee_Desaggrege;

end;

procedure TblMois.Create_Aggregation( Name: String; P: ThAggregation_Create_Params);
begin
          if 'Piece' = Name then P.Faible( ThaMois__Piece, TblPiece, poolPiece)
     else                  inherited Create_Aggregation( Name, P);
end;

//pattern_aggregation_accesseurs_implementation

function  TblMois.GethaPiece: ThaMois__Piece;
begin
     if FhaPiece = nil
     then
         FhaPiece:= Aggregations['Piece'] as ThaMois__Piece;

     Result:= FhaPiece;
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


initialization
finalization
end.


