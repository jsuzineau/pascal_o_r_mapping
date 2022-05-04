unit ublPassage;
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            http://www.mars42.com                                               |
                                                                                |
    Copyright 2014 Jean SUZINEAU - MARS42                                       |
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
    along with this program.  If not, see <http://www.gnu.org/licenses/>. 1     |
                                                                                |
|                                                                               }

interface

uses
    uClean,
    u_sys_,
    uuStrings,
    uBatpro_StringList,
    uChamp,
    uReels,
    ufAccueil_Erreur,
    uPublieur,

    uBatpro_Element,
    uBatpro_Ligne,

    udmDatabase,

    SysUtils, Classes, sqldb, DateUtils, Math;

type
  TblPassage = class;
  TIterateur_Passage= class;

  { ThaPassage__Self }

  ThaPassage__Self
  =
   class( ThAggregation)
   //Gestion du cycle de vie
   public
     constructor Create( _Parent: TBatpro_Element;
                         _Classe_Elements: TBatpro_Element_Class;
                         _pool_Ancetre_Ancetre: Tpool_Ancetre_Ancetre); override;
     destructor  Destroy; override;
   //Création d'itérateur
   protected
     class function Classe_Iterateur: TIterateur_Class; override;
   public
     function Iterateur: TIterateur_Passage;
     function Iterateur_Decroissant: TIterateur_Passage;
   //Chargement de tous les détails
   public
     procedure Charge; override;
   end;

  { TblPassage }

 TblPassage
 =
  class( TBatpro_Ligne)
  //Gestion du cycle de vie
  public
    constructor Create( _sl: TBatpro_StringList; _jsdc: TjsDataContexte; _pool: Tpool_Ancetre_Ancetre); override;
    destructor Destroy; override;
  //champs persistants
  public
    Page: Integer;
    Debut: TDateTime; cDebut: TChamp;
    Fin  : TDateTime; cFin  : TChamp;
    Pourcentage: Double;
    Texte: String;
  //Gestion de la clé
  public
    function sCle: String; override;
  //Champs calculés
  public
    function Debut_seconds: Double;
    function Fin_seconds: Double;
  end;

 TIterateur_Passage
 =
  class( TIterateur)
  //Iterateur
  public
    procedure Suivant( out _Resultat: TblPassage);
    function  not_Suivant( out _Resultat: TblPassage): Boolean;
  end;

 { TslPassage }

 TslPassage
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
    function Iterateur: TIterateur_Passage;
    function Iterateur_Decroissant: TIterateur_Passage;
  end;

function blPassage_from_sl( sl: TBatpro_StringList; Index: Integer): TblPassage;
function blPassage_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TblPassage;

implementation

function blPassage_from_sl( sl: TBatpro_StringList; Index: Integer): TblPassage;
begin
     _Classe_from_sl( Result, TblPassage, sl, Index);
end;

function blPassage_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TblPassage;
begin
     _Classe_from_sl_sCle( Result, TblPassage, sl, sCle);
end;

{ ThaPassage__Self }

constructor ThaPassage__Self.Create( _Parent: TBatpro_Element;
                               _Classe_Elements: TBatpro_Element_Class;
                               _pool_Ancetre_Ancetre: Tpool_Ancetre_Ancetre);
begin
     inherited;
     if Classe_Elements <> _Classe_Elements
     then
         fAccueil_Erreur(  'Erreur ? signaler au d?veloppeur: '#13#10
                          +' '+ClassName+'.Create: Classe_Elements <> _Classe_Elements:'#13#10
                          +' Classe_Elements='+ Classe_Elements.ClassName+#13#10
                          +'_Classe_Elements='+_Classe_Elements.ClassName
                          );
end;

destructor ThaPassage__Self.Destroy;
begin
     inherited;
end;

class function ThaPassage__Self.Classe_Iterateur: TIterateur_Class;
begin
     Result:= TIterateur_Passage;
end;

function ThaPassage__Self.Iterateur: TIterateur_Passage;
begin
     Result:= TIterateur_Passage( Iterateur_interne);
end;

function ThaPassage__Self.Iterateur_Decroissant: TIterateur_Passage;
begin
     Result:= TIterateur_Passage( Iterateur_interne_Decroissant);
end;

procedure ThaPassage__Self.Charge;
var
   bl: TblPassage;
begin
     sl.Clear;
     inherited Charge;
     if Affecte_( bl, TblPassage, Parent) then exit;

     slCharge.AddObject( bl.sCle, bl);
     Ajoute_slCharge;
end;

{ TIterateur_Passage }

function TIterateur_Passage.not_Suivant( out _Resultat: TblPassage): Boolean;
begin
     Result:= not_Suivant_interne( _Resultat);
end;

procedure TIterateur_Passage.Suivant( out _Resultat: TblPassage);
begin
     Suivant_interne( _Resultat);
end;

{ TslPassage }

constructor TslPassage.Create( _Nom: String= '');
begin
     inherited CreateE( _Nom, TblPassage);
end;

destructor TslPassage.Destroy;
begin
     inherited;
end;

class function TslPassage.Classe_Iterateur: TIterateur_Class;
begin
     Result:= TIterateur_Passage;
end;

function TslPassage.Iterateur: TIterateur_Passage;
begin
     Result:= TIterateur_Passage( Iterateur_interne);
end;

function TslPassage.Iterateur_Decroissant: TIterateur_Passage;
begin
     Result:= TIterateur_Passage( Iterateur_interne_Decroissant);
end;

{ TblPassage }

constructor TblPassage.Create( _sl: TBatpro_StringList; _jsdc: TjsDataContexte; _pool: Tpool_Ancetre_Ancetre);
var
   CP: IblG_BECP;
begin
     CP:= Init_ClassParams;
     if Assigned( CP)
     then
         begin
         CP.Libelle:= 'Passage';
         CP.Font.Name:= sys_Times_New_Roman;
         CP.Font.Size:= 12;
         end;

     inherited;

     Champs.ChampDefinitions.NomTable:= 'Passage';

     //champs persistants

     Integer_from_ ( Page, 'Page');

     cDebut:= DateTime_from_( Debut, 'Debut'      );
     cDebut.Definition.Format_DateTime:= 'hh":"nn":"ss"."zzz';

     cFin:= DateTime_from_( Fin           , 'Fin'            );
     cFin.Definition.Format_DateTime:= 'hh":"nn":"ss"."zzz';

     Double_from_    ( Pourcentage, 'Pourcentage');
     String_from_Memo( Texte               , 'Texte'               );

     cLibelle:= cDebut;
end;

destructor TblPassage.Destroy;
begin

     inherited;
end;

function TblPassage.sCle: String;
begin
     Result:= sCle_ID;
end;


function XLSX_DateTime_to_Seconds( _d: TDateTime): double;
begin
     Result:= Frac( _d)*24*3600;//à peaufiner si > 24h
end;

function TblPassage.Debut_seconds: Double;
begin
     Result:= XLSX_DateTime_to_Seconds( Debut);
end;

function TblPassage.Fin_seconds: Double;
begin
     Result:= XLSX_DateTime_to_Seconds( Fin);
end;

initialization
finalization
end.


