unit ublPouls;
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            http://www.mars42.com                                               |
                                                                                |
    Copyright 2014 Jean SUZINEAU - MARS42                                       |
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

interface

uses
    uClean,
    u_sys_,
    uuStrings,
    uBatpro_StringList,
    uChamp,
    ufAccueil_Erreur,

    uBatpro_Element,
    uBatpro_Ligne,

    udmDatabase,

    SysUtils, Classes, sqldb, DB,DateUtils, Math;

type
  { TblPouls }

 TblPouls
 =
  class( TBatpro_Ligne)
  //Gestion du cycle de vie
  public
    constructor Create( _sl: TBatpro_StringList; _jsdc: TjsDataContexte; _pool: Tpool_Ancetre_Ancetre); override;
    destructor Destroy; override;
  //champs
  public
    Secondes: double;
    iPouls: Integer;
  //Gestion de la clé
  public
    function sCle: String; override;
  end;

 TIterateur_Pouls
 =
  class( TIterateur)
  //Iterateur
  public
    procedure Suivant( var _Resultat: TblPouls);
    function  not_Suivant( var _Resultat: TblPouls): Boolean;
  end;

 TslPouls
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
    function Iterateur: TIterateur_Pouls;
    function Iterateur_Decroissant: TIterateur_Pouls;
  end;

function sNb_Heures_from_DateTime( _dt: TDateTime): String;
function sNb_Heures_Arrondi_from_DateTime( _dt: TDateTime): String;

function blPouls_from_sl( sl: TBatpro_StringList; Index: Integer): TblPouls;
function blPouls_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TblPouls;

implementation

function blPouls_from_sl( sl: TBatpro_StringList; Index: Integer): TblPouls;
begin
     _Classe_from_sl( Result, TblPouls, sl, Index);
end;

function blPouls_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TblPouls;
begin
     _Classe_from_sl_sCle( Result, TblPouls, sl, sCle);
end;

{ TIterateur_Pouls }

function TIterateur_Pouls.not_Suivant( var _Resultat: TblPouls): Boolean;
begin
     Result:= not_Suivant_interne( _Resultat);
end;

procedure TIterateur_Pouls.Suivant( var _Resultat: TblPouls);
begin
     Suivant_interne( _Resultat);
end;

{ TslPouls }

constructor TslPouls.Create( _Nom: String= '');
begin
     inherited CreateE( _Nom, TblPouls);
end;

destructor TslPouls.Destroy;
begin
     inherited;
end;

class function TslPouls.Classe_Iterateur: TIterateur_Class;
begin
     Result:= TIterateur_Pouls;
end;

function TslPouls.Iterateur: TIterateur_Pouls;
begin
     Result:= TIterateur_Pouls( Iterateur_interne);
end;

function TslPouls.Iterateur_Decroissant: TIterateur_Pouls;
begin
     Result:= TIterateur_Pouls( Iterateur_interne_Decroissant);
end;

{ TblPouls }

constructor TblPouls.Create( _sl: TBatpro_StringList; _jsdc: TjsDataContexte; _pool: Tpool_Ancetre_Ancetre);
var
   CP: IblG_BECP;
begin
     CP:= Init_ClassParams;
     if Assigned( CP)
     then
         begin
         CP.Libelle:= 'Pouls';
         CP.Font.Name:= sys_Times_New_Roman;
         CP.Font.Size:= 12;
         end;

     inherited;

     Champs.ChampDefinitions.NomTable:= 'Pouls';

     //champs
     Ajou
     Secondes: double;
     iPouls: Integer;

     Integer_from_ ( nUser          , 'nUser'          );
     Integer_from_ ( nProject       , 'nProject'       );

     cBeginning:= DateTime_from_( Beginning      , 'Beginning'      );
     cBeginning.Definition.Format_DateTime:= 'yyyy/mm/dd" "hh:nn';

     cEnd:= DateTime_from_( End_           , 'End'            );
     cEnd.Definition.Format_DateTime:= 'yyyy/mm/dd" "hh:nn';

     String_from_  ( Description    , 'Description'    );

     cDuree:= Ajoute_Float( FDuree, 'Duree', False);
     cDuree.OnGetChaine:= Duree_GetChaine;

     csSession:= Ajoute_String( FsSession,'sSession', False);
     csSession.OnGetChaine:= sSession_GetChaine;
end;

destructor TblPouls.Destroy;
begin

     inherited;
end;

procedure TblPouls.Create_Aggregation( Name: String; P: ThAggregation_Create_Params);
begin
          if 'Tag' = Name then P.Faible( ThaPouls__Tag, TblTag, poolTag)
     else if 'Tag_from_Description' = Name then P.Faible( ThaPouls__Tag_from_Description, TblTag, poolTag)
     else                  inherited Create_Aggregation( Name, P);
end;

function  TblPouls.GethaTag: ThaPouls__Tag;
begin
     if FhaTag = nil
     then
         FhaTag:= Aggregations['Tag'] as ThaPouls__Tag;

     Result:= FhaTag;
end;

function  TblPouls.GethaTag_from_Description: ThaPouls__Tag_from_Description;
begin
     if FhaTag_from_Description = nil
     then
         FhaTag_from_Description:= Aggregations['Tag_from_Description'] as ThaPouls__Tag_from_Description;

     Result:= FhaTag_from_Description;
end;

procedure TblPouls.Duree_GetChaine(var _Chaine: String);
begin
     _Chaine:= sDuree;
end;

function TblPouls.sDuree: String;
begin
     Result:= FormatDateTime( 'hh:nn', Duree);
end;

function TblPouls.GetDuree: TDateTime;
begin
     if End_ < Beginning
     then
         FDuree:= 0
     else
         FDuree:= End_ - Beginning;

     Result:= FDuree;
end;

function TblPouls.sCle: String;
begin
     Result:= sCle_ID;
end;

procedure TblPouls.Stop;
begin
     End_:= Now;
     Save_to_database;
end;

procedure TblPouls.sSession_GetChaine(var _Chaine: String);
begin
     _Chaine:= GetsSession;
end;

function TblPouls.GetsSession: String;
begin
     Result
     :=
       // FormatDateTime( 'hh:nn', Beginning)
       //+'-'
       //+FormatDateTime( 'hh:nn', End_     )
       //+'('+sDuree+'):'
        sDuree+':'
       +Description;
       ;
end;

function TblPouls.Session_Differente( _bl: TblPouls): Boolean;
     function Test( _1, _2: TblPouls): Boolean;
     const
          dt_2_minute= (2{minute}/60{heure})/24{jour};
     var
        Delta: TDateTime;
     begin
          Delta:= _2.Beginning - _1.End_;
          Result:= Delta > dt_2_minute;
     end;
begin
     Result:= True;
     if _bl = nil then exit;

     if Self.Beginning < _bl.Beginning
     then
         Result:= Test( Self, _bl)
     else
         Result:= Test( _bl, Self);
end;

function TblPouls.Semaine_Differente(_bl: TblPouls): Boolean;
begin
     Result:= True;
     if _bl = nil then exit;

     Result:= WeekOfTheYear( Beginning) <> WeekOfTheYear( _bl.Beginning);
end;

function TblPouls.Jour_Different(_bl: TblPouls): Boolean;
begin
     Result:= True;
     if _bl = nil then exit;

     Result:= DayOfTheMonth( Beginning) <> DayOfTheMonth( _bl.Beginning);
end;

procedure TblPouls.Tag( _blTag: TblTag);
begin
     if _blTag = nil then exit;
     poolTag_Pouls.Assure( _blTag.id, id);
     haTag.Ajoute( _blTag);
end;

initialization
              ublTag.TIterateur_Pouls:= TIterateur_Pouls;
              ublTag.TblPouls:= TblPouls;
              ublTag.poolPouls:= poolPouls;
finalization
            ublTag.TIterateur_Pouls:= nil;
            ublTag.TblPouls:= nil;
            ublTag.poolPouls:= nil;
end.


