unit ublTestWinUtils;
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
    ujsDataContexte,
    uBatpro_Element,
    uBatpro_Ligne,
 Classes, SysUtils,db;

type

 { TblTestWinUtils }

 TblTestWinUtils
 =
  class( TBatpro_Ligne)
  //Cycle de vie
  public
    constructor Create( _sl: TBatpro_StringList; _jsdc: TjsDataContexte; _pool: Tpool_Ancetre_Ancetre); virtual;
    destructor Destroy; override;
  //Attributs
  public
    Nom: String;
    graphic_Nom: String;
  end;

 TIterateur_TestWinUtils
 =
  class( TIterateur)
  //Iterateur
  public
    procedure Suivant( var _Resultat: TblTestWinUtils);
    function  not_Suivant( var _Resultat: TblTestWinUtils): Boolean;
  end;

 TslTestWinUtils
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
    function Iterateur: TIterateur_TestWinUtils;
    function Iterateur_Decroissant: TIterateur_TestWinUtils;
  end;

implementation

{ TIterateur_TestWinUtils }

function TIterateur_TestWinUtils.not_Suivant( var _Resultat: TblTestWinUtils): Boolean;
begin
     Result:= not_Suivant_interne( _Resultat);
end;

procedure TIterateur_TestWinUtils.Suivant( var _Resultat: TblTestWinUtils);
begin
     Suivant_interne( _Resultat);
end;

{ TslTestWinUtils }

constructor TslTestWinUtils.Create( _Nom: String= '');
begin
     inherited CreateE( _Nom, TblTestWinUtils);
end;

destructor TslTestWinUtils.Destroy;
begin
     inherited;
end;

class function TslTestWinUtils.Classe_Iterateur: TIterateur_Class;
begin
     Result:= TIterateur_TestWinUtils;
end;

function TslTestWinUtils.Iterateur: TIterateur_TestWinUtils;
begin
     Result:= TIterateur_TestWinUtils( Iterateur_interne);
end;

function TslTestWinUtils.Iterateur_Decroissant: TIterateur_TestWinUtils;
begin
     Result:= TIterateur_TestWinUtils( Iterateur_interne_Decroissant);
end;


{ TblTestWinUtils }

constructor TblTestWinUtils.Create( _sl: TBatpro_StringList;
                                    _jsdc: TjsDataContexte;
                                    _pool: Tpool_Ancetre_Ancetre);
var
   CP: IblG_BECP;
begin
     CP:= Init_ClassParams;
     if Assigned( CP)
     then
         begin
         CP.Libelle:= 'TestWinUtils';
         CP.Font.Name:= sys_Times_New_Roman;
         CP.Font.Size:= 12;
         end;

     inherited;

     Champs.ChampDefinitions.NomTable:= 'TestWinUtils';

     Ajoute_String( Nom, 'Nom', False);
end;

destructor TblTestWinUtils.Destroy;
begin
     inherited Destroy;
end;

end.

