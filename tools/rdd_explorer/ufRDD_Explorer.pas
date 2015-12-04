unit ufRDD_Explorer;

{$mode objfpc}{$H+}

interface

uses
    uClean,
    uRDD,
 Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
 StdCtrls, Grids;

type

 { TfRDD_Explorer }

 TfRDD_Explorer
 =
  class(TForm)
   mRaw: TMemo;
   pc: TPageControl;
   sg: TStringGrid;
   tsGrid: TTabSheet;
   tsRaw: TTabSheet;
   procedure FormCreate(Sender: TObject);
   procedure FormDestroy(Sender: TObject);
   procedure FormDropFiles(Sender: TObject; const FileNames: array of String);
  //RDD
  private
    rdd: TRDD;
    procedure rdd_Changed;
  end;

var
 fRDD_Explorer: TfRDD_Explorer;

implementation

{$R *.lfm}

{ TfRDD_Explorer }

procedure TfRDD_Explorer.FormCreate(Sender: TObject);
begin
     rdd:= TRDD.Create;
     rdd.OnChange.Abonne( Self, @rdd_Changed);
end;

procedure TfRDD_Explorer.FormDestroy(Sender: TObject);
begin
     rdd.OnChange.DesAbonne( Self, @rdd_Changed);
     Free_nil( rdd);
end;

procedure TfRDD_Explorer.FormDropFiles( Sender: TObject; const FileNames: array of String);
begin
     if Length( FileNames) < 1 then exit;

     rdd.NomFichier:= FileNames[0];
end;

procedure TfRDD_Explorer.rdd_Changed;
var
   I: TIterateur_RDD_Ligne;
   bl: TRDD_Ligne;
   X, Y: Integer;
begin
     mRaw.Lines.Text:= rdd.S;
     sg.ColCount:= rdd.NbColonnes;
     sg.RowCount:= rdd.NbLignes;
     Y:= 0;
     I:= rdd.sl.Iterateur;
     while I.Continuer
     do
       begin
       if I.not_Suivant( bl) then continue;

       for X:= 0 to bl.NbColonnes - 1
       do
         sg.Cells[ X, Y]:= bl.A[X];

       Inc( Y);
       end;

end;

end.

