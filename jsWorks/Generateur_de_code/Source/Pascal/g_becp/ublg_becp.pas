unit ublg_becp;
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


 Tblg_becp
 =
  class( TBatpro_Ligne)
  //Gestion du cycle de vie
  public
    constructor Create( _sl: TBatpro_StringList; _jsdc: TjsDataContexte; _pool: Tpool_Ancetre_Ancetre); override;
    destructor Destroy; override;
  //champs persistants
  public
    nomclasse: String;
    libelle: String;
  //Gestion de la clé
  public
  
    function sCle: String; override;

  end;

 TIterateur_g_becp
 =
  class( TIterateur)
  //Iterateur
  public
    procedure Suivant( var _Resultat: Tblg_becp);
    function  not_Suivant( var _Resultat: Tblg_becp): Boolean;
  end;

 Tslg_becp
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
    function Iterateur: TIterateur_g_becp;
    function Iterateur_Decroissant: TIterateur_g_becp;
  end;

function blg_becp_from_sl( sl: TBatpro_StringList; Index: Integer): Tblg_becp;
function blg_becp_from_sl_sCle( sl: TBatpro_StringList; sCle: String): Tblg_becp;

implementation

function blg_becp_from_sl( sl: TBatpro_StringList; Index: Integer): Tblg_becp;
begin
     _Classe_from_sl( Result, Tblg_becp, sl, Index);
end;

function blg_becp_from_sl_sCle( sl: TBatpro_StringList; sCle: String): Tblg_becp;
begin
     _Classe_from_sl_sCle( Result, Tblg_becp, sl, sCle);
end;

{ TIterateur_g_becp }

function TIterateur_g_becp.not_Suivant( var _Resultat: Tblg_becp): Boolean;
begin
     Result:= not_Suivant_interne( _Resultat);
end;

procedure TIterateur_g_becp.Suivant( var _Resultat: Tblg_becp);
begin
     Suivant_interne( _Resultat);
end;

{ Tslg_becp }

constructor Tslg_becp.Create( _Nom: String= '');
begin
     inherited CreateE( _Nom, Tblg_becp);
end;

destructor Tslg_becp.Destroy;
begin
     inherited;
end;

class function Tslg_becp.Classe_Iterateur: TIterateur_Class;
begin
     Result:= TIterateur_g_becp;
end;

function Tslg_becp.Iterateur: TIterateur_g_becp;
begin
     Result:= TIterateur_g_becp( Iterateur_interne);
end;

function Tslg_becp.Iterateur_Decroissant: TIterateur_g_becp;
begin
     Result:= TIterateur_g_becp( Iterateur_interne_Decroissant);
end;



{ Tblg_becp }

constructor Tblg_becp.Create( _sl: TBatpro_StringList; _jsdc: TjsDataContexte; _pool: Tpool_Ancetre_Ancetre);
var
   CP: IblG_BECP;
begin
     CP:= Init_ClassParams;
     if Assigned( CP)
     then
         begin
         CP.Libelle:= 'g_becp';
         CP.Font.Name:= sys_Times_New_Roman;
         CP.Font.Size:= 12;
         end;

     inherited;

     Champs.ChampDefinitions.NomTable:= 'g_becp';

     //champs persistants
     Champs.  String_from_String ( nomclasse      , 'nomclasse'      );
     Champs.  String_from_String ( libelle        , 'libelle'        );

end;

destructor Tblg_becp.Destroy;
begin

     inherited;
end;



function Tblg_becp.sCle: String;
begin
     Result:= sCle_ID;
end;





end.


