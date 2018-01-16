unit ucBatpro_Shape;
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            partly as freelance: http://www.mars42.com                          |
        and partly as employee : http://www.adinfo.com                          |
                                 http://www.adi-bat.com                         |
    Copyright 2017 Jean SUZINEAU - MARS42                                       |
    Copyright 2017 GROUPE ADINFO SOFTWARE                                       |
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
    along with this program.  If not, see <http://www.gnu.org/licenses/>.       |
                                                                                |
|                                                                               }

interface

uses
  SysUtils, Classes, FMX.Controls, FMX.ExtCtrls, Types, FMX.Graphics, FMX.Objects,
  System.Math.Vectors;

type
 TBatpro_ShapeType
 =
  (
   bstRectangle,
   bstSquare,
   bstRoundRect,
   bstRoundSquare,
   bstEllipse,
   bstCircle,
   bstCursor);

 TBatpro_Shape
 =
  class(TShape)
  //Forme
  private
    FBatpro_Shape: TBatpro_ShapeType;
    procedure SetBatpro_Shape(Value: TBatpro_ShapeType);
  published
    property Batpro_Shape: TBatpro_ShapeType
             read    FBatpro_Shape
             write   SetBatpro_Shape
             default bstCursor;
  //Dessin
  protected
    procedure Paint; override;
  end;

procedure Register;

implementation

procedure Register;
begin
     RegisterComponents('Batpro', [TBatpro_Shape]);
end;

{ TBatpro_Shape }

procedure TBatpro_Shape.Paint;
var
   X, Y, W, H, S: Single;
   P: TPolygon;
begin
     with Canvas
     do
       begin
       Stroke.Assign( Self.Stroke);
       Fill := Self.Fill;
       X := Stroke.Thickness / 2;
       Y := X;
       W := Width - Stroke.Thickness + 1;
       H := Height - Stroke.Thickness + 1;
       if Stroke.Thickness = 0
       then
           begin
           W:= W-1;
           H:= H-1;
           end;
       if W < H
       then
           S := W
       else
           S := H;
       if FBatpro_Shape in [bstSquare, bstRoundSquare, bstCircle, bstCursor]
       then
           begin
           X:= X+ (W - S) / 2;
           Y:= Y+ (H - S) / 2;
           W := S;
           H := S;
           end;
       case FBatpro_Shape
       of
         bstRectangle, bstSquare:
           //Rectangle(X, Y, X + W, Y + H);
           ;
         bstRoundRect, bstRoundSquare:
           //RoundRect(X, Y, X + W, Y + H, S div 4, S div 4);
           ;
         bstCircle, bstEllipse:
           //Ellipse(X, Y, X + W, Y + H);
           ;
         bstCursor:
           begin
           SetLength( P, 3);
           P[0]:= PointF( X  , Y        );
           P[1]:= PointF( X+W, Y+H / 2);
           P[2]:= PointF( X  , Y+H      );
           //Polygon( P);
           end;
         end;
       end;
end;

procedure TBatpro_Shape.SetBatpro_Shape(Value: TBatpro_ShapeType);
begin
     if FBatpro_Shape <> Value
     then
         begin
         FBatpro_Shape:= Value;
         //Invalidate;
         end;
end;

end.
