unit uGeometrie;

{$mode objfpc}{$H+}

interface

uses
    uGeometrie_Base,
 Classes, SysUtils,Math,Graphics;

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
    Color: TColor;
    Vertical: Boolean;
    Vertical_x: ValReal;
    angle_d, d: ValReal;
    dx, dy: ValReal;
    angle_droite: ValReal;
    cos_angle_droite: ValReal;
    a, b: ValReal;
    segment: ValReal;
    constructor Create;
    procedure Init( _angle_d, _d, _segment: ValReal);
    procedure Init_Vertical( _Vertical_x, _segment: ValReal);
    function y( _x: ValReal): ValReal;
    class function Intersection( _D1, _D2: TAffine): TValReal_Point;
    procedure Draw(_C: TCanvas; _Scale: ValReal);
  private
    procedure Init_a_b;
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
    constructor Create;
    destructor Destroy; override;
  //Méthodes
  public
    procedure Init( _s: ValReal);
    procedure Draw(_C: TCanvas; _Scale: ValReal);
  end;

type
 { TRectangle }

 TRectangle
 =
  class
    s: ValReal;
    a, a2: ValReal;
    b, b2: ValReal;
    D1, D2, D3, D4: TAffine;
  //Cycle de vie
  public
    constructor Create;
    destructor Destroy; override;
  //Méthodes
  public
    procedure Init( _a, _b: ValReal);
    procedure Draw(_C: TCanvas; _Scale: ValReal);
  end;

type
 { TTriangle }

 TTriangle
 =
  class
    s: ValReal;
    a: ValReal;
    cercle_inscrit_r: ValReal;
    D1, D2, D3: TAffine;
  //Cycle de vie
  public
    constructor Create;
    destructor Destroy; override;
  //Méthodes
  public
    procedure Init( _s: ValReal);
    procedure Draw(_C: TCanvas; _Scale: ValReal);
  end;

procedure Circle( _C: TCanvas; _x, _y, _r: Integer);

implementation

procedure Circle( _C: TCanvas; _x, _y, _r: Integer);
begin
     _C.Ellipse( _x-_r, _y-_r, _x+_r, _y+_r);
end;

{ TValReal_Point }

function TValReal_Point.r: ValReal;
begin
     Result:= sqrt(sqr(x)+sqrt(y));
end;

{ TAffine }

constructor TAffine.Create;
begin
     Color:= clBlack;
end;

procedure TAffine.Init(_angle_d, _d, _segment: ValReal);
begin
     angle_d:= _angle_d;
     d    := _d;
     segment:= _segment;
     Vertical:= angle_d mod PI = 0;

     angle_droite:= angle_d - PI/2;

     Init_Vertical_x_from_alpha_d;
     Init_a_b;
end;

procedure TAffine.Init_Vertical(_Vertical_x, _segment: ValReal);
begin
     Vertical:= True;
     Vertical_x:= _Vertical_x;
     segment:= _segment;
     Init_alpha_d_from_Vertical_x;
     Init_a_b;
end;

procedure TAffine.Init_alpha_d_from_Vertical_x;
begin
     if Vertical_x <= 0
     then
         begin
         d:= -Vertical_x;
         angle_d:= PI;
         end
     else
         begin
         d:= +Vertical_x;
         angle_d:= 0;
         end;
end;

procedure TAffine.Init_Vertical_x_from_alpha_d;
begin
     if Vertical
     then
         if angle_d = PI
         then
             Vertical_x:= -d
         else
             Vertical_x:= +d
     else
         Vertical_x:= NaN;
end;

procedure TAffine.Init_a_b;
begin
     cos_angle_droite:= cos( angle_droite);
     dx:= d*cos(angle_d);
     dy:= d*sin(angle_d);
     if Vertical
     then
         begin
         a:= 0;
         b:= 0;
         end
     else
         begin
         a:= tan(angle_droite);
         b:= d / cos_angle_droite;
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

procedure TAffine.Draw( _C: TCanvas; _Scale: ValReal);
   procedure Traite_Vertical;
   var
      cx, cy: Integer;
      canvas_x: Integer;
      yr: ValReal;
      canvas_yr: Integer;
   begin
        cx:= _C.Width  div 2;
        cy:= _C.Height div 2;
        canvas_x:= cx+round(_Scale*Vertical_x);
        yr:= segment/2;
        canvas_yr:= round(_Scale*yr);
        _C.Line( canvas_x, cy-canvas_yr,
                 canvas_x, cy+canvas_yr);
   end;
   procedure Traite_non_Vertical;
   var
      canvas_dx, canvas_dy: Integer;
      cx, cy: Integer;
      xr: ValReal;
      canvas_xr: Integer;
      x1, y1, x2, y2: Integer;
   begin
        cx:= _C.Width  div 2;
        cy:= _C.Height div 2;
        canvas_dx:= cx+round(_Scale*dx);
        canvas_dy:= cy-round(_Scale*dy);

        //xr:= (_C.Width/_Scale)/2;
        xr:= (segment/2)*cos_angle_droite;
        canvas_xr:= round(xr*_Scale);
        x1:= canvas_dx-canvas_xr;
        y1:= cy+round(-_Scale*y(dx-xr));
        x2:= canvas_dx+canvas_xr;
        y2:= cy+round(-_Scale*y(dx+xr));
        //Circle( _C, x1, y1, 2);
        _C.Line( x1, y1, x2, y2);
        //_C.Pen.Color:= clLime;
        //Circle( _C, canvas_dx, canvas_dy, 3);

   end;
begin
     _C.Pen.Color:= Color;
     if Vertical
     then
         Traite_Vertical
     else
         Traite_non_Vertical;

end;

{ TCarre }

constructor TCarre.Create;
begin
     D1:= TAffine.Create;
     D2:= TAffine.Create;
     D3:= TAffine.Create;
     D4:= TAffine.Create;

     {
     D1.Color:= clRed  ;
     D2.Color:= $000808;
     D3.Color:= clGreen;
     D4.Color:= clBlue ;
     }
     D1.Color:= clRed  ;
     D2.Color:= clRed  ;
     D3.Color:= clRed  ;
     D4.Color:= clRed  ;
end;

destructor TCarre.Destroy;
begin
     FreeAndNil(D1);
     FreeAndNil(D2);
     FreeAndNil(D3);
     FreeAndNil(D4);
     inherited Destroy;
end;

procedure TCarre.Init(_s: ValReal);
begin
     s:= _s;
     a:= Carre_a_from_s( s);
     a2:= a/2;

     D1.Init( +3*PI/4, a2, a);
     D2.Init( +  PI/4, a2, a);
     D3.Init( -  PI/4, a2, a);
     D4.Init( -3*PI/4, a2, a);
end;

procedure TCarre.Draw( _C: TCanvas; _Scale: ValReal);
begin
     D1.Draw( _C, _Scale);
     D2.Draw( _C, _Scale);
     D3.Draw( _C, _Scale);
     D4.Draw( _C, _Scale);
end;


{ TRectangle }

constructor TRectangle.Create;
begin
     D1:= TAffine.Create;
     D2:= TAffine.Create;
     D3:= TAffine.Create;
     D4:= TAffine.Create;

     {
     D1.Color:= clRed  ;
     D2.Color:= $000808;
     D3.Color:= clGreen;
     D4.Color:= clBlue ;
     }
     D1.Color:= clBlue ;
     D2.Color:= clBlue ;
     D3.Color:= clBlue ;
     D4.Color:= clBlue ;
end;

destructor TRectangle.Destroy;
begin
     FreeAndNil(D1);
     FreeAndNil(D2);
     FreeAndNil(D3);
     FreeAndNil(D4);
     inherited Destroy;
end;

procedure TRectangle.Init(_a, _b: ValReal);
begin
     a:= _a;
     b:= _b;
     s:= a*b;
     a2:= a/2;
     b2:= b/2;

     D1.Init( +3*PI/4, a2, b);
     D2.Init( +  PI/4, b2, a);
     D3.Init( -  PI/4, a2, b);
     D4.Init( -3*PI/4, b2, a);
end;

procedure TRectangle.Draw(_C: TCanvas; _Scale: ValReal);
begin
     D1.Draw( _C, _Scale);
     D2.Draw( _C, _Scale);
     D3.Draw( _C, _Scale);
     D4.Draw( _C, _Scale);
end;

{ TTriangle }

constructor TTriangle.Create;
begin
     D1:= TAffine.Create;
     D2:= TAffine.Create;
     D3:= TAffine.Create;

     {
     D1.Color:= clRed  ;
     D2.Color:= clGreen;
     D3.Color:= clBlue ;
     }

     D1.Color:= $0080FF;
     D2.Color:= $0080FF;
     D3.Color:= $0080FF;
end;

destructor TTriangle.Destroy;
begin
     FreeAndNil(D1);
     FreeAndNil(D2);
     FreeAndNil(D3);
     inherited Destroy;
end;

procedure TTriangle.Init(_s: ValReal);
begin
     s:= _s;
     a:= Triangle_a_from_s( s);
     cercle_inscrit_r:= a*(sqrt(3)/6);

     D1.Init( +PI/3, cercle_inscrit_r, a);
     D2.Init( -PI/3, cercle_inscrit_r, a);
     D3.Init_Vertical( -cercle_inscrit_r, a);
end;

procedure TTriangle.Draw(_C: TCanvas; _Scale: ValReal);
begin
     D1.Draw( _C, _Scale);
     D2.Draw( _C, _Scale);
     D3.Draw( _C, _Scale);
end;

end.

