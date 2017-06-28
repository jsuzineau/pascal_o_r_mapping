unit udmSQLite;

{$mode delphi}

interface

uses
    uuStrings,
 Classes, SysUtils, sqlite3conn, sqldb, db, Sqlite3DS, FileUtil, Forms,
 Controls, Graphics, Dialogs,strutils;

type

    { TSQLite3Connection_custom }

    TSQLite3Connection_custom
    =
     class( TSQLite3Connection)
     public
       function stringsquery(const asql: string): TArrayStringArray;
     end;

 { TdmSQLite }

 TdmSQLite = class(TForm)
  c: TSQLite3Connection;
  ds: TDataSource;
  sqlds: TSqlite3Dataset;
  sqldsBeginning: TDateTimeField;
  sqldsDescription: TStringField;
  sqldsEnd: TDateTimeField;
  sqldsid: TAutoIncField;
  sqldsnProject: TLongintField;
  sqldsnUser: TLongintField;
  sqlq: TSQLQuery;
  sqlqBeginning: TDateTimeField;
  sqlqDescription: TStringField;
  sqlqEnd: TDateTimeField;
  sqlqid: TLongintField;
  sqlqnProject: TLongintField;
  sqlqnUser: TLongintField;
  sqlqOld: TSQLQuery;
  sqlqOldid: TLongintField;
  sqlqOlds: TMemoField;
  t: TSQLTransaction;
  procedure FormCreate(Sender: TObject);
  procedure FormDestroy(Sender: TObject);
 private
   is_sqldb: Boolean;
   cc: TSQLite3Connection_custom;
 public
   procedure Ouvre;
   procedure Ferme;
   procedure sqldb;
   procedure sqlite3dataset;
   function Description: String;
   function Field: String;
 end;

implementation

{$R *.lfm}

{ TSQLite3Connection_custom }

function TSQLite3Connection_custom.stringsquery( const asql: string): TArrayStringArray;
begin
     Result:= inherited stringsquery( asql);
end;

{ TdmSQLite }

procedure TdmSQLite.FormCreate(Sender: TObject);
begin
     is_sqldb:= False;
     cc:= TSQLite3Connection_custom.Create(nil);
     cc.DatabaseName:= c.DatabaseName;
end;

procedure TdmSQLite.FormDestroy(Sender: TObject);
begin
     FreeAndNil(cc);
end;

procedure TdmSQLite.Ouvre;
begin
     c.Open;
     cc.Open;
     sqlq.Open;
     sqlds.Open;
end;

procedure TdmSQLite.Ferme;
begin
     sqlq.Close;
     c.Close;
     cc.Close;
     sqlds.Close;
end;

procedure TdmSQLite.sqldb;
begin
     Ferme;
     ds.DataSet:= sqlq;
     is_sqldb:= True;
     Ouvre;
end;

procedure TdmSQLite.sqlite3dataset;
begin
     Ferme;
     ds.DataSet:= sqlds;
     is_sqldb:= False;
     Ouvre;
end;

function TdmSQLite.Description: String;
begin
     Result:= IfThen( is_sqldb, sqlqDescription.AsString, sqldsDescription.AsString);
end;

function TdmSQLite.Field: String;
begin
     Result:= IfThen( is_sqldb, sqlq.Fields[4].AsString, sqlds.Fields[4].AsString);
end;

end.

