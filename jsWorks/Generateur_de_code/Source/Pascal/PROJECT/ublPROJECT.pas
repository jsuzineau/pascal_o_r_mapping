unit ublProject;
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            partly as freelance: http://www.mars42.com                          |
        and partly as employee : http://www.batpro.com                          |
    Contact: gilles.doutre@batpro.com                                           |
                                                                                |
    Copyright 2014 Jean SUZINEAU - MARS42                                       |
    Copyright 2014 Cabinet Gilles DOUTRE - BATPRO                               |
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
    u_sys_,
    uuStrings,
    uBatpro_StringList,

    uBatpro_Element,
    uBatpro_Ligne,

    udmDatabase,
    upool_Ancetre_Ancetre,

    SysUtils, Classes, SqlDB, DB;

type


 TblProject
 =
  class( TBatpro_Ligne)
  //Gestion du cycle de vie
  public
    constructor Create( _sl: TBatpro_StringList; _q: TDataset; _pool: Tpool_Ancetre_Ancetre); override;
    destructor Destroy; override;
  //champs persistants
  public
    Name: String;
  //Gestion de la clé
  public
  
    function sCle: String; override;

  end;

 TIterateur_Project
 =
  class( TIterateur)
  //Iterateur
  public
    procedure Suivant( var _Resultat: TblProject);
    function  not_Suivant( var _Resultat: TblProject): Boolean;
  end;

 TslProject
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
    function Iterateur: TIterateur_Project;
    function Iterateur_Decroissant: TIterateur_Project;
  end;

function blProject_from_sl( sl: TBatpro_StringList; Index: Integer): TblProject;
function blProject_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TblProject;

implementation

function blProject_from_sl( sl: TBatpro_StringList; Index: Integer): TblProject;
begin
     _Classe_from_sl( Result, TblProject, sl, Index);
end;

function blProject_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TblProject;
begin
     _Classe_from_sl_sCle( Result, TblProject, sl, sCle);
end;

{ TIterateur_Project }

function TIterateur_Project.not_Suivant( var _Resultat: TblProject): Boolean;
begin
     Result:= not_Suivant_interne( _Resultat);
end;

procedure TIterateur_Project.Suivant( var _Resultat: TblProject);
begin
     Suivant_interne( _Resultat);
end;

{ TslProject }

constructor TslProject.Create( _Nom: String= '');
begin
     inherited CreateE( _Nom, TblProject);
end;

destructor TslProject.Destroy;
begin
     inherited;
end;

class function TslProject.Classe_Iterateur: TIterateur_Class;
begin
     Result:= TIterateur_Project;
end;

function TslProject.Iterateur: TIterateur_Project;
begin
     Result:= TIterateur_Project( Iterateur_interne);
end;

function TslProject.Iterateur_Decroissant: TIterateur_Project;
begin
     Result:= TIterateur_Project( Iterateur_interne_Decroissant);
end;



{ TblProject }

constructor TblProject.Create( _sl: TBatpro_StringList; _q: TDataset; _pool: Tpool_Ancetre_Ancetre);
var
   CP: IblG_BECP;
begin
     CP:= Init_ClassParams;
     if Assigned( CP)
     then
         begin
         CP.Libelle:= 'Project';
         CP.Font.Name:= sys_Times_New_Roman;
         CP.Font.Size:= 12;
         end;

     inherited;

     Champs.ChampDefinitions.NomTable:= 'Project';

     //champs persistants
     Champs.  String_from_String ( Name           , 'Name'           );

end;

destructor TblProject.Destroy;
begin

     inherited;
end;



function TblProject.sCle: String;
begin
     Result:= sCle_ID;
end;





end.


