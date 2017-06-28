unit ublTestDockableScrollbox;
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

 { TblTestDockableScrollbox }

 TblTestDockableScrollbox
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

 TIterateur_TestDockableScrollbox
 =
  class( TIterateur)
  //Iterateur
  public
    procedure Suivant( var _Resultat: TblTestDockableScrollbox);
    function  not_Suivant( var _Resultat: TblTestDockableScrollbox): Boolean;
  end;

 TslTestDockableScrollbox
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
    function Iterateur: TIterateur_TestDockableScrollbox;
    function Iterateur_Decroissant: TIterateur_TestDockableScrollbox;
  end;

implementation

{ TIterateur_TestDockableScrollbox }

function TIterateur_TestDockableScrollbox.not_Suivant( var _Resultat: TblTestDockableScrollbox): Boolean;
begin
     Result:= not_Suivant_interne( _Resultat);
end;

procedure TIterateur_TestDockableScrollbox.Suivant( var _Resultat: TblTestDockableScrollbox);
begin
     Suivant_interne( _Resultat);
end;

{ TslTestDockableScrollbox }

constructor TslTestDockableScrollbox.Create( _Nom: String= '');
begin
     inherited CreateE( _Nom, TblTestDockableScrollbox);
end;

destructor TslTestDockableScrollbox.Destroy;
begin
     inherited;
end;

class function TslTestDockableScrollbox.Classe_Iterateur: TIterateur_Class;
begin
     Result:= TIterateur_TestDockableScrollbox;
end;

function TslTestDockableScrollbox.Iterateur: TIterateur_TestDockableScrollbox;
begin
     Result:= TIterateur_TestDockableScrollbox( Iterateur_interne);
end;

function TslTestDockableScrollbox.Iterateur_Decroissant: TIterateur_TestDockableScrollbox;
begin
     Result:= TIterateur_TestDockableScrollbox( Iterateur_interne_Decroissant);
end;


{ TblTestDockableScrollbox }

constructor TblTestDockableScrollbox.Create( _sl: TBatpro_StringList;
                                             _jsdc: TjsDataContexte;
                                             _pool: Tpool_Ancetre_Ancetre);
var
   CP: IblG_BECP;
begin
     CP:= Init_ClassParams;
     if Assigned( CP)
     then
         begin
         CP.Libelle:= 'TestDockableScrollbox';
         CP.Font.Name:= sys_Times_New_Roman;
         CP.Font.Size:= 12;
         end;

     inherited;

     Champs.ChampDefinitions.NomTable:= 'TestDockableScrollbox';

     Ajoute_String( Nom, 'Nom', False);
end;

destructor TblTestDockableScrollbox.Destroy;
begin
     inherited Destroy;
end;

end.

