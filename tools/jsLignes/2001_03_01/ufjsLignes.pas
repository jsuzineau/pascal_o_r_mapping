unit ufjsLignes;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls, ExtCtrls;

type
  TForm1 = class(TForm)
    TreeView1: TTreeView;
    Panel1: TPanel;
    eRep: TEdit;
    Label1: TLabel;
    bLoad: TButton;
    bjsLignes: TButton;
    procedure bLoadClick(Sender: TObject);
    procedure bjsLignesClick(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  Form1: TForm1;

implementation

uses ujsLignesTree;

{$R *.DFM}

procedure TForm1.bLoadClick(Sender: TObject);
begin
     Free_Tree( TreeView1);
     Load_Tree( TreeView1, eRep.Text);
end;

procedure TForm1.bjsLignesClick(Sender: TObject);
begin
     Traite( TreeView1);
end;

end.

