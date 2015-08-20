unit ublg_becpctx;
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


 Tblg_becpctx
 =
  class( TBatpro_Ligne)
  //Gestion du cycle de vie
  public
    constructor Create( _sl: TBatpro_StringList; _q: TDataset; _pool: Tpool_Ancetre_Ancetre); override;
    destructor Destroy; override;
  //champs persistants
  public
    nomclasse: String;
    contexte: Integer;
    logfont: String;
    stringlist: String;
  //Gestion de la clé
  public
  
    function sCle: String; override;

  end;

 TIterateur_g_becpctx
 =
  class( TIterateur)
  //Iterateur
  public
    procedure Suivant( var _Resultat: Tblg_becpctx);
    function  not_Suivant( var _Resultat: Tblg_becpctx): Boolean;
  end;

 Tslg_becpctx
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
    function Iterateur: TIterateur_g_becpctx;
    function Iterateur_Decroissant: TIterateur_g_becpctx;
  end;

function blg_becpctx_from_sl( sl: TBatpro_StringList; Index: Integer): Tblg_becpctx;
function blg_becpctx_from_sl_sCle( sl: TBatpro_StringList; sCle: String): Tblg_becpctx;

implementation

function blg_becpctx_from_sl( sl: TBatpro_StringList; Index: Integer): Tblg_becpctx;
begin
     _Classe_from_sl( Result, Tblg_becpctx, sl, Index);
end;

function blg_becpctx_from_sl_sCle( sl: TBatpro_StringList; sCle: String): Tblg_becpctx;
begin
     _Classe_from_sl_sCle( Result, Tblg_becpctx, sl, sCle);
end;

{ TIterateur_g_becpctx }

function TIterateur_g_becpctx.not_Suivant( var _Resultat: Tblg_becpctx): Boolean;
begin
     Result:= not_Suivant_interne( _Resultat);
end;

procedure TIterateur_g_becpctx.Suivant( var _Resultat: Tblg_becpctx);
begin
     Suivant_interne( _Resultat);
end;

{ Tslg_becpctx }

constructor Tslg_becpctx.Create( _Nom: String= '');
begin
     inherited CreateE( _Nom, Tblg_becpctx);
end;

destructor Tslg_becpctx.Destroy;
begin
     inherited;
end;

class function Tslg_becpctx.Classe_Iterateur: TIterateur_Class;
begin
     Result:= TIterateur_g_becpctx;
end;

function Tslg_becpctx.Iterateur: TIterateur_g_becpctx;
begin
     Result:= TIterateur_g_becpctx( Iterateur_interne);
end;

function Tslg_becpctx.Iterateur_Decroissant: TIterateur_g_becpctx;
begin
     Result:= TIterateur_g_becpctx( Iterateur_interne_Decroissant);
end;



{ Tblg_becpctx }

constructor Tblg_becpctx.Create( _sl: TBatpro_StringList; _q: TDataset; _pool: Tpool_Ancetre_Ancetre);
var
   CP: IblG_BECP;
begin
     CP:= Init_ClassParams;
     if Assigned( CP)
     then
         begin
         CP.Libelle:= 'g_becpctx';
         CP.Font.Name:= sys_Times_New_Roman;
         CP.Font.Size:= 12;
         end;

     inherited;

     Champs.ChampDefinitions.NomTable:= 'g_becpctx';

     //champs persistants
     Champs.  String_from_String ( nomclasse      , 'nomclasse'      );
     Champs. Integer_from_Integer( contexte       , 'contexte'       );
     Champs.  String_from_String ( logfont        , 'logfont'        );
     Champs.  String_from_String ( stringlist     , 'stringlist'     );

end;

destructor Tblg_becpctx.Destroy;
begin

     inherited;
end;



function Tblg_becpctx.sCle: String;
begin
     Result:= sCle_ID;
end;





end.


