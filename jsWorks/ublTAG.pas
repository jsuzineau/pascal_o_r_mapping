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
    ufAccueil_Erreur,

    uBatpro_Element,
    uBatpro_Ligne,

    udmDatabase,
    upool_Ancetre_Ancetre,

    SysUtils, Classes, SqlDB, DB;

type
  { ThaTag__Work }
  ThaTag__Work
  =
   class( ThAggregation)
     //Gestion du cycle de vie
     public
       constructor Create( _Parent: TBatpro_Element;
                           _Classe_Elements: TBatpro_Element_Class;
                           _pool_Ancetre_Ancetre: Tpool_Ancetre_Ancetre); override;
       destructor  Destroy; override;
   //Chargement de tous les détails
   public
     procedure Charge; override;
   //Création d'itérateur
   protected
     class function Classe_Iterateur: TIterateur_Class; override;
   //public
   //  function Iterateur: TIterateur_Work;
   //  function Iterateur_Decroissant: TIterateur_Work;
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
    Name: String;
    idType: Integer;
  //Gestion de la clé
  public
    class function sCle_from_( _idType: Integer;  _Name: String): String;

    function sCle: String; override;
  //Aggrégations
  protected
    procedure Create_Aggregation( Name: String; P: ThAggregation_Create_Params); override;
  //Aggrégation vers les Work correspondants
  private
    FhaWork: ThaTag__Work;
    function GethaWork: ThaTag__Work;
  public
    property haWork: ThaTag__Work read GethaWork;
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

var
   TIterateur_Work: TIterateur_Class= nil;
   TblWork: TBatpro_Ligne_Class= nil;
   poolWork: Tfunction_pool_Ancetre_Ancetre= nil;

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

{ ThaTag__Work }

constructor ThaTag__Work.Create( _Parent: TBatpro_Element;
                               _Classe_Elements: TBatpro_Element_Class;
                               _pool_Ancetre_Ancetre: Tpool_Ancetre_Ancetre);
begin
     inherited;
     if Classe_Elements <> _Classe_Elements
     then
         fAccueil_Erreur(  'Erreur à signaler au développeur: '#13#10
                          +' '+ClassName+'.Create: Classe_Elements <> _Classe_Elements:'#13#10
                          +' Classe_Elements='+ Classe_Elements.ClassName+#13#10
                          +'_Classe_Elements='+_Classe_Elements.ClassName
                          );
end;

destructor ThaTag__Work.Destroy;
begin
     inherited;
end;

procedure ThaTag__Work.Charge;
begin
     inherited Charge;
end;

class function ThaTag__Work.Classe_Iterateur: TIterateur_Class;
begin
     Result:= TIterateur_Work;
end;

{
function ThaTag__Work.Iterateur: TIterateur_Work;
begin
     Result:= TIterateur_Work( Iterateur_interne);
end;

function ThaTag__Work.Iterateur_Decroissant: TIterateur_Work;
begin
     Result:= TIterateur_Work( Iterateur_interne_Decroissant);
end;
}

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
     Result:=  IntToHex( _idType, 8)+ _Name;
end;

function TblTAG.sCle: String;
begin
     Result:= sCle_from_(  idType,  Name);
end;

procedure TblTAG.Create_Aggregation( Name: String; P: ThAggregation_Create_Params);
begin
          if 'Work' = Name then P.Faible( ThaTag__Work, TblWork, poolWork)
     else                  inherited Create_Aggregation( Name, P);
end;


function  TblTAG.GethaWork: ThaTag__Work;
begin
     if FhaWork = nil
     then
         FhaWork:= Aggregations['Work'] as ThaTag__Work;

     Result:= FhaWork;
end;

end.


