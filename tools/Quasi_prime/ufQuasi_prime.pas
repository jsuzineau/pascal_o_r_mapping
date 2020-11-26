unit ufQuasi_prime;

{$mode objfpc}{$H+}

interface

uses
 Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
 Spin,math;

type

 { TfQuasi_prime }

 TfQuasi_prime = class(TForm)
  m: TMemo;
  Panel1: TPanel;
  spe: TSpinEdit;
  procedure FormCreate(Sender: TObject);
  procedure speChange(Sender: TObject);
 private
  procedure Calcule;

 public
 end;

var
 fQuasi_prime: TfQuasi_prime;

implementation

{$R *.lfm}

function Carre_a_from_s( _s:ValReal):ValReal; begin Result:=sqrt(_s); end;
function Triangle_a_from_s( _s: ValReal): ValReal; begin Result:=sqrt((4/sqrt(3))*_s); end;
function Triangle_circonscrit_r_from_a( _a: ValReal):ValReal;begin Result:=_a/sqrt(3); end;


type
 { TAffine }

 TAffine
 =
  class
  s: ValReal;
  a: ValReal;
  constructor Create( _s: ValReal);
  function b: ValReal; virtual;
  function y( _x: ValReal): ValReal;
  class function Intersection_x( _D1, _D2: TAffine): ValReal;
  end;

{ TAffine }

constructor TAffine.Create(_s: ValReal);
begin
     s:= _s;
     a:= 0;
end;

function TAffine.b: ValReal;
begin
     Result:= 0;
end;

function TAffine.y(_x: ValReal): ValReal;
begin
     Result:= a * _x +  b;
end;

class function TAffine.Intersection_x(_D1, _D2: TAffine): ValReal;
begin
     Result:= (_D1.b-_D2.b) / (_D2.a-_D1.a);
end;

type
 { TCarre }

 TCarre
 =
  class(TAffine)
  constructor Create( _s: ValReal);
  function b: ValReal; override;
  end;

constructor TCarre.Create( _s: ValReal);
begin
     inherited Create( _s);
     //a:= -tan(PI/4-PI/6);
     a:= 1;
end;

function TCarre.b: ValReal;
begin
     //Result:= (Carre_a_from_s( s)/2)/cos(PI/4-PI/6);
     Result:= Carre_a_from_s( s)/sqrt(2);
end;

type
 { TTriangle }

 TTriangle
 =
  class(TAffine)
  constructor Create( _s: ValReal);
  function b: ValReal; override;
  end;

constructor TTriangle.Create(_s: ValReal);
begin
     inherited Create( _s);
     //a:= sqrt(3);//tan(PI/3);
     a:= -1/sqrt(3);
end;

function TTriangle.b: ValReal;
begin
     //Result:= Triangle_circonscrit_r_from_a( Triangle_a_from_s( s));
     Result:= Triangle_a_from_s( s)/3;
end;

{ TfQuasi_prime }

procedure TfQuasi_prime.FormCreate(Sender: TObject);
begin
     m.Clear;
     Calcule;
end;

procedure TfQuasi_prime.speChange(Sender: TObject);
begin
     Calcule;
end;

procedure TfQuasi_prime.Calcule;
var
   s: Integer;
   Carre: TCarre;
   Triangle: TTriangle;
   Intersection_x,
   Intersection_y,
   Intersection_r,
   Blue_Circle_s,
   Mean,
   Ecart_s,
   Ecart,
   P1, P2: ValReal;
   procedure p( _s: String; _d: ValReal);
   begin
        m.Lines.Add( _s+':'+FloatToStr( _d));
   end;
begin
     s:= spe.Value;
     m.Lines.Add('');
     p('s', s);
     Carre:= TCarre.Create( s);
     Triangle:= TTriangle.Create(s);

     Intersection_x:= TAffine.Intersection_x( Triangle, Carre);
     Intersection_y:= Triangle.y( Intersection_x);
     Intersection_r:= round(sqrt( sqr(Intersection_x) +sqr(Intersection_y) ));
     Blue_Circle_s:=PI*sqr(Intersection_r);
     p('Blue_Circle_s', Blue_Circle_s);
     Mean:= round(sqrt(Blue_Circle_s));
     Blue_Circle_s:=sqr(Mean);
     Ecart_s:= Blue_Circle_s - s;
     Ecart:=round(sqrt( Ecart_s));

     P1:= Mean-Ecart;
     P2:= Mean+Ecart;

     p('Blue_Circle_s', Blue_Circle_s);
     p('Mean', Mean);
     p('Ecart', Ecart);
     p('P1',P1);
     p('P2',P2);

     FreeAndNil(Carre   );
     FreeAndNil(Triangle);
end;

end.

