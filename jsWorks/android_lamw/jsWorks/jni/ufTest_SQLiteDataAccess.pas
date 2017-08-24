{Hint: save all files to location: \jni }
unit ufTest_SQLiteDataAccess;

{$mode delphi}

interface

uses
    uLog,
    uAndroid_Database,
 Classes, SysUtils, Laz_And_Controls, AndroidWidget;
 
type

	{ TfTest_SQLiteDataAccess }

 TfTest_SQLiteDataAccess
 =
		 class(jForm)
				bOuvrir: jButton;
				bState: jButton;
				bWork: jButton;
				sc: jSqliteCursor;
				sda: jSqliteDataAccess;
				tw: jTextView;
				procedure fTest_SQLiteDataAccessJNIPrompt(Sender: TObject);
				procedure bOuvrirClick(Sender: TObject);
				procedure bStateClick(Sender: TObject);
				procedure bWorkClick(Sender: TObject);
		 private
		 public
    procedure Exec_query( _SQL: String);
    procedure Show_tables;
    procedure Dump_LastWork;
		 end;

function fTest_SQLiteDataAccess: TfTest_SQLiteDataAccess;

implementation
 
{$R *.lfm}

var
   FfTest_SQLiteDataAccess: TfTest_SQLiteDataAccess= nil;

function fTest_SQLiteDataAccess: TfTest_SQLiteDataAccess;
begin
     if nil = FfTest_SQLiteDataAccess
     then
         begin
         gApp.CreateForm( TfTest_SQLiteDataAccess, FfTest_SQLiteDataAccess);
         FfTest_SQLiteDataAccess.Init( gApp);
         end;
     Result:= FfTest_SQLiteDataAccess;
end;


{ TfTest_SQLiteDataAccess }

procedure TfTest_SQLiteDataAccess.fTest_SQLiteDataAccessJNIPrompt( Sender: TObject);
begin
     sda.DataBaseName:= Filename;
end;

procedure TfTest_SQLiteDataAccess.Exec_query(_SQL: String);
var
   sl: TStringList;
begin
     WriteLn( ClassName+'.Exec_query: début _SQL=',_SQL,', Filename=', Filename);
     sl:= TStringList.Create;
     sl.StrictDelimiter:= True;
     sl.Delimiter:= sda.RowDelimiter;
     sda.OpenOrCreate( Filename);
     sl.DelimitedText:= sda.Select(_SQL);
     sda.Close;
     tw.Text:= _SQL+#13#10+sl.Text;
     sl.Free;
end;

procedure TfTest_SQLiteDataAccess.Show_tables;
begin
     Exec_query( 'SELECT name FROM sqlite_master WHERE type=''table''');
end;

procedure TfTest_SQLiteDataAccess.Dump_LastWork;
begin
     (*
     sda.OpenOrCreate( Filename);
     sda.InsertIntoTable( 'insert into Work(id) values (0)');
     sda.Close;
     *)
     Exec_query( 'SELECT * FROM Work order by id desc limit 1');
     Show;
end;

procedure TfTest_SQLiteDataAccess.bOuvrirClick(Sender: TObject);
begin
     sda.OpenOrCreate(sda.DataBaseName);
     Show_tables;
end;

procedure TfTest_SQLiteDataAccess.bStateClick(Sender: TObject);
begin
     Exec_query( 'SELECT * FROM State');
end;

procedure TfTest_SQLiteDataAccess.bWorkClick(Sender: TObject);
begin
     Dump_LastWork;
end;

end.
