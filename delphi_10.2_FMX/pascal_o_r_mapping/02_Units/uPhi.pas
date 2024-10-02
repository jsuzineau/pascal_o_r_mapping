unit uPhi;
{$IFDEF FPC}
{$mode ObjFPC}{$H+}
{$ENDIF}


interface

uses
 Classes, SysUtils,Math, System.Types;

//Nombre d'or
//Golden ratio
var
   Phi,
   Phi_up,
   Phi_down: double;
//echo( "Phi_down", Phi_down);
//echo( "pi/Phi²", PI/sqr(Phi));
function PhiDown( _d: double; _n: Integer):double;
function PhiUp  ( _d: double; _n: Integer):double;

type
    TPhiSize_function= function ( _P: TPoint): TPoint;
function PhiSizeUp_horizontal( _P: TPoint): TPoint;
function PhiSizeUp_vertical  ( _P: TPoint): TPoint;
function PhiSizeDown_horizontal( _P: TPoint): TPoint;
function PhiSizeDown_vertical  ( _P: TPoint): TPoint;

implementation

function PhiDown(_d:double;_n: Integer):double;begin Result:=_d*Power(Phi_down,_n);end;
function PhiUp  (_d:double;_n: Integer):double;begin Result:=_d*Power(Phi_up  ,_n);end;

function PhiSizeUp( _P: TPoint; _HorizontalVertical_: Boolean): TPoint;
var
   Phi_X, Phi_Y: Integer;
begin
     if _HorizontalVertical_
     then
         begin
         Phi_X:= Trunc( Phiup  (_P.Y, 1));
         Phi_Y:= Trunc( Phidown(_P.X, 1));
         end
     else
         begin
           Phi_X:= Trunc( Phidown(_P.Y, 1));
           Phi_Y:= Trunc( Phiup  (_P.X, 1));
         end;
          if Phi_X >= _P.X then Result:= Point( Phi_X, _P.Y)
     else if Phi_Y >= _P.Y then Result:= Point(  _P.X, Phi_Y)
     else                       Result:= _P;
end;

function PhiSizeUp_horizontal( _P: TPoint): TPoint;
begin
     Result:= PhiSizeUp( _P, True);
end;

function PhiSizeUp_vertical  ( _P: TPoint): TPoint;
begin
     Result:= PhiSizeUp( _P, False);
end;

function PhiSizeDown( _P: TPoint; _HorizontalVertical_: Boolean): TPoint;
var
   Phi_X, Phi_Y: Integer;
begin
     if _HorizontalVertical_
     then
         begin
         Phi_X:= Trunc( PhiDown(_P.Y, 1));
         Phi_Y:= Trunc( PhiUp  (_P.X, 1));
         end
     else
         begin
           Phi_X:= Trunc( PhiUp  (_P.Y, 1));
           Phi_Y:= Trunc( PhiDown(_P.X, 1));
         end;
          if Phi_X <= _P.X then Result:= Point( Phi_X, _P.Y)
     else if Phi_Y <= _P.Y then Result:= Point(  _P.X, Phi_Y)
     else                       Result:= _P;
end;

function PhiSizeDown_horizontal( _P: TPoint): TPoint;
begin
     Result:= PhiSizeDown( _P, True);
end;

function PhiSizeDown_vertical  ( _P: TPoint): TPoint;
begin
     Result:= PhiSizeDown( _P, False);
end;

initialization
              Phi:= (1+sqrt(5))/2;
              Phi_up:= Phi;
              Phi_down:=Phi_up-1;
end.

