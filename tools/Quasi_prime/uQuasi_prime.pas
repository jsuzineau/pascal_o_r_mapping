unit uQuasi_prime;

{$mode objfpc}{$H+}

interface

uses
    uuStrings,
 Classes, SysUtils, Math, StrUtils;

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

type
 { TCarre }

 TCarre
 =
  class(TAffine)
  constructor Create( _s: ValReal);
  function b: ValReal; override;
  end;

type
 { TTriangle }

 TTriangle
 =
  class(TAffine)
  constructor Create( _s: ValReal);
  function b: ValReal; override;
  function vertical_edge_x: ValReal;
  end;
function Intersection_r_from_i( _i: Integer):ValReal;

type

  { TCalcul_Boucle }

  TCalcul_Boucle
  =
   object
     i: Integer;
     Intersection_r: ValReal;
     Mean_Circle_s,
     Mean,
     Distance_s,
     Distance: Int64;
     P1, P2, P1P2: Integer;
     Erreur: Boolean;
     nBoucle: Integer;
     procedure Init( _i: Integer;_Intersection_r: ValReal);
     procedure Boucle;
     function Header: String;
     function sP1: String;
     function sP2: String;
     function Log_interne( _Header: String= ''):String;
   end;

  { TCalcul }

  TCalcul
  =
   object
     i: Integer;
     Premier: Boolean;
     Intersection_r: ValReal;
     Intersection_r_direct: ValReal;
     Calcul_Original, Calcul: TCalcul_Boucle;

     covariance_mean_p1p2_positif: string;
     covariance_mean_p1p2_negatif: string;
     sens: String;

     i_root            : ValReal;
     Reverse_r         : ValReal;
     Reverse : TCalcul_Boucle;

     Mean_Delta: Integer;

     procedure Decompose( _i: Integer);
     function Log:String;
     function Log_interne:String;
     function sP1: String;
     function sP2: String;
   end;

  { TCalcul_Test }

  TCalcul_Test
  =
   object(TCalcul)
     i1, i2: Integer;
     i1i2: Integer;

     Erreur_Test: Boolean;

     Intersection_r_:ValReal;
     Mean_,
     Mean_Circle_s_,
     Distance_s_,
     Distance_ :Int64;

     procedure Decompose_Test( _i1, _i2: Integer);
     function Log_Detail:String;
     function sErreur_Test: String;
     function Log: String;
   end;

function Decompose( _i: Integer):TCalcul;

function Decompose_Test( _i1, _i2: Integer):TCalcul_Test;

implementation

function Carre_a_from_s( _s:ValReal):ValReal; begin Result:=sqrt(_s); end;
function Triangle_a_from_s( _s: ValReal): ValReal; begin Result:=sqrt((4/sqrt(3))*_s); end;
function Triangle_circonscrit_r_from_a( _a: ValReal):ValReal;begin Result:=_a/sqrt(3); end;

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


{ TCarre }
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

{ TTriangle }
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

function TTriangle.vertical_edge_x: ValReal;
begin
     Result:= -Triangle_a_from_s( s)*(sqrt(3)/6);//=rayon cercle inscrit
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
        Result:= sqrt( sqr(x) +sqr(y) )(*/1.0524*);
     finally
            FreeAndNil(Carre   );
            FreeAndNil(Triangle);
            end;
end;

{
x:= TAffine.Intersection_x( Triangle, Carre);
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
var
   ri: ValReal;
begin
     ri:= sqrt(_i);
     Result:= ri * ra2b2;
end;

type
  TIntersections
  =
   object
     Mean_r: ValReal;   //mean from current
     Reverse_r: ValReal;//from which current is the mean
   end;

function Intersections_from_i( _i: Integer):TIntersections;
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
        Result.Mean_r:= sqrt( sqr(x) +sqr(y) )(*/1.0524*);

        x:= Triangle.vertical_edge_x;
        y:= Carre.y( x);
        Result.Reverse_r:= sqrt( sqr(x) +sqr(y));
     finally
            FreeAndNil(Carre   );
            FreeAndNil(Triangle);
            end;
end;


{ TCalcul_Boucle }

procedure TCalcul_Boucle.Init(_i: Integer; _Intersection_r: ValReal);
begin
     i:= _i;
     Intersection_r:= _Intersection_r;
     Mean_Circle_s:=round(PI*sqr(Intersection_r));
     Mean:= round(sqrt(Mean_Circle_s)); //Mean = Intersection_r*sqrt(PI) ?
     nBoucle:= 0;
     Boucle;
end;

procedure TCalcul_Boucle.Boucle;
begin
     Mean_Circle_s:=sqr(Mean);
     Intersection_r:= sqrt( Mean_Circle_s/PI);
     Distance_s:= Mean_Circle_s - i;

     Distance:=ifthen( Distance_s = 0 , 0, round(sqrt( Distance_s)));

     P1:= Mean-Distance;
     P2:= Mean+Distance;
     P1P2:= P1*P2;
     Erreur:= P1P2 <> i;
     Inc(nBoucle);
end;

function TCalcul_Boucle.Header: String;
begin
     Result:= IfThen( Erreur, Format('Erreur: %d <> %d * %d = %d', [i, P1, P2, P1P2]), Format('%d = %d * %d ', [i, P1, P2]));
end;

function TCalcul_Boucle.sP1: String;
begin
     Result:= FloatToStr( P1);
end;

function TCalcul_Boucle.sP2: String;
begin
     Result:= FloatToStr( P2);
end;

{ TCalcul }
procedure TCalcul.Decompose(_i: Integer);
var
   Intersections: TIntersections;
   j: Integer;
begin
     i:= _i;
     Premier:= 0 = (sqr(i)-1) mod 24;

     covariance_mean_p1p2_positif:= '';
     covariance_mean_p1p2_negatif:= '';
     sens:= '';

     i_root:= sqrt(i);

     Intersections:= Intersections_from_i( i);
     Intersection_r:= Intersections.Mean_r;
     //Intersection_r:= Intersection_r_from_i_direct( i);
     Intersection_r_direct:= Intersection_r_from_i_direct( i);

     Calcul.Init( i, Intersection_r);
     Calcul_Original:= Calcul;

     if Calcul.Erreur
     then
         for j:= 1 to 30
         do
           begin
           Calcul.Mean:= Calcul_Original.Mean + j;
           Calcul.Boucle;
           Formate_Liste( covariance_mean_p1p2_positif, '/', IntToStr(Calcul.P1P2-Calcul_Original.P1P2));
           if not Calcul.Erreur
           then
               begin
               sens:= 'positif';
               break;
               end;

           Calcul.Mean:= Calcul_Original.Mean - j;
           Calcul.Boucle;
           Formate_Liste_inverse( covariance_mean_p1p2_negatif, '/', IntToStr(Calcul.P1P2-Calcul_Original.P1P2));
           if not Calcul.Erreur
           then
               begin
               sens:= 'négatif';
               break;
               end;
           end;

     Reverse_r:= Intersections.Reverse_r;
     Reverse.Init( round(PI*sqr(Reverse_r)), i_root);

     if Calcul.Erreur
     then
         Mean_Delta:= 0
     else
         Mean_Delta:= Calcul.Mean-Calcul_Original.Mean;
end;

function TCalcul.sP1: String;
begin
     Result:= Calcul.sP1;
end;

function TCalcul.sP2: String;
begin
     Result:= Calcul.sP2;
end;

{ TCalcul_Test }

procedure TCalcul_Test.Decompose_Test( _i1, _i2: Integer);
begin
     i1:= _i1;
     i2:= _i2;

     i1i2:= i1*i2;
     Decompose( i1i2);

     Erreur_Test
     :=
       not
          (
            ((Calcul.P1=i1)and(Calcul.P2=i2))
          or((Calcul.P1=i2)and(Calcul.P2=i1))
          );

     Mean_:= (i1+i2) div 2;
     Mean_Circle_s_:= Mean_**2;

     Distance_:= (i2-i1) div 2;
     Distance_s_:= Distance_**2;

     Intersection_r_:= sqrt(Mean_Circle_s_/PI);
end;

function TCalcul_Boucle.Log_interne( _Header: String): String;
begin
     Result:= _Header;
     Formate_Liste( Result, #13#10, Format('Mean_Circle_s : %d', [Mean_Circle_s ]));
     Formate_Liste( Result, #13#10, Format('Mean          : %d', [Mean          ]));
     Formate_Liste( Result, #13#10, Format('Distance_s    : %d', [Distance_s       ]));
     Formate_Liste( Result, #13#10, Format('Distance      : %d', [Distance         ]));
     Formate_Liste( Result, #13#10, Format('P1            : %d', [P1            ]));
     Formate_Liste( Result, #13#10, Format('P2            : %d', [P2            ]));
     Formate_Liste( Result, #13#10, Format('P1P2          : %d', [P1P2          ]));
     Formate_Liste( Result, #13#10, Format('nBoucle       : %d', [nBoucle       ]));
     Formate_Liste( Result, #13#10, 'Erreur: '+BoolToStr(Erreur, True));
end;

function TCalcul.Log_interne: String;
begin
     Result:= '';
     Formate_Liste( Result, #13#10, Calcul.Header);
     if Premier then Formate_Liste( Result, #13#10, 'Premier');
     Formate_Liste( Result, #13#10, Format('Intersection_r: %f', [Intersection_r]));
     Formate_Liste( Result, #13#10, Format('Intersection_r_direct: %f', [Intersection_r_direct]));
     Formate_Liste( Result, #13#10, Format('ra2b2: %f', [ra2b2]));
     Formate_Liste( Result, #13#10, Calcul_Original.Log_interne('Calcul_Original'));
     Formate_Liste( Result, #13#10, Calcul         .Log_interne('Calcul'         ));
     Formate_Liste( Result, #13#10, Format('Calcul.Intersection_r/i_root: %f', [Calcul.Intersection_r/i_root]));

     Formate_Liste( Result, #13#10, Format('i_root            : %f', [i_root            ]));
     Formate_Liste( Result, #13#10, Format('Reverse_r         : %f', [Reverse_r         ]));
     Formate_Liste( Result, #13#10, Reverse.Log_interne('Reverse'));
end;

function TCalcul.Log: String;
begin
     Result:= Log_interne;
end;

function TCalcul_Test.Log_Detail: String;
begin
     Result:= '';
     Formate_Liste( Result, #13#10, Format('%s%d * %d = %d', [sErreur_Test, i1, i2, i]));
     Formate_Liste( Result, #13#10, Log_interne);
     Formate_Liste( Result, #13#10, Format('Intersection_r: %f attendu %f,  %f%%', [Intersection_r, Intersection_r_, (Intersection_r/Intersection_r_)*100]));
     Formate_Liste( Result, #13#10, Format('Mean_Circle_s : %d attendu %d', [Calcul.Mean_Circle_s, Mean_Circle_s_]));
     Formate_Liste( Result, #13#10, Format('Mean          : %d attendu %d', [Calcul.Mean, Mean_]));
     Formate_Liste( Result, #13#10, Format('Distance_s    : %d attendu %d', [Calcul.Distance_s, Distance_s_]));
     Formate_Liste( Result, #13#10, Format('Distance      : %d attendu %d', [Calcul.Distance, Distance_]));
end;

function TCalcul_Test.sErreur_Test: String;
begin
     Result:= IfThen( Erreur_Test, 'Erreur_Test: ', '');
end;

function TCalcul_Test.Log: String;
begin
     //Result:= Format( '%d : %d : %d : %s : %d : %d, %s, %s',[i1i2,i1i2 mod 6,i1i2 mod 24,sens,Mean_Delta, Calcul.P1P2-Calcul_Original.P1P2, covariance_mean_p1p2_negatif, covariance_mean_p1p2_positif]);
     //Result:= Format( '%d : %f : %f : %f: %d , %d, %s',[i1i2, Intersection_r/i_root, Intersection_r_direct/i_root, Calcul.Intersection_r/i_root, Calcul.P1, Calcul.P2, BoolToStr(Calcul.Erreur,True)]);
     Result:= Format( '%-4d : %f : %-2d , %-2d',[i1i2, Calcul.Intersection_r/i_root, Calcul.P1, Calcul.P2]);
end;

function Decompose( _i: Integer):TCalcul;
begin
     Result.Decompose( _i);
end;

function Decompose_Test( _i1, _i2: Integer):TCalcul_Test;
begin
     Result.Decompose_Test( _i1, _i2);
end;


end.

