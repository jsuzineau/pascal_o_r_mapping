unit ufFileTree;

{$mode objfpc}{$H+}

interface

uses
    uFileTree,
 Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, ComCtrls,
 StdCtrls, IniFiles;

type

 { TfFileTree }

 TfFileTree
 =
  class(TForm)
   bGetSelection: TButton;
   l: TLabel;
   m: TMemo;
    Panel1: TPanel;
    Panel2: TPanel;
    Splitter1: TSplitter;
    tv: TTreeView;
    procedure bGetSelectionClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    slFiles: TStringList;
  public
    function Get_Selected: String;
  end;

var
 fFileTree: TfFileTree;

implementation

{$R *.lfm}

{ TfFileTree }

procedure TfFileTree.FormCreate(Sender: TObject);
   procedure slFiles_from_ini_file;
   var
      ini: TINIFile;
   begin
        ini:= TINIFile.Create( 'FileTree.ini');
        try
           ini.ReadSectionRaw( 'Files', slFiles);
        finally
               FreeAndNil( ini);
               end;
   end;
begin
     slFiles:= TStringList.Create;
     slFiles_from_ini_file;
     TreeView_from_slFiles( tv, slFiles);
end;

procedure TfFileTree.FormDestroy(Sender: TObject);
begin
     FreeAndNil( slFiles);
end;

function TfFileTree.Get_Selected: String;
var
   I: Integer;
begin
     Result:= '';
     for i:=0 to tv.SelectionCount-1
     do
       Formate_Liste( Result, #13#10, tv.Selections[i].GetTextPath);
end;

procedure TfFileTree.bGetSelectionClick(Sender: TObject);
begin
     m.Lines.Text:= Get_Selected;
end;

end.

