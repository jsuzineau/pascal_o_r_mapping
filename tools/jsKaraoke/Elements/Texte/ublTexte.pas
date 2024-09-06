unit ublTexte;
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            http://www.mars42.com                                               |
                                                                                |
    Copyright 2024 Jean SUZINEAU - MARS42                                       |
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

    ublTiming,
    upoolTiming,



    SysUtils, Classes, SqlDB, DB;

type
 TblTexte= class;
  { ThaTexte__Timing }
  ThaTexte__Timing
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
     blTexte: TblTexte;  
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
     function Iterateur: TIterateur_Timing;
     function Iterateur_Decroissant: TIterateur_Timing;
   end;




 { TblTexte }

 TblTexte
 =
  class( TBatpro_Ligne)
  //Gestion du cycle de vie
  public
    constructor Create( _sl: TBatpro_StringList; _jsdc: TjsDataContexte; _pool: Tpool_Ancetre_Ancetre); override;
    destructor Destroy; override;
  //champs persistants
  public
    Cyrillique: String;
    Translitteration: String;
    Francais: String;
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
  //Aggrégation vers les Timing correspondants
  private
    FhaTiming: ThaTexte__Timing;
    function GethaTiming: ThaTexte__Timing;
  public
    property haTiming: ThaTexte__Timing read GethaTiming;

  end;

 TIterateur_Texte
 =
  class( TIterateur)
  //Iterateur
  public
    procedure Suivant( out _Resultat: TblTexte);
    function  not_Suivant( out _Resultat: TblTexte): Boolean;
  end;

 TslTexte
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
    function Iterateur: TIterateur_Texte;
    function Iterateur_Decroissant: TIterateur_Texte;
  end;

function blTexte_from_sl( sl: TBatpro_StringList; Index: Integer): TblTexte;
function blTexte_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TblTexte;

//Details_Pascal_ubl_declaration_pools_aggregations_pas

implementation

function blTexte_from_sl( sl: TBatpro_StringList; Index: Integer): TblTexte;
begin
     _Classe_from_sl( Result, TblTexte, sl, Index);
end;

function blTexte_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TblTexte;
begin
     _Classe_from_sl_sCle( Result, TblTexte, sl, sCle);
end;

{ TIterateur_Texte }

function TIterateur_Texte.not_Suivant( out _Resultat: TblTexte): Boolean;
begin
     Result:= not_Suivant_interne( _Resultat);
end;

procedure TIterateur_Texte.Suivant( out _Resultat: TblTexte);
begin
     Suivant_interne( _Resultat);
end;

{ TslTexte }

constructor TslTexte.Create( _Nom: String= '');
begin
     inherited CreateE( _Nom, TblTexte);
end;

destructor TslTexte.Destroy;
begin
     inherited;
end;

class function TslTexte.Classe_Iterateur: TIterateur_Class;
begin
     Result:= TIterateur_Texte;
end;

function TslTexte.Iterateur: TIterateur_Texte;
begin
     Result:= TIterateur_Texte( Iterateur_interne);
end;

function TslTexte.Iterateur_Decroissant: TIterateur_Texte;
begin
     Result:= TIterateur_Texte( Iterateur_interne_Decroissant);
end;

{ ThaTexte__Timing }

constructor ThaTexte__Timing.Create( _Parent: TBatpro_Element;
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
     if Affecte_( blTexte, TblTexte, Parent) then exit;
end;

destructor ThaTexte__Timing.Destroy;
begin
     inherited;
end;

procedure ThaTexte__Timing.Charge;
begin
     poolTiming.Charge_Texte( blTexte.id);
end;

procedure ThaTexte__Timing.Delete_from_database;
var
   I: TIterateur_Timing;
   bl: TblTiming;
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

class function ThaTexte__Timing.Classe_Iterateur: TIterateur_Class;
begin
     Result:= TIterateur_Timing;
end;

function ThaTexte__Timing.Iterateur: TIterateur_Timing;
begin
     Result:= TIterateur_Timing(Iterateur_interne);
end;

function ThaTexte__Timing.Iterateur_Decroissant: TIterateur_Timing;
begin
     Result:= TIterateur_Timing(Iterateur_interne_Decroissant);
end;



{ TblTexte }

constructor TblTexte.Create( _sl: TBatpro_StringList; _jsdc: TjsDataContexte; _pool: Tpool_Ancetre_Ancetre);
var
   CP: IblG_BECP;
begin
     CP:= Init_ClassParams;
     if Assigned( CP)
     then
         begin
         CP.Libelle:= 'Texte';
         CP.Font.Name:= sys_Times_New_Roman;
         CP.Font.Size:= 12;
         end;

     inherited;

     Champs.ChampDefinitions.NomTable:= 'Texte';

     //champs persistants
     cLibelle:= Champs.  String_from_String ( Cyrillique     , 'Cyrillique'     );
     Champs.  String_from_String ( Translitteration, 'Translitteration');
     Champs.  String_from_String ( Francais       , 'Francais'       );

//Pascal_ubl_constructor_pas_detail
end;

destructor TblTexte.Destroy;
begin

     inherited;
end;

//pattern_sCle_from__Implementation

function TblTexte.sCle: String;
begin
     Result:= sCle_ID;
end;

procedure TblTexte.Unlink( be: TBatpro_Element);
begin
     inherited Unlink( be);
     ;

end;

procedure TblTexte.Create_Aggregation( Name: String; P: ThAggregation_Create_Params);
begin
          if 'Timing' = Name then P.Faible( ThaTexte__Timing, TblTiming, poolTiming)
     else                  inherited Create_Aggregation( Name, P);
end;


function  TblTexte.GethaTiming: ThaTexte__Timing;
begin
     if FhaTiming = nil
     then
         FhaTiming:= Aggregations['Timing'] as ThaTexte__Timing;

     Result:= FhaTiming;
end;


//Pascal_ubl_implementation_pas_detail

initialization
finalization
end.


