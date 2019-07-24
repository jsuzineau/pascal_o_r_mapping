unit utcOD_SpreadsheetManager;
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            partly as freelance: http://www.mars42.com                          |
        and partly as employee : http://www.batpro.com                          |
    Contact: gilles.doutre@batpro.com                                           |
                                                                                |
    Copyright 2011,2012,2014 Jean SUZINEAU - MARS42                             |
    Copyright 2011,2012,2014 Cabinet Gilles DOUTRE - BATPRO                     |
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
  uOD_SpreadsheetManager,
  uOD_Dataset_Columns,
  uOD_Styles,
  uODRE_Table,
  utcOD_TestCase,
  TestFrameWork,
  SysUtils, Classes, BufDataset;

type
 TtcOD_SpreadsheetManager
 =
  class( TtcOD_TestCase)
  // Test methods
  published
    //procedure TestCURRENCYFromStr;
    //procedure TestName_Cell;
    procedure TestInsert_Table;
    procedure TestInsert_Table_with_format;
  end;

implementation

{ TtcOD_SpreadsheetManager }

procedure TtcOD_SpreadsheetManager.TestInsert_Table;
var
   OD_SpreadsheetManager: TOD_SpreadsheetManager;
   cd1: TBufDataSet;
   ODRE_Table: TODRE_Table;
   OD_Styles1: TOD_Styles;
   OD_Dataset_Columns, OD_Dataset_Columns1: TOD_Dataset_Columns;
begin
     cd := TBufDataSet.Create( nil);
     cd1:= TBufDataSet.Create( nil);
     ODRE_Table:= TODRE_Table.Create( 'table');
     OD_Dataset_Columns := ODRE_Table.AddDataset( cd );
     OD_Dataset_Columns1:= ODRE_Table.AddDataset( cd1);
     OD_Styles1:= TOD_Styles.Create( '1,2,3,4,5,currency,date');
     OD_Dataset_Columns1.OD_Styles:= OD_Styles1;
     ODRE_Table.OD_Merge   := OD_Merge;

     try
        Cree_dataset( 5);
        Cree_dataset_interne( cd1, 'cd1', 5);
        try
           OD_SpreadsheetManager:= TOD_SpreadsheetManager.Create('OD.ots');

           OD_SpreadsheetManager.Insert_Table( 0, ODRE_Table);

           OD_SpreadsheetManager.Ferme;

        finally
               FreeAndNil( OD_SpreadsheetManager);
               end;
     finally
            Detruit_Dataset;
            FreeAndNil( cd1);
            end;
end;

procedure TtcOD_SpreadsheetManager.TestInsert_Table_with_format;
var
   OD_SpreadsheetManager: TOD_SpreadsheetManager;
   cd1: TBufDataSet;
   ODRE_Table: TODRE_Table;
   OD_Styles1: TOD_Styles;
   OD_Dataset_Columns, OD_Dataset_Columns1: TOD_Dataset_Columns;
begin
     cd := TBufDataSet.Create( nil);
     cd1:= TBufDataSet.Create( nil);
     ODRE_Table:= TODRE_Table.Create( 'table');
     OD_Dataset_Columns := ODRE_Table.AddDataset( cd );
     OD_Dataset_Columns1:= ODRE_Table.AddDataset( cd1);
     OD_Styles1:= TOD_Styles.Create( '1,2,3,4,5,currency,date');
     OD_Dataset_Columns1.OD_Styles:= OD_Styles1;
     ODRE_Table.OD_Merge   := OD_Merge;

     ODRE_Table.AddColumn( 1, 'Column 0');
     ODRE_Table.AddColumn( 1, 'Column 1');

     try
        Cree_dataset( 5);
        Cree_dataset_interne( cd1, 'cd1', 5);
        try
           OD_SpreadsheetManager:= TOD_SpreadsheetManager.Create('OD.ots');

           OD_Dataset_Columns .Column_Avant( 'cd_Numero', 0, 0);
           OD_Dataset_Columns .Column_Avant( 'cd_Code'  , 1, 1);
           OD_Dataset_Columns1.Column_Avant( 'cd1_Colonne3', 0, 0);
           OD_Dataset_Columns1.Column_Avant( 'cd1_Colonne4'  , 1, 1);

           OD_SpreadsheetManager.Insert_Table_with_format( 0, ODRE_Table);
           OD_SpreadsheetManager.Ferme;
        finally
               FreeAndNil( OD_SpreadsheetManager);
               end;
     finally
            Detruit_Dataset;
            FreeAndNil( cd1);
            end;
end;

initialization
  TestFramework.RegisterTest('utcOD_SpreadsheetManager Suite',
    TtcOD_SpreadsheetManager.Suite);

end.
