unit udmx;
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            partly as freelance: http://www.mars42.com                          |
        and partly as employee : http://www.adinfo.com                          |
                                 http://www.adi-bat.com                         |
    Copyright 2017 Jean SUZINEAU - MARS42                                       |
    Copyright 2017 GROUPE ADINFO SOFTWARE                                       |
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
    udmBatpro_DataModule,
    uBatpro_Element,
    uBatpro_Ligne,
    uhRequete,
  SysUtils, Classes,
  DBTables, Db, FMTBcd, Provider,
  DBClient, SqlExpr, ucBatproVerifieur, ucbvQuery_Datasource;

type
 Tdmx
 =
  class(TdmBatpro_DataModule)
    ds: TDataSource;
    bvqd: TbvQuery_Datasource;
    sqlq: TSQLQuery;
    cd: TClientDataSet;
    p: TDataSetProvider;
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
    Classe_Handler: ThRequete_Class;
    Classe_Elements: TBatpro_Ligne_Class;
    hr: ThRequete;
    procedure Assure_sqlq_Datasource( Defaut: TDatasource);
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    function Cherche( sCle: String): TBatpro_Ligne;
    procedure Avant_OnCreate;
    procedure Apres_OnCreate;
    procedure Avant_OnDestroy;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Cree_hr;
  end;

implementation

uses
    udmDatabase, uDataUtilsU, uVide, uClean;

{$R *.fmx}

procedure Tdmx.Assure_sqlq_Datasource( Defaut: TDatasource);
begin
     Assure_Datasource( sqlq, Defaut);
end;

procedure Tdmx.Avant_OnCreate;
begin
     Classe_Handler := nil;
     Classe_Elements:= nil;
     hr:= nil;
end;

procedure Tdmx.Cree_hr;
begin
     if Assigned( Classe_Handler) and (hr = nil)
     then
         hr:= Classe_Handler.Create( cd, ds, Classe_Elements);
end;

procedure Tdmx.Apres_OnCreate;
begin
     Cree_hr;
end;

procedure Tdmx.Avant_OnDestroy;
begin
     Free_nil( hr);
end;

constructor Tdmx.Create(AOwner: TComponent);
begin
     Avant_OnCreate;
     inherited;
     if OldCreateOrder
     then
         Apres_OnCreate;
end;

procedure Tdmx.AfterConstruction;
begin
     inherited;
     if not OldCreateOrder
     then
         Apres_OnCreate;
end;

procedure Tdmx.BeforeDestruction;
begin
     if not OldCreateOrder
     then
         Avant_OnDestroy;
     inherited;
end;

destructor Tdmx.Destroy;
begin
     if OldCreateOrder
     then
         Avant_OnDestroy;
     inherited;
end;

function Tdmx.Cherche( sCle: String): TBatpro_Ligne;
begin
     Result:= nil;

     if hr = nil then exit;

     Result:= hr.Cherche( sCle);
end;

end.
