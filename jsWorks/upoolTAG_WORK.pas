unit upoolTAG_WORK;
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
  uBatpro_StringList,
{implementation_uses_key}

  ublTAG_WORK,

  udmDatabase,
  udmBatpro_DataModule,
  uPool,
  

  uhfTAG_WORK,
  SysUtils, Classes, DB, SqlDB;

type

 { TpoolTAG_WORK }

 TpoolTAG_WORK
 =
  class( TPool)
    procedure DataModuleCreate(Sender: TObject);
  //Filtre
  public
    hfTAG_WORK: ThfTAG_WORK;
  //Accés général
  public
    function Get( _id: integer): TblTag_Work;
  //Accés par clé
  public
     idTag: Integer;
    idWork: Integer;
    function Get_by_Cle( _idTag: Integer;  _idWork: Integer): TblTag_Work;
    function Assure( _idTag: Integer;  _idWork: Integer): TblTag_Work;
  //Méthode de création de test
  public
    function Test( _id: Integer;  _idTag: Integer;  _idWork: Integer):Integer;

  end;

function poolTAG_WORK: TpoolTAG_WORK;

implementation

{$R *.dfm}

var
   FpoolTAG_WORK: TpoolTAG_WORK;

function poolTAG_WORK: TpoolTAG_WORK;
begin
     Clean_Get( Result, FpoolTAG_WORK, TpoolTAG_WORK);
end;

{ TpoolTAG_WORK }

procedure TpoolTAG_WORK.DataModuleCreate(Sender: TObject);
begin
     NomTable:= 'Tag_Work';
     Classe_Elements:= TblTag_Work;
     Classe_Filtre:= ThfTAG_WORK;

     inherited;

     hfTAG_WORK:= hf as ThfTAG_WORK;
end;

function TpoolTAG_WORK.Get( _id: integer): TblTag_Work;
begin
     Get_Interne_from_id( _id, Result);
end;

function TpoolTAG_WORK.Get_by_Cle(_idTag: Integer; _idWork: Integer
 ): TblTag_Work;
begin
     idTag:=  _idTag;
     idWork:=  _idWork;
     sCle:= TblTag_Work.sCle_from_( idTag, idWork);
     Get_Interne( Result);
end;

function TpoolTAG_WORK.Assure( _idTag: Integer; _idWork: Integer): TblTag_Work;
begin
     try
        Creer_si_non_trouve:= True;
        Result:= Get_by_Cle( _idTag, _idWork);
     finally
            Creer_si_non_trouve:= False;
            end;
end;

function TpoolTAG_WORK.Test( _id: Integer;  _idTag: Integer;  _idWork: Integer):Integer;
var                                                 
   bl: TblTag_Work;
begin                                               
          Nouveau_Base( bl);                        
       bl.id             := _id           ;
       bl.idTag          := _idTag        ;
       bl.idWork         := _idWork       ;
     bl.Save_to_database;                            
     Result:= bl.id;                                 
end;                                                 


initialization
              Clean_Create ( FpoolTAG_WORK, TpoolTAG_WORK);
finalization
              Clean_destroy( FpoolTAG_WORK);
end.
