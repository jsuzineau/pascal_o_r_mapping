unit ublClient;
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
    upoolFacture,



    SysUtils, Classes, SqlDB, DB;

type
 TblClient= class;
  { ThaClient__Facture }
  ThaClient__Facture
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
     blClient: TblClient;  
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




 { TblClient }

 TblClient
 =
  class( TBatpro_Ligne)
  //Gestion du cycle de vie
  public
    constructor Create( _sl: TBatpro_StringList; _jsdc: TjsDataContexte; _pool: Tpool_Ancetre_Ancetre); override;
    destructor Destroy; override;
  //champs persistants
  public
    Nom: String;
    Adresse_1: String; cAdresse_1: TChamp;
    Adresse_2: String;
    Adresse_3: String;
    Code_Postal: String;
    Ville: String;
    Tarif_horaire: Double;
    procedure Adresse_1_from_Nom;
//Pascal_ubl_declaration_pas_detail
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
  //Aggrégation vers les Facture correspondants
  private
    FhaFacture: ThaClient__Facture;
    function GethaFacture: ThaClient__Facture;
  public
    property haFacture: ThaClient__Facture read GethaFacture;

  end;

 TIterateur_Client
 =
  class( TIterateur)
  //Iterateur
  public
    procedure Suivant( out _Resultat: TblClient);
    function  not_Suivant( out _Resultat: TblClient): Boolean;
  end;

 TslClient
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
    function Iterateur: TIterateur_Client;
    function Iterateur_Decroissant: TIterateur_Client;
  end;

function blClient_from_sl( sl: TBatpro_StringList; Index: Integer): TblClient;
function blClient_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TblClient;

//Details_Pascal_ubl_declaration_pools_aggregations_pas

implementation

function blClient_from_sl( sl: TBatpro_StringList; Index: Integer): TblClient;
begin
     _Classe_from_sl( Result, TblClient, sl, Index);
end;

function blClient_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TblClient;
begin
     _Classe_from_sl_sCle( Result, TblClient, sl, sCle);
end;

{ TIterateur_Client }

function TIterateur_Client.not_Suivant( out _Resultat: TblClient): Boolean;
begin
     Result:= not_Suivant_interne( _Resultat);
end;

procedure TIterateur_Client.Suivant( out _Resultat: TblClient);
begin
     Suivant_interne( _Resultat);
end;

{ TslClient }

constructor TslClient.Create( _Nom: String= '');
begin
     inherited CreateE( _Nom, TblClient);
end;

destructor TslClient.Destroy;
begin
     inherited;
end;

class function TslClient.Classe_Iterateur: TIterateur_Class;
begin
     Result:= TIterateur_Client;
end;

function TslClient.Iterateur: TIterateur_Client;
begin
     Result:= TIterateur_Client( Iterateur_interne);
end;

function TslClient.Iterateur_Decroissant: TIterateur_Client;
begin
     Result:= TIterateur_Client( Iterateur_interne_Decroissant);
end;

{ ThaClient__Facture }

constructor ThaClient__Facture.Create( _Parent: TBatpro_Element;
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
     if Affecte_( blClient, TblClient, Parent) then exit;
end;

destructor ThaClient__Facture.Destroy;
begin
     inherited;
end;

procedure ThaClient__Facture.Charge;
begin
     poolFacture.Charge_Client( blClient.id);
end;

procedure ThaClient__Facture.Delete_from_database;
var
   I: TIterateur_Facture;
   bl: TblFacture;
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

class function ThaClient__Facture.Classe_Iterateur: TIterateur_Class;
begin
     Result:= TIterateur_Facture;
end;

function ThaClient__Facture.Iterateur: TIterateur_Facture;
begin
     Result:= TIterateur_Facture(Iterateur_interne);
end;

function ThaClient__Facture.Iterateur_Decroissant: TIterateur_Facture;
begin
     Result:= TIterateur_Facture(Iterateur_interne_Decroissant);
end;



{ TblClient }

constructor TblClient.Create( _sl: TBatpro_StringList; _jsdc: TjsDataContexte; _pool: Tpool_Ancetre_Ancetre);
var
   CP: IblG_BECP;
begin
     CP:= Init_ClassParams;
     if Assigned( CP)
     then
         begin
         CP.Libelle:= 'Client';
         CP.Font.Name:= sys_Times_New_Roman;
         CP.Font.Size:= 12;
         end;

     inherited;

     Champs.ChampDefinitions.NomTable:= 'Client';

     //champs persistants
     cLibelle:= String_from_String ( Nom, 'Nom');
     cAdresse_1:= Champs.  String_from_String ( Adresse_1      , 'Adresse_1'      );
     Champs.  String_from_String ( Adresse_2      , 'Adresse_2'      );
     Champs.  String_from_String ( Adresse_3      , 'Adresse_3'      );
     Champs.  String_from_String ( Code_Postal    , 'Code_Postal'    );
     Champs.  String_from_String ( Ville          , 'Ville'          );
     Champs.  Double_from_       ( Tarif_horaire  , 'Tarif_horaire'  );

//Pascal_ubl_constructor_pas_detail
end;

destructor TblClient.Destroy;
begin

     inherited;
end;

procedure TblClient.Adresse_1_from_Nom;
begin
     cAdresse_1.Chaine:= Nom;
end;

//pattern_sCle_from__Implementation

function TblClient.sCle: String;
begin
     Result:= sCle_ID;
end;

procedure TblClient.Unlink( be: TBatpro_Element);
begin
     inherited Unlink( be);
     ;

end;

procedure TblClient.Create_Aggregation( Name: String; P: ThAggregation_Create_Params);
begin
          if 'Facture' = Name then P.Faible( ThaClient__Facture, TblFacture, poolFacture)
     else                  inherited Create_Aggregation( Name, P);
end;


function  TblClient.GethaFacture: ThaClient__Facture;
begin
     if FhaFacture = nil
     then
         FhaFacture:= Aggregations['Facture'] as ThaClient__Facture;

     Result:= FhaFacture;
end;


//Pascal_ubl_implementation_pas_detail

initialization
finalization
end.


