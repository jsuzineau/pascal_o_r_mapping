unit udmxLAST_INSERT_ID_MySQL;
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
  uDataUtilsF,

  udmDatabase,
  udmBatpro_DataModule,
  udmx,

  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, FMTBcd, BufDataset, DB, SQLDB, mysql51conn,
  ucBatproVerifieur,
  ucbvQuery_Datasource;

type

 { TdmxLAST_INSERT_ID_MySQL }

 TdmxLAST_INSERT_ID_MySQL
 =
  class( TdmBatpro_DataModule)
    sqlq: TSQLQuery;
    sqlqValeur: TLargeintField;
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
    function Valeur( SQLConnection: TDatabase = nil): Integer;
  end;

function dmxLAST_INSERT_ID_MySQL: TdmxLAST_INSERT_ID_MySQL;

implementation

{$R *.lfm}

var
   FdmxLAST_INSERT_ID_MySQL: TdmxLAST_INSERT_ID_MySQL;

function dmxLAST_INSERT_ID_MySQL: TdmxLAST_INSERT_ID_MySQL;
begin
     Clean_Get( Result, FdmxLAST_INSERT_ID_MySQL, TdmxLAST_INSERT_ID_MySQL);
end;

{ TdmxLAST_INSERT_ID_MySQL }

function TdmxLAST_INSERT_ID_MySQL.Valeur( SQLConnection: TDatabase = nil): Integer;
begin
     if SQLConnection = nil
     then
         SQLConnection:= dmDatabase.sqlc;

     sqlq.Close;
     sqlq.DataBase:= SQLConnection;

     Result:= -1;
     if RefreshQuery( sqlq)
     then
         begin
         sqlq.First;
         Result:= sqlqValeur.AsInteger;
         sqlq.Close;
         end;
end;

initialization
              Clean_CreateD( FdmxLAST_INSERT_ID_MySQL, TdmxLAST_INSERT_ID_MySQL);
finalization
              Clean_Destroy( FdmxLAST_INSERT_ID_MySQL);
end.
CREATE OR REPLACE FUNCTION g_ppl_srl()
  RETURNS "trigger" AS
$BODY$
declare  ls bigint;
rc integer;
begin
if new.id isnull or new.id=0
then
    select into ls nextval('G_PPL_SEQ');
    get diagnostics rc=row_count;
    if rc=1
    then
        new.id:=ls;
    else
        new.id:=1;
        perform setval('G_PPL',new.id);
    end if;
else
    select into ls nextval('G_PPL_SEQ');
    if new.id>=ls
    then
        perform setval('G_PPL_SEQ',new.id);
    else
        select into ls nextval('G_PPL_SEQ');
        get diagnostics rc=row_count;
        if rc=1
        then
            new.id:=ls;
        else
            new.id:=1;
            perform setval('G_PPL_SEQ',new.id);
        end if;
    end if;
end if;
return new;
end;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION g_ppl_srl() OWNER TO postgres;

