unit ubeClusterElement;
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
    SysUtils, Classes,
    {$IFDEF MSWINDOWS}
    FMX.Graphics, Windows, FMX.Grid,
    {$ENDIF}
    Types,
    uBatpro_StringList,
    u_sys_,
    uDrawInfo,
    uBatpro_Element;

type
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

    function Cell_Height( DrawInfo: TDrawInfo; Cell_Width: Integer): Integer; override;
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
  //Gestion de la composition de la bulle d'aide
  public
    procedure EditeBulle( Contexte: Integer); override;
  end;

function beClusterElement_from_sl( sl: TBatpro_StringList; Index: Integer): TbeClusterElement;

implementation

function beClusterElement_from_sl( sl: TBatpro_StringList; Index: Integer): TbeClusterElement;
begin
     _Classe_from_sl( Result, TbeClusterElement, sl, Index);
end;


{ TbeClusterElement }

constructor TbeClusterElement.Create( un_sl: TBatpro_StringList;
                                      _beCluster: TBatpro_Element);
begin
     inherited Create( un_sl);
     FbeCluster:= _beCluster;
end;

procedure TbeClusterElement.Draw(DrawInfo: TDrawInfo);
{$IFDEF MSWINDOWS}
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
     {
     if DrawInfo.Impression
     then
         sg_GridLineWidth:= 0
     else
         sg_GridLineWidth:= sg.GridLineWidth;
     }

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
{$IFDEF MSWINDOWS}
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
{$ELSE}
begin
end;
{$ENDIF}

function TbeClusterElement.Cell_Height( DrawInfo: TDrawInfo; Cell_Width: Integer): Integer;
begin
     //pas évident que cet algo soit OK
     if     Assigned( beCluster)
        and Assigned( beCluster.Cluster)
        and beCluster.Cluster.SingleRow
     then
         // si 1 seule ligne, on postule que le cluster a toute la largeur
         // qu'il demande
         Result:= beCluster.Cell_Height( DrawInfo,
                                         beCluster.Cell_Width( DrawInfo))
     else
         Result:= inherited Cell_Height( DrawInfo, Cell_Width);
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

procedure TbeClusterElement.EditeBulle(Contexte: Integer);
begin
     beCluster.EditeBulle( Contexte);
end;

end.
