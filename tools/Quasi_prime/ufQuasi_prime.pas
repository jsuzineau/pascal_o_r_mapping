unit ufQuasi_prime;

{$mode objfpc}{$H+}

interface

uses
    uuStrings, uReels, uQuasi_prime, ufCanvas,
 Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
 Spin, ShellCtrls, ComCtrls, VirtualTrees,math,StrUtils;

type

 { TfQuasi_prime }

 TfQuasi_prime = class(TForm)
  bBatch: TButton;
  Button1: TButton;
  Label1: TLabel;
  Label2: TLabel;
  lP1: TLabel;
  lP2: TLabel;
  m: TMemo;
  Panel1: TPanel;
  spe: TSpinEdit;
  procedure bBatchClick(Sender: TObject);
  procedure Button1Click(Sender: TObject);
  procedure FormCreate(Sender: TObject);
  procedure speChange(Sender: TObject);
 private
  procedure Calcule;
  procedure Batch;

 public
 end;

var
 fQuasi_prime: TfQuasi_prime;

implementation

{$R *.lfm}

{ TfQuasi_prime }

procedure TfQuasi_prime.FormCreate(Sender: TObject);
begin
     m.Clear;
     //Calcule;
     Batch;
end;

procedure TfQuasi_prime.speChange(Sender: TObject);
begin
     Calcule;
end;

procedure TfQuasi_prime.Calcule;
var
   c: TCalcul;
begin
     c:= Decompose( spe.Value);
     m.Lines.Add('');
     m.Lines.Add(c.Log);
     lP1.Caption:= c.sP1;
     lP2.Caption:= c.sP2;
end;

procedure TfQuasi_prime.bBatchClick(Sender: TObject);
begin
     Batch;
end;

procedure TfQuasi_prime.Button1Click(Sender: TObject);
begin
     fCanvas.Show;
end;

procedure TfQuasi_prime.Batch;
const
     prime: array of integer
     =
      (
      {2,3,5,}7,11,13,17,19,23,29,31,37,41,43,47,53,59,61,67,71,73,79,83,89,97
      );
    //31*61=1891 Mean 46 Ecart 15
var
   n, nOK: Integer;
   procedure T( _j1, _j2: Integer);
   var
      i1, i2: Integer;
      C: TCalcul_Test;
   begin
        i1:= prime[_j1];
        i2:= prime[_j2];
        C:= Decompose_Test( i1 , i2);
        if C.Erreur_Test
        then
            begin
            //m.Lines.Add('');
            //m.Lines.Add(Format('j1:%d   j2: %d', [_j1, _j2]));
            //m.Lines.Add(C.Log_Detail);
            end
        else
            begin
            //m.Lines.Add(C.Log_Detail);
            Inc(nOK);
            end;
        Inc(n);
       if not C.Calcul.Erreur
       then
           m.Lines.Add(C.Log);

   end;
   procedure precedent_suivant;
   var
      j: Integer;
   begin
        for j:= Low(prime)+1 to High(prime)
        do
          T(  j-1,  j);
   end;
   procedure carres;
   var
      j: Integer;
   begin
        for j:= Low(prime) to High(prime)
        do
          T(  j,  j);
   end;
   procedure croise;
   var
      i,j: Integer;
   begin
        for i:= Low(prime) to High(prime)
        do
          for j:= Low(prime) to High(prime)
          do
            T(  i,  j);
   end;
begin
     nOK:= 0;
     n:= 0;
     //precedent_suivant;
     //carres;
     croise;
     m.Lines.Add(IntToStr(nOK)+' calculs ok sur '+IntToStr(n));

end;

end.

