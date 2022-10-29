unit ublSession;
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            http://www.mars42.com                                               |
                                                                                |
    Copyright 2019 Jean SUZINEAU - MARS42                                       |
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
    uChamp,

    uBatpro_Element,
    uBatpro_Ligne,

    udmDatabase,
    upool_Ancetre_Ancetre,

    SysUtils, Classes, SqlDB, DB;

type
//pattern_aggregation_classe_declaration

 { TblSession }

 TblSession
 =
  class( TBatpro_Ligne)
  //Gestion du cycle de vie
  public
    constructor Create( _sl: TBatpro_StringList; _jsdc: TjsDataContexte; _pool: Tpool_Ancetre_Ancetre); override;
    destructor Destroy; override;
  //champs persistants
  public
    ApplicationKey: String;
    cookie_id: String;
    Port: String;
  //champs calculés
  public
    function URL_interne:String;
    function URL_externe:String;
  //Gestion de la clé
  public
    class function sCle_from_( _cookie_id: String): String;

    function sCle: String; override;
//pattern_aggregation_function_Create_Aggregation_declaration
  end;

 TIterateur_Session
 =
  class( TIterateur)
  //Iterateur
  public
    procedure Suivant( out _Resultat: TblSession);
    function  not_Suivant( out _Resultat: TblSession): Boolean;
  end;

 TslSession
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
    function Iterateur: TIterateur_Session;
    function Iterateur_Decroissant: TIterateur_Session;
  end;

function blSession_from_sl( sl: TBatpro_StringList; Index: Integer): TblSession;
function blSession_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TblSession;

implementation

function blSession_from_sl( sl: TBatpro_StringList; Index: Integer): TblSession;
begin
     _Classe_from_sl( Result, TblSession, sl, Index);
end;

function blSession_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TblSession;
begin
     _Classe_from_sl_sCle( Result, TblSession, sl, sCle);
end;

{ TIterateur_Session }

function TIterateur_Session.not_Suivant( out _Resultat: TblSession): Boolean;
begin
     Result:= not_Suivant_interne( _Resultat);
end;

procedure TIterateur_Session.Suivant( out _Resultat: TblSession);
begin
     Suivant_interne( _Resultat);
end;

{ TslSession }

constructor TslSession.Create( _Nom: String= '');
begin
     inherited CreateE( _Nom, TblSession);
end;

destructor TslSession.Destroy;
begin
     inherited;
end;

class function TslSession.Classe_Iterateur: TIterateur_Class;
begin
     Result:= TIterateur_Session;
end;

function TslSession.Iterateur: TIterateur_Session;
begin
     Result:= TIterateur_Session( Iterateur_interne);
end;

function TslSession.Iterateur_Decroissant: TIterateur_Session;
begin
     Result:= TIterateur_Session( Iterateur_interne_Decroissant);
end;

//pattern_aggregation_classe_implementation

{ TblSession }

constructor TblSession.Create( _sl: TBatpro_StringList; _jsdc: TjsDataContexte; _pool: Tpool_Ancetre_Ancetre);
var
   CP: IblG_BECP;
begin
     CP:= Init_ClassParams;
     if Assigned( CP)
     then
         begin
         CP.Libelle:= 'Session';
         CP.Font.Name:= sys_Times_New_Roman;
         CP.Font.Size:= 12;
         end;

     inherited;

     Champs.ChampDefinitions.NomTable:= 'Session';

     //champs persistants
     Champs.  String_from_String ( ApplicationKey , 'ApplicationKey' );
     Champs.  String_from_String ( cookie_id      , 'cookie_id'      );
     Champs.  String_from_String ( Port           , 'Port'           );

end;

destructor TblSession.Destroy;
begin

     inherited;
end;

function TblSession.URL_interne: String;
begin
     Result:= 'http://localhost:'+Port+'/';
end;

function TblSession.URL_externe: String;
begin
     Result:= 'http://localhost:1500/'+cookie_id+'/';
end;

class function TblSession.sCle_from_( _cookie_id: String): String;
begin 
     Result:=  _cookie_id;
end;  

function TblSession.sCle: String;
begin
     Result:= sCle_from_( cookie_id);
end;

//pattern_aggregation_Create_Aggregation_implementation

//pattern_aggregation_accesseurs_implementation

end.


