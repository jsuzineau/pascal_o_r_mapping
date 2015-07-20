unit ublTAG;
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
  { ThaTag__Tag_Work }    
  ThaTag__Tag_Work        
  =                                                   
   class( ThAggregation)                              
   //Chargement de tous les détails
   public                                             
     procedure Charge; override;                      
  //Création d'itérateur
  protected                                                           
    class function Classe_Iterateur: TIterateur_Class; override;      
  public                                                              
    function Iterateur: TIterateur_Tag_Work;               
    function Iterateur_Decroissant: TIterateur_Tag_Work;   
   end;                                                               


 TblTAG
 =
  class( TBatpro_Ligne)
  //Gestion du cycle de vie
  public
    constructor Create( _sl: TBatpro_StringList; _q: TDataset; _pool: Tpool_Ancetre_Ancetre); override;
    destructor Destroy; override;
  //champs persistants
  public
    id: Integer;
    idType: Integer;
    Name: String;
  //Gestion de la clé
  public
    class function sCle_from_( _idType: Integer;  _Name: String): String;
  
    function sCle: String; override;
  end;

 TIterateur_TAG
 =
  class( TIterateur)
  //Iterateur
  public
    procedure Suivant( var _Resultat: TblTAG);
    function  not_Suivant( var _Resultat: TblTAG): Boolean;
  end;

 TslTAG
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
    function Iterateur: TIterateur_TAG;
    function Iterateur_Decroissant: TIterateur_TAG;
  end;

function blTAG_from_sl( sl: TBatpro_StringList; Index: Integer): TblTAG;
function blTAG_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TblTAG;

implementation

function blTAG_from_sl( sl: TBatpro_StringList; Index: Integer): TblTAG;
begin
     _Classe_from_sl( Result, TblTAG, sl, Index);
end;

function blTAG_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TblTAG;
begin
     _Classe_from_sl_sCle( Result, TblTAG, sl, sCle);
end;

{ TIterateur_TAG }

function TIterateur_TAG.not_Suivant( var _Resultat: TblTAG): Boolean;
begin
     Result:= not_Suivant_interne( _Resultat);
end;

procedure TIterateur_TAG.Suivant( var _Resultat: TblTAG);
begin
     Suivant_interne( _Resultat);
end;

{ TslTAG }

constructor TslTAG.Create( _Nom: String= '');
begin
     inherited CreateE( _Nom, TblTAG);
end;

destructor TslTAG.Destroy;
begin
     inherited;
end;

class function TslTAG.Classe_Iterateur: TIterateur_Class;
begin
     Result:= TIterateur_TAG;
end;

function TslTAG.Iterateur: TIterateur_TAG;
begin
     Result:= TIterateur_TAG( Iterateur_interne);
end;

function TslTAG.Iterateur_Decroissant: TIterateur_TAG;
begin
     Result:= TIterateur_TAG( Iterateur_interne_Decroissant);
end;


{ TblTAG }

constructor TblTAG.Create( _sl: TBatpro_StringList; _q: TDataset; _pool: Tpool_Ancetre_Ancetre);
var
   CP: IblG_BECP;
begin
     CP:= Init_ClassParams;
     if Assigned( CP)
     then
         begin
         CP.Libelle:= 'TAG';
         CP.Font.Name:= sys_Times_New_Roman;
         CP.Font.Size:= 12;
         end;

     inherited;

     Champs.ChampDefinitions.NomTable:= 'Tag';

     //champs persistants
     Champs. Integer_from_Integer( id             , 'id'             );
     Champs. Integer_from_Integer( idType         , 'idType'         );
     Champs.  String_from_String ( Name           , 'Name'           );

end;

destructor TblTAG.Destroy;
begin

     inherited;
end;

class function TblTAG.sCle_from_( _idType: Integer;  _Name: String): String;
begin 
     Result:=  _idType+ _Name;
end;  

function TblTAG.sCle: String;
begin
     Result:= sCle_from_( idType, Name);
end;

end.


