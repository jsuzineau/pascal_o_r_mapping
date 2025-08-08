unit ublReputation;
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            http://www.mars42.com                                               |
                                                                                |
    Copyright 2024 Jean SUZINEAU - MARS42                                       |
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
    ufAccueil_Erreur,
    u_sys_,
    uuStrings,
    uBatpro_StringList,
    uChamp,

    uBatpro_Element,
    uBatpro_Ligne,

    udmDatabase,
    upool_Ancetre_Ancetre,
    upool,

//Aggregations_Pascal_ubl_uses_details_pas


    SysUtils, Classes, SqlDB, DB,Math;

type
 TblReputation= class;
//pattern_aggregation_classe_declaration

 { TblReputation }

 TblReputation
 =
  class( TBatpro_Ligne)
  //Gestion du cycle de vie
  public
    constructor Create( _sl: TBatpro_StringList; _jsdc: TjsDataContexte; _pool: Tpool_Ancetre_Ancetre); override;
    destructor Destroy; override;
  //champs persistants
  public
    ip_address: Integer;
    bad: Integer;
    tested: String;
    ip: String;
//Pascal_ubl_declaration_pas_detail
  //Gestion de la clé
  public
    class function sCle_from_( _ip_address: Integer): String;

    function sCle: String; override;
  //Gestion des déconnexions
  public
    procedure Unlink(be: TBatpro_Element); override;
//pattern_aggregation_function_Create_Aggregation_declaration
  private
    function Get_Is_Bad: Boolean;
    procedure Set_Is_Bad( _Value: Boolean);
  public
    property Is_Bad: Boolean read Get_Is_Bad write Set_Is_Bad;
  end;

 TIterateur_Reputation
 =
  class( TIterateur)
  //Iterateur
  public
    procedure Suivant( out _Resultat: TblReputation);
    function  not_Suivant( out _Resultat: TblReputation): Boolean;
  end;

 TslReputation
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
    function Iterateur: TIterateur_Reputation;
    function Iterateur_Decroissant: TIterateur_Reputation;
  end;

function blReputation_from_sl( sl: TBatpro_StringList; Index: Integer): TblReputation;
function blReputation_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TblReputation;

//Details_Pascal_ubl_declaration_pools_aggregations_pas

implementation

function blReputation_from_sl( sl: TBatpro_StringList; Index: Integer): TblReputation;
begin
     _Classe_from_sl( Result, TblReputation, sl, Index);
end;

function blReputation_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TblReputation;
begin
     _Classe_from_sl_sCle( Result, TblReputation, sl, sCle);
end;

{ TIterateur_Reputation }

function TIterateur_Reputation.not_Suivant( out _Resultat: TblReputation): Boolean;
begin
     Result:= not_Suivant_interne( _Resultat);
end;

procedure TIterateur_Reputation.Suivant( out _Resultat: TblReputation);
begin
     Suivant_interne( _Resultat);
end;

{ TslReputation }

constructor TslReputation.Create( _Nom: String= '');
begin
     inherited CreateE( _Nom, TblReputation);
end;

destructor TslReputation.Destroy;
begin
     inherited;
end;

class function TslReputation.Classe_Iterateur: TIterateur_Class;
begin
     Result:= TIterateur_Reputation;
end;

function TslReputation.Iterateur: TIterateur_Reputation;
begin
     Result:= TIterateur_Reputation( Iterateur_interne);
end;

function TslReputation.Iterateur_Decroissant: TIterateur_Reputation;
begin
     Result:= TIterateur_Reputation( Iterateur_interne_Decroissant);
end;

//pattern_aggregation_classe_implementation

{ TblReputation }

constructor TblReputation.Create( _sl: TBatpro_StringList; _jsdc: TjsDataContexte; _pool: Tpool_Ancetre_Ancetre);
var
   CP: IblG_BECP;
begin
     CP:= Init_ClassParams;
     if Assigned( CP)
     then
         begin
         CP.Libelle:= 'Reputation';
         CP.Font.Name:= sys_Times_New_Roman;
         CP.Font.Size:= 12;
         end;

     inherited;

     Champs.ChampDefinitions.NomTable:= 'Reputation';

     //champs persistants
     Champs. Integer_from_Integer( ip_address     , 'ip_address'     );
     Champs. Integer_from_Integer( bad            , 'bad'            );
     Champs.  String_from_String ( tested         , 'tested'         );
     Champs.  String_from_String ( ip             , 'ip'             );
     if (ip = '') and (ip_address <> 0)
     then
         begin
         ip:= Format( '%d.%d.%d.%d',
                      [
                      Hi(Hi(Longint(ip_address))),
                      Lo(Hi(Longint(ip_address))),
                      Hi(Lo(Longint(ip_address))),
                      Lo(Lo(Longint(ip_address)))
                      ]);
         Save_to_database;
         end;

//Pascal_ubl_constructor_pas_detail
end;

destructor TblReputation.Destroy;
begin

     inherited;
end;

class function TblReputation.sCle_from_( _ip_address: Integer): String;
begin 
     Result:=  IntToStr( LongWord(Longint( _ip_address)));
end;  

function TblReputation.sCle: String;
begin
     Result:= sCle_from_( ip_address);
end;

procedure TblReputation.Unlink( be: TBatpro_Element);
begin
     inherited Unlink( be);
     ;

end;

function TblReputation.Get_Is_Bad: Boolean;
begin
     Result:= 1 = bad;
end;

procedure TblReputation.Set_Is_Bad( _Value: Boolean);
var
   Old_bad: Integer;
begin
     Old_bad:= bad;
     bad:= IfThen( _Value, 1, 0);
     if bad <> Old_bad
     then
         Save_to_database;
end;

//pattern_aggregation_accesseurs_implementation

//Pascal_ubl_implementation_pas_detail

initialization
finalization
end.


