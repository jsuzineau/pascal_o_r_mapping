unit upoolCategorie;
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

  ublCategorie,

  udmDatabase,
  udmBatpro_DataModule,
  uPool,
  

  uhfCategorie,
  SysUtils, Classes, DB, SqlDB;

type
 TpoolCategorie
 =
  class( TPool)
    procedure DataModuleCreate(Sender: TObject);
  //Filtre
  public
    hfCategorie: ThfCategorie;
  //Accés général
  public
    function Get( _id: integer): TblCategorie;
  //Accés par clé
  protected
    procedure To_SQLQuery_Params( SQLQuery: TSQLQuery); override;
  public
  
  
  
  //Indépendance par rapport au SGBD Informix ou MySQL
  protected
    function SQLWHERE_ContraintesChamps: String; override;
  //Méthode de création de test
  public
    function Test( _Symbol: String;  _Description: String):Integer;

  end;

function poolCategorie: TpoolCategorie;

implementation

{$R *.dfm}

var
   FpoolCategorie: TpoolCategorie;

function poolCategorie: TpoolCategorie;
begin
     Clean_Get( Result, FpoolCategorie, TpoolCategorie);
end;

{ TpoolCategorie }

procedure TpoolCategorie.DataModuleCreate(Sender: TObject);
begin
     NomTable:= 'Categorie';
     Classe_Elements:= TblCategorie;
     Classe_Filtre:= ThfCategorie;

     inherited;

     hfCategorie:= hf as ThfCategorie;
end;

function TpoolCategorie.Get( _id: integer): TblCategorie;
begin
     Get_Interne_from_id( _id, Result);
end;





procedure TpoolCategorie.To_SQLQuery_Params(SQLQuery: TSQLQuery);
begin
     inherited;
     with SQLQuery.Params
     do
       begin
       ParamByName( 'Symbol'    ).AsString:= Symbol;
       ParamByName( 'Description'    ).AsString:= Description;
       end;
end;

function TpoolCategorie.SQLWHERE_ContraintesChamps: String;
begin
     Result                                    
     :=                                        
       'where                        '#13#10+
       '         Symbol          = :Symbol         '#13#10+
       '     and Description     = :Description    ';
end;

function TpoolCategorie.Test( _Symbol: String;  _Description: String):Integer;
var                                                 
   bl: TblCategorie;                          
begin                                               
          Nouveau_Base( bl);                        
       bl.Symbol         := _Symbol       ;
       bl.Description    := _Description  ;
     bl.Save_to_database;                            
     Result:= bl.id;                                 
end;                                                 


initialization
              Clean_Create ( FpoolCategorie, TpoolCategorie);
finalization
              Clean_destroy( FpoolCategorie);
end.
