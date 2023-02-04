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
    Annee: Integer;
    NumeroDansAnnee: Integer;
    Date: TDateTime; cDate: TChamp;
    NbHeures: Double;
    Montant: Double;
  //Nom
  public
    Nom: String; cNom: TChamp;
    procedure Nom_from_;
  //Client
  private
    FidClient: Integer;
    FblClient: TBatpro_Ligne;
    FClient: String;
    procedure SetblClient(const Value: TBatpro_Ligne);
    procedure SetidClient(const Value: Integer);
    procedure idClient_Change;
    procedure Client_Connecte;
    procedure Client_Aggrege;
    procedure Client_Desaggrege;
    procedure Client_Change;
  public
    cidClient: TChamp;
    cClient: TChamp;
    property idClient: Integer read FidClient write SetidClient;
    property blClient: TBatpro_Ligne read FblClient write SetblClient;
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
     Champs. Integer_from_Integer( Annee          , 'Annee'          );
     Champs. Integer_from_Integer( NumeroDansAnnee, 'NumeroDansAnnee');
     cDate:= DateTime_from_( Date           , 'Date'           );
     cDate.Definition.Typ:= ftDate;
     cNom:= String_from_String ( Nom            , 'Nom'            );
     cLibelle:= cNom;
     Champs.  Double_from_       ( NbHeures       , 'NbHeures'       );
     Champs.  Double_from_       ( Montant        , 'Montant'        );


     FblClient:= nil;
     cidClient:= Integer_from_Integer( FidClient, 'idClient');
     cClient  := Champs.String_Lookup( FClient  , 'Client'  , cidClient, ublFacture_poolClient.GetLookupListItems, '');
     idClient_Change;
     cidClient.OnChange.Abonne( Self, idClient_Change);


end;

destructor TblFacture.Destroy;
begin

     inherited;
end;

procedure TblFacture.Nom_from_;
var
   Y, M, D: Word;
begin
     if Nom <> '' then exit;

     DecodeDate( Date, Y, M, D);
     Nom
     :=
       Format( '%4d_%2d_%2d_%2d_',
               [Annee, NumeroDansAnnee, M, D]);
     if Assigned( blClient)
     then
         Nom:= Nom + blClient.GetLibelle;
     cNom.Chaine:= Nom;//juste pour les évènements de publication et sauvegarde
end;

class function TblFacture.sCle_from_( _Annee: Integer;  _NumeroDansAnnee: Integer): String;
begin 
     Result:=  Format('%4d%4d',[_Annee, _NumeroDansAnnee]);
end;  

function TblFacture.sCle: String;
begin
     Result:= sCle_from_( Annee, NumeroDansAnnee);
end;

procedure TblFacture.Unlink( be: TBatpro_Element);
begin
     inherited Unlink( be);
if blClient = be then Client_Desaggrege;

end;

procedure TblFacture.Create_Aggregation( Name: String; P: ThAggregation_Create_Params);
begin
          if 'Piece' = Name then P.Faible( ThaFacture__Piece, TblPiece, poolPiece)
     else                  inherited Create_Aggregation( Name, P);
end;


function  TblFacture.GethaPiece: ThaFacture__Piece;
begin
     if FhaPiece = nil
     then
         FhaPiece:= Aggregations['Piece'] as ThaFacture__Piece;

     Result:= FhaPiece;
end;


procedure TblFacture.SetidClient(const Value: Integer);
begin
     if FidClient = Value then exit;
     FidClient:= Value;
     idClient_Change;
     Save_to_database;
end;

procedure TblFacture.idClient_Change;
begin
     Client_Aggrege;
end;

procedure TblFacture.SetblClient(const Value: TBatpro_Ligne);
begin
     if FblClient = Value then exit;

     Client_Desaggrege;

     FblClient:= Value;

     if idClient <> FblClient.id
     then
         begin
         idClient:= FblClient.id;
         Save_to_database;
         end;

     Client_Connecte;
end;

procedure TblFacture.Client_Connecte;
begin
     if nil = blClient then exit;

     if Assigned(blClient) 
     then 
         blClient.Aggregations.by_Name[ 'Facture'].Ajoute(Self);
     Connect_To( FblClient);

     Nom_from_;
end;

procedure TblFacture.Client_Aggrege;
var
   blClient_New: TBatpro_Ligne;
begin                                                        
     ublFacture_poolClient.Get_Interne_from_id( idClient, blClient_New);
     if blClient = blClient_New then exit;

     Client_Desaggrege;
     FblClient:= blClient_New;

     Client_Connecte;
end;

procedure TblFacture.Client_Desaggrege;
begin
     if blClient = nil then exit;

     if Assigned(blClient) 
     then 
         blClient.Aggregations.by_Name[ 'Facture'].Enleve(Self);
     Unconnect_To( FblClient);
end;

procedure TblFacture.Client_Change;
begin
     if Assigned( FblClient)
     then
         FClient:= FblClient.GetLibelle
     else
         FClient:= '';
end;

function TblFacture.Client: String;
begin
     if Assigned( FblClient)
     then
         Result:= FblClient.GetLibelle
     else
         Result:= '';
end;

 

initialization
finalization
end.


