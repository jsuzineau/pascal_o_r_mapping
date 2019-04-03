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
    PopupMenu1: TPopupMenu;
    Exclure1: TMenuItem;
    mExclus: TMemo;
    Splitter1: TSplitter;
    speLignes_Page: TSpinEdit;
    Label1: TLabel;
    procedure bAnalyserClick(Sender: TObject);
    procedure bParcourirClick(Sender: TObject);
    procedure Exclure1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure eRootPathChange(Sender: TObject);
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

