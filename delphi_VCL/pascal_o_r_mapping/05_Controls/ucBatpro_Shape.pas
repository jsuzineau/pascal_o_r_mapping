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
  SysUtils, Classes, VCL.Controls, VCL.ExtCtrls, Types, VCL.Graphics,
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
   X, Y, W, H, S: Integer;
   P: array of TPoint;
   PenWidth:Integer;
begin
     Canvas.Pen  := Self.Pen;
     Canvas.Brush:= Self.Brush;
     PenWidth:= Canvas.Pen.Width;
     X := PenWidth div 2;
     Y := X;
     W := Width - PenWidth + 1;
     H := Height - PenWidth + 1;
     if PenWidth = 0
     then
         begin
         Dec(W);
         Dec(H);
         end;
     if W < H
     then
         S := W
     else
         S := H;
     if FBatpro_Shape in [bstSquare, bstRoundSquare, bstCircle, bstCursor]
     then
         begin
         Inc(X, (W - S) div 2);
         Inc(Y, (H - S) div 2);
         W := S;
         H := S;
         end;
     case FBatpro_Shape
     of
       bstRectangle, bstSquare:
         Canvas.Rectangle(X, Y, X + W, Y + H);
       bstRoundRect, bstRoundSquare:
         Canvas.RoundRect(X, Y, X + W, Y + H, S div 4, S div 4);
       bstCircle, bstEllipse:
         Canvas.Ellipse(X, Y, X + W, Y + H);
       bstCursor:
         begin
         SetLength( P, 3);
         P[0]:= Point( X  , Y        );
         P[1]:= Point( X+W, Y+H div 2);
         P[2]:= Point( X  , Y+H      );
         Canvas.Polygon( P);
         end;
       end;
end;

procedure TBatpro_Shape.SetBatpro_Shape(Value: TBatpro_ShapeType);
begin
     if FBatpro_Shape <> Value
     then
         begin
         FBatpro_Shape:= Value;
         Invalidate;
         end;
end;

end.
