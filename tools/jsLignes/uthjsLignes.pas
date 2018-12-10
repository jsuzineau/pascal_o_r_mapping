unit uthjsLignes;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
    Classes, ComCtrls;

type
    TthjsLignes
    =
     class(TThread)
     public
       constructor Create(aRootPath: String; _Exclus: String);
       destructor Destroy; override;
     protected
       RootPath: String;
       Node, NewNode: TTreeNode;
       Libelle: String;
       Exclus: TStringList;
       procedure Execute; override;
       function TraiteRepertoire(Parent: TTreeNode; Path: String): Int64;
       procedure PrepareLibelle(Taille: Int64; NomFichier: String; Exclu: Boolean);
       procedure DoAddNode;
       procedure DoChangeNodeText;
     end;

var
   thjsLignes: TthjsLignes;
   //FinLigne: PChar= #13#10;
   FinLigne: PChar= LineEnding;
   NbLignes_Pages: Integer= 150;

implementation

uses
    ufjsLignes, SysUtils;
{ Important : les méthodes et les propriétés des objets dans la VCL ne peuvent
  être utilisées que dans une méthode appelée en utilisant Synchronize, par exemple :

      Synchronize(UpdateCaption);

  où UpdateCaption pourrait être du type :

    procedure thjsLignes.UpdateCaption;
    begin
      Form1.Caption := 'Mise à jour dans un thread';
    end; }

{ thjsLignes }

constructor TthjsLignes.Create( aRootPath: String; _Exclus: String);
begin
     RootPath:= aRootPath;
     Exclus:= TStringList.Create;
     Exclus.Text:= _Exclus;
     inherited Create( False);
end;

destructor TthjsLignes.Destroy;
begin
     Exclus.Free;
     inherited;
end;

procedure TthjsLignes.DoAddNode;
begin
     NewNode:= fjsLignes.Tree.Items.AddChild( Node, Libelle);
end;

procedure TthjsLignes.DoChangeNodeText;
begin
     Node.Text:= Libelle;
end;

procedure TthjsLignes.PrepareLibelle(Taille: Int64; NomFichier: String; Exclu: Boolean);
var
   Pages: Extended;
begin
     Pages:= Taille / NbLignes_Pages;
     Libelle:= Format('%7.2f pages, %6d lignes, %s',[Pages,Taille,NomFichier]);
     if Exclu
     then
         Libelle:= '      ('+Libelle+')';
end;

function NombreLignes( Path, NomFichier: String): Integer;
var
   FileName: String;
   F: File;
   TailleF: Integer;
   S: String;
   SP: PChar;
   LongueurFinLigne: Integer;
begin
     FileName:= Path+PathDelim+NomFichier;
     AssignFile( F, FileName);
     FileMode:= 0;
     Reset( F, 1);
     TailleF:= FileSize(F);
     SetLength( S, TailleF+1);
     BlockRead( F, S[1], TailleF);
     CloseFile( F);
     S[ Length(S)]:= #0;
     SP:= @S[1];

     LongueurFinLigne:= Length( FinLigne);
     Result:= 1;
     repeat
           SP:= StrPos( SP, FinLigne);
           if Assigned( SP)
           then
               begin
               Inc( Result);
               Inc( SP, LongueurFinLigne);
               end;
     until SP =  nil;
end;

function TthjsLignes.TraiteRepertoire(Parent: TTreeNode; Path: String): Int64;
var
   SearchRec: TSearchRec;
   Courant: TTreeNode;
   NomFichier, NomComplet: String;
   Taille: Int64;
   NomMAJ, Ext: String;
   Exclu: Boolean;
   procedure CreeNode( TailleNode: Int64);
   begin
        Taille:= TailleNode;

        Node:= Parent;
        PrepareLibelle( Taille, NomFichier, Exclu);
        Synchronize( DoAddNode);
        Courant:= NewNode;
        Courant.Data:= StrNew( PChar( NomComplet));//pas de destructeur pour l'instant
   end;
begin
     Result:= 0;
     if FindFirst( Path+PathDelim+{$ifdef unix}'*'{$else}'*.*'{$endif}, faAnyFile, SearchRec) = 0
     then
         repeat
               NomFichier:= SearchRec.Name;
               NomComplet:= Path+PathDelim+NomFichier;
               NomMAJ:= UpperCase( NomFichier);
               Ext:= ExtractFileExt( NomMAJ);
               Exclu:= Exclus.IndexOf( NomComplet) >= 0;

               if SearchRec.Attr and faDirectory = 0
               then
                   //if (Ext = '.PAS') or (Ext = '.DPR') or (Ext = '.PP' ) or (Ext = '.INC') or
                   //   (Ext = '.ASP') or (Ext = '.PHP') or (Ext = '.4GL') or (Ext = '.PER')
                   if (Ext = '.HTML') or (Ext = '.HTM')
                   then
                       CreeNode( NombreLignes(Path, NomFichier))
                   else
                       Taille:= 0
               else
                   begin
                   CreeNode( 0);
                   if (NomFichier <> '.') and (NomFichier <> '..')
                   then
                       begin
                       Taille:= TraiteRepertoire( Courant, NomComplet);
                       Node:= Courant;
                       PrepareLibelle( Taille, NomFichier, Exclu);
                       Synchronize( DoChangeNodeText);
                       end;
                   end;
               if not Exclu
               then
                   Inc( Result, Taille);
         until FindNext( SearchRec) <> 0;
     Parent.AlphaSort;
end;


procedure TthjsLignes.Execute;
var
   Parent: TTreeNode;
   Taille: Int64;
begin
     { Placez le code du thread ici}
     Node:= nil;
     Libelle:= RootPath;
     Synchronize( DoAddNode);
     Parent:= NewNode;
     Taille:= TraiteRepertoire( Parent, RootPath);
     Node:= Parent;
     PrepareLibelle( Taille, RootPath, False);
     Synchronize( DoChangeNodeText);
     Parent.AlphaSort;
     FreeOnTerminate:= True;
     if Self = thjsLignes
     then
         thjsLignes:= nil;
end;

initialization
              thjsLignes:= nil;
end.
