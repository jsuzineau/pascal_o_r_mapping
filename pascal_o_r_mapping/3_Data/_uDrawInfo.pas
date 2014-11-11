unit uDrawInfo;
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            partly as freelance: http://www.mars42.com                          |
        and partly as employee : http://www.batpro.com                          |
    Contact: gilles.doutre@batpro.com                                           |
                                                                                |
    Copyright 2014 Jean SUZINEAU - MARS42                                       |
    Copyright 2014 Cabinet Gilles DOUTRE - BATPRO                               |
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
    {$IFNDEF FPC}
    DOM,
    {$ELSE}
    DOM,
    {$ENDIF}
    uSVG,
    {$IFNDEF FPC}
    ufBitmaps,
    {$ENDIF}
  SysUtils, Classes, Windows, Graphics, Types, Grids, Controls,XMLRead,XMLWrite;

const
     {$IFDEF FPC}
     clBlack = TColor($000000);
     clMaroon = TColor($000080);
     clGreen = TColor($008000);
     clOlive = TColor($008080);
     clNavy = TColor($800000);
     clPurple = TColor($800080);
     clTeal = TColor($808000);
     clGray = TColor($808080);
     clSilver = TColor($C0C0C0);
     clRed = TColor($0000FF);
     clLime = TColor($00FF00);
     clYellow = TColor($00FFFF);
     clBlue = TColor($FF0000);
     clFuchsia = TColor($FF00FF);
     clAqua = TColor($FFFF00);
     clLtGray = TColor($C0C0C0);
     clDkGray = TColor($808080);
     clWhite = TColor($FFFFFF);
     StandardColorsCount = 16;

     clMoneyGreen = TColor($C0DCC0);
     clSkyBlue = TColor($F0CAA6);
     clCream = TColor($F0FBFF);
     clMedGray = TColor($A4A0A0);
     ExtendedColorsCount = 4;

     clNone = TColor($1FFFFFFF);
     clDefault = TColor($20000000);

     clBtnFace=clMedGray;
     clWindow=clWhite;
     clInfoBk=$FFFF80;
     {$ENDIF}

     Couleur_Jour_Non_Ouvrable_1_2     =  clLtGray ;
     Couleur_Jour_Non_Ouvrable_3       = clMedGray;
     Couleur_Jour_Non_Ouvrable_Chantier=  clDkGray ;

{$IFDEF FPC}
type
 TStringGrid= TObject;
 TPenStyle=TObject;
 TFont
 =
  class
    Name: String;
    Size: Integer;
    procedure Assign( _Source: TFont);
  end;
 TBrushStyle=TObject;

 { TBrush }

 TBrush
 =
  class
    //Gestion du cycle de vie
    public
      constructor Create;
      destructor Destroy; override;
    //Attributs
    public
      Color: Integer;
  end;

 { TPen }

 TPen
 =
  class
    //Gestion du cycle de vie
    public
      constructor Create;
      destructor Destroy; override;
    //Attributs
    public
      Style: Integer;
  end;

 { TCanvas }

 TCanvas
 =
  class
  //Gestion du cycle de vie
  public
    constructor Create;
    destructor Destroy; override;
  //Attributs
  public
    Handle: Integer;
    Font: TFont;
  end;
{$ENDIF}

type
 TDrawInfo
 =
  class
  //Gestion du cycle de vie
  public
    constructor Create(unContexte: Integer; _sg: TStringGrid);
  //attributs
  public
    sg: TStringGrid;
    Contexte: Integer;
  //Draw
  public
    Canvas: TCanvas;
    Col, Row: Integer;
    Rect_Original: TRect; //pour échapper au bornage de la hauteur dans planning production
    Rect: TRect;
    Impression: Boolean;
    procedure Init_Draw( _Canvas: TCanvas; _Col, _Row: Integer; _Rect: TRect;
                         _Impression: Boolean);
  //Cell
  public
    Fixe: Boolean;
    Fond: TColor;
    procedure Init_Cell( _Fixe, _Gris: Boolean);
  //Gestion des jours non ouvrables
  public
    Couleur_Jour_Non_Ouvrable: TColor;
    Gris: Boolean;
  //SVG
  public
    SVG_Drawing: Boolean;
    svg: TSVGDocument;
    eCell: TDOMNode;
    procedure Init_SVG( _svg: TSVGDocument; _eCell: TDOMNode);
    function _rect( _R: TRect;
                   _Color: TColor;
                   _Pen_Color: TColor;
                   _Pen_Width: Integer): TDOMNode;
    function rect_pattern( _R: TRect;
                           _pattern: String;
                           _Pen_Color: TColor;
                           _Pen_Width: Integer): TDOMNode;
    function rect_hachures_slash( _R: TRect;
                                  _Pen_Color: TColor;
                                  _Pen_Width: Integer): TDOMNode;
    function rect_hachures_backslash( _R: TRect;
                                      _Pen_Color: TColor;
                                      _Pen_Width: Integer): TDOMNode;
    function rect_uni( _R: TRect; _Color: TColor): TDOMNode;
    function rect_vide( _R: TRect;
                        _Pen_Color: TColor;
                        _Pen_Width: Integer): TDOMNode;
    function _ellipse( _R: TRect;
                   _Color: TColor;
                   _Pen_Color: TColor;
                   _Pen_Width: Integer): TDOMNode;
    function text( _X, _Y: Integer;
                   _Text, _Font_Family: String;
                   _Font_Size: Integer;
                   _Font_Family_Generic: String = 'sans-serif'): TDOMNode;
    function text_a_Gauche(
                   _X, _Y: Integer;
                   _Text, _Font_Family: String;
                   _Font_Size: Integer;
                   _Font_Family_Generic: String = 'sans-serif'): TDOMNode;
    function text_au_Milieu(
                   _X, _Y: Integer;
                   _Text, _Font_Family: String;
                   _Font_Size: Integer;
                   _Font_Family_Generic: String = 'sans-serif'): TDOMNode;
    function text_a_Droite(
                   _X, _Y: Integer;
                   _Text, _Font_Family: String;
                   _Font_Size: Integer;
                   _Font_Family_Generic: String = 'sans-serif'): TDOMNode;
    function text_rotate( _X, _Y: Integer;
                          _Text, _Font_Family: String;
                          _Font_Size: Integer;
                          _Rotate: Integer): TDOMNode;
    function line( _x1, _y1, _x2, _y2: Integer;
                   _stroke: TColor;
                   _stroke_width: Integer): TDOMNode;
    function line_dash( _x1, _y1, _x2, _y2: Integer;
                        _stroke: TColor;
                        _stroke_width: Integer): TDOMNode;
    function svg_polygon( _points: array of TPoint;
                      _Color: TColor;
                      _Pen_Color: TColor;
                      _Pen_Width: Integer): TDOMNode;
    function svg_PolyBezier( _points: array of TPoint;
                         _Pen_Color: TColor;
                         _Pen_Width: Integer): TDOMNode;
    function image( _x, _y, _width, _height: Integer;
                    _xlink_href: String): TDOMNode;
    function image_from_id( _x, _y, _width, _height: Integer;
                            _idImage: String): TDOMNode;
    function image_DOCSINGL( _x, _y: Integer): TDOMNode;
    function image_LOSANGE ( _x, _y: Integer): TDOMNode;
    function image_LOGIN   ( _x, _y: Integer): TDOMNode;

    function image_from_id_centre( _width, _height: Integer;
                                       _idImage: String): TDOMNode;
    function svg_image_DOCSINGL_centre: TDOMNode;
    function svg_image_LOSANGE__centre: TDOMNode;
    function svg_image_LOGIN__centre: TDOMNode;
    function svg_image_MEN_AT_WORK__centre: TDOMNode;
    function svg_image_DOSSIER_KDE_PAR_POSTE__centre: TDOMNode;

    function image_from_id_bas_droite( _width, _height: Integer;
                                       _idImage: String): TDOMNode;
    function svg_image_DOCSINGL_bas_droite: TDOMNode;
    function image_LOSANGE__bas_droite: TDOMNode;
    function svg_image_LOGIN__bas_droite: TDOMNode;
    procedure svgDessinne_Coche( _CouleurFond, _CouleurCoche: TColor;
                                 _Coche: Boolean);
  //Méthodes
  public
    procedure Borne_Hauteur;
  //abstraction SVG /Canvas
  private
    XTortue, YTortue: Integer;//graphiques tortue, point courant MoveTo/LineTo
    FCouleurLigne: TColor;
    FCouleur_Brosse: TColor;
    FLargeurLigne: Integer;
    FStyleLigne: TPenStyle;
    procedure SetCouleurLigne(const Value: TColor);
    procedure SetCouleur_Brosse(const Value: TColor);
    procedure SetLargeurLigne(const Value: Integer);
    procedure SetStyleLigne(const Value: TPenStyle);
  public
    property CouleurLigne: TColor read FCouleurLigne write SetCouleurLigne;
    property Couleur_Brosse: TColor read FCouleur_Brosse write SetCouleur_Brosse;
    property LargeurLigne: Integer read FLargeurLigne write SetLargeurLigne;
    property StyleLigne: TPenStyle read FStyleLigne write SetStyleLigne;
    procedure MoveTo( X, Y: Integer);
    procedure LineTo( X, Y: Integer);
    procedure Contour_Rectangle( _R: TRect; _Couleur: TColor);
    procedure Remplit_Rectangle( _R: TRect; _Couleur: TColor);
    procedure Rectangle( X1, Y1, X2, Y2: Integer); overload;
    procedure Rectangle( _R: TRect); overload;
    procedure Ellipse( X1, Y1, X2, Y2: Integer);
    procedure Polygon(const Points: array of TPoint);
    procedure PolyBezier(const Points: array of TPoint);
    procedure image_DOCSINGL_bas_droite( _Couleur_Fond: TColor);
    procedure image_DOCSINGL_centre( _Couleur_Fond: TColor);
    procedure image_LOSANGE__centre( _Couleur_Fond: TColor);

    procedure image_LOGIN__centre( _Couleur_Fond: TColor);
    procedure image_LOGIN_bas_droite(_Couleur_Fond: TColor);

    procedure image_MEN_AT_WORK__centre( _Couleur_Fond: TColor);
    procedure image_DOSSIER_KDE_PAR_POSTE__centre( _Couleur_Fond: TColor);
  end;

implementation

constructor TDrawInfo.Create( unContexte: Integer; _sg: TStringGrid);
begin
     Contexte:= unContexte;
     sg:= _sg;
end;

procedure TDrawInfo.Init_Draw( _Canvas: TCanvas; _Col, _Row: Integer;
                               _Rect: TRect; _Impression: Boolean);
begin
    Canvas    := _Canvas     ;
    Col       := _Col        ;
    Row       := _Row        ;
    Rect      := _Rect       ;
    Impression:= _Impression;
    Fond      := clWhite;

    Rect_Original:= Rect;

    SVG_Drawing:= False;
    FLargeurLigne:= 1;
    FCouleurLigne  := Canvas.Pen  .Color;
    FCouleur_Brosse:= Canvas.Brush.Color;
    FStyleLigne    := Canvas.Pen  .Style; 
end;

procedure TDrawInfo.Init_Cell( _Fixe, _Gris: Boolean);
begin
    Fixe:= _Fixe;
    Gris:= _Gris;
    Couleur_Jour_Non_Ouvrable:= Couleur_Jour_Non_Ouvrable_1_2;
end;

procedure TDrawInfo.Borne_Hauteur;
begin                   // on garde Rect_Original pour dessinner le fond
     if Rect.Bottom - Rect.Top > 20
     then
     //    Rect.Top:= Rect.Bottom - 20;
         Rect.Bottom:=  Rect.Top+ 20;
end;

procedure TDrawInfo.Init_SVG( _svg: TSVGDocument; _eCell: TDOMNode);
begin
     svg  := _svg;
     eCell:= _eCell;
     SVG_Drawing:= Assigned( svg);
end;

function TDrawInfo._rect( _R: TRect; _Color: TColor;
                          _Pen_Color: TColor;
                          _Pen_Width: Integer): TDOMNode;
begin
     Result:= svg.rect( eCell, _R, _Color, _Pen_Color, _Pen_Width);
end;

function TDrawInfo.rect_pattern( _R: TRect; _pattern: String;
                                 _Pen_Color: TColor;
                                 _Pen_Width: Integer): TDOMNode;
begin
     Result:= svg.rect_pattern( eCell, _R, _pattern, _Pen_Color, _Pen_Width);
end;

function TDrawInfo.rect_hachures_slash( _R: TRect;
                                        _Pen_Color: TColor;
                                        _Pen_Width: Integer): TDOMNode;
begin
     Result:= rect_pattern( _R, 'Hachures_Slash', _Pen_Color, _Pen_Width);
end;

function TDrawInfo.rect_hachures_backslash( _R: TRect;
                                            _Pen_Color: TColor;
                                            _Pen_Width: Integer): TDOMNode;
begin
     Result:= rect_pattern( _R, 'Hachures_BackSlash', _Pen_Color, _Pen_Width);
end;

function TDrawInfo.rect_uni(_R: TRect; _Color: TColor): TDOMNode;
begin
     Result:= _rect( _R, _Color, _Color, 1);
end;

function TDrawInfo.rect_vide( _R: TRect;
                              _Pen_Color: TColor;
                              _Pen_Width: Integer): TDOMNode;
begin
     Result:= svg.rect_vide( eCell, _R, _Pen_Width, _Pen_Color);
end;

function TDrawInfo._ellipse( _R: TRect;
                             _Color, _Pen_Color: TColor;_Pen_Width: Integer): TDOMNode;
begin
     Result:= svg.ellipse( eCell, _R, _Color, _Pen_Color, _Pen_Width);
end;

function TDrawInfo.text( _X, _Y: Integer;
                         _Text, _Font_Family: String;
                         _Font_Size: Integer;
                         _Font_Family_Generic: String): TDOMNode;
begin
     Result:= svg.text( eCell, _X, _Y, _Text, _Font_Family, _Font_Size, _Font_Family_Generic);
end;

function TDrawInfo.text_a_Gauche( _X, _Y: Integer;
                         _Text, _Font_Family: String;
                         _Font_Size: Integer;
                         _Font_Family_Generic: String): TDOMNode;
begin
     Result:= svg.text_a_Gauche( eCell, _X, _Y, _Text, _Font_Family, _Font_Size, _Font_Family_Generic);
end;

function TDrawInfo.text_au_Milieu( _X, _Y: Integer;
                         _Text, _Font_Family: String;
                         _Font_Size: Integer;
                         _Font_Family_Generic: String): TDOMNode;
begin
     Result:= svg.text_au_Milieu( eCell, _X, _Y, _Text, _Font_Family, _Font_Size, _Font_Family_Generic);
end;

function TDrawInfo.text_a_Droite( _X, _Y: Integer;
                         _Text, _Font_Family: String;
                         _Font_Size: Integer;
                         _Font_Family_Generic: String): TDOMNode;
begin
     Result:= svg.text_a_Droite( eCell, _X, _Y, _Text, _Font_Family, _Font_Size, _Font_Family_Generic);
end;

function TDrawInfo.text_rotate( _X, _Y: Integer;
                                _Text, _Font_Family: String;
                                _Font_Size, _Rotate: Integer): TDOMNode;
begin
     Result:= svg.text_rotate( eCell, _X, _Y, _Text, _Font_Family, _Font_Size, _Rotate);
end;

function TDrawInfo.line( _x1, _y1, _x2, _y2: Integer;
                         _stroke: TColor; _stroke_width: Integer): TDOMNode;
begin
     Result:= svg.line( eCell, _x1, _y1, _x2, _y2, _stroke, _stroke_width);
end;

function TDrawInfo.line_dash( _x1, _y1, _x2, _y2: Integer;
                              _stroke: TColor; _stroke_width: Integer): TDOMNode;
begin
     Result:= svg.line_dash( eCell, _x1, _y1, _x2, _y2, _stroke, _stroke_width);
end;

function TDrawInfo.svg_polygon( _points: array of TPoint;
                            _Color: TColor;
                            _Pen_Color: TColor;
                            _Pen_Width: Integer): TDOMNode;
begin
     Result:= svg.polygon( eCell, _points, _Color, _Pen_Color, _Pen_Width)
end;

function TDrawInfo.svg_PolyBezier( _points: array of TPoint;
                               _Pen_Color: TColor;
                               _Pen_Width: Integer): TDOMNode;
begin
     Result:= svg.PolyBezier( eCell, _points, _Pen_Color, _Pen_Width);
end;

function TDrawInfo.image( _x, _y, _width, _height: Integer;
                          _xlink_href: String): TDOMNode;
begin
     Result:= svg.image( eCell, _x, _y, _width, _height, _xlink_href);
end;

function TDrawInfo.image_from_id( _x, _y, _width, _height: Integer;
                                  _idImage: String): TDOMNode;
begin
     Result:= image( _x, _y, _width, _height, 'url(#'+_idImage+')');;
end;

function TDrawInfo.image_DOCSINGL(_x, _y: Integer): TDOMNode;
begin
     Result
     :=
       image_from_id( _x, _y,
                      fBitmaps.svgDOCSINGL_width ,
                      fBitmaps.svgDOCSINGL_height,
                      fBitmaps.svgDOCSINGL_id    );
end;

function TDrawInfo.image_LOSANGE(_x, _y: Integer): TDOMNode;
begin
     Result
     :=
       image_from_id( _x, _y,
                      fBitmaps.svgLOSANGE_width ,
                      fBitmaps.svgLOSANGE_height,
                      fBitmaps.svgLOSANGE_id    );
end;

function TDrawInfo.image_LOGIN(_x, _y: Integer): TDOMNode;
begin
     Result
     :=
       image_from_id( _x, _y,
                      fBitmaps.svgLOGIN_width ,
                      fBitmaps.svgLOGIN_height,
                      fBitmaps.svgLOGIN_id    );
end;

function TDrawInfo.image_from_id_centre( _width, _height: Integer;
                                             _idImage: String): TDOMNode;
var
   dx, dy: Integer;
   R: TRect;
begin
     R:= Rect;
     dx:= (R.Right -_width -R.Left) div 2;
     dy:= (R.Bottom-_height-R.Top ) div 2;
     InflateRect( R, -dx, -dy);
     Result:= image_from_id( R.Left, R.Top, _width, _height, _idImage);
end;

function TDrawInfo.svg_image_DOCSINGL_centre: TDOMNode;
begin
     Result
     :=
       image_from_id_centre( fBitmaps.svgDOCSINGL_width ,
                                 fBitmaps.svgDOCSINGL_height,
                                 fBitmaps.svgDOCSINGL_id    );
end;

function TDrawInfo.svg_image_LOSANGE__centre: TDOMNode;
begin
     Result
     :=
       image_from_id_centre( fBitmaps.svgLOSANGE_width ,
                                 fBitmaps.svgLOSANGE_height,
                                 fBitmaps.svgLOSANGE_id    );
end;

function TDrawInfo.svg_image_LOGIN__centre: TDOMNode;
begin
     Result
     :=
       image_from_id_centre( fBitmaps.svgLOGIN_width ,
                                 fBitmaps.svgLOGIN_height,
                                 fBitmaps.svgLOGIN_id    );
end;

function TDrawInfo.svg_image_MEN_AT_WORK__centre: TDOMNode;
begin
     Result
     :=
       image_from_id_centre( fBitmaps.svgMEN_AT_WORK_width ,
                                 fBitmaps.svgMEN_AT_WORK_height,
                                 fBitmaps.svgMEN_AT_WORK_id    );
end;

function TDrawInfo.svg_image_DOSSIER_KDE_PAR_POSTE__centre: TDOMNode;
begin
     Result
     :=
       image_from_id_centre( fBitmaps.svgDOSSIER_KDE_PAR_POSTE_width ,
                                 fBitmaps.svgDOSSIER_KDE_PAR_POSTE_height,
                                 fBitmaps.svgDOSSIER_KDE_PAR_POSTE_id    );
end;

function TDrawInfo.image_from_id_bas_droite( _width, _height: Integer;
                                             _idImage: String): TDOMNode;
var
   x, y: Integer;
   R: TRect;
begin
     R:= Rect;
     x:= R.Right -_width ;
     y:= R.Bottom-_height;
     Result:= image_from_id( x, y, _width, _height, _idImage);
end;

function TDrawInfo.svg_image_DOCSINGL_bas_droite: TDOMNode;
begin
     Result
     :=
       image_from_id_bas_droite( fBitmaps.svgDOCSINGL_width ,
                                 fBitmaps.svgDOCSINGL_height,
                                 fBitmaps.svgDOCSINGL_id    );
end;

function TDrawInfo.image_LOSANGE__bas_droite: TDOMNode;
begin
     Result
     :=
       image_from_id_bas_droite( fBitmaps.svgLOSANGE_width ,
                                 fBitmaps.svgLOSANGE_height,
                                 fBitmaps.svgLOSANGE_id    );
end;

function TDrawInfo.svg_image_LOGIN__bas_droite: TDOMNode;
begin
     Result
     :=
       image_from_id_bas_droite( fBitmaps.svgLOGIN_width ,
                                 fBitmaps.svgLOGIN_height,
                                 fBitmaps.svgLOGIN_id    );
end;

procedure TDrawInfo.svgDessinne_Coche( _CouleurFond, _CouleurCoche: TColor;
                                      _Coche: Boolean);
begin
     svg.Dessinne_Coche( eCell, _CouleurFond, _CouleurCoche, Rect, _Coche);
end;

procedure TDrawInfo.SetCouleurLigne(const Value: TColor);
begin
     FCouleurLigne:= Value;
     if not SVG_Drawing
     then
         Canvas.Pen.Color:= FCouleurLigne;
end;

procedure TDrawInfo.SetCouleur_Brosse(const Value: TColor);
begin
     FCouleur_Brosse:= Value;
     if not SVG_Drawing
     then
         Canvas.Brush.Color:= FCouleur_Brosse;
end;

procedure TDrawInfo.SetLargeurLigne(const Value: Integer);
begin
     FLargeurLigne := Value;
     if not SVG_Drawing
     then
         Canvas.Pen.Width:= FLargeurLigne;
end;

procedure TDrawInfo.SetStyleLigne(const Value: TPenStyle);
begin
     FStyleLigne := Value;
     if not SVG_Drawing
     then
         Canvas.Pen.Style:= FStyleLigne;
end;

procedure TDrawInfo.MoveTo(X, Y: Integer);
begin
     if SVG_Drawing
     then
         begin
         XTortue:= X;
         YTortue:= Y;
         end
     else
         Canvas.MoveTo( X, Y);
end;

procedure TDrawInfo.LineTo(X, Y: Integer);
begin
     if SVG_Drawing
     then
         begin
         case StyleLigne
         of
           psSolid     : line     ( XTortue, YTortue, X, Y, CouleurLigne, LargeurLigne);
           psDot       : line_dash( XTortue, YTortue, X, Y, CouleurLigne, LargeurLigne);
           psDash      : line_dash( XTortue, YTortue, X, Y, CouleurLigne, LargeurLigne);
           psDashDot   : line_dash( XTortue, YTortue, X, Y, CouleurLigne, LargeurLigne);
           psDashDotDot: line_dash( XTortue, YTortue, X, Y, CouleurLigne, LargeurLigne);
           psClear     : begin end;
           else       line     ( XTortue, YTortue, X, Y, CouleurLigne, LargeurLigne);
           end;
         XTortue:= X;
         YTortue:= Y;
         end
     else
         Canvas.LineTo( X, Y);
end;

procedure TDrawInfo.Contour_Rectangle( _R: TRect; _Couleur: TColor);
begin
     if SVG_Drawing
     then
         rect_vide( _R, _Couleur, 1)
     else
         begin
         Canvas.Brush.Color:= _Couleur;
         Canvas.Brush.Style:= bsSolid;
         Canvas.FrameRect( _R);
         end;

end;

procedure TDrawInfo.Remplit_Rectangle( _R: TRect; _Couleur: TColor);
     procedure GDI;
     var
        OldColor: TColor;
     begin
          OldColor:= Canvas.Brush.Color;
          Canvas.Brush.Color:= _Couleur;
          Canvas.FillRect( _R);
          Canvas.Brush.Color:= OldColor;
     end;
begin
     if Gris
     then
         _Couleur:= Couleur_Jour_Non_Ouvrable;

     if SVG_Drawing
     then
         rect_uni( _R, _Couleur)
     else
         GDI;
end;

procedure TDrawInfo.Polygon(const Points: array of TPoint);
begin
     if SVG_Drawing
     then
         svg_polygon( Points, Couleur_Brosse, CouleurLigne, LargeurLigne)
     else
         Canvas.Polygon( Points);
end;

procedure TDrawInfo.PolyBezier(const Points: array of TPoint);
begin
     if SVG_Drawing
     then
         svg_PolyBezier( Points, CouleurLigne, LargeurLigne)
     else
         Canvas.PolyBezier( Points);
end;

procedure TDrawInfo.Rectangle(X1, Y1, X2, Y2: Integer);
begin
     if SVG_Drawing
     then
         _rect( Classes.Rect( X1, Y1, X2, Y2),
                Couleur_Brosse, CouleurLigne, LargeurLigne)
     else
         Canvas.Rectangle( X1, Y1, X2, Y2);
end;

procedure TDrawInfo.Ellipse( X1, Y1, X2, Y2: Integer);
begin
     if SVG_Drawing
     then
         _ellipse( Classes.Rect( X1, Y1, X2, Y2),
                   Couleur_Brosse, CouleurLigne, LargeurLigne)
     else
         Canvas.Ellipse( X1, Y1, X2, Y2);
end;

procedure TDrawInfo.Rectangle( _R: TRect);
begin
     Rectangle( _R.Left, _R.Top, _R.Right, _R.Bottom);
end;

procedure TDrawInfo.image_DOCSINGL_bas_droite( _Couleur_Fond: TColor);
begin
     if SVG_Drawing
     then
         svg_image_DOCSINGL_bas_droite
     else
         begin
         fBitmaps.DOCSINGL.BkColor:= _Couleur_Fond;
         fBitmaps.DOCSINGL.Draw( Canvas,
                                 Rect.Right -fBitmaps.DOCSINGL.Width -1,
                                 Rect.Bottom-fBitmaps.DOCSINGL.Height-1,
                                 0);
         end;
end;

procedure TDrawInfo.image_DOCSINGL_centre( _Couleur_Fond: TColor);
   procedure GDI;
   var
      ImageList: TImageList;
      dx, dy: Integer;
      R: TRect;
   begin
        ImageList:= fBitmaps.DOCSINGL;
        R:= Rect;
        dx:= (R.Right -ImageList.Width -R.Left) div 2;
        dy:= (R.Bottom-ImageList.Height-R.Top ) div 2;
        InflateRect( R, -dx, -dy);

        ImageList.BkColor:= _Couleur_Fond;
        ImageList.Draw( Canvas, R.Left, R.Top, 0);
   end;
begin
     if SVG_Drawing
     then
         svg_image_DOCSINGL_centre
     else
         GDI;
end;

procedure TDrawInfo.image_LOSANGE__centre(_Couleur_Fond: TColor);
   procedure GDI;
   var
      ImageList: TImageList;
      dx, dy: Integer;
      R: TRect;
   begin
        ImageList:= fBitmaps.LOSANGE;
        R:= Rect;
        dx:= (R.Right -ImageList.Width -R.Left) div 2;
        dy:= (R.Bottom-ImageList.Height-R.Top ) div 2;
        InflateRect( R, -dx, -dy);

        ImageList.BkColor:= _Couleur_Fond;
        ImageList.Draw( Canvas, R.Left, R.Top, 0);
   end;
begin
     if SVG_Drawing
     then
         svg_image_LOSANGE__centre
     else
         GDI;
end;

procedure TDrawInfo.image_LOGIN__centre(_Couleur_Fond: TColor);
   procedure GDI;
   var
      ImageList: TImageList;
      dx, dy: Integer;
      R: TRect;
   begin
        ImageList:= fBitmaps.LOGIN;
        R:= Rect;
        dx:= (R.Right -ImageList.Width -R.Left) div 2;
        dy:= (R.Bottom-ImageList.Height-R.Top ) div 2;
        InflateRect( R, -dx, -dy);

        ImageList.BkColor:= _Couleur_Fond;
        ImageList.Draw( Canvas, R.Left, R.Top, 0);
   end;
begin
     if SVG_Drawing
     then
         svg_image_LOGIN__centre
     else
         GDI;
end;

procedure TDrawInfo.image_LOGIN_bas_droite( _Couleur_Fond: TColor);
begin
     if SVG_Drawing
     then
         svg_image_LOGIN__bas_droite
     else
         begin
         fBitmaps.LOGIN.BkColor:= _Couleur_Fond;
         fBitmaps.LOGIN.Draw( Canvas,
                                 Rect.Right -fBitmaps.LOGIN.Width -1,
                                 Rect.Bottom-fBitmaps.LOGIN.Height-1,
                                 0);
         end;
end;

procedure TDrawInfo.image_MEN_AT_WORK__centre(_Couleur_Fond: TColor);
   procedure GDI;
   var
      ImageList: TImageList;
      dx, dy: Integer;
      R: TRect;
   begin
        ImageList:= fBitmaps.MEN_AT_WORK;
        R:= Rect;
        dx:= (R.Right -ImageList.Width -R.Left) div 2;
        dy:= (R.Bottom-ImageList.Height-R.Top ) div 2;
        InflateRect( R, -dx, -dy);

        ImageList.BkColor:= _Couleur_Fond;
        ImageList.Draw( Canvas, R.Left, R.Top, 0);
   end;
begin
     if SVG_Drawing
     then
         svg_image_MEN_AT_WORK__centre
     else
         GDI;
end;

procedure TDrawInfo.image_DOSSIER_KDE_PAR_POSTE__centre(_Couleur_Fond: TColor);
   procedure GDI;
   var
      ImageList: TImageList;
      dx, dy: Integer;
      R: TRect;
   begin
        ImageList:= fBitmaps.DOSSIER_KDE_PAR_POSTE;
        R:= Rect;
        dx:= (R.Right -ImageList.Width -R.Left) div 2;
        dy:= (R.Bottom-ImageList.Height-R.Top ) div 2;
        InflateRect( R, -dx, -dy);

        ImageList.BkColor:= _Couleur_Fond;
        ImageList.Draw( Canvas, R.Left, R.Top, 0);
   end;
begin
     if SVG_Drawing
     then
         svg_image_DOSSIER_KDE_PAR_POSTE__centre
     else
         GDI;
end;

{$IFDEF FPC}
{ TFont }

procedure TFont.Assign( _Source: TFont);
begin
     if _Source= nil then exit;

     Name:= _Source.Name;
     Size:= _Source.Size;
end;

{$ENDIF}
end.

