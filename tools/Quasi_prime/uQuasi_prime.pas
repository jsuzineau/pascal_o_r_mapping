unit uQuasi_prime;

{$mode objfpc}{$H+}

interface

uses
    uuStrings, uGeometrie, uGeometrie_old,
 Classes, SysUtils, Math, StrUtils,Graphics;

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

  { TPolyedres }

  TPolyedres
  =
   class
   //Cycle de vie
   public
     constructor Create;
     destructor Destroy; override;
   //Attributs
   public
     P: array[3..8] of TPolyedre;
     Intersections: TIntersection_array;
   //Méthodes
   public
     procedure Init( _i: Integer);
     procedure Draw( _C: TCanvas; _Scale: ValReal; _Mean: ValReal);
     function Log( _Intersection_r: ValReal): String;
     procedure Calcule_Intersections;
   end;

  { TCalcul }

  TCalcul
  =
   class
   //Cycle de vie
   public
     constructor Create;
     destructor Destroy; override;

   //Attributs
   public
     i: Integer;
     //Premier: Boolean;

     Rectangle1: TRectangle;
     Rectangle2: TRectangle;
     P: TPolyedres;

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

     coeff_Intersection_r: ValReal;
     ShowRectangles: Boolean;

   //Méthodes
   public
     procedure Init( _i: Integer);
     function Log:String;
     function Log_interne:String;
     function sP1: String;
     function sP2: String;
     function scoeff_Intersection_r: String;
     procedure Draw( _C: TCanvas);
     function Carre: TPolyedre;
   end;

  { TCalcul_Test }

  TCalcul_Test
  =
   class(TCalcul)
   //Cycle de vie
   public
     constructor Create;
     destructor Destroy; override;

   //Attributs
   public
     i1, i2: Integer;
     i1i2: Integer;

     Erreur_Test: Boolean;

     Intersection_r_:ValReal;
     Mean_,
     Mean_Circle_s_,
     Distance_s_,
     Distance_ :Int64;

     procedure Init( _i1, _i2: Integer);
     function Log_Detail:String;
     function sErreur_Test: String;
     function Log: String;
   end;

implementation

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
     Distance_s:= abs(Mean_Circle_s - i);

     Distance:=ifthen( Distance_s = 0 , 0, round(sqrt( Distance_s)));

     P1:= Mean-Distance;
     P2:= Mean+Distance;
     P1P2:= P1*P2;
     Erreur:= P1P2 <> i;
     Inc(nBoucle);
end;

function TCalcul_Boucle.Header: String;
begin
     Result:= IfThen( Erreur, Format('Erreur: %d <> %d * %d = %d, mod6: %d', [i, P1, P2, P1P2, i mod 6]), Format('%d = %d * %d , mod6: %d', [i, P1, P2, i mod 6]));
end;

function TCalcul_Boucle.sP1: String;
begin
     Result:= FloatToStr( P1);
end;

function TCalcul_Boucle.sP2: String;
begin
     Result:= FloatToStr( P2);
end;

{ TPolyedres }

constructor TPolyedres.Create;
var
   iP: Integer;
begin
     for iP:= Low(P) to High(P)
     do
       P[iP]:= TPolyedre.Create( iP);
     Intersections.Reset;
end;

destructor TPolyedres.Destroy;
var
   iP: Integer;
begin
     for iP:= Low(P) to High(P)
     do
       FreeAndNil(P[iP]);
     inherited Destroy;
end;

procedure TPolyedres.Init(_i: Integer);
var
   iP: Integer;
begin
     for iP:= Low(P) to High(P)
     do
       P[iP].Init( _i);
     Calcule_Intersections;
end;

procedure TPolyedres.Calcule_Intersections;
var
   iP1, iP2: Integer;
   vrpa: TIntersection_array;
begin
     Intersections.Reset;
     for iP1:= Low(P) to High(P)
     do
       for iP2:= iP1+1 to High(P)
       do
         begin
         vrpa:= TPolyedre.Intersections( P[iP1], P[iP2]);
         Intersections.Add( vrpa);
         end;
end;

procedure TPolyedres.Draw( _C: TCanvas; _Scale: ValReal; _Mean: ValReal);
var
   iP: Integer;
   iI: Integer;
   cx, cy: Integer;
   vrp: TValReal_Point;
   vrp_r: ValReal;
   Mean, Mean_sqrt_2: Integer;
   x, y: Integer;
   Direct_match, Racine_match: Boolean;
begin
     for iP:= Low(P) to High(P)
     do
       P[iP].Draw( _C, _Scale);

     cx:= _C.Width  div 2;
     cy:= _C.Height div 2;
     with _C do Brush.Style:= bsClear;

     for iI:= Low(Intersections.a) to High(Intersections.a)
     do
       begin
       vrp:= Intersections.a[iI];
       vrp_r:= vrp.r;
       Mean       := round( sqrt(PI)*vrp_r);
       Mean_sqrt_2:= round( sqrt(PI)*vrp_r*sqrt(2));
       Direct_match:= Mean        = _Mean;
       Racine_match:= Mean_sqrt_2 = _Mean;
       if     not Direct_match
          and not Racine_match
       then
           continue;
       if Direct_match
       then
           with _C do Pen.Color:= clGreen
       else
           with _C do Pen.Color:= clRed;
       try
          x:= cx + round(vrp.x * _Scale);
          y:= cy - round(vrp.y * _Scale);
       except
             on E: Exception
             do
               continue;
             end;

       Circle( _C, x, y, round(_Scale*0.2));
       end;
end;

{ TCalcul }
constructor TCalcul.Create;
begin
     Rectangle1:= TRectangle.Create;
     Rectangle2:= TRectangle.Create;
     P:= TPolyedres.Create;
     ShowRectangles:= False;
end;

destructor TCalcul.Destroy;
begin
     FreeAndNil( Rectangle1);
     FreeAndNil( Rectangle2);
     FreeAndNil( P);
     inherited Destroy;
end;

function TCalcul.Carre: TPolyedre;
begin
     Result:= P.P[4];
end;

procedure TCalcul.Init( _i: Integer);
var
   Intersections: TIntersections_old;
   j: Integer;
begin
     i:= _i;
     //Premier:= 0 = (sqr(i)-1) mod 24; nécessaire non suffisant
     //Premier:= (i mod 6) in [1, 5];   nécessaire non suffisant

     covariance_mean_p1p2_positif:= '';
     covariance_mean_p1p2_negatif:= '';
     sens:= '';

     i_root:= sqrt(i);

     P.Init( i);

     Intersections:= Intersections_from_i_old( i);
     Intersection_r:= Intersections.Mean_r;
     //Intersection_r:= Intersection_r_from_i_direct_old( i);
     Intersection_r_direct:= Intersection_r_from_i_direct_old( i);

     Calcul.Init( i, Intersection_r);
     Calcul_Original:= Calcul;

     if Calcul.Erreur
     then
         for j:= 1 to 1000
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

     Rectangle1.Init( Calcul.P1, Calcul.P2);
     Rectangle2.Init( Calcul.P2, Calcul.P1);

     coeff_Intersection_r:= Calcul.Intersection_r/Calcul_Original.Intersection_r;
end;

function TCalcul.sP1: String;
begin
     Result:= Calcul.sP1;
end;

function TCalcul.sP2: String;
begin
     Result:= Calcul.sP2;
end;

function TCalcul.scoeff_Intersection_r: String;
begin
     //Result:= Format( '%f', [coeff_Intersection_r]);
     Result:= FloatToStr(coeff_Intersection_r);
end;

procedure TCalcul.Draw(_C: TCanvas);
var
   Scale: ValReal;
   cx, cy: Integer;
begin
     Scale:= _C.Width / (3*Carre.a);
     cx:= _C.Width  div 2;
     cy:= _C.Height div 2;

     _C.Clear;
     with _C do Pen.Color:= clBlack;
     with _C do Line( 0, cy, Width,     cy);
     with _C do Line(cx,  0,    cx, Height);
     P.Draw( _C, Scale, Calcul.Mean);
     if ShowRectangles
     then
         begin
         Rectangle1.Draw( _C, Scale);
         Rectangle2.Draw( _C, Scale);
         end;
     with _C do Brush.Style:= bsClear;
     with _C do Pen.Color:= clRed;
     Circle( _C, cx, cy, round( Scale*Calcul_Original.Intersection_r));
     with _C do Pen.Color:= clBlue;
     Circle( _C, cx, cy, round( Scale*Calcul.Intersection_r));
end;

{ TCalcul_Test }

constructor TCalcul_Test.Create;
begin
     inherited Create;
end;

destructor TCalcul_Test.Destroy;
begin
     inherited Destroy;
end;

procedure TCalcul_Test.Init(_i1, _i2: Integer);
begin
     i1:= _i1;
     i2:= _i2;

     i1i2:= i1*i2;
     inherited Init( i1i2);

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

function TPolyedres.Log(_Intersection_r: ValReal): String;
var
   iI: Integer;
   vrp: TIntersection;
   vrp_r: ValReal;
   x, y: Integer;
   Direct_match, Racine_match: Boolean;
   sMatch: String;
   vr1, vr2, vr3: ValReal;
   Mean: Integer;
   vr: ValReal;
begin
     Result:= 'Intersections';
     for iI:= Low(Intersections.a) to High(Intersections.a)
     do
       begin
       vrp:= Intersections.a[iI];
       vrp_r:= vrp.r;
       Direct_match:= (abs(vrp_r - _Intersection_r        ) <= 0.1);
       Racine_match:= (abs(vrp_r - _Intersection_r/sqrt(2)) <= 0.1);
            if Direct_match then sMatch:= 'D'
       else if Racine_match then sMatch:= 'R'
       else                      sMatch:= '';
       vr1:= round(sqrt(round(PI*sqr(vrp_r))));
       Mean:= round(sqrt(PI)*vrp_r);
       vr3:= sqrt(PI)*vrp_r;
       vr:= vr1-Mean;
       Formate_Liste( Result, #13#10, Format('%d',[Mean])+' type '+vrp.s+' '+sMatch);
       end;
end;

function TCalcul.Log_interne: String;
begin
     Result:= '';
     Formate_Liste( Result, #13#10, Calcul.Header);
     //if Premier then Formate_Liste( Result, #13#10, 'Premier');
     Formate_Liste( Result, #13#10, Format('Intersection_r: %f', [Intersection_r]));
     Formate_Liste( Result, #13#10, Format('Intersection_r_direct: %f', [Intersection_r_direct]));
     Formate_Liste( Result, #13#10, Format('ra2b2: %f', [ra2b2]));
     //Formate_Liste( Result, #13#10, Calcul_Original.Log_interne('Calcul_Original'));
     Formate_Liste( Result, #13#10, Calcul         .Log_interne('Calcul'         ));
     //Formate_Liste( Result, #13#10, Format('Calcul.Intersection_r/i_root: %f', [Calcul.Intersection_r/i_root]));

     //Formate_Liste( Result, #13#10, Format('i_root            : %f', [i_root            ]));
     //Formate_Liste( Result, #13#10, Format('Reverse_r         : %f', [Reverse_r         ]));
     //Formate_Liste( Result, #13#10, Reverse.Log_interne('Reverse'));
     Formate_Liste( Result, #13#10, P.Log( Calcul.Intersection_r));
end;

function TCalcul.Log: String;
begin
     Result:= Log_interne;
end;

function TCalcul_Test.Log_Detail: String;
begin
     Result:= '';
     Formate_Liste( Result, #13#10, Format('%s%d * %d = %d, mod6: %d', [sErreur_Test, i1, i2, i, i mod 6]));
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


end.

