unit uDessin;
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
    Windows, SysUtils, Graphics, Types;

procedure Dessinne_Coche( Canvas: TCanvas;
                          CouleurFond, CouleurCoche: TColor;
                          R: TRect;
                          Coche: Boolean);

procedure Dessinne_X( Canvas: TCanvas;
                      CouleurFond, CouleurCoche: TColor;
                      R: TRect;
                      X: Boolean);

procedure Dessinne_Coche_X( Canvas: TCanvas;
                      CouleurFond, CouleurCoche: TColor;
                      R: TRect;
                      Coche_X, Coche, X: String);

procedure FrameRect_0( C: TCanvas; R: TRect);
                      
implementation

procedure Dessinne_Coche( Canvas: TCanvas;
                          CouleurFond, CouleurCoche: TColor;
                          R: TRect;
                          Coche: Boolean);
var
   W, H, W3, H3, W5, H5: Integer;
   OldPenWidth: Integer;
   OldColor: TColor;
   procedure WH_from_R;
   begin
        W:= R.Right  - R.Left;
        H:= R.Bottom - R.Top ;

        W3:= W div 3;
        H3:= H div 3;

        W5:= W div 5;
        H5:= H div 5;
   end;
begin
     with Canvas
     do
       begin
       OldColor:= Brush.Color;
       Brush.Color:= CouleurFond;
       FillRect( R);
       Brush.Color:= OldColor;
       if Coche
       then
           begin
           OldPenWidth:= Pen.Width;
           OldColor   := Pen.Color;

           // on rétrécit R de 1/5
           WH_from_R;
           InflateRect( R, -W5, -H5);
           WH_from_R;

           Pen.Color:= CouleurCoche;
           MoveTo( R.Left, R.Top+H3);

           Pen.Width:= 1;
           LineTo( R.Left+W3, R.Bottom);

           Pen.Width:= 2;
           LineTo( R.Right, R.Top);

           Pen.Color:= OldColor;
           Pen.Width:= OldPenWidth;
           end;
       end;
end;

procedure Dessinne_X( Canvas: TCanvas;
                      CouleurFond, CouleurCoche: TColor;
                      R: TRect;
                      X: Boolean);
var
   W, H, W3, H3, W5, H5: Integer;
   OldPenWidth: Integer;
   OldColor: TColor;
   procedure WH_from_R;
   begin
        W:= R.Right  - R.Left;
        H:= R.Bottom - R.Top ;

        W3:= W div 3;
        H3:= H div 3;

        W5:= W div 5;
        H5:= H div 5;
   end;
begin
     with Canvas
     do
       begin
       OldColor:= Brush.Color;
       Brush.Color:= CouleurFond;
       FillRect( R);
       Brush.Color:= OldColor;
       if X
       then
           begin
           OldPenWidth:= Pen.Width;
           OldColor   := Pen.Color;

           // on rétrécit R de 1/5
           WH_from_R;
           InflateRect( R, -W5, -H5);
           WH_from_R;

           Pen.Color:= CouleurCoche;
           Pen.Width:= 2;
           MoveTo( R.Left , R.Top   );
           LineTo( R.Right, R.Bottom);

           MoveTo( R.Right, R.Top   );
           LineTo( R.Left , R.Bottom);

           Pen.Color:= OldColor;
           Pen.Width:= OldPenWidth;
           end;
       end;
end;

procedure Dessinne_Coche_X( Canvas: TCanvas;
                      CouleurFond, CouleurCoche: TColor;
                      R: TRect;
                      Coche_X, Coche, X: String);
begin
     if Coche = Coche_X
     then
         Dessinne_Coche( Canvas, CouleurFond, CouleurCoche, R, True)
     else
         Dessinne_X( Canvas, CouleurFond, CouleurCoche, R, X = Coche_X);
end;

procedure FrameRect_0( C: TCanvas; R: TRect);
var
   P: array[0..4] of TPoint;
   OldPenWidth: Integer;
begin
     P[0]:= R.TopLeft;
     P[1]:= Point( R.Right, R.Top);
     P[2]:= R.BottomRight;
     P[3]:= Point( R.Left, R.Bottom);
     P[4]:= P[0];
     OldPenWidth  := C.Pen.Width;
     try
        C.Pen.Width:= 0;
        C.Polyline( P);
     finally
            C.Pen.Width  := OldPenWidth;
            end;
end;

end.
