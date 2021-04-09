unit uGeometrie;

{$mode objfpc}{$H+}

interface

uses
    uGeometrie_Base,
 Classes, SysUtils,Math;

type

 { TValReal_Point }

 TValReal_Point
 =
  object
    x: ValReal;
    y: ValReal;
    function r: ValReal;
  end;

 { TAffine }

 TAffine
 =
  class
  public
    Vertical: Boolean;
    Vertical_x: ValReal;
    alpha, d: ValReal;
    tan_alpha, cos_alpha: ValReal;
    a, b: ValReal;
    constructor Create( _alpha, _d: ValReal);
    constructor Create_from_tan_cos( _tan_alpha, _cos_alpha, _d: ValReal);
    constructor Create_from_arctan2( _x, _y, _d: ValReal);
    constructor Create_Vertical( _Vertical_x: ValReal);
    function y( _x: ValReal): ValReal;
    class function Intersection( _D1, _D2: TAffine): TValReal_Point;
  private
    procedure Init_a_b;
    procedure Init_tan_cos_from_alpha;
    procedure Init_alpha_from_tan_cos;
    procedure Init_Vertical_x_from_alpha_d;
    procedure Init_alpha_d_from_Vertical_x;
  end;

type
 { TCarre }

 TCarre
 =
  class
    s: ValReal;
    a, a2: ValReal;
    D1, D2, D3, D4: TAffine;
  //Cycle de vie
  public
    constructor Create( _s: ValReal);
    destructor Destroy; override;
  end;

implementation

{ TValReal_Point }

function TValReal_Point.r: ValReal;
begin
     Result:= sqrt(sqr(x)+sqrt(y));
end;

{ TAffine }

constructor TAffine.Create(_alpha, _d: ValReal);
begin
     alpha:= _alpha;
     d    := _d;
     Vertical:= PI/2 = abs(alpha);

     Init_Vertical_x_from_alpha_d;
     Init_tan_cos_from_alpha;
     Init_a_b;
end;

constructor TAffine.Create_from_tan_cos( _tan_alpha, _cos_alpha, _d: ValReal);
begin
     Vertical:= False;//sinon _tan_alpha infini
     tan_alpha:= _tan_alpha;
     cos_alpha:= _cos_alpha;
     d        := _d;

     Init_Vertical_x_from_alpha_d;
     Init_alpha_from_tan_cos;
     Init_a_b;
end;

constructor TAffine.Create_from_arctan2(_x, _y, _d: ValReal);
begin
     Vertical:= False;//sinon _y infini
     alpha:= ArcTan2( _y, _x);
     d    := _d;

     Init_Vertical_x_from_alpha_d;
     Init_tan_cos_from_alpha;
     Init_a_b;
end;

constructor TAffine.Create_Vertical( _Vertical_x: ValReal);
begin
     Vertical:= True;
     Vertical_x:= _Vertical_x;
     Init_alpha_d_from_Vertical_x;
     Init_tan_cos_from_alpha;
     Init_a_b;
end;

procedure TAffine.Init_tan_cos_from_alpha;
begin
     tan_alpha:= tan( alpha);
     cos_alpha:= cos( alpha);
end;

procedure TAffine.Init_alpha_from_tan_cos;
begin
     alpha:= ArcTan( tan_alpha);
     if cos_alpha >= 0 then exit;

     alpha:= alpha + PI;
end;

procedure TAffine.Init_alpha_d_from_Vertical_x;
begin
     if Vertical_x <= 0
     then
         begin
         d:= -Vertical_x;
         alpha:= PI/2;
         end
     else
         begin
         d:= +Vertical_x;
         alpha:= -PI/2;
         end;
end;

procedure TAffine.Init_Vertical_x_from_alpha_d;
begin
     if Vertical
     then
         if alpha > 0
         then
             Vertical_x:= -d
         else
             Vertical_x:= +d
     else
         Vertical_x:= NaN;
end;

procedure TAffine.Init_a_b;
begin
     if Vertical
     then
         begin
         a:= 0;
         b:= 0;
         end
     else
         begin
         a:= tan_alpha;
         b:= d / cos_alpha;
         end;
end;

function TAffine.y(_x: ValReal): ValReal;
begin
     if Vertical
     then
         Result:= NaN
     else
         Result:= a * _x +  b;
end;

class function TAffine.Intersection( _D1, _D2: TAffine): TValReal_Point;
   procedure Traite_Vertical( _x: ValReal; _D: TAffine);
   begin
        Result.x:= _x;
        Result.y:= _D.y( _x);
   end;
begin
     if _D1.Vertical
     then
         if _D2.Vertical
         then
             begin
             Result.x:= NaN;
             Result.y:= NaN;
             end
         else
             Traite_Vertical( _D1.Vertical_x, _D2)
     else
         if _D2.Vertical
         then
             Traite_Vertical( _D2.Vertical_x, _D1)
         else
             begin
             Result.x:= (_D1.b-_D2.b) / (_D2.a-_D1.a);
             Result.y:= _D1.y( Result.x);
             end;
end;

{ TCarre }

constructor TCarre.Create(_s: ValReal);
begin
     s:= _s;
     a:= Carre_a_from_s( s);
     a2:= a/2;

     D1:= TAffine.Create( +  PI/4, a2);
     D2:= TAffine.Create( -  PI/4, a2);
     D3:= TAffine.Create( -3*PI/4, a2);
     D4:= TAffine.Create( +3*PI/4, a2);
end;

destructor TCarre.Destroy;
begin
     inherited Destroy;
end;


end.

