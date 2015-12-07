unit ufExport_Genero_Report;

{$mode objfpc}{$H+}

interface

uses
 Classes, SysUtils, sqlite3conn, FileUtil, Forms, Controls, Graphics, Dialogs;

type

 { TfExport_Genero_Report }

 TfExport_Genero_Report
 =
  class( TForm)
   SQLite3Connection1: TSQLite3Connection;
  private
   { private declarations }
  public
   { public declarations }
  end;

var
   fExport_Genero_Report: TfExport_Genero_Report;

implementation

{$R *.lfm}

end.

