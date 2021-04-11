unit ufCanvas;

{$mode objfpc}{$H+}

interface

uses
    uGeometrie, uQuasi_prime,
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs,
  ExtCtrls, StdCtrls, Spin, fgl;

type
 TFPGList_Integer= specialize TFPGList<Integer>;
 { TfCanvas }

 TfCanvas
 =
  class(TForm)
   bNext: TButton;
   bPrevious: TButton;
   cbRectangles: TCheckBox;
   Label1: TLabel;
   Label2: TLabel;
   Label3: TLabel;
   Label4: TLabel;
   Label5: TLabel;
   Label6: TLabel;
   lcoeff_Intersection_r: TLabel;
   lErreur: TLabel;
   lnBoucle: TLabel;
   lP2_P1: TLabel;
   lI: TLabel;
   lP1: TLabel;
   lP1P2: TLabel;
   lP2: TLabel;
   Panel1: TPanel;
   pb: TPaintBox;
   spe: TSpinEdit;
   procedure bNextClick(Sender: TObject);
   procedure bPreviousClick(Sender: TObject);
   procedure cbRectanglesChange(Sender: TObject);
   procedure FormCreate(Sender: TObject);
   procedure FormDestroy(Sender: TObject);
   procedure pbPaint(Sender: TObject);
   procedure speChange(Sender: TObject);
  public
     l_i: Integer;
     l: TFPGList_Integer;
     c: TCalcul;
     procedure Init( _i: Integer);
     class function Calcule( _i: Integer): TfCanvas;
  private
     procedure Populate_l;
     procedure Rafraichit;
  end;

implementation

{$R *.lfm}

function TFPGList_Integer_CompareFunc(const Item1, Item2: Integer): Integer;
begin
     Result:= Item1-Item2;
end;

{ TfCanvas }

procedure TfCanvas.FormCreate(Sender: TObject);
begin
     c:= TCalcul.Create;
     l_i:= 0;
     l:= TFPGList_Integer.Create;
     Populate_l;
end;

procedure TfCanvas.FormDestroy(Sender: TObject);
begin
     FreeAndNil( c);
     FreeAndNil( l);
end;

procedure TfCanvas.Populate_l;
const
     prime: array of integer
     =
      (
      {2,3,5,}7,11,13,17,19,23,29,31,37,41,43,47,53,59,61,67,71,73,79,83,89,97
      );
var
   i,j, i1, i2, i1i2,l_l_i: Integer;
begin
     l.Clear;
     for i:= Low(prime) to High(prime)
     do
       for j:= Low(prime) to High(prime)
       do
         begin
         i1:= prime[i];
         i2:= prime[j];
         i1i2:= i1*i2;
         l_i:= l.Add( i1i2);
         l_l_i:= l.Items[l_i];
         if i1i2 <> l_l_i then ShowMessage( Format('l_i: %d  i: %d j:%d i1i2: %d l_l_i: %d', [l_i, i, j, i1i2, l_l_i] )) ;
         end;

     l.Sort( @TFPGList_Integer_CompareFunc);
     i2:=l.Items[l.Count-1];
     for i:= l.Count-2 downto 0
     do
       begin
       i1:= l.Items[i];
       if i1 = i2 then l.Delete( i);
       i2:= i1;
       end;
     l_i:= 0;
end;

procedure TfCanvas.pbPaint(Sender: TObject);
begin
     //with pb.Canvas do Line( 0, 0 , Width, Height);
     if C = nil then exit;
     C.Draw( pb.Canvas);
end;

procedure TfCanvas.speChange(Sender: TObject);
begin
     Init( spe.Value);
     pb.Canvas.Clear;
     pb.Refresh;
end;

procedure TfCanvas.Init(_i: Integer);
begin
     C.Init( _i);
     lI .Caption:= IntToStr( _i);
     lP1.Caption:= C.sP1;
     lP2.Caption:= C.sP2;
     lP1P2.Caption:= IntToStr( C.Calcul.P1P2);
     lP2_P1.Caption:= FloatToStr( C.Calcul.P2/C.Calcul.P1)+ '  ' +FloatToStr( C.Calcul.P1/C.Calcul.P2);
     lcoeff_Intersection_r.Caption:= C.scoeff_Intersection_r;
     lnBoucle.Caption:= IntToStr( C.Calcul.nBoucle);
     lErreur.Visible:= C.Calcul.Erreur;
     lP1P2.Visible:= C.Calcul.Erreur;
end;

procedure TfCanvas.bNextClick(Sender: TObject);
begin
     Inc(l_i);
     Rafraichit;
end;

procedure TfCanvas.Rafraichit;
begin
          if l_i >= l.Count then l_i:=0
     else if l_i < 0        then l_i:= l.Count-1;

     Init( l.Items[l_i]);
     pb.Canvas.Clear;
     pb.Refresh;
end;

procedure TfCanvas.bPreviousClick(Sender: TObject);
begin
     Dec(l_i);
     Rafraichit;
end;

procedure TfCanvas.cbRectanglesChange(Sender: TObject);
begin
     C.ShowRectangles:= cbRectangles.Checked;
     Rafraichit;
end;

class function TfCanvas.Calcule(_i: Integer): TfCanvas;
begin
     Application.CreateForm(TfCanvas, Result);
     Result.spe.Value:= _i;
end;

end.

