unit uBatproReportPageFormat;
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
    uWinUtils,
    uuStrings,
    uClean,
    u_sys_,
    uhDessinnateur,
    upoolG_PAR,
    ufAccueil_Erreur,
    Windows, SysUtils, Classes, ExtCtrls, Graphics, Grids, Printers;

type
 TBatproReportPageFormat
 =
  class
  //Gestion du cycle de vie
  public
    constructor Create;
    destructor Destroy; override;
  //Dimensions de la zone d'impression de l'imprimante
  private
    //en mm
    nHorzSize,
    nVertSize: Integer;
    //en pixels
    nHorzRes,
    nVertRes: Integer;
    //Forme de pixel
    nAspectX,
    nAspectY: Integer;
    //initialisation
    procedure Init_from_printer;
  //Dimensions en mm
  private
    mm_HauteurLogo : double;
    mm_HauteurTitre: double;
    mm_HauteurPied : double;
    HauteurTable_en_mm: double;
    procedure Calcule_HauteurTable_en_mm;
  //Dimensions en pixels
  private
    FLargeur: Integer;
    GrilleLargeur, ZoneImprimable_Hauteur: Integer;
    X_Coeff_Pixels_from_mm: double;
    Y_Coeff_Pixels_from_mm: double;
    FHauteurLogo: Integer;
    HauteurEntete: Integer;
    HauteurTitre: Integer;
    HauteurPied : Integer;
    function X_Pixels_from_mm( _mm: double): Integer;
    function Y_Pixels_from_mm( _mm: double): Integer;
    procedure Calcule_hauteurs_en_pixels;
    procedure Baser_sur_GrilleLargeur;
    procedure Baser_sur_TableHeight;
  public
    property Largeur    : Integer read FLargeur;
    property Hauteur    : Integer read ZoneImprimable_Hauteur;
    procedure Calcule( _NumeroPage: Integer;
                       var ZoneGrille_Top, ZoneGrille_Hauteur: Integer);
  //Coordonnées en Pixels
  private
    YPied: Integer;
  //Général
  private
    aLegende_ligne_2: array of String;
    sLegende_ligne_1,
    sLegende_ligne_2: String;
    FBande_Titre: Boolean;
    procedure Dessinne_Titre       (Canvas: TCanvas);
    procedure Dessinne_ColumnHeader(Canvas: TCanvas);
    procedure Dessinne_Pied        (Canvas: TCanvas);
  public
    sTitre: String;

    hdTable: ThDessinnateur;
    Logo: TImage;
    fCourierNew_10_Italic: TFont;
    fArial_14_Bold_Underline_clNavy: TFont;
    fTitre: TFont;


    //entête de colonnes répliqué sur toutes les pages > 1
    ColumnHeader: TMetafile;
    ColumnHeaderHeight: Integer;
    // les bornes en numéros de ligne
    nColumnHeaderDebut,
    nColumnHeaderFin  : Integer;

    property HauteurLogo: Integer read FHauteurLogo;
    property Entete     : Integer read HauteurEntete;
    property Titre      : Integer read HauteurTitre;
    property Pied       : Integer read HauteurPied;

    property Bande_Titre: Boolean read FBande_Titre;

    procedure Set_hdTable_Legende( unhdTable: ThDessinnateur;
                                   _sLegende_ligne_1: String;
                                   _aLegende_ligne_2: array of String;
                                   _nColumnHeaderDebut,
                                   _nColumnHeaderFin  : Integer;
                                   _Bande_Titre: Boolean
                                   );

    procedure Dessinne( Canvas: TCanvas; NumeroPage: Integer);
  //Mode multipage, document aligné sur la largeur de page disponible
  public
    procedure Multipages( _AfficherLogo: Boolean = True; _AfficherTitre: boolean= True);
  //Mode monopage, document mis à échelle pour impression sur une seule page
  public
    TableHeight: Integer;
    procedure Monopage( _AfficherLogo: Boolean = True; _AfficherTitre: boolean= True);
  //Gestion de l'affichage du logo
  public
    AfficherLogo: Boolean;
  //Gestion du titre
  public
    AfficherTitre: Boolean;
  end;

implementation

constructor TBatproReportPageFormat.Create;
begin
     mm_HauteurLogo := 20  ;
     mm_HauteurTitre:= 14.3;
     mm_HauteurPied := 10  ;

     Logo:= TImage.Create(nil);


     fCourierNew_10_Italic:= TFont.Create;
     with fCourierNew_10_Italic
     do
       begin
       Name:= 'Courier New';
       Size:= 10;
       Style:= Style + [fsItalic];
       end;

     fArial_14_Bold_Underline_clNavy:= TFont.Create;
     with fArial_14_Bold_Underline_clNavy
     do
       begin
       Name:= 'Arial';
       Size:= 14;
       Style:= Style + [fsBold, fsUnderline];
       Color:= clNavy;
       end;

     fTitre:= TFont.Create;
     fTitre.Assign( fArial_14_Bold_Underline_clNavy);

     ColumnHeader:= TMetafile.Create;
     ColumnHeaderHeight:= 0;
     FBande_Titre:= True;
end;

destructor TBatproReportPageFormat.Destroy;
begin
     Free_nil( ColumnHeader);
     Free_nil( fCourierNew_10_Italic);
     Free_nil( Logo);
end;

function TBatproReportPageFormat.X_Pixels_from_mm( _mm: double): Integer;
begin
     Result:= Trunc( X_Coeff_Pixels_from_mm * _mm);
end;

function TBatproReportPageFormat.Y_Pixels_from_mm( _mm: double): Integer;
begin
     Result:= Trunc( Y_Coeff_Pixels_from_mm * _mm);
end;

procedure TBatproReportPageFormat.Calcule_hauteurs_en_pixels;
begin
     ZoneImprimable_Hauteur:= Y_Pixels_from_mm( nVertSize);

     if AfficherLogo
     then
         FHauteurLogo:= Y_Pixels_from_mm( mm_HauteurLogo)
     else
         FHauteurLogo:= 0;
     HauteurEntete:= HauteurLogo+ColumnHeaderHeight;
     if AfficherTitre
     then
         HauteurTitre := Y_Pixels_from_mm( mm_HauteurTitre)
     else
         HauteurTitre := 0;
     HauteurPied  := Y_Pixels_from_mm( mm_HauteurPied );

     YPied:= ZoneImprimable_Hauteur - HauteurPied;
end;

procedure TBatproReportPageFormat.Calcule_HauteurTable_en_mm;
begin
     HauteurTable_en_mm:= nVertSize - mm_HauteurTitre - mm_HauteurPied;
     if AfficherLogo
     then
         HauteurTable_en_mm:= HauteurTable_en_mm - mm_HauteurLogo;
     if AfficherTitre
     then
         HauteurTable_en_mm:= HauteurTable_en_mm - mm_HauteurTitre;
end;

procedure TBatproReportPageFormat.Init_from_printer;
var
   PCH: HDC;
begin
     poolG_PAR.Put_plogo_in( Logo);
     Printer.BeginDoc;
     try
        PCH:= Printer.Canvas.Handle;
        nHorzSize:= GetDeviceCaps( PCH, HORZSIZE);
        nVertSize:= GetDeviceCaps( PCH, VERTSIZE);
        nHorzRes := GetDeviceCaps( PCH, HORZRES );
        nVertRes := GetDeviceCaps( PCH, VERTRES );
        nAspectX := GetDeviceCaps( PCH, ASPECTX );
        nAspectY := GetDeviceCaps( PCH, ASPECTY );
        Calcule_HauteurTable_en_mm;
     finally
            Printer.Abort;
            end;
end;

procedure TBatproReportPageFormat.Baser_sur_GrilleLargeur;
begin
     FLargeur:= GrilleLargeur;

     X_Coeff_Pixels_from_mm:= FLargeur/nHorzSize;
     Y_Coeff_Pixels_from_mm:= (X_Coeff_Pixels_from_mm * nAspectY) / nAspectX;
end;

procedure TBatproReportPageFormat.Baser_sur_TableHeight;
begin
     Y_Coeff_Pixels_from_mm:= TableHeight/ HauteurTable_en_mm;
     X_Coeff_Pixels_from_mm:= (Y_Coeff_Pixels_from_mm * nAspectX) / nAspectY;

     FLargeur:= X_Pixels_from_mm( nHorzSize);
end;

procedure TBatproReportPageFormat.Multipages( _AfficherLogo: Boolean = True; _AfficherTitre: boolean= True);
begin
     AfficherLogo := _AfficherLogo;
     AfficherTitre:= _AfficherTitre;
     Init_from_printer;

     Baser_sur_GrilleLargeur;

     Calcule_hauteurs_en_pixels;
end;

procedure TBatproReportPageFormat.Monopage( _AfficherLogo: Boolean = True; _AfficherTitre: boolean= True);
begin
     AfficherLogo := _AfficherLogo ;
     AfficherTitre:= _AfficherTitre;
     Init_from_printer;

     Baser_sur_TableHeight;
     if FLargeur < GrilleLargeur 
     then
         Baser_sur_GrilleLargeur;

     Calcule_hauteurs_en_pixels;
end;

procedure TBatproReportPageFormat.Set_hdTable_Legende( unhdTable: ThDessinnateur;
                                                       _sLegende_ligne_1: String;
                                                       _aLegende_ligne_2: array of String;
                                                       _nColumnHeaderDebut,
                                                       _nColumnHeaderFin  : Integer;
                                                       _Bande_Titre: Boolean);
var
   I: Integer;
begin
     hdTable:= unhdTable;

     SetLength(aLegende_ligne_2, Length( _aLegende_ligne_2));
     for I:= Low(aLegende_ligne_2) to High(aLegende_ligne_2)
     do
       aLegende_ligne_2[I]:= _aLegende_ligne_2[I];

     GrilleLargeur:= 0;
     for I:= 0 to hdTable.sg.ColCount-1
     do
       Inc( GrilleLargeur, hdTable.sg.ColWidths[I]);

     sLegende_ligne_2:= Justifie( aLegende_ligne_2,
                          NbChars( fCourierNew_10_Italic, GrilleLargeur)
                          -Length('Légende: '));
     sTitre:= hdTable.hdCell;

     nColumnHeaderDebut:= _nColumnHeaderDebut;
     nColumnHeaderFin  := _nColumnHeaderFin  ;
     ColumnHeaderHeight:= 0;
     for I:= nColumnHeaderDebut to nColumnHeaderFin
     do
       Inc( ColumnHeaderHeight, hdTable.sg.RowHeights[I]);

     TableHeight:= 0;
     for I:= 0 to hdTable.sg.RowCount - 1
     do
       Inc( TableHeight, hdTable.sg.RowHeights[I]);

     FBande_Titre:= _Bande_Titre;
end;

procedure TBatproReportPageFormat.Dessinne_Titre( Canvas: TCanvas);
var
   SommetTitre: Integer;
begin
     if not AfficherTitre then exit;

     SommetTitre:= HauteurLogo;

     Canvas.Brush.Color:= clInfoBk;
      Canvas.Pen.Style:= psClear;
        Canvas.Rectangle( 0, SommetTitre, Largeur, SommetTitre + Titre);
      Canvas.Pen.Style:= psSolid;

      Canvas.Font.Assign( fTitre);
      Canvas.Font.Height:= Titre div 3;
      SetTextAlign( Canvas.Handle, TA_CENTER or TA_TOP);
      Canvas.TextOut( Largeur div 2,
                       SommetTitre
                      +Titre div 2
                      -LineHeight( Canvas.Font) div 2,
                      sTitre);
     Canvas.Brush.Color:= clWhite;
end;

procedure TBatproReportPageFormat.Dessinne_ColumnHeader(Canvas: TCanvas);
begin
     Canvas.Draw( 0, HauteurLogo, ColumnHeader);
end;

procedure TBatproReportPageFormat.Dessinne_Pied( Canvas: TCanvas);
var
   LH: Integer;
begin
     Canvas.Font.Assign( fCourierNew_10_Italic);
     SetTextAlign( Canvas.Handle, TA_LEFT or TA_TOP);
     LH:= LineHeight( Canvas.Font);

     if sLegende_ligne_1 <> sys_Vide
     then
         Canvas.TextOut( 10, YPied   , 'Légende: '+sLegende_ligne_1);
     if sLegende_ligne_2 <> sys_Vide
     then
         Canvas.TextOut( 10, YPied+LH, '         '+sLegende_ligne_2);
end;

procedure TBatproReportPageFormat.Dessinne( Canvas:TCanvas; NumeroPage:Integer);
begin
     if (NumeroPage = 1) and Bande_Titre
     then
         Dessinne_Titre( Canvas);

     if NumeroPage > 1
     then
         Dessinne_ColumnHeader( Canvas);

     Dessinne_Pied ( Canvas);
end;

procedure TBatproReportPageFormat.Calcule( _NumeroPage: Integer;
                                           var ZoneGrille_Top,
                                               ZoneGrille_Hauteur: Integer);
begin
     ZoneGrille_Top:= HauteurEntete;
     if _NumeroPage = 1
     then
         begin
         if Bande_Titre
         then
             Inc( ZoneGrille_Top, HauteurTitre);
         Dec( ZoneGrille_Top, ColumnHeaderHeight);
         end;

     ZoneGrille_Hauteur:= YPied-ZoneGrille_Top;
end;

end.
