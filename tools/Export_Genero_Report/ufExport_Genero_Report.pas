unit ufExport_Genero_Report;

{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            partly as freelance: http://www.mars42.com                          |
        and partly as employee : http://www.batpro.com                          |
    Contact: gilles.doutre@batpro.com                                           |
                                                                                |
    Copyright 2015 Jean SUZINEAU - MARS42                                       |
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
{$mode objfpc}{$H+}

interface

uses
    uGenero_Report_from_Dataset,
    uGenero_Report_from_ODRE_Table,
    Classes, SysUtils, sqlite3conn, sqldb, FileUtil, Forms,
    Controls, Graphics, Dialogs, StdCtrls;

type

 { TfExport_Genero_Report }

 TfExport_Genero_Report
 =
  class( TForm)
   bGenero_Report_from_Dataset: TButton;
   bGenero_Report_from_ODRE_Table: TButton;
   procedure bGenero_Report_from_DatasetClick(Sender: TObject);
   procedure bGenero_Report_from_ODRE_TableClick(Sender: TObject);
   procedure FormCreate(Sender: TObject);
   procedure FormDestroy(Sender: TObject);
  private
  end;

var
   fExport_Genero_Report: TfExport_Genero_Report;

implementation

{$R *.lfm}

{ TfExport_Genero_Report }

procedure TfExport_Genero_Report.FormCreate(Sender: TObject);
begin
end;

procedure TfExport_Genero_Report.FormDestroy(Sender: TObject);
begin
end;

procedure TfExport_Genero_Report.bGenero_Report_from_DatasetClick(Sender: TObject);
var
   gr: TGenero_Report_from_Dataset;
begin
     gr:= TGenero_Report_from_Dataset.Create;
     try
        gr.Test;
     finally
            FreeAndNil( gr);
            end;
end;

procedure TfExport_Genero_Report.bGenero_Report_from_ODRE_TableClick(  Sender: TObject);
var
   gr: TGenero_Report_from_ODRE_Table;
begin
     gr:= TGenero_Report_from_ODRE_Table.Create;
     try
        gr.Test;
     finally
            FreeAndNil( gr);
            end;
end;

end.

