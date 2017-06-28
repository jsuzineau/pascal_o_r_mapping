unit ublTag_Development;
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
 TblTag_Development
 =
  class( TBatpro_Ligne)
  //Gestion du cycle de vie
  public
    constructor Create( _sl: TBatpro_StringList; _jsdc: TjsDataContexte; _pool: Tpool_Ancetre_Ancetre); override;
    destructor Destroy; override;
  //champs persistants
  public
    idTag: Integer;
    idDevelopment: Integer;
  //Gestion de la clé
  public
    class function sCle_from_( _idTag: Integer;  _idDevelopment: Integer): String;
    function sCle: String; override;
  end;

 TIterateur_Tag_Development
 =
  class( TIterateur)
  //Iterateur
  public
    procedure Suivant( var _Resultat: TblTag_Development);
    function  not_Suivant( var _Resultat: TblTag_Development): Boolean;
  end;

 TslTag_Development
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
    function Iterateur: TIterateur_Tag_Development;
    function Iterateur_Decroissant: TIterateur_Tag_Development;
  end;

function blTag_Development_from_sl( sl: TBatpro_StringList; Index: Integer): TblTag_Development;
function blTag_Development_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TblTag_Development;

implementation

function blTag_Development_from_sl( sl: TBatpro_StringList; Index: Integer): TblTag_Development;
begin
     _Classe_from_sl( Result, TblTag_Development, sl, Index);
end;

function blTag_Development_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TblTag_Development;
begin
     _Classe_from_sl_sCle( Result, TblTag_Development, sl, sCle);
end;

{ TIterateur_Tag_Development }

function TIterateur_Tag_Development.not_Suivant( var _Resultat: TblTag_Development): Boolean;
begin
     Result:= not_Suivant_interne( _Resultat);
end;

procedure TIterateur_Tag_Development.Suivant( var _Resultat: TblTag_Development);
begin
     Suivant_interne( _Resultat);
end;

{ TslTag_Development }

constructor TslTag_Development.Create( _Nom: String= '');
begin
     inherited CreateE( _Nom, TblTag_Development);
end;

destructor TslTag_Development.Destroy;
begin
     inherited;
end;

class function TslTag_Development.Classe_Iterateur: TIterateur_Class;
begin
     Result:= TIterateur_Tag_Development;
end;

function TslTag_Development.Iterateur: TIterateur_Tag_Development;
begin
     Result:= TIterateur_Tag_Development( Iterateur_interne);
end;

function TslTag_Development.Iterateur_Decroissant: TIterateur_Tag_Development;
begin
     Result:= TIterateur_Tag_Development( Iterateur_interne_Decroissant);
end;

{ TblTag_Development }

constructor TblTag_Development.Create( _sl: TBatpro_StringList; _jsdc: TjsDataContexte; _pool: Tpool_Ancetre_Ancetre);
var
   CP: IblG_BECP;
begin
     CP:= Init_ClassParams;
     if Assigned( CP)
     then
         begin
         CP.Libelle:= 'Tag_Development';
         CP.Font.Name:= sys_Times_New_Roman;
         CP.Font.Size:= 12;
         end;

     inherited;

     Champs.ChampDefinitions.NomTable:= 'Tag_Development';

     //champs persistants
     Champs. Integer_from_Integer( idTag          , 'idTag'          );
     Champs. Integer_from_Integer( idDevelopment  , 'idDevelopment'  );

end;

destructor TblTag_Development.Destroy;
begin

     inherited;
end;

class function TblTag_Development.sCle_from_( _idTag: Integer;  _idDevelopment: Integer): String;
begin
     Result
     :=
         IntToHex( _idTag        , 8)
       + IntToHex( _idDevelopment, 8);
end;

function TblTag_Development.sCle: String;
begin
     Result:= sCle_from_( idTag, idDevelopment);
end;

end.


