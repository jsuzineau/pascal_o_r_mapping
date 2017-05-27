{Hint: save all files to location: C:\_freepascal\pascal_o_r_mapping\jsWorks\android_lamw\jsWorks\jni }
unit uamjsWorks;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, And_jni_Bridge, Laz_And_Controls, AndroidWidget,
		gridview;

type

  { TamjsWorks }

  TamjsWorks = class(jForm)
    bOuvrir: jButton;
    bState: jButton;
				tw: jTextView;
    sc: jSqliteCursor;
    sda: jSqliteDataAccess;
    procedure amjsWorksCreate(Sender: TObject);
    procedure amjsWorksJNIPrompt(Sender: TObject);
    procedure bOuvrirClick(Sender: TObject);
    procedure bStateClick(Sender: TObject);
  private
    procedure Exec_query( _SQL: String);
    procedure Show_tables;
  end;

var
  amjsWorks: TamjsWorks;

implementation
  
{$R *.lfm}
  

{ TamjsWorks }

procedure TamjsWorks.amjsWorksCreate(Sender: TObject);
begin

end;

procedure TamjsWorks.amjsWorksJNIPrompt(Sender: TObject);
var
   Filename: String;
   EnvironmentDirPath:String;
begin
     Filename:= 'jsWorks.sqlite';
     EnvironmentDirPath:= GetEnvironmentDirectoryPath(dirDatabase);
     tw.Text:= ClassName+'.amjsWorksJNIPrompt: Avant CopyFromAssetsToEnvironmentDir('+Filename+', '+EnvironmentDirPath+');';
     CopyFromAssetsToEnvironmentDir(Filename, EnvironmentDirPath);
     sda.DataBaseName:= Filename;
end;

procedure TamjsWorks.bOuvrirClick(Sender: TObject);
begin
     sda.OpenOrCreate(sda.DataBaseName);
     Show_tables;
end;

procedure TamjsWorks.Exec_query(_SQL: String);
var
   sl: TStringList;
   i: integer;
begin
     sl:= TStringList.Create;
     sl.StrictDelimiter:= True;
     sl.Delimiter:= sda.RowDelimiter;
     sl.DelimitedText:= sda.Select(_SQL);
     tw.Text:= sl.Text;
     sl.Free;
end;

procedure TamjsWorks.bStateClick(Sender: TObject);
begin
     Exec_query( 'SELECT * FROM State');
end;

procedure TamjsWorks.Show_tables;
begin
     Exec_query( 'SELECT name FROM sqlite_master WHERE type=''table''');
end;

end.
