unit ublState;
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


 TblState
 =
  class( TBatpro_Ligne)
  //Gestion du cycle de vie
  public
    constructor Create( _sl: TBatpro_StringList; _jsdc: TjsDataContexte; _pool: Tpool_Ancetre_Ancetre); override;
    destructor Destroy; override;
  //champs persistants
  public
    Symbol: String;
    Description: String;
  //Gestion de la clé
  public
  
    function sCle: String; override;

  end;

 TIterateur_State
 =
  class( TIterateur)
  //Iterateur
  public
    procedure Suivant( var _Resultat: TblState);
    function  not_Suivant( var _Resultat: TblState): Boolean;
  end;

 TslState
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
    function Iterateur: TIterateur_State;
    function Iterateur_Decroissant: TIterateur_State;
  end;

function blState_from_sl( sl: TBatpro_StringList; Index: Integer): TblState;
function blState_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TblState;

implementation

function blState_from_sl( sl: TBatpro_StringList; Index: Integer): TblState;
begin
     _Classe_from_sl( Result, TblState, sl, Index);
end;

function blState_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TblState;
begin
     _Classe_from_sl_sCle( Result, TblState, sl, sCle);
end;

{ TIterateur_State }

function TIterateur_State.not_Suivant( var _Resultat: TblState): Boolean;
begin
     Result:= not_Suivant_interne( _Resultat);
end;

procedure TIterateur_State.Suivant( var _Resultat: TblState);
begin
     Suivant_interne( _Resultat);
end;

{ TslState }

constructor TslState.Create( _Nom: String= '');
begin
     inherited CreateE( _Nom, TblState);
end;

destructor TslState.Destroy;
begin
     inherited;
end;

class function TslState.Classe_Iterateur: TIterateur_Class;
begin
     Result:= TIterateur_State;
end;

function TslState.Iterateur: TIterateur_State;
begin
     Result:= TIterateur_State( Iterateur_interne);
end;

function TslState.Iterateur_Decroissant: TIterateur_State;
begin
     Result:= TIterateur_State( Iterateur_interne_Decroissant);
end;



{ TblState }

constructor TblState.Create( _sl: TBatpro_StringList; _jsdc: TjsDataContexte; _pool: Tpool_Ancetre_Ancetre);
var
   CP: IblG_BECP;
begin
     CP:= Init_ClassParams;
     if Assigned( CP)
     then
         begin
         CP.Libelle:= 'State';
         CP.Font.Name:= sys_Times_New_Roman;
         CP.Font.Size:= 12;
         end;

     inherited;

     Champs.ChampDefinitions.NomTable:= 'State';

     //champs persistants
     Champs.  String_from_String ( Symbol         , 'Symbol'         );
     Champs.  String_from_String ( Description    , 'Description'    );

end;

destructor TblState.Destroy;
begin

     inherited;
end;



function TblState.sCle: String;
begin
     Result:= sCle_ID;
end;





end.


