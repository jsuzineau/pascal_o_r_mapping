unit uCircle;

{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            http://www.mars42.com                                               |
                                                                                |
    Copyright 2017 Jean SUZINEAU - MARS42                                       |
                                                                                |
    This program is free software: you can redistribute it and/or modify        |
    it under the terms of the GNU Lesser General Public License as published by |
    the Free Software Foundation, either version 3 of the License, or           |
    (at your option) any later version.                                         |
                                                                                |
    This program is distributed in the hope that it will be useful,             |
    but WITHOUT ANY WARRANTY; without even the implied warranty of              |
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the               |
    GNU Lesser General Public License for more details.                         |
                                                                                |
    You should have received a copy of the GNU Lesser General Public License    |
    along with this program.  If not, see <http://www.gnu.org/licenses/>. 1     |
                                                                                |
|                                                                               }
{$mode objfpc}{$H+}

interface

uses
 Classes, SysUtils, math;

type

 { TCircle }

 TCircle
 =
  class
  //Gestion du cycle de vie
  public
    constructor Create( _x1, _y1, _x2, _y2, _angle: double);
    destructor Destroy; override;
  //radians and degrees
  public
    function radians_from_degrees( _degrees: double): double;
    function degrees_from_radians( _radians: double): double;
  //paramètres initiaux
  public
    x1, y1, x2, y2: double;
    angle: double;
    angle_radians: double;
  //calculs intermédiaires
  public
    cas: string;
    slope, new_slope: double;
    xm, ym: double;
    d_chord: double;
    d_perp: double;
  //Centre
  public
    xc, yc: double;
  //Rayon
  public
    r: double;
  //Calcul
  public
    function x_from_angle( _alpha: double): double;
    function y_from_angle( _alpha: double): double;
    procedure Calcul( _Nb_points: Integer);
  //Résultat
  public
    x, y: array of double;
  end;

implementation

{ TCircle }

constructor TCircle.Create(_x1, _y1, _x2, _y2, _angle: double);
begin
     x1   := _x1   ;
     y1   := _y1   ;
     x2   := _x2   ;
     y2   := _y2   ;
     angle:= _angle;

     angle_radians:= radians_from_degrees( angle);

     //from https://stackoverflow.com/questions/10576641/given-2-points-on-a-circle-and-the-angle-between-how-to-find-the-center-in-pyt

     // Point on the line perpendicular to the chord
     // Note that this line also passes through the center of the circle
     xm:= (x1+x2)/2;
     ym:= (y1+y2)/2;

     // Distance between p1 and p2
     d_chord:= sqrt(sqr(x1-x2) + sqr(y1-y2));

     // Distance between xm, ym and center of the circle (xc, yc)
     d_perp:= d_chord/(2*tan(angle_radians));

     if x1 = x2
     then
         begin
         cas:= 'x1 = x2';
         slope:= 0;//infinite
         new_slope:= 0;
         xc:= d_perp + xm;
         yc:= ym;
         end
     else if y1 = y2
     then
         begin
         cas:= 'y1 = y2';
         slope:= 0;
         new_slope:= 0;//infinite

         xc:= xm;
         yc:= d_perp + ym;
         end
     else
         begin
         cas:= 'standard';
         // Slope of the line through the chord
         slope:= (y1-y2)/(x1-x2);

         // Slope of a line perpendicular to the chord
         new_slope:= -1/slope;

         // Equation of line perpendicular to the chord: y-ym = new_slope(x-xm)
         // Distance between xm,ym and xc, yc: (yc-ym)^2 + (xc-xm)^2 = d_perp^2
         // Substituting from 1st to 2nd equation for y,
         //   we get: (new_slope^2+1)(xc-xm)^2 = d^2

         // Solve for xc:
         xc:= (d_perp)/sqrt(sqr(new_slope)+1) + xm;

         // Solve for yc:
         yc:= (new_slope)*(xc-xm) + ym;
         end;

     r:= sqrt(sqr(xc-x1) + sqr(yc-y1));
end;

destructor TCircle.Destroy;
begin
     inherited Destroy;
end;

function TCircle.radians_from_degrees( _degrees: double): double;
begin
     Result:= _degrees * pi / 180;
end;

function TCircle.degrees_from_radians( _radians: double): double;
begin
     Result:= _radians * 180 / pi;
end;

function TCircle.x_from_angle( _alpha: double): double;
begin
     Result:= xc + r * cos( radians_from_degrees( _alpha));
end;

function TCircle.y_from_angle( _alpha: double): double;
begin
     Result:= yc + r * sin( radians_from_degrees( _alpha));
end;

procedure TCircle.Calcul( _Nb_points: Integer);
var
   Angle_start: double;
   Angle_step: double;
   Angle_courant: double;
   I: Integer;
begin
     SetLength( x, _Nb_points);
     SetLength( y, _Nb_points);

     Angle_step:= angle / _Nb_points;
     Angle_start:= degrees_from_radians( arctan2( y1-yc, x1-xc));

     for I:= 0 to _Nb_points-1
     do
       begin
       Angle_courant:= Angle_start+(I+1)*Angle_step;
       x[I]:= x_from_angle( Angle_courant);
       y[I]:= y_from_angle( Angle_courant);
       end;
end;

end.

