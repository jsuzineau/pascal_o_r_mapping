unit ufExport_Genero_Report;

{$mode objfpc}{$H+}

interface

uses
    uGenero_Report_XML, Classes, SysUtils, sqlite3conn, sqldb, FileUtil, Forms,
    Controls, Graphics, Dialogs, StdCtrls;

type

 { TfExport_Genero_Report }

 TfExport_Genero_Report
 =
  class( TForm)
   bTest: TButton;
   SQLite3Connection1: TSQLite3Connection;
   SQLTransaction1: TSQLTransaction;
   procedure bTestClick(Sender: TObject);
   procedure FormCreate(Sender: TObject);
   procedure FormDestroy(Sender: TObject);
  private
   grx: TGenero_Report_XML;
  end;

var
   fExport_Genero_Report: TfExport_Genero_Report;

implementation

{$R *.lfm}

{ TfExport_Genero_Report }

procedure TfExport_Genero_Report.FormCreate(Sender: TObject);
begin
     grx:= TGenero_Report_XML.Create;
end;

procedure TfExport_Genero_Report.FormDestroy(Sender: TObject);
begin
     FreeAndNil( grx);
end;

procedure TfExport_Genero_Report.bTestClick(Sender: TObject);
begin
     grx.Test;
end;

end.

