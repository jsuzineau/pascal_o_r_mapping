unit upoolPouls;
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
    uBatpro_StringList,
    uhAggregation,
    uDataUtilsU,

    uBatpro_Element,

    ublTag,

    ublPouls,

    udmDatabase,
    udmBatpro_DataModule,
    uPool,

    uhfPouls,

    uHTTP_Interface,

  SysUtils, Classes,
  DB, sqldb;

type

 { TpoolPouls }

 TpoolPouls
 =
  class( TPool)
    procedure DataModuleCreate(Sender: TObject);  override;
  //Filtre
  public
    hfPouls: ThfPouls;
  //Accés général
  public
    function Get( _id: integer): TblPouls;
  //Méthode de création de test
  public
    function Test( _nProject   : Integer;
                   _Beginning  : TDateTime;
                   _End        : TDateTime;
                   _Description: String;
                   _nUser      : Integer
                   ):Integer;
  //Chargement d'un projet
  public
    procedure Charge_Project( _nProject: Integer; slLoaded: TBatpro_StringList = nil);
  //Début d'une nouvelle session
  public
    function Start( _nProject: Integer): TblPouls;
  //Gestion communication HTTP avec pages html Angular / JSON
  public
    function Traite_HTTP: Boolean; override;
  //Chargement d'une période
  public
    procedure Charge_Periode( _Debut, _Fin: TDateTime; _idTag: Integer= 0; _slLoaded: TBatpro_StringList = nil);
  //Chargement des Pouls d'un Tag
  public
    procedure Charge_Tag( _idTag: Integer; _slLoaded: TBatpro_StringList);
  //Tag_from_Description
  public
    procedure Tag_from_Description;
  end;

function poolPouls: TpoolPouls;

implementation



var
   FpoolPouls: TpoolPouls;

function poolPouls: TpoolPouls;
begin
     TPool.class_Get( Result, FpoolPouls, TpoolPouls);
end;

function poolPouls_Ancetre_Ancetre: Tpool_Ancetre_Ancetre;
begin
     Result:= poolPouls;
end;
{ TpoolPouls }

procedure TpoolPouls.DataModuleCreate(Sender: TObject);
begin
     NomTable:= 'Pouls';
     Classe_Elements:= TblPouls;
     Classe_Filtre:= ThfPouls;

     inherited;

     hfPouls:= hf as ThfPouls;
     ChampTri['Beginning']:= +1;

     ublTag.poolPouls_Charge_Tag:= Charge_Tag;
end;

function TpoolPouls.Get( _id: integer): TblPouls;
begin
     Get_Interne_from_id( _id, Result);
end;

function TpoolPouls.Test( _nProject   : Integer;
                         _Beginning  : TDateTime;
                         _End        : TDateTime;
                         _Description: String;
                         _nUser      : Integer
                         ):Integer;
var
   bl: TblPouls;
begin
     Nouveau_Base( bl);
       bl.End_           := _End          ;
       bl.Description    := _Description  ;
       bl.nUser          := _nUser        ;
       bl.nProject       := _nProject     ;
       bl.Beginning      := _Beginning    ;
     bl.Save_to_database;
     Result:= bl.id;
end;

procedure TpoolPouls.Charge_Project( _nProject: Integer; slLoaded: TBatpro_StringList);
var
   SQL: String;
begin
     SQL:= 'select * from '+NomTable+' where nProject = '+IntToStr( _nProject);

     Load( SQL, slLoaded);
end;

function TpoolPouls.Start( _nProject: Integer): TblPouls;
begin
     Nouveau_Base( Result);
     if Result = nil then exit;

     Result.nProject:= _nProject;
     Result.Beginning:= Now;
     Result.Save_to_database;
end;

function TpoolPouls.Traite_HTTP: Boolean;
     function http_from_Project: Boolean;
     var
        sidProject: String;
        idProject: Integer;
        sl: TBatpro_StringList;
     begin
          sidProject:= HTTP_Interface.uri;
          Result:= TryStrToInt( sidProject, idProject);
          if not Result then exit;

          sl:= TBatpro_StringList.Create;
          Charge_Project( idProject, sl);
          HTTP_Interface.Send_JSON( sl.JSON);
          FreeAndNil( sl);
     end;
     function http_Start: Boolean;
     var
        sidProject: String;
        idProject: Integer;
        bl: TblPouls;
     begin
          sidProject:= HTTP_Interface.uri;
          Result:= TryStrToInt( sidProject, idProject);
          if not Result then exit;

          bl:= Start( idProject);
          Result:= Assigned( bl);
          if not Result then exit;

          HTTP_Interface.Send_JSON( bl.JSON);
     end;
     function http_Stop: Boolean;
     var
        sidPouls: String;
        idPouls: Integer;
        bl: TblPouls;
     begin
          sidPouls:= HTTP_Interface.uri;
          Result:= TryStrToInt( sidPouls, idPouls);
          if not Result then exit;

          bl:= Get( idPouls);
          Result:= Assigned( bl);
          if not Result then exit;

          bl.Stop;
          HTTP_Interface.Send_JSON( bl.JSON);
     end;
begin
     Result:=inherited Traite_HTTP;
     if Result then exit;

          if HTTP_Interface.Prefixe('_Start')       then Result:= http_Start
     else if HTTP_Interface.Prefixe('_Stop' )       then Result:= http_Stop
     else if HTTP_Interface.Prefixe('_from_Project')then Result:= http_from_Project
     else                                                Result:= False;
end;

procedure TpoolPouls.Charge_Periode( _Debut, _Fin: TDateTime; _idTag: Integer= 0;
                                    _slLoaded: TBatpro_StringList= nil);
var
   SQL: String;
   P: TParams;
   pDebut, pFin: TParam;
begin
     if _idTag = 0
     then
         SQL:= 'select * from '+NomTable+' where Beginning >= :Debut and Beginning <= :Fin'
     else
         SQL
         :=
  'select                                          '#13#10
 +'      Pouls.*                                    '#13#10
 +'from                                            '#13#10
 +'    Tag_Pouls                                        '#13#10
 +'left join Pouls                             '#13#10
 +'on                                              '#13#10
 +'      (Tag_Pouls.idTag  = '+IntToStr(_idTag)+')  '#13#10
 +'  and (Tag_Pouls.idPouls = Pouls.id             )  '#13#10
 +'where                                           '#13#10
 +'         Pouls.id is not null                    '#13#10
 +'     and Tag_Pouls.id is not null                '#13#10
 +'     and Beginning >= :Debut and Beginning <= :Fin'#13#10;
     P:= TParams.Create;
     try
        pDebut:= CreeParam( P, 'Debut');
        pFin  := CreeParam( P, 'Fin'  );
        pDebut.AsDateTime:= Trunc( _Debut);
        pFin  .AsDateTime:= Trunc(_Fin)+1;
        Load( SQL, _slLoaded, nil, P);
     finally
            FreeAndNil( P);
            end;
     Tri.Execute( _slLoaded);
end;

procedure TpoolPouls.Charge_Tag(_idTag: Integer; _slLoaded: TBatpro_StringList);
var
   SQL: String;
begin
     SQL
     :=
 'select                                          '#13#10
+'      Pouls.*                                   '#13#10
+'from                                            '#13#10
+'    Tag_Pouls                                   '#13#10
+'left join Pouls                                 '#13#10
+'on                                              '#13#10
+'      (Tag_Pouls.idTag  = '+IntToStr(_idTag)+')  '#13#10
+'  and (Tag_Pouls.idPouls = Pouls.id             )  '#13#10
+'where                                           '#13#10
+'         Pouls.id is not null                    '#13#10
+'     and Tag_Pouls.id is not null                '#13#10;
     Load( SQL, _slLoaded);
end;

procedure TpoolPouls.Tag_from_Description;
var
   I: TIterateur;
   bl: TblPouls;
   blTag: TblTag;
begin
     ToutCharger;
     I:= slT.Iterateur_interne;
     while I.Continuer
     do
       begin
       if I.not_Suivant_interne( bl) then continue;

       bl.haTag_from_Description.Valide;
       end;
end;

initialization
              ublTag.poolPouls:= poolPouls_Ancetre_Ancetre;
finalization
              TPool.class_Destroy( FpoolPouls);
end.
