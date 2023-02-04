unit ublPiece;
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

//Aggregations_Pascal_ubl_uses_details_pas


    SysUtils, Classes, SqlDB, DB;

type
 TblPiece= class;
//pattern_aggregation_classe_declaration

 { TblPiece }

 TblPiece
 =
  class( TBatpro_Ligne)
  //Gestion du cycle de vie
  public
    constructor Create( _sl: TBatpro_StringList; _jsdc: TjsDataContexte; _pool: Tpool_Ancetre_Ancetre); override;
    destructor Destroy; override;
  //champs persistants
  public
    Date: String;
  //Facture
  private
    FidFacture: Integer;
    FblFacture: TBatpro_Ligne;
    FFacture: String;
    procedure SetblFacture(const Value: TBatpro_Ligne);
    procedure SetidFacture(const Value: Integer);
    procedure idFacture_Change;
    procedure Facture_Connecte;
    procedure Facture_Aggrege;
    procedure Facture_Desaggrege;
    procedure Facture_Change;
  public
    cidFacture: TChamp;
    property idFacture: Integer read FidFacture write SetidFacture;
    property blFacture: TBatpro_Ligne read FblFacture write SetblFacture;
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

 TIterateur_Piece
 =
  class( TIterateur)
  //Iterateur
  public
    procedure Suivant( out _Resultat: TblPiece);
    function  not_Suivant( out _Resultat: TblPiece): Boolean;
  end;

 TslPiece
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
    function Iterateur: TIterateur_Piece;
    function Iterateur_Decroissant: TIterateur_Piece;
  end;

function blPiece_from_sl( sl: TBatpro_StringList; Index: Integer): TblPiece;
function blPiece_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TblPiece;

var
   ublPiece_poolFacture: TPool = nil;


implementation

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
     Champs.  String_from_String ( Date           , 'Date'           );


     FblFacture:= nil;
     cidFacture:= Integer_from_Integer( FidFacture, 'idFacture');
     Champs.String_Lookup( FFacture, 'Facture', cidFacture, ublPiece_poolFacture.GetLookupListItems, '');
     idFacture_Change;
     cidFacture.OnChange.Abonne( Self, idFacture_Change);


end;

destructor TblPiece.Destroy;
begin

     inherited;
end;

//pattern_sCle_from__Implementation

function TblPiece.sCle: String;
begin
     Result:= sCle_ID;
end;

procedure TblPiece.Unlink( be: TBatpro_Element);
begin
     inherited Unlink( be);
if blFacture = be then Facture_Desaggrege;

end;

(*
procedure TblPiece.Create_Aggregation( Name: String; P: ThAggregation_Create_Params);
begin
          
     else                  inherited Create_Aggregation( Name, P);
end;
*)

//pattern_aggregation_accesseurs_implementation

procedure TblPiece.SetidFacture(const Value: Integer);
begin
     if FidFacture = Value then exit;
     FidFacture:= Value;
     idFacture_Change;
     Save_to_database;
end;

procedure TblPiece.idFacture_Change;
begin
     Facture_Aggrege;
end;

procedure TblPiece.SetblFacture(const Value: TBatpro_Ligne);
begin
     if FblFacture = Value then exit;

     Facture_Desaggrege;

     FblFacture:= Value;

     if idFacture <> FblFacture.id
     then
         begin
         idFacture:= FblFacture.id;
         Save_to_database;
         end;

     Facture_Connecte;
end;

procedure TblPiece.Facture_Connecte;
begin
     if nil = blFacture then exit;

     if Assigned(blFacture) 
     then 
         blFacture.Aggregations.by_Name[ 'Piece'].Ajoute(Self);
     Connect_To( FblFacture);
end;

procedure TblPiece.Facture_Aggrege;
var
   blFacture_New: TBatpro_Ligne;
begin                                                        
     ublPiece_poolFacture.Get_Interne_from_id( idFacture, blFacture_New);
     if blFacture = blFacture_New then exit;

     Facture_Desaggrege;
     FblFacture:= blFacture_New;

     Facture_Connecte;
end;

procedure TblPiece.Facture_Desaggrege;
begin
     if blFacture = nil then exit;

     if Assigned(blFacture) 
     then 
         blFacture.Aggregations.by_Name[ 'Piece'].Enleve(Self);
     Unconnect_To( FblFacture);
end;

procedure TblPiece.Facture_Change;
begin
     if Assigned( FblFacture)
     then
         FFacture:= FblFacture.GetLibelle
     else
         FFacture:= '';
end;

function TblPiece.Facture: String;
begin
     if Assigned( FblFacture)
     then
         Result:= FblFacture.GetLibelle
     else
         Result:= '';
end;

 

initialization
finalization
end.


