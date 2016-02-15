unit ufjsFichiers;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls,
  uWinUtils, StdCtrls, ExtCtrls;

type
  TfjsFichiers = class(TForm)
    Tree: TTreeView;
    Panel1: TPanel;
    bAnalyser: TButton;
    eRootPath: TEdit;
    bParcourir: TButton;
    bImport_from_du: TButton;
    Open_du_Result: TOpenDialog;
    procedure bAnalyserClick(Sender: TObject);
    procedure bParcourirClick(Sender: TObject);
    procedure bImport_from_duClick(Sender: TObject);
  private
    { Déclarations privées}
  public
    function TraiteRepertoire( var T: Text; RepNode: TTreeNode; var TailleRep: Integer; var Rep: String): Boolean;
    { Déclarations publiques}
  end;

var
  fjsFichiers: TfjsFichiers;

implementation

uses uthjsFichiers;

{$R *.DFM}

procedure TfjsFichiers.bAnalyserClick(Sender: TObject);
begin
     if thjsFichiers = nil
     then
         thjsFichiers:= TthjsFichiers.Create( eRootPath.Text);
end;


// à réécrire avec TSelectDirectoryDialog ?
function SelectionnneRepertoire( Parent: integer; Titre: String; var Path: String): Boolean;
(*
var
   bi: TBrowseInfoA;
   pIIL: PItemIDList;
   malloc: IMalloc;
   Display: PChar;
*)
begin
     Result:= False;
(*
SHGetMalloc( malloc);
     Display:= malloc.Alloc( MAX_PATH+1);
       StrPCopy( Display, Path);
       bi.hwndOwner:= Parent;
       bi.pidlRoot:= nil;//GetIILfromPath(Parent, Path);
       bi.pszDisplayName:= Display;
       bi.lpszTitle:= PChar(Titre);
       bi.ulFlags:= 0;//$0010;//BIF_EDITBOX;
       bi.lpfn:= BrowseCallbackProc;
       bi.lParam:= Integer( Display);
       bi.iImage:=0;
       pIIL:= SHBrowseForFolder( bi);
       if pIIL <> nil
       then
           begin
           if SHGetPathFromIDList( pIIL, Display)
           then
               begin
               Path:= Display;
               Result:= True;
               end;
           end;
     malloc.Free( Display);
*)
end;

procedure TfjsFichiers.bParcourirClick(Sender: TObject);
var
   RootPath: String;
begin
     RootPath:= eRootPath.Text;
     if SelectionnneRepertoire( Handle, 'Sélectionnez le répertoire racine', RootPath)
     then
         eRootPath.Text:= RootPath;
end;

function TailleStr( Taille: Integer): String;
begin
     Result:= Format( '%10d, ', [Taille]);
end;


function TfjsFichiers.TraiteRepertoire( var T: Text; RepNode: TTreeNode; var TailleRep: Integer; var Rep: String): Boolean;
var
   Taille: Integer;
   Chemin: String;
   Node: TTreeNode;
   Continuer: Boolean;
   procedure Update_Continuer;
   begin
        Continuer:= Pos( Rep, Chemin) > 0;
   end;
begin

     Result:= not EOF( T);
     if not Result then exit;

     ReadLn( T, Taille, Chemin);
     Update_Continuer;
     if Continuer
     then
         begin
         while Continuer
         do
           begin
           Node:= Tree.Items.AddChild( RepNode, TailleStr(Taille)+Copy( Chemin, Length(Rep)+2, Length(Chemin)));
           Result:= TraiteRepertoire( T, Node, Taille, Chemin);
           if Result
           then
               Update_Continuer
           else
               Continuer:= False;
           end;
         end;

     if Result
     then
         begin
         TailleRep:= Taille;
         Rep:= Chemin;
         end;
end;

procedure TfjsFichiers.bImport_from_duClick(Sender: TObject);
var
   FichierDu: String;
   FichierTemporaire: String;
   sl: TStringList;
   I: Integer;

   T: TextFile;
   RootNode: TTreeNode;
   Taille: Integer;
   Chemin: String;
   Node: TTreeNode;

begin
     if Open_du_Result.Execute
     then
         begin
         FichierDu:= Open_du_Result.FileName;
         FichierTemporaire:= ChangeFileExt( ParamStr(0), '_Resultat_du.txt');
         sl:= TStringList.Create;
         try
            AssignFile( T, FichierTemporaire);
            ReWrite( T);
            try
               sl.LoadFromFile( FichierDu);
               for I:= sl.Count-1 downto 0
               do
                 WriteLn( T, sl.Strings[I]);
            finally
                   CloseFile( T);
                   end;
         finally
                sl.Free;
                end;

         AssignFile( T, FichierTemporaire);
         Reset( T);
         RootNode:= Tree.Items.AddChild( nil, FichierDu);
         try
            ReadLn( T, Taille, Chemin);
            Delete( Chemin, Length(Chemin), 1);
            repeat
                  Node:= Tree.Items.AddChild( RootNode, TailleStr(Taille)+Chemin);
            until not TraiteRepertoire( T, Node, Taille, Chemin);
         finally
                CloseFile( T);
                end;
         end;
         Tree.AlphaSort;
end;

end.

