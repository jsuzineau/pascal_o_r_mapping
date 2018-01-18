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
    {$IF DEFINED(MSWINDOWS) AND NOT DEFINED(FPC)}
    Xml.XMLIntf,
    {$ELSE}
    DOM,
    {$IFEND}
    uSVG,
    {$IF DEFINED(MSWINDOWS) AND NOT DEFINED(FPC)}
    ufBitmaps,
    {$IFEND}
  {$IF DEFINED(MSWINDOWS) AND NOT DEFINED(FPC)}
  FMX.Graphics, Windows, Types, FMX.Grid, FMX.Controls,
  {$ELSE}
  XMLRead,XMLWrite,
  {$IFEND}
  System.UITypes,
  System.Math.Vectors,FMX.ImgList,
  SysUtils, Classes;
const
     Couleur_Jour_Non_Ouvrable_1_2     =  TColorRec.LtGray ;
     Couleur_Jour_Non_Ouvrable_3       =  TColorRec.MedGray;
     Couleur_Jour_Non_Ouvrable_Chantier=  TColorRec.DkGray ;

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
    eCell: IXMLNode;
    procedure Init_SVG( _svg: TSVGDocument; _eCell: IXMLNode);
    function _rect( _R: TRect;
                   _Color: TColor;
                   _Pen_Color: TColor;
                   _Pen_Width: Integer): IXMLNode;
    function rect_pattern( _R: TRect;
                           _pattern: String;
                           _Pen_Color: TColor;
                           _Pen_Width: Integer): IXMLNode;
    function rect_hachures_slash( _R: TRect;
                                  _Pen_Color: TColor;
                                  _Pen_Width: Integer): IXMLNode;
    function rect_hachures_backslash( _R: TRect;
                                      _Pen_Color: TColor;
                                      _Pen_Width: Integer): IXMLNode;
    function rect_uni( _R: TRect; _Color: TColor): IXMLNode;
    function rect_vide( _R: TRect;
                        _Pen_Color: TColor;
                        _Pen_Width: Integer): IXMLNode;
    function _ellipse( _R: TRect;
                   _Color: TColor;
                   _Pen_Color: TColor;
                   _Pen_Width: Integer): IXMLNode;
    function text( _X, _Y: Integer;
                   _Text, _Font_Family: String;
                   _Font_Size: Integer;
                   _Font_Family_Generic: String = 'sans-serif'): IXMLNode;
    function text_a_Gauche(
                   _X, _Y: Integer;
                   _Text, _Font_Family: String;
                   _Font_Size: Integer;
                   _Font_Family_Generic: String = 'sans-serif'): IXMLNode;
    function text_au_Milieu(
                   _X, _Y: Integer;
                   _Text, _Font_Family: String;
                   _Font_Size: Integer;
                   _Font_Family_Generic: String = 'sans-serif'): IXMLNode;
    function text_a_Droite(
                   _X, _Y: Integer;
                   _Text, _Font_Family: String;
                   _Font_Size: Integer;
                   _Font_Family_Generic: String = 'sans-serif'): IXMLNode;
    function text_rotate( _X, _Y: Integer;
                          _Text, _Font_Family: String;
                          _Font_Size: Integer;
                          _Rotate: Integer): IXMLNode;
    function line( _x1, _y1, _x2, _y2: Integer;
                   _stroke: TColor;
                   _stroke_width: Integer): IXMLNode;
    function line_dash( _x1, _y1, _x2, _y2: Integer;
                        _stroke: TColor;
                        _stroke_width: Integer): IXMLNode;
    function svg_polygon( _points: TPolygon;
                      _Color: TColor;
                      _Pen_Color: TColor;
                      _Pen_Width: Integer): IXMLNode;
    function svg_PolyBezier( _points: TPolygon;
                         _Pen_Color: TColor;
                         _Pen_Width: Integer): IXMLNode;
    function image( _x, _y, _width, _height: Integer;
                    _xlink_href: String): IXMLNode;
    function image_from_id( _x, _y, _width, _height: Integer;
                            _idImage: String): IXMLNode;
    function image_DOCSINGL( _x, _y: Integer): IXMLNode;
    function image_LOSANGE ( _x, _y: Integer): IXMLNode;
    function image_LOGIN   ( _x, _y: Integer): IXMLNode;

    function image_from_id_centre( _width, _height: Integer;
                                       _idImage: String): IXMLNode;
    function svg_image_DOCSINGL_centre: IXMLNode;
    function svg_image_LOSANGE__centre: IXMLNode;
    function svg_image_LOGIN__centre: IXMLNode;
    function svg_image_MEN_AT_WORK__centre: IXMLNode;
    function svg_image_DOSSIER_KDE_PAR_POSTE__centre: IXMLNode;

    function image_from_id_bas_droite( _width, _height: Integer;
                                       _idImage: String): IXMLNode;
    function svg_image_DOCSINGL_bas_droite: IXMLNode;
    function image_LOSANGE__bas_droite: IXMLNode;
    function svg_image_LOGIN__bas_droite: IXMLNode;
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
    FStyleLigne: TStrokeDash;
    procedure SetCouleurLigne(const Value: TColor);
    procedure SetCouleur_Brosse(const Value: TColor);
    procedure SetLargeurLigne(const Value: Integer);
    procedure SetStyleLigne(const Value: TStrokeDash);
  public
    property CouleurLigne: TColor read FCouleurLigne write SetCouleurLigne;
    property Couleur_Brosse: TColor read FCouleur_Brosse write SetCouleur_Brosse;
    property LargeurLigne: Integer read FLargeurLigne write SetLargeurLigne;
    property StyleLigne: TStrokeDash read FStyleLigne write SetStyleLigne;
    procedure MoveTo( X, Y: Integer);
    procedure LineTo( X, Y: Integer);
    procedure Contour_Rectangle( _R: TRect; _Couleur: TColor);
    procedure Remplit_Rectangle( _R: TRect; _Couleur: TColor);
    procedure Rectangle( X1, Y1, X2, Y2: Integer); overload;
    procedure Rectangle( _R: TRect); overload;
    procedure Ellipse( X1, Y1, X2, Y2: Integer);
    procedure Polygon(const Points: TPolygon);
    procedure PolyBezier(const Points: TPolygon);
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
    Fond      := TColorRec.White;

    Rect_Original:= Rect;

    SVG_Drawing:= False;
    FLargeurLigne:= 1;
    FCouleurLigne  := Canvas.Stroke.Color;
    FCouleur_Brosse:= Canvas.Fill.Color;
    FStyleLigne    := Canvas.Stroke.Dash;
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

procedure TDrawInfo.Init_SVG( _svg: TSVGDocument; _eCell: IXMLNode);
begin
     svg  := _svg;
     eCell:= _eCell;
     SVG_Drawing:= Assigned( svg);
end;

function TDrawInfo._rect( _R: TRect; _Color: TColor;
                          _Pen_Color: TColor;
                          _Pen_Width: Integer): IXMLNode;
begin
     Result:= svg.rect( eCell, _R, _Color, _Pen_Color, _Pen_Width);
end;

function TDrawInfo.rect_pattern( _R: TRect; _pattern: String;
                                 _Pen_Color: TColor;
                                 _Pen_Width: Integer): IXMLNode;
begin
     Result:= svg.rect_pattern( eCell, _R, _pattern, _Pen_Color, _Pen_Width);
end;

function TDrawInfo.rect_hachures_slash( _R: TRect;
                                        _Pen_Color: TColor;
                                        _Pen_Width: Integer): IXMLNode;
begin
     Result:= rect_pattern( _R, 'Hachures_Slash', _Pen_Color, _Pen_Width);
end;

function TDrawInfo.rect_hachures_backslash( _R: TRect;
                                            _Pen_Color: TColor;
                                            _Pen_Width: Integer): IXMLNode;
begin
     Result:= rect_pattern( _R, 'Hachures_BackSlash', _Pen_Color, _Pen_Width);
end;

function TDrawInfo.rect_uni(_R: TRect; _Color: TColor): IXMLNode;
begin
     Result:= _rect( _R, _Color, _Color, 1);
end;

function TDrawInfo.rect_vide( _R: TRect;
                              _Pen_Color: TColor;
                              _Pen_Width: Integer): IXMLNode;
begin
     Result:= svg.rect_vide( eCell, _R, _Pen_Width, _Pen_Color);
end;

function TDrawInfo._ellipse( _R: TRect;
                             _Color, _Pen_Color: TColor;_Pen_Width: Integer): IXMLNode;
begin
     Result:= svg.ellipse( eCell, _R, _Color, _Pen_Color, _Pen_Width);
end;

function TDrawInfo.text( _X, _Y: Integer;
                         _Text, _Font_Family: String;
                         _Font_Size: Integer;
                         _Font_Family_Generic: String): IXMLNode;
begin
     Result:= svg.text( eCell, _X, _Y, _Text, _Font_Family, _Font_Size, _Font_Family_Generic);
end;

function TDrawInfo.text_a_Gauche( _X, _Y: Integer;
                         _Text, _Font_Family: String;
                         _Font_Size: Integer;
                         _Font_Family_Generic: String): IXMLNode;
begin
     Result:= svg.text_a_Gauche( eCell, _X, _Y, _Text, _Font_Family, _Font_Size, _Font_Family_Generic);
end;

function TDrawInfo.text_au_Milieu( _X, _Y: Integer;
                         _Text, _Font_Family: String;
                         _Font_Size: Integer;
                         _Font_Family_Generic: String): IXMLNode;
begin
     Result:= svg.text_au_Milieu( eCell, _X, _Y, _Text, _Font_Family, _Font_Size, _Font_Family_Generic);
end;

function TDrawInfo.text_a_Droite( _X, _Y: Integer;
                         _Text, _Font_Family: String;
                         _Font_Size: Integer;
                         _Font_Family_Generic: String): IXMLNode;
begin
     Result:= svg.text_a_Droite( eCell, _X, _Y, _Text, _Font_Family, _Font_Size, _Font_Family_Generic);
end;

function TDrawInfo.text_rotate( _X, _Y: Integer;
                                _Text, _Font_Family: String;
                                _Font_Size, _Rotate: Integer): IXMLNode;
begin
     Result:= svg.text_rotate( eCell, _X, _Y, _Text, _Font_Family, _Font_Size, _Rotate);
end;

function TDrawInfo.line( _x1, _y1, _x2, _y2: Integer;
                         _stroke: TColor; _stroke_width: Integer): IXMLNode;
begin
     Result:= svg.line( eCell, _x1, _y1, _x2, _y2, _stroke, _stroke_width);
end;

function TDrawInfo.line_dash( _x1, _y1, _x2, _y2: Integer;
                              _stroke: TColor; _stroke_width: Integer): IXMLNode;
begin
     Result:= svg.line_dash( eCell, _x1, _y1, _x2, _y2, _stroke, _stroke_width);
end;

function TDrawInfo.svg_polygon( _points: TPolygon;
                            _Color: TColor;
                            _Pen_Color: TColor;
                            _Pen_Width: Integer): IXMLNode;
begin
     Result:= svg.polygon( eCell, _points, _Color, _Pen_Color, _Pen_Width)
end;

function TDrawInfo.svg_PolyBezier( _points: TPolygon;
                               _Pen_Color: TColor;
                               _Pen_Width: Integer): IXMLNode;
begin
     Result:= svg.PolyBezier( eCell, _points, _Pen_Color, _Pen_Width);
end;

function TDrawInfo.image( _x, _y, _width, _height: Integer;
                          _xlink_href: String): IXMLNode;
begin
     Result:= svg.image( eCell, _x, _y, _width, _height, _xlink_href);
end;

function TDrawInfo.image_from_id( _x, _y, _width, _height: Integer;
                                  _idImage: String): IXMLNode;
begin
     Result:= image( _x, _y, _width, _height, 'url(#'+_idImage+')');;
end;

function TDrawInfo.image_DOCSINGL(_x, _y: Integer): IXMLNode;
begin
     Result
     :=
       image_from_id( _x, _y,
                      fBitmaps.svgDOCSINGL_width ,
                      fBitmaps.svgDOCSINGL_height,
                      fBitmaps.svgDOCSINGL_id    );
end;

function TDrawInfo.image_LOSANGE(_x, _y: Integer): IXMLNode;
begin
     Result
     :=
       image_from_id( _x, _y,
                      fBitmaps.svgLOSANGE_width ,
                      fBitmaps.svgLOSANGE_height,
                      fBitmaps.svgLOSANGE_id    );
end;

function TDrawInfo.image_LOGIN(_x, _y: Integer): IXMLNode;
begin
     Result
     :=
       image_from_id( _x, _y,
                      fBitmaps.svgLOGIN_width ,
                      fBitmaps.svgLOGIN_height,
                      fBitmaps.svgLOGIN_id    );
end;

function TDrawInfo.image_from_id_centre( _width, _height: Integer;
                                             _idImage: String): IXMLNode;
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

function TDrawInfo.svg_image_DOCSINGL_centre: IXMLNode;
begin
     Result
     :=
       image_from_id_centre( fBitmaps.svgDOCSINGL_width ,
                                 fBitmaps.svgDOCSINGL_height,
                                 fBitmaps.svgDOCSINGL_id    );
end;

function TDrawInfo.svg_image_LOSANGE__centre: IXMLNode;
begin
     Result
     :=
       image_from_id_centre( fBitmaps.svgLOSANGE_width ,
                                 fBitmaps.svgLOSANGE_height,
                                 fBitmaps.svgLOSANGE_id    );
end;

function TDrawInfo.svg_image_LOGIN__centre: IXMLNode;
begin
     Result
     :=
       image_from_id_centre( fBitmaps.svgLOGIN_width ,
                                 fBitmaps.svgLOGIN_height,
                                 fBitmaps.svgLOGIN_id    );
end;

function TDrawInfo.svg_image_MEN_AT_WORK__centre: IXMLNode;
begin
     Result
     :=
       image_from_id_centre( fBitmaps.svgMEN_AT_WORK_width ,
                                 fBitmaps.svgMEN_AT_WORK_height,
                                 fBitmaps.svgMEN_AT_WORK_id    );
end;

function TDrawInfo.svg_image_DOSSIER_KDE_PAR_POSTE__centre: IXMLNode;
begin
     Result
     :=
       image_from_id_centre( fBitmaps.svgDOSSIER_KDE_PAR_POSTE_width ,
                                 fBitmaps.svgDOSSIER_KDE_PAR_POSTE_height,
                                 fBitmaps.svgDOSSIER_KDE_PAR_POSTE_id    );
end;

function TDrawInfo.image_from_id_bas_droite( _width, _height: Integer;
                                             _idImage: String): IXMLNode;
var
   x, y: Integer;
   R: TRect;
begin
     R:= Rect;
     x:= R.Right -_width ;
     y:= R.Bottom-_height;
     Result:= image_from_id( x, y, _width, _height, _idImage);
end;

function TDrawInfo.svg_image_DOCSINGL_bas_droite: IXMLNode;
begin
     Result
     :=
       image_from_id_bas_droite( fBitmaps.svgDOCSINGL_width ,
                                 fBitmaps.svgDOCSINGL_height,
                                 fBitmaps.svgDOCSINGL_id    );
end;

function TDrawInfo.image_LOSANGE__bas_droite: IXMLNode;
begin
     Result
     :=
       image_from_id_bas_droite( fBitmaps.svgLOSANGE_width ,
                                 fBitmaps.svgLOSANGE_height,
                                 fBitmaps.svgLOSANGE_id    );
end;

function TDrawInfo.svg_image_LOGIN__bas_droite: IXMLNode;
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
         Canvas.Stroke.Color:= FCouleurLigne;
end;

procedure TDrawInfo.SetCouleur_Brosse(const Value: TColor);
begin
     FCouleur_Brosse:= Value;
     if not SVG_Drawing
     then
         Canvas.Fill.Color:= FCouleur_Brosse;
end;

procedure TDrawInfo.SetLargeurLigne(const Value: Integer);
begin
     FLargeurLigne := Value;
     if not SVG_Drawing
     then
         Canvas.Stroke.Thickness:= FLargeurLigne;
end;

procedure TDrawInfo.SetStyleLigne(const Value: TStrokeDash);
begin
     FStyleLigne := Value;
     if not SVG_Drawing
     then
         Canvas.Stroke.Dash:= FStyleLigne;
end;

procedure TDrawInfo.MoveTo(X, Y: Integer);
begin
     XTortue:= X;
     YTortue:= Y;
end;

procedure TDrawInfo.LineTo(X, Y: Integer);
begin
     if SVG_Drawing
     then
         begin
         case StyleLigne
         of
           TStrokeDash.Solid     : line     ( XTortue, YTortue, X, Y, CouleurLigne, LargeurLigne);
           TStrokeDash.Dot       : line_dash( XTortue, YTortue, X, Y, CouleurLigne, LargeurLigne);
           TStrokeDash.Dash      : line_dash( XTortue, YTortue, X, Y, CouleurLigne, LargeurLigne);
           TStrokeDash.DashDot   : line_dash( XTortue, YTortue, X, Y, CouleurLigne, LargeurLigne);
           TStrokeDash.DashDotDot: line_dash( XTortue, YTortue, X, Y, CouleurLigne, LargeurLigne);
           TStrokeDash.Custom    : begin {à revoir, peut être implémenté dans uSVG} end;
           else       line     ( XTortue, YTortue, X, Y, CouleurLigne, LargeurLigne);
           end;
         XTortue:= X;
         YTortue:= Y;
         end
     else
         Canvas.DrawLine( PointF(XTortue, YTortue),PointF(X, Y), 1);
end;

procedure TDrawInfo.Contour_Rectangle( _R: TRect; _Couleur: TColor);
begin
     if SVG_Drawing
     then
         rect_vide( _R, _Couleur, 1)
     else
         begin
         Canvas.Fill.Color:= _Couleur;
         Canvas.Fill.Kind:= TBrushKind.Solid;
         Canvas.DrawRect( _R, 0,0, [], 1);
         end;

end;

procedure TDrawInfo.Remplit_Rectangle( _R: TRect; _Couleur: TColor);
     procedure GDI;
     var
        OldColor: TColor;
     begin
          OldColor:= Canvas.Fill.Color;
          Canvas.Fill.Color:= _Couleur;
          Canvas.FillRect( _R, 0, 0, [], 1);
          Canvas.Fill.Color:= OldColor;
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

procedure TDrawInfo.Polygon(const Points: TPolygon);
begin
     if SVG_Drawing
     then
         svg_polygon( Points, Couleur_Brosse, CouleurLigne, LargeurLigne)
     else
         Canvas.DrawPolygon( Points, 1);
end;

procedure TDrawInfo.PolyBezier(const Points: TPolygon);
var
   P: TPathData;
begin
     if SVG_Drawing
     then
         //svg_PolyBezier( Points, CouleurLigne, LargeurLigne)
         svg_polygon( Points, Couleur_Brosse, CouleurLigne, LargeurLigne)
     else
         begin
         P:= TPathData.Create;
         try
            //à traiter
            Canvas.DrawPolygon( Points, 1);
         finally
                FreeAndNil( P);
                end;
         end;
end;

procedure TDrawInfo.Rectangle(X1, Y1, X2, Y2: Integer);
begin
     if SVG_Drawing
     then
         _rect( Classes.Rect( X1, Y1, X2, Y2),
                Couleur_Brosse, CouleurLigne, LargeurLigne)
     else
         Canvas.DrawRect( RectF(X1, Y1, X2, Y2), 0, 0, [], 1);
end;

procedure TDrawInfo.Ellipse( X1, Y1, X2, Y2: Integer);
begin
     if SVG_Drawing
     then
         _ellipse( Classes.Rect( X1, Y1, X2, Y2),
                   Couleur_Brosse, CouleurLigne, LargeurLigne)
     else
         Canvas.DrawEllipse( RectF(X1, Y1, X2, Y2), 1);
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
         //fBitmaps.DOCSINGL.BkColor:= _Couleur_Fond;
         fBitmaps.DOCSINGL.Draw( Canvas, TRectF.Create( Rect), 0);
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
        //dx:= (R.Right -ImageList.Width -R.Left) div 2;
        //dy:= (R.Bottom-ImageList.Height-R.Top ) div 2;
        //InflateRect( R, -dx, -dy);

        //ImageList.BkColor:= _Couleur_Fond;
        ImageList.Draw( Canvas, TRectF.Create( Rect), 0);
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
        //dx:= (R.Right -ImageList.Width -R.Left) div 2;
        //dy:= (R.Bottom-ImageList.Height-R.Top ) div 2;
        //InflateRect( R, -dx, -dy);

        //ImageList.BkColor:= _Couleur_Fond;
        ImageList.Draw( Canvas, TRectF.Create( Rect), 0);
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
        //dx:= (R.Right -ImageList.Width -R.Left) div 2;
        //dy:= (R.Bottom-ImageList.Height-R.Top ) div 2;
        //InflateRect( R, -dx, -dy);

        //ImageList.BkColor:= _Couleur_Fond;
        ImageList.Draw( Canvas, TRectF.Create( Rect), 0);
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
         //fBitmaps.LOGIN.BkColor:= _Couleur_Fond;
         fBitmaps.LOGIN.Draw( Canvas, TRectF.Create( Rect), 0);
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
        //dx:= (R.Right -ImageList.Width -R.Left) div 2;
        //dy:= (R.Bottom-ImageList.Height-R.Top ) div 2;
        //InflateRect( R, -dx, -dy);

        //ImageList.BkColor:= _Couleur_Fond;
        ImageList.Draw( Canvas, TRectF.Create( Rect), 0);
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
        //dx:= (R.Right -ImageList.Width -R.Left) div 2;
        //dy:= (R.Bottom-ImageList.Height-R.Top ) div 2;
        //InflateRect( R, -dx, -dy);

        //ImageList.BkColor:= _Couleur_Fond;
        ImageList.Draw( Canvas, TRectF.Create( Rect), 0);
   end;
begin
     if SVG_Drawing
     then
         svg_image_DOSSIER_KDE_PAR_POSTE__centre
     else
         GDI;
end;

end.

