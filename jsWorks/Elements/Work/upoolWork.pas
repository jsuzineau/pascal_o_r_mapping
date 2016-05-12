unit upoolWork;
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
    uSGBD,

    uBatpro_Element,

    ublTag,

    ublWork,

    udmDatabase,
    udmBatpro_DataModule,
    uPool,

    uhfWork,

    uHTTP_Interface,

  SysUtils, Classes,
  DB, sqldb;

type

 { TpoolWork }

 TpoolWork
 =
  class( TPool)
    procedure DataModuleCreate(Sender: TObject);
  //Filtre
  public
    hfWork: ThfWork;
  //Accés général
  public
    function Get( _id: integer): TblWork;
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
    function Start( _nProject: Integer): TblWork;
  //Gestion communication HTTP avec pages html Angular / JSON
  public
    function Traite_HTTP: Boolean; override;
  //Chargement d'une période
  public
    procedure Charge_Periode( _Debut, _Fin: TDateTime; _idTag: Integer= 0; _slLoaded: TBatpro_StringList = nil);
  //Chargement des Work d'un Tag
  public
    procedure Charge_Tag( _idTag: Integer; _slLoaded: TBatpro_StringList);
  //Tag_from_Description
  public
    procedure Tag_from_Description;
  end;

function poolWork: TpoolWork;

implementation

{$R *.lfm}

var
   FpoolWork: TpoolWork;

function poolWork: TpoolWork;
begin
     Clean_Get( Result, FpoolWork, TpoolWork);
end;

function poolWork_Ancetre_Ancetre: Tpool_Ancetre_Ancetre;
begin
     Result:= poolWork;
end;
{ TpoolWork }

procedure TpoolWork.DataModuleCreate(Sender: TObject);
begin
     NomTable:= 'Work';
     Classe_Elements:= TblWork;
     Classe_Filtre:= ThfWork;

     inherited;

     hfWork:= hf as ThfWork;
     ChampTri['Beginning']:= +1;

     ublTag.poolWork_Charge_Tag:= Charge_Tag;
end;

function TpoolWork.Get( _id: integer): TblWork;
begin
     Get_Interne_from_id( _id, Result);
end;

function TpoolWork.Test( _nProject   : Integer;
                         _Beginning  : TDateTime;
                         _End        : TDateTime;
                         _Description: String;
                         _nUser      : Integer
                         ):Integer;
var
   bl: TblWork;
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

procedure TpoolWork.Charge_Project( _nProject: Integer; slLoaded: TBatpro_StringList);
var
   SQL: String;
begin
     SQL:= 'select * from '+NomTable+' where nProject = '+IntToStr( _nProject);

     Load( SQL, slLoaded);
end;

function TpoolWork.Start( _nProject: Integer): TblWork;
begin
     Nouveau_Base( Result);
     if Result = nil then exit;

     Result.nProject:= _nProject;
     Result.Beginning:= Now;
     Result.Save_to_database;
end;

function TpoolWork.Traite_HTTP: Boolean;
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
        bl: TblWork;
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
        sidWork: String;
        idWork: Integer;
        bl: TblWork;
     begin
          sidWork:= HTTP_Interface.uri;
          Result:= TryStrToInt( sidWork, idWork);
          if not Result then exit;

          bl:= Get( idWork);
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

procedure TpoolWork.Charge_Periode( _Debut, _Fin: TDateTime; _idTag: Integer= 0;
                                    _slLoaded: TBatpro_StringList= nil);
   procedure Version_avec_TParams;
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
    +'      Work.*                                    '#13#10
    +'from                                            '#13#10
    +'    Tag_Work                                        '#13#10
    +'left join Work                             '#13#10
    +'on                                              '#13#10
    +'      (Tag_Work.idTag  = '+IntToStr(_idTag)+')  '#13#10
    +'  and (Tag_Work.idWork = Work.id             )  '#13#10
    +'where                                           '#13#10
    +'         Work.id is not null                    '#13#10
    +'     and Tag_Work.id is not null                '#13#10
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
   end;
   procedure Version_avec_sgbd_DateTimeSQL;
   var
      SQL: String;
      sDebut, sFin: String;
   begin
        sDebut:= sgbd_DateTimeSQL( _Debut);
        sFin  := sgbd_DateTimeSQL( _Fin  );

        if _idTag = 0
        then
            SQL:= 'select * from '+NomTable+' where Beginning >= "'+sDebut+'" and Beginning <= "'+sFin+'"'
        else
            SQL
            :=
     'select                                          '#13#10
    +'      Work.*                                    '#13#10
    +'from                                            '#13#10
    +'    Tag_Work                                        '#13#10
    +'left join Work                             '#13#10
    +'on                                              '#13#10
    +'      (Tag_Work.idTag  = '+IntToStr(_idTag)+')  '#13#10
    +'  and (Tag_Work.idWork = Work.id             )  '#13#10
    +'where                                           '#13#10
    +'         Work.id is not null                    '#13#10
    +'     and Tag_Work.id is not null                '#13#10
    +'     and Beginning >= "'+sDebut+'" and Beginning <= "'+sFin+'"'#13#10;
        Load( SQL, _slLoaded);
   end;
begin
     dmDatabase.Start_SQLLog;

     //Version_avec_sgbd_DateTimeSQL;
     Version_avec_TParams;
     Tri.Execute( _slLoaded);
     dmDatabase.Stop_SQLLog;
end;
procedure TpoolWork.Charge_Tag(_idTag: Integer; _slLoaded: TBatpro_StringList);
var
   SQL: String;
begin
     SQL
     :=
 'select                                          '#13#10
+'      Work.*                                    '#13#10
+'from                                            '#13#10
+'    Tag_Work                                    '#13#10
+'left join Work                                  '#13#10
+'on                                              '#13#10
+'      (Tag_Work.idTag  = '+IntToStr(_idTag)+')  '#13#10
+'  and (Tag_Work.idWork = Work.id             )  '#13#10
+'where                                           '#13#10
+'         Work.id is not null                    '#13#10
+'     and Tag_Work.id is not null                '#13#10;
     Load( SQL, _slLoaded);
end;

procedure TpoolWork.Tag_from_Description;
var
   I: TIterateur;
   bl: TblWork;
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
              ublTag.poolWork:= poolWork_Ancetre_Ancetre;
finalization
              Clean_destroy( FpoolWork);
end.
