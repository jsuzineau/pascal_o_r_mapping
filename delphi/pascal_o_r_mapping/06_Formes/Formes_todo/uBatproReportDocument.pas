unit uBatproReportDocument;
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
    uOD_Forms,
    uBatpro_StringList,
    uBatpro_Element,
    ubeClusterElement,
    uhDessinnateur,
    uBatproReportPage,
    uBatproReportPageFormat,
    ufAccueil_Erreur,
  Windows, SysUtils, Classes, FMX.Graphicso,Printers,Grids,FMX.ExtCtrls,
  Gauges;

type
 TBatproReportDocument
 =
  class
  public
    PageFormat: TBatproReportPageFormat;
  private
    function Cree_Page(Top: Integer): TBatproReportPage;
    function Page_from_Index(Index: Integer): TBatproReportPage;
    function Page_from_Top(Top, h: Integer): TBatproReportPage;
    function GetCanvas(x, y, w, h: Integer): TCanvas;
    procedure Print_hd( hDessinnateur: ThDessinnateur);
  public
    mfEnteteColonnes: TMetafile;
    Pages: TBatpro_StringList;
    constructor Create;
    destructor Destroy; override;
    procedure Vide;
    procedure Dessinne( _g: TGauge);
    procedure Set_hdTable_Legende( unhdTable: ThDessinnateur;
                                   _sLegende_ligne_1: String; //'Les couleurs représentent les équipes.'
                                   _aLegende_ligne_2: array of String;
                                   _nColumnHeaderDebut,
                                   _nColumnHeaderFin  : Integer;
                                   _Bande_Titre: Boolean);
    function mfPage_from_Index(Index: Integer): TMetafile;
    function Titre: String;
  //Gestion du multipages
  public
    Multipages: Boolean;
  //Gestion de l'affichage du logo
  public
    AfficherLogo: Boolean;
  //Gestion de l'affichage du titre
  public
    AfficherTitre: Boolean;
  //Jauge
  private
    g: TGauge;
  //Sémaphore d'annulation en cours de traitement
  public
    Abandon: Boolean;
  end;

implementation

uses
    uClean,
    udmxG3_UTI,
    uDessin;

constructor TBatproReportDocument.Create;
begin
     PageFormat:= TBatproReportPageFormat.Create;
     Pages:= TBatpro_StringList.Create;
     Multipages:= True;
     AfficherLogo:= True;
     AfficherTitre:= True;
     Abandon:= False;
end;

destructor TBatproReportDocument.Destroy;
begin
     Vide;
     Free_nil( Pages);
     Free_nil( PageFormat);
end;

procedure TBatproReportDocument.Vide;
var
   P: TBatproReportPage;
begin
     while Pages.Count > 0
     do
       begin
       P:= Page_from_Index( 0);
       Pages.Delete( 0);
       Free_nil( P);
       end;
end;

function TBatproReportDocument.Cree_Page( Top: Integer): TBatproReportPage;
begin
     Result:= TBatproReportPage.Create( Pages.Count+1, Top, PageFormat);
     Pages.AddObject( IntToStr(Top), Result);
end;

function TBatproReportDocument.Page_from_Index(Index:Integer):TBatproReportPage;
var
   O: TObject;
begin
     Result:= nil;

     if Index <  0           then exit;
     if Index >= Pages.Count then exit;

     O:= Pages.Objects[Index];
     if O = nil                     then exit;
     if not(O is TBatproReportPage) then exit;

     Result:= TBatproReportPage(O);
end;

function TBatproReportDocument.Page_from_Top( Top ,h: Integer): TBatproReportPage;
var
   I: Integer;
begin
     if Pages.Count = 0
     then
         begin
         Result:= Cree_Page( Top);
         exit;
         end;

     if not Multipages
     then
         begin
         Result:= Page_from_Index( 0);
         exit;
         end;

     Result:= nil;
     for I:= 0 to Pages.Count-1
     do
       begin
       Result:= Page_from_Index( I);
       if Top+h <= Result.DocumentBottom
       then
           break;
       end;
end;

function TBatproReportDocument.GetCanvas( x, y, w, h: Integer): TCanvas;
var
   P: TBatproReportPage;
begin
     Result:= nil;

     P:= Page_from_Top( y, h);

     //si aucune page n'existe ou si la page correspondante est pleine
     //on cree une nouvelle page
     if Assigned( P)
     then
         Result:= P.MC( x, y, w, h);

     if (P = nil) or (Result = nil)
     then
         begin
         P:= Cree_Page( y);
         Result:= P.MC( x, y, w, h);
         end;
end;

procedure TBatproReportDocument.Set_hdTable_Legende( unhdTable: ThDessinnateur;
                                                     _sLegende_ligne_1: String;
                                                     _aLegende_ligne_2: array of String;
                                                     _nColumnHeaderDebut,
                                                     _nColumnHeaderFin  : Integer;
                                                     _Bande_Titre: Boolean);
begin
     PageFormat.Set_hdTable_Legende( unhdTable,
                                     _sLegende_ligne_1,
                                     _aLegende_ligne_2,
                                     _nColumnHeaderDebut,
                                     _nColumnHeaderFin  ,
                                     _Bande_Titre       );
end;

procedure TBatproReportDocument.Dessinne( _g: TGauge);
var
   I: Integer;
   P: TBatproReportPage;
   NbPages: Integer;
   sDate, sEntete: String;
begin
     g:= _g;

     Vide;

     if Multipages
     then
         PageFormat.Multipages( AfficherLogo, AfficherTitre)
     else
         PageFormat.Monopage( AfficherLogo, AfficherTitre);
     try
        //with PageFormat.hdTable
        //do
        //  fAccueil_Erreur(  'Largeur: '+IntToStr( sg.ColWidths [0])+#13#10
        //                   +'Hauteur: '+IntToStr( sg.RowHeights[0])+#13#10);
        Print_hd( PageFormat.hdTable);
     finally
            sDate:= FormatDateTime( '"le "ddddd" à "t', Now);
            NbPages:= Pages.Count;
            for I:= 0 to NbPages - 1
            do
              begin
              P:= Page_from_Index( I);
              sEntete:= Format( '%s %s %s page %d/%d',
                                [
                                dmxG3_UTI.cdsoc.Value,
                                dmxG3_UTI.cdets.Value,
                                sDate,
                                I+1,
                                NbPages
                                ]);
              P.Relie( sEntete);
              end;
            end;
end;

procedure TBatproReportDocument.Print_hd( hDessinnateur: ThDessinnateur);
var
   sg_colcount, sg_rowcount, Progress, Total, Modulo: Integer;
   Colonne, Ligne: Integer;
   sg: TStringGrid;
   R: TRect;
   OffsetX, OffsetY: Integer;
   CellLargeur, CellHauteur: Integer;


   be: TBatpro_Element;
   Is_Cluster: Boolean;

   ColumnHeader_Canvas: TMetafileCanvas;
   ColumnHeader_OffsetY: Integer;

   procedure Print_be( C: TCanvas);
   begin
        if C = nil then exit;

        C.Fill.Color:= TColorRec.White;

        hDessinnateur.DI.Init_Draw( C, Colonne, Ligne, R, True);
        hDessinnateur.DI.Init_Cell( hDessinnateur.Typ(Colonne, Ligne) <> tc_Case,
                                    False);
        hDessinnateur.DrawCell_Table;

        be:= hDessinnateur.sg_be( Colonne, Ligne);
        Is_Cluster:=     Assigned( be)
                     and (be is TbeClusterElement);

        if     (hDessinnateur.Typ( Colonne, Ligne) = tc_Case)
           and not Is_Cluster
        then
            begin
            if Colonne = sg.ColCount-1 then Dec( R.Right );
            if Ligne   = sg.RowCount-1 then Dec( R.Bottom);
            FrameRect_0( C, R);
            end;

        C.Fill.Color:= TColorRec.White;
   end;
   procedure Traite_ColumnHeader;
   begin
        if    (Ligne < PageFormat.nColumnHeaderDebut       )
            or(        PageFormat.nColumnHeaderFin  < Ligne)
        then
            exit;

        SetWindowOrgEx( ColumnHeader_Canvas.Handle,
                        -OffsetX, -ColumnHeader_OffsetY, nil);
        Print_be( ColumnHeader_Canvas);

        Inc( ColumnHeader_OffsetY, CellHauteur);
   end;
begin
     Abandon:= False;
     
     //initialisation pour l'entête de colonnes
     Printer.BeginDoc;
     try
        ColumnHeader_Canvas:= TMetafileCanvas.Create( PageFormat.ColumnHeader,
                                                      Printer.Canvas.Handle);
        //hDessinnateur.DI.Canvas    := ColumnHeader_Canvas;
        //hDessinnateur.DI.Impression:= True;
        //hDessinnateur.Traite_Dimensions;

     finally
            Printer.Abort;
            end;
     try
        //dessin
        sg:= hDessinnateur.sg;
        sg_colcount:= sg.ColCount;
        sg_rowcount:= sg.RowCount;
        Total:= sg_colcount*sg_rowcount;
        Modulo:= Total div 100;
        if Modulo =  0 then Modulo:= 1;
        if Assigned( g)
        then
            begin
            g.MinValue:= 0;
            g.MaxValue:= Total;
            g.Progress:= 0;
            end;

        OffsetX:= 0;
        for Colonne:= 0 to sg.ColCount-1
        do
          begin
          CellLargeur:= sg.ColWidths [Colonne];
          OffsetY:= 0;
          ColumnHeader_OffsetY:= 0;
          for Ligne:= 0 to sg.RowCount-1
          do
            begin
            CellHauteur:= sg.RowHeights[Ligne  ];
            R:= Rect( 0, 0, CellLargeur, CellHauteur);

            Print_be( GetCanvas( OffsetX, OffsetY, CellLargeur, CellHauteur));
            Traite_ColumnHeader;

            Inc( OffsetY, CellHauteur);
            Progress:= Colonne*sg_rowcount+Ligne;
            if Progress mod Modulo = 0
            then
                begin
                if Assigned( g)
                then
                    g.Progress:= Progress;
                uOD_Forms_ProcessMessages;
                if Abandon then break;
                end;
            end;
          Inc( OffsetX, CellLargeur);
          if Abandon then break;
          end;
     finally
            Free_nil( ColumnHeader_Canvas);
            end;
end;

function TBatproReportDocument.mfPage_from_Index( Index: Integer): TMetafile;
var
   P: TBatproReportPage;
begin
     Result:= nil;

     P:= Page_from_Index( Index);
     if P = nil then exit;

     Result:= P.M;
end;

function TBatproReportDocument.Titre: String;
begin
     Result:= PageFormat.sTitre;
end;

end.
