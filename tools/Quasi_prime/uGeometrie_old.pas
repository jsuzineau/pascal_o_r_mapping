unit uGeometrie_old;

{$mode objfpc}{$H+}

interface

uses
    uGeometrie_Base,
 Classes, SysUtils, Math;

type
 { TAffine_old }

 TAffine_old
 =
  class
  s: ValReal;
  a: ValReal;
  constructor Create( _s: ValReal);
  function b: ValReal; virtual;
  function y( _x: ValReal): ValReal;
  class function Intersection_x( _D1, _D2: TAffine_old): ValReal;
  end;

type
 { TCarre_old }

 TCarre_old
 =
  class(TAffine_old)
  constructor Create( _s: ValReal);
  function b: ValReal; override;
  end;

type
 { TTriangle_old }

 TTriangle_old
 =
  class(TAffine_old)
  constructor Create( _s: ValReal);
  function b: ValReal; override;
  function vertical_edge_x: ValReal;
  end;

function Intersection_r_from_i( _i: Integer):ValReal;

{
x:= TAffine_old.Intersection_x( Triangle, Carre);
x:= (Triangle.b-Carre.b) / (Carre.a-Triangle.a);;
x:= (Triangle_a_from_s( s)/3-Carre_a_from_s( s)/sqrt(2)) / (1+1/sqrt(3));
x:= (sqrt((4/sqrt(3))*_s)/3-sqrt(_s)/sqrt(2)) / (1+1/sqrt(3));
x:= sqrt(_s)*(r43/3-1/r2) / (1+1/r3);

y:= Triangle.y( x);
y:= Triangle.a * x +  Triangle.b;
y:= -1/sqrt(3) * x +  Triangle_a_from_s( s)/3;
y:= -1/sqrt(3) * x +  sqrt((4/sqrt(3))*_s)/3;
y:= -1/r3 * x +  r43*sqrt(_s)/3;

}
const
     r2=sqrt(2);
     r3=sqrt(3);
     _4r3=4/r3;
     r43=sqrt(_4r3);
     a= (r43/3 -1/r2) / _4r3;
     b= (-1/r3)*a+r43/3;
     ra2b2=sqrt(sqr(a)+sqr(b));
function Intersection_r_from_i_direct( _i: Integer):ValReal;

type
  TIntersections
  =
   object
     Mean_r: ValReal;   //mean from current
     Reverse_r: ValReal;//from which current is the mean
   end;

function Intersections_from_i( _i: Integer):TIntersections;


implementation

{ TAffine_old }

constructor TAffine_old.Create(_s: ValReal);
begin
     s:= _s;
     a:= 0;
end;

function TAffine_old.b: ValReal;
begin
     Result:= 0;
end;

function TAffine_old.y(_x: ValReal): ValReal;
begin
     Result:= a * _x +  b;
end;

class function TAffine_old.Intersection_x(_D1, _D2: TAffine_old): ValReal;
begin
     Result:= (_D1.b-_D2.b) / (_D2.a-_D1.a);
end;


{ TCarre_old }
constructor TCarre_old.Create( _s: ValReal);
begin
     inherited Create( _s);
     //a:= -tan(PI/4-PI/6);
     a:= 1;
end;

function TCarre_old.b: ValReal;
begin
     //Result:= (Carre_a_from_s( s)/2)/cos(PI/4-PI/6);
     Result:= Carre_a_from_s( s)/sqrt(2);
end;

{ TTriangle_old }
constructor TTriangle_old.Create(_s: ValReal);
begin
     inherited Create( _s);
     //a:= sqrt(3);//tan(PI/3);
     a:= -1/sqrt(3);
end;

function TTriangle_old.b: ValReal;
begin
     //Result:= Triangle_circonscrit_r_from_a( Triangle_a_from_s( s));
     Result:= Triangle_a_from_s( s)/3;
end;

function TTriangle_old.vertical_edge_x: ValReal;
begin
     Result:= -Triangle_a_from_s( s)*(sqrt(3)/6);//=rayon cercle inscrit
end;

function Intersection_r_from_i( _i: Integer):ValReal;
var
   Carre   : TCarre_old;
   Triangle: TTriangle_old;
   x, y: ValReal;
begin
     Carre   := TCarre_old   .Create( _i);
     Triangle:= TTriangle_old.Create( _i);
     try
        x:= TAffine_old.Intersection_x( Triangle, Carre);
        y:= Triangle.y( x);
        Result:= sqrt( sqr(x) +sqr(y) )(*/1.0524*);
     finally
            FreeAndNil(Carre   );
            FreeAndNil(Triangle);
            end;
end;

function Intersection_r_from_i_direct( _i: Integer):ValReal;
var
   ri: ValReal;
begin
     ri:= sqrt(_i);
     Result:= ri * ra2b2;
end;

function Intersections_from_i( _i: Integer):TIntersections;
var
   Carre   : TCarre_old;
   Triangle: TTriangle_old;
   x, y: ValReal;
begin
     Carre   := TCarre_old   .Create( _i);
     Triangle:= TTriangle_old.Create( _i);
     try
        x:= TAffine_old.Intersection_x( Triangle, Carre);
        y:= Triangle.y( x);
        Result.Mean_r:= sqrt( sqr(x) +sqr(y) )(*/1.0524*);

        x:= Triangle.vertical_edge_x;
        y:= Carre.y( x);
        Result.Reverse_r:= sqrt( sqr(x) +sqr(y));
     finally
            FreeAndNil(Carre   );
            FreeAndNil(Triangle);
            end;
end;


end.

