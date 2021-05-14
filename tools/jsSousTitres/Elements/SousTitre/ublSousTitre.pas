unit ublSousTitre;
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            http://www.mars42.com                                               |
                                                                                |
    Copyright 2021 Jean SUZINEAU - MARS42                                       |
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
    ufAccueil_Erreur,

    uBatpro_Element,
    uBatpro_Ligne,

  SysUtils, Classes;

type

 { TblSousTitre }

 TblSousTitre
 =
  class( TBatpro_Ligne)
  //Gestion du cycle de vie
  public
    constructor Create( _sl: TBatpro_StringList; _jsdc: TjsDataContexte; _pool: Tpool_Ancetre_Ancetre); override;
    destructor Destroy; override;
  //Gestion de la clé
  public
    function sCle: String; override;
  //SousTitre
  public
    SousTitre: String;
  end;

 TIterateur_SousTitre
 =
  class( TIterateur)
  //Iterateur
  public
    procedure Suivant( var _Resultat: TblSousTitre);
    function  not_Suivant( var _Resultat: TblSousTitre): Boolean;
  end;

 TslSousTitre
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
    function Iterateur: TIterateur_SousTitre;
    function Iterateur_Decroissant: TIterateur_SousTitre;
  end;


function blSousTitre_from_sl( sl: TBatpro_StringList; Index: Integer): TblSousTitre;
function blSousTitre_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TblSousTitre;

var
   ublSession_Ecrire_arrondi: Boolean= False;

implementation

function blSousTitre_from_sl( sl: TBatpro_StringList; Index: Integer): TblSousTitre;
begin
     _Classe_from_sl( Result, TblSousTitre, sl, Index);
end;

function blSousTitre_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TblSousTitre;
begin
     _Classe_from_sl_sCle( Result, TblSousTitre, sl, sCle);
end;

{ TIterateur_SousTitre }

function TIterateur_SousTitre.not_Suivant( var _Resultat: TblSousTitre): Boolean;
begin
     Result:= not_Suivant_interne( _Resultat);
end;

procedure TIterateur_SousTitre.Suivant( var _Resultat: TblSousTitre);
begin
     Suivant_interne( _Resultat);
end;

{ TslSousTitre }

constructor TslSousTitre.Create( _Nom: String= '');
begin
     inherited CreateE( _Nom, TblSousTitre);
end;

destructor TslSousTitre.Destroy;
begin
     inherited;
end;

class function TslSousTitre.Classe_Iterateur: TIterateur_Class;
begin
     Result:= TIterateur_SousTitre;
end;

function TslSousTitre.Iterateur: TIterateur_SousTitre;
begin
     Result:= TIterateur_SousTitre( Iterateur_interne);
end;

function TslSousTitre.Iterateur_Decroissant: TIterateur_SousTitre;
begin
     Result:= TIterateur_SousTitre( Iterateur_interne_Decroissant);
end;

{ TblSousTitre }

constructor TblSousTitre.Create( _sl: TBatpro_StringList; _jsdc: TjsDataContexte; _pool: Tpool_Ancetre_Ancetre);
var
   CP: IblG_BECP;
begin
     CP:= Init_ClassParams;
     if Assigned( CP)
     then
         begin
         CP.Libelle:= 'SousTitre';
         CP.Font.Name:= sys_Times_New_Roman;
         CP.Font.Size:= 12;
         end;

     inherited;

     Champs.ChampDefinitions.NomTable:= '';

     cLibelle:= Ajoute_String ( SousTitre,'SousTitre', False);
end;

destructor TblSousTitre.Destroy;
begin

     inherited;
end;

function TblSousTitre.sCle: String;
begin
     Result:= sCle_ID;
end;

end.


