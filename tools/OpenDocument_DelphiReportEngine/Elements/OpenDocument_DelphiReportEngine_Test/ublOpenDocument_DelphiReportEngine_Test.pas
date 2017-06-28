unit ublOpenDocument_DelphiReportEngine_Test;
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

 { TblOpenDocument_DelphiReportEngine_Test }

 TblOpenDocument_DelphiReportEngine_Test
 =
  class( TBatpro_Ligne)
  //Cycle de vie
  public
    constructor Create( _sl: TBatpro_StringList; _jsdc: TjsDataContexte; _pool: Tpool_Ancetre_Ancetre); virtual;
    destructor Destroy; override;
  //Attributs
  public
    Code   : String;
    Libelle: String;
    Quantite     : double;
    Prix_Unitaire: double;
    Montant      : double;
  end;

 TIterateur_OpenDocument_DelphiReportEngine_Test
 =
  class( TIterateur)
  //Iterateur
  public
    procedure Suivant( var _Resultat: TblOpenDocument_DelphiReportEngine_Test);
    function  not_Suivant( var _Resultat: TblOpenDocument_DelphiReportEngine_Test): Boolean;
  end;

 TslOpenDocument_DelphiReportEngine_Test
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
    function Iterateur: TIterateur_OpenDocument_DelphiReportEngine_Test;
    function Iterateur_Decroissant: TIterateur_OpenDocument_DelphiReportEngine_Test;
  end;

implementation

{ TIterateur_OpenDocument_DelphiReportEngine_Test }

function TIterateur_OpenDocument_DelphiReportEngine_Test.not_Suivant( var _Resultat: TblOpenDocument_DelphiReportEngine_Test): Boolean;
begin
     Result:= not_Suivant_interne( _Resultat);
end;

procedure TIterateur_OpenDocument_DelphiReportEngine_Test.Suivant( var _Resultat: TblOpenDocument_DelphiReportEngine_Test);
begin
     Suivant_interne( _Resultat);
end;

{ TslOpenDocument_DelphiReportEngine_Test }

constructor TslOpenDocument_DelphiReportEngine_Test.Create( _Nom: String= '');
begin
     inherited CreateE( _Nom, TblOpenDocument_DelphiReportEngine_Test);
end;

destructor TslOpenDocument_DelphiReportEngine_Test.Destroy;
begin
     inherited;
end;

class function TslOpenDocument_DelphiReportEngine_Test.Classe_Iterateur: TIterateur_Class;
begin
     Result:= TIterateur_OpenDocument_DelphiReportEngine_Test;
end;

function TslOpenDocument_DelphiReportEngine_Test.Iterateur: TIterateur_OpenDocument_DelphiReportEngine_Test;
begin
     Result:= TIterateur_OpenDocument_DelphiReportEngine_Test( Iterateur_interne);
end;

function TslOpenDocument_DelphiReportEngine_Test.Iterateur_Decroissant: TIterateur_OpenDocument_DelphiReportEngine_Test;
begin
     Result:= TIterateur_OpenDocument_DelphiReportEngine_Test( Iterateur_interne_Decroissant);
end;


{ TblOpenDocument_DelphiReportEngine_Test }

constructor TblOpenDocument_DelphiReportEngine_Test.Create( _sl: TBatpro_StringList; _jsdc: TjsDataContexte; _pool: Tpool_Ancetre_Ancetre);
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

     Champs.ChampDefinitions.NomTable:= 'OpenDocument_DelphiReportEngine_Test';

     Ajoute_String( Code   , 'Code'   , False);
     Ajoute_String( Libelle, 'Libelle', False);
     Ajoute_Float( Quantite     , 'Quantite'     , False);
     Ajoute_Float( Prix_Unitaire, 'Prix_Unitaire', False);
     Ajoute_Float( Montant      , 'Montant'      , False);
end;

destructor TblOpenDocument_DelphiReportEngine_Test.Destroy;
begin
     inherited Destroy;
end;

end.

