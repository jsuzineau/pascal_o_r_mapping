unit ufjsLignes;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFnDEF FPC}
  Windows,
{$ELSE}
  LCLIntf, LCLType, LMessages,
{$ENDIF}
  Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls,
StdCtrls, ExtCtrls, Menus, Spin;

type
  TfjsLignes = class(TForm)
    Tree: TTreeView;
    Panel1: TPanel;
    bAnalyser: TButton;
    eRootPath: TEdit;
    bParcourir: TButton;
    bImport_from_du: TButton;
    Open_du_Result: TOpenDialog;
    PopupMenu1: TPopupMenu;
    Exclure1: TMenuItem;
    mExclus: TMemo;
    Splitter1: TSplitter;
    speLignes_Page: TSpinEdit;
    Label1: TLabel;
    procedure bAnalyserClick(Sender: TObject);
    procedure bParcourirClick(Sender: TObject);
    procedure bImport_from_duClick(Sender: TObject);
    procedure Exclure1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure eRootPathChange(Sender: TObject);
  private
    { Déclarations privées}
  public
    function TraiteRepertoire( var T: Text; RepNode: TTreeNode; var TailleRep: Integer; var Rep: String): Boolean;
    { Déclarations publiques}
  end;

var
  fjsLignes: TfjsLignes;

implementation

uses uthjsLignes;

{$R *.dfm}

procedure TfjsLignes.bAnalyserClick(Sender: TObject);
begin
     if thjsLignes = nil
     then
         begin
         NbLignes_Pages:= speLignes_Page.Value;
         thjsLignes:= TthjsLignes.Create( eRootPath.Text, mExclus.Text);
         end;
end;

procedure TfjsLignes.bParcourirClick(Sender: TObject);
var
   RootPath: String;
begin
     if SelectDirectory( 'Sélectionnez le répertoire racine', eRootPath.Text, RootPath)
     then
         eRootPath.Text:= RootPath;
end;

function TailleStr( Taille: Integer): String;
begin
     Result:= Format( '%10d, ', [Taille]);
end;


function TfjsLignes.TraiteRepertoire( var T: Text; RepNode: TTreeNode; var TailleRep: Integer; var Rep: String): Boolean;
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

procedure TfjsLignes.bImport_from_duClick(Sender: TObject);
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

procedure TfjsLignes.Exclure1Click(Sender: TObject);
begin
     mExclus.Lines.Add( PChar(Tree.Selected.Data));
end;

procedure TfjsLignes.FormClose(Sender: TObject; var Action: TCloseAction);
var
   FileName: String;
begin
     FileName:= eRootPath.Text+'\jsLignes.Exclus.txt';
     mExclus.Lines.SaveToFile( FileName);
end;

procedure TfjsLignes.eRootPathChange(Sender: TObject);
var
   FileName: String;
begin
     FileName:= eRootPath.Text+'\jsLignes.Exclus.txt';
     if FileExists( FileName)
     then
         mExclus.Lines.LoadFromFile( FileName);
end;

end.

