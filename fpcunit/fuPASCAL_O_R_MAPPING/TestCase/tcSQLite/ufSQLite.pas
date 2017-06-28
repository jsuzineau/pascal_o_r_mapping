unit ufSQLite;

{$mode delphi}

interface

uses
 Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, DBGrids,
 ExtCtrls, DbCtrls, StdCtrls, udmSQLite;

type

 { TfSQLite }

 TfSQLite = class(TForm)
  bCommit: TButton;
  bDescription: TButton;
  Button1: TButton;
  dbg: TDBGrid;
  dbm: TDBMemo;
  dbn: TDBNavigator;
  m: TMemo;
  Panel1: TPanel;
  rg: TRadioGroup;
  Splitter1: TSplitter;
  procedure bCommitClick(Sender: TObject);
  procedure bDescriptionClick(Sender: TObject);
  procedure Button1Click(Sender: TObject);
  procedure FormCreate(Sender: TObject);
  procedure FormDestroy(Sender: TObject);
  procedure rgClick(Sender: TObject);
 private
   dm: TdmSQLite;
 public

 end;

implementation

{$R *.lfm}

{ TfSQLite }

procedure TfSQLite.FormCreate(Sender: TObject);
begin
     dm:= TdmSQLite.Create( nil);
     dbg.DataSource:= dm.ds;
     dbm.DataSource:= dm.ds;
     dbn.DataSource:= dm.ds;
     dm.Ouvre;
end;

procedure TfSQLite.FormDestroy(Sender: TObject);
begin
     dm.Ferme;
     FreeAndNil(dm);
end;

procedure TfSQLite.bCommitClick(Sender: TObject);
begin
     dm.t.Commit;
end;

procedure TfSQLite.bDescriptionClick(Sender: TObject);
begin
     ShowMessage( dm.Description);
end;

procedure TfSQLite.Button1Click(Sender: TObject);
begin
     ShowMessage( dm.Field);
end;

procedure TfSQLite.rgClick(Sender: TObject);
begin
     case rg.ItemIndex
     of
       0: dm.sqldb;
       1: dm.sqlite3dataset;
       end;
end;

end.

