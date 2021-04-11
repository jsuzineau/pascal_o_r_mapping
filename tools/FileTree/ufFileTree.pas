unit ufFileTree;

{$mode objfpc}{$H+}

interface

uses
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
    procedure tv_addnode_from_key_value( _Key, _Value: String);
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
   procedure tv_from_slFiles;
   var
      i: Integer;
      Key, Value: String;
   begin
        for i:= 0 to slFiles.Count-1
        do
          begin
          Key  := slFiles.Names         [ i];
          Value:= slFiles.ValueFromIndex[ i];

          tv_addnode_from_key_value( Key, Value);
          end;
   end;
begin
     slFiles:= TStringList.Create;
     slFiles_from_ini_file;
     tv_from_slFiles;
end;

procedure TfFileTree.FormDestroy(Sender: TObject);
begin
     FreeAndNil( slFiles);
end;

//duplicated for convenience from uuStrings.pas
function StrToK( Key: String; var S: String): String;
var
   I: Integer;
begin
     I:= Pos( Key, S);
     if I = 0
     then
         begin
         Result:= S;
         S:= '';
         end
     else
         begin
         Result:= Copy( S, 1, I-1);
         Delete( S, 1, (I-1)+Length( Key));
         end;
end;

procedure TfFileTree.tv_addnode_from_key_value(_Key, _Value: String);
const
     Separator='\';
var
   sTreePath: String;
   procedure Recursif( Root: String; Parent: TTreeNode);
   var
      s: String;
      Node: TTreeNode;
   begin
        s:= StrTok( Separator, sTreePath);
        if sTreePath = ''
        then             //terminal case for recursion, add Value
            s:= s + ' ' + _Value;

        if nil = Parent
        then
            Node:= tv.Items.FindNodeWithText( s)
        else
            Node:= Parent.FindNode(s);
        if nil = Node
        then
            Node:= tv.Items.AddChild( Parent, s);

        if sTreePath = ''
        then //terminal case for recursion
            begin
            end
        else
            Recursif( sTreePath, Node);
   end;
begin
     sTreePath:= _Key;
     Recursif( '', nil);

end;

//duplicated for convenience from uuStrings.pas
{ Formate_Liste
Concatène les éléments de S en les séparant par la chaine Separateur
et retourne le résultat.
}
procedure Formate_Liste( var S: String; Separateur, Element: String); overload;
const sys_Vide=''; //duplicated for convenience from u_sys_.pas
begin
     if Element = sys_Vide then exit;

     if S <> sys_Vide
     then
         S:= S + Separateur;

     S:= S + Element;
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

