unit ublTest_HTML;
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            http://www.mars42.com                                               |
                                                                                |
    Copyright 2017 Jean SUZINEAU - MARS42                                       |
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

{$mode delphi}

interface

uses
    uClean,
    u_sys_,
    uuStrings,
    uBatpro_StringList,
    uBatpro_Element,
    uBatpro_Ligne,
 Classes, SysUtils,db;

const nom_html  = 'tcOpenDocument_AddHTML.html';
const nom_html_2= 'tcOpenDocument_AddHTML_2.html';
const nom_html_3= 'tcOpenDocument_AddHTML_3.html';
const nom_html_4= 'tcOpenDocument_AddHTML_4.html';
type

 { TblTest_HTML }

 TblTest_HTML
 =
  class( TBatpro_Ligne)
  //Cycle de vie
  public
    constructor Create( _sl: TBatpro_StringList; _q: TDataset; _pool: Tpool_Ancetre_Ancetre); virtual;
    destructor Destroy; override;
  //Attributs
  public
    Nom: String;
    html: String;
    procedure Load_html( _Nom_Fichier: String);
  end;

 TIterateur_Test_HTML
 =
  class( TIterateur)
  //Iterateur
  public
    procedure Suivant( var _Resultat: TblTest_HTML);
    function  not_Suivant( var _Resultat: TblTest_HTML): Boolean;
  end;

 TslTest_HTML
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
    function Iterateur: TIterateur_Test_HTML;
    function Iterateur_Decroissant: TIterateur_Test_HTML;
  end;

implementation

{ TIterateur_Test_HTML }

function TIterateur_Test_HTML.not_Suivant( var _Resultat: TblTest_HTML): Boolean;
begin
     Result:= not_Suivant_interne( _Resultat);
end;

procedure TIterateur_Test_HTML.Suivant( var _Resultat: TblTest_HTML);
begin
     Suivant_interne( _Resultat);
end;

{ TslTest_HTML }

constructor TslTest_HTML.Create( _Nom: String= '');
begin
     inherited CreateE( _Nom, TblTest_HTML);
end;

destructor TslTest_HTML.Destroy;
begin
     inherited;
end;

class function TslTest_HTML.Classe_Iterateur: TIterateur_Class;
begin
     Result:= TIterateur_Test_HTML;
end;

function TslTest_HTML.Iterateur: TIterateur_Test_HTML;
begin
     Result:= TIterateur_Test_HTML( Iterateur_interne);
end;

function TslTest_HTML.Iterateur_Decroissant: TIterateur_Test_HTML;
begin
     Result:= TIterateur_Test_HTML( Iterateur_interne_Decroissant);
end;


{ TblTest_HTML }

constructor TblTest_HTML.Create( _sl: TBatpro_StringList; _q: TDataset; _pool: Tpool_Ancetre_Ancetre);
var
   CP: IblG_BECP;
begin
     CP:= Init_ClassParams;
     if Assigned( CP)
     then
         begin
         CP.Libelle:= 'Test';
         CP.Font.Name:= sys_Times_New_Roman;
         CP.Font.Size:= 12;
         end;

     inherited;

     Champs.ChampDefinitions.NomTable:= 'Test_HTML';

     Ajoute_String( Nom, 'Nom', False);

     Ajoute_String( html, 'html', False);
     html:= String_from_File( nom_html);
end;

destructor TblTest_HTML.Destroy;
begin
     inherited Destroy;
end;

procedure TblTest_HTML.Load_html( _Nom_Fichier: String);
begin
     html:= String_from_File( _Nom_Fichier);
end;

end.

