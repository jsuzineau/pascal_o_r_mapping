unit ublTest;
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
    uBatpro_StringList,
    uBatpro_Element,
    uBatpro_Ligne,
 Classes, SysUtils,db;

type

 { TblTest }

 TblTest
 =
  class( TBatpro_Ligne)
  //Cycle de vie
  public
    constructor Create( _sl: TBatpro_StringList; _q: TDataset; _pool: Tpool_Ancetre_Ancetre); virtual;
    destructor Destroy; override;
  //Attributs
  public
    graphic_png: String;
    graphic_jpg: String;
  end;

 TIterateur_Test
 =
  class( TIterateur)
  //Iterateur
  public
    procedure Suivant( var _Resultat: TblTest);
    function  not_Suivant( var _Resultat: TblTest): Boolean;
  end;

 TslTest
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
    function Iterateur: TIterateur_Test;
    function Iterateur_Decroissant: TIterateur_Test;
  end;

implementation

{ TIterateur_Test }

function TIterateur_Test.not_Suivant( var _Resultat: TblTest): Boolean;
begin
     Result:= not_Suivant_interne( _Resultat);
end;

procedure TIterateur_Test.Suivant( var _Resultat: TblTest);
begin
     Suivant_interne( _Resultat);
end;

{ TslTest }

constructor TslTest.Create( _Nom: String= '');
begin
     inherited CreateE( _Nom, TblTest);
end;

destructor TslTest.Destroy;
begin
     inherited;
end;

class function TslTest.Classe_Iterateur: TIterateur_Class;
begin
     Result:= TIterateur_Test;
end;

function TslTest.Iterateur: TIterateur_Test;
begin
     Result:= TIterateur_Test( Iterateur_interne);
end;

function TslTest.Iterateur_Decroissant: TIterateur_Test;
begin
     Result:= TIterateur_Test( Iterateur_interne_Decroissant);
end;


{ TblTest }

constructor TblTest.Create( _sl: TBatpro_StringList; _q: TDataset; _pool: Tpool_Ancetre_Ancetre);
var
   CP: IblG_BECP;
begin
     CP:= Init_ClassParams;
     if Assigned( CP)
     then
         begin
         CP.Libelle:= 'Work';
         CP.Font.Name:= sys_Times_New_Roman;
         CP.Font.Size:= 12;
         end;

     inherited;

     Champs.ChampDefinitions.NomTable:= 'Test';

     //champs persistants

     Ajoute_String( graphic_png, 'graphic_png', False); graphic_png:= ExtractFilePath(ParamStr(0))+'Test.png';
     Ajoute_String( graphic_jpg, 'graphic_jpg', False); graphic_jpg:= ExtractFilePath(ParamStr(0))+'Test.jpg';
end;

destructor TblTest.Destroy;
begin
     inherited Destroy;
end;

end.

