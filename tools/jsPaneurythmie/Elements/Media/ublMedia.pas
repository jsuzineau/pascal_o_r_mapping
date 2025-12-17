unit ublMedia;
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
    uPool,

    SysUtils, Classes, SqlDB, DB, FileUtil;

type
 TblMedia= class;
//pattern_aggregation_classe_declaration

 { TblMedia }

 TblMedia
 =
  class( TBatpro_Ligne)
  //Gestion du cycle de vie
  public
    constructor Create( _sl: TBatpro_StringList; _jsdc: TjsDataContexte; _pool: Tpool_Ancetre_Ancetre); override;
    destructor Destroy; override;
  //champs persistants
  public
    Titre: String;
    NomFichier: String;cNomFichier: TChamp;
    Boucler    : Boolean;
    Verrouiller: Boolean;
    HeureFin   : TDateTime;cHeureFin: TChamp;
  //Gestion de la clé
  public
    function sCle: String; override;
  //Gestion des déconnexions
  public
    procedure Unlink(be: TBatpro_Element); override;
  //Liste
  private
    slListe: TStringList;
    NomCourant: String; cNomCourant: TChamp;
  public
    Is_Liste: Boolean;
    procedure Prepare_Liste;
    function NomFichier_from_Liste: String;
  end;

 TIterateur_Media
 =
  class( TIterateur)
  //Iterateur
  public
    procedure Suivant( out _Resultat: TblMedia);
    function  not_Suivant( out _Resultat: TblMedia): Boolean;
  end;

 TslMedia
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
    function Iterateur: TIterateur_Media;
    function Iterateur_Decroissant: TIterateur_Media;
  end;

function blMedia_from_sl( sl: TBatpro_StringList; Index: Integer): TblMedia;
function blMedia_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TblMedia;

//Details_Pascal_ubl_declaration_pools_aggregations_pas

implementation

function blMedia_from_sl( sl: TBatpro_StringList; Index: Integer): TblMedia;
begin
     _Classe_from_sl( Result, TblMedia, sl, Index);
end;

function blMedia_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TblMedia;
begin
     _Classe_from_sl_sCle( Result, TblMedia, sl, sCle);
end;

{ TIterateur_Media }

function TIterateur_Media.not_Suivant( out _Resultat: TblMedia): Boolean;
begin
     Result:= not_Suivant_interne( _Resultat);
end;

procedure TIterateur_Media.Suivant( out _Resultat: TblMedia);
begin
     Suivant_interne( _Resultat);
end;

{ TslMedia }

constructor TslMedia.Create( _Nom: String= '');
begin
     inherited CreateE( _Nom, TblMedia);
end;

destructor TslMedia.Destroy;
begin
     inherited;
end;

class function TslMedia.Classe_Iterateur: TIterateur_Class;
begin
     Result:= TIterateur_Media;
end;

function TslMedia.Iterateur: TIterateur_Media;
begin
     Result:= TIterateur_Media( Iterateur_interne);
end;

function TslMedia.Iterateur_Decroissant: TIterateur_Media;
begin
     Result:= TIterateur_Media( Iterateur_interne_Decroissant);
end;

//pattern_aggregation_classe_implementation

{ TblMedia }

constructor TblMedia.Create( _sl: TBatpro_StringList; _jsdc: TjsDataContexte; _pool: Tpool_Ancetre_Ancetre);
var
   CP: IblG_BECP;
begin
     CP:= Init_ClassParams;
     if Assigned( CP)
     then
         begin
         CP.Libelle:= 'Media';
         CP.Font.Name:= sys_Times_New_Roman;
         CP.Font.Size:= 12;
         end;

     inherited;

     Champs.ChampDefinitions.NomTable:= 'Media';

     //champs persistants
                   Champs. String_from_String( Titre      , 'Titre'      );
     cNomFichier:= Champs. String_from_String( NomFichier , 'NomFichier' );
                   Champs.Boolean_from_      ( Boucler    , 'Boucler'    );
                   Champs.Boolean_from_      ( Verrouiller, 'Verrouiller');
     cHeureFin:= DateTime_from_( HeureFin, 'HeureFin'      );
     cHeurefin.Definition.Format_DateTime:= 'yyyy/mm/dd" "hh:nn';

     Is_Liste:= DirectoryExists( NomFichier);
     slListe:= TStringList.Create;
     cNomCourant:= Ajoute_String(NomCourant,'NomCourant', False);
     NomCourant:= '';
end;

destructor TblMedia.Destroy;
begin
     FreeAndNil( slListe);
     inherited;
end;

//pattern_sCle_from__Implementation

function TblMedia.sCle: String;
begin
     Result:= sCle_ID;
end;

procedure TblMedia.Unlink( be: TBatpro_Element);
begin
     inherited Unlink( be);
     ;

end;

procedure TblMedia.Prepare_Liste;
begin
     NomCourant:= '';
     Randomize;
     slListe.Clear;
     FindAllFiles( slListe, NomFichier, '*.*');
end;

function TblMedia.NomFichier_from_Liste: String;
   procedure Cas_Liste;
   var
      i: Integer;
   begin
        i:= Random( slListe.Count);
        Result:= slListe[i];
        slListe.Delete( i);
        if 0 = slListe.Count
        then
            Prepare_Liste;

        cNomCourant.asString:= ExtractFileName( Result);
   end;
   procedure Cas_direct;
   begin
        Result:= NomFichier;
   end;
begin
     if Is_Liste
     then
         Cas_Liste
     else
         Cas_direct;
end;

//pattern_aggregation_accesseurs_implementation

//Pascal_ubl_implementation_pas_detail

initialization
finalization
end.


