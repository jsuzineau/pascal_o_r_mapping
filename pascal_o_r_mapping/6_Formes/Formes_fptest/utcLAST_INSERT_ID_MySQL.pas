unit utcLAST_INSERT_ID_MySQL;
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
  SysUtils, Classes, SQLDB,
  TestFrameWork,
  uDataUtilsF,
  udmxLAST_INSERT_ID_MySQL,
  udmDatabase;

type
  TtcLAST_INSERT_ID_MySQL = class(TTestCase)
  private

  protected

//    procedure SetUp; override;
//    procedure TearDown; override;

  published

    // Test methods
    procedure TestValeur;

  end;

implementation

{ TtcLAST_INSERT_ID_MySQL }

procedure TtcLAST_INSERT_ID_MySQL.TestValeur;
var
   sqlq: TSQLQuery;
   last_insert_id: Integer;
begin
     sqlq:= TSQLQuery.Create( nil);
     try
        sqlq.Database:= dmDatabase.sqlc;
        sqlq.sql.Text:= 'insert into p_plp () values ()';
        ExecSQLQuery( sqlq);
        last_insert_id:= dmxLAST_INSERT_ID_MySQL.Valeur;
        Check( (last_insert_id > 0),
               'Echec: LAST_INSERT_ID obtenu:'+IntToStr(last_insert_id));
     finally
            FreeAndNil( sqlq);
            end;
end;

initialization

  TestFramework.RegisterTest('utcLAST_INSERT_ID_MySQL Suite',
    TtcLAST_INSERT_ID_MySQL.Suite);

end.
