unit uFleur_de_vie;

{$mode objfpc}{$H+}

interface

uses
 Classes, SysUtils, math, StdCtrls;
const
     r3_2=sqrt(3)/2;
     r23=sqrt(2/3);
     s60=r3_2;//sin 60 °
     c60=1/2;//cos 60 °
     s30=c60;//sin 30 °
     c30=s60;//cos 30 °
     r2_2=sqrt(2)/2;
var
     at,at2,sat2,cat2: double;
var
   e: double =2;


function Fleur_de_vie_NbSpheres( _Xmin: integer=-2;
                                 _Xmax: integer= 2;
                                 _Ymin: integer=-2;
                                 _Ymax: integer= 2;
                                 _Zmin: integer=-2;
                                 _Zmax: integer= 2;
                                 _Rayon: integer=2;
                                 _m: TMemo=nil): Int64;

function Fleur_de_vie_NbSpheres_from_Rayon( _Rayon: integer=2; _m: TMemo=nil): Int64;

//function Fleur_de_vie_Test( _Rayon: integer=2; _m: TMemo=nil): Integer;

//procedure Fleur_de_vie_Calcul( _m: TMemo);

implementation

function Fleur_de_vie_NbSpheres_from_Rayon( _Rayon: integer=2;
                                            _m: TMemo=nil): Int64;
begin
     Result
     :=
       Fleur_de_vie_NbSpheres( -_Rayon, //_Xmin: integer=-2;
                               +_Rayon, //_Xmax: integer= 2;
                               -_Rayon, //_Ymin: integer=-2;
                               +_Rayon, //_Ymax: integer= 2;
                               -_Rayon, //_Zmin: integer=-2;
                               +_Rayon, //_Zmax: integer= 2;
                               +_Rayon,_m); //_Rayon: integer=2): Integer;
end;
function Fleur_de_vie_NbSpheres( _Xmin: integer=-2;
                                 _Xmax: integer= 2;
                                 _Ymin: integer=-2;
                                 _Ymax: integer= 2;
                                 _Zmin: integer=-2;
                                 _Zmax: integer= 2;
                                 _Rayon: integer=2;
                                 _m: TMemo=nil): Int64;
var
   ix, iy, iz: Integer;
   cx, cy, cz: double;
   cr2: Extended;
   Rayon_carre: Int64;
begin
     Result:= 0;
     Rayon_carre:= _Rayon*_Rayon;
     for ix:= _Xmin to _Xmax
     do
       for iy:= _Ymin to _Ymax
       do
         for iz:= _Zmin to _Zmax
         do
           begin
           cx:= e*ix+e*iy*c60+e*iz*cat2*c30;
           cy:=      e*iy*s60+e*iz*cat2*s30;
           cz:=               e*iz*sat2;
           cr2:= cx*cx+cy*cy+cz*cz;
           //_m.Lines.Add( Format('ix:%d; iy:%d; iz:%d; cx:%f; cy:%f; cz: %f; cr: %f', [ix,iy,iz,cx,cy,cz,sqrt(cr2)]));
           if  Rayon_carre >= cr2
           then
               Inc(Result);
           end;
end;

initialization
              at:=arccos(-1/3);//angle central du tétraèdre
              at2:=at/2;//demi-angle central du tétraèdre
              sat2:= sin(at2);
              cat2:= cos(at2);
end.

