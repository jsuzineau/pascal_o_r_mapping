unit upoolPostgres_Foreign_Key;
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            http://www.mars42.com                                               |
                                                                                |
    Copyright 2019 Jean SUZINEAU - MARS42                                       |
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
  uDataUtilsU,
  uBatpro_StringList,

  ublPostgres_Foreign_Key,

  uPostgres,
  udmDatabase,
  udmBatpro_DataModule,
  uPool,
  

  uhfPostgres_Foreign_Key,
  SysUtils, Classes, DB, SqlDB;

type

 { TpoolPostgres_Foreign_Key }

 TpoolPostgres_Foreign_Key
 =
  class( TPool)
    procedure DataModuleCreate(Sender: TObject);  override;
  //Filtre
  public
    hfPostgres_Foreign_Key: ThfPostgres_Foreign_Key;
  //Chargement pour une table
  public
    procedure Charge_Table( _NomTable: String; _slLoaded: TBatpro_StringList);
  end;

function poolPostgres_Foreign_Key: TpoolPostgres_Foreign_Key;

implementation

var
   FpoolPostgres_Foreign_Key: TpoolPostgres_Foreign_Key;

function poolPostgres_Foreign_Key: TpoolPostgres_Foreign_Key;
begin
     TPool.class_Get( Result, FpoolPostgres_Foreign_Key, TpoolPostgres_Foreign_Key);
end;

{ TpoolPostgres_Foreign_Key }

procedure TpoolPostgres_Foreign_Key.DataModuleCreate(Sender: TObject);
begin
     NomTable:= 'Postgres_Foreign_Key';
     Classe_Elements:= TblPostgres_Foreign_Key;
     Classe_Filtre:= ThfPostgres_Foreign_Key;

     inherited;
     Pas_de_champ_id:= True;
     hfPostgres_Foreign_Key:= hf as ThfPostgres_Foreign_Key;
end;

procedure TpoolPostgres_Foreign_Key.Charge_Table( _NomTable: String; _slLoaded: TBatpro_StringList);
var
   SQL: String;
   P: TParams;
   pNomTable  : TParam;
   pSchemaName: TParam;
begin
         SQL
         :=
  'SELECT                                           '#13#10
 +'      conrelid::regclass AS NomTable,            '#13#10
 +'      conname as "Constraint",                   '#13#10
 +'      pg_get_constraintdef(c.oid) as "Definition"'#13#10
 +'FROM                                             '#13#10
 +'    pg_constraint c                              '#13#10
 +'JOIN                                             '#13#10
 +'    pg_namespace n                               '#13#10
 +'    ON                                           '#13#10
 +'      n.oid = c.connamespace                     '#13#10
 +'WHERE                                            '#13#10
 +'         contype IN (''f'')                      '#13#10
 +'     and conrelid::regclass::text=:NomTable      '#13#10
 +'AND                                              '#13#10
 +'   n.nspname = :SchemaName                       '#13#10
 +'ORDER  BY                                        '#13#10
 +'       conrelid::regclass::text,                 '#13#10
 +'       contype DESC;                             '#13#10;
     P:= TParams.Create;
     try
        pNomTable  := CreeParam( P, 'NomTable'  );pNomTable  .AsString:= _NomTable;
        pSchemaName:= CreeParam( P, 'SchemaName');pSchemaName.AsString:= (Connection as TPostgres).SchemaName;
        Load( SQL, _slLoaded, nil, P);
     finally
            FreeAndNil( P);
            end;
end;


initialization
finalization
              TPool.class_Destroy( FpoolPostgres_Foreign_Key);
end.
