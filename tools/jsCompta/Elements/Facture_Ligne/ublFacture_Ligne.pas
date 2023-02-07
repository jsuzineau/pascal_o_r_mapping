unit ublFacture_Ligne;
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

//Aggregations_Pascal_ubl_uses_details_pas


    SysUtils, Classes, SqlDB, DB;

type
 TblFacture_Ligne= class;
//pattern_aggregation_classe_declaration

 { TblFacture_Ligne }

 TblFacture_Ligne
 =
  class( TBatpro_Ligne)
  //Gestion du cycle de vie
  public
    constructor Create( _sl: TBatpro_StringList; _jsdc: TjsDataContexte; _pool: Tpool_Ancetre_Ancetre); override;
    destructor Destroy; override;
  //champs persistants
  public
    Date: String;
    Libelle: String;
    NbHeures: Double; cNbHeures: TChamp;
    Prix_unitaire: Double; cPrix_unitaire: TChamp;
 //Montant
 public
    Montant: Double; cMontant: TChamp;
    procedure Montant_from_;
  //Facture
  private
    FFacture_id: Integer;
    FFacture_bl: TBatpro_Ligne;
    FFacture: String;
    procedure SetFacture_bl(const Value: TBatpro_Ligne);
    procedure SetFacture_id(const Value: Integer);
    procedure Facture_id_Change;
    procedure Facture_Connecte;
    procedure Facture_Aggrege;
    procedure Facture_Desaggrege;
    procedure Facture_Change;
  public
    cFacture_id: TChamp;
    property Facture_id: Integer       read FFacture_id write SetFacture_id;
    property Facture_bl: TBatpro_Ligne read FFacture_bl write SetFacture_bl;
    function Facture: String;

  //Gestion de la clé
  public
//pattern_sCle_from__Declaration
    function sCle: String; override;
  //Gestion des déconnexions
  public
    procedure Unlink(be: TBatpro_Element); override;
//pattern_aggregation_function_Create_Aggregation_declaration
  end;

 TIterateur_Facture_Ligne
 =
  class( TIterateur)
  //Iterateur
  public
    procedure Suivant( out _Resultat: TblFacture_Ligne);
    function  not_Suivant( out _Resultat: TblFacture_Ligne): Boolean;
  end;

 TslFacture_Ligne
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
    function Iterateur: TIterateur_Facture_Ligne;
    function Iterateur_Decroissant: TIterateur_Facture_Ligne;
  end;

function blFacture_Ligne_from_sl( sl: TBatpro_StringList; Index: Integer): TblFacture_Ligne;
function blFacture_Ligne_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TblFacture_Ligne;

var
   ublFacture_Ligne_poolFacture: TPool = nil;


implementation

function blFacture_Ligne_from_sl( sl: TBatpro_StringList; Index: Integer): TblFacture_Ligne;
begin
     _Classe_from_sl( Result, TblFacture_Ligne, sl, Index);
end;

function blFacture_Ligne_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TblFacture_Ligne;
begin
     _Classe_from_sl_sCle( Result, TblFacture_Ligne, sl, sCle);
end;

{ TIterateur_Facture_Ligne }

function TIterateur_Facture_Ligne.not_Suivant( out _Resultat: TblFacture_Ligne): Boolean;
begin
     Result:= not_Suivant_interne( _Resultat);
end;

procedure TIterateur_Facture_Ligne.Suivant( out _Resultat: TblFacture_Ligne);
begin
     Suivant_interne( _Resultat);
end;

{ TslFacture_Ligne }

constructor TslFacture_Ligne.Create( _Nom: String= '');
begin
     inherited CreateE( _Nom, TblFacture_Ligne);
end;

destructor TslFacture_Ligne.Destroy;
begin
     inherited;
end;

class function TslFacture_Ligne.Classe_Iterateur: TIterateur_Class;
begin
     Result:= TIterateur_Facture_Ligne;
end;

function TslFacture_Ligne.Iterateur: TIterateur_Facture_Ligne;
begin
     Result:= TIterateur_Facture_Ligne( Iterateur_interne);
end;

function TslFacture_Ligne.Iterateur_Decroissant: TIterateur_Facture_Ligne;
begin
     Result:= TIterateur_Facture_Ligne( Iterateur_interne_Decroissant);
end;

//pattern_aggregation_classe_implementation

{ TblFacture_Ligne }

constructor TblFacture_Ligne.Create( _sl: TBatpro_StringList; _jsdc: TjsDataContexte; _pool: Tpool_Ancetre_Ancetre);
var
   CP: IblG_BECP;
begin
     CP:= Init_ClassParams;
     if Assigned( CP)
     then
         begin
         CP.Libelle:= 'Facture_Ligne';
         CP.Font.Name:= sys_Times_New_Roman;
         CP.Font.Size:= 12;
         end;

     inherited;

     Champs.ChampDefinitions.NomTable:= 'Facture_Ligne';

     //champs persistants
     Champs.          String_from_String( Date           , 'Date'           );
     Champs.          String_from_String( Libelle        , 'Libelle'        );
     cNbHeures     := Double_from_      ( NbHeures       , 'NbHeures'       );
     cPrix_unitaire:= Double_from_      ( Prix_unitaire  , 'Prix_unitaire'  );
     cMontant      := Double_from_      ( Montant        , 'Montant'        );
     cNbHeures     .OnChange.Abonne( Self, Montant_from_);
     cPrix_unitaire.OnChange.Abonne( Self, Montant_from_);


     FFacture_bl:= nil;
     cFacture_id:= Integer_from_Integer( FFacture_id, 'Facture_id');
     Champs.String_Lookup( FFacture, 'Facture', cFacture_id, ublFacture_Ligne_poolFacture.GetLookupListItems, '');
     Facture_id_Change;
     cFacture_id.OnChange.Abonne( Self, Facture_id_Change);


end;

destructor TblFacture_Ligne.Destroy;
begin

     inherited;
end;

procedure TblFacture_Ligne.Montant_from_;
begin
     cMontant.asDouble:= Arrondi_Arithmetique_00( NbHeures * Prix_unitaire);
end;

//pattern_sCle_from__Implementation

function TblFacture_Ligne.sCle: String;
begin
     Result:= sCle_ID;
end;

procedure TblFacture_Ligne.Unlink( be: TBatpro_Element);
begin
     inherited Unlink( be);
     if Facture_bl = be then Facture_Desaggrege;

end;

(*
procedure TblFacture_Ligne.Create_Aggregation( Name: String; P: ThAggregation_Create_Params);
begin
          
     else                  inherited Create_Aggregation( Name, P);
end;
*)

//pattern_aggregation_accesseurs_implementation

procedure TblFacture_Ligne.SetFacture_id(const Value: Integer);
begin
     if FFacture_id = Value then exit;
     FFacture_id:= Value;
     Facture_id_Change;
     Save_to_database;
end;

procedure TblFacture_Ligne.Facture_id_Change;
begin
     Facture_Aggrege;
end;

procedure TblFacture_Ligne.SetFacture_bl(const Value: TBatpro_Ligne);
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

procedure TblFacture_Ligne.Facture_Connecte;
begin
     if nil = Facture_bl then exit;

     if Assigned(Facture_bl) 
     then 
         Facture_bl.Aggregations.by_Name[ 'Facture_Ligne'].Ajoute(Self);
     Connect_To( FFacture_bl);
end;

procedure TblFacture_Ligne.Facture_Aggrege;
var
   Facture_bl_New: TBatpro_Ligne;
begin                                                        
     ublFacture_Ligne_poolFacture.Get_Interne_from_id( Facture_id, Facture_bl_New);
     if Facture_bl = Facture_bl_New then exit;

     Facture_Desaggrege;
     FFacture_bl:= Facture_bl_New;

     Facture_Connecte;
end;

procedure TblFacture_Ligne.Facture_Desaggrege;
begin
     if Facture_bl = nil then exit;

     if Assigned(Facture_bl) 
     then 
         Facture_bl.Aggregations.by_Name[ 'Facture_Ligne'].Enleve(Self);
     Unconnect_To( FFacture_bl);
end;

procedure TblFacture_Ligne.Facture_Change;
begin
     if Assigned( FFacture_bl)
     then
         FFacture:= FFacture_bl.GetLibelle
     else
         FFacture:= '';
end;

function TblFacture_Ligne.Facture: String;
begin
     if Assigned( FFacture_bl)
     then
         Result:= FFacture_bl.GetLibelle
     else
         Result:= '';
end;

 

initialization
finalization
end.


