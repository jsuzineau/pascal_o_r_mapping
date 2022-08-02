unit ublProject;
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

    uBatpro_Element,
    uBatpro_Ligne,

    ublTag,
    upoolTag,

    ublWork,
    upoolWork,

    ublDevelopment,
    upoolDevelopment,

    udmDatabase,
    upool_Ancetre_Ancetre,

    SysUtils, Classes, SqlDB, DB;

type

  { ThaProject__Work }
  ThaProject__Work
  =
   class( ThAggregation)
   //Chargement de tous les détails
   public
     procedure Charge; override;
   //Méthodes
   public
     function Start: TblWork;
     procedure Tag( _blTag: TblTag);
   end;

  { ThaProject__Development }
  ThaProject__Development
  =
   class( ThAggregation)
   //Chargement de tous les détails
   public
     procedure Charge; override;
   //Méthodes
   public
     function Point: TblDevelopment;
     function Bug: TblDevelopment;
     procedure Tag( _blTag: TblTag);
   end;

 TblProject
 =
  class( TBatpro_Ligne)
  //Gestion du cycle de vie
  public
    constructor Create( _sl: TBatpro_StringList; _jsdc: TjsDataContexte; _pool: Tpool_Ancetre_Ancetre); override;
    destructor Destroy; override;
  //champs persistants
  public
    Name: string;
  //Gestion de la clé
  public
    function sCle: String; override;
  //Aggrégations
  protected
    procedure Create_Aggregation( Name: String; P: ThAggregation_Create_Params); override;
  //Aggrégation vers les Work correspondants
  private
    FhaWork: ThaProject__Work;
    function GethaWork: ThaProject__Work;
  public
    property haWork: ThaProject__Work read GethaWork;
  //Aggrégation vers les Development correspondants
  private
    FhaDevelopment: ThaProject__Development;
    function GethaDevelopment: ThaProject__Development;
  public
    property haDevelopment: ThaProject__Development read GethaDevelopment;
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

{ ThaProject__Work }

procedure ThaProject__Work.Charge;
var
   blProject: TblProject;
begin
     inherited;

     if Affecte_( blProject, TblProject, Parent) then exit;

     poolWork.Charge_Project( blProject.id, slCharge);
     Ajoute_slCharge;
end;

function ThaProject__Work.Start: TblWork;
var
   blProject: TblProject;
begin
     Result:= nil;

     if Affecte_( blProject, TblProject, Parent) then exit;

     Result:= poolWork.Start( blProject.id);
end;

procedure ThaProject__Work.Tag(_blTag: TblTag);
var
   I: TIterateur;
   bl: TblWork;
begin
     Charge;
     I:= Iterateur_interne;
     while I.Continuer
     do
       begin
       if I.not_Suivant_interne( bl) then continue;

       bl.Tag( _blTag);
       end;
end;

{ ThaProject__Development }

procedure ThaProject__Development.Charge;
var
   blProject: TblProject;
begin
     inherited;

     if Affecte_( blProject, TblProject, Parent) then exit;

     poolDevelopment.Charge_Project( blProject.id, slCharge);
     Ajoute_slCharge;
end;

function ThaProject__Development.Point: TblDevelopment;
var
   blProject: TblProject;
begin
     Result:= nil;

     if Affecte_( blProject, TblProject, Parent) then exit;

     Result:=poolDevelopment.Point( blProject.id);
end;

function ThaProject__Development.Bug: TblDevelopment;
var
   blProject: TblProject;
begin
     Result:= nil;

     if Affecte_( blProject, TblProject, Parent) then exit;

     Result:=poolDevelopment.Point( blProject.id);
end;

procedure ThaProject__Development.Tag(_blTag: TblTag);
var
   I: TIterateur;
   bl: TblDevelopment;
begin
     Charge;
     I:= Iterateur_interne;
     while I.Continuer
     do
       begin
       if I.not_Suivant_interne( bl) then continue;

       bl.Tag( _blTag);
       end;
end;
{ TblProject }

constructor TblProject.Create( _sl: TBatpro_StringList; _jsdc: TjsDataContexte; _pool: Tpool_Ancetre_Ancetre);
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
     cLibelle:= Champs.  String_from_String ( Name           , 'Name'           );
end;

destructor TblProject.Destroy;
begin

     inherited;
end;

function TblProject.sCle: String;
begin
     Result:= sCle_ID;
end;

procedure TblProject.Create_Aggregation( Name: String; P: ThAggregation_Create_Params);
begin
          if 'Work'         = Name then P.Forte( ThaProject__Work       , TblWork       , poolWork)
     else if 'Development'  = Name then P.Forte( ThaProject__Development, TblDevelopment, poolDevelopment)
     else                               inherited Create_Aggregation( Name, P);
end;

function TblProject.GethaWork: ThaProject__Work;
begin
     Get_Aggregation( Result, FhaWork, 'Work');
end;

function TblProject.GethaDevelopment: ThaProject__Development;
begin
     Get_Aggregation( Result, FhaDevelopment, 'Development');
end;

end.


