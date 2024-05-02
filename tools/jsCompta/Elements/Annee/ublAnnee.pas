unit ublAnnee;
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

    ublMois,
    upoolMois,



    SysUtils, Classes, SqlDB, DB;

type
 TblAnnee= class;
  { ThaAnnee__Mois }
  ThaAnnee__Mois
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
     blAnnee: TblAnnee;  
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
     function Iterateur: TIterateur_Mois;
     function Iterateur_Decroissant: TIterateur_Mois;
   //Total des lignes
   public
     function CalculeTotal: Double;
     function Calcule_Declare_mois: Integer;

     procedure Declare_from_Total;
   end;




 { TblAnnee }

 TblAnnee
 =
  class( TBatpro_Ligne)
  //Gestion du cycle de vie
  public
    constructor Create( _sl: TBatpro_StringList; _jsdc: TjsDataContexte; _pool: Tpool_Ancetre_Ancetre); override;
    destructor Destroy; override;
  //champs persistants
  public
    Annee       : Integer; cAnnee       : TChamp;
    Declare     : Double ; cDeclare     : TChamp;
    Declare_mois: Integer; cDeclare_mois: TChamp;
//Pascal_ubl_declaration_pas_detail
  //Gestion de la clé
  public
    class function sCle_from_( _Annee: Integer): String;

    function sCle: String; override;
  //Gestion des déconnexions
  public
    procedure Unlink(be: TBatpro_Element); override;
  //Aggrégations
  protected
    procedure Create_Aggregation( Name: String; P: ThAggregation_Create_Params); override;
  //Aggrégation vers les Mois correspondants
  private
    FhaMois: ThaAnnee__Mois;
    function GethaMois: ThaAnnee__Mois;
  public
    property haMois: ThaAnnee__Mois read GethaMois;
  //Libelle
  private
    FLibelle: String;
    procedure Libelle_from_;
    function GetLibelle: String;
  public
    cLibelle: TChamp;
    property Libelle: String read GetLibelle;
  end;

 TIterateur_Annee
 =
  class( TIterateur)
  //Iterateur
  public
    procedure Suivant( out _Resultat: TblAnnee);
    function  not_Suivant( out _Resultat: TblAnnee): Boolean;
  end;

 TslAnnee
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
    function Iterateur: TIterateur_Annee;
    function Iterateur_Decroissant: TIterateur_Annee;
  end;

function blAnnee_from_sl( sl: TBatpro_StringList; Index: Integer): TblAnnee;
function blAnnee_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TblAnnee;

//Details_Pascal_ubl_declaration_pools_aggregations_pas

implementation

function blAnnee_from_sl( sl: TBatpro_StringList; Index: Integer): TblAnnee;
begin
     _Classe_from_sl( Result, TblAnnee, sl, Index);
end;

function blAnnee_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TblAnnee;
begin
     _Classe_from_sl_sCle( Result, TblAnnee, sl, sCle);
end;

{ TIterateur_Annee }

function TIterateur_Annee.not_Suivant( out _Resultat: TblAnnee): Boolean;
begin
     Result:= not_Suivant_interne( _Resultat);
end;

procedure TIterateur_Annee.Suivant( out _Resultat: TblAnnee);
begin
     Suivant_interne( _Resultat);
end;

{ TslAnnee }

constructor TslAnnee.Create( _Nom: String= '');
begin
     inherited CreateE( _Nom, TblAnnee);
end;

destructor TslAnnee.Destroy;
begin
     inherited;
end;

class function TslAnnee.Classe_Iterateur: TIterateur_Class;
begin
     Result:= TIterateur_Annee;
end;

function TslAnnee.Iterateur: TIterateur_Annee;
begin
     Result:= TIterateur_Annee( Iterateur_interne);
end;

function TslAnnee.Iterateur_Decroissant: TIterateur_Annee;
begin
     Result:= TIterateur_Annee( Iterateur_interne_Decroissant);
end;

{ ThaAnnee__Mois }

constructor ThaAnnee__Mois.Create( _Parent: TBatpro_Element;
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
     if Affecte_( blAnnee, TblAnnee, Parent) then exit;
end;

destructor ThaAnnee__Mois.Destroy;
begin
     inherited;
end;

procedure ThaAnnee__Mois.Charge;
var
   I: TIterateur_Mois;
   bl: TblMois;
begin
     poolMois.Charge_Annee( blAnnee.Annee, sl);
     I:= Iterateur;
     try
        while I.Continuer
        do
          begin
          if I.not_Suivant( bl) then Continue;

          bl.Annee_bl:= blAnnee;
          end;
     finally
            FreeAndNil( I);
            end;
     Declare_from_Total;
end;

procedure ThaAnnee__Mois.Delete_from_database;
var
   I: TIterateur_Mois;
   bl: TblMois;
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

class function ThaAnnee__Mois.Classe_Iterateur: TIterateur_Class;
begin
     Result:= TIterateur_Mois;
end;

function ThaAnnee__Mois.Iterateur: TIterateur_Mois;
begin
     Result:= TIterateur_Mois(Iterateur_interne);
end;

function ThaAnnee__Mois.Iterateur_Decroissant: TIterateur_Mois;
begin
     Result:= TIterateur_Mois(Iterateur_interne_Decroissant);
end;

function ThaAnnee__Mois.CalculeTotal: Double;
var
   I: TIterateur_Mois;
   bl: TblMois;
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

function ThaAnnee__Mois.Calcule_Declare_mois: Integer;
var
   I: TIterateur_Mois;
   bl: TblMois;
begin
     Result:= 0;
     I:= Iterateur;
     try
        while I.Continuer
        do
          begin
          if I.not_Suivant( bl) then continue;

          Result:= Result + bl.Declare;
          end;
     finally
            FreeAndNil( I);
            end;
end;

procedure ThaAnnee__Mois.Declare_from_Total;
   procedure Calcul_sur_Mois_Montant;
   var
      Total: double;
   begin
        Total:= CalculeTotal;

        if         Reel_Zero( blAnnee.Declare)
           and not Reel_Zero( Total          )
        then
            blAnnee.cDeclare.asDouble:= Total
        else
            if Total <> blAnnee.Declare
            then
                fAccueil_Erreur( 'Année '+blAnnee.Libelle+', Declare incohérent: '+blAnnee.cDeclare.Chaine+' calculé: '+FloatToStr( Total));
   end;
   procedure Calcul_sur_Mois_Declare;
   var
      Total_Declare_mois: integer;
   begin
        Total_Declare_mois:= Calcule_Declare_mois;

        if         Reel_Zero( blAnnee.Declare_mois)
           and not Reel_Zero(   Total_Declare_mois)
        then
            blAnnee.cDeclare_mois.asInteger:= Total_Declare_mois
        else
            if Total_Declare_mois <> blAnnee.Declare_mois
            then
                fAccueil_Erreur( 'Année '+blAnnee.Libelle+', Declare_mois incohérent: '+blAnnee.cDeclare_mois.Chaine+' calculé: '+IntToStr( Total_Declare_mois));

   end;
begin
     Calcul_sur_Mois_Montant;
     Calcul_sur_Mois_Declare;
end;



{ TblAnnee }

constructor TblAnnee.Create( _sl: TBatpro_StringList; _jsdc: TjsDataContexte; _pool: Tpool_Ancetre_Ancetre);
var
   CP: IblG_BECP;
begin
     CP:= Init_ClassParams;
     if Assigned( CP)
     then
         begin
         CP.Libelle:= 'Annee';
         CP.Font.Name:= sys_Times_New_Roman;
         CP.Font.Size:= 12;
         end;

     inherited;

     Champs.ChampDefinitions.NomTable:= 'Annee';

     //champs persistants
     cAnnee       := Integer_from_Integer( Annee       , 'Annee'       );
     cDeclare     :=  Double_from_       ( Declare     , 'Declare'     );
     cDeclare_mois:= Integer_from_Integer( Declare_mois, 'Declare_mois');

//Pascal_ubl_constructor_pas_detail

     //Libelle
     cLibelle:= Ajoute_String ( FLibelle, 'Libelle', False);
     cAnnee.OnChange.Abonne( Self, Libelle_from_);
     Libelle_from_;
end;

destructor TblAnnee.Destroy;
begin

     inherited;
end;

class function TblAnnee.sCle_from_( _Annee: Integer): String;
begin 
     Result:=  IntToStr( _Annee);
end;  

function TblAnnee.sCle: String;
begin
     Result:= sCle_from_( Annee);
end;

procedure TblAnnee.Unlink( be: TBatpro_Element);
begin
     inherited Unlink( be);
     ;

end;

procedure TblAnnee.Create_Aggregation( Name: String; P: ThAggregation_Create_Params);
begin
          if 'Mois' = Name then P.Faible( ThaAnnee__Mois, TblMois, poolMois)
     else                  inherited Create_Aggregation( Name, P);
end;


function  TblAnnee.GethaMois: ThaAnnee__Mois;
begin
     if FhaMois = nil
     then
         FhaMois:= Aggregations['Mois'] as ThaAnnee__Mois;

     Result:= FhaMois;
end;


//Pascal_ubl_implementation_pas_detail

procedure TblAnnee.Libelle_from_;
begin
     cLibelle.Chaine:= Format( '%.4d', [Annee]);
end;

function TblAnnee.GetLibelle: String;
begin
     Libelle_from_;
     Result:= FLibelle;
end;

initialization
finalization
end.


