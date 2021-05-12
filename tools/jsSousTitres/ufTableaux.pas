unit ufTableaux;

{$mode objfpc}{$H+}

interface

uses
    uEXE_INI,
    uFichierODT,
 Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
 Spin, IniPropStorage, Math;

type

 { TfTableaux }

 TfTableaux
 =
  class(TForm)
   ips: TIniPropStorage;
   Label3: TLabel;
    Label4: TLabel;
    lbColumn: TListBox;
    lbTable: TListBox;
    lNbLignes: TLabel;
    lTable: TLabel;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    seColonne: TSpinEdit;
    seDebut: TSpinEdit;
    Splitter1: TSplitter;
    procedure FormCreate(Sender: TObject);
    procedure lbTableClick(Sender: TObject);
    procedure seColonneChange(Sender: TObject);
  //Document
  public
    fo: TFichierODT;
    procedure Liste_Tableaux( _fo: TFichierODT);
  //Table
  private
    Tableau: TTableau;
    iColonne: Integer;
    procedure Selectionne_Table;
  end;

var
 fTableaux: TfTableaux;

implementation

{$R *.lfm}

{ TfTableaux }

procedure TfTableaux.FormCreate(Sender: TObject);
begin
     ips.IniFileName:= ExtractFilePath( EXE_INI_Nom)+'IniPropStorage.ini' ;
     ips.IniSection := Name;
end;

procedure TfTableaux.Liste_Tableaux( _fo: TFichierODT);
var
   t: TTableau;
begin
     fo:= _fo;
     lbTable.Clear;
     for t in fo.tl
     do
       lbTable.Items.AddObject( t.Nom, t);
end;

procedure TfTableaux.lbTableClick(Sender: TObject);
begin
     Selectionne_Table;
end;

procedure TfTableaux.seColonneChange(Sender: TObject);
begin
     Selectionne_Table;
end;

procedure TfTableaux.Selectionne_Table;
var
   iTable: Integer;
   c: TColonne;
begin
     iTable:= lbTable.ItemIndex;
     Tableau:= lbTable.Items.Objects[iTable] as TTableau;
     lTable.Caption:= Tableau.Nom;
     seDebut.Value:= Tableau.Debut;
     iColonne:= Tableau.Check( seColonne.Value);
     c:= Tableau.cl[ iColonne];
     lbColumn.Clear;
     lbColumn.Items.Text:= c.sl.Text;
     lNbLignes.Caption:= IntToStr( lbColumn.Count)+' lignes';
end;

end.

