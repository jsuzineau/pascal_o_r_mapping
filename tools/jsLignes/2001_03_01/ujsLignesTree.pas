unit ujsLignesTree;

interface

uses
    SysUtils, ComCtrls,
    ujsLignes;

procedure Load_Tree( Tree:TTreeView; Repertoire: String);
procedure Free_Tree( Tree:TTreeView);

procedure Traite( Tree: TTreeView);

implementation

const
     file_BackSlash= '\';

procedure Backslashe( var Chemin: String);
begin
     if Chemin[Length(Chemin)]<> file_BackSlash then Chemin:= Chemin + file_BackSlash;
end;

procedure DeBackslashe( var Chemin: String);
begin
     if Chemin[Length(Chemin)]= file_BackSlash then Delete( Chemin, Length(Chemin), 1);
end;

procedure rLoad_Tree( Tree: TTreeNodes; Node: TTreeNode; Repertoire: String);
var
   SearchRec: TSearchRec;
   Found: Integer;
   Nom, NomMAJ, NomFichier: String;
   RepNode: TTreeNode;
   Ext: String;
   jsLignes: TjsLignes;
begin
     RepNode:= Tree.AddChild( Node, ExtractFileName(Repertoire));
     Backslashe( Repertoire);
     Found:= FindFirst( Repertoire+'*.*', faAnyFile, SearchRec);
     while Found = 0
     do
       begin
       Nom:= ExtractFileName(SearchRec.Name);
       NomMAJ:= UpperCase( Nom);
       Ext:= ExtractFileExt( NomMAJ);
       NomFichier:= Repertoire+Nom;
       if (NomMAJ <> '.') and (NomMAJ <> '..')
       then
           if SearchRec.Attr = faDirectory
           then
               rLoad_Tree( Tree, RepNode, NomFichier)
           else
               if (Ext = '.PAS') or (Ext = '.DPR') or (Ext = '.PP') or (Ext = '.INC') 
               then
                   begin
                   jsLignes:= TjsLignes.Create( NomFichier);
                   Tree.AddChildObject( RepNode, Nom, jsLignes);
                   end;
       Found := FindNext(SearchRec);
       end;
     FindClose(SearchRec);
end;

procedure Load_Tree( Tree:TTreeView; Repertoire: String);
var
   Racine: TTreeNode;
begin
     DeBackslashe( Repertoire);
     Racine:= Tree.Items.AddChild( nil, 'Racine');
     rLoad_Tree( Tree.Items, Racine, Repertoire);
end;

procedure Free_Tree( Tree:TTreeView);
var
   Liste: TTreeNodes;
   I: Integer;
   Child: TTreeNode;
   O: TObject;
begin
     Liste:= Tree.Items;
     with Liste
     do
       for I:= 0 to Liste.Count -1
       do
         begin
         Child:= Liste.Item[ I];
         if Assigned( Child)
         then
             begin
             O:= TObject(Child.Data);
             if Assigned( O)
             then
                 begin
                 O.Free;
                 Child.Data:= nil;
                 end;
             end;
       end;
     Liste.Clear;
end;

procedure Traite( Tree:TTreeView);
var
   Liste: TTreeNodes;
   I: Integer;
   Child: TTreeNode;
   O: TObject;
begin
     Liste:= Tree.Items;
     with Liste
     do
       for I:= 0 to Liste.Count -1
       do
         begin
         Child:= Liste.Item[ I];
         if Assigned( Child)
         then
             begin
             O:= TObject(Child.Data);
             if Assigned( O)
             then
                 if O is TjsLignes
                 then
                     Child.
                     (O as TjsLignes).Traite;
             end;
       end;
end;

end.
