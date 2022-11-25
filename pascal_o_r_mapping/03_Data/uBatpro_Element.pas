unit uBatpro_Element;
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
    JclSimpleXml,
    {$ELSE}
    DOM,
    {$ENDIF}
    ubtString,
    uskString,
    uuStrings,
    uBatpro_StringList,
    {$IFDEF WINDOWS_GRAPHIC}
    uWinUtils,
    {$ENDIF}
    uReels,
    u_sys_,
    uSVG,
    uClean,
    uContextes,
    uDrawInfo,
    uChampDefinitions,
    uChamps,
    //uLog,
    {$IF DEFINED(MSWINDOWS) AND NOT DEFINED(FPC)}
    uImpression_Font_Size_Multiplier,
    {$IFEND}
    uVide,

    ufAccueil_Erreur,
    {$IF DEFINED(MSWINDOWS) AND NOT DEFINED(FPC)}
    ufBitmaps,
    {$IFEND}

  {$IFDEF WINDOWS_GRAPHIC}
    {$IFDEF MSWINDOWS}
    Windows,
    {$ENDIF}
    Controls, Menus, Types, ExtCtrls, Grids,Graphics,
  {$ENDIF}
  FPCanvas,
  SysUtils, Classes, XMLRead, XMLWrite,math;

const
     //nom de la classe TBatpro_Element
     sys_TBatpro_Element: String='TBatpro_Element';
     //nom de la classe de paramètres TBatpro_Element
     sys_TblG_BECP   : String='TblG_BECP';
     sys_TblG_BECPCTX: String='TblG_BECPCTX';
     sys_TpoolG_BECP   : String='TpoolG_BECP';
     sys_TpoolG_BECPCTX: String='TpoolG_BECPCTX';

     //Batpro_Element_Marge= 2; //bordure
     Batpro_Element_Marge: Integer = 0; //bordure

type
     TbeAlignementH= (bea_Gauche, bea_Centre_Horiz , bea_Droite);
     TbeAlignementV= (bea_Haut  , bea_Centre_Vertic, bea_Bas   );
     TbeAlignement
     =
      record
      H: TbeAlignementH;
      V: TbeAlignementV;
      end;
const
  Format_beAlignementH
  :
   array[bea_Gauche..bea_Droite] of Integer
   =
    {$IFNDEF FPC}
    ( DT_LEFT, DT_CENTER, DT_RIGHT);
    {$ELSE}
    (0      ,   1,           2) ;
    {$ENDIF}

{$IFNDEF WINDOWS_GRAPHIC}
const //recopié de l'unité Graphics
  psSolid = FPCanvas.psSolid;
  psDash = FPCanvas.psDash;
  psDot = FPCanvas.psDot;
  psDashDot = FPCanvas.psDashDot;
  psDashDotDot = FPCanvas.psDashDotDot;
  psClear = FPCanvas.psClear;
  psInsideframe = FPCanvas.psInsideframe;
  psPattern = FPCanvas.psPattern;

  pmBlack = FPCanvas.pmBlack;
  pmWhite = FPCanvas.pmWhite;
  pmNop = FPCanvas.pmNop;
  pmNot = FPCanvas.pmNot;
  pmCopy = FPCanvas.pmCopy;
  pmNotCopy = FPCanvas.pmNotCopy;
  pmMergePenNot = FPCanvas.pmMergePenNot;
  pmMaskPenNot = FPCanvas.pmMaskPenNot;
  pmMergeNotPen = FPCanvas.pmMergeNotPen;
  pmMaskNotPen = FPCanvas.pmMaskNotPen;
  pmMerge = FPCanvas.pmMerge;
  pmNotMerge = FPCanvas.pmNotMerge;
  pmMask = FPCanvas.pmMask;
  pmNotMask = FPCanvas.pmNotMask;
  pmXor = FPCanvas.pmXor;
  pmNotXor = FPCanvas.pmNotXor;

  bsSolid = FPCanvas.bsSolid;
  bsClear = FPCanvas.bsClear;
  bsHorizontal = FPCanvas.bsHorizontal;
  bsVertical = FPCanvas.bsVertical;
  bsFDiagonal = FPCanvas.bsFDiagonal;
  bsBDiagonal = FPCanvas.bsBDiagonal;
  bsCross = FPCanvas.bsCross;
  bsDiagCross = FPCanvas.bsDiagCross;
{$ENDIF}

{début de l'unité uDrawInfo déplacée}
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

type
 TDrawInfo=class;
 TBatpro_Element= class;
 TAggregations  = class;
 ThAggregation_Create_Params= class;
 ThAggregation_class= class of ThAggregation;
 TBatpro_Serie  = class;
 TBatpro_Cluster= class;
 TbeClusterElement=class;
 TBatpro_ElementClassParams= class;
 TslBatpro_Element = class;

 { TStringGridWeb }

 TStringGridWeb
 =
  class
  //Gestion du cycle de vie
  public
    constructor Create;
    destructor Destroy; override;
  //Méthodes
  public
    procedure Resize( _ColCount: Integer= -1; _RowCount: Integer= -1);
    procedure Charge_Cell( _Colonne, _Ligne:Integer; _be: TBatpro_Element; _Contexte: Integer);
    procedure Charge_Ligne( _OffsetColonne, _Ligne: Integer;
                            _sl: TBatpro_StringList;
                            _ClusterAddInit_: Boolean;
                            _Contexte: Integer); overload;
    procedure Charge_Colonne( _Colonne, _OffsetLigne: Integer;
                              _sl: TBatpro_StringList;
                              _Contexte: Integer); overload;
    procedure Charge_Colonne( _Colonne, _OffsetLigne:Integer;
                              _beEntete:TBatpro_Element;
                              _sl:TBatpro_StringList;
                              _Contexte: Integer); overload;
    procedure Charge_Ligne( _OffsetColonne, _Ligne: Integer;
                            _bts: TbtString;
                            _ClusterAddInit_: Boolean;
                            _Contexte: Integer); overload;
    procedure Charge_Colonne( _Colonne, _OffsetLigne: Integer;
                              _bts: TbtString;
                              _Contexte: Integer); overload;
    procedure Charge_Colonne( _Colonne, _OffsetLigne:Integer;
                              _beEntete:TBatpro_Element;
                              _bts: TbtString;
                              _Contexte: Integer); overload;
    function Hauteur_Ligne( _DrawInfo: TDrawInfo;
                            _Ligne: Integer;
                            _TraiterClusters: Boolean = False): Integer;
    function Largeur_Colonne( _DrawInfo: TDrawInfo; _Colonne: Integer;
                              _TraiterClusters: Boolean = False): Integer;
    procedure Traite_Hauteurs_Lignes( _DrawInfo: TDrawInfo);
    procedure Traite_Largeurs_Colonnes( _DrawInfo: TDrawInfo;
                                        _ColonneDebut: Integer= 0;
                                        _ColonneFin  : Integer= -1);
    procedure Egalise_Largeurs_Colonnes( _ColonneDebut, _ColonneFin: Integer);
    procedure Egalise_Hauteurs_Lignes  ( _LigneDebut, _LigneFin: Integer);
    procedure Initialise_dimensions( _ColonneDebut: Integer= 0);
    procedure Ajuste_Largeur_Client( _ColonneDebut: Integer= 0);
    procedure Refresh;
    procedure MouseToCell(X,Y: Integer; var ACol,ARow: Longint); overload;
    function  CellRect(_Col, _Row: Integer): TRect;
  //FixedCols
  private
    FFixedCols: Integer;
  public
    property FixedCols: Integer read FFixedCols;
  //FixedRows
  private
    FFixedRows: Integer;
  public
    property FixedRows: Integer read FFixedRows;
  //ColCount
  private
    FColCount: Integer;
    procedure SetColCount( _Value: Integer);
  public
    property ColCount: Integer read FColCount write SetColCount;
  //RowCount
  private
    FRowCount: Integer;
    procedure SetRowCount( _Value: Integer);
  public
    property RowCount: Integer read FRowCount write SetRowCount;
  //ColWidths
  private
    FColWidths: array of Integer;
    function  GetColWidths(Index: Integer): Integer;
    procedure SetColWidths(Index: Integer; _Value: Integer);
  public
    property ColWidths[Index: Integer]: Integer read GetColWidths write SetColWidths;
  //RowHeights
  private
    FRowHeights: array of Integer;
    function  GetRowHeights(Index: Integer): Integer;
    procedure SetRowHeights(Index: Integer; _Value: Integer);
  public
    property RowHeights[Index: Integer]: Integer read GetRowHeights write SetRowHeights;
  //ClientWidth
  public
    ClientWidth: Integer;
  //GridLineWidth
  public
    GridLineWidth: Integer;
  //DefaultColWidth
  public
    DefaultColWidth: Integer;
  //DefaultRowHeight
  public
    DefaultRowHeight: Integer;
  //Col
  public
    Col: Integer;
  //Row
  public
    Row: Integer;
  //Selection
  public
    Selection: TRect;
  //Width
  public
    Width: Integer;
  //Height
  public
    Height: Integer;
  //Cells
  private
    FCells: array of array of String;
    function GetCell( _Col, _Row: Integer): String;
    procedure SetCell( _Col, _Row: Integer; _Value: String);
  public
    property Cells[ _Col, _Row: Integer]: String read GetCell write SetCell;
  //Objects
  private
    FObjects: array of array of TObject;
    function GetObject( _Col, _Row: Integer): TObject;
    procedure SetObject( _Col, _Row: Integer; _Value: TObject);
  public
    property Objects[ _Col, _Row: Integer]: TObject read GetObject write SetObject;
  //be
  private
    function GetBatpro_Element( _Col, _Row: Integer): TBatpro_Element;
    procedure SetBatpro_Element( _Col, _Row: Integer; _Value: TBatpro_Element);
  public
    property Batpro_Element[ _Col, _Row: Integer]: TBatpro_Element read GetBatpro_Element write SetBatpro_Element;
  end;

{$IFNDEF WINDOWS_GRAPHIC}
 TStringGrid= TStringGridWeb;
 TBrushStyle = TFPBrushStyle;

 TBrush
 =
  class
  Color: TColor;
  Style: TBrushStyle;
  end;

 TPenStyle=TFPPenStyle;

 TPen
 =
  class
  Color: TColor;
  Width: Integer;
  Mode : TFPPenMode;
  Style: TPenStyle;
  end;

 TCanvas
 =
  class( TFPCustomCanvas)
  private
    FFBrush: TBrush;
    FFPen  : TPen  ;
  public
    property Brush: TBrush read FFBrush write FFBrush;
    property Pen  : TPen   read FFPen   write FFPen  ;
  end;
 TFontStyle=(fsBold, fsItalic);
 TFontStyles= set of TFontStyle;

 { TFont }

 TFont
 =
  class(TFPCustomFont)
  public
    Color: TColor;
    Style: TFontStyles;
    constructor Create;
    procedure Assign( _Source: TPersistent); override;
  end;
{$ELSE}
 TFont= Graphics.TFont;
 TFontStyle= Graphics.TFontStyle;
 //TFontStyles= Graphics.TFontStyles;
 TFontStyles= Set of TFontStyle;
{$ENDIF}

 { TDrawInfo }

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
  public
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
    procedure Dessine_Fond;
    procedure Traite_Grille_impression( _Afficher_Grille: Boolean);
  end;

{fin de l'unité uDrawInfo déplacée}
{début de l'unité uTraits déplacée}
 TArete
 =
  (
  a_Milieu,
  a_Gauche,
  a_Haut  ,
  a_Droite,
  a_Bas
  );
 TProgression_Trait
 =
  class
  //Gestion du cycle de vie
  public
    constructor Create;
    destructor Destroy; override;
  //Attributs
  public
    Debut, Arrivee: TArete;
    Step: Integer;
  end;
 TLigne
 =
  class
  //Gestion du cycle de vie
  public
    constructor Create;
    destructor Destroy; override;
  //Attributs
  public
    bl_1,
    bl_2: TObject;
    x1,y1,
    x2,y2: Integer;
    IndiceColonne: Integer;
  //Clé
  public
    function sCle: String;
  //Progressions
  private
    FHorizontal: TProgression_Trait;
    FAngle     : TProgression_Trait;
    FVertical  : TProgression_Trait;
    procedure Assure_Progression( var pt: TProgression_Trait);
  public
    function Horizontal: TProgression_Trait;
    function Angle     : TProgression_Trait;
    function Vertical  : TProgression_Trait;
  end;
 TTrait
 =
  class
  //Gestion du cycle de vie
  public
    constructor Create;
    destructor Destroy; override;
  //Attributs
  public
    Ligne: TLigne;
    Depart, Arrivee: TArete;
    a: double;
    IsDebutLigne, IsFinLigne: Boolean;
  //Méthodes
  public
    procedure {svg}Dessinne(  DrawInfo: TDrawInfo);
  end;
 TTraits
 =
  class
  //Gestion du cycle de vie
  public
    constructor Create;
    destructor Destroy; override;
  //Attributs
  public
    sl: TBatpro_StringList;
  //Méthodes
  public
    function Ajoute( _Ligne: TLigne;
                      _Depart, _Arrivee: TArete): TTrait;
    procedure {svg}Dessinne( DrawInfo: TDrawInfo);
    procedure Vide;
  end;

{fin de l'unité uTraits déplacée}

  {$IFNDEF WINDOWS_GRAPHIC}

  { TPopupMenu }

  TPopupMenu
  =
   class
     constructor create( _object: TObject);
   end;

  { TMenuItem }

  TMenuItem
  =
   class
     constructor create( _object: TObject);
   end;

  TMouseButton=TObject;
  {$ELSE}
  TPopupMenu= Menus.TPopupMenu;
  TMenuItem=Menus.TMenuItem;
  TMouseButton=Controls.TMouseButton;
  {$ENDIF}
  TTypeJalon = (
               tj_Losange, tj_LosangePlein,
               tj_Ellipse, tj_TraitVertical, tj_Puce,
               tj_Triangle_vers_droite,
               tj_Jalon_Debut, tj_Jalon_Fin,
               tj_Jalon_Trait_Epais_Debut, tj_Jalon_Trait_Epais_Fin,
               tj_Login,
               tj_MEN_AT_WORK,
               tj_DOSSIER_KDE_PAR_POSTE
               );
  TStyleSerie
  =
   (
   ss_TraitFin,
   ss_TraitEpais,
   ss_DemiLigne,
   ss_DemiLigne_Pointille,
   ss_DemiLigne_Points
   );

 IBatpro_Element_Editeur
 =
  interface
  ['{64BF044D-1965-45D8-9DA5-389664F8F606}']//généré dans Delphi par(Maj+Ctrl+G)
    function Edite( be: TBatpro_Element): Boolean;
  end;

 { TBatpro_Element }

 TBatpro_Element
 =
  class( TChampsProvider)
  //Gestion du cycle de vie
  public
    constructor Create( _sl: TBatpro_StringList);
    destructor Destroy; override;
  //Gestion de la taille en pixels
  protected
    Retrait_Texte: Integer;
    function Cell_Width_Interne (DrawInfo: TDrawInfo;F:TFont;Texte:String):Integer;
    function Cell_Height_Interne(DrawInfo: TDrawInfo;F:TFont;Texte:String;
                                 Cell_Width: Integer): Integer;
    function MargeX( DrawInfo: TDrawInfo): Integer;
    function MargeY( DrawInfo: TDrawInfo): Integer;
    function  Width_Externe_from_Interne( DrawInfo: TDrawInfo; Valeur: Integer): Integer;
    function Height_Externe_from_Interne( DrawInfo: TDrawInfo; Valeur: Integer): Integer;
    function  Width_Interne_from_Externe( DrawInfo: TDrawInfo; Valeur: Integer): Integer;
    function Height_Interne_from_Externe( DrawInfo: TDrawInfo; Valeur: Integer): Integer;
    function Rect_Interne_from_Externe( DrawInfo: TDrawInfo; Valeur: TRect): TRect;
    function Rect_Externe_from_Interne( DrawInfo: TDrawInfo; Valeur: TRect): TRect;
    function Rectangle_Aligne( R: TRect; Alignement: TbeAlignement; Largeur, Hauteur: Integer):TRect;
  public
    function Cell_Height( _DrawInfo: TDrawInfo; _Cell_Width: Integer): Integer; virtual;
    function Cell_Width( DrawInfo: TDrawInfo): Integer; virtual;
  //Gestion de l'orientation
  public
    function OrientationTexte( DrawInfo: TDrawInfo): Integer; virtual;
  //Gestion du texte de cellule
  protected
    function GetCell( Contexte: Integer): String; virtual;
  public
    property Cell[ Contexte: Integer]: String read GetCell;
  //Gestion de l'export vers un tableur
  protected
    function GetTableurCell( Contexte: Integer): String; virtual;
  public
    property TableurCell[ Contexte: Integer]: String read GetTableurCell;
  //Gestion du Hint
  public
    Contenu_statique: String;
    function Contenu( Contexte: Integer; Col, Row: Integer): String; virtual;
  //Gestion de la sélection
  protected
    FSelected: Boolean;
    procedure SetSelected( Value: Boolean); virtual;
  public
    property Selected: Boolean read FSelected write SetSelected;
  //Gestion des séries
  public
    Serie: TBatpro_Serie;
    procedure Cree_Serie;
  //Gestion des clusters
  public
    Cluster:TBatpro_Cluster;
    procedure Cree_Cluster;
    function sEtatCluster: String;
  //Gestion de l'édition
  public
    function Edite: Boolean; virtual;
  //Flag de création, à gérer classe par classe
  protected
    Creating: Boolean;
  //Général
  public
    sl: TBatpro_StringList;
    Fond: TColor;
    Tag: TObject;
  //Paramètres de classe
  private
    function Batpro_ElementClassesParams_nil: Boolean;
  protected
    Instance_Font: TFont;
  public
    function ClassFont( DrawInfo: TDrawInfo): TFont; virtual;
    function Has_ClassParams: Boolean;
    function ClassParams: TBatpro_ElementClassParams;
    function Init_ClassParams: TBatpro_ElementClassParams;
  //Affichage
  public
    Aggrandir_a_l_impression: Boolean;
    function {svg}Draw_Text( DrawInfo: TDrawInfo; Alignement: TbeAlignement;
                             Text: String; Font: TFont): Integer; virtual;
    procedure Draw( DrawInfo: TDrawInfo); virtual;
    function MulDiv_Color( Color: TColor; Mul_, Div_: Integer): TColor;
    function _3D_Clair( Color: TColor): TColor;
    function _3D_Sombre( Color: TColor): TColor;
    function OffsetPoint( P: TPoint; dx, dy: Integer): TPoint;
    procedure DrawFrameButton_Color( Canvas: TCanvas; Color: TColor; R: TRect);
    procedure {svg}Dessinne_Fond( DrawInfo: TDrawInfo); virtual;
    function Get_Alignement( Contexte: Integer): TbeAlignement; virtual;
    function VerticalHorizontal_( Contexte: Integer): Boolean; virtual;
    function Couleur_Fond(DrawInfo: TDrawInfo): TColor; virtual;
    procedure {svg}Dessinne_Gris(DrawInfo: TDrawInfo);
    procedure {svg}DrawJalon( DrawInfo: TDrawInfo; Forme: TTypeJalon;
                         CouleurJalon: TColor;
                         CouleurJalon_Contour : TColor= clBlack;
                         Note: Boolean= False);
    function Cree_Fonte( DrawInfo: TDrawInfo; Gras: Boolean): TFont;
  //Affichage SVG
  public
    procedure svgDraw( DrawInfo: TDrawInfo); virtual;
  //Menu contextuel
  protected
    FPopupMenu: TPopupMenu;
    miContexteFont: TMenuItem;
    function Assure_PopupMenu: Boolean; virtual;
    procedure miContexteFontCLick( Sender:TObject);
  public
    function Popup( Contexte: Integer): TPopupMenu; virtual;
  //Gestion de la composition de la bulle d'aide
  private
    miBulle: TMenuItem;
    procedure miBulleCLick( Sender:TObject);
  public
    procedure EditeBulle( Contexte: Integer); virtual;
  //Gestion de la souris
  public
    function MouseDown( Button: TMouseButton; Shift: TShiftState): Boolean; virtual;
  //Gestion de la clé
  public
    function sCle: String; virtual;
    function Index: Integer;
    procedure sl_from_sCle;
  //Connection entre éléments
  public
    // méthode ajoutée pour le planning pour assurer la mise à jour
    // des aggrégations faibles lors de la destruction de l'élément aggégé be .
    procedure Unlink( be: TBatpro_Element); virtual;
  //Suppression de la connection dans la base
  public
    procedure Supprime_Connection( be: TBatpro_Element); virtual;
  //Comparaison
  public
    function Egale( be: TBatpro_Element): Boolean; virtual;
  //Dessin d'une bordure
  private
    FBordure: Boolean;
  protected
    function GetBordure: Boolean; virtual;
  public
    property Bordure: Boolean read GetBordure write FBordure;
    procedure {svg}Dessinne_Bordure( DrawInfo: TDrawInfo);
  //Aggrégeurs : liste des objets ThAggregation qui contiennent cet objet
  private
    FAggregeurs: TBatpro_StringList;
    function GetAggregeurs: TBatpro_StringList;
  public
    property Aggregeurs: TBatpro_StringList read GetAggregeurs;
  //Connecteurs : liste des objets TBatpro_element qui ont un pointeur vers cet objet
  //Connectes   : liste de pointeurs vers des objets TBatpro_element
  private
    FConnecteurs: TslBatpro_Element;
    FConnectes: TslBatpro_Element;
    function GetConnecteurs: TslBatpro_Element;
    function GetConnectes: TslBatpro_Element;
    //Fonctionne à l'endroit sur Self.FConnecteurs
    procedure Connecteurs_Ajoute( _be: TBatpro_Element; _Nom: String= '');
    procedure Connecteurs_Enleve( _be: TBatpro_Element);
  public
    property Connecteurs: TslBatpro_Element read GetConnecteurs;
    property Connectes: TslBatpro_Element read GetConnectes;
    //On fonctionne à l'envers sur  _be.FConnecteurs
    procedure Connect_To( _be: TBatpro_Element; _Nom: String= '');
    procedure Unconnect_To( var _be; _Contexte: String= '');
  //Gestion des traits de connection
  private
    FTraits: TTraits;
    function GetTraits: TTraits;
  public
    property Traits: TTraits read GetTraits;
  //BECP: Batpro_ElementClassParams
  //alternative à l'interface IblG_BECP utilisée précédemment
  //jeu de méthodes seulement définies dans TblG_BECP
  public
    asBECP: TBatpro_ElementClassParams;
    function BECP_GetNomClasse: String; virtual;
    function BECP_GetLibelle  : String; virtual;
    function BECP_GetContexteFont( Contexte: Integer): TFont ; virtual;
    function BECP_GetFont: TFont ; virtual;
    function BECP_GetSauver   : Boolean; virtual;
    function BECP_GetEditeur: IBatpro_Element_Editeur; virtual;

    procedure BECP_SetNomClasse(Value: String ); virtual;
    procedure BECP_SetLibelle  (Value: String ); virtual;
    procedure BECP_SetSauver   (Value: Boolean); virtual;
    procedure BECP_SetEditeur( Value: IBatpro_Element_Editeur); virtual;

    procedure BECP_Edit_ContexteFont( Contexte: Integer); virtual;

    procedure BECP_Save_to_database; virtual;
  //Aggrégations
  private
    FAggregations: TAggregations;
    function GetAggregations: TAggregations;
  protected
    procedure Create_Aggregation( Name: String; P: ThAggregation_Create_Params); virtual;
    procedure Get_Aggregation( var Resultat; var Fha;
                               Name: String;
                               Classe_Aggregation: ThAggregation_class= nil);
  public
    property Aggregations: TAggregations read GetAggregations;
  //Listing des champs pour déboguage
  public
    function Listing_Champs( Separateur: String): String; virtual;
    function Listing( Indentation: String): String; virtual;
  //Vérification de la cohérence
  public
    procedure Verifie_coherence( var _log: String); virtual;
  end;

 TbeClusterElement
 =
  class( TBatpro_Element)
  private
    FbeCluster: TBatpro_Element;
  protected
    function GetCell(Contexte: Integer): String; override;

  public
    constructor Create( un_sl: TBatpro_StringList; _beCluster: TBatpro_Element);
    procedure Draw(DrawInfo: TDrawInfo); override;

    function Cell_Height( _DrawInfo: TDrawInfo; _Cell_Width: Integer): Integer; override;
    procedure CalculeLargeur( DrawInfo: TDrawInfo;
                              Colonne, Ligne: Integer;
                              var Largeur: Integer);
    procedure CalculeHauteur( DrawInfo: TDrawInfo;
                              Colonne, Ligne: Integer;
                              var Hauteur: Integer);
    procedure Initialise;
    procedure Ajoute( Colonne, Ligne: Integer);
    function  sEtatCluster: String;
    property beCluster: TBatpro_Element read FbeCluster;

  //Affichage SVG
  public
    procedure svgDraw( DrawInfo: TDrawInfo); override;
  //Contenu
  public
    function Contenu(Contexte: Integer; Col: Integer; Row: Integer): String; override;
  end;

 TBatpro_ElementClassParams
 =
  class
  //Gestion du cycle de vie
  public
    constructor Create( _be: TBatpro_element);
    destructor Destroy; override;
  //Attributs
  public
    be: TBatpro_element;
  //Méthodes
    function GetNomClasse: String;
    function GetLibelle  : String;
    function GetContexteFont( Contexte: Integer): TFont ;
    function GetFont: TFont ;
    function GetSauver   : Boolean;
    function GetEditeur: IBatpro_Element_Editeur;

    procedure SetNomClasse(Value: String );
    procedure SetLibelle  (Value: String );
    procedure SetSauver   (Value: Boolean);
    procedure SetEditeur( Value: IBatpro_Element_Editeur);

    procedure Edit_ContexteFont( Contexte: Integer);

    procedure Save_to_database;
  public
    property NomClasse: String  read GetNomClasse write SetNomClasse;
    property Libelle  : String  read GetLibelle   write SetLibelle  ;
    property Titre    : String  read GetLibelle   write SetLibelle  ;
    property ContexteFont[Contexte: Integer]: TFont read GetContexteFont;
    property Font     : TFont   read GetFont;
    property Sauver   : Boolean read GetSauver    write SetSauver   ;
    property Editeur: IBatpro_Element_Editeur read GetEditeur write SetEditeur;
  end;

 //provisoire
 //pas trés propre au niveau norme de nommage
 //mis pour éviter un gros chercher/remplacer
 IblG_BECP= TBatpro_ElementClassParams;

 TBatpro_Element_Class= class of TBatpro_Element;

 TBatpro_Serie
 =
  class
  private
    EtatInitial: Boolean;
    FDebut       , FFin       : Integer;
    procedure {svg}DrawTraitHorizontal    ( DrawInfo: TDrawInfo; R:TRect;TrameSolide_:Boolean);
    procedure {svg}DrawDemiLigne          ( DrawInfo: TDrawInfo; R:TRect;TrameSolide_:Boolean);
    procedure {svg}DrawDemiLigne_Pointille( DrawInfo: TDrawInfo; R:TRect;TrameSolide_:Boolean);
    procedure {svg}DrawDemiLigne_Points   ( DrawInfo: TDrawInfo; R:TRect;TrameSolide_:Boolean);
  public
    be: TBatpro_Element;
    CellDebut: Boolean;
    Style: TStyleSerie;
    CoefficientEpaisseur: Double;
    Couleur: TColor;
    constructor Create( un_be: TBatpro_Element);

    function Draw               ( DrawInfo: TDrawInfo): Boolean;
    procedure Ligne_Serie       ( DrawInfo: TDrawInfo; nJour: Integer); virtual;
    procedure Ligne_DebutSerie  ( DrawInfo: TDrawInfo; nJour: Integer); virtual;
    procedure Ligne_FinSerie    ( DrawInfo: TDrawInfo; nJour: Integer); virtual;
    procedure Affiche_nJour     ( DrawInfo: TDrawInfo; _nJour: Integer);
    procedure {svg}Dessinne_Fond     ( DrawInfo: TDrawInfo);
    procedure Ligne_VisibleFin  ( DrawInfo: TDrawInfo; nJour: Integer);
    procedure Ligne_VisibleDebut( DrawInfo: TDrawInfo; nJour: Integer);
    function VerticalHorizontal_( Contexte: Integer): Boolean;

    property Debut: Integer read FDebut;
    property Fin  : Integer read FFin  ;

    procedure Initialise;
    procedure Ajoute( _Debut, _Fin: Integer);
    procedure Decale( Delta: Integer);
  //Affichage SVG
  public
    function  svgDraw               ( _DrawInfo: TDrawInfo): Boolean;
    procedure svgLigne_Serie       ( _DrawInfo: TDrawInfo; nJour: Integer); virtual;
    procedure svgLigne_DebutSerie  ( _DrawInfo: TDrawInfo; nJour: Integer); virtual;
    procedure svgLigne_FinSerie    ( _DrawInfo: TDrawInfo; nJour: Integer); virtual;
    procedure svgAffiche_nJour     ( _DrawInfo: TDrawInfo; _nJour: Integer);
    procedure svgLigne_VisibleFin  ( _DrawInfo: TDrawInfo; nJour: Integer);
    procedure svgLigne_VisibleDebut( _DrawInfo: TDrawInfo; nJour: Integer);
  //Gestion nJour
  private
    function snJour_from_nJour( _nJour: Integer): String;
  //Pourcentage de progression
  public
    Pourcentage: double;
    nPourcentage: double;
    Pourcentage_2: double;
    nPourcentage_2: double;
  //Gestion de la visibilité
  private
    // Debut <= VisibleDebut <= VisibleFin <= Fin
    FVisibleDebut: Integer;
    FVisibleFin  : Integer;
  public
    property VisibleDebut: Integer read FVisibleDebut;
    property VisibleFin  : Integer read FVisibleFin  ;
    procedure SetVisible( _VisibleDebut, _VisibleFin: Integer);
  //Calcul de l'index
  private
    function Index_from_DrawInfo( DrawInfo: TDrawInfo): Integer;
  //Dessin de l'avancement
  private
    procedure {svg}Dessinne_Pourcentage_interne_interne( _DrawInfo: TDrawInfo;
                                                         _Index: Integer;
                                                         _Pourcentage: double;
                                                         _nPourcentage: double;
                                                         _Y: Integer;
                                                         _Color: TColor);
    procedure {svg}Dessinne_Pourcentage_interne( DrawInfo: TDrawInfo; Index: Integer);
  public
    procedure {svg}Dessinne_Pourcentage( DrawInfo: TDrawInfo);
  //Dessin de l'avancement 2
  private
    procedure {svg}Dessinne_Pourcentage_2_interne( DrawInfo: TDrawInfo; Index: Integer);
  public
    procedure {svg}Dessinne_Pourcentage_2( DrawInfo: TDrawInfo);
  end;

 TBatpro_Cluster
 =
  class
  private
    EtatInitial: Boolean;
  public
    be: TBatpro_Element;
    Bounds: TRect;//attention, ici coordonnées de cellules, pas celles de pixels
    Grains: array of array of TBatpro_Element;
    Largeur, Hauteur: Integer;
    Colonne_LargeurMaxi,
      Ligne_HauteurMaxi: Integer;
    constructor Create( _be: TBatpro_Element);
    procedure Initialise;
    procedure Ajoute( _Grain: TBatpro_Element; _Colonne, _Ligne: Integer);
    function SingleRow: Boolean;
    procedure CalculeLargeur( _DrawInfo: TDrawInfo;
                              _Colonne, _Ligne: Integer;
                              var _Largeur: Integer);
    procedure CalculeHauteur( _DrawInfo: TDrawInfo;
                              _Colonne, _Ligne: Integer;
                              var _Hauteur: Integer);
    procedure Check_LargeurTotale( var _LargeurTotale: Integer);
    procedure Check_HauteurTotale( var _HauteurTotale: Integer);
    function Cherche( _Grain: TBatpro_Element): TPoint;
  //Affichage de l'état du cluster
  public
    function sEtat: String;
  end;

  TBatpro_ElementClassesParams= function :TbtString of object;
  TpoolG_BECP_Cree_Function= function (_NomClasse: String):TBatpro_ElementClassParams of object;
  TpoolG_BECP_Get_by_Cle= function ( _nomclasse: String): TBatpro_ElementClassParams of object;

 TIterateur_Batpro_Element
 =
  class( TIterateur)
  //Iterateur
  public
    procedure Suivant( out _Resultat: TBatpro_Element);
    function  not_Suivant( out _Resultat: TBatpro_Element): Boolean;
  end;

 TslBatpro_Element
 =
  class( TBatpro_StringList)
  //Gestion du cycle de vie
  public
    constructor Create( _Nom: String= ''); override;
    destructor Destroy; override;
  //Création d'itérateur
  protected
    class function Classe_Iterateur: TIterateur_Class; override;
  public
    function Iterateur: TIterateur_Batpro_Element;
    function Iterateur_Decroissant: TIterateur_Batpro_Element;
  end;

 THTTP_Interface_Ancetre
 =
  class
  //méthodes d'envoi de données
  public
    procedure Send_Data(_Content_type, _Data: String);         virtual;abstract;
    procedure Send_Fichier( _NomFichier: String);              virtual;abstract;
    procedure Send_HTML(_HTML: String);                        virtual;abstract;
    procedure Send_JSON(_JSON: String);                        virtual;abstract;
    procedure Send_Text(_Text: String);                        virtual;abstract;
    procedure Send_JS(_JS: String);                            virtual;abstract;
    procedure Send_CSS(_CSS: String);                          virtual;abstract;
    procedure Send_WOFF(_WOFF: String);                        virtual;abstract;
    procedure Send_WOFF2(_WOFF2: String);                      virtual;abstract;
    procedure Send_ICO(_ICO: String);                          virtual;abstract;
    procedure Send_MIME_from_Extension(_S, _Extension: String);virtual;abstract;
    procedure Send_Not_found;                                  virtual;abstract;
  //Traitement des appels
  public
    uri: String;
    uri_lowercase: String;
    body: String;
    function Prefixe( _Prefixe: String): Boolean;              virtual;abstract;
  end;

 { Tpool_Ancetre_Ancetre }
 Tpool_Ancetre_Ancetre= class;

 TIterateur_pool_Ancetre_Ancetre
 =
  class( TIterateur)
  //Iterateur
  public
    procedure Suivant( var _Resultat: Tpool_Ancetre_Ancetre);
    function  not_Suivant( var _Resultat: Tpool_Ancetre_Ancetre): Boolean;
  end;

 Tslpool_Ancetre_Ancetre
 =
  class( TBatpro_StringList)
  //Gestion du cycle de vie
  public
    constructor Create( _Nom: String= ''); override;
    destructor Destroy; override;
  //Cr?ation d'it?rateur
  protected
    class function Classe_Iterateur: TIterateur_Class; override;
  public
    function Iterateur: TIterateur_pool_Ancetre_Ancetre;
    function Iterateur_Decroissant: TIterateur_pool_Ancetre_Ancetre;
  end;

 Tpool_Ancetre_Ancetre_Class= class of Tpool_Ancetre_Ancetre;

 Tpool_Ancetre_Ancetre
 =
  class( TBatpro_Element)
  //Gestion du cycle de vie
  public
    constructor Create( _sl: TBatpro_StringList);reintroduce;virtual;
    destructor Destroy; override;
  public
    class function Name: String;
  //Gestion de la clé
  public
    procedure sCle_Change( _bl: TBatpro_element); virtual; 
  //Suppression
  public
    procedure Supprimer( var bl); virtual; abstract;
  //Nom de la table
  protected
    FNomTable: String;
    procedure SetNomTable(const Value: String); virtual; abstract;
    property NomTable: String read FNomTable write SetNomTable;
  public
    property NomTable_public: String read FNomTable;
  //Gestion communication HTTP avec pages html Angular / JSON
  public
    function Traite_HTTP( _HTTP_Interface: THTTP_Interface_Ancetre): Boolean; virtual; abstract;
  //Logique de classe pour la gestion des instances
  private
    class var Fclass_sl: Tslpool_Ancetre_Ancetre;
  public
    class function class_sl: Tslpool_Ancetre_Ancetre;
    class procedure class_Create (               var Reference ; Classe: Tpool_Ancetre_Ancetre_Class);
    class procedure class_Destroy(               var Reference                                      );
    class procedure class_Get    ( out Resultat; var Reference ; Classe: Tpool_Ancetre_Ancetre_Class);
  end;

 Tfunction_pool_Ancetre_Ancetre= function : Tpool_Ancetre_Ancetre;

 ThAggregation= class;

 TIterateur_hAggregation
 =
  class( TIterateur)
  //Iterateur
  public
    procedure Suivant( out _Resultat: ThAggregation);
    function  not_Suivant( out _Resultat: ThAggregation): Boolean;
  end;

 TslhAggregation
 =
  class( TBatpro_StringList)
  //Gestion du cycle de vie
  public
    constructor Create( _Nom: String= ''); override;
    destructor Destroy; override;
  //Création d'itérateur
  protected
    class function Classe_Iterateur: TIterateur_Class; override;
  public
    function Iterateur: TIterateur_hAggregation;
    function Iterateur_Decroissant: TIterateur_hAggregation;
  end;

 { ThAggregation }

 ThAggregation
 =
  class( TBatpro_StringList)
  //Gestion du cycle de vie
  public
    constructor Create( _Parent: TBatpro_Element;
                        _Classe_Elements: TBatpro_Element_Class;
                        _pool_Ancetre_Ancetre: Tpool_Ancetre_Ancetre); reintroduce;virtual; 
    destructor Destroy; override;
  //Attributs
  public
    Parent: TBatpro_Element;
    pool_Ancetre_Ancetre: Tpool_Ancetre_Ancetre;
    function sl: TBatpro_StringList; // provisioire, retourne self
  //Intermédiaire de chargement pour gérer les aggrégeurs
  protected
    slCharge: TBatpro_StringList;
    procedure Cree_slCharge; virtual;
    procedure Ajoute_slCharge;
  //Méthodes
  public
    function Is_Vide: Boolean;
    function Contient( be: TBatpro_Element): Boolean;
  //Vidage
  public
    procedure Vide; virtual;
  //Chargement de tous les détails
  public
    procedure Charge; virtual;
  //Chargement 1 fois
  private
    Assure_Charge_premier: Boolean;
  public
    procedure Assure_Charge;
  //Connection / Déconnection simple
  public
    procedure Ajoute( be: TBatpro_Element); virtual;
    procedure Enleve( _be: TBatpro_Element; _Index: Integer= -1); virtual;
    procedure Deconnecte;           virtual;
  //Déconnection avec suppression des connections dans la base de données
  public
    procedure Supprime_Connection( be: TBatpro_Element; Index: Integer= -1); virtual;
    procedure Supprime_Connections; virtual;
  //Gestion de la liste des aggregeurs
  private
    procedure Enleve_dans_be_Aggregeurs( be: TBatpro_Element);
  //Suppression
  public
    procedure Delete_from_database; virtual;
  //Gestion de la copie depuis une autre aggrégation
  public
    procedure Copy_from( _hAggregation: ThAggregation); virtual;
  //Export JSON, JavaScript Object Notation
  public
    function JSON: String; override;
    function JSON_Persistants: String; override;
  //Type d'aggrégation: forte ou faible
  public
    Forte: Boolean;
  //Listing des champs pour déboguage
  public
    function Listing( Indentation: String): String; virtual;
  //Gestion de la clé
  public
    procedure sCle_Change( _bl: TBatpro_Element);
  end;

 ThAggregation_Create_Params
 =
  class
  //Gestion du cycle de vie
  public
    constructor Create( _Parent: TBatpro_Element);
    destructor Destroy; override;
  //Paramètres constant au cours du cycle de vie
  public
    Parent: TBatpro_Element;
  //Paramètres modifiés à chaque utilisation
  private
    hAggregation_class  : ThAggregation_class;
    Batpro_Element_Class: TBatpro_Element_Class;
    pool_Ancetre_Ancetre: Tpool_Ancetre_Ancetre;
    Is_Forte            : Boolean;
  //Méthodes
  public
    procedure I( _hAggregation_class  : ThAggregation_class  ;
                 _Batpro_Element_Class: TBatpro_Element_Class;
                 _pool_Ancetre_Ancetre: Tpool_Ancetre_Ancetre;
                 _Is_Forte            : Boolean              );
    procedure Forte( _hAggregation_class  : ThAggregation_class  ;
                     _Batpro_Element_Class: TBatpro_Element_Class;
                     _pool_Ancetre_Ancetre: Tpool_Ancetre_Ancetre);
    procedure Faible( _hAggregation_class  : ThAggregation_class  ;
                      _Batpro_Element_Class: TBatpro_Element_Class;
                      _pool_Ancetre_Ancetre: Tpool_Ancetre_Ancetre);
    function Instancie:ThAggregation;
  end;

 TCreate_Aggregation_procedure= procedure ( Name: String; P: ThAggregation_Create_Params) of object;

 { TAggregations }

 TAggregations //liste de ThAggregation
 =
  class
  //Gestion du cycle de vie
  public
    constructor Create( _Parent: TBatpro_Element;
                        _Create_Aggregation: TCreate_Aggregation_procedure);
    destructor Destroy; override;
  //Attributs
  private
    Create_Params: ThAggregation_Create_Params;
    Create_Aggregation: TCreate_Aggregation_procedure;
    sl: TslhAggregation;
  //Accés
  private
    function  Get_by_Name( Name: String): ThAggregation;
    procedure Set_by_Name( Name: String; const Value: ThAggregation);
  public
    property by_Name[ Name: String]:ThAggregation
             read  Get_by_Name
             write Set_by_Name; default;
    function Iterateur: TIterateur_hAggregation;
  //Déconnection simple
  public
    procedure Deconnecte;
  //Déconnection avec suppression de la connection dans la base de données
  public
    procedure Supprime_Connections;
  //Export JSON, JavaScript Object Notation
  public
    function JSON: String;
    function JSON_Persistants: String;
  //Suppression
  public
    procedure Delete_from_database; 
  //Listing des champs pour déboguage
  public
    function Listing( Indentation: String): String;
  //Gestion de la clé
  public
    procedure sCle_Change( _bl: TBatpro_Element);
  end;

function hAggregation_from_sl( sl: TStringList; Index: Integer): ThAggregation;

var
   uhAggregation_Deconnecte_contexte: String= '';

var
   Batpro_ElementClassesParams: TBatpro_ElementClassesParams;
   //poolG_BECP_Get_by_Cle: TpoolG_BECP_Get_by_Cle = nil;
   Classe_TBatpro_Element: TBatpro_ElementClassParams= nil;
   Classe_TblG_BECP      : TBatpro_ElementClassParams= nil;
   Classe_TblG_BECPCTX   : TBatpro_ElementClassParams= nil;
   poolG_BECP_Cree: TpoolG_BECP_Cree_Function= nil;
   uBatpro_Element_Afficher_Grille: Boolean= True;

procedure OffsetRect( var _R: TRect; _dx, _dy: Integer);

procedure InflateRect( var _R: TRect; _dx, _dy: Integer);
function MulDiv( Nombre, Numerateur, Denominateur: Integer): Integer;

function Ligne_from_sl( sl: TStringList; Index: Integer): TLigne;
function Ligne_from_sl_sCle( sl: TStringList; sCle: String): TLigne;

function Batpro_Element_from_sl( sl: TStringList; Index: Integer): TBatpro_Element;

function Batpro_Element_from_sl_sCle( sl: TStringList; sCle: String): TBatpro_Element;

procedure slAjoute( L: TBatpro_StringList; be: TBatpro_Element);

procedure slExtrait_SousListe( Source: TBatpro_StringList; sCle: String; Cible: TBatpro_StringList);

procedure sl_ToutSelectionner( _sl: TBatpro_StringList);
procedure sl_ToutDeselectionner( _sl: TBatpro_StringList);

type
 TPlace_function_result = ( pfr_Success, pfr_Index_negatif, pfr_Deja_pris);

function Place( sl: TBatpro_StringList; Index: Integer; S: String; O: TObject;
                Contexte_si_erreur: String;
                Modal_si_erreur: Boolean = True): TPlace_function_result;
function Description_Objet( Titre: String; O: TObject): String;

procedure Copie         ( Source: TBatpro_StringList; IndexSource: Integer; Cible: TBatpro_StringList);
procedure Transfere     ( Source: TBatpro_StringList; IndexSource: Integer; Cible: TBatpro_StringList);
procedure AjouteListe   ( Source: TBatpro_StringList; Cible: array of TBatpro_StringList);
procedure AssureLongueur( sl: TBatpro_StringList; Longueur: Integer; sCle: String);

procedure Affiche_Classes( Titre: String; sl: TBatpro_StringList);

function beClusterElement_from_sl( sl: TBatpro_StringList; Index: Integer): TbeClusterElement;

procedure Initialise_Clusters( sl: TBatpro_StringList); overload;
procedure Initialise_Clusters( bts: TbtString); overload;

procedure Vide_StringGrid( _sg: TStringGridWeb);

procedure Vide_StringGrid_Liste( _sg: TStringGridWeb);

{Début de l'ancienne unité uDessin}
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
{Fin de l'ancienne unité uDessin}
{Début de l'ancienne unité uWindows}
var
   //bords non 3D
   CXBORDER, CYBORDER: Integer;
   //bords 3D
   CXEDGE  , CYEDGE  : Integer;
{Fin de l'ancienne unité uWindows}


implementation

{Début de l'ancienne unité uDessin}
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
{Fin de l'ancienne unité uDessin}

procedure Vide_StringGrid( _sg: TStringGridWeb);
var
   Ligne, Colonne: Integer;
begin
     if _sg = nil then exit;
     for Ligne:= 0 to _sg.RowCount - 1
     do
       for Colonne:= 0 to _sg.ColCount - 1
       do
         begin
         _sg.Objects[ Colonne, Ligne]:= nil;
         _sg.Cells[ Colonne, Ligne]:= sys_Vide;
         end;
end;

procedure Vide_StringGrid_Liste( _sg: TStringGridWeb);
var
   Ligne, Colonne: Integer;
begin
     if _sg = nil then exit;
     Colonne:= 0;
     for Ligne:= 0 to _sg.RowCount - 1
     do
       begin
       _sg.Objects[ Colonne, Ligne]:= nil;
       _sg.Cells[ Colonne, Ligne]:= sys_Vide;
       end;
end;

{ TStringGridWeb }

constructor TStringGridWeb.Create;
begin
     ColCount:= 0;
     RowCount:= 0;
     Resize;
end;

destructor TStringGridWeb.Destroy;
begin
     inherited Destroy;
end;

procedure TStringGridWeb.Resize( _ColCount: Integer= -1; _RowCount: Integer= -1);
var
   I: Integer;
begin
     if _ColCount <> -1 then FColCount:= _ColCount;
     if _RowCount <> -1 then FRowCount:= _RowCount;

     SetLength( FColWidths , ColCount);
     SetLength( FRowHeights, RowCount);
     for I:= Low(FColWidths) to High(FColWidths) do FColWidths[I]:= -1;
     for I:= Low(FRowHeights) to High(FRowHeights) do FRowHeights[I]:= -1;

     SetLength( FObjects, ColCount, RowCount);
     SetLength( FCells  , ColCount, RowCount);
end;

procedure TStringGridWeb.Charge_Cell( _Colonne, _Ligne: Integer; _be: TBatpro_Element; _Contexte: Integer);
begin
     if _be = nil
     then
         begin
         Cells  [ _Colonne, _Ligne]:= sys_Vide;
         Objects[ _Colonne, _Ligne]:= nil;
         end
     else
         begin
         Cells  [ _Colonne, _Ligne]:= _be.Cell[ _Contexte];
         Objects[ _Colonne, _Ligne]:= _be;
         end;
end;

procedure TStringGridWeb.Charge_Ligne( _OffsetColonne, _Ligne: Integer;
                                       _sl: TBatpro_StringList;
                                       _ClusterAddInit_: Boolean;
                                       _Contexte: Integer); overload;
var
   I,
   Colonne: Integer;
   BE: TBatpro_Element;
   beClusterElement: TbeClusterElement;
   Cell: String;
begin
     if not _ClusterAddInit_
     then
         Initialise_Clusters( _sl);

     for I:= 0 to _sl.Count-1
     do
       begin
       Colonne:= _OffsetColonne+I;

       BE:= Batpro_Element_from_sl( _sl, I);
       if Assigned( BE)
       then
           begin
           Cell:= BE.Cell[ _Contexte];
           if BE is TbeClusterElement
           then
               begin
               beClusterElement:= TbeClusterElement( BE);
               beClusterElement.Ajoute( Colonne, _Ligne);
               end
           end
       else
           Cell:= _sl.Strings[ I];

       Cells  [ Colonne, _Ligne]:= Cell;
       Objects[ Colonne, _Ligne]:= _sl.Objects[ I];
       end;
end;

procedure TStringGridWeb.Charge_Colonne( _Colonne, _OffsetLigne: Integer;
                                         _sl: TBatpro_StringList;
                                         _Contexte: Integer);
var
   Ligne: Integer;
   BE: TBatpro_Element;
   Cell: String;
begin
     for Ligne:= 0 to _sl.Count-1
     do
       begin
       BE:= Batpro_Element_from_sl( _sl, Ligne);
       if Assigned( BE)
       then
           Cell:= BE.Cell[ _Contexte]
       else
           Cell:= _sl.Strings[ Ligne];
       Cells  [ _Colonne, _OffsetLigne+Ligne]:= Cell;
       Objects[ _Colonne, _OffsetLigne+Ligne]:= _sl.Objects[ Ligne];
       end;
end;

procedure TStringGridWeb.Charge_Colonne( _Colonne, _OffsetLigne: Integer;
                                         _beEntete: TBatpro_Element;
                                         _sl: TBatpro_StringList;
                                         _Contexte: Integer);
begin
     Charge_Cell   ( _Colonne, _OffsetLigne-1, _beEntete, _Contexte);
     Charge_Colonne( _Colonne, _OffsetLigne  , _sl      , _Contexte);
end;

procedure TStringGridWeb.Charge_Ligne( _OffsetColonne, _Ligne: Integer;
                                       _bts: TbtString;
                                       _ClusterAddInit_: Boolean;
                                       _Contexte: Integer); overload;
var
   I,
   Colonne: Integer;
   BE: TBatpro_Element;
   beClusterElement: TbeClusterElement;
   Cell: String;
begin
     if not _ClusterAddInit_
     then
         Initialise_Clusters( _bts);

     I:= -1;
     _bts.Iterateur_Start;
     while not _bts.Iterateur_EOF
     do
       begin
       _bts.Iterateur_Suivant( BE);
       Inc( I);

       Colonne:= _OffsetColonne+I;

       if Assigned( BE)
       then
           begin
           Cell:= BE.Cell[ _Contexte];
           if BE is TbeClusterElement
           then
               begin
               beClusterElement:= TbeClusterElement( BE);
               beClusterElement.Ajoute( Colonne, _Ligne);
               end
           end
       else
           Cell:= sys_Vide;

       Cells  [ Colonne, _Ligne]:= Cell;
       Objects[ Colonne, _Ligne]:= BE;
       end;
end;

procedure TStringGridWeb.Charge_Colonne( _Colonne, _OffsetLigne: Integer;
                                         _bts: TbtString;
                                         _Contexte: Integer);
var
   Ligne: Integer;
   BE: TBatpro_Element;
   Cell: String;
begin
     Ligne:= -1;
     _bts.Iterateur_Start;
     while not _bts.Iterateur_EOF
     do
       begin
       _bts.Iterateur_Suivant( BE);
       Inc( Ligne);

       if Assigned( BE)
       then
           Cell:= BE.Cell[ _Contexte]
       else
           Cell:= sys_Vide;
       Cells  [ _Colonne, _OffsetLigne+Ligne]:= Cell;
       Objects[ _Colonne, _OffsetLigne+Ligne]:= BE;
       end;
end;

procedure TStringGridWeb.Charge_Colonne( _Colonne, _OffsetLigne: Integer;
                                         _beEntete: TBatpro_Element;
                                         _bts: TbtString;
                                         _Contexte: Integer);
begin
     Charge_Cell   ( _Colonne, _OffsetLigne-1, _beEntete, _Contexte);
     Charge_Colonne( _Colonne, _OffsetLigne  , _bts     , _Contexte);
end;

function TStringGridWeb.Hauteur_Ligne( _DrawInfo: TDrawInfo;
                                       _Ligne: Integer;
                                       _TraiterClusters: Boolean): Integer;
var
   Colonne: Integer;
   be: TBatpro_Element;
   be_Height: Integer;
begin
     _DrawInfo.Row:= _Ligne;

     if _TraiterClusters
     then
         Result:= RowHeights[ _Ligne]
     else
         Result:= 0;

     for Colonne:= 0 to ColCount-1
     do
       begin
       be:= Batpro_Element[ Colonne, _Ligne];
       if be = nil then continue;

       _DrawInfo.Col:= Colonne;
            if not( _TraiterClusters or  (be is TbeClusterElement))
       then
           begin
           be_Height:= be.Cell_Height( _DrawInfo, ColWidths[ Colonne]);
           if be_Height > Result
           then
               Result:= be_Height;
           end
       else if      _TraiterClusters and (be is TbeClusterElement)
       then
           begin
           TbeClusterElement(be).CalculeHauteur( _DrawInfo,
                                                 Colonne, _Ligne,
                                                 Result);
           end;
       end;
end;

function TStringGridWeb.Largeur_Colonne( _DrawInfo: TDrawInfo;
                                         _Colonne: Integer;
                                         _TraiterClusters: Boolean): Integer;
var
   Ligne: Integer;
   be: TBatpro_Element;
   be_Width: Integer;
begin
     _DrawInfo.Col:= _Colonne;

     if _TraiterClusters
     then
         Result:= ColWidths[ _Colonne]
     else
         Result:= 0;

     for Ligne:= 0 to RowCount-1
     do
       begin
       be:= Batpro_Element[_Colonne, Ligne];
       if be = nil then continue;
       _DrawInfo.Row:= Ligne;

            if not( _TraiterClusters or  (be is TbeClusterElement))
       then
           begin
           be_Width:= be.Cell_Width( _DrawInfo);
           if be_Width > Result
           then
               Result:= be_Width;
           end
       else if      _TraiterClusters and (be is TbeClusterElement)
       then
           begin
           TbeClusterElement(be).CalculeLargeur( _DrawInfo,
                                                 _Colonne, Ligne,
                                                 Result);
           end;
       end;
end;

procedure TStringGridWeb.Traite_Hauteurs_Lignes( _DrawInfo: TDrawInfo);
var
   Ligne: Integer;
   Max: Integer;
begin
     //première passe sur les cellules non-clusters
     for Ligne:= 0 to RowCount-1
     do
       begin
       Max:= Hauteur_Ligne( _DrawInfo, Ligne, False);
       if Max > 0
       then
           RowHeights[ Ligne]:= Max;
       end;

     //seconde passe sur les cellules clusters
     for Ligne:= 0 to RowCount-1
     do
       begin
       Max:= Hauteur_Ligne( _DrawInfo, Ligne, True);
       if Max > 0
       then
           RowHeights[ Ligne]:= Max;
       end;
end;

procedure TStringGridWeb.Traite_Largeurs_Colonnes( _DrawInfo: TDrawInfo;
                                                   _ColonneDebut: Integer;
                                                   _ColonneFin  : Integer);
var
   Colonne: Integer;
   Max: Integer;
begin
     if _ColonneFin = -1
     then
         _ColonneFin:= ColCount-1;

     //première passe sur les cellules non-clusters
     for Colonne:= _ColonneDebut to _ColonneFin
     do
       begin
       Max:= Largeur_Colonne( _DrawInfo, Colonne, False);
       if Max > 0
       then
           ColWidths[ Colonne]:= Max;
       end;

     //seconde passe sur les cellules clusters
     for Colonne:= _ColonneDebut to _ColonneFin
     do
       begin
       Max:= Largeur_Colonne( _DrawInfo, Colonne, True);
       if Max > 0
       then
           ColWidths[ Colonne]:= Max;
       end;
end;

procedure TStringGridWeb.Egalise_Largeurs_Colonnes( _ColonneDebut,
                                                    _ColonneFin  : Integer);
var
   Colonne: Integer;
   Largeur, LargeurMax: Integer;
begin
     //première passe de détection de la largeur maxi
     LargeurMax:= 0;
     for Colonne:= _ColonneDebut to _ColonneFin
     do
       begin
       Largeur:= ColWidths[ Colonne];
       if LargeurMax < Largeur
       then
           LargeurMax:= Largeur;
       end;

     //Seconde passe pour égaliser
     for Colonne:= _ColonneDebut to _ColonneFin
     do
       ColWidths[ Colonne]:= LargeurMax;
end;

procedure TStringGridWeb.Egalise_Hauteurs_Lignes( _LigneDebut, _LigneFin: Integer);
var
   Ligne: Integer;
   Hauteur, HauteurMax: Integer;
begin
     //première passe de détection de la Hauteur maxi
     HauteurMax:= 0;
     for Ligne:= _LigneDebut to _LigneFin
     do
       begin
       Hauteur:= RowHeights[ Ligne];
       if HauteurMax < Hauteur
       then
           HauteurMax:= Hauteur;
       end;

     //Seconde passe pour égaliser
     for Ligne:= _LigneDebut to _LigneFin
     do
       RowHeights[ Ligne]:= HauteurMax;
end;

procedure TStringGridWeb.Initialise_dimensions( _ColonneDebut: Integer);
var
   Colonne, Ligne: Integer;
begin
     for Colonne:= _ColonneDebut to ColCount-1
     do
       ColWidths[ Colonne]:= DefaultColWidth;

     for Ligne:= 0 to RowCount-1
     do
       RowHeights[ Ligne]:= DefaultRowHeight;
end;

procedure TStringGridWeb.Ajuste_Largeur_Client(_ColonneDebut: Integer);
var
   LargeurDisponible: Integer;
   NbColonnesAjustees: Integer;
   LargeurColonne_avec_GridLineWidth,
   LargeurColonne, Reste: Integer;
   Colonne: Integer;
begin
     LargeurDisponible:= ClientWidth - ColCount*GridLineWidth;
     for Colonne:= 0 to _ColonneDebut-1
     do
       begin
       Dec( LargeurDisponible, ColWidths[ Colonne]);
       Dec( LargeurDisponible, GridLineWidth);
       end;

     NbColonnesAjustees:= ColCount - _ColonneDebut;
     LargeurColonne_avec_GridLineWidth:= LargeurDisponible div NbColonnesAjustees;
     LargeurColonne:= LargeurColonne_avec_GridLineWidth - GridLineWidth;
     Reste:= LargeurDisponible - LargeurColonne_avec_GridLineWidth * NbColonnesAjustees;

     for Colonne:= _ColonneDebut to ColCount-2
     do
       ColWidths[ Colonne]:= LargeurColonne;

     Colonne:= ColCount-1;
     ColWidths[ Colonne]:= LargeurColonne+Reste;
end;

procedure TStringGridWeb.Refresh;
begin

end;

procedure TStringGridWeb.MouseToCell(X, Y: Integer; var ACol, ARow: Longint);
begin

end;

function TStringGridWeb.CellRect( _Col, _Row: Integer): TRect;
var
   I: Integer;
   X, Y: Integer;
begin
     Result:= Rect( 0,0,ColWidths[_Col],RowHeights[_Row]);
     X:= 0;for I:= 0 to _Col-1 do Inc(X, ColWidths [I]);
     Y:= 0;for I:= 0 to _Row-1 do Inc(Y, RowHeights[I]);
     OffsetRect( Result, X, Y);
end;


procedure TStringGridWeb.SetColCount( _Value: Integer);
begin
     if FColCount= _Value then exit;

     FColCount:= _Value;
     Resize;
end;

procedure TStringGridWeb.SetRowCount( _Value: Integer);
begin
     if FRowCount=_Value then exit;

     FRowCount:=_Value;
     Resize;
end;

function TStringGridWeb.GetColWidths(Index: Integer): Integer;
begin
     Result:= FColWidths[Index];
     if -1 = Result
     then
         Result:= DefaultColWidth;
end;

procedure TStringGridWeb.SetColWidths(Index: Integer; _Value: Integer);
begin
     FColWidths[Index]:= _Value;
end;

function TStringGridWeb.GetRowHeights(Index: Integer): Integer;
begin
     Result:= FRowHeights[Index];
     if -1 = Result
     then
         Result:= DefaultRowHeight;
end;

procedure TStringGridWeb.SetRowHeights(Index: Integer; _Value: Integer);
begin
     FColWidths[Index]:= _Value;
end;

function TStringGridWeb.GetCell(_Col, _Row: Integer): String;
begin
     Result:= FCells[_Col][_Row];
end;

procedure TStringGridWeb.SetCell(_Col, _Row: Integer; _Value: String);
begin
     FCells[_Col][_Row]:= _Value;
end;

function TStringGridWeb.GetObject( _Col, _Row: Integer): TObject;
begin
     Result:= nil;

     if _Col     <  0    then exit;
     if ColCount <= _Col then exit;

     if _Row     <  0    then exit;
     if RowCount <= _Row then exit;

     Result:= FObjects[_Col][_Row];
end;

procedure TStringGridWeb.SetObject( _Col, _Row: Integer; _Value: TObject);
begin
     if _Col     <  0    then exit;
     if ColCount <= _Col then exit;

     if _Row     <  0    then exit;
     if RowCount <= _Row then exit;

     FObjects[_Col][_Row]:= _Value;
end;

function TStringGridWeb.GetBatpro_Element( _Col, _Row: Integer): TBatpro_Element;
begin
     Affecte_( Result, TBatpro_Element, Objects[ _Col, _Row]);
end;

procedure TStringGridWeb.SetBatpro_Element( _Col, _Row: Integer; _Value: TBatpro_Element);
begin
     Objects[_Col, _Row]:= _Value;
end;

{début de l'unité uDrawInfo déplacée}
function MulDiv( Nombre, Numerateur, Denominateur: Integer): Integer;
begin
     Result:= (Nombre*Numerateur) div Denominateur;
end;

procedure OffsetRect( var _R: TRect; _dx, _dy: Integer);
begin
     with _R
     do
       begin
       Left  := Left  +_dx;
       Right := Right +_dx;
       Top   := Top   +_dy;
       Bottom:= Bottom+_dy;
       end;
end;

procedure InflateRect( var _R: TRect; _dx, _dy: Integer);
begin
     with _R
     do
       begin
       Left  := Left  -_dx;
       Right := Right +_dx;
       Top   := Top   -_dy;
       Bottom:= Bottom+_dy;
       end;
end;

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

    {$IFNDEF FPC}
    FCouleurLigne  := Canvas.Pen  .Color;
    FCouleur_Brosse:= Canvas.Brush.Color;
    FStyleLigne    := Canvas.Pen  .Style;
    {$ENDIF}
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

function TDrawInfo._ellipse(_R: TRect; _Color: TColor; _Pen_Color: TColor;
 _Pen_Width: Integer): TDOMNode;
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

function TDrawInfo.text_rotate(_X, _Y: Integer; _Text, _Font_Family: String;
 _Font_Size: Integer; _Rotate: Integer): TDOMNode;
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
     (*
     Result
     :=
       image_from_id( _x, _y,
                      fBitmaps.svgDOCSINGL_width ,
                      fBitmaps.svgDOCSINGL_height,
                      fBitmaps.svgDOCSINGL_id    );
     *)
end;

function TDrawInfo.image_LOSANGE(_x, _y: Integer): TDOMNode;
begin
     (*
     Result
     :=
       image_from_id( _x, _y,
                      fBitmaps.svgLOSANGE_width ,
                      fBitmaps.svgLOSANGE_height,
                      fBitmaps.svgLOSANGE_id    );
     *)
end;

function TDrawInfo.image_LOGIN(_x, _y: Integer): TDOMNode;
begin
     (*
     Result
     :=
       image_from_id( _x, _y,
                      fBitmaps.svgLOGIN_width ,
                      fBitmaps.svgLOGIN_height,
                      fBitmaps.svgLOGIN_id    );
     *)
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
     (*
     Result
     :=
       image_from_id_centre( fBitmaps.svgDOCSINGL_width ,
                                 fBitmaps.svgDOCSINGL_height,
                                 fBitmaps.svgDOCSINGL_id    );
     *)
end;

function TDrawInfo.svg_image_LOSANGE__centre: TDOMNode;
begin
     (*
     Result
     :=
       image_from_id_centre( fBitmaps.svgLOSANGE_width ,
                                 fBitmaps.svgLOSANGE_height,
                                 fBitmaps.svgLOSANGE_id    );
     *)
end;

function TDrawInfo.svg_image_LOGIN__centre: TDOMNode;
begin
     (*
     Result
     :=
       image_from_id_centre( fBitmaps.svgLOGIN_width ,
                                 fBitmaps.svgLOGIN_height,
                                 fBitmaps.svgLOGIN_id    );
     *)
end;

function TDrawInfo.svg_image_MEN_AT_WORK__centre: TDOMNode;
begin
     {
     Result
     :=
       image_from_id_centre( fBitmaps.svgMEN_AT_WORK_width ,
                                 fBitmaps.svgMEN_AT_WORK_height,
                                 fBitmaps.svgMEN_AT_WORK_id    );
                                 }
end;

function TDrawInfo.svg_image_DOSSIER_KDE_PAR_POSTE__centre: TDOMNode;
begin{
     Result
     :=
       image_from_id_centre( fBitmaps.svgDOSSIER_KDE_PAR_POSTE_width ,
                                 fBitmaps.svgDOSSIER_KDE_PAR_POSTE_height,
                                 fBitmaps.svgDOSSIER_KDE_PAR_POSTE_id    );}
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
{     Result
     :=
       image_from_id_bas_droite( fBitmaps.svgDOCSINGL_width ,
                                 fBitmaps.svgDOCSINGL_height,
                                 fBitmaps.svgDOCSINGL_id    );}
end;

function TDrawInfo.image_LOSANGE__bas_droite: TDOMNode;
begin                                                          {
     Result
     :=
       image_from_id_bas_droite( fBitmaps.svgLOSANGE_width ,
                                 fBitmaps.svgLOSANGE_height,
                                 fBitmaps.svgLOSANGE_id    );   }
end;

function TDrawInfo.svg_image_LOGIN__bas_droite: TDOMNode;
begin                                                            {
     Result
     :=
       image_from_id_bas_droite( fBitmaps.svgLOGIN_width ,
                                 fBitmaps.svgLOGIN_height,
                                 fBitmaps.svgLOGIN_id    );       }
end;

procedure TDrawInfo.svgDessinne_Coche( _CouleurFond, _CouleurCoche: TColor;
                                      _Coche: Boolean);
begin
     svg.Dessinne_Coche( eCell, _CouleurFond, _CouleurCoche, Rect, _Coche);
end;

procedure TDrawInfo.SetCouleurLigne(const Value: TColor);
begin
     {$IFNDEF FPC}
     FCouleurLigne:= Value;
     if not SVG_Drawing
     then
         Canvas.Pen.Color:= FCouleurLigne;
     {$ENDIF}
end;


procedure TDrawInfo.SetCouleur_Brosse(const Value: TColor);
begin
     {$IFNDEF FPC}
     FCouleur_Brosse:= Value;
     if not SVG_Drawing
     then
         Canvas.Brush.Color:= FCouleur_Brosse;
     {$ENDIF}
end;

procedure TDrawInfo.SetLargeurLigne(const Value: Integer);
begin
     {$IFNDEF FPC}
     FLargeurLigne := Value;
     if not SVG_Drawing
     then
         Canvas.Pen.Width:= FLargeurLigne;
     {$ENDIF}
end;

procedure TDrawInfo.SetStyleLigne(const Value: TPenStyle);
begin
     {$IFNDEF FPC}
     FStyleLigne := Value;
     if not SVG_Drawing
     then
         Canvas.Pen.Style:= FStyleLigne;
     {$ENDIF}
end;

procedure TDrawInfo.MoveTo(X, Y: Integer);
begin
     {$IFNDEF FPC}
     if SVG_Drawing
     then
         begin
         XTortue:= X;
         YTortue:= Y;
         end
     else
         Canvas.MoveTo( X, Y);
     {$ENDIF}
end;

procedure TDrawInfo.LineTo(X, Y: Integer);
begin
     {$IFNDEF FPC}
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
     {$ENDIF}
end;

procedure TDrawInfo.Contour_Rectangle( _R: TRect; _Couleur: TColor);
begin
     {$IFNDEF FPC}
     if SVG_Drawing
     then
         rect_vide( _R, _Couleur, 1)
     else
         begin
         Canvas.Brush.Color:= _Couleur;
         Canvas.Brush.Style:= bsSolid;
         Canvas.FrameRect( _R);
         end;
     {$ENDIF}
end;

procedure TDrawInfo.Remplit_Rectangle( _R: TRect; _Couleur: TColor);
     procedure GDI;
     var
        OldColor: TColor;
     begin
          {$IFDEF WINDOWS_GRAPHIC}
          OldColor:= Canvas.Brush.Color;
          Canvas.Brush.Color:= _Couleur;
          Canvas.FillRect( _R);
          Canvas.Brush.Color:= OldColor;
          {$ENDIF}
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
     {$IFNDEF FPC}
     if SVG_Drawing
     then
         svg_polygon( Points, Couleur_Brosse, CouleurLigne, LargeurLigne)
     else
         Canvas.Polygon( Points);
     {$ENDIF}
end;

procedure TDrawInfo.PolyBezier(const Points: array of TPoint);
begin
     {$IFNDEF FPC}
     if SVG_Drawing
     then
         svg_PolyBezier( Points, CouleurLigne, LargeurLigne)
     else
         Canvas.PolyBezier( Points);
     {$ENDIF}
end;

procedure TDrawInfo.Rectangle(X1, Y1, X2, Y2: Integer);
begin
     {$IFNDEF FPC}
     if SVG_Drawing
     then
         _rect( Classes.Rect( X1, Y1, X2, Y2),
                Couleur_Brosse, CouleurLigne, LargeurLigne)
     else
         Canvas.Rectangle( X1, Y1, X2, Y2);
     {$ENDIF}
end;

procedure TDrawInfo.Ellipse( X1, Y1, X2, Y2: Integer);
begin
     {$IFNDEF FPC}
     if SVG_Drawing
     then
         _ellipse( Classes.Rect( X1, Y1, X2, Y2),
                   Couleur_Brosse, CouleurLigne, LargeurLigne)
     else
         Canvas.Ellipse( X1, Y1, X2, Y2);
     {$ENDIF}
end;

procedure TDrawInfo.Rectangle( _R: TRect);
begin
     Rectangle( _R.Left, _R.Top, _R.Right, _R.Bottom);
end;

procedure TDrawInfo.image_DOCSINGL_bas_droite( _Couleur_Fond: TColor);
begin
     {$IF DEFINED(MSWINDOWS) AND NOT DEFINED(FPC)}
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
     {$ENDIF}
end;

procedure TDrawInfo.image_DOCSINGL_centre( _Couleur_Fond: TColor);
   procedure GDI;
   var
//      ImageList: TImageList;
      dx, dy: Integer;
      R: TRect;
   begin           {
        ImageList:= fBitmaps.DOCSINGL;
        R:= Rect;
        dx:= (R.Right -ImageList.Width -R.Left) div 2;
        dy:= (R.Bottom-ImageList.Height-R.Top ) div 2;
        InflateRect( R, -dx, -dy);

        ImageList.BkColor:= _Couleur_Fond;
        ImageList.Draw( Canvas, R.Left, R.Top, 0);}
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
//      ImageList: TImageList;
      dx, dy: Integer;
      R: TRect;
   begin
  {      ImageList:= fBitmaps.LOSANGE;
        R:= Rect;
        dx:= (R.Right -ImageList.Width -R.Left) div 2;
        dy:= (R.Bottom-ImageList.Height-R.Top ) div 2;
        InflateRect( R, -dx, -dy);

        ImageList.BkColor:= _Couleur_Fond;
        ImageList.Draw( Canvas, R.Left, R.Top, 0);}
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
//      ImageList: TImageList;
      dx, dy: Integer;
      R: TRect;
   begin
{        ImageList:= fBitmaps.LOGIN;
        R:= Rect;
        dx:= (R.Right -ImageList.Width -R.Left) div 2;
        dy:= (R.Bottom-ImageList.Height-R.Top ) div 2;
        InflateRect( R, -dx, -dy);

        ImageList.BkColor:= _Couleur_Fond;
        ImageList.Draw( Canvas, R.Left, R.Top, 0);}
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
{         fBitmaps.LOGIN.BkColor:= _Couleur_Fond;
         fBitmaps.LOGIN.Draw( Canvas,
                                 Rect.Right -fBitmaps.LOGIN.Width -1,
                                 Rect.Bottom-fBitmaps.LOGIN.Height-1,
                                 0);
 }        end;
end;

procedure TDrawInfo.image_MEN_AT_WORK__centre(_Couleur_Fond: TColor);
   procedure GDI;
   var
  //    ImageList: TImageList;
      dx, dy: Integer;
      R: TRect;
   begin
    {    ImageList:= fBitmaps.MEN_AT_WORK;
        R:= Rect;
        dx:= (R.Right -ImageList.Width -R.Left) div 2;
        dy:= (R.Bottom-ImageList.Height-R.Top ) div 2;
        InflateRect( R, -dx, -dy);

        ImageList.BkColor:= _Couleur_Fond;
        ImageList.Draw( Canvas, R.Left, R.Top, 0);
}   end;
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
 //     ImageList: TImageList;
      dx, dy: Integer;
      R: TRect;
   begin
   {     ImageList:= fBitmaps.DOSSIER_KDE_PAR_POSTE;
        R:= Rect;
        dx:= (R.Right -ImageList.Width -R.Left) div 2;
        dy:= (R.Bottom-ImageList.Height-R.Top ) div 2;
        InflateRect( R, -dx, -dy);

        ImageList.BkColor:= _Couleur_Fond;
        ImageList.Draw( Canvas, R.Left, R.Top, 0);
}   end;
begin
     if SVG_Drawing
     then
         svg_image_DOSSIER_KDE_PAR_POSTE__centre
     else
         GDI;
end;

procedure TDrawInfo.Dessine_Fond;
var
   C: TColor;
begin
     if Gris
     then
         C:= Couleur_Jour_Non_Ouvrable
     else
         C:= Fond;
     Remplit_Rectangle( Rect, C);
end;

procedure TDrawInfo.Traite_Grille_impression( _Afficher_Grille: Boolean);
begin
     if not Impression then exit;

     {$IFDEF WINDOWS_GRAPHIC}
     if _Afficher_Grille
     then
         begin
         Canvas.Pen.Style:= psSolid;
         Canvas.Pen.Color:= clBlack;
         end
     else
         Canvas.Pen.Style:= psClear;
     {$ENDIF}

end;

{$IFNDEF WINDOWS_GRAPHIC}
{ TFont }

constructor TFont.Create;
begin
     inherited;
     Name:='Arial';
     Size:= 7;
end;

procedure TFont.Assign(_Source: TPersistent);
var
   F: TFPCustomFont;
begin
     //inherited Assign(_Source);
     if Affecte_( F, TFPCustomFont, _Source) then exit;

     Name:= F.Name;
     size:= F.Size;

end;

function LargeurTexte( F: TFont; S: String): Integer;
begin
     Result:= Length( S)*F.Size;
end;

function LineHeight( F: TFont): Integer;
begin
     Result:= F.Size;
end;

function HauteurTexte( F: TFont; S: String; Largeur: Integer): Integer;
var
   LH: Integer;
   L: Integer;
   NbLignes: Integer;
begin
     LH:= LineHeight( F);
     Result:= LH;
     if Largeur = 0 then exit;

     L:= LargeurTexte( F, S);
     NbLignes:= ceil( L/Largeur);
     Result:= NbLignes*LH;
end;
{$ENDIF}

{fin de l'unité uDrawInfo déplacée}
{début de l'unité uTraits déplacée}
function Ligne_from_sl( sl: TStringList; Index: Integer): TLigne;
begin
     _Classe_from_sl( Result, TLigne, sl, Index);
end;

function Ligne_from_sl_sCle( sl: TStringList; sCle: String): TLigne;
begin
     _Classe_from_sl_sCle( Result, TLigne, sl, sCle);
end;

{ TProgression_Trait }

constructor TProgression_Trait.Create;
begin

end;

destructor TProgression_Trait.Destroy;
begin

  inherited;
end;

{ TLigne }

constructor TLigne.Create;
begin
     bl_1:= nil;
     bl_2:= nil;
     x1:= 0;
     y1:= 0;
     x2:= 0;
     y2:= 0;
     FHorizontal:= nil;
     FAngle     := nil;
     FVertical  := nil;
end;

destructor TLigne.Destroy;
begin

     inherited;
end;

function TLigne.sCle: String;
begin
     Result
     :=
        IntToHex( Integer(Pointer( bl_2)), 8)
       +IntToHex( Integer(Pointer( bl_1)), 8);
end;

procedure TLigne.Assure_Progression(var pt: TProgression_Trait);
begin
     if pt = nil
     then
         pt:= TProgression_Trait.Create;
end;

function TLigne.Horizontal: TProgression_Trait;
begin
     Assure_Progression( FHorizontal);
     Result:= FHorizontal;
     if x1 <= x2
     then
         begin
         Result.Step:= +1;
         Result.Debut  := a_Gauche;
         Result.Arrivee:= a_Droite;
         end
     else
         begin
         Result.Step:= -1;
         Result.Debut  := a_Droite;
         Result.Arrivee:= a_Gauche;
         end
end;

function TLigne.Angle: TProgression_Trait;
begin
     Assure_Progression( FAngle);
     Result:= FAngle;
     Result.Step:= 0;
     if x1 <= x2
     then
         Result.Debut:= a_Gauche
     else
         Result.Debut:= a_Droite;
     if y1 <= y2
     then
         Result.Arrivee:= a_Bas
     else
         Result.Arrivee:= a_Haut;
end;

function TLigne.Vertical: TProgression_Trait;
begin
     Assure_Progression( FVertical);
     Result:= FVertical;
     if y1 <= y2
     then
         begin
         Result.Step:= +1;
         Result.Debut  := a_Haut;
         Result.Arrivee:= a_Bas ;
         end
     else
         begin
         Result.Step:= -1;
         Result.Debut  := a_Bas ;
         Result.Arrivee:= a_Haut;
         end
end;

{ TTrait }

constructor TTrait.Create;
begin
     Ligne       := nil;
     IsDebutLigne:= False;
     IsFinLigne  := False;
end;

destructor TTrait.Destroy;
begin

     inherited;
end;

procedure TTrait.{svg}Dessinne( DrawInfo: TDrawInfo);
var
   XGauche, XDroite, XMilieu, XLigne: Integer;
   YHaut  , YBas   , YMilieu: Integer;
   W: Integer;
   W4: Integer;//Width  div 4
   H4: Integer;//Height div 4
   W8: Integer;//Width  div 8
   x1, y1, x2, y2: Integer;
   XBezier: Integer;
   Points: array[1..4] of TPoint;
   procedure D( x, y: Integer);
   begin
        x1:= x;
        y1:= y;
   end;
   procedure Ar( x, y: Integer);
   begin
        x2:= x;
        y2:= y;
   end;
   procedure P( Indice, _x, _y: Integer);
   begin
        with Points[ Indice]
        do
          begin
          X:= _x;
          Y:= _y;
          end;
   end;
begin
     XGauche:= DrawInfo.Rect.Left  ;
     XDroite:= DrawInfo.Rect.Right ;
     XMilieu:= (XGauche + XDroite) div 2;


     YHaut  := DrawInfo.Rect.Top   ;
     YBas   := DrawInfo.Rect.Bottom;
     YMilieu:= (YHaut + YBas) div 2;

     W := XDroite - XGauche;
     W4:= W div 4;
     W8:= W div 8;
     H4:= (YBas    - YHaut  ) div 4;

     XLigne:= XGauche+W8+Trunc( Self.a * (W-W4));//marge de W8
                                                 //a: position relative de la ligne verticale
     case Depart
     of
       a_Milieu: D(XMilieu,YMilieu);
       a_Gauche: D(XGauche,YMilieu);
       a_Haut  : D(XLigne ,YHaut  );
       a_Droite: D(XDroite,YMilieu);
       a_Bas   : D(XLigne ,YBas   );
       end;

     case Arrivee
     of
       a_Milieu: Ar( XLigne,YMilieu);
       a_Gauche: Ar(XGauche,YMilieu);
       a_Haut  : Ar(XLigne ,YHaut  );
       a_Droite: Ar(XDroite,YMilieu);
       a_Bas   : Ar(XLigne ,YBas   );
       end;

     P( 1, x1, y1);
     P( 4, x2, y2);

     //P( 2, (XMilieu+x1)div 2, (YMilieu+y1)div 2);
     //P( 3, (XMilieu+x2)div 2, (YMilieu+y2)div 2);
     if      IsDebutLigne
        and (Arrivee = a_Droite)
     then
         XBezier:= XMilieu
     else
         XBezier:= XLigne;
     P( 2, XBezier, YMilieu);
     P( 3, XBezier, YMilieu);

     DrawInfo.PolyBezier( Points);

     if IsFinLigne
     then
         begin
         //DrawInfo.MoveTo( XMilieu   , YHaut  );
         //DrawInfo.LineTo( XMilieu   , YBas-H4);
         //DrawInfo.MoveTo( XGauche+W4, YBas-H4);
         //DrawInfo.LineTo( XDroite-W4, YBas-H4);
         //DrawInfo.MoveTo( XMilieu   , YHaut+H4);
         //DrawInfo.LineTo( XMilieu   , YBas    );
         if Depart = a_Haut
         then
             begin
             DrawInfo.MoveTo( XLigne-W8, YHaut+H4);
             DrawInfo.LineTo( XLigne   , YMilieu );
             DrawInfo.LineTo( XLigne+W8, YHaut+H4);
             end
         else
             begin
             DrawInfo.MoveTo( XLigne-W8, YBas-H4);
             DrawInfo.LineTo( XLigne   , YMilieu);
             DrawInfo.LineTo( XLigne+W8, YBas-H4);
             end;
         end;
     //DrawInfo.MoveTo( x1, y1);
     //DrawInfo.LineTo( x2, y2);
end;

{ TTraits }

constructor TTraits.Create;
begin
     sl:= TBatpro_StringList.CreateE( ClassName+'.sl', TTrait);
end;

destructor TTraits.Destroy;
begin
     Free_nil( sl);
     inherited;
end;

function TTraits.Ajoute( _Ligne: TLigne; _Depart, _Arrivee: TArete): TTrait;
begin
     Result:= TTrait.Create;
     Result.Ligne  := _Ligne  ;
     Result.Depart := _Depart ;
     Result.Arrivee:= _Arrivee;
     sl.AddObject( '', Result);
end;

procedure TTraits.Dessinne( DrawInfo: TDrawInfo);
var
   T: TTrait;
   OldPenColor: TColor;
begin
     if DrawInfo.Contexte = ct_PL_SAL then exit;

     OldPenColor:= DrawInfo.CouleurLigne;
     DrawInfo.CouleurLigne:= clBlue;

     sl.Iterateur_Start;
     try
        while not sl.Iterateur_EOF
        do
          begin
          sl.Iterateur_Suivant( T);
          if T = nil then continue;

          T.Dessinne( DrawInfo);
          end;
     finally
            sl.Iterateur_Stop;
            end;
     DrawInfo.CouleurLigne:= OldPenColor;
end;

procedure TTraits.Vide;
begin
     Vide_StringList( sl);
end;
{fin de l'unité uTraits déplacée}

//########################### TBatpro_Element ##################################

function Batpro_Element_from_sl( sl: TStringList; Index: Integer): TBatpro_Element;
begin
     _Classe_from_sl( Result, TBatpro_Element, sl, Index);
end;

function Batpro_Element_from_sl_sCle( sl: TStringList; sCle: String): TBatpro_Element;
begin
     _Classe_from_sl_sCle( Result, TBatpro_Element, sl, sCle);
end;

{$IFNDEF WINDOWS_GRAPHIC}
{ TMenuItem }

constructor TMenuItem.create(_object: TObject);
begin

end;
{$ENDIF}

{$IFNDEF WINDOWS_GRAPHIC}
{ TPopupMenu }

constructor TPopupMenu.create(_object: TObject);
begin

end;
{$ENDIF}

{ TIterateur_Batpro_Element }

function TIterateur_Batpro_Element.not_Suivant( out _Resultat: TBatpro_Element): Boolean;
begin
     Result:= not_Suivant_interne( _Resultat);
end;

procedure TIterateur_Batpro_Element.Suivant( out _Resultat: TBatpro_Element);
begin
     Suivant_interne( _Resultat);
end;

{ TslBatpro_Element }

constructor TslBatpro_Element.Create( _Nom: String= '');
begin
     inherited CreateE( _Nom, TBatpro_Element);
end;

destructor TslBatpro_Element.Destroy;
begin
     inherited;
end;

class function TslBatpro_Element.Classe_Iterateur: TIterateur_Class;
begin
     Result:= TIterateur_Batpro_Element;
end;

function TslBatpro_Element.Iterateur: TIterateur_Batpro_Element;
begin
     Result:= TIterateur_Batpro_Element( Iterateur_interne);
end;

function TslBatpro_Element.Iterateur_Decroissant: TIterateur_Batpro_Element;
begin
     Result:= TIterateur_Batpro_Element( Iterateur_interne_Decroissant);
end;

procedure slAjoute( L: TBatpro_StringList; be: TBatpro_Element);
begin
     if Assigned( L) and Assigned( be)
     then
         L.AddObject( be.sCle, be);
end;

procedure slExtrait_SousListe( Source: TBatpro_StringList; sCle: String; Cible: TBatpro_StringList);
var
   I: Integer;
   Continuer: Boolean;
   s: String;
begin
     Cible.Clear;

     if not Source.Sorted then Source.Sort;
     I:= Source.IndexOf( sCle);
     if I = -1 then exit;

     Continuer:= True;
     s:= Source.Strings[I];

     while Continuer
     do
       begin
       Cible.AddObject( s, Source.Objects[I]);
       Inc(I);
       Continuer:= I < Source.Count;
       if Continuer
       then
           begin
           s:= Source.Strings[I];
           Continuer:= s = sCle;
           end;
       end;

end;

procedure sl_ChangeSelected( _sl: TBatpro_StringList; _Selected: Boolean);
var
   I: Integer;
   be: TBatpro_Element;
begin
     if _sl = nil then exit;

     for I:= 0 to _sl.Count-1
     do
       begin
       be:= Batpro_Element_from_sl( _sl, I);
       if be= nil then continue;

       be.Selected:= _Selected;
       end;
end;

procedure sl_ToutSelectionner( _sl: TBatpro_StringList);
begin
     sl_ChangeSelected( _sl, True);
end;

procedure sl_ToutDeselectionner( _sl: TBatpro_StringList);
begin
     sl_ChangeSelected( _sl, False);
end;

function Description_Objet( Titre: String; O: TObject): String;
var
   be: TBatpro_Element;
begin
     Result:= Titre+sys_N;
     if O = nil
     then
         begin
         Result:= Result+'   pointeur à nil';
         exit;
         end;

     Result:= Result+'   classe : '+O.ClassName+sys_N;

     if not (O is TBatpro_Element) then exit;

     be:= TBatpro_Element(O);
     Result:= Result+ '   Clé de liste: >'+be.sCle+'<'+ sys_N;
     Result:= Result+ '   Texte de cellule:'+sys_N;
     Result:= Result+ be.Cell[0]+sys_N;
     Result:= Result+ '   Texte de bulle d''aide:'+sys_N;
     Result:= Result+ be.Contenu(0,-1,-1);

end;
function Place( sl: TBatpro_StringList; Index: Integer; S: String; O: TObject;
                Contexte_si_erreur: String;
                Modal_si_erreur: Boolean = True): TPlace_function_result;
var
   Messag: String;
begin
     Result:= pfr_Success;
     if Index < 0
     then
         begin
         Messag:= 'Erreur à signaler au développeur: '+sys_N+
                  'Contexte: '+Contexte_si_erreur+sys_N+
                  'uBatpro_Element.Place: l''index est négatif. '+
                  IntToStr( Index)+sys_N+
                  Description_Objet('Description de l''objet concerné:', O);
         if Modal_si_erreur
         then
             fAccueil_Erreur( Messag)
         else
             fAccueil_Log( Messag);
         sl.AddObject( S, O);
         Result:= pfr_Index_negatif;
         end
     else
         begin
         if Index >= sl.Count
         then
             begin
             while Index > sl.Count
             do
               sl.Add( sys_Vide);
             sl.AddObject( S, O);
             end
         else
             begin
             if not (    (sl.Strings[Index] = sys_Vide)
                     and (sl.Objects[Index] = nil     )
                     )
             then
                 begin
                 Messag:= 'Erreur à signaler au développeur: '+sys_N+
                          'Contexte: '+Contexte_si_erreur+sys_N+
                          'uBatpro_Element.Place: la position '+
                          IntToStr(Index)+
                          'n''est pas vide dans la liste'+sys_N+
                          Description_Objet( 'Objet déjà présent dans la liste:',
                                                     sl.Objects[Index])+sys_N+
                          Description_Objet('Nouvel objet à placer:', O);
                 if Modal_si_erreur
                 then
                     fAccueil_Erreur( Messag)
                 else
                     fAccueil_Log( Messag);
                 Result:= pfr_Deja_pris;
                 end
             else
                 begin
                 sl.Strings[Index]:= S;
                 sl.Objects[Index]:= O;
                 end;
             end;
         end;
end;

procedure Copie( Source: TBatpro_StringList; IndexSource: Integer; Cible: TBatpro_StringList);
var
   S: String;
   O: TObject;
begin
     if IndexSource = -1 then exit;
     S:= Source.Strings[ IndexSource];
     O:= Source.Objects[ IndexSource];
     Cible.AddObject( S, O);
end;

procedure AjouteListe( Source: TBatpro_StringList; Cible: array of TBatpro_StringList);
var
   iSource, iCible: Integer;
   NbCibles: Integer;
   NbSource, NbParCible, NbCibleRestant: Integer;
   Cible_iCible: TBatpro_StringList;
begin
     if Source = nil then exit;

     NbSource:= Source.Count;
     NbCibles:= Length( Cible);
     NbParCible:= NbSource div NbCibles;

     iCible:= Low( Cible);
     NbCibleRestant:= NbParCible;
     for iSource:= 0 to NbSource -1
     do
       begin
       Cible_iCible:= Cible[iCible];
       if Assigned( Cible_iCible)
       then
           Copie( Source, iSource, Cible_iCible);
       Dec( NbCibleRestant);
       if NbCibleRestant = 0
       then
           begin
           if iCible < High( Cible)
           then
               Inc( iCible);
           NbCibleRestant:= NbParCible;
           end;
       end;
end;

procedure AssureLongueur( sl: TBatpro_StringList; Longueur: Integer; sCle: String);
begin
     while sl.Count < Longueur
     do
       sl.AddObject( sCle, nil);
end;

procedure Transfere( Source: TBatpro_StringList; IndexSource: Integer; Cible: TBatpro_StringList);
var
   be: TBatpro_Element;
begin
     if IndexSource = -1 then exit;
     be:= Batpro_Element_from_sl( Source, IndexSource);

     Copie( Source, IndexSource, Cible);
     Source.Delete( IndexSource);

     be.sl:= Cible;
end;

procedure Affiche_Classes( Titre: String; sl: TBatpro_StringList);
var
   slClasses: TBatpro_StringList;
   I: Integer;
   O: TObject;
   Classe: String;
begin
     slClasses:= TBatpro_StringList.Create;
     try
        slClasses.Sorted:= True;
        for I:= 0 to sl.Count - 1
        do
          begin
          O:= sl.Objects[ I];

          if Assigned( O)
          then
              begin
              Classe:= O.ClassName;
              if -1 = slClasses.IndexOf(Classe)
              then
                  slClasses.Add( Classe);
              end;
          end;
        fAccueil_Log( Titre+sys_N+slClasses.Text);
        fAccueil_Execute;
     finally
            Free_nil( slClasses);
            end;
end;

{ TBatpro_Element }

constructor TBatpro_Element.Create( _sl: TBatpro_StringList);
begin
     try
        Creating:= True;

        inherited Create;
        sl:= _sl;
        Fond:= clWhite;
        Serie:= nil;
        Cluster:= nil;
        Tag:= nil;
        Selected:= False;
        Bordure:= False;
        asBECP:= TBatpro_ElementClassParams.Create( Self);
        Init_ClassParams;
        FAggregeurs:= nil;
        FConnecteurs:= nil;
        FTraits    := nil;
        Instance_Font:= TFont.Create;
        Retrait_Texte:= 0;
        Aggrandir_a_l_impression:= False;
        FAggregations:= nil;
        Contenu_statique:= '';        
        {$IFNDEF FPC}
        FPopupMenu:= nil;
        miContexteFont:= nil;
        {$ENDIF}
     finally
            Creating:= False;
            end;
end;

destructor TBatpro_Element.Destroy;
begin
     {$IFNDEF FPC}
     Free_nil( FPopupMenu);
     {$ENDIF}
     Free_nil( FAggregations);
     Free_nil( FConnecteurs);
     Free_nil( FAggregeurs);
     FreeAndNil( Serie);
     FreeAndNil( Instance_Font);
     inherited;
end;

procedure TBatpro_Element.Cree_Serie;
begin
     if Serie = nil
     then
         Serie:= TBatpro_Serie.Create( Self)
     else
         Serie.Initialise;
end;

procedure TBatpro_Element.Cree_Cluster;
begin
     if Cluster = nil
     then
         Cluster:= TBatpro_Cluster.Create( Self)
     else
         Cluster.Initialise;
     Bordure:= True;
end;

function TBatpro_Element.Couleur_Fond( DrawInfo: TDrawInfo): TColor;
begin
          if Selected      then Result:= clAqua //clHighlight
     else if DrawInfo.Gris then Result:= DrawInfo.Couleur_Jour_Non_Ouvrable
     else                       Result:= Fond;
end;

procedure TBatpro_Element.{svg}Dessinne_Fond( DrawInfo: TDrawInfo);
begin
     DrawInfo.Remplit_Rectangle( DrawInfo.Rect_Original, Couleur_Fond( DrawInfo));
end;

function TBatpro_Element.GetBordure: Boolean;
begin
     Result:= FBordure;
end;

procedure TBatpro_Element.{svg}Dessinne_Bordure( DrawInfo: TDrawInfo);
begin
     if not uBatpro_Element_Afficher_Grille then exit;
     
     DrawInfo.Contour_Rectangle( DrawInfo.Rect, clBlack);
end;

function TBatpro_Element.Rectangle_Aligne( R: TRect;
                                           Alignement: TbeAlignement;
                                           Largeur, Hauteur: Integer): TRect;
var
   DW2, DH2: Integer;
begin
     Result.TopLeft    := Point(R.Left        , R.Top        );
     Result.BottomRight:= Point(R.Left+Largeur, R.Top+Hauteur);

     DW2:= ((R.Right -R.Left) - Largeur) div 2;
     DH2:= ((R.Bottom-R.Top ) - Hauteur) div 2;
     if DH2 < 0
     then
         begin
         //fAccueil_Log( 'Hauteur = '+IntToStr(Hauteur)+' pour >'+Text+'<');
         Alignement.V:= bea_Haut;
         end;

     case Alignement.H
     of
       bea_Gauche       : OffsetRect( Result,     0,     0);
       bea_Centre_Horiz : OffsetRect( Result,   DW2,     0);
       bea_Droite       : OffsetRect( Result, 2*DW2,     0);
       end;
     case Alignement.V
     of
       bea_Haut         : OffsetRect( Result,     0,     0);
       bea_Centre_Vertic: OffsetRect( Result,     0,   DH2);
       bea_Bas          : OffsetRect( Result,     0, 2*DH2);
       end;
end;

function TBatpro_Element.{svg}Draw_Text( DrawInfo: TDrawInfo; Alignement: TbeAlignement;
                                    Text: String; Font: TFont): Integer;
var
   R, CALCRECT: TRect;
   TextW, TextH: Integer;
   OldFont: TFont;
   uFormat: Cardinal;
   OrientationTexte_: Integer;
begin
     OrientationTexte_:= OrientationTexte( DrawInfo);

     OldFont:= TFont.Create;
     //OldFont.Assign( DrawInfo.Canvas.Font);
     //DrawInfo.Canvas.Font.Assign( Font);
       R:= DrawInfo.Rect;
       //InflateRect( R, -Batpro_Element_Marge, -Batpro_Element_Marge);
       TextW:= Cell_Width_Interne ( DrawInfo, Font, Text);
       TextW:= Width_Externe_from_Interne( DrawInfo, TextW);
       TextH:= Cell_Height_Interne( DrawInfo, Font, Text, TextW);
       TextH:= Height_Externe_from_Interne( DrawInfo, TextH);
       Result:= TextH;

       CALCRECT:= Rectangle_Aligne( R, Alignement, TextW, TextH);
       //CALCRECT:= Rectangle_Aligne( R, Alignement, R.Right-R.Left, TextH);
       CALCRECT:= Rect_Interne_from_Externe( DrawInfo, CALCRECT);

       if DrawInfo.SVG_Drawing
       then
           DrawInfo.text_rotate( CALCRECT.Left,
                                 CALCRECT.Top ,
                                 Text,
                                 Font.Name, Font.Size,
                                 OrientationTexte_ div 10)
       else
           begin
           {$IFDEF WINDOWS_GRAPHIC}
             {$IFDEF MSWINDOWS}
             uFormat:= DT_WORDBREAK or Format_beAlignementH[ Alignement.H];
             SetBkMode( DrawInfo.Canvas.Handle, TRANSPARENT);
             try
                Oriente_Fonte( OrientationTexte_,DrawInfo.Canvas.Font);
                //SetTextAlign( DrawInfo.Canvas.Handle, TA_TOP or TA_LEFT);
                if OrientationTexte_ = 900
                then
                    begin
                    SetTextAlign( DrawInfo.Canvas.Handle, TA_TOP or TA_LEFT);
                    TextOut( DrawInfo.Canvas.Handle,
                             CALCRECT.Left,
                             CALCRECT.Bottom,
                             PChar( Text), Length(Text));
                    end
                else
                    DrawText( DrawInfo.Canvas.Handle,
                              PChar(Text), Length(Text),
                              CALCRECT, uFormat);
             finally
                    SetBkMode( DrawInfo.Canvas.Handle, OPAQUE);
                    end;
             {$ELSE}
             {$WARNING TBatpro_Element.Draw_Text cas linux non codé }
             //Log.Prin
             {$ENDIF}
           {$ENDIF}
           end;

     {$IFDEF WINDOWS_GRAPHIC}
     DrawInfo.Canvas.Font.Assign( OldFont);
     {$ENDIF}
     FreeAndNil( OldFont);
end;

procedure TBatpro_Element.Draw( DrawInfo: TDrawInfo);
var
   Alignement: TbeAlignement;
   Serie_not_CellDebut: Boolean;
   procedure Traite_Serie_not_CellDebut; //spécial pour demi-ligne sur planning production
   var
      R: TRect;
   begin
        if not (Serie.Style in [ss_DemiLigne,ss_DemiLigne_Pointille, ss_DemiLigne_Points]) then exit;

        R:= DrawInfo.Rect;
        InflateRect( R, 0, -3);
        case Serie.Style
        of
          ss_DemiLigne:
            Serie.DrawDemiLigne( DrawInfo, R, False);
          ss_DemiLigne_Pointille:
            Serie.DrawDemiLigne_Pointille( DrawInfo, R, False);
          ss_DemiLigne_Points:
            Serie.DrawDemiLigne_Points( DrawInfo, R, False);
          else
            Serie.DrawDemiLigne( DrawInfo, R, False);
          end;
   end;
begin
     {$IF DEFINED(MSWINDOWS) AND NOT DEFINED(FPC)}
     if Assigned( Serie)
     then
         if Serie.Draw( DrawInfo)
         then
             exit
         else
             Serie_not_CellDebut:= True
     else
         Serie_not_CellDebut:= False;

     if DrawInfo.Fixe
     then
         begin
         DrawInfo.Couleur_Brosse:= Fond;
         if DrawInfo.Couleur_Brosse = clBtnFace
         then
             DrawFrameControl( DrawInfo.Canvas.Handle, DrawInfo.Rect,DFC_BUTTON,DFCS_BUTTONPUSH)
         else
             DrawFrameButton_Color( DrawInfo.Canvas, DrawInfo.Couleur_Brosse, DrawInfo.Rect);
         if DrawInfo.Impression
         then
             Dessinne_Bordure( DrawInfo);
         InflateRect( DrawInfo.Rect, -CXEDGE, -CYEDGE);
         end;

     Dessinne_Fond( DrawInfo);

     if Serie_not_CellDebut
     then
         Traite_Serie_not_CellDebut;

     Alignement:= Get_Alignement( DrawInfo.Contexte);
     Draw_Text( DrawInfo, Alignement,
                Cell     [ DrawInfo.Contexte],
                ClassFont( DrawInfo));
     Dessinne_Gris( DrawInfo);
     if Bordure
     then
         Dessinne_Bordure( DrawInfo);
     if Assigned( Serie)
     then
         begin
         Serie.Dessinne_Pourcentage  ( DrawInfo);
         Serie.Dessinne_Pourcentage_2( DrawInfo);
         end;
     if Assigned( FTraits)
     then
         FTraits.Dessinne( DrawInfo);
     {$IFEND}
end;

procedure TBatpro_Element.svgDraw( DrawInfo: TDrawInfo);
var
   Alignement: TbeAlignement;
   Serie_not_CellDebut: Boolean;
   procedure Traite_Serie_not_CellDebut; //spécial pour demi-ligne sur planning production
   var
      R: TRect;
   begin
        if not (Serie.Style in [ss_DemiLigne,ss_DemiLigne_Pointille, ss_DemiLigne_Points]) then exit;

        R:= DrawInfo.Rect;
        InflateRect( R, 0, -3);
        case Serie.Style
        of
          ss_DemiLigne:
            Serie.{svg}DrawDemiLigne( DrawInfo, R, False);
          ss_DemiLigne_Pointille:
            Serie.{svg}DrawDemiLigne_Pointille( DrawInfo, R, False);
          ss_DemiLigne_Points:
            Serie.{svg}DrawDemiLigne_Points( DrawInfo, R, False);
          else
            Serie.{svg}DrawDemiLigne( DrawInfo, R, False);
          end;
   end;
begin
     if Assigned( Serie)
     then
         if Serie.svgDraw( DrawInfo)
         then
             exit
         else
             Serie_not_CellDebut:= True
     else
         Serie_not_CellDebut:= False;

     if DrawInfo.Fixe
     then
         begin
         DrawInfo.Couleur_Brosse:= Fond;
         {
         if DrawInfo.Couleur_Brosse = clBtnFace
         then
             DrawFrameControl( DrawInfo.Canvas.Handle, DrawInfo.Rect,DFC_BUTTON,DFCS_BUTTONPUSH)
         else
             DrawFrameButton_Color( DrawInfo.Canvas, DrawInfo.Couleur_Brosse, DrawInfo.Rect);
         }
         if DrawInfo.Impression
         then
             {svg}Dessinne_Bordure( DrawInfo);
         //InflateRect( DrawInfo.Rect, -CXEDGE, -CYEDGE);
         end;

     {svg}Dessinne_Fond( DrawInfo);

     if Serie_not_CellDebut
     then
         Traite_Serie_not_CellDebut;

     Alignement:= Get_Alignement( DrawInfo.Contexte);
     {svg}Draw_Text( DrawInfo, Alignement,
                   Cell     [ DrawInfo.Contexte],
                   ClassFont( DrawInfo));
     {svg}Dessinne_Gris( DrawInfo);
     if Bordure
     then
         {svg}Dessinne_Bordure( DrawInfo);
     if Assigned( Serie)
     then
         begin
         Serie.{svg}Dessinne_Pourcentage( DrawInfo);
         Serie.{svg}Dessinne_Pourcentage_2( DrawInfo);
         end;
     if Assigned( FTraits)
     then
         FTraits.{svg}Dessinne( DrawInfo);
end;

function TBatpro_Element.GetCell( Contexte: Integer): String;
begin
     Result:= sys_Vide;
end;

function TBatpro_Element.GetTableurCell(Contexte: Integer): String;
begin
     Result:= GetCell( Contexte);
end;

function TBatpro_Element.MulDiv_Color( Color: TColor; Mul_,Div_:Integer):TColor;
{$IFNDEF FPC}
var
   Q: TRGBQuad;
{$ENDIF}
   //OldRayon, Old_BG, NewRayon, New_BG: Extended;
   //R_BG: Extended;
   //B_G: Extended;
   //New_B,
   //New_G,
   //New_R: Extended;
   function MulDiv_Byte( B: Byte; Mul_, Div_: Integer): Byte;
   var
      D: Double;
   begin
        D:= (B*Mul_)/Div_;
        if D > 255 then D := 255;
        Result:= Trunc( D);
   end;
   //function Rayon( C: TRGBQuad): Extended;
   //var
   //   R, G, B: Extended;
   //begin
   //     B:= C.rgbBlue ;
   //     G:= C.rgbGreen;
   //     R:= C.rgbRed  ;
   //     Result:= sqrt( sqr(B)+
   //                    sqr(G)+
   //                    sqr(R));
   //end;
   //function BG( C: TRGBQuad): Extended;
   //var
   //   G, B: Extended;
   //begin
   //     B:= C.rgbBlue ;
   //     G:= C.rgbGreen;
   //     Result:= sqrt( sqr(B)+
   //                    sqr(G));
   //end;
   //procedure Inc_Byte( var B: Byte; Increment: Integer);
   //var
   //   Nouveau: Integer;
   //begin
   //     Nouveau:= B + Increment;
   //     if (Nouveau < 0) or (255 < Nouveau) then exit;
   //     B:= Nouveau;
   //end;
begin
	 {$IFNDEF FPC}
     Q:= TRGBQuad(Color);
	 {$ENDIF}

     //OldRayon:= Rayon( Q);
     //Old_BG  := BG( Q);

     //B_G := Q.rgbBlue / Q.rgbGreen;     ### zero divide
     //R_BG:= Q.rgbRed  / Old_BG;

     (*
     NewRayon:= (OldRayon * Mul_) / Div_;
     //sqr( NewRayon)= sqr( R) + sqr(BG)
     //sqr( NewRayon)= sqr( R_BG * BG) + sqr(BG)
     //sqr( NewRayon)= sqr( R_BG) * sqr( BG) + sqr(BG)
     //sqr( NewRayon)= (1+sqr( R_BG)) * sqr( BG)
     //BG= sqrt(sqr( NewRayon)/ (1+sqr( R_BG)))
     New_BG:= sqrt(  sqr(NewRayon) / (1+sqr(R_BG))  );
     New_R := R_BG * New_BG;
     New_G := sqrt(  sqr(New_BG  ) / (1+sqr(B_G ))  );
     New_B := B_G * New_G;

     if New_B > 255 then Q.rgbBlue := 255 else Q.rgbBlue := Trunc( New_B);
     if New_G > 255 then Q.rgbGreen:= 255 else Q.rgbGreen:= Trunc( New_G);
     if New_R > 255 then Q.rgbRed  := 255 else Q.rgbRed  := Trunc( New_R);
     *)
     {$IFNDEF FPC} 
     Q.rgbBlue := MulDiv_Byte( Q.rgbBlue , Mul_, Div_);
     Q.rgbGreen:= MulDiv_Byte( Q.rgbGreen, Mul_, Div_);
     Q.rgbRed  := MulDiv_Byte( Q.rgbRed  , Mul_, Div_);
     {$ENDIF}
     //if NewRayon > OldRayon
     //then
     //    while
     //                  (Rayon( Q) < NewRayon)
     //          and not (    (Q.rgbBlue  = 255)
     //                   and (Q.rgbGreen = 255)
     //                   and (Q.rgbRed   = 255)
     //                  )
     //    do
     //      begin
     //      Inc_Byte( Q.rgbBlue , 1);
     //      Inc_Byte( Q.rgbGreen, 1);
     //      Inc_Byte( Q.rgbRed  , 1);
     //      end
     //else
     //    while
     //                  (Rayon( Q) > NewRayon)
     //          and not (    (Q.rgbBlue  = 0)
     //                   and (Q.rgbGreen = 0)
     //                   and (Q.rgbRed   = 0)
     //                  )
     //    do
     //      begin
     //      Inc_Byte( Q.rgbBlue , -1);
     //      Inc_Byte( Q.rgbGreen, -1);
     //      Inc_Byte( Q.rgbRed  , -1);
     //      end;

     {$IFNDEF FPC}
     Result:= TColor( Q);
     {$ELSE}
     Result:= $FFFFFF;
     {$ENDIF}
end;

function TBatpro_Element._3D_Clair( Color: TColor): TColor;
const
     Mul_= 6;
     Div_= 5;
begin
     Result:= MulDiv_Color( Color, Mul_, Div_);
end;

function TBatpro_Element._3D_Sombre( Color: TColor): TColor;
const
     Mul_= 4;
     Div_= 5;
begin
     Result:= MulDiv_Color( Color, Mul_, Div_);
end;

function TBatpro_Element.OffsetPoint( P: TPoint; dx, dy: Integer): TPoint;
begin
     Result:= P;
     Inc( Result.X, dx);
     Inc( Result.Y, dy);
end;

procedure TBatpro_Element.DrawFrameButton_Color( Canvas: TCanvas; Color: TColor;
                                                 R: TRect);
var
   PolyClair: array[0..5] of TPoint;
   OldColor: TColor;
   OldStyle: TPenStyle;
   Clair, Sombre: TColor;
begin
	 {$IFNDEF FPC}
     OldColor:= Canvas.Brush.Color;
     OldStyle:= Canvas.Pen.Style;

     Clair := _3D_Clair ( Color);
     Sombre:= _3D_Sombre( Color);

     Canvas.Brush.Color:= Sombre;
     Canvas.FillRect( R);

     PolyClair[0]:= R.TopLeft;
     with PolyClair[1] do begin X:= R.Right; Y:= R.Top   ; end;
     with PolyClair[5] do begin X:= R.Left ; Y:= R.Bottom; end;

     PolyClair[3]:= OffsetPoint( PolyClair[0],  CXEDGE,  CYEDGE);
     PolyClair[2]:= OffsetPoint( PolyClair[1], -CXEDGE,  CYEDGE);
     PolyClair[4]:= OffsetPoint( PolyClair[5],  CXEDGE, -CYEDGE);

     Canvas.Pen.Style:= psClear;
     Canvas.Brush.Color:= Clair;
     Canvas.Polygon( PolyClair);
     Canvas.Pen.Style  := OldStyle;

     InflateRect( R, -CXEDGE, -CYEDGE);
     Canvas.Brush.Color:= Color;
     Canvas.FillRect( R);

     Canvas.Brush.Color:= OldColor;
     {$ENDIF}
end;

function TBatpro_Element.Batpro_ElementClassesParams_nil: Boolean;
begin
     Result:= @Batpro_ElementClassesParams = nil;
     if Result
     then
         fAccueil_Erreur(  'Erreur à signaler au développeur: '+sys_N
                          +'Batpro_ElementClassesParams = nil'+sys_N
                          +'probablement upoolG_BECP n''est pas inclue dans le projet');
end;

function TBatpro_Element.ClassParams: TBatpro_ElementClassParams;
var
   NomClasse: String;
   be: TBatpro_Element;
begin
if ClassName=sys_TBatpro_Element then begin Result:=Classe_TBatpro_Element;exit;end;
if ClassName=sys_TblG_BECP       then begin Result:=Classe_TblG_BECP      ;exit;end;
if ClassName=sys_TblG_BECPCTX    then begin Result:=Classe_TblG_BECPCTX   ;exit;end;

     Result:= Classe_TBatpro_Element;
     if Batpro_ElementClassesParams_nil then exit;

     NomClasse:= ClassName;
     Batpro_ElementClassesParams.Element_from_Cle( be, NomClasse);
     if be = nil
     then
         Result:= Classe_TBatpro_Element
     else
         Result:= be.asBECP;
end;

function TBatpro_Element.ClassFont( DrawInfo: TDrawInfo): TFont;
begin
     Result:= ClassParams.ContexteFont[ DrawInfo.Contexte];
     {
     if       (Aggrandir_a_l_impression or (DrawInfo.Col = 0))
          and (DrawInfo.Impression)
     then
         begin
         Instance_Font.Assign( Result);
         Result:= Instance_Font;
         with Result
         do
           Size
           :=
               Size
             * Impression_Font_Size_Multiplier.Valeur[ DrawInfo.Contexte];
         end;
     }

end;

function TBatpro_Element.Has_ClassParams: Boolean;
var
   NomClasse: String;
   Resultat: Boolean;
begin
     Result
     :=
          (ClassName=sys_TBatpro_Element)
       or (ClassName=sys_TblG_BECP      )or (ClassName=sys_TpoolG_BECP      )
       or (ClassName=sys_TblG_BECPCTX   )or (ClassName=sys_TpoolG_BECPCTX   );
     if Result then exit;

     if Batpro_ElementClassesParams_nil then exit;

     NomClasse:= ClassName;
     Resultat:= Batpro_ElementClassesParams.Contient( NomClasse);
     Result:= Resultat;
end;

function TBatpro_Element.Init_ClassParams: TBatpro_ElementClassParams;
begin
     Result:= nil;

     if ClassName = sys_TBatpro_Element then exit;
     if ClassName = sys_TblG_BECP       then exit;
     if ClassName = sys_TblG_BECPCTX    then exit;

     if not Assigned( poolG_BECP_Cree)  then exit;
     if Has_ClassParams                 then exit;

     Result:= poolG_BECP_Cree( ClassName);
     Result:= nil;//############ provisoire 2017 04 22
end;

function TBatpro_Element.OrientationTexte( DrawInfo: TDrawInfo): Integer;
begin
     Result:= 0;
end;

function TBatpro_Element.Cell_Height_Interne( DrawInfo: TDrawInfo;
                                              F: TFont;
                                              Texte: String;
                                              Cell_Width: Integer): Integer;
begin
     if OrientationTexte( DrawInfo) = 900
     then
         Result:=   MulDiv( LargeurTexte( F, Texte), 105, 100)
     else
         Result:=   HauteurTexte( F, Texte,
                                  Width_Interne_from_Externe( DrawInfo, Cell_Width)
                                  );
     if Assigned( Cluster)
     then
         Cluster.Check_HauteurTotale( Result);
end;

function TBatpro_Element.MargeY( DrawInfo: TDrawInfo): Integer;
begin
     if DrawInfo.Fixe
     then
         Result:= CYEDGE
     else
         Result:= CYBORDER;

     Result:= Result + Batpro_Element_Marge;
end;

function TBatpro_Element.Height_Externe_from_Interne( DrawInfo: TDrawInfo; Valeur: Integer): Integer;
begin
     Result:= Valeur + 2 * MargeY( DrawInfo);
end;

function TBatpro_Element.Height_Interne_from_Externe( DrawInfo: TDrawInfo;
                                                      Valeur: Integer): Integer;
begin
     Result:= Valeur - 2 * MargeY( DrawInfo);
end;

function TBatpro_Element.Cell_Height( _DrawInfo: TDrawInfo;
                                      _Cell_Width: Integer): Integer;
begin
     Result:= Cell_Height_Interne( _DrawInfo,
                                   ClassFont( _DrawInfo),
                                   Cell     [ _DrawInfo.Contexte], _Cell_Width);

     Result:= Height_Externe_from_Interne( _DrawInfo, Result);
end;

function TBatpro_Element.Cell_Width_Interne( DrawInfo: TDrawInfo;
                                             F: TFont;
                                             Texte: String): Integer;
begin
     if OrientationTexte( DrawInfo) = 900
     then
         Result:= MulDiv( LineHeight( F), 105, 100)
     else
         Result:= LargeurTexte( F, Texte);
     if Assigned( Cluster)
     then
         Cluster.Check_LargeurTotale( Result);
end;

function TBatpro_Element.MargeX( DrawInfo: TDrawInfo): Integer;
begin
     if DrawInfo.Fixe
     then
         Result:= CXEDGE
     else
         Result:= CXBORDER;

     Result:= Result + Batpro_Element_Marge;
end;

function TBatpro_Element.Width_Externe_from_Interne( DrawInfo: TDrawInfo;Valeur: Integer): Integer;
begin
     Result:= Valeur + 2 * MargeX( DrawInfo) + Retrait_Texte;
end;

function TBatpro_Element.Width_Interne_from_Externe( DrawInfo: TDrawInfo;
                                                     Valeur: Integer): Integer;
begin
     Result:= Valeur - 2 * MargeX( DrawInfo) - Retrait_Texte;
end;

function TBatpro_Element.Cell_Width( DrawInfo: TDrawInfo): Integer;
begin
     Result:= Cell_Width_Interne( DrawInfo,
                                  ClassFont( DrawInfo),
                                  Cell     [ DrawInfo.Contexte]);
     if Result > 0
     then
         Result:=   Width_Externe_from_Interne( DrawInfo, Result);
end;

function TBatpro_Element.Rect_Interne_from_Externe( DrawInfo: TDrawInfo;
                                                    Valeur: TRect): TRect;
begin
     Result:= Valeur;
     InflateRect( Result, - MargeX( DrawInfo) -Retrait_Texte div 2, - MargeY( DrawInfo));
     if Retrait_Texte <> 0
     then
         OffsetRect( Result, Retrait_Texte div 2, 0);
end;

function TBatpro_Element.Rect_Externe_from_Interne( DrawInfo: TDrawInfo;
                                                    Valeur: TRect): TRect;
begin
     Result:= Valeur;
     InflateRect( Result, + MargeX( DrawInfo) +Retrait_Texte div 2, + MargeY( DrawInfo));
     if Retrait_Texte <> 0
     then
         OffsetRect( Result, -Retrait_Texte div 2, 0);
end;

function TBatpro_Element.MouseDown( Button: TMouseButton;
                                    Shift: TShiftState): Boolean;
begin
     Result:= False;
end;

function TBatpro_Element.sCle: String;
begin
     Result:= sys_Vide;
end;

function TBatpro_Element.Contenu( Contexte: Integer; Col, Row: Integer): String;
begin
     Result:= Contenu_statique;
     if '' <> Result then exit;

     Result:= Cell[ Contexte];
end;

function TBatpro_Element.Assure_PopupMenu: Boolean;
begin
     Result:= nil = FPopupMenu;
     if not Result then exit;

     FPopupMenu:= TPopupMenu.Create( nil);

     {$IFNDEF FPC}
     miContexteFont:= TMenuItem.Create( FPopupMenu);
     FPopupMenu.Items.Add( miContexteFont);
     miContexteFont.Caption:= 'Police';
     miContexteFont.OnClick:= miContexteFontCLick;

     miBulle:= TMenuItem.Create( FPopupMenu);
     FPopupMenu.Items.Add( miBulle);
     miBulle.Caption:= 'Bulle d''aide '+ClassName;
     miBulle.OnClick:= miBulleCLick;
     {$ENDIF}
end;

function TBatpro_Element.Popup(Contexte: Integer): TPopupMenu;
begin
     Assure_PopupMenu;

     Result:= FPopupMenu;
     {$IFNDEF FPC}
     miContexteFont.Tag:= Contexte;
     miBulle       .Tag:= Contexte;
     {$ENDIF}
end;

procedure TBatpro_Element.miContexteFontCLick(Sender: TObject);
var
   Contexte: Integer;
begin
     {$IFNDEF FPC}
     Contexte:= miContexteFont.Tag;
     ClassParams.Edit_ContexteFont( Contexte);
     {$ENDIF}
end;

procedure TBatpro_Element.miBulleCLick(Sender: TObject);
var
   Contexte: Integer;
begin
     {$IFNDEF FPC}
     Contexte:= miBulle.Tag;
     EditeBulle( Contexte);
     {$ENDIF}
end;

procedure TBatpro_Element.EditeBulle(Contexte: Integer);
begin
     {$IFNDEF FPC}
     MessageBox( 0, PChar( String( classname)), 'EditeBulle', 0);
     {$ENDIF}
end;

function TBatpro_Element.Index: Integer;
begin
     Result:= -1;
     if sl = nil then exit;
     Result:= sl.IndexOfObject( Self);
end;

procedure TBatpro_Element.sl_from_sCle;
var
   I: Integer;
begin
     I:= Index;
     if I = -1 then exit;

     sl.Strings[ I]:= sCle;
end;

function TBatpro_Element.Get_Alignement(Contexte: Integer): TbeAlignement;
begin
     Result.H:= bea_Centre_Horiz ;
     Result.V:= bea_Centre_Vertic;
     //Result.V:= bea_Haut;
end;

function TBatpro_Element.VerticalHorizontal_( Contexte: Integer): Boolean;
begin
     Result:= False;
end;

procedure TBatpro_Element.{svg}Dessinne_Gris( DrawInfo: TDrawInfo);
begin
     {$IFDEF WINDOWS_GRAPHIC}
     if False//Gris essai désactivé
     then
         with DrawInfo
         do
           begin
           Couleur_Brosse:= clBlack;
           Canvas.Brush.Style:= bsFDiagonal;
           StyleLigne:= psClear;
           Rectangle( Rect);
           StyleLigne:= psSolid;
           Canvas.Brush.Style:= bsSolid;
           end;
     {$ENDIF}
end;


procedure TBatpro_Element.{svg}DrawJalon( DrawInfo: TDrawInfo; Forme: TTypeJalon;
                                     CouleurJalon: TColor;
                                     CouleurJalon_Contour : TColor= clBlack;
                                     Note: Boolean= False);
var
   //Jalon
   Centre: TPoint;
   Border: TRect;
   dx , dy ,
   dx2, dy2,
   rayon: Integer;
   Polygone: array of TPoint;
   function StartX_from_DebutFin_( DebutFin_: Boolean): Integer;
   begin
        if DebutFin_
        then
            Result:= Border.Right
        else
            Result:= Border.Left;
   end;
   procedure Draw_Jalon_Debut_Fin( DebutFin_: Boolean);
   var
      StartX: Integer;
   begin
        StartX:= StartX_from_DebutFin_( DebutFin_);

        // formes v- et -v
        with DrawInfo
        do
          begin
          CouleurLigne:= CouleurJalon;
          MoveTo( StartX      , Centre.Y   );
          LineTo( Centre.X    , Centre.Y   );
          LineTo( Centre.X    , Rect.Bottom);

          CouleurLigne:= CouleurJalon_Contour;
          SetLength( Polygone, 3);
          Polygone[0]:= Point( Centre.X+dx2, Rect.Top);
          Polygone[1]:= Point( Centre.X    , Rect.Bottom      );
          Polygone[2]:= Point( Centre.X-dx2, Rect.Top);

          Polygon( Polygone);
          end;
   end;
   procedure Draw_Jalon_Trait_Epais_Debut_Fin( DebutFin_: Boolean);
   var
      CoefficientEpaisseur: double;
      c_dy2, c_dy4: Integer;
      Sommet: Integer;
      Pointe: TPoint;
      procedure Calcule_c_dy;
      begin
           c_dy2    := Trunc( CoefficientEpaisseur * dy2);
           c_dy4    := c_dy2 div 2;
      end;
   begin
        if Assigned(Serie)
        then
            CoefficientEpaisseur:= Serie.CoefficientEpaisseur
        else
            CoefficientEpaisseur:= 1/2;

        Calcule_c_dy;
        if c_dy2 < 4
        then
            begin
            CouleurJalon_Contour:= CouleurJalon;
            //if c_dy2 <= 2
            //then
            //    begin
            //    CoefficientEpaisseur:= 1;
            //    Calcule_c_dy;
            //    end
            end;

        Sommet:= Centre.Y - c_dy2;

        // formes v- et -v
        with DrawInfo
        do
          begin
          SetLength( Polygone, 5);
          //if DebutFin_
          //then
          //    begin //Debut v-
          //    Polygone[0]:= Point( Rect.Left   , Sommet     );
          //    Polygone[1]:= Point( Centre.X    , Rect.Bottom);
          //    Polygone[2]:= Point( Centre.X+dx2_c_dx4, Centre.Y   );
          //    Polygone[3]:= Point( Border.Right, Centre.Y   );
          //    Polygone[4]:= Point( Border.Right, Sommet     );
          //    end
          //else
          //    begin //Fin   -v
          //    Polygone[0]:= Point( Rect.Right  , Sommet     );
          //    Polygone[1]:= Point( Centre.X    , Rect.Bottom);
          //    Polygone[2]:= Point( Centre.X-dx2_c_dx4, Centre.Y   );
          //    Polygone[3]:= Point( Border.Left , Centre.Y   );
          //    Polygone[4]:= Point( Border.Left , Sommet     );
          //    end;

          Pointe.x:= Centre.x;
          Pointe.y:= Centre.y  + c_dy2;
          if DebutFin_
          then
              begin //Debut v-
              Polygone[0]:= Point( Pointe.x-c_dy2, Sommet     );
              if Polygone[0].x < Rect.Left    then Polygone[0].x:= Rect.Left;
              Polygone[1]:= Pointe;
              Polygone[2]:= Point( Pointe.x+c_dy4, Centre.Y   );
              if Polygone[2].x > Border.Right then Polygone[2].x:= Border.Right;
              Polygone[3]:= Point( Border.Right, Centre.Y   );
              Polygone[4]:= Point( Border.Right, Sommet     );
              end
          else
              begin //Fin   -v
              Polygone[0]:= Point( Pointe.x+c_dy2 , Sommet     );
              if Polygone[0].x > Rect.Right   then Polygone[0].x:= Rect.Right;
              Polygone[1]:= Pointe;
              Polygone[2]:= Point( Pointe.x-c_dy4, Centre.Y   );
              if Polygone[2].x < Border.Left  then Polygone[2].x:= Border.Left;
              Polygone[3]:= Point( Border.Left , Centre.Y   );
              Polygone[4]:= Point( Border.Left , Sommet     );
              end;

          CouleurLigne:= CouleurJalon_Contour;
          Polygon( Polygone);
          end;
   end;
begin
     DrawInfo.Borne_Hauteur;
     with DrawInfo
     do
       begin
       Remplit_Rectangle( Rect_Original, Couleur_Fond( DrawInfo));

       Couleur_Brosse:= CouleurJalon;

       if Note
       then
           image_DOCSINGL_centre( Couleur_Fond( DrawInfo));

       Border:= Rect;

       InflateRect( Rect, -3, -3);
       {$IF DEFINED(MSWINDOWS) AND NOT DEFINED(FPC)}
       Centre:= CenterPoint( Rect);
       {$ELSE}
       {$IFEND}
       dx:= Rect.Right  - Rect.Left;
       dy:= Rect.Bottom - Rect.Top ;
       dx2:= dx div 2; dy2:= dy div 2;

       case Forme
       of
         tj_Losange:
           begin
           // forme  /\
           //        \/
           CouleurLigne:= CouleurJalon_Contour;

           MoveTo( Centre.X  , Rect.Top   );
           LineTo( Rect.Right, Centre.Y   );
           LineTo( Centre.X  , Rect.Bottom);
           LineTo( Rect.Left , Centre.Y   );
           LineTo( Centre.X  , Rect.Top   );
           end;
         tj_LosangePlein:
           begin
           // forme  /\
           //        \/
           //CouleurLigne:= CouleurJalon_Contour;

           //SetLength( Polygone, 4);
           //Polygone[0]:= Point( Centre.X      , Rect.Top+dy4   );
           //Polygone[1]:= Point( Rect.Right-dx4, Centre.Y       );
           //Polygone[2]:= Point( Centre.X      , Rect.Bottom-dy4);
           //Polygone[3]:= Point( Rect.Left+dx4 , Centre.Y       );
           //Canvas.Polygon( Polygone);

           DrawInfo.image_LOSANGE__centre(Couleur_Fond( DrawInfo));
           end;
         tj_Login:
           begin
           DrawInfo.image_LOSANGE__centre(Couleur_Fond( DrawInfo));
           end;
         tj_MEN_AT_WORK:
           begin
           DrawInfo.image_MEN_AT_WORK__centre(Couleur_Fond( DrawInfo));
           end;
         tj_DOSSIER_KDE_PAR_POSTE:
           begin
           DrawInfo.image_DOSSIER_KDE_PAR_POSTE__centre(Couleur_Fond( DrawInfo));
           end;
         tj_Ellipse:
           begin
           // forme  
           if dx < dy
           then
               rayon:= dx div 2
           else
               rayon:= dy div 2;
           if rayon = 0 then rayon:= 1;

           CouleurLigne:= CouleurJalon;
           Ellipse( Centre.X-rayon, Centre.Y-rayon,
                    Centre.X+rayon, Centre.Y+rayon);
           end;
         tj_TraitVertical:
           begin
           // forme  |
           Rayon:= 2;
           CouleurLigne:= CouleurJalon;
           Rectangle( Centre.X-rayon, Rect.Top,
                      Centre.X+rayon, Rect.Bottom);
           end;
         tj_Puce:
           begin
           // forme  
           if dx < dy
           then
               rayon:= dx div 5
           else
               rayon:= dy div 5;
           if rayon = 0 then rayon:= 1;

           CouleurLigne:= CouleurJalon;
           Ellipse( Centre.X-rayon, Centre.Y-rayon,
                    Centre.X+rayon, Centre.Y+rayon);
           end;
         tj_Triangle_vers_droite:
           begin
           // forme  |>
           CouleurLigne:= CouleurJalon_Contour;

           SetLength( Polygone, 3);
           Polygone[0]:= Point( Rect.Left , Rect.Top   );
           Polygone[1]:= Point( Rect.Right, Centre.Y   );
           Polygone[2]:= Point( Rect.Left , Rect.Bottom);
           Polygon( Polygone);
           end;
         tj_Jalon_Debut:
           begin
           // forme  v-
           Draw_Jalon_Debut_Fin( True);
           end;
         tj_Jalon_Fin:
           begin
           // forme  -v
           Draw_Jalon_Debut_Fin( False);
           end;
         tj_Jalon_Trait_Epais_Debut:
           begin
           // forme  v-
           Draw_Jalon_Trait_Epais_Debut_Fin( True);
           end;
         tj_Jalon_Trait_Epais_Fin:
           begin
           // forme  -v
           Draw_Jalon_Trait_Epais_Debut_Fin( False);
           end;
         end;
       end
end;

procedure TBatpro_Element.SetSelected( Value: Boolean);
begin
     FSelected:= Value;
end;

{ TbeClusterElement }

function beClusterElement_from_sl( sl: TBatpro_StringList; Index: Integer): TbeClusterElement;
begin
     _Classe_from_sl( Result, TbeClusterElement, sl, Index);
end;


procedure Initialise_Clusters( sl: TBatpro_StringList); overload;
var
   I: Integer;
   BE: TBatpro_Element;
   beClusterElement: TbeClusterElement;
begin
     for I:= 0 to sl.Count - 1
     do
       begin
       BE:= Batpro_Element_from_sl( sl, I);
       if     Assigned( BE)
          and (BE is TbeClusterElement)
       then
           begin
           beClusterElement:= TbeClusterElement( BE);
           beClusterElement.Initialise;
           end
       end;
end;

procedure Initialise_Clusters( bts: TbtString); overload;
var
   BE: TBatpro_Element;
   beClusterElement: TbeClusterElement;
begin
     bts.Iterateur_Start;
     while not bts.Iterateur_EOF
     do
       begin
       bts.Iterateur_Suivant( BE);
       if     Assigned( BE)
          and (BE is TbeClusterElement)
       then
           begin
           beClusterElement:= TbeClusterElement( BE);
           beClusterElement.Initialise;
           end
       end;
end;

constructor TbeClusterElement.Create( un_sl: TBatpro_StringList;
                                      _beCluster: TBatpro_Element);
begin
     inherited Create( un_sl);
     FbeCluster:= _beCluster;
end;

procedure TbeClusterElement.Draw(DrawInfo: TDrawInfo);
{$IFNDEF FPC}
var
   Bounds: TRect;
   sg: TStringGrid;
   sg_GridLineWidth: Integer;
   I, J,
   OffsetX, OffsetY,
   Largeur, Hauteur: Integer;

   OriginalRect, OriginalRect_Original: TRect;
   procedure Traite_Rect( var _R: TRect);
   var
      Origine: TPoint;
   begin
        Origine:= _R.TopLeft;
        Dec( Origine.x, OffsetX);
        Dec( Origine.y, OffsetY);
        _R:= Rect( 0,0, Largeur, Hauteur);
        OffsetRect( _R, Origine.x, Origine.y);
   end;
begin
     if beCluster         = nil then exit;
     if beCluster.Cluster = nil then exit;

     Bounds:= beCluster.Cluster.Bounds;
     sg:= DrawInfo.sg;
     if DrawInfo.Impression
     then
         sg_GridLineWidth:= 0
     else
         sg_GridLineWidth:= sg.GridLineWidth;


     OffsetX:= 0;
     for I:= Bounds.Left to DrawInfo.Col-1 do Inc( OffsetX, sg.ColWidths [I]+sg_GridLineWidth);
     OffsetY:= 0;
     for J:= Bounds.Top  to DrawInfo.Row-1 do Inc( OffsetY, sg.RowHeights[J]+sg_GridLineWidth);

     Largeur:= 0;
     for I:= Bounds.Left to Bounds.Right  do Inc( Largeur, sg.ColWidths [I]+sg_GridLineWidth);
     Hauteur:= 0;
     for J:= Bounds.Top  to Bounds.Bottom do Inc( Hauteur, sg.RowHeights[J]+sg_GridLineWidth);

     OriginalRect         := DrawInfo.Rect;
     OriginalRect_Original:= DrawInfo.Rect_Original;
       Traite_Rect( DrawInfo.Rect);
       Traite_Rect( DrawInfo.Rect_Original);
       beCluster.Draw( DrawInfo);
     DrawInfo.Rect         := OriginalRect;
     DrawInfo.Rect_Original:= OriginalRect_Original;
     //Il faudrait peut-être gérer le clipping
     //==> comment vont se dessinner les lignes de la grille ?
end;
{$ELSE}
begin
end;
{$ENDIF}

procedure TbeClusterElement.svgDraw(DrawInfo: TDrawInfo);
var
   Bounds: TRect;
   sg: TStringGrid;
   sg_GridLineWidth: Integer;
   I, J,
   OffsetX, OffsetY,
   Largeur, Hauteur: Integer;

   OriginalRect: TRect;
   Origine: TPoint;
begin
     if beCluster         = nil then exit;
     if beCluster.Cluster = nil then exit;

     Bounds:= beCluster.Cluster.Bounds;
     sg:= DrawInfo.sg;
     if DrawInfo.Impression
     then
         sg_GridLineWidth:= 0
     else
         sg_GridLineWidth:= sg.GridLineWidth;


     OffsetX:= 0;
     for I:= Bounds.Left to DrawInfo.Col-1 do Inc( OffsetX, sg.ColWidths [I]+sg_GridLineWidth);
     OffsetY:= 0;
     for J:= Bounds.Top  to DrawInfo.Row-1 do Inc( OffsetY, sg.RowHeights[J]+sg_GridLineWidth);

     Largeur:= 0;
     for I:= Bounds.Left to Bounds.Right  do Inc( Largeur, sg.ColWidths [I]+sg_GridLineWidth);
     Hauteur:= 0;
     for J:= Bounds.Top  to Bounds.Bottom do Inc( Hauteur, sg.RowHeights[J]+sg_GridLineWidth);

     OriginalRect:= DrawInfo.Rect;
       Origine:= DrawInfo.Rect.TopLeft;
       Dec( Origine.x, OffsetX);
       Dec( Origine.y, OffsetY);
       DrawInfo.Rect:= Rect( 0,0, Largeur, Hauteur);
       OffsetRect( DrawInfo.Rect, Origine.x, Origine.y);
       beCluster.svgDraw( DrawInfo);
     DrawInfo.Rect:= OriginalRect;
     //Il faudrait peut-être gérer le clipping
     //==> comment vont se dessinner les lignes de la grille ?
end;

function TbeClusterElement.Cell_Height( _DrawInfo: TDrawInfo; _Cell_Width: Integer): Integer;
begin
     //pas évident que cet algo soit OK
     if     Assigned( beCluster)
        and Assigned( beCluster.Cluster)
        and beCluster.Cluster.SingleRow
     then
         // si 1 seule ligne, on postule que le cluster a toute la largeur
         // qu'il demande
         Result:= beCluster.Cell_Height( _DrawInfo,
                                         beCluster.Cell_Width( _DrawInfo))
     else
         Result:= inherited Cell_Height( _DrawInfo, _Cell_Width);
end;

procedure TbeClusterElement.CalculeLargeur( DrawInfo: TDrawInfo;
                                            Colonne, Ligne: Integer;
                                            var Largeur: Integer);
begin
     if     Assigned( beCluster)
        and Assigned( beCluster.Cluster)
     then
         beCluster.Cluster.CalculeLargeur( DrawInfo,
                                           Colonne, Ligne,
                                           Largeur);
end;

procedure TbeClusterElement.CalculeHauteur( DrawInfo: TDrawInfo;
                                            Colonne, Ligne: Integer;
                                            var Hauteur: Integer);
begin
     if     Assigned( beCluster)
        and Assigned( beCluster.Cluster)
     then
         beCluster.Cluster.CalculeHauteur( DrawInfo,
                                           Colonne, Ligne,
                                           Hauteur);
end;

procedure TbeClusterElement.Initialise;
begin
     if     Assigned( beCluster)
        and Assigned( beCluster.Cluster)
     then
         beCluster.Cluster.Initialise;
end;

procedure TbeClusterElement.Ajoute(Colonne, Ligne: Integer);
begin
     if     Assigned( beCluster)
        and Assigned( beCluster.Cluster)
     then
         beCluster.Cluster.Ajoute( Self, Colonne, Ligne);
end;

function TbeClusterElement.GetCell( Contexte: Integer): String;
var
   Position: TPoint;
begin
     Result:= sys_Vide;
     if beCluster         = nil then exit;
     if beCluster.Cluster = nil then exit;
     Position:= beCluster.Cluster.Cherche( Self);
     if    (Position.x <> 0)
        or (Position.y <> 0) then exit;

     Result:= beCluster.Cell[ Contexte];
end;

function TbeClusterElement.Contenu( Contexte, Col, Row: Integer): String;
begin
     Result:= sys_Vide;
     if beCluster         = nil then exit;

     Result:= beCluster.Contenu( Contexte, Col, Row);
end;

function TbeClusterElement.sEtatCluster: String;
begin
     if Assigned( beCluster)
     then
         Result:= beCluster.sEtatCluster
     else
         Result:= 'Erreur à signaler au développeur: '+
                  'TbeClusterElement.beCluster = nil';
end;

//############################## TBatpro_Serie #################################

constructor TBatpro_Serie.Create(un_be: TBatpro_Element);
begin
     inherited Create;
     Initialise;
     be:= un_be;
     CellDebut:= False;
     Style:= ss_TraitFin;
     CoefficientEpaisseur:= 1;
     Couleur:= clBlack;
     Pourcentage:= 0;
end;

procedure TBatpro_Serie.Initialise;
begin
     EtatInitial:= True;
end;

procedure TBatpro_Serie.Ajoute( _Debut, _Fin: Integer);
begin
     if EtatInitial
     then
         begin
         FDebut:=_Debut;
         FFin  :=_Fin  ;
         EtatInitial:= False;
         end
     else
         begin
         if FDebut > _Debut then FDebut:=_Debut;
         if FFin   < _Fin   then FFin  :=_Fin  ;
         end;
end;

procedure TBatpro_Serie.Decale( Delta: Integer);
begin
     if EtatInitial then exit;
     Inc( FDebut, Delta);
     Inc( FFin  , Delta);
end;

function TBatpro_Serie.VerticalHorizontal_( Contexte: Integer): Boolean;
begin
     Result:= be.VerticalHorizontal_( Contexte);
end;

procedure TBatpro_Serie.SetVisible( _VisibleDebut, _VisibleFin: Integer);
begin
     FVisibleDebut:= _VisibleDebut;
     FVisibleFin  := _VisibleFin  ;
     nPourcentage
     :=
       VisibleDebut+( (VisibleFin-VisibleDebut+1) * Pourcentage) /100;
     nPourcentage_2
     :=
       VisibleDebut+( (VisibleFin-VisibleDebut+1) * Pourcentage_2) /100;
end;

function TBatpro_Serie.Index_from_DrawInfo(DrawInfo: TDrawInfo): Integer;
begin
     if VerticalHorizontal_( DrawInfo.Contexte)
     then
         Result:= DrawInfo.Row
     else
         Result:= DrawInfo.Col;
end;

procedure TBatpro_Serie.{svg}Dessinne_Pourcentage_interne_interne( _DrawInfo: TDrawInfo;
                                                                   _Index: Integer;
                                                                   _Pourcentage: double;
                                                                   _nPourcentage: double;
                                                                   _Y: Integer;
                                                                   _Color: TColor);
var
   Largeur, Hauteur: Integer;
   XGauche, XDroite,
   X1, X2: Integer;
   Old_Pen_Style: TPenStyle;
   Old_Pen_Color: TColor;
   Old_Brush_Style: TBrushStyle;
   Old_Brush_Color: TColor;
   Trunc_nPourcentage: Integer;
begin
     {$IFNDEF FPC}
     if Reel_Zero( _Pourcentage) then exit;

     Trunc_nPourcentage:= Trunc( _nPourcentage);
     if Trunc_nPourcentage < _Index then exit;

     XGauche:= _DrawInfo.Rect.Left;
     XDroite:= _DrawInfo.Rect.Right;
     Largeur:= XDroite-XGauche;
     with _DrawInfo.Rect
     do
       Hauteur:= (Bottom - Top) div 4;

          if _Index < Trunc_nPourcentage
     then
         begin
         X1:= XGauche;
         X2:= XDroite;
         end
     else if _Index = Trunc_nPourcentage
     then
         begin
         X1:= XGauche;
         X2:= Trunc( XGauche + Frac(_nPourcentage)*Largeur);
         end
     else
         begin
         X1:= 0;
         X2:= 0;
         end;
     Old_Pen_Style:= _DrawInfo.StyleLigne;
     Old_Pen_Color:= _DrawInfo.CouleurLigne;
     Old_Brush_Style:= _DrawInfo.Canvas.Brush.Style;
     Old_Brush_Color:= _DrawInfo.Couleur_Brosse;

     _DrawInfo.StyleLigne:= psSolid;
     _DrawInfo.CouleurLigne:= _Color;
     _DrawInfo.Canvas.Brush.Style:= bsSolid;
     _DrawInfo.Couleur_Brosse:= _Color;
     //_DrawInfo.Moveto( X1, _Y);
     //_DrawInfo.LineTo( X2, _Y);
     _DrawInfo.Rectangle( X1, _Y, X2, _Y+Hauteur);

     _DrawInfo.StyleLigne:= Old_Pen_Style;
     _DrawInfo.CouleurLigne:= Old_Pen_Color;
     _DrawInfo.Canvas.Brush.Style:= Old_Brush_Style;
     _DrawInfo.Couleur_Brosse:= Old_Brush_Color;
     {$ENDIF}
end;

procedure TBatpro_Serie.{svg}Dessinne_Pourcentage_interne( DrawInfo: TDrawInfo; Index: Integer);
var
   Y: Integer;
begin
     with DrawInfo.Rect
     do
       Y:= Top + Muldiv( Bottom - Top, 3, 4);
     Dessinne_Pourcentage_interne_interne( DrawInfo, Index, Pourcentage, nPourcentage, Y,clRed);
end;

procedure TBatpro_Serie.{svg}Dessinne_Pourcentage( DrawInfo: TDrawInfo);
begin
     {svg}Dessinne_Pourcentage_interne( DrawInfo, Index_from_DrawInfo( DrawInfo));
end;

procedure TBatpro_Serie.{svg}Dessinne_Pourcentage_2_interne( DrawInfo: TDrawInfo; Index: Integer);
var
   Y: Integer;
begin
     with DrawInfo.Rect
     do
       Y:= Top;
     Dessinne_Pourcentage_interne_interne( DrawInfo, Index, Pourcentage_2, nPourcentage_2, Y, clBlue);
end;

procedure TBatpro_Serie.{svg}Dessinne_Pourcentage_2( DrawInfo: TDrawInfo);
begin
     {svg}Dessinne_Pourcentage_2_interne( DrawInfo, Index_from_DrawInfo( DrawInfo));
end;

function TBatpro_Serie.Draw( DrawInfo: TDrawInfo): Boolean;
var
   Index: Integer;
   TronqueDebut, TronqueFin: Boolean;
   nJour: Integer;
begin
     Result:= CellDebut;
     if EtatInitial               then exit;
     if VisibleDebut = VisibleFin then exit;

     Index:= Index_from_DrawInfo( DrawInfo);
     if Index < VisibleDebut     then exit;

     DrawInfo.Borne_Hauteur;
     if (Index = VisibleDebut) and (not CellDebut)  then exit;

     Result:= True;
     TronqueDebut:= Debut < VisibleDebut;
     TronqueFin  := VisibleFin < Fin;
     nJour:= 1+Index-Debut;

          if Index = VisibleFin
     then
         if TronqueFin
         then
            Ligne_VisibleFin( DrawInfo, nJour)
         else
             Ligne_FinSerie ( DrawInfo, nJour)
     else if Index = VisibleDebut + 1
     then
         if TronqueDebut
         then
             Ligne_VisibleDebut( DrawInfo, nJour)
         else
             Ligne_Serie( DrawInfo, nJour)
     else if Index = VisibleDebut
     then
         Ligne_DebutSerie ( DrawInfo, nJour)
     else
         Ligne_Serie( DrawInfo, nJour);
     if Assigned( be)
     then
         be.Dessinne_Gris( DrawInfo);
     Dessinne_Pourcentage_interne  ( DrawInfo, Index);
     Dessinne_Pourcentage_2_interne( DrawInfo, Index);
end;

function TBatpro_Serie.svgDraw( _DrawInfo: TDrawInfo): Boolean;
var
   Index: Integer;
   TronqueDebut, TronqueFin: Boolean;
   nJour: Integer;
begin
     Result:= CellDebut;
     if EtatInitial               then exit;
     if VisibleDebut = VisibleFin then exit;

     Index:= Index_from_DrawInfo( _DrawInfo);
     if Index < VisibleDebut     then exit;

     if (Index = VisibleDebut) and (not CellDebut)  then exit;

     _DrawInfo.Borne_Hauteur;

     Result:= True;
     TronqueDebut:= Debut < VisibleDebut;
     TronqueFin  := VisibleFin < Fin;
     nJour:= 1+Index-Debut;

          if Index = VisibleFin
     then
         if TronqueFin
         then
             svgLigne_VisibleFin( _DrawInfo, nJour)
         else
             svgLigne_FinSerie ( _DrawInfo, nJour)
     else if Index = VisibleDebut + 1
     then
         if TronqueDebut
         then
             svgLigne_VisibleDebut( _DrawInfo, nJour)
         else
             svgLigne_Serie( _DrawInfo, nJour)
     else if Index = VisibleDebut
     then
         svgLigne_DebutSerie ( _DrawInfo, nJour)
     else
         svgLigne_Serie( _DrawInfo, nJour);
     if Assigned( be)
     then
         be.{svg}Dessinne_Gris( _DrawInfo);
     {svg}Dessinne_Pourcentage_interne  ( _DrawInfo, Index);
     {svg}Dessinne_Pourcentage_2_interne( _DrawInfo, Index);
end;

procedure TBatpro_Serie.{svg}Dessinne_Fond( DrawInfo: TDrawInfo);
begin
     if Assigned( be)
     then
         be.Dessinne_Fond( DrawInfo);
end;

function TBatpro_Serie.snJour_from_nJour( _nJour: Integer): String;
begin
     if _nJour < 0
     then
         Result:= 'J-'+IntToStr( _nJour)
     else if _nJour = 0
     then
         Result:= ''
     else
         Result:= 'J+'+IntToStr( _nJour);
end;

procedure TBatpro_Serie.Affiche_nJour( DrawInfo: TDrawInfo; _nJour: Integer);
var
   OldFont: TFont;
begin
     {$IFNDEF FPC}
     if not VerticalHorizontal_( DrawInfo.Contexte) then exit;
     OldFont:= TFont.Create;
     with DrawInfo
     do
       begin
       OldFont.Assign( Canvas.Font);
         Canvas.Font.Name:= sys_Arial; // sys_SmallFonts, 7, Bold
         Canvas.Font.Size:= 8;
         //with Canvas.Font do Style:= Style + [fsBold];
         Canvas.TextOut( Rect.Left+3, Rect.Top+3, snJour_from_nJour( _nJour));
       Canvas.Font.Assign( OldFont);
       end;
     FreeAndNil( OldFont);
     {$ENDIF}
end;

procedure TBatpro_Serie.svgAffiche_nJour( _DrawInfo: TDrawInfo; _nJour: Integer);
begin
     if not VerticalHorizontal_( _DrawInfo.Contexte) then exit;

     with _DrawInfo
     do
       text( Rect.Left+3, Rect.Top+3, snJour_from_nJour( _nJour), sys_Arial,8);
end;

procedure TBatpro_Serie.{svg}DrawTraitHorizontal( DrawInfo: TDrawInfo; R: TRect;
                                             TrameSolide_:Boolean);
{$IF DEFINED(MSWINDOWS) AND NOT DEFINED(FPC)}
var
   Polygone: array of TPoint;
   OldBrushColor: TColor;
   OldBitmap: TCustomBitmap;
   YC, dy2, c_dy2: Integer;
   Sommet: Integer;
   Motif: TBitmap;
begin
     if TrameSolide_
     then
         Motif:= fBitmaps.bBrosse_Vertical_50
     else
         Motif:= fBitmaps.bBrosse_Solide;

     YC := (R.Top+R.Bottom) div 2;
     dy2:= (R.Bottom-R.Top) div 2;
     c_dy2:= Trunc( CoefficientEpaisseur * dy2);
     Sommet:= YC-c_dy2;

     SetLength( Polygone, 4);
     Polygone[0]:= Point( R.Left , Sommet);
     Polygone[1]:= Point( R.Right, Sommet);
     Polygone[2]:= Point( R.Right, YC    );
     Polygone[3]:= Point( R.Left , YC    );

     with DrawInfo
     do
       begin
       OldBitmap:= Canvas.Brush.Bitmap;
       Canvas.Brush.Bitmap:= Motif;
         OldBrushColor:= Couleur_Brosse;
         Couleur_Brosse:= Couleur;
           Polygon( Polygone);
         Couleur_Brosse:= OldBrushColor;
       Canvas.Brush.Bitmap:= OldBitmap;
       end;
end;
{$ELSE}
begin
end;
{$IFEND}

procedure TBatpro_Serie.{svg}DrawDemiLigne( DrawInfo: TDrawInfo; R: TRect; TrameSolide_: Boolean);
{$IF DEFINED(MSWINDOWS) AND NOT DEFINED(FPC)}
var
   Polygone: array of TPoint;
   OldBrushColor: TColor;
   OldBitmap: TCustomBitmap;
   YC: Integer;
   Bas: Integer;
   Motif: TBitmap;
begin
     if TrameSolide_
     then
         Motif:= fBitmaps.bBrosse_Vertical_50
     else
         Motif:= fBitmaps.bBrosse_Solide;

     YC := (R.Top+R.Bottom) div 2;
     Bas:= R.Bottom;

     SetLength( Polygone, 4);
     Polygone[0]:= Point( R.Left , YC);
     Polygone[1]:= Point( R.Right, YC);
     Polygone[2]:= Point( R.Right, Bas);
     Polygone[3]:= Point( R.Left , Bas);

     with DrawInfo
     do
       begin
       OldBitmap:= Canvas.Brush.Bitmap;
       Canvas.Brush.Bitmap:= Motif;
         OldBrushColor:= Couleur_Brosse;
         Couleur_Brosse:= Couleur;
           Polygon( Polygone);
         Couleur_Brosse:= OldBrushColor;
       Canvas.Brush.Bitmap:= OldBitmap;
       end;
end;
{$ELSE}
begin
end;
{$IFEND}

procedure TBatpro_Serie.{svg}DrawDemiLigne_Pointille( DrawInfo: TDrawInfo;
                                                 R: TRect; TrameSolide_: Boolean);
{$IF DEFINED(MSWINDOWS) AND NOT DEFINED(FPC)}
var
   W, X1_3, X2_3, YC: Integer;
   Bas: Integer;
   Motif: TBitmap;
   procedure Bloc( _Debut, _Fin: Integer);
   var
      Polygone: array of TPoint;
      OldBrushColor: TColor;
      OldBitmap: TCustomBitmap;
      OldPenStyle: TPenStyle;
   begin
        SetLength( Polygone, 4);
        Polygone[0]:= Point( _Debut, YC);
        Polygone[1]:= Point( _Fin  , YC);
        Polygone[2]:= Point( _Fin  , Bas);
        Polygone[3]:= Point( _Debut, Bas);

        with DrawInfo
        do
          begin
          OldBitmap  := Canvas.Brush.Bitmap;
          OldPenStyle:= StyleLigne;
          Canvas.Brush.Bitmap:= Motif;
          StyleLigne   := psClear;
            OldBrushColor:= Couleur_Brosse;
            Couleur_Brosse:= Couleur;
              Polygon( Polygone);
            Couleur_Brosse:= OldBrushColor;
          StyleLigne   := OldPenStyle;
          Canvas.Brush.Bitmap:= OldBitmap;
          end;
   end;
begin
     if TrameSolide_
     then
         Motif:= fBitmaps.bBrosse_Vertical_50
     else
         Motif:= fBitmaps.bBrosse_Solide;

     W:= R.Right-R.Left;
     X1_3:= R.Left+MulDiv(W,1,3);
     X2_3:= R.Left+MulDiv(W,2,3);

     YC := (R.Top+R.Bottom) div 2;
     Bas:= R.Bottom;

     Bloc( R.Left, X1_3);
     Bloc( X2_3, R.Right);
end;
{$ELSE}
begin
end;
{$IFEND}

procedure TBatpro_Serie.{svg}DrawDemiLigne_Points( DrawInfo: TDrawInfo;
                                                 R: TRect; TrameSolide_: Boolean);
{$IF DEFINED(MSWINDOWS) AND NOT DEFINED(FPC)}
var
   W, X1_3, X2_3, YC: Integer;
   Bas: Integer;
   procedure Bloc( _Debut, _Fin: Integer);
   var
      Polygone: array of TPoint;
      OldBrushColor: TColor;
      OldPenStyle: TPenStyle;
   begin
        SetLength( Polygone, 4);
        Polygone[0]:= Point( _Debut, YC);
        Polygone[1]:= Point( _Fin  , YC);
        Polygone[2]:= Point( _Fin  , Bas);
        Polygone[3]:= Point( _Debut, Bas);

        with DrawInfo
        do
          begin
          OldPenStyle:= StyleLigne;
          StyleLigne   := psClear;
            OldBrushColor:= Couleur_Brosse;
            Couleur_Brosse:= Couleur;
              Polygon( Polygone);
            Couleur_Brosse:= OldBrushColor;
          StyleLigne   := OldPenStyle;
          end;
   end;
begin
     W:= R.Right-R.Left;
     X1_3:= R.Left+MulDiv(W,1,3);
     X2_3:= R.Left+MulDiv(W,2,3);

     YC := (R.Top+R.Bottom) div 2;
     Bas:= R.Bottom;

     Bloc( R.Left, X1_3);
     Bloc( X2_3, R.Right);
end;
{$ELSE}
begin
end;
{$IFEND}

procedure TBatpro_Serie.Ligne_Serie   ( DrawInfo: TDrawInfo;nJour:Integer);
{$IF DEFINED(MSWINDOWS) AND NOT DEFINED(FPC)}
var
   XC, YC: Integer;
   OldColor: TColor;

   R: TRect;
begin
     Dessinne_Fond( DrawInfo);
     Affiche_nJour( DrawInfo, nJour);

     with DrawInfo
     do
       begin
       OldColor:= CouleurLigne;
       CouleurLigne:= Couleur;

       if VerticalHorizontal_( Contexte)
       then
           begin
           XC:= (Rect.Left+Rect.Right) div 2;
           Moveto( XC, Rect.Top   );
           LineTo( XC, Rect.Bottom);
           end
       else
           begin
           case Style
           of
             ss_TraitFin:
               begin
               YC:= (Rect.Top+Rect.Bottom) div 2;
               Moveto( Rect.Left , YC);
               LineTo( Rect.Right, YC);
               end;
             ss_TraitEpais:
               begin
               R:= Rect;
               InflateRect( R, 0, -3);
               DrawTraitHorizontal( DrawInfo, R, False);
               end;
             ss_DemiLigne:
               begin
               R:= Rect;
               InflateRect( R, 0, -3);
               DrawDemiLigne( DrawInfo, R, False);
               end;
             ss_DemiLigne_Pointille:
               begin
               R:= Rect;
               InflateRect( R, 0, -3);
               DrawDemiLigne_Pointille( DrawInfo, R, False);
               end;
             ss_DemiLigne_Points:
               begin
               R:= Rect;
               InflateRect( R, 0, -3);
               DrawDemiLigne_Points( DrawInfo, R, False);
               end;
             end;
           end;

       CouleurLigne:= OldColor;
       end;
end;
{$ELSE}
begin
end;
{$IFEND}

procedure TBatpro_Serie.svgLigne_Serie( _DrawInfo: TDrawInfo; nJour: Integer);
{$IF DEFINED(MSWINDOWS) AND NOT DEFINED(FPC)}
var
   XC, YC: Integer;

   R: TRect;
begin
     {svg}Dessinne_Fond( _DrawInfo);
     svgAffiche_nJour( _DrawInfo, nJour);

     with _DrawInfo
     do
       begin
       if VerticalHorizontal_( Contexte)
       then
           begin
           XC:= (Rect.Left+Rect.Right) div 2;
           _DrawInfo.line( XC, Rect.Top, XC, Rect.Bottom, Couleur, 0);
           end
       else
           begin
           case Style
           of
             ss_TraitFin:
               begin
               YC:= (Rect.Top+Rect.Bottom) div 2;
               _DrawInfo.line( Rect.Left , YC, Rect.Right, YC, Couleur, 0);
               end;
             ss_TraitEpais:
               begin
               R:= Rect;
               InflateRect( R, 0, -3);
               {svg}DrawTraitHorizontal( _DrawInfo, R, False);
               end;
             ss_DemiLigne:
               begin
               R:= Rect;
               InflateRect( R, 0, -3);
               {svg}DrawDemiLigne( _DrawInfo, R, False);
               end;
             ss_DemiLigne_Pointille:
               begin
               R:= Rect;
               InflateRect( R, 0, -3);
               {svg}DrawDemiLigne_Pointille( _DrawInfo, R, False);
               end;
             ss_DemiLigne_Points:
               begin
               R:= Rect;
               InflateRect( R, 0, -3);
               {svg}DrawDemiLigne_Points( _DrawInfo, R, False);
               end;
             end;
           end;
       end;
end;
{$ELSE}
begin
end;
{$IFEND}

procedure TBatpro_Serie.Ligne_VisibleDebut( DrawInfo: TDrawInfo; nJour: Integer);
{$IF DEFINED(MSWINDOWS) AND NOT DEFINED(FPC)}
var
   XC, YC: Integer;
   W2: Integer;//Width  div 2
   H2: Integer;//Height div 2
   OldColor: TColor;

   R, Rdot, Rsolid: TRect;
begin
     Dessinne_Fond( DrawInfo);
     Affiche_nJour( DrawInfo, nJour);
     with DrawInfo
     do
       begin
       OldColor:= CouleurLigne;
       CouleurLigne:= Couleur;
       if VerticalHorizontal_( Contexte)
       then
           begin
           XC:= (Rect.Left+Rect.Right ) div 2;
           H2:= (Rect.Bottom-Rect.Top ) div 2;
           StyleLigne:= psDot;
           Moveto( XC, Rect.Top      );
           LineTo( XC, Rect.Top   +H2);
           StyleLigne:= psSolid;
           Moveto( XC, Rect.Top   +H2);
           LineTo( XC, Rect.Bottom   );
           end
       else
           begin
           case Style
           of
             ss_TraitFin:
               begin
               YC:= (Rect.Top +Rect.Bottom) div 2;
               W2:= (Rect.Right -Rect.Left) div 2;
               StyleLigne:= psDot;
               Moveto( Rect.Left   , YC);
               LineTo( Rect.Left+W2, YC);
               StyleLigne:= psSolid;
               Moveto( Rect.Left+W2, YC);
               LineTo( Rect.Right  , YC);
               end;
             ss_TraitEpais:
               begin
               R:= Rect;
               InflateRect( R, 0, -3);
               W2:= (R.Right -R.Left) div 2;
               Rdot:= R; with Rdot do Right:= Left+W2;
               DrawTraitHorizontal( DrawInfo, Rdot, True);

               Rsolid:= R; with Rsolid do Left:= Left+W2;
               DrawTraitHorizontal( DrawInfo, Rsolid, False);
               end;
             ss_DemiLigne:
               begin
               R:= Rect;
               InflateRect( R, 0, -3);
               W2:= (R.Right -R.Left) div 2;
               Rdot:= R; with Rdot do Right:= Left+W2;
               DrawDemiLigne( DrawInfo, Rdot, True);

               Rsolid:= R; with Rsolid do Left:= Left+W2;
               DrawDemiLigne( DrawInfo, Rsolid, False);
               end;
             ss_DemiLigne_Pointille:
               begin
               R:= Rect;
               InflateRect( R, 0, -3);
               W2:= (R.Right -R.Left) div 2;
               Rdot:= R; with Rdot do Right:= Left+W2;
               DrawDemiLigne_Pointille( DrawInfo, Rdot, True);

               Rsolid:= R; with Rsolid do Left:= Left+W2;
               DrawDemiLigne_Pointille( DrawInfo, Rsolid, False);
               end;
             ss_DemiLigne_Points:
               begin
               R:= Rect;
               InflateRect( R, 0, -3);
               W2:= (R.Right -R.Left) div 2;
               Rdot:= R; with Rdot do Right:= Left+W2;
               DrawDemiLigne_Points( DrawInfo, Rdot, True);

               Rsolid:= R; with Rsolid do Left:= Left+W2;
               DrawDemiLigne_Points( DrawInfo, Rsolid, False);
               end;
             end;
           end;
       CouleurLigne:= OldColor;
       end;
end;
{$ELSE}
begin
end;
{$IFEND}

procedure TBatpro_Serie.svgLigne_VisibleDebut( _DrawInfo: TDrawInfo; nJour: Integer);
{$IF DEFINED(MSWINDOWS) AND NOT DEFINED(FPC)}
var
   XC, YC: Integer;
   W2: Integer;//Width  div 2
   H2: Integer;//Height div 2
   OldColor: TColor;

   R, Rdot, Rsolid: TRect;
begin
     {svg}Dessinne_Fond( _DrawInfo);
     svgAffiche_nJour( _DrawInfo, nJour);
     with _DrawInfo
     do
       begin
       OldColor:= CouleurLigne;
       CouleurLigne:= Couleur;
       if VerticalHorizontal_( Contexte)
       then
           begin
           XC:= (Rect.Left+Rect.Right ) div 2;
           H2:= (Rect.Bottom-Rect.Top ) div 2;
           _DrawInfo.line_dash( XC, Rect.Top   , XC, Rect.Top   +H2, Couleur, 1);
           _DrawInfo.line     ( XC, Rect.Top+H2, XC, Rect.Bottom   , Couleur, 1);
           end
       else
           begin
           case Style
           of
             ss_TraitFin:
               begin
               YC:= (Rect.Top +Rect.Bottom) div 2;
               W2:= (Rect.Right -Rect.Left) div 2;
               _DrawInfo.line_dash( Rect.Left   , YC, Rect.Left+W2, YC, Couleur, 1);
               _DrawInfo.line     ( Rect.Left+W2, YC, Rect.Right  , YC, Couleur, 1);
               end;
             ss_TraitEpais:
               begin
               R:= Rect;
               InflateRect( R, 0, -3);
               W2:= (R.Right -R.Left) div 2;
               Rdot:= R; with Rdot do Right:= Left+W2;
               {svg}DrawTraitHorizontal( _DrawInfo, Rdot, True);

               Rsolid:= R; with Rsolid do Left:= Left+W2;
               {svg}DrawTraitHorizontal( _DrawInfo, Rsolid, False);
               end;
             ss_DemiLigne:
               begin
               R:= Rect;
               InflateRect( R, 0, -3);
               W2:= (R.Right -R.Left) div 2;
               Rdot:= R; with Rdot do Right:= Left+W2;
               {svg}DrawDemiLigne( _DrawInfo, Rdot, True);

               Rsolid:= R; with Rsolid do Left:= Left+W2;
               {svg}DrawDemiLigne( _DrawInfo, Rsolid, False);
               end;
             ss_DemiLigne_Pointille:
               begin
               R:= Rect;
               InflateRect( R, 0, -3);
               W2:= (R.Right -R.Left) div 2;
               Rdot:= R; with Rdot do Right:= Left+W2;
               {svg}DrawDemiLigne_Pointille( _DrawInfo, Rdot, True);

               Rsolid:= R; with Rsolid do Left:= Left+W2;
               {svg}DrawDemiLigne_Pointille( _DrawInfo, Rsolid, False);
               end;
             ss_DemiLigne_Points:
               begin
               R:= Rect;
               InflateRect( R, 0, -3);
               W2:= (R.Right -R.Left) div 2;
               Rdot:= R; with Rdot do Right:= Left+W2;
               {svg}DrawDemiLigne_Points( _DrawInfo, Rdot, True);

               Rsolid:= R; with Rsolid do Left:= Left+W2;
               {svg}DrawDemiLigne_Points( _DrawInfo, Rsolid, False);
               end;
             end;
           end;
       CouleurLigne:= OldColor;
       end;
end;
{$ELSE}
begin
end;
{$IFEND}

procedure TBatpro_Serie.Ligne_DebutSerie( DrawInfo: TDrawInfo; nJour:Integer);
{$IF DEFINED(MSWINDOWS) AND NOT DEFINED(FPC)}
var
   XC, YC: Integer;
   W4: Integer;//Width  div 4
   H4: Integer;//Height div 4
   OldColor: TColor;
   R: TRect;
begin
     Dessinne_Fond( DrawInfo);
     Affiche_nJour( DrawInfo, nJour);

     with DrawInfo
     do
       begin
       OldColor:= CouleurLigne;
       CouleurLigne:= Couleur;
       W4:= (Rect.Right -Rect.Left) div 4;
       H4:= (Rect.Bottom-Rect.Top ) div 4;
       if VerticalHorizontal_( Contexte)
       then
           begin
           XC:= (Rect.Left+Rect.Right ) div 2;
           Moveto( XC           , Rect.Top    +H4);
           LineTo( XC           , Rect.Bottom    );

           Moveto( Rect.Left +W4, Rect.Top+H4);
           LineTo( Rect.Right-W4, Rect.Top+H4);
           CouleurLigne:= OldColor;
           end
       else
           begin
           case Style
           of
             ss_TraitFin:
               begin
               YC:= (Rect.Top +Rect.Bottom) div 2;
               // -
               Moveto( Rect.Left +W4  , YC);
               LineTo( Rect.Right     , YC);
               // |
               Moveto( Rect.Left +W4, Rect.Top   +H4);
               LineTo( Rect.Left +W4, Rect.Bottom-H4);
               end;
             ss_TraitEpais:
               be.DrawJalon( DrawInfo, tj_Jalon_Trait_Epais_Debut, Couleur, Couleur);
             ss_DemiLigne:
               begin
               R:= Rect;
               InflateRect( R, 0, -3);
               DrawDemiLigne( DrawInfo, R, False);
               end;
             ss_DemiLigne_Pointille:
               begin
               R:= Rect;
               InflateRect( R, 0, -3);
               DrawDemiLigne_Pointille( DrawInfo, R, False);
               end;
             ss_DemiLigne_Points:
               begin
               R:= Rect;
               InflateRect( R, 0, -3);
               DrawDemiLigne_Points( DrawInfo, R, False);
               end;
             end;
           end;
       end;
end;
{$ELSE}
begin
end;
{$IFEND}


procedure TBatpro_Serie.svgLigne_DebutSerie( _DrawInfo: TDrawInfo; nJour: Integer);
{$IF DEFINED(MSWINDOWS) AND NOT DEFINED(FPC)}
var
   XC, YC: Integer;
   W4: Integer;//Width  div 4
   H4: Integer;//Height div 4
   //OldColor: TColor;
   R: TRect;
begin
     {svg}Dessinne_Fond( _DrawInfo);
     svgAffiche_nJour( _DrawInfo, nJour);

     with _DrawInfo
     do
       begin
       //OldColor:= CouleurLigne;
       CouleurLigne:= Couleur;
       W4:= (Rect.Right -Rect.Left) div 4;
       H4:= (Rect.Bottom-Rect.Top ) div 4;
       if VerticalHorizontal_( Contexte)
       then
           begin
           XC:= (Rect.Left+Rect.Right ) div 2;
           _DrawInfo.line( XC           , Rect.Top+H4,XC           , Rect.Bottom, Couleur, 1);
           _DrawInfo.line( Rect.Left +W4, Rect.Top+H4,Rect.Right-W4, Rect.Top+H4, Couleur, 1);
           end
       else
           begin
           case Style
           of
             ss_TraitFin:
               begin
               YC:= (Rect.Top +Rect.Bottom) div 2;
               // -
               _DrawInfo.line( Rect.Left +W4, YC            , Rect.Right   , YC            , Couleur, 1);
               // |
               _DrawInfo.line( Rect.Left +W4, Rect.Top   +H4, Rect.Left +W4, Rect.Bottom-H4, Couleur, 1);
               end;
             ss_TraitEpais:
               be.{svg}DrawJalon( _DrawInfo, tj_Jalon_Trait_Epais_Debut, Couleur, Couleur);
             ss_DemiLigne:
               begin
               R:= Rect;
               InflateRect( R, 0, -3);
               {svg}DrawDemiLigne( _DrawInfo, R, False);
               end;
             ss_DemiLigne_Pointille:
               begin
               R:= Rect;
               InflateRect( R, 0, -3);
               {svg}DrawDemiLigne_Pointille( _DrawInfo, R, False);
               end;
             ss_DemiLigne_Points:
               begin
               R:= Rect;
               InflateRect( R, 0, -3);
               {svg}DrawDemiLigne_Points( _DrawInfo, R, False);
               end;
             end;
           end;
       end;
end;
{$ELSE}
begin
end;
{$IFEND}

procedure TBatpro_Serie.Ligne_FinSerie( DrawInfo: TDrawInfo; nJour:Integer);
{$IF DEFINED(MSWINDOWS) AND NOT DEFINED(FPC)}
var
   XC, YC: Integer;
   W4: Integer;//Width  div 4
   H4: Integer;//Height div 4
   OldColor: TColor;
   R: TRect;
begin
     Dessinne_Fond( DrawInfo);
     Affiche_nJour( DrawInfo, nJour);

     with DrawInfo
     do
       begin
       OldColor:= CouleurLigne;
       CouleurLigne:= Couleur;
       W4:= (Rect.Right -Rect.Left) div 4;
       H4:= (Rect.Bottom-Rect.Top ) div 4;
       if VerticalHorizontal_( Contexte)
       then
           begin
           XC:= (Rect.Left+Rect.Right ) div 2;
           Moveto( XC           , Rect.Top      );
           LineTo( XC           , Rect.Bottom-H4);
           Moveto( Rect.Left +W4, Rect.Bottom-H4);
           LineTo( Rect.Right-W4, Rect.Bottom-H4);
           CouleurLigne:= OldColor;
           end
       else
           begin
           case Style
           of
             ss_TraitFin:
               begin
               YC:= (Rect.Top +Rect.Bottom) div 2;
               // -
               Moveto( Rect.Left    , YC);
               LineTo( Rect.Right-W4, YC);
               // |
               //Moveto( Rect.Right-W4, Rect.Top   +H4);
               //LineTo( Rect.Right-W4, Rect.Bottom-H4);
               // \
               Moveto( Rect.Right-  W4, YC   );
               LineTo( Rect.Right-2*W4, YC-H4);
               // /
               Moveto( Rect.Right-  W4, YC   );
               LineTo( Rect.Right-2*W4, YC+H4);
               end;
             ss_TraitEpais:
               be.DrawJalon( DrawInfo, tj_Jalon_Trait_Epais_Fin, Couleur, Couleur);
             ss_DemiLigne:
               begin
               R:= Rect;
               InflateRect( R, 0, -3);
               DrawDemiLigne( DrawInfo, R, False);
               end;
             ss_DemiLigne_Pointille:
               begin
               R:= Rect;
               InflateRect( R, 0, -3);
               DrawDemiLigne_Pointille( DrawInfo, R, False);
               end;
             ss_DemiLigne_Points:
               begin
               R:= Rect;
               InflateRect( R, 0, -3);
               DrawDemiLigne_Points( DrawInfo, R, False);
               end;
             end;
           end;
       end;
end;
{$ELSE}
begin
end;
{$IFEND}

procedure TBatpro_Serie.svgLigne_FinSerie(_DrawInfo: TDrawInfo; nJour: Integer);
{$IF DEFINED(MSWINDOWS) AND NOT DEFINED(FPC)}
var
   XC, YC: Integer;
   W4: Integer;//Width  div 4
   H4: Integer;//Height div 4
   //OldColor: TColor;
   R: TRect;
begin
     {svg}Dessinne_Fond( _DrawInfo);
     svgAffiche_nJour( _DrawInfo, nJour);

     with _DrawInfo
     do
       begin
       //OldColor:= CouleurLigne;
       CouleurLigne:= Couleur;
       W4:= (Rect.Right -Rect.Left) div 4;
       H4:= (Rect.Bottom-Rect.Top ) div 4;
       if VerticalHorizontal_( Contexte)
       then
           begin
           XC:= (Rect.Left+Rect.Right ) div 2;
           _DrawInfo.line( XC           , Rect.Top      , XC           , Rect.Bottom-H4, Couleur, 1);
           _DrawInfo.line( Rect.Left +W4, Rect.Bottom-H4, Rect.Right-W4, Rect.Bottom-H4, Couleur, 1);
           end
       else
           begin
           case Style
           of
             ss_TraitFin:
               begin
               YC:= (Rect.Top +Rect.Bottom) div 2;
               // -
               _DrawInfo.line( Rect.Left    , YC, Rect.Right-W4, YC, Couleur, 1);
               // |
               //Moveto( Rect.Right-W4, Rect.Top   +H4);
               //LineTo( Rect.Right-W4, Rect.Bottom-H4);
               // \
               _DrawInfo.line( Rect.Right-  W4, YC   , Rect.Right-2*W4, YC-H4, Couleur, 1);
               // /
               _DrawInfo.line( Rect.Right-  W4, YC   , Rect.Right-2*W4, YC+H4, Couleur, 1);
               end;
             ss_TraitEpais:
               be.{svg}DrawJalon( _DrawInfo, tj_Jalon_Trait_Epais_Fin, Couleur, Couleur);
             ss_DemiLigne:
               begin
               R:= Rect;
               InflateRect( R, 0, -3);
               {svg}DrawDemiLigne( _DrawInfo, R, False);
               end;
             ss_DemiLigne_Pointille:
               begin
               R:= Rect;
               InflateRect( R, 0, -3);
               {svg}DrawDemiLigne_Pointille( _DrawInfo, R, False);
               end;
             ss_DemiLigne_Points:
               begin
               R:= Rect;
               InflateRect( R, 0, -3);
               {svg}DrawDemiLigne_Points( _DrawInfo, R, False);
               end;
             end;
           end;
       end;
end;
{$ELSE}
begin
end;
{$IFEND}

procedure TBatpro_Serie.Ligne_VisibleFin( DrawInfo: TDrawInfo; nJour:Integer);
{$IF DEFINED(MSWINDOWS) AND NOT DEFINED(FPC)}
var
   XC, YC: Integer;
   W2: Integer;//Width  div 2
   H2: Integer;//Height div 2
   OldColor: TColor;

   R, Rdot, Rsolid: TRect;
begin
     Dessinne_Fond( DrawInfo);
     Affiche_nJour( DrawInfo, nJour);

     with DrawInfo
     do
       begin
       OldColor:= CouleurLigne;
       CouleurLigne:= Couleur;
       StyleLigne:= psSolid;
       if VerticalHorizontal_( Contexte)
       then
           begin
           XC:= (Rect.Left+Rect.Right ) div 2;
           H2:= (Rect.Bottom-Rect.Top ) div 2;
           Moveto( XC, Rect.Top      );
           LineTo( XC, Rect.Top   +H2);
           StyleLigne:= psDot;
           Moveto( XC, Rect.Top   +H2);
           LineTo( XC, Rect.Bottom   );
           end
       else
           begin
           case Style
           of
             ss_TraitFin:
               begin
               YC:= (Rect.Top +Rect.Bottom) div 2;
               W2:= (Rect.Right -Rect.Left) div 2;
               Moveto( Rect.Left   , YC);
               LineTo( Rect.Left+W2, YC);
               StyleLigne:= psDot;
               Moveto( Rect.Left+W2, YC);
               LineTo( Rect.Right  , YC);
               end;
             ss_TraitEpais:
               begin
               R:= Rect;
               InflateRect( R, 0, -3);
               W2:= (R.Right -R.Left) div 2;
               Rsolid:= R; with Rsolid do Right:= Left+W2;
               DrawTraitHorizontal( DrawInfo, Rsolid, False);

               Rdot:= R; with Rdot do Left:= Left+W2;
               DrawTraitHorizontal( DrawInfo, Rdot, True);
               end;
             ss_DemiLigne:
               begin
               R:= Rect;
               InflateRect( R, 0, -3);
               W2:= (R.Right -R.Left) div 2;
               Rsolid:= R; with Rsolid do Right:= Left+W2;
               DrawDemiLigne( DrawInfo, Rsolid, False);

               Rdot:= R; with Rdot do Left:= Left+W2;
               DrawDemiLigne( DrawInfo, Rdot, True);
               end;
             ss_DemiLigne_Pointille:
               begin
               R:= Rect;
               InflateRect( R, 0, -3);
               W2:= (R.Right -R.Left) div 2;
               Rsolid:= R; with Rsolid do Right:= Left+W2;
               DrawDemiLigne_Pointille( DrawInfo, Rsolid, False);

               Rdot:= R; with Rdot do Left:= Left+W2;
               DrawDemiLigne_Pointille( DrawInfo, Rdot, True);
               end;
             ss_DemiLigne_Points:
               begin
               R:= Rect;
               InflateRect( R, 0, -3);
               W2:= (R.Right -R.Left) div 2;
               Rsolid:= R; with Rsolid do Right:= Left+W2;
               DrawDemiLigne_Points( DrawInfo, Rsolid, False);

               Rdot:= R; with Rdot do Left:= Left+W2;
               DrawDemiLigne_Points( DrawInfo, Rdot, True);
               end;
             end;
           end;
       StyleLigne:= psSolid;
       CouleurLigne:= OldColor;
       end;
end;
{$ELSE}
begin
end;
{$IFEND}

procedure TBatpro_Serie.svgLigne_VisibleFin( _DrawInfo: TDrawInfo; nJour: Integer);
{$IF DEFINED(MSWINDOWS) AND NOT DEFINED(FPC)}
var
   XC, YC: Integer;
   W2: Integer;//Width  div 2
   H2: Integer;//Height div 2
   OldColor: TColor;

   R, Rdot, Rsolid: TRect;
begin
     {svg}Dessinne_Fond( _DrawInfo);
     svgAffiche_nJour( _DrawInfo, nJour);

     with _DrawInfo
     do
       begin
       OldColor:= CouleurLigne;
       CouleurLigne:= Couleur;
       StyleLigne:= psSolid;
       if VerticalHorizontal_( Contexte)
       then
           begin
           XC:= (Rect.Left+Rect.Right ) div 2;
           H2:= (Rect.Bottom-Rect.Top ) div 2;
           _DrawInfo.line     ( XC, Rect.Top      ,XC, Rect.Top   +H2, Couleur, 1);
           _DrawInfo.line_dash( XC, Rect.Top   +H2,XC, Rect.Bottom   , Couleur, 1);
           end
       else
           begin
           case Style
           of
             ss_TraitFin:
               begin
               YC:= (Rect.Top +Rect.Bottom) div 2;
               W2:= (Rect.Right -Rect.Left) div 2;
               _DrawInfo.line     ( Rect.Left   , YC, Rect.Left+W2, YC, Couleur, 1);
               _DrawInfo.line_dash( Rect.Left+W2, YC, Rect.Right  , YC, Couleur, 1);
               end;
             ss_TraitEpais:
               begin
               R:= Rect;
               InflateRect( R, 0, -3);
               W2:= (R.Right -R.Left) div 2;
               Rsolid:= R; with Rsolid do Right:= Left+W2;
               {svg}DrawTraitHorizontal( _DrawInfo, Rsolid, False);

               Rdot:= R; with Rdot do Left:= Left+W2;
               {svg}DrawTraitHorizontal( _DrawInfo, Rdot, True);
               end;
             ss_DemiLigne:
               begin
               R:= Rect;
               InflateRect( R, 0, -3);
               W2:= (R.Right -R.Left) div 2;
               Rsolid:= R; with Rsolid do Right:= Left+W2;
               {svg}DrawDemiLigne( _DrawInfo, Rsolid, False);

               Rdot:= R; with Rdot do Left:= Left+W2;
               {svg}DrawDemiLigne( _DrawInfo, Rdot, True);
               end;
             ss_DemiLigne_Pointille:
               begin
               R:= Rect;
               InflateRect( R, 0, -3);
               W2:= (R.Right -R.Left) div 2;
               Rsolid:= R; with Rsolid do Right:= Left+W2;
               {svg}DrawDemiLigne_Pointille( _DrawInfo, Rsolid, False);

               Rdot:= R; with Rdot do Left:= Left+W2;
               {svg}DrawDemiLigne_Pointille( _DrawInfo, Rdot, True);
               end;
             ss_DemiLigne_Points:
               begin
               R:= Rect;
               InflateRect( R, 0, -3);
               W2:= (R.Right -R.Left) div 2;
               Rsolid:= R; with Rsolid do Right:= Left+W2;
               {svg}DrawDemiLigne_Points( _DrawInfo, Rsolid, False);

               Rdot:= R; with Rdot do Left:= Left+W2;
               {svg}DrawDemiLigne_Points( _DrawInfo, Rdot, True);
               end;
             end;
           end;
       StyleLigne:= psSolid;
       CouleurLigne:= OldColor;
       end;
end;
{$ELSE}
begin
end;
{$IFEND}

{ TBatpro_Element }

procedure TBatpro_Element.Unlink( be: TBatpro_Element);
begin
     // rien à faire à ce niveau
end;

procedure TBatpro_Element.Supprime_Connection(be: TBatpro_Element);
begin
     // rien à faire à ce niveau
end;

function TBatpro_Element.sEtatCluster: String;
begin
     if Assigned( Cluster)
     then
         Result:= Cluster.sEtat
     else
         Result:= 'Pas de cluster pour cet élément';
end;

function TBatpro_Element.Edite: Boolean;
var
   Editeur: IBatpro_Element_Editeur;
begin
     Editeur:= ClassParams.Editeur;
     Result:= Assigned( Editeur);
     if not Result then exit;

     Result:= Editeur.Edite( Self);

end;

function TBatpro_Element.Egale( be: TBatpro_Element): Boolean;
begin
     Result:= Self = be; //ici juste une comparaison de pointeurs
end;                     //on peut le raffiner dans les classes dérivées

function TBatpro_Element.Cree_Fonte( DrawInfo: TDrawInfo; Gras: Boolean): TFont;
begin
     {$IF DEFINED(MSWINDOWS) AND NOT DEFINED(FPC)}
     Result:= TFont.Create;
     Result.Assign( ClassFont( DrawInfo));
     if Gras
     then
         Result.Style:= Result.Style + [fsBold]
     else
         Result.Style:= Result.Style - [fsBold];
     {$ELSE}
     {$IFEND}
end;

function TBatpro_Element.GetAggregeurs: TBatpro_StringList;
begin
     if FAggregeurs = nil
     then
         FAggregeurs:= TBatpro_StringList.Create;

     Result:= FAggregeurs;
end;

function TBatpro_Element.GetConnecteurs: TslBatpro_Element;
begin
     if FConnecteurs = nil
     then
         FConnecteurs:= TslBatpro_Element.Create( ClassName+'.FConnecteurs');

     Result:= FConnecteurs;
end;

function TBatpro_Element.GetConnectes: TslBatpro_Element;
begin
     if FConnectes = nil
     then
         FConnectes:= TslBatpro_Element.Create( ClassName+'.FConnectes');

     Result:= FConnectes;
end;

procedure TBatpro_Element.Connecteurs_Ajoute( _be: TBatpro_Element; _Nom: String= '');
begin
     if _be = nil then exit;
     if -1 <> Connecteurs.IndexOfObject( _be) then exit;

     Self.Connecteurs.AddObject( _Nom, _be );
     _be .Connectes  .AddObject( _Nom, Self);
end;

procedure TBatpro_Element.Connecteurs_Enleve( _be: TBatpro_Element);
begin
     if _be = nil then exit;

     Self.Connecteurs.Remove( _be );
     _be .Connectes  .Remove( Self);
end;

procedure TBatpro_Element.Connect_To(_be: TBatpro_Element; _Nom: String= '');
begin
     if _be = nil then exit;
     _be.Connecteurs_Ajoute( Self, _Nom);
end;

procedure TBatpro_Element.Unconnect_To( var _be; _Contexte: String= '');
var
   Batpro_Element: TBatpro_Element;
begin
     if TObject( _be) = nil then exit;
     if Affecte_( Batpro_Element, TBatpro_Element, TObject(_be))
     then
         begin
         fAccueil_Log(  'TBatpro_Element.Unconnect_To: '
                       +'paramètre _be invalide; Classname: '+ClassName+' '
                       +_Contexte);
         exit;
         end;
     try
        try
           Batpro_Element.Connecteurs_Enleve( Self);
        except
              on E: Exception
              do
                begin
                fAccueil_Log(  'TBatpro_Element.Unconnect_To: '
                              +'paramètre _be invalide; Classname: '+ClassName+' '+_Contexte);
                end;
              end;
     finally
            TObject( _be):= nil;
            end;
end;

function TBatpro_Element.GetTraits: TTraits;
begin
     if FTraits = nil
     then
         FTraits:= TTraits.Create;
     Result:= FTraits;
end;

procedure TBatpro_Element.BECP_Edit_ContexteFont(Contexte: Integer);begin end;

function TBatpro_Element.BECP_GetContexteFont(Contexte: Integer): TFont;
begin
     Result:= nil;
end;

function TBatpro_Element.BECP_GetEditeur: IBatpro_Element_Editeur;
begin
     Result:= nil;
end;

function TBatpro_Element.BECP_GetFont: TFont;
begin
     Result:= nil;
end;

function TBatpro_Element.BECP_GetLibelle: String;
begin
     Result:= '';
end;

function TBatpro_Element.BECP_GetNomClasse: String;
begin
     Result:= '';
end;

function TBatpro_Element.BECP_GetSauver: Boolean;
begin
     Result:= False;
end;

procedure TBatpro_Element.BECP_Save_to_database; begin end;

procedure TBatpro_Element.BECP_SetEditeur(Value: IBatpro_Element_Editeur);
begin
end;

procedure TBatpro_Element.BECP_SetLibelle(Value: String); begin end;

procedure TBatpro_Element.BECP_SetNomClasse(Value: String); begin end;

procedure TBatpro_Element.BECP_SetSauver(Value: Boolean); begin end;

function TBatpro_Element.GetAggregations: TAggregations;
begin
     if FAggregations = nil
     then
         FAggregations:= TAggregations.Create( Self, Create_Aggregation);

     Result:= FAggregations;
end;

procedure TBatpro_Element.Create_Aggregation( Name: String; P: ThAggregation_Create_Params);
begin
     P.Faible( nil, nil, nil);
end;

procedure TBatpro_Element.Get_Aggregation( var Resultat; var Fha; Name: String;
                                           Classe_Aggregation: ThAggregation_class= nil);
begin
     //Création éventuelle
     if ThAggregation( Fha) = nil
     then
         begin
         ThAggregation( Fha):= Aggregations[Name];

         //contrôle de la classe de l'instance obtenue
         if     Assigned( ThAggregation( Fha))
            and Assigned( Classe_Aggregation)
         then
             if not ( ThAggregation( Fha) is Classe_Aggregation)
             then
                 ThAggregation( Fha):= nil;
         end;

     //Affectation au résultat
     ThAggregation( Resultat):= ThAggregation( Fha);
end;

function TBatpro_Element.Listing_Champs(Separateur: String): String;
begin
     Result:= 'Self: '+ClassName+' = $'+IntToHex( Integer( Pointer( Self)), 8);
end;

function TBatpro_Element.Listing( Indentation: String): String;
begin
     Result:= Aggregations.Listing( Indentation+'   ');
end;

procedure TBatpro_Element.Verifie_coherence( var _log: String);
begin
end;

{ TBatpro_Cluster }

constructor TBatpro_Cluster.Create( _be: TBatpro_Element);
begin
     inherited Create;
     be:= _be;
     Initialise;
end;

procedure TBatpro_Cluster.Initialise;
begin
     EtatInitial:= True;
     SetLength( Grains, 0, 0);
     Largeur:= 0;
     Hauteur:= 0;
     Colonne_LargeurMaxi:= 0;
     Ligne_HauteurMaxi  := 0;
end;

procedure TBatpro_Cluster.Ajoute( _Grain: TBatpro_Element; _Colonne, _Ligne: Integer);
var
   I, J: Integer;
   Largeur_Hauteur_Change: Boolean;
begin
     if EtatInitial
     then
         begin
         Bounds:= Rect( _Colonne, _Ligne, _Colonne, _Ligne);
         EtatInitial:= False;
         end
     else
         begin
              if _Colonne < Bounds.Left              then Bounds.Left  := _Colonne
         else if            Bounds.Right  < _Colonne then Bounds.Right := _Colonne;
              if _Ligne   < Bounds.Top               then Bounds.Top   := _Ligne
         else if            Bounds.Bottom < _Ligne   then Bounds.Bottom:= _Ligne;
         end;

     //Remarque: les tableaux multidimensionnels delphi
     //           sont plutôt (ligne,colonne)
     //          mais ici on travaille en (colonne,ligne)
     I:= _Colonne - Bounds.Left;
     J:= _Ligne   - Bounds.Top;
     Largeur_Hauteur_Change:= False;
     if I >= Largeur then begin Largeur:= I +1;Largeur_Hauteur_Change:=True;end;
     if J >= Hauteur then begin Hauteur:= J +1;Largeur_Hauteur_Change:=True;end;
     if Largeur_Hauteur_Change
     then
         SetLength( Grains, Largeur, Hauteur);
     Grains[I,J]:= _Grain;
end;

function TBatpro_Cluster.Cherche( _Grain: TBatpro_Element): TPoint;
var
   I, J: Integer;
begin
     Result:= Point( -1, -1);
     for I:= Low(Grains) to High(Grains)
     do
       for J:= Low(Grains[I]) to High(Grains[I])
       do
         if Grains[I,J] = _Grain
         then
             Result:= Point( I, J);
end;

function TBatpro_Cluster.SingleRow: Boolean;
begin
     with Bounds
     do
       Result:= Top = Bottom;
end;

procedure TBatpro_Cluster.CalculeLargeur( _DrawInfo: TDrawInfo;
                                          _Colonne, _Ligne: Integer;
                                          var _Largeur: Integer);
var
   I,
   NbColonnesCluster,
   LargeurTotaleSG,
   LargeurTotaleDemandee,
   LargeurManquante,
   LargeurManquanteElement: Integer;
begin
     {$IF DEFINED(MSWINDOWS) AND NOT DEFINED(FPC)}
     LargeurTotaleSG:= 0;
     for I:= Bounds.Left to Bounds.Right
     do
       begin
       if I = _Colonne
       then
           Inc( LargeurTotaleSG, _Largeur)
       else
           Inc( LargeurTotaleSG, _DrawInfo.sg.ColWidths [I]);
       end;

     LargeurTotaleDemandee:= be.Cell_Width( _DrawInfo);

     LargeurManquante:= LargeurTotaleDemandee - LargeurTotaleSG;
     if LargeurManquante > 0
     then
         begin
         NbColonnesCluster:= Bounds.Right - _Colonne + 1;
         LargeurManquanteElement:= LargeurManquante div NbColonnesCluster;
         Inc( _Largeur, LargeurManquanteElement);
         end;
     if Colonne_LargeurMaxi <> 0
     then
         if Colonne_LargeurMaxi < _Largeur
         then
             _Largeur:= Colonne_LargeurMaxi;
     {$IFEND}
end;

procedure TBatpro_Cluster.CalculeHauteur( _DrawInfo: TDrawInfo;
                                          _Colonne, _Ligne: Integer;
                                          var _Hauteur: Integer);
var
   J,
   NbLignesCluster,
   HauteurTotaleSG,
   HauteurTotaleDemandee,
   HauteurManquante,
   HauteurManquanteElement: Integer;
begin
     {$IF DEFINED(MSWINDOWS) AND NOT DEFINED(FPC)}
     HauteurTotaleSG:= 0;
     for J:= Bounds.Top to Bounds.Bottom
     do
       begin
       if J = _Ligne
       then
           Inc( HauteurTotaleSG, _Hauteur)
       else
           Inc( HauteurTotaleSG, _DrawInfo.sg.RowHeights[J]);
       end;

     HauteurTotaleDemandee:= be.Cell_Height( _DrawInfo, _DrawInfo.sg.ColWidths[ _Colonne]);

     HauteurManquante:= HauteurTotaleDemandee - HauteurTotaleSG;
     if HauteurManquante > 0
     then
         begin
         NbLignesCluster:= Bounds.Bottom - _Ligne + 1;
         HauteurManquanteElement:= HauteurManquante div NbLignesCluster;
         Inc( _Hauteur, HauteurManquanteElement);
         end;
     if Ligne_HauteurMaxi <> 0
     then
         if Ligne_HauteurMaxi < _Hauteur
         then
             _Hauteur:= Ligne_HauteurMaxi;
     {$IFEND}
end;

procedure TBatpro_Cluster.Check_LargeurTotale(var _LargeurTotale: Integer);
var
   NbColonnesCluster: Integer;
begin
     if Colonne_LargeurMaxi = 0 then exit;

     NbColonnesCluster:= Bounds.Right - Bounds.Left;
     if NbColonnesCluster = 0 then exit;

     Largeur:= _LargeurTotale div NbColonnesCluster;
     if Colonne_LargeurMaxi < Largeur
     then
         begin
         Largeur:= Colonne_LargeurMaxi;
         _LargeurTotale:= Largeur * NbColonnesCluster;
         end;
end;

procedure TBatpro_Cluster.Check_HauteurTotale(var _HauteurTotale: Integer);
var
   NbLignesCluster: Integer;
begin
     if Ligne_HauteurMaxi = 0 then exit;

     NbLignesCluster:= Bounds.Bottom - Bounds.Top;
     if NbLignesCluster = 0 then exit;

     Hauteur:= _HauteurTotale div NbLignesCluster;
     if Ligne_HauteurMaxi < Hauteur
     then
         begin
         Hauteur:= Ligne_HauteurMaxi;
         _HauteurTotale:= Hauteur * NbLignesCluster;
         end;
end;

function TBatpro_Cluster.sEtat: String;
begin
     Result
     :=
        Format(  'Horizontalement de %d à %d'+sys_N
                +'Verticalement   de %d à %d'+sys_N
                +'Largeur: %d'+sys_N
                +'Hauteur: %d',
               [
               Bounds.Left, Bounds.Right ,
               Bounds.Top , Bounds.Bottom,
               Largeur    , Hauteur
               ]);
end;

{ TBatpro_ElementClassParams }

constructor TBatpro_ElementClassParams.Create(_be: TBatpro_element);
begin
     be:= _be;
end;

destructor TBatpro_ElementClassParams.Destroy;
begin

  inherited;
end;

function TBatpro_ElementClassParams.GetNomClasse: String;
begin
     Result:= be.BECP_GetNomClasse;
end;

function TBatpro_ElementClassParams.GetLibelle: String;
begin
     Result:= be.BECP_GetLibelle
end;

function TBatpro_ElementClassParams.GetContexteFont( Contexte: Integer): TFont;
begin
     Result:= be.BECP_GetContexteFont( Contexte);
end;

function TBatpro_ElementClassParams.GetFont: TFont;
begin
     Result:= be.BECP_GetFont;
end;

function TBatpro_ElementClassParams.GetSauver: Boolean;
begin
     Result:= be.BECP_GetSauver;
end;

function TBatpro_ElementClassParams.GetEditeur: IBatpro_Element_Editeur;
begin
     Result:= be.BECP_GetEditeur;
end;

procedure TBatpro_ElementClassParams.SetNomClasse(Value: String);
begin
     be.BECP_SetNomClasse( Value);
end;

procedure TBatpro_ElementClassParams.SetLibelle(Value: String);
begin
     be.BECP_SetLibelle( Value);
end;

procedure TBatpro_ElementClassParams.SetSauver(Value: Boolean);
begin
     be.BECP_SetSauver( Value);
end;

procedure TBatpro_ElementClassParams.SetEditeur( Value: IBatpro_Element_Editeur);
begin
     be.BECP_SetEditeur( Value);
end;

procedure TBatpro_ElementClassParams.Edit_ContexteFont(Contexte: Integer);
begin
     be.BECP_Edit_ContexteFont( Contexte);
end;

procedure TBatpro_ElementClassParams.Save_to_database;
begin
     be.BECP_Save_to_database;
end;

{ Tpool_Ancetre_Ancetre }

constructor Tpool_Ancetre_Ancetre.Create( _sl: TBatpro_StringList);
begin
     inherited Create( _sl);
end;

destructor Tpool_Ancetre_Ancetre.Destroy;
begin
     inherited Destroy;
end;

class function Tpool_Ancetre_Ancetre.Name: String;
begin
     Result:= ClassName;
end;

procedure Tpool_Ancetre_Ancetre.sCle_Change(_bl: TBatpro_element);
begin

end;

class function Tpool_Ancetre_Ancetre.class_sl: Tslpool_Ancetre_Ancetre;
begin
     if nil = Fclass_sl
     then
         Fclass_sl:= Tslpool_Ancetre_Ancetre.Create( ClassName+'.slInstances');
     Result:= Fclass_sl;
end;

class procedure Tpool_Ancetre_Ancetre.class_Create( var Reference; Classe: Tpool_Ancetre_Ancetre_Class);
var
   Nom: String;
begin
     //if Assigned(Chrono) then Chrono.Stop( 'Clean_Create , début');
     Tpool_Ancetre_Ancetre(Reference):= Classe.Create( class_sl);
     //Liste.Add( @Reference);
     Nom:= Tpool_Ancetre_Ancetre(Reference).Name;
     //Noms.Add( Nom);
     class_sl.AddObject( Nom, Tpool_Ancetre_Ancetre(Reference));
     //if Assigned(Chrono) then Chrono.Stop( 'Clean_Create ( '+Nom+')');
end;

class procedure Tpool_Ancetre_Ancetre.class_Destroy(var Reference);
begin
     Clean_Destroy( Reference);
end;

class procedure Tpool_Ancetre_Ancetre.class_Get( out Resultat; var Reference; Classe: Tpool_Ancetre_Ancetre_Class);
begin
     if not Assigned( Tpool_Ancetre_Ancetre( Reference))
     then
         class_Create( Reference, Classe);

     Tpool_Ancetre_Ancetre( Resultat):= Tpool_Ancetre_Ancetre( Reference);
end;

{ TIterateur_pool_Ancetre_Ancetre }

function TIterateur_pool_Ancetre_Ancetre.not_Suivant( var _Resultat: Tpool_Ancetre_Ancetre): Boolean;
begin
     Result:= not_Suivant_interne( _Resultat);
end;

procedure TIterateur_pool_Ancetre_Ancetre.Suivant( var _Resultat: Tpool_Ancetre_Ancetre);
begin
     Suivant_interne( _Resultat);
end;

{ Tslpool_Ancetre_Ancetre }

constructor Tslpool_Ancetre_Ancetre.Create( _Nom: String= '');
begin
     inherited CreateE( _Nom, Tpool_Ancetre_Ancetre);
end;

destructor Tslpool_Ancetre_Ancetre.Destroy;
begin
     inherited;
end;

class function Tslpool_Ancetre_Ancetre.Classe_Iterateur: TIterateur_Class;
begin
     Result:= TIterateur_pool_Ancetre_Ancetre;
end;

function Tslpool_Ancetre_Ancetre.Iterateur: TIterateur_pool_Ancetre_Ancetre;
begin
     Result:= TIterateur_pool_Ancetre_Ancetre( Iterateur_interne);
end;

function Tslpool_Ancetre_Ancetre.Iterateur_Decroissant: TIterateur_pool_Ancetre_Ancetre;
begin
     Result:= TIterateur_pool_Ancetre_Ancetre( Iterateur_interne_Decroissant);
end;

{ TIterateur_hAggregation }

function hAggregation_from_sl( sl: TStringList; Index: Integer): ThAggregation;
var
   O: TObject;
begin
     Result:= nil;

     if sl = nil                        then exit;
     if (Index < 0)or(sl.Count<= Index) then exit;

     O:= sl.Objects[ Index];
     if O = nil                         then exit;
     if not (O is ThAggregation)      then exit;

     Result:= ThAggregation(O);
end;

function hAggregation_from_sl_Name( sl: TStringList; Name: String): ThAggregation;
begin
     Result:= nil;
     if sl = nil                        then exit;
     Result:= hAggregation_from_sl( sl, sl.IndexOf( Name))
end;

function TIterateur_hAggregation.not_Suivant( out _Resultat: ThAggregation): Boolean;
begin
     Result:= not_Suivant_interne( _Resultat);
end;

procedure TIterateur_hAggregation.Suivant( out _Resultat: ThAggregation);
begin
     Suivant_interne( _Resultat);
end;

{ TslhAggregation }

constructor TslhAggregation.Create( _Nom: String= '');
begin
     inherited CreateE( _Nom, ThAggregation);
end;

destructor TslhAggregation.Destroy;
begin
     inherited;
end;

class function TslhAggregation.Classe_Iterateur: TIterateur_Class;
begin
     Result:= TIterateur_hAggregation;
end;

function TslhAggregation.Iterateur: TIterateur_hAggregation;
begin
     Result:= TIterateur_hAggregation( Iterateur_interne);
end;

function TslhAggregation.Iterateur_Decroissant: TIterateur_hAggregation;
begin
     Result:= TIterateur_hAggregation( Iterateur_interne_Decroissant);
end;

{ ThAggregation }

constructor ThAggregation.Create( _Parent              : TBatpro_Element      ;
                                  _Classe_Elements     : TBatpro_Element_Class;
                                  _pool_Ancetre_Ancetre: Tpool_Ancetre_Ancetre);
begin
     inherited CreateE( ClassName, _Classe_Elements);
     Parent              := _Parent              ;
     pool_Ancetre_Ancetre:= _pool_Ancetre_Ancetre;

     Forte:= False;

     Cree_slCharge;
     Assure_Charge_premier:= True;
end;

destructor ThAggregation.Destroy;
begin
     Deconnecte;
     Free_nil( slCharge);
     inherited;
end;

procedure ThAggregation.Cree_slCharge;
begin
     slCharge:= TBatpro_StringList.CreateE( Classname+'.slCharge', Classe_Elements);
end;

procedure ThAggregation.Deconnecte;
var
   be: TBatpro_Element;
begin
     uClean_Log( ClassName+':ThAggregation.Deconnecte, Classe_Elements:'+Classe_Elements.ClassName);
     while sl.Count > 0
     do
       begin
       be:= Batpro_Element_from_sl( sl, 0);
       if be = nil
       then
           sl.Delete( 0)
       else
           Enleve( be, 0);
       end;
end;

procedure ThAggregation.Supprime_Connections;
var
   be: TBatpro_Element;
   Old_Count: Integer;
begin
     while sl.Count > 0
     do
       begin
       be:= Batpro_Element_from_sl( sl, 0);
       if be = nil
       then
           sl.Delete( 0)
       else
           begin
           Old_Count:= sl.Count;
           Supprime_Connection( be, 0);
           //Pas trop propre
           //mis suite à un bloquage dans le planning
           if Old_Count = sl.Count
           then
               sl.Delete( 0);
           end;
       end;
end;

procedure ThAggregation.Ajoute( be: TBatpro_Element);
begin
     CheckClass( be, Classe_Elements);

     if be = nil      then exit;
     if Contient( be) then exit;

     sl.AddObject( be.sCle , be);
     be.Aggregeurs.AddObject( sys_Vide, Self);
end;

procedure ThAggregation.Enleve_dans_be_Aggregeurs( be: TBatpro_Element);
var
   i: Integer;
begin
     i:= be.Aggregeurs.IndexOfObject( Self);
     if i = -1 then exit;

     be.Aggregeurs.Delete( i);
end;

procedure ThAggregation.Enleve( _be: TBatpro_Element; _Index: Integer= -1);
begin
     if _be = nil         then exit;
     Enleve_dans_be_Aggregeurs( _be);
     
     if not Contient( _be) then exit;

     if _Index = -1
     then
         _Index:= sl.IndexOfObject( _be);
     if _Index = -1 then exit;
     sl.Delete( _Index);
end;

procedure ThAggregation.Supprime_Connection( be: TBatpro_Element; Index: Integer);
begin
     if be = nil         then exit;
     if not Contient(be) then exit;

     be.Supprime_Connection( Parent);

     if Index = -1
     then
         Index:= sl.IndexOfObject( be);
     if Index = -1 then exit;
     sl.Delete( Index);

     Enleve_dans_be_Aggregeurs( be);
end;

procedure ThAggregation.Vide;
begin

end;

procedure ThAggregation.Charge;
begin
     Vide;
end;

procedure ThAggregation.Assure_Charge;
begin
     if not Assure_Charge_premier then exit;

     Charge;
     Assure_Charge_premier:= False;
end;

function ThAggregation.Is_Vide: Boolean;
begin
     Result:= sl.Count = 0;
end;

function ThAggregation.Contient( be: TBatpro_Element): Boolean;
begin
     Result:= 0 <= sl.IndexOfObject( be);
end;

procedure ThAggregation.Delete_from_database;
var
   be, Trash: TBatpro_Element;
   ibe: Integer;
begin
     if not Forte then exit;

     if pool_Ancetre_Ancetre = nil
     then
         begin
         fAccueil_Erreur(  'ThAggregation.Delete_from_database: '
                          +ClassName+': aucun pool défini pour la suppression');
         exit;
         end;
     Charge;
     while sl.Count > 0
     do
       begin
       be:= Batpro_Element_from_sl( sl, 0);
       Trash:= be;
       pool_Ancetre_Ancetre.Supprimer( Trash);

       //dans certains cas le parent est prévenu de la suppression, (planning)
       //dans d'autres non
       ibe:= sl.IndexOfObject( be);
       if ibe <> -1
       then
           sl.Delete( ibe);
       end;
end;

procedure ThAggregation.Copy_from(_hAggregation: ThAggregation);
begin

end;

function ThAggregation.JSON: String;
begin
     Result:= inherited JSON;
end;

function ThAggregation.JSON_Persistants: String;
begin
     Result:= inherited JSON_Persistants;
end;

function ThAggregation.Listing(Indentation: String): String;
var
   be: TBatpro_Element;
   I: TIterateur;
begin
     Result:= '';
     Charge;

     I:= Iterateur_interne;
     while I.Continuer
     do
       begin
       if I.not_Suivant_interne( be) then continue;

       Formate_Liste( Result, #13#10, be.Listing(Indentation+'  '));
       end;
end;

procedure ThAggregation.sCle_Change( _bl: TBatpro_Element);
var
   i: Integer;
begin
     if _bl = nil                  then exit;
     i:= IndexOfObject( _bl);
     if i <> -1
     then
         Strings[i]:= _bl.sCle;
end;

procedure ThAggregation.Ajoute_slCharge;
var
   be: TBatpro_Element;
begin
     slCharge.Iterateur_Start;
     try
        while not slCharge.Iterateur_EOF
        do
          begin
          slCharge.Iterateur_Suivant( be);
          if be = nil then continue;
          Ajoute( be);
          slCharge.Iterateur_Supprime_courant;
          end;
     finally
            slCharge.Iterateur_Stop;
            end;
end;

function ThAggregation.sl: TBatpro_StringList;
begin
     Result:= Self;
end;

{ ThAggregation_Create_Params }

constructor ThAggregation_Create_Params.Create( _Parent: TBatpro_Element);
begin
     Parent:= _Parent;
     hAggregation_class:= nil;
     Batpro_Element_Class:= nil;
end;

destructor ThAggregation_Create_Params.Destroy;
begin

     inherited;
end;

procedure ThAggregation_Create_Params.I( _hAggregation_class  : ThAggregation_class  ;
                                         _Batpro_Element_Class: TBatpro_Element_Class;
                                         _pool_Ancetre_Ancetre: Tpool_Ancetre_Ancetre;
                                         _Is_Forte            : Boolean              );
begin
     hAggregation_class  := _hAggregation_class  ;
     Batpro_Element_Class:= _Batpro_Element_Class;
     pool_Ancetre_Ancetre:= _pool_Ancetre_Ancetre;
     Is_Forte:= _Is_Forte;
end;

procedure ThAggregation_Create_Params.Faible( _hAggregation_class: ThAggregation_class;
                                              _Batpro_Element_Class: TBatpro_Element_Class;
                                              _pool_Ancetre_Ancetre: Tpool_Ancetre_Ancetre);
begin
     I( _hAggregation_class, _Batpro_Element_Class, _pool_Ancetre_Ancetre, False);
end;

procedure ThAggregation_Create_Params.Forte( _hAggregation_class: ThAggregation_class;
                                             _Batpro_Element_Class: TBatpro_Element_Class;
                                             _pool_Ancetre_Ancetre: Tpool_Ancetre_Ancetre);
begin
     I( _hAggregation_class, _Batpro_Element_Class, _pool_Ancetre_Ancetre, True);
end;

function ThAggregation_Create_Params.Instancie: ThAggregation;
begin
     if hAggregation_class = nil
     then
         Result:= nil
     else
         begin
         Result:= hAggregation_class.Create( Parent, Batpro_Element_Class, pool_Ancetre_Ancetre);
         if Assigned( Result)
         then
             Result.Forte:= Is_Forte;
         end;
end;

{ TAggregations }

constructor TAggregations.Create( _Parent: TBatpro_Element;
                                  _Create_Aggregation: TCreate_Aggregation_procedure);
begin
     Create_Aggregation:= _Create_Aggregation;
     Create_Params:= ThAggregation_Create_Params.Create( _Parent);
     sl:= TslhAggregation.Create( ClassName+'.sl');
end;

destructor TAggregations.Destroy;
begin
     Detruit_StringList( sl);
     Free_nil( Create_Params);
     inherited;
end;

function TAggregations.Get_by_Name( Name: String): ThAggregation;
begin
     Result:= hAggregation_from_sl_Name( sl, Name);

     if Result = nil
     then
         begin
         Create_Aggregation( Name, Create_Params);
         Result:= Create_Params.Instancie;
         Result.Nom:= Name;
         sl.AddObject( Name, Result);
         end;
end;

procedure TAggregations.Set_by_Name( Name: String; const Value: ThAggregation);
var
   I: Integer;
begin
     I:= sl.IndexOf( Name);
     if I = -1
     then
         sl.AddObject( Name, Value)
     else
         sl.Objects[I]:= Value;
end;

function TAggregations.Iterateur: TIterateur_hAggregation;
begin
     Result:= sl.Iterateur;
end;

procedure TAggregations.Deconnecte;
var
   I: TIterateur_hAggregation;
   ha: ThAggregation;
begin
     try
        I:= sl.Iterateur;
        while I.Continuer
        do
          begin
          if I.not_Suivant( ha) then continue;

          uhAggregation_Deconnecte_contexte:= ha.ClassName;
          ha.Deconnecte;
          end;
        FreeAndNil( I);
     finally
            uhAggregation_Deconnecte_contexte:= '';
            end;
end;

procedure TAggregations.Supprime_Connections;
var
   I: Integer;
   ha: ThAggregation;
begin
     for I:= 0 to sl.Count -1
     do
       begin
       ha:= hAggregation_from_sl( sl, I);
       if Assigned( ha)
       then
           ha.Supprime_Connections;
       end;
end;

function TAggregations.JSON: String;
var
   I: Integer;
   ha: ThAggregation;
   haName: String;
   iJSON: Integer;
begin
     Result:= '';
     iJSON:= 0;
     for I:= 0 to sl.Count -1
     do
       begin
       ha:= hAggregation_from_sl( sl, I);
       if ha = nil then continue;
       haName:= sl.Strings[I];
       if iJSON > 0
       then
           Result:= Result + ',';
       Result:= Result + Format( '"%s":%s',[haName, ha.JSON]);
       Inc( iJSON);
       end;
end;

function TAggregations.JSON_Persistants: String;
var
   I: Integer;
   ha: ThAggregation;
   haName: String;
   iJSON: Integer;
begin
     Result:= '';
     iJSON:= 0;
     for I:= 0 to sl.Count -1
     do
       begin
       ha:= hAggregation_from_sl( sl, I);
       if ha = nil then continue;
       haName:= sl.Strings[I];
       if iJSON > 0
       then
           Result:= Result + ',';
       Result:= Result + Format( '"%s":%s',[haName, ha.JSON_Persistants]);
       Inc( iJSON);
       end;
end;

procedure TAggregations.Delete_from_database;
var
   I: Integer;
   ha: ThAggregation;
begin
     for I:= 0 to sl.Count -1
     do
       begin
       ha:= hAggregation_from_sl( sl, I);
       if ha = nil then continue;
       ha.Delete_from_database;
       end;
end;

function TAggregations.Listing(Indentation: String): String;
var
   I: Integer;
   ha: ThAggregation;
   sha: String;
begin
     Result:= '';
     for I:= 0 to sl.Count -1
     do
       begin
       ha:= hAggregation_from_sl( sl, I);
       if ha = nil then continue;

       sha:= ha.Listing(Indentation);
       if '' = sha then continue;

       Formate_Liste( Result, #13#10, Indentation+sl[I]);
       Formate_Liste( Result, #13#10, sha);
       end;
end;

procedure TAggregations.sCle_Change(_bl: TBatpro_Element);
var
   I: Integer;
   ha: ThAggregation;
begin
     for I:= 0 to sl.Count -1
     do
       begin
       ha:= hAggregation_from_sl( sl, I);
       if ha = nil then continue;

       ha.sCle_Change( _bl);
       end;
end;


initialization
              Tpool_Ancetre_Ancetre.Fclass_sl:= nil;
              {Début de l'ancienne unité uWindows}
              {$IF DEFINED(MSWINDOWS) AND NOT DEFINED(FPC)}
              CXBORDER:= GetSystemMetrics( SM_CXBORDER);
              CYBORDER:= GetSystemMetrics( SM_CYBORDER);
              CXEDGE:= GetSystemMetrics( SM_CXEDGE);
              CYEDGE:= GetSystemMetrics( SM_CYEDGE);
              {$ELSE}
              CXBORDER:= 1;
              CYBORDER:= 1;
              CXEDGE:= 1;
              CYEDGE:= 1;
              {$IFEND}
              {Fin de l'ancienne unité uWindows}
finalization
end.
