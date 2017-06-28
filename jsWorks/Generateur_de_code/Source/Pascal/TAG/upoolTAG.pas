unit upoolTag;
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

  ublTag,

  udmDatabase,
  udmBatpro_DataModule,
  uPool,
  

  uhfTag,
  SysUtils, Classes, DB, SqlDB;

type
 TpoolTag
 =
  class( TPool)
    procedure DataModuleCreate(Sender: TObject);
  //Filtre
  public
    hfTag: ThfTag;
  //Accés général
  public
    function Get( _id: integer): TblTag;
  //Accés par clé
  protected
    procedure To_Params( _Params: TParams); override;
  public
      idType: Integer;
    Name: String;

      function Get_by_Cle( _idType: Integer;  _Name: String): TblTag;
      function Assure( _idType: Integer;  _Name: String): TblTag;
  //Indépendance par rapport au SGBD Informix ou MySQL
  protected
    function SQLWHERE_ContraintesChamps: String; override;
  //Méthode de création de test
  public
    function Test( _idType: Integer;  _Name: String):Integer;

  end;

function poolTag: TpoolTag;

implementation

{$R *.dfm}

var
   FpoolTag: TpoolTag;

function poolTag: TpoolTag;
begin
     Clean_Get( Result, FpoolTag, TpoolTag);
end;

{ TpoolTag }

procedure TpoolTag.DataModuleCreate(Sender: TObject);
begin
     NomTable:= 'Tag';
     Classe_Elements:= TblTag;
     Classe_Filtre:= ThfTag;

     inherited;

     hfTag:= hf as ThfTag;
end;

function TpoolTag.Get( _id: integer): TblTag;
begin
     Get_Interne_from_id( _id, Result);
end;

function TpoolTag.Get_by_Cle( _idType: Integer;  _Name: String): TblTag;
begin                               
     idType:=  _idType;
     Name:=  _Name;
     sCle:= TblTag.sCle_from_( idType, Name);
     Get_Interne( Result);       
end;                             


function TpoolTag.Assure( _idType: Integer;  _Name: String): TblTag;
begin                               
     Result:= Get_by_Cle(  _idType,  _Name);
     if Assigned( Result) then exit;

     Nouveau_Base( Result);                        
       Result.idType         := _idType       ;
       Result.Name           := _Name         ;
     Result.Save_to_database;
end;


procedure TpoolTag.To_Params( _Params: TParams);
begin
     inherited;
     with _Params
     do
       begin
       ParamByName( 'idType'    ).AsInteger:= idType;
       ParamByName( 'Name'    ).AsString:= Name;
       end;
end;

function TpoolTag.SQLWHERE_ContraintesChamps: String;
begin
     Result                                    
     :=                                        
       'where                        '#13#10+
       '         idType          = :idType         '#13#10+
       '     and Name            = :Name           ';
end;

function TpoolTag.Test( _idType: Integer;  _Name: String):Integer;
var                                                 
   bl: TblTag;                          
begin                                               
          Nouveau_Base( bl);                        
       bl.idType         := _idType       ;
       bl.Name           := _Name         ;
     bl.Save_to_database;                            
     Result:= bl.id;                                 
end;                                                 


initialization
              Clean_Create ( FpoolTag, TpoolTag);
finalization
              Clean_destroy( FpoolTag);
end.
