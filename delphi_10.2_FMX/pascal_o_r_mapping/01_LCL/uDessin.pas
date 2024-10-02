﻿unit uDessin;
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
    Windows, SysUtils, FMX.Graphics, Types, System.Math.Vectors, System.UITypes;

procedure Dessinne_Coche( Canvas: TCanvas;
                          CouleurFond, CouleurCoche: TColor;
                          R: TRectF;
                          Coche: Boolean);

procedure Dessinne_X( Canvas: TCanvas;
                      CouleurFond, CouleurCoche: TColor;
                      R: TRectF;
                      X: Boolean);

procedure Dessinne_Coche_X( Canvas: TCanvas;
                      CouleurFond, CouleurCoche: TColor;
                      R: TRectF;
                      Coche_X, Coche, X: String);

procedure FrameRect_0( C: TCanvas; R: TRectF);

implementation

procedure Dessinne_Coche( Canvas: TCanvas;
                          CouleurFond, CouleurCoche: TColor;
                          R: TRectF;
                          Coche: Boolean);
var
   W, H, W3, H3, W5, H5: Single;
   OldPenWidth: Single;
   OldColor: TColor;
   P1, P2, P3: TPointF;
   procedure WH_from_R;
   begin
        W:= R.Right  - R.Left;
        H:= R.Bottom - R.Top ;

        W3:= W / 3;
        H3:= H / 3;

        W5:= W / 5;
        H5:= H / 5;
   end;
begin
     with Canvas
     do
       begin
       OldColor:= Fill.Color;
       Fill.Color:= CouleurFond;
       FillRect( R, 0, 0, [], 1);
       Fill.Color:= OldColor;
       if Coche
       then
           begin
           OldPenWidth:= Stroke.Thickness;
           OldColor   := Stroke.Color;

           // on rétrécit R de 1/5
           WH_from_R;
           InflateRect( R, -W5, -H5);
           WH_from_R;

           P1:= PointF( R.Left   , R.Top   +H3);
           P2:= PointF( R.Left+W3, R.Bottom   );
           P3:= PointF( R.Right  , R.Top      );
           Stroke.Color:= CouleurCoche;

           Stroke.Thickness:= 1;
           DrawLine( P1, P2, 1);

           Stroke.Thickness:= 2;
           DrawLine( P2, P3, 1);

           Stroke.Color:= OldColor;
           Stroke.Thickness:= OldPenWidth;
           end;
       end;
end;

procedure Dessinne_X( Canvas: TCanvas;
                      CouleurFond, CouleurCoche: TColor;
                      R: TRectF;
                      X: Boolean);
var
   W, H, W3, H3, W5, H5: Single;
   OldPenWidth: Single;
   OldColor: TColor;
   procedure WH_from_R;
   begin
        W:= R.Right  - R.Left;
        H:= R.Bottom - R.Top ;

        W3:= W / 3;
        H3:= H / 3;

        W5:= W / 5;
        H5:= H / 5;
   end;
begin
     with Canvas
     do
       begin
       OldColor:= Fill.Color;
       Fill.Color:= CouleurFond;
       FillRect( R, 0, 0, [], 1);
       Fill.Color:= OldColor;
       if X
       then
           begin
           OldPenWidth:= Stroke.Thickness;
           OldColor   := Stroke.Color;

           // on rétrécit R de 1/5
           WH_from_R;
           InflateRect( R, -W5, -H5);
           WH_from_R;

           Stroke.Color:= CouleurCoche;
           Stroke.Thickness:= 2;

           DrawLine( PointF( R.Left , R.Top),PointF( R.Right, R.Bottom), 1);
           DrawLine( PointF( R.Right, R.Top),PointF( R.Left , R.Bottom), 1);

           Stroke.Color:= OldColor;
           Stroke.Thickness:= OldPenWidth;
           end;
       end;
end;

procedure Dessinne_Coche_X( Canvas: TCanvas;
                      CouleurFond, CouleurCoche: TColor;
                      R: TRectF;
                      Coche_X, Coche, X: String);
begin
     if Coche = Coche_X
     then
         Dessinne_Coche( Canvas, CouleurFond, CouleurCoche, R, True)
     else
         Dessinne_X( Canvas, CouleurFond, CouleurCoche, R, X = Coche_X);
end;

procedure FrameRect_0( C: TCanvas; R: TRectF);
var
   P: TPolygon;
   OldPenWidth: Single;
begin
     P[0]:= R.TopLeft;
     P[1]:= PointF( R.Right, R.Top);
     P[2]:= R.BottomRight;
     P[3]:= PointF( R.Left, R.Bottom);
     P[4]:= P[0];
     OldPenWidth  := C.Stroke.Thickness;
     try
        C.Stroke.Thickness:= 0;
        C.DrawPolygon( P, 1);
     finally
            C.Stroke.Thickness  := OldPenWidth;
            end;
end;

end.
