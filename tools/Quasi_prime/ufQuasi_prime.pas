unit ufQuasi_prime;

{$mode objfpc}{$H+}

interface

uses
    uuStrings, uReels,
 Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
 Spin, ShellCtrls,math;

type

 { TfQuasi_prime }

 TfQuasi_prime = class(TForm)
  bBatch: TButton;
  Label1: TLabel;
  Label2: TLabel;
  lP1: TLabel;
  lP2: TLabel;
  m: TMemo;
  Panel1: TPanel;
  spe: TSpinEdit;
  procedure bBatchClick(Sender: TObject);
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

function Intersection_r_from_i( _i: Integer):ValReal;
var
   Carre   : TCarre;
   Triangle: TTriangle;
   x, y: ValReal;
begin
     Carre   := TCarre   .Create( _i);
     Triangle:= TTriangle.Create( _i);
     try
        x:= TAffine.Intersection_x( Triangle, Carre);
        y:= Triangle.y( x);
        Result:= sqrt( sqr(x) +sqr(y) )/1.0524;
     finally
            FreeAndNil(Carre   );
            FreeAndNil(Triangle);
            end;
end;

type

  { TCalcul }

  TCalcul
  =
   object
     i1, i2, i: Integer;
     Intersection_r,
     Mean_Circle_s,
     Mean,
     Ecart_s,
     Ecart,
     P1,
     P2: ValReal;

     Erreur: Boolean;

     Intersection_r_,
     Mean_,
     Mean_Circle_s_,
     Ecart_s_,
     Ecart_ :ValReal;

     procedure Decompose( _i1, _i2: Integer);
     function Log:String;
   end;

{ TCalcul }

procedure TCalcul.Decompose( _i1, _i2: Integer);
begin
     i1:= _i1;
     i2:= _i2;
     i:= i1*i2;

     Intersection_r:= Intersection_r_from_i( i);
     Mean_Circle_s:=PI*sqr(Intersection_r);
     Mean:= round(sqrt(Mean_Circle_s)); //Mean = Intersection_r*sqrt(PI) ?
     Mean_Circle_s:=Mean**2;

     Ecart_s:= Abs( Mean_Circle_s - i);

     Ecart:=ifthen( Ecart_s < 0.01, 0, sqrt( Ecart_s));

     P1:= round(Mean-Ecart);
     P2:= round(Mean+Ecart);

     Erreur
     :=
       not
          (
            ((P1=i1)and(P2=i2))
          or((P1=i2)and(P2=i1))
          );

     Mean_:= (i1+i2)/2;
     Mean_Circle_s_:= Mean_**2;

     Ecart_:= (i2-i1)/2;
     Ecart_s_:= Ecart_**2;

     Intersection_r_:= sqrt(Mean_Circle_s_/PI);
end;

function TCalcul.Log: String;
begin
     Result:= '';
     Formate_Liste( Result, #13#10, Format('%d * %d = %d', [i1, i2, i]));
     Formate_Liste( Result, #13#10, Format('Intersection_r: %f attendu %f,  %f%%', [Intersection_r, Intersection_r_, (Intersection_r/Intersection_r_)*100]));
     Formate_Liste( Result, #13#10, Format('Mean_Circle_s : %f attendu %f', [Mean_Circle_s, Mean_Circle_s_]));
     Formate_Liste( Result, #13#10, Format('Mean          : %f attendu %f', [Mean, Mean_]));
     Formate_Liste( Result, #13#10, Format('Ecart_s       : %f attendu %f', [Ecart_s, Ecart_s_]));
     Formate_Liste( Result, #13#10, Format('Ecart         : %f attendu %f', [Ecart, Ecart_]));
     Formate_Liste( Result, #13#10, Format('P1            : %f ', [P1]));
     Formate_Liste( Result, #13#10, Format('P2            : %f ', [P2]));
end;

function Decompose( _i1, _i2: Integer):TCalcul;
begin
     Result.Decompose( _i1, _i2);
end;


{ TfQuasi_prime }

procedure TfQuasi_prime.FormCreate(Sender: TObject);
begin
     m.Clear;
     //Calcule;
end;

procedure TfQuasi_prime.speChange(Sender: TObject);
begin
     Calcule;
end;

procedure TfQuasi_prime.Calcule;
var
   s: Integer;
   s_racine:Integer;
   s_racine_delta: Integer;
   is_square: Boolean;

   P1, P2: ValReal;
   Feedback_s:Integer;
   procedure p( _s: String; _d: ValReal; _l: TLabel = nil);
   var
      sD: String;
   begin
        sD:= FloatToStr( _d);
        m.Lines.Add( _s+':'+sD);
        with m.VertScrollBar do Position:= Range;
        if nil = _l then exit;
        _l.Caption:= sD;
   end;
   procedure l( _l: TLabel; _d: ValReal);
   var
      sD: String;
   begin
        sD:= FloatToStr( _d);
        _l.Caption:= sD;
   end;
   procedure Traite_Carre;
   begin
        P1:= s_racine;
        P2:= P1;
        Feedback_s := Trunc(P1*P2);

        p('P1=P2=',P1);
        p('Feedback_s' ,Feedback_s );
   end;
   procedure Cas_General;
   var
      Intersection_x,
      Intersection_y,
      Intersection_r,
      Blue_Circle_s,
      Blue_Circle_s_from_Mean,
      Mean,
      Ecart_s,
      Ecart: ValReal;
      Feedback_s1:Integer;
      Feedback_s2:Integer;
      procedure Calcule_intersection;
      var
         Carre   : TCarre;
         Triangle: TTriangle;
      begin
           Carre   := TCarre   .Create( s);
           Triangle:= TTriangle.Create( s);
           try
              Intersection_x:= TAffine.Intersection_x( Triangle, Carre);
              Intersection_y:= Triangle.y( Intersection_x);
           finally
                  FreeAndNil(Carre   );
                  FreeAndNil(Triangle);
                  end;
      end;
   begin
        Calcule_intersection;

        Intersection_r:= round(sqrt( sqr(Intersection_x) +sqr(Intersection_y) ));
        Blue_Circle_s:=PI*sqr(Intersection_r);
        Mean:= round(sqrt(Blue_Circle_s));
        Blue_Circle_s_from_Mean:=sqr(Mean);
        Ecart_s:= Blue_Circle_s_from_Mean - s;
        Ecart:=round(sqrt( Ecart_s));

        P1:= Mean-Ecart;
        P2:= Mean+Ecart;
        Feedback_s := Trunc(P1*P2);

        p('Blue_Circle_s', Blue_Circle_s);
        p('Blue_Circle_s_from_Mean', Blue_Circle_s_from_Mean);
        p('Mean', Mean);
        p('Ecart', Ecart);
        p('P1',P1);
        p('P2',P2);
        p('Feedback_s' ,Feedback_s );
        if Feedback_s <> s
        then
            begin
            Feedback_s1:= Trunc((P1+1)* P2   );
            Feedback_s2:= Trunc( P1   *(P2+1));
            p('Feedback_s1',Feedback_s1);
            p('Feedback_s2',Feedback_s2);
            end;
   end;
begin
     s:= spe.Value;
     m.Lines.Add('');
     p('s', s);

     s_racine:= Trunc(sqrt(s));
     s_racine_delta:= s-s_racine**2;
     p( 's-s_racine²',s_racine_delta);
     is_square:= 0 = s_racine_delta;

          if is_square then Traite_Carre
     else                   Cas_General;

     l(lP1,P1);
     l(lP2,P2);
end;

procedure TfQuasi_prime.bBatchClick(Sender: TObject);
const
     prime: array of integer
     =
      (
      2,3,5,7,11,13,17,19,23,29,31,37,41,43,47,53,59,61,67,71,73,79,83,89,97
      );

var
   j: Integer;
   n, nOK: Integer;
   procedure T( _i1, _i2: Integer);
   var
      C: TCalcul;
   begin
        C:= Decompose( _i1 , _i2);
        if C.Erreur
        then
            begin
            m.Lines.Add(C.Log);
            end
        else
            begin
            //m.Lines.Add(C.Log);
            Inc(nOK);
            end;
        Inc(n);
   end;
begin
     nOK:= 0;
     n:= 0;
     for j:= Low(prime)+1 to High(prime)
     do
       begin
       T(  prime[j-1],  prime[j]);
       T(  prime[j],  prime[j]);
       end;
     m.Lines.Add(IntToStr(nOK)+' calculs ok sur '+IntToStr(n));

end;

end.

