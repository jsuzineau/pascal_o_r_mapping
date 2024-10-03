unit uBatproReportPage;
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
    Windows, SysUtils, Classes, FMX.Graphicso, Printers, FMX.ExtCtrls,
    uBatproReportPageFormat;

type
 TBatproReportPage
 =
  class
  private
    PageFormat: TBatproReportPageFormat;
    DocumentTop   ,
    OffsetY       ,
    FDocumentBottom: Integer;
    FMC: TMetafileCanvas;
    OriginalWindowOrg: TPoint;
  public
    M: TMetafile;
    NumeroPage: Integer;
    constructor Create( unNumeroPage: Integer;
                        unDocumentTop: Integer;
                        unPageFormat: TBatproReportPageFormat);
    procedure Relie( sEntete: String);
    destructor Destroy; override;
    procedure Cree_MC;
    function MC( x, y, w, h: Integer): TMetafileCanvas;
    function Aggrandissement(X: Integer): Integer;
    property DocumentBottom: Integer read FDocumentBottom;
  end;

implementation

uses
    uWinUtils,
    uClean;

constructor TBatproReportPage.Create( unNumeroPage: Integer;
                                      unDocumentTop: Integer;
                                      unPageFormat: TBatproReportPageFormat);
var
   ZoneGrille_Hauteur: Integer;
begin
     NumeroPage := unNumeroPage ;
     DocumentTop:= unDocumentTop;
     PageFormat := unPageFormat     ;

     PageFormat.Calcule( NumeroPage, OffsetY, ZoneGrille_Hauteur);
     FDocumentBottom:= DocumentTop+ ZoneGrille_Hauteur;

     M:= TMetafile.Create;
     M.Width := PageFormat.Largeur;
     M.Height:= PageFormat.Hauteur;
     FMC:= nil;
end;

destructor TBatproReportPage.Destroy;
begin
     Free_nil( M);
end;

function TBatproReportPage.Aggrandissement( X: Integer): Integer;
begin
     Result
     :=
       MulDiv( X,
               PageFormat.HauteurLogo,
               PageFormat.Logo.Picture.Graphic.Height);
end;

procedure TBatproReportPage.Relie( sEntete: String);
var
   LargeurLogo: Integer;
   TailleFonte: Integer;
begin
     //appellé en fin de dessin pour mettre le logo et l'entête
     SetWindowOrgEx( FMC.Handle, OriginalWindowOrg.x, OriginalWindowOrg.Y, nil);

     if PageFormat.AfficherLogo
     then
         begin
         LargeurLogo:= Aggrandissement( PageFormat.Logo.Picture.Graphic.Width);
         FMC.StretchDraw( Rect( 0, 0, LargeurLogo, PageFormat.HauteurLogo),
                          PageFormat.Logo.Picture.Graphic);

         FMC.Font.Assign( PageFormat.fCourierNew_10_Italic);
         FMC.Font.Size:= Aggrandissement( 10);
         SetTextAlign( FMC.Handle, TA_RIGHT or TA_TOP);
         FMC.TextOut( PageFormat.Largeur, 0, sEntete);
         end;

     PageFormat.Dessinne( FMC, NumeroPage);

     Free_nil( FMC);
end;

procedure TBatproReportPage.Cree_MC;
begin
     Printer.BeginDoc;
     try
        FMC:= TMetafileCanvas.Create( M, Printer.Canvas.Handle);
     finally
            Printer.Abort;
            end;
     GetWindowOrgEx( FMC.Handle, OriginalWindowOrg);
     FMC.FillRect(Rect(0,0,PageFormat.Largeur, PageFormat.Hauteur));
end;

function TBatproReportPage.MC( x, y, w, h: Integer): TMetafileCanvas;
var
   WindowOrg: TPoint;
begin
     Result:= nil;

     if   (y < DocumentTop)or(DocumentBottom < y  )
        or                   (DocumentBottom < y+h) then exit;

     if FMC = nil
     then
         Cree_MC;
     Result:= FMC;

     WindowOrg:= OriginalWindowOrg;
     Inc( WindowOrg.x, -x);
     Inc( WindowOrg.y, -(y-DocumentTop+OffsetY));
     SetWindowOrgEx( FMC.Handle, WindowOrg.x, WindowOrg.Y, nil);
end;

initialization
finalization
end.

