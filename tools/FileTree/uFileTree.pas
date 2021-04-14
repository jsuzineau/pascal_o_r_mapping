unit uFileTree;

{$mode objfpc}{$H+}

interface

uses
 Classes, SysUtils,ComCtrls;

//duplicated for convenience from uuStrings.pas
function StrToK( Key: String; var S: String): String;

//duplicated for convenience from uuStrings.pas
{ Formate_Liste
Concatène les éléments de S en les séparant par la chaine Separateur
et retourne le résultat.
}
procedure Formate_Liste( var S: String; Separateur, Element: String); overload;

procedure TreeView_from_slFiles( _TreeView: TTreeView; _slFiles: TStringList);

implementation

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


procedure TreeView_addnode_from_key_value( _TreeView: TTreeView; _Key, _Value: String);
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
            Node:= _TreeView.Items.FindNodeWithText( s)
        else
            Node:= Parent.FindNode(s);
        if nil = Node
        then
            Node:= _TreeView.Items.AddChild( Parent, s);

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

procedure TreeView_from_slFiles( _TreeView: TTreeView; _slFiles: TStringList);
var
   i: Integer;
   Key, Value: String;
begin
     for i:= 0 to _slFiles.Count-1
     do
       begin
       Key  := _slFiles.Names         [ i];
       Value:= _slFiles.ValueFromIndex[ i];

       TreeView_addnode_from_key_value( _TreeView, Key, Value);
       end;
end;

end.

