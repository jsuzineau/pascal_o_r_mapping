unit uSVG;
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
    uOD_Temporaire,
    uOOoChrono,
    uClean,
    uuStrings,
  {$IFDEF MSWINDOWS}
  JclSimpleXml,
  System.UITypes,
  Windows,FMX.Graphics,
  {$ELSE}
  XMLRead,XMLWrite,DOM, FPimage,
  {$ENDIF}
  System.Math.Vectors,
  SysUtils, Classes, Types;

type
 {$IFNDEF MSWINDOWS}
 TColor=Cardinal;
 {$ENDIF}
 { TSVGDocument }

 TSVGDocument
 =
  class
  //Gestion du cycle de vie
  public
    constructor Create( _Nom: String);
    destructor Destroy; override;
  //Enregistrement des modifications
  public
    procedure Save;
    function Save_to_string: String;
  //Attributs
  public
    Nom: String;
  public
    xml: TJclSimpleXml;
  //Gestion des properties
  private
    function Get_Property_Name( _e: TJclSimpleXMLElem; _FullName: String): String;
  public
    function not_Get_Property( _e: TJclSimpleXMLElem;
                               _FullName: String;
                               out _Value: String): Boolean;
    function not_Test_Property( _e: TJclSimpleXMLElem;
                                _FullName: String;
                                _Values: array of String): Boolean;
    procedure Set_Property( _e: TJclSimpleXMLElem;
                            _Fullname, _Value: String); overload;
    procedure Set_Property( _e: TJclSimpleXMLElem;
                            _Fullname: String; _Value: Integer); overload;
    procedure Delete_Property( _e: TJclSimpleXMLElem; _Fullname: String);
  //Gestion des items
  public
    function Cherche_Item( _eRoot: TJclSimpleXMLElem; _FullName: String;
                           _Properties_Names,
                           _Properties_Values: array of String): TJclSimpleXMLElem;
    function Cherche_Item_Recursif( _eRoot: TJclSimpleXMLElem;
                                    _FullName: String;
                                    _Properties_Names,
                                    _Properties_Values: array of String): TJclSimpleXMLElem;
    function Assure_Item( _eRoot: TJclSimpleXMLElem; _FullName: String;
                           _Properties_Names,
                           _Properties_Values: array of String): TJclSimpleXMLElem;
    procedure Supprime_Item( _e: TJclSimpleXMLElem);
  //Gestion SVG
  public
    function svgColor( Color: TColor): String;
    function rect( _eRoot: TJclSimpleXMLElem;
                   _R: TRect;
                   _Color: TColor;
                   _Pen_Color: TColor;
                   _Pen_Width: Integer): TJclSimpleXMLElem;
    function rect_pattern( _eRoot: TJclSimpleXMLElem;
                           _R: TRect;
                           _pattern: String;
                           _Pen_Color: TColor;
                           _Pen_Width: Integer): TJclSimpleXMLElem;
    function rect_vide( _eRoot: TJclSimpleXMLElem;
                        _R: TRect;
                        _Pen_Color: TColor;
                        _Pen_Width: Integer): TJclSimpleXMLElem;
    function ellipse( _eRoot: TJclSimpleXMLElem;
                   _R: TRect;
                   _Color: TColor;
                   _Pen_Color: TColor;
                   _Pen_Width: Integer): TJclSimpleXMLElem;
    function text( _eRoot: TJclSimpleXMLElem;
                   _X, _Y: Integer;
                   _Text, _Font_Family: String;
                   _Font_Size: Integer;
                   _Font_Family_Generic: String = 'sans-serif'): TJclSimpleXMLElem;
    function text_a_Gauche( _eRoot: TJclSimpleXMLElem;
                   _X, _Y: Integer;
                   _Text, _Font_Family: String;
                   _Font_Size: Integer;
                   _Font_Family_Generic: String = 'sans-serif'): TJclSimpleXMLElem;
    function text_au_Milieu( _eRoot: TJclSimpleXMLElem;
                   _X, _Y: Integer;
                   _Text, _Font_Family: String;
                   _Font_Size: Integer;
                   _Font_Family_Generic: String = 'sans-serif'): TJclSimpleXMLElem;
    function text_a_Droite( _eRoot: TJclSimpleXMLElem;
                   _X, _Y: Integer;
                   _Text, _Font_Family: String;
                   _Font_Size: Integer;
                   _Font_Family_Generic: String = 'sans-serif'): TJclSimpleXMLElem;
    function text_rotate( _eRoot: TJclSimpleXMLElem;
                          _X, _Y: Integer;
                          _Text, _Font_Family: String;
                          _Font_Size: Integer;
                          _Rotate: Integer): TJclSimpleXMLElem;
    function line( _eRoot: TJclSimpleXMLElem;
                   _x1, _y1, _x2, _y2: Integer;
                   _stroke: TColor;
                   _stroke_width: Integer): TJclSimpleXMLElem;
    function line_dash( _eRoot: TJclSimpleXMLElem;
                        _x1, _y1, _x2, _y2: Integer;
                        _stroke: TColor;
                        _stroke_width: Integer): TJclSimpleXMLElem;
    function polygon( _eRoot: TJclSimpleXMLElem;
                      _points: TPolygon;
                      _Color: TColor;
                      _Pen_Color: TColor;
                      _Pen_Width: Integer): TJclSimpleXMLElem;
    function PolyBezier( _eRoot: TJclSimpleXMLElem;
                         _points: array of TPoint;
                         _Pen_Color: TColor;
                         _Pen_Width: Integer): TJclSimpleXMLElem;
    function image( _eRoot: TJclSimpleXMLElem;
                    _x, _y, _width, _height: Integer;
                    _xlink_href: String): TJclSimpleXMLElem;
    procedure Dessinne_Coche( _eRoot: TJclSimpleXMLElem;
                    _CouleurFond, _CouleurCoche: TColor;
                    _R: TRect;
                    _Coche: Boolean);
  end;

function Name_from_FullName( _FullName: String): String;
function Elem_from_path( _e: TJclSimpleXMLElem; Path: String):TJclSimpleXMLElem;
function Cree_path( _e: TJclSimpleXMLElem; Path: String):TJclSimpleXMLElem;

implementation

procedure FullName_Split( _FullName: String; var NameSpace, Name: String);
begin
     NameSpace:= StrToK( ':', _FullName);
     Name:= _FullName;
     if Name = '' //pas de :
     then
         begin
         Name:= NameSpace;
         NameSpace:= '';
         end;
end;

function Name_from_FullName( _FullName: String): String;
var
   NameSpace: String;
begin
     NameSpace:= StrToK( ':', _FullName);
     Result:= _FullName;
     if Result = '' //pas de :
     then
         Result:= NameSpace;
end;

function Elem_from_path( _e: TJclSimpleXMLElem; Path: String):TJclSimpleXMLElem;
var
   sNode: String;
   Name: String;
begin
     Result:= _e;
     if _e = nil  then exit;
     if Path = '' then exit;

     sNode:= StrToK( '/', Path);
     Name:= Name_from_FullName( sNode);
     Result:= _e.Items.ItemNamed[ Name];
     Result:= Elem_from_path( Result, Path);
end;

function Cree_path( _e: TJclSimpleXMLElem; Path: String):TJclSimpleXMLElem;
var
   FullName: String;
begin
     Result:= _e;
     if _e = nil  then exit;
     if Path = '' then exit;

     FullName:= StrToK( '/', Path);
     Result:= _e.Items.Add( FullName);
     Result:= Cree_path( Result, Path);
end;

{ TSVGDocument }

constructor TSVGDocument.Create( _Nom: String);
begin
     Nom:= _Nom;

     xml:= TJclSimpleXml.Create;
     xml.IndentString:= '  ';
     with xml do Options:= Options + [sxoAutoEncodeValue];

     if Nom <> ''
     then
         xml.LoadFromFile( Nom);
     OOoChrono.Stop( 'Chargement en objet du fichier xml '+Nom);
end;

destructor TSVGDocument.Destroy;
begin
     FreeAndNil( xml);
     inherited;
end;

function TSVGDocument.Get_Property_Name( _e: TJclSimpleXMLElem; _FullName: String): String;
var
   _e_NameSpace: String;
   Name: String;
begin
     _e_NameSpace:= _e.NameSpace;
     if _e_NameSpace = ''
     then
         Result:= _FullName
     else
         begin
         Name:= Name_from_FullName( _FullName);
         Result:= Name;
         end;
end;

function TSVGDocument.not_Get_Property( _e: TJclSimpleXMLElem;
                                         _FullName: String;
                                         out _Value: String): Boolean;
var
   PropertyName: String;
   p: TJclSimpleXMLProp;
begin
     Result:= _e = nil;
     if Result then exit;

     PropertyName:= Get_Property_Name( _e, _FullName);

     p:= _e.Properties.ItemNamed[ PropertyName];

     Result:= p = nil;
     if Result then exit;

     _Value:= p.Value;
end;

function TSVGDocument.not_Test_Property( _e: TJclSimpleXMLElem;
                                          _FullName: String;
                                          _Values: array of String): Boolean;
var
   Value: String;
   I: Integer;
begin
     Result:= not_Get_Property( _e, _FullName, Value);
     if Result then exit;

     Result:= True;
     for I:= Low( _Values) to High( _Values)
     do
       begin
       Result:= Value <> _Values[ I];
       if not Result then break;
       end;
end;

procedure TSVGDocument.Set_Property( _e: TJclSimpleXMLElem;
                                      _Fullname, _Value: String);
var
   PropertyName: String;
   p: TJclSimpleXMLProp;
begin
     if _e = nil then exit;

     PropertyName:= Get_Property_Name( _e, _FullName);
     p:= _e.Properties.ItemNamed[ PropertyName];

     if Assigned( p)
     then
         p.Value:= _Value
     else
         _e.Properties.Add( _Fullname, _Value);
end;

procedure TSVGDocument.Set_Property( _e: TJclSimpleXMLElem; _Fullname: String; _Value: Integer);
var
   PropertyName: String;
   p: TJclSimpleXMLProp;
begin
     if _e = nil then exit;

     PropertyName:= Get_Property_Name( _e, _FullName);
     p:= _e.Properties.ItemNamed[ PropertyName];

     if Assigned( p)
     then
         p.IntValue:= _Value
     else
         _e.Properties.Add( _Fullname, _Value);
end;

procedure TSVGDocument.Delete_Property( _e: TJclSimpleXMLElem; _Fullname: String);
var
   PropertyName: String;
begin
     if _e = nil then exit;

     PropertyName:= Get_Property_Name( _e, _FullName);

     _e.Properties.Delete( PropertyName);
end;

function TSVGDocument.Cherche_Item( _eRoot: TJclSimpleXMLElem; _FullName: String;
                                     _Properties_Names ,
                                     _Properties_Values: array of String): TJclSimpleXMLElem;
var
   I: Integer;
   e: TJclSimpleXMLElem;
   iProperties: Integer;
   Properties_Values: array of String;
   Arreter: Boolean;
begin
     Result:= nil;

     if _eRoot = nil then exit;

     SetLength( Properties_Values, Length( _Properties_Names));

     for I:= 0 to _eRoot.Items.Count - 1
     do
       begin
       e:= _eRoot.Items.Item[ I];
       if e = nil                 then continue;
       if e.FullName <> _FullName then continue;

       Arreter:= False;
       for iProperties:= Low( _Properties_Names) to High( _Properties_Names)
       do
         begin
         Arreter
         :=
           not_Get_Property( e,
                             _Properties_Names [iProperties],
                              Properties_Values[iProperties]
                             );
         if Arreter
         then
             break;
         end;
       if Arreter then continue;

       for iProperties:= Low( _Properties_Names) to High( _Properties_Names)
       do
         begin
         Arreter
         :=
              _Properties_Values[ iProperties]
           <>  Properties_Values[ iProperties];
         if Arreter
         then
             break;
         end;
       if Arreter then continue;

       Result:= e;
       break;
       end;
end;

function TSVGDocument.Cherche_Item_Recursif( _eRoot: TJclSimpleXMLElem; _FullName: String;
                                              _Properties_Names ,
                                              _Properties_Values: array of String): TJclSimpleXMLElem;
var
   I: Integer;
   e: TJclSimpleXMLElem;
   Properties_Values: array of String;
   Arreter: Boolean;
   procedure Traite_Properties;
   var
      iProperties: Integer;
   begin
        for iProperties:= Low( _Properties_Names) to High( _Properties_Names)
        do
          begin
          Arreter
          :=
            not_Get_Property( e,
                              _Properties_Names [iProperties],
                               Properties_Values[iProperties]
                              );
          if Arreter then break;
          end;
        if Arreter then exit;

        for iProperties:= Low( _Properties_Names) to High( _Properties_Names)
        do
          begin
          Arreter
          :=
               _Properties_Values[ iProperties]
            <>  Properties_Values[ iProperties];
          if Arreter then break;
          end;
   end;
begin
     Result:= nil;

     if _eRoot = nil then exit;

     SetLength( Properties_Values, Length( _Properties_Names));

     for I:= 0 to _eRoot.Items.Count - 1
     do
       begin
       e:= _eRoot.Items.Item[ I];
       if e = nil                 then continue;

       Arreter:= False;
       if e.FullName = _FullName
       then
           Traite_Properties
       else
           begin
           e:= Cherche_Item_Recursif( e, _FullName, _Properties_Names, _Properties_Values);
           Arreter:= e = nil;
           end;
       if Arreter then continue;

       Result:= e;
       break;
       end;
end;

function TSVGDocument.Assure_Item( _eRoot: TJclSimpleXMLElem; _FullName: String;
                                    _Properties_Names ,
                                    _Properties_Values: array of String): TJclSimpleXMLElem;
var
   iProperties: Integer;
begin
     Result:= Cherche_Item( _eRoot, _FullName, _Properties_Names, _Properties_Values);
     if Assigned( Result) then exit;

     Result:= _eRoot.Items.Add( _FullName);
     if Result = nil then exit;

     for iProperties:= Low( _Properties_Names) to High( _Properties_Names)
     do
       Set_Property( Result,
                     _Properties_Names[ iProperties],
                     _Properties_Values[ iProperties]);
end;

procedure TSVGDocument.Supprime_Item( _e: TJclSimpleXMLElem);
var
   Parent: TJclSimpleXMLElem;
   CONTAINER: TJclSimpleXMLElems;
begin
     if _e = nil then exit;

     Parent:= _e.Parent;
     if Parent= nil then exit;

     CONTAINER:= Parent.Items;
     if CONTAINER = nil then exit;
     
     CONTAINER.Delete( CONTAINER.IndexOf( _e));
end;

procedure TSVGDocument.Save;
begin
     xml.SaveToFile( Nom);
end;

function TSVGDocument.Save_to_string: String;
var
   ss: TStringStream;
begin
     ss:= TStringStream.Create('');
     try
     	  xml.SaveToStream( ss);
        Result:= ss.DataString;
     finally
            Free_nil( ss);
            end;
end;

function TSVGDocument.svgColor( Color: TColor): String;
var
   iColor: Longint;
   C: TRGBQuad;
begin
     iColor:= TColorRec.ColorToRGB( Color);
     Longint(C):= iColor; //la conversion en TRGBQuad ne doit pas être correcte
                          //rouge et bleu sont inversés
                          // du coup on les réinverse ci-dessous
     Result:= Format('rgb(%d,%d,%d)',[C.rgbBlue, C.rgbGreen, C.rgbRed]);
end;

function TSVGDocument.rect( _eRoot: TJclSimpleXMLElem;
                            _R: TRect;
                            _Color: TColor;
                            _Pen_Color: TColor;
                            _Pen_Width: Integer): TJclSimpleXMLElem;
var
   x, y, width, height: Integer;
   fill: String;
   stroke: String;
   style: String;
begin
     Result:= _eRoot.Items.Add( 'rect');

     x     := _R.Left;
     y     := _R.Top ;
     width := _R.Right -x;
     height:= _R.Bottom-y;
     fill  := svgColor( _Color);
     stroke:= svgColor( _Pen_Color);
     style
     :=
       Format(  'fill:%s;stroke-width:%d;stroke:%s',
               [ fill   , _Pen_Width    , stroke]);

     Set_Property( Result, 'x'     , x     );
     Set_Property( Result, 'y'     , y     );
     Set_Property( Result, 'width' , width );
     Set_Property( Result, 'height', height);
     Set_Property( Result, 'style' , style );
end;

function TSVGDocument.ellipse( _eRoot: TJclSimpleXMLElem;
                               _R: TRect;
                               _Color,
                               _Pen_Color: TColor;
                               _Pen_Width: Integer): TJclSimpleXMLElem;
var
   cx, cy, rx, ry: Integer;
   fill: String;
   stroke: String;
   style: String;
begin
     Result:= _eRoot.Items.Add( 'ellipse');

     cx    := (_R.Left+_R.Right ) div 2;
     cy    := (_R.Top +_R.Bottom) div 2;
     rx    := _R.Right - cx;
     ry    := _R.Bottom- cy;
     fill  := svgColor( _Color);
     stroke:= svgColor( _Pen_Color);
     style
     :=
       Format(  'fill:%s;stroke-width:%d;stroke:%s',
               [ fill   , _Pen_Width    , stroke]);

     Set_Property( Result, 'cx'   , cx   );
     Set_Property( Result, 'cy'   , cy   );
     Set_Property( Result, 'rx'   , rx   );
     Set_Property( Result, 'ry'   , ry   );
     Set_Property( Result, 'style', style);
end;

function TSVGDocument.rect_pattern( _eRoot: TJclSimpleXMLElem;
                                    _R: TRect;
                                    _pattern: String;
                                    _Pen_Color: TColor;
                                    _Pen_Width: Integer): TJclSimpleXMLElem;
var
   x, y, width, height: Integer;
   fill: String;
   stroke: String;
   style: String;
begin
     Result:= _eRoot.Items.Add( 'rect');

     x     := _R.Left;
     y     := _R.Top ;
     width := _R.Right -x;
     height:= _R.Bottom-y;
     fill  := 'url(#'+_pattern+')';
     stroke:= svgColor( _Pen_Color);
     style
     :=
       Format(  'fill:%s;stroke-width:%d;stroke:%s',
               [ fill   , _Pen_Width    , stroke]);

     Set_Property( Result, 'x'     , x     );
     Set_Property( Result, 'y'     , y     );
     Set_Property( Result, 'width' , width );
     Set_Property( Result, 'height', height);
     Set_Property( Result, 'style' , style );
end;

function TSVGDocument.rect_vide( _eRoot: TJclSimpleXMLElem;
                                 _R: TRect;
                                 _Pen_Color: TColor;
                                 _Pen_Width: Integer): TJclSimpleXMLElem;
var
   x, y, width, height: Integer;
   fill: String;
   stroke: String;
   style: String;
begin
     Result:= _eRoot.Items.Add( 'rect');

     x     := _R.Left;
     y     := _R.Top ;
     width := _R.Right -x;
     height:= _R.Bottom-y;
     fill  := 'none';
     stroke:= svgColor( _Pen_Color);
     style
     :=
       Format(  'fill:%s;stroke-width:%d;stroke:%s',
               [ fill   , _Pen_Width    , stroke]);

     Set_Property( Result, 'x'     , x     );
     Set_Property( Result, 'y'     , y     );
     Set_Property( Result, 'width' , width );
     Set_Property( Result, 'height', height);
     Set_Property( Result, 'style' , style );
end;

function TSVGDocument.text( _eRoot: TJclSimpleXMLElem;
                            _X, _Y: Integer;
                            _Text, _Font_Family: String;
                            _Font_Size: Integer;
                            _Font_Family_Generic: String = 'sans-serif'): TJclSimpleXMLElem;
var
   font_family: String;
begin
     Result:= _eRoot.Items.Add( 'text');

     font_family:= _Font_Family+','+_Font_Family_Generic;

     Set_Property( Result, 'x'                , _X           );
     Set_Property( Result, 'y'                , _Y+_Font_Size);
     Set_Property( Result, 'font_family'      , font_family  );
     Set_Property( Result, 'font-size'        , IntToStr(_Font_Size)+'pt');
     Result.Value:= _Text
end;

function TSVGDocument.text_a_Gauche(  _eRoot: TJclSimpleXMLElem;
                                      _X, _Y: Integer;
                                      _Text, _Font_Family: String;
                                      _Font_Size: Integer;
                                      _Font_Family_Generic: String): TJclSimpleXMLElem;
begin
     Result:= text( _eRoot, _X, _Y, _Text, _Font_Family, _Font_Size, _Font_Family_Generic);
     Set_Property( Result, 'text-anchor'  , 'start');
end;

function TSVGDocument.text_au_Milieu( _eRoot: TJclSimpleXMLElem;
                                      _X, _Y: Integer;
                                      _Text, _Font_Family: String;
                                      _Font_Size: Integer;
                                      _Font_Family_Generic: String): TJclSimpleXMLElem;
begin
     Result:= text( _eRoot, _X, _Y, _Text, _Font_Family, _Font_Size, _Font_Family_Generic);
     Set_Property( Result, 'text-anchor'  , 'middle');
end;

function TSVGDocument.text_a_Droite( _eRoot: TJclSimpleXMLElem;
                                     _X, _Y: Integer;
                                     _Text, _Font_Family: String;
                                     _Font_Size: Integer;
                                     _Font_Family_Generic: String): TJclSimpleXMLElem;
begin
     Result:= text( _eRoot, _X, _Y, _Text, _Font_Family, _Font_Size, _Font_Family_Generic);
     Set_Property( Result, 'text-anchor'  , 'end');
end;

function TSVGDocument.text_rotate(  _eRoot: TJclSimpleXMLElem;
                                    _X, _Y: Integer;
                                    _Text, _Font_Family: String;
                                    _Font_Size, _Rotate: Integer): TJclSimpleXMLElem;
var
   sTransform: String;
   eG: TJclSimpleXMLElem;
begin
     if _Rotate=0
     then
         Result:= text( _eRoot, _X, _Y, _Text, _Font_Family, _Font_Size)
     else
         begin
         sTransform:= 'rotate('+InTToStr(_Rotate)+')';
         eG:= _eRoot.Items.Add( 'g');
         Set_Property( eG, 'transform', sTransform);
         text( eG, _X, _Y, _Text, _Font_Family, _Font_Size);
         Result:= eG;
         end;
end;

function TSVGDocument.line( _eRoot: TJclSimpleXMLElem;
                            _x1, _y1, _x2, _y2: Integer;
                            _stroke: TColor;
                            _stroke_width: Integer): TJclSimpleXMLElem;
begin
     Result:= _eRoot.Items.Add( 'line');
     Set_Property( Result, 'x1'          , _x1               );
     Set_Property( Result, 'y1'          , _y1               );
     Set_Property( Result, 'x2'          , _x2               );
     Set_Property( Result, 'y2'          , _y2               );
     Set_Property( Result, 'stroke'      , svgColor( _stroke));
     Set_Property( Result, 'stroke-width', _stroke_width     );
end;

function TSVGDocument.line_dash( _eRoot: TJclSimpleXMLElem;
                                 _x1, _y1, _x2, _y2: Integer;
                                 _stroke: TColor;
                                 _stroke_width: Integer): TJclSimpleXMLElem;
begin
     Result:= line( _eRoot, _x1, _y1, _x2, _y2, _stroke, _stroke_width);
     Set_Property( Result, 'stroke-dasharray', '5, 5');
end;

function TSVGDocument.polygon( _eRoot: TJclSimpleXMLElem;
                               _points: TPolygon;
                               _Color: TColor;
                               _Pen_Color: TColor;
                               _Pen_Width: Integer): TJclSimpleXMLElem;
var
   i: Integer;
   sX, sY: String;
   points: String;
   fill: String;
   stroke: String;
   style: String;
begin
     points:= '';
     for i:= Low( _points) to High( _points)
     do
       begin
       if points <> ''
       then
           points:= points + ' ';

       Str(_points[i].X, sX);
       Str(_points[i].Y, sY);
       points:= points+sX+','+sY;
       end;
     fill  := svgColor( _Color);
     stroke:= svgColor( _Pen_Color);
     style
     :=
       Format(  'fill:%s;stroke-width:%d;stroke:%s',
               [ fill   , _Pen_Width    , stroke]);

     Result:= _eRoot.Items.Add( 'polygon');
     Set_Property( Result, 'points', points);
     Set_Property( Result, 'style' , style );
end;

function TSVGDocument.PolyBezier( _eRoot: TJclSimpleXMLElem;
                                  _points: array of TPoint;
                                  _Pen_Color: TColor;
                                  _Pen_Width: Integer): TJclSimpleXMLElem;
var
   i: Integer;
   d: String;
   stroke: String;
   style: String;
begin
     d:= '';
     for i:= Low( _points) div 4 to High( _points) div 4
     do
       begin
       if d <> ''
       then
           d:= d + ' ';

       d
       :=
          d
         +'M '+IntToStr(_points[i  ].X)+','+IntToStr(_points[i  ].Y)+' '
         +'C '+IntToStr(_points[i+1].X)+','+IntToStr(_points[i+1].Y)+' '
              +IntToStr(_points[i+2].X)+','+IntToStr(_points[i+2].Y)+' '
              +IntToStr(_points[i+3].X)+','+IntToStr(_points[i+3].Y);
       end;
     stroke:= svgColor( _Pen_Color);
     style
     :=
       Format(  'stroke-width:0.2;stroke:%s;fill:none',
               [ {_Pen_Width     ,} stroke]);

     Result:= _eRoot.Items.Add( 'path');
     Set_Property( Result, 'd'     , d     );
     Set_Property( Result, 'style' , style );
end;

function TSVGDocument.image( _eRoot: TJclSimpleXMLElem;
                             _x, _y, _width, _height: Integer;
                             _xlink_href: String): TJclSimpleXMLElem;
begin
     Result:= _eRoot.Items.Add( 'image');
     Set_Property( Result, 'x'         , _x     );
     Set_Property( Result, 'y'         , _y     );
     Set_Property( Result, 'width'     , _width );
     Set_Property( Result, 'height'    , _height);
     Set_Property( Result, 'xlink_href', _xlink_href);
end;

procedure TSVGDocument.Dessinne_Coche( _eRoot: TJclSimpleXMLElem;
                             _CouleurFond, _CouleurCoche: TColor;
                             _R: TRect; _Coche: Boolean);
var
   W, H, W3, H3, W5, H5: Integer;
   procedure WH_from_R;
   begin
        W:= _R.Right  - _R.Left;
        H:= _R.Bottom - _R.Top ;

        W3:= W div 3;
        H3:= H div 3;

        W5:= W div 5;
        H5:= H div 5;
   end;
begin
     rect( _eRoot, _R, _CouleurFond, _CouleurFond, 1);
     if _Coche
     then
         begin
         // on rétrécit R de 1/5
         WH_from_R;
         InflateRect( _R, -W5, -H5);
         WH_from_R;

         line( _eRoot, _R.Left   , _R.Top+H3, _R.Left+W3, _R.Bottom, _CouleurCoche, 1);
         line( _eRoot, _R.Left+W3, _R.Bottom, _R.Right  , _R.Top   , _CouleurCoche, 2);
         end;
end;

end.

