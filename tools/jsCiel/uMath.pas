unit uMath;

interface

uses
    Math;

const
     _2PI= 2*PI;
     Ratio_Egalite= 1E-6;// tolérance de différence pour le test d'égalité
                         // entre nombres flottants

function MaxInd( const Args: array of Extended): Longint;

function MinInd( const Args: array of Extended): Longint;

function Max( const Args: array of Extended): Extended;

function Min( const Args: array of Extended): Extended;

function iMax( const Args: array of Longint): Longint;

function iMin( const Args: array of Longint): Longint;

// rajouté pour portage sous Free Pascal
function Max_2( e1, e2: Extended): Extended;
function iMax_2( i1, i2: Longint): Longint;
function Min_2( e1, e2: Extended): Extended;

function Max_3( e1, e2, e3: Extended): Extended;
function Min_3( e1, e2, e3: Extended): Extended;


type
    TypeComp= (c_Inferieur, c_Egal, c_Superieur);

function iComp(Compare,Reference: Longint): TypeComp;

function fComp(Compare,Reference: Extended): TypeComp;

function ArcTangente(x,y:Extended):Extended;
function Angle(x,y:Extended):Extended; {piqué dans la définition du log complexe}
function AnglePositif(x,y:Extended):Extended;{évite un modulo}

function rd_from_dg( d: Extended): Extended;
function dg_from_rd( d: Extended): Extended;
function dg_from_dgsec( d: Extended):Extended;{degrés from secondes d"arc}

function Modulo2PI(r :Extended):Extended;{ex- R2PI20}
function R2PI20(r :Extended):Extended;{pour ne pas modifier tout le code}
                           {on enlèvera ce détour quand tout marchera}

function Distance_Angulaire( A1, A2: Extended): Extended;

function TestZeroPentium( H: Extended):Boolean;
{ si H trop prés de 0, çà explose                                }
{ apparemment encore un bogue de calcul du Pentium               }
{ sqrt(2)*sqrt(2)-sqrt(2)*sqrt(2)*1 = 1.7e-15 !!!!               }
{ d"où cette fonction qui sert à "écrémer" les cas douteux                     }
{ Le paramètre "H" testé ici représente dans les fonctions XXXFix de uQuadril  }
{ et T_Objet.Calcul de uObjets                                                 }
{ la composante normale à l"écran avant la projection de la sphère sur le plan }
{ de l"écran. On atteint 0 sur le contour de la sphère vue à l"écran.          }

function TestInferieurZeroPentium( H: Extended):Boolean;

function fEgal( A, B: Extended): Boolean;

function AinB(ADeb, AFin, BDeb, BFin: Extended):Boolean;
{ on suppose Deb <= Fin}

function ArcCos(X: Extended): Extended;
function ArcSin(X: Extended): Extended;

function Tan( X: Extended): Extended;

function Log10( X: Extended): Extended;

procedure SinCos(Theta: Extended; var Sin, Cos: Extended);

procedure xy_to_sincos( var x, y: Extended);

function Normalise_Ascension_Droite( AD: Extended): Extended;

// On arrive dans certains cas à avoir une valeur d'entrée en dehors de [-1, 1]
// alors que l'on doit appliquer une fonction trigonométrique inverse ArcSin
// ou ArcCos.
// cas rencontré notamment dans TEquinoxeur.Calcul sur la variable C,
// en version Linux/XWindows
// dans ce cas, les algorithmes étant conformes au MEEUS, je présume que cela
// vient d'une erreur de troncature. donc on est obligé de "bidouiller".
function Bidouille_Valeur_Absolue_Inferieure_A_Un( X: Extended): Extended;

implementation

function MaxInd( const Args: array of Extended): Longint;
var
  I: Longint;
begin
     Result:= 0;
     for I := 0 to High(Args) do if Args[I] > Args[Result] then Result:= I;
end;

function MinInd( const Args: array of Extended): Longint;
var
  I: Longint;
begin
     Result:= 0;
     for I := 0 to High(Args) do if Args[I] < Args[Result] then Result:= I;
end;

function iMaxInd( const Args: array of Longint): Longint;
var
  I: Longint;
begin
     Result:= 0;
     for I := 0 to High(Args) do if Args[I] > Args[Result] then Result:= I;
end;

function iMinInd( const Args: array of Longint): Longint;
var
  I: Longint;
begin
     Result:= 0;
     for I := 0 to High(Args) do if Args[I] < Args[Result] then Result:= I;
end;

function Max( const Args: array of Extended): Extended;
begin
     Result:= Args[MaxInd( Args)];
end;

function Max_2( e1, e2: Extended): Extended;
begin
     if e2 > e1
     then
         Result:= e2
     else
         Result:= e1;
end;

function Max_3( e1, e2, e3: Extended): Extended;
begin
     if e2 > e1
     then
         Result:= e2
     else
         Result:= e1;

     if e3 > Result
     then
         Result:= e3;
end;

function Min( const Args: array of Extended): Extended;
begin
     Result:= Args[MinInd(Args)];
end;
function Min_2( e1, e2: Extended): Extended;
begin
     if e2 < e1
     then
         Result:= e2
     else
         Result:= e1;
end;

function Min_3( e1, e2, e3: Extended): Extended;
begin
     if e2 < e1
     then
         Result:= e2
     else
         Result:= e1;

     if e3 < Result
     then
         Result:= e3;
end;


function iMax( const Args: array of Longint): Longint;
begin
     Result:= Args[iMaxInd( Args)];
end;

function iMax_2( i1, i2: Longint): Longint;
begin
     if i2 > i1
     then
         Result:= i2
     else
         Result:= i1;
end;

function iMin( const Args: array of Longint): Longint;
begin
     Result:= Args[iMinInd(Args)];
end;
function iComp(Compare,Reference: Longint): TypeComp;
begin
     if Compare = Reference
     then
         Result:= c_Egal
     else
         if Compare<Reference
         then
             Result:= c_Inferieur
         else
             Result:= c_Superieur;
end;
function fComp(Compare,Reference: Extended): TypeComp;
begin
     if Compare = Reference
     then
         Result:= c_Egal
     else
         if Compare<Reference
         then
             Result:= c_Inferieur
         else
             Result:= c_Superieur;
end;

procedure SinCos(Theta: Extended; var Sin, Cos: Extended);
begin
     Math.SinCos(Theta, Sin, Cos);
end;

function Tan( X: Extended): Extended;
{$IFDEF BROWSER}
var
   s, c: Extended;
begin
     SinCos( x, s, c);
     if c = 0
     then
         Result:= NaN
     else
         Result:= s/c;
end;
{$ELSE}
begin
       Result:= Math.Tan(x);
end;
{$ENDIF}

function Log10( X: Extended): Extended;
begin
     Result:= Math.Log10(x);
end;

function ArcTangente(x,y:Extended):Extended;
begin
     if X = 0
     then
         if y<0
         then
             Result:= -PI/2
         else
             Result:= +PI/2
     else
         Result:= Arctan(y/x);

end;

function Angle(x,y:Extended):Extended; {piqué dans la définition du log complexe}
const
     Valeur_absolue_maxi_pour_ArcTan2= 264;
var
   Utiliser_ArcTan2: Boolean;
begin
     Utiliser_ArcTan2:= (Abs(x) < Valeur_absolue_maxi_pour_ArcTan2) and
                        (Abs(y) < Valeur_absolue_maxi_pour_ArcTan2) ;

     if Utiliser_ArcTan2
     then
         if x = 0.0
         then
             if y < 0.0
             then
                 Result:= -PI/2
             else
                 Result:= +PI/2
         else
             Result:= ArcTan2( y, x)
     else
         Result:= 2*ArcTangente(x+sqrt(sqr(x)+sqr(y)), y);
end;

function AnglePositif(x,y:Extended):Extended;
begin
     Result:= Angle(x,y);
     if Result < 0 then Result:= Result + _2PI;
end;

function rd_from_dg( d: Extended): Extended;
begin
     Result:= d*PI/180;
end;

function dg_from_rd( d: Extended): Extended;
begin
     Result:= d*180/PI;
end;

function Modulo2PI(r :Extended):Extended;{provient de R2PI20}
begin
     Result:=Frac(r/_2PI)*_2PI;
     if Result < 0 then Result:= Result + _2PI;
end;

function R2PI20(r :Extended):Extended;
begin
     Result:= Modulo2PI(r);
end;

function dg_from_dgsec( d: Extended):Extended;
begin
     Result:= d / 3600;
end;

{ si H trop prés de 0, çà explose                                }
{ apparemment encore un bogue de calcul du Pentium               }
{ sqrt(2)*sqrt(2)-sqrt(2)*sqrt(2)*1 = 1.7e-15 !!!!               }
{ d"où la fonction suivante qui sert à "écrémer" les cas douteux               }
{ Le paramètre "H" testé ici représente dans les fonctions XXXFix de uQuadril  }
{ et T_Objet.Calcul de uObjets                                                 }
{ la composante normale à l"écran avant la projection de la sphère sur le plan }
{ de l"écran. On atteint 0 sur le contour de la sphère vue à l"écran.          }
function TestZeroPentium( H: Extended):Boolean;
begin
     Result:= Abs(H) < 1e-10;
end;

function TestInferieurZeroPentium( H: Extended):Boolean;
begin
     Result:= H < 1e-10;
end;

function AinB(ADeb, AFin, BDeb, BFin: Extended):Boolean;
{ on suppose Deb <= Fin}
begin
     Result:= (BDeb <= ADeb) and (AFin <= BFin);
end;

function Distance_Angulaire( A1, A2: Extended): Extended;
begin
     if A1 > A2
     then
         Result:= A1-A2
     else
         Result:= A2-A1;
     if Result > PI
     then
         Result:= 2*PI - Result;
end;

function ArcCos(X: Extended): Extended;
begin
     X:= Bidouille_Valeur_Absolue_Inferieure_A_Un( X);
     Result:= Angle(X, Sqrt(1 - X*X));
end;

function ArcSin(X: Extended): Extended;
begin
     X:= Bidouille_Valeur_Absolue_Inferieure_A_Un( X);
     Result:= Angle( Sqrt(1 - X*X), X);
end;

procedure xy_to_sincos( var x, y: Extended);
var
   Norme: Extended;
begin
     Norme:= sqrt(x*x + y*y);
     x:= x/Norme;
     y:= y/Norme;
end;

function Normalise_Ascension_Droite( AD: Extended): Extended;
begin
     if AD < 0
     then
         Result:= AD + _2PI
     else
         Result:= AD;
end;

// On arrive dans certains cas à avoir une valeur d'entrée en dehors de [-1, 1]
// alors que l'on doit appliquer une fonction trigonométrique inverse ArcSin
// ou ArcCos.
// cas rencontré notamment dans TEquinoxeur.Calcul sur la variable C,
// en version Linux/XWindows
// dans ce cas, les algorithmes étant conformes au MEEUS, je présume que cela
// vient d'une erreur de troncature. donc on est obligé de "bidouiller".
function Bidouille_Valeur_Absolue_Inferieure_A_Un( X: Extended): Extended;
begin
     if X > 1
     then
         X:= 1
     else
         if X < -1
         then
             X:= -1;
     Result:= X;
end;

function fEgal( A, B: Extended): Boolean;
begin
          if A = B
     then
         Result:= True
     else if A = 0
     then
         Result:= Abs(B) < Ratio_Egalite
     else if B = 0
     then
         Result:= Abs(A) < Ratio_Egalite
     else
         Result:= Abs((B-A)/A) < Ratio_Egalite;
end;

end.

