unit uDataClasses;
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
    uBatpro_StringList,
    ubtString,
    uDrawInfo,
    u_sys_,
    uClean,
    uBatpro_Element,
    ubeClusterElement,
    ufAccueil_Erreur,
  SysUtils, Classes, Grids, Dialogs, Printers, Windows, Forms, Controls;

function Batpro_Element_from_sg( sg: TStringGrid;
                                 Colonnne, Ligne: Integer): TBatpro_Element;
function Cell_Height( DrawInfo: TDrawInfo;
                      Colonnne, Ligne: Integer; Cell_Width: Integer): Integer;
//Chargement de cellule
procedure Charge_Cell   ( DrawInfo: TDrawInfo; be:TBatpro_Element;
                                Colonne,Ligne:Integer);
//Chargement de listes
procedure Initialise_Clusters( sl: TBatpro_StringList); overload;
procedure Charge_Ligne  ( DrawInfo: TDrawInfo; sl:TBatpro_StringList;
                          OffsetColonne,      Ligne:Integer;
                          ClusterAddInit_: Boolean); overload;
procedure Charge_Colonne( DrawInfo: TDrawInfo; sl:TBatpro_StringList;
                                Colonne,OffsetLigne:Integer); overload;
procedure Charge_Colonne( DrawInfo: TDrawInfo; beEntete:TBatpro_Element; sl:TBatpro_StringList;
                                Colonne,OffsetLigne:Integer); overload;

//Chargement d'arbres binaires
procedure Initialise_Clusters( bts: TbtString); overload;
procedure Charge_Ligne  ( DrawInfo: TDrawInfo; bts: TbtString;
                          OffsetColonne,      Ligne:Integer;
                          ClusterAddInit_: Boolean); overload;
procedure Charge_Colonne( DrawInfo: TDrawInfo; bts: TbtString;
                                Colonne,OffsetLigne:Integer); overload;
procedure Charge_Colonne( DrawInfo: TDrawInfo; beEntete:TBatpro_Element; bts: TbtString;
                                Colonne,OffsetLigne:Integer); overload;

function Largeur_Colonne( DrawInfo: TDrawInfo; Colonne: Integer;
                          TraiterClusters: Boolean = False): Integer;
function Hauteur_Ligne( DrawInfo: TDrawInfo;
                        Ligne: Integer;
                        TraiterClusters: Boolean = False): Integer;

procedure Initialise_dimensions   ( _DrawInfo: TDrawInfo;
                                    _ColonneDebut: Integer= 0);
procedure Ajuste_Largeur_Client( _DrawInfo: TDrawInfo; _ColonneDebut: Integer= 0);
procedure Traite_Hauteurs_Lignes  ( DrawInfo: TDrawInfo);
procedure Traite_Largeurs_Colonnes( _DrawInfo: TDrawInfo;
                                    _ColonneDebut: Integer= 0;
                                    _ColonneFin  : Integer= -1);
procedure Traite_Ratio( DrawInfo: TDrawInfo);
procedure Egalise_Largeurs_Colonnes( sg: TStringGrid; ColonneDebut, ColonneFin: Integer);
procedure Egalise_Hauteurs_Lignes  ( sg: TStringGrid; LigneDebut, LigneFin: Integer);

implementation

function Batpro_Element_from_sg( sg: TStringGrid;
                                 Colonnne,
                                 Ligne   : Integer): TBatpro_Element;
var
   O: TObject;
begin
     Result:= nil;

     if sg = nil                                 then exit;
     if (Colonnne < 0)or(sg.ColCount<= Colonnne) then exit;
     if (Ligne    < 0)or(sg.RowCount<= Ligne   ) then exit;

     O:= sg.Objects[ Colonnne, Ligne];
     if O = nil                         then exit;
     if not (O is TBatpro_Element)      then exit;

     Result:= TBatpro_Element(O);
end;

function Cell_Height( DrawInfo: TDrawInfo;
                      Colonnne, Ligne: Integer; Cell_Width: Integer): Integer;
var
   be: TBatpro_Element;
begin
     be:= Batpro_Element_from_sg( DrawInfo.sg, 0, Ligne);
     if Assigned( be)
     then
         Result:= be.Cell_Height( DrawInfo, Cell_Width)
     else
         Result:= DrawInfo.sg.RowHeights[ Ligne];
end;

//Chargement de cellules
procedure Charge_Cell   ( DrawInfo: TDrawInfo; be:TBatpro_Element;
                          Colonne,Ligne:Integer);
begin
     if (Colonne<0)or(DrawInfo.sg.ColCount <= Colonne) then exit;
     if (Ligne  <0)or(DrawInfo.sg.RowCount <= Ligne  ) then exit;
     if be = nil
     then
         begin
         DrawInfo.sg.Cells  [ Colonne, Ligne]:= sys_Vide;
         DrawInfo.sg.Objects[ Colonne, Ligne]:= nil;
         end
     else
         begin
         DrawInfo.sg.Cells  [ Colonne, Ligne]:= be.Cell[ DrawInfo.Contexte];
         DrawInfo.sg.Objects[ Colonne, Ligne]:= be;
         end;
end;

//Chargement de listes

procedure Charge_Ligne( DrawInfo: TDrawInfo; sl: TBatpro_StringList;
                        OffsetColonne, Ligne: Integer;
                        ClusterAddInit_: Boolean);
var
   I,
   Colonne: Integer;
   BE: TBatpro_Element;
   beClusterElement: TbeClusterElement;
   Cell: String;
begin
     if not ClusterAddInit_
     then
         Initialise_Clusters( sl);

     for I:= 0 to sl.Count-1
     do
       begin
       Colonne:= OffsetColonne+I;

       BE:= Batpro_Element_from_sl( sl, I);
       if Assigned( BE)
       then
           begin
           Cell:= BE.Cell[DrawInfo.Contexte];
           if BE is TbeClusterElement
           then
               begin
               beClusterElement:= TbeClusterElement( BE);
               beClusterElement.Ajoute( Colonne, Ligne);
               end
           end
       else
           Cell:= sl.Strings[ I];

       DrawInfo.sg.Cells  [ Colonne, Ligne]:= Cell;
       DrawInfo.sg.Objects[ Colonne, Ligne]:= sl.Objects[ I];
       end;
end;

procedure Charge_Colonne( DrawInfo: TDrawInfo; sl: TBatpro_StringList;
                          Colonne, OffsetLigne: Integer); overload;
var
   Ligne: Integer;
   BE: TBatpro_Element;
   Cell: String;
begin
     for Ligne:= 0 to sl.Count-1
     do
       begin
       BE:= Batpro_Element_from_sl( sl, Ligne);
       if Assigned( BE)
       then
           Cell:= BE.Cell[ DrawInfo.Contexte]
       else
           Cell:= sl.Strings[ Ligne];
       DrawInfo.sg.Cells  [ Colonne, OffsetLigne+Ligne]:= Cell;
       DrawInfo.sg.Objects[ Colonne, OffsetLigne+Ligne]:= sl.Objects[ Ligne];
       end;
end;

procedure Charge_Colonne( DrawInfo: TDrawInfo; beEntete:TBatpro_Element; sl:TBatpro_StringList;
                                Colonne,OffsetLigne:Integer); overload;
begin
     Charge_Cell   ( DrawInfo, beEntete, Colonne, OffsetLigne-1);
     Charge_Colonne( DrawInfo, sl      , Colonne, OffsetLigne  );
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

//Chargement d'arbres binaires

procedure Initialise_Clusters( bts: TbtString);
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

procedure Charge_Ligne( DrawInfo: TDrawInfo; bts: TbtString;
                        OffsetColonne, Ligne: Integer;
                        ClusterAddInit_: Boolean);
var
   I,
   Colonne: Integer;
   BE: TBatpro_Element;
   beClusterElement: TbeClusterElement;
   Cell: String;
begin
     if not ClusterAddInit_
     then
         Initialise_Clusters( bts);

     I:= -1;
     bts.Iterateur_Start;
     while not bts.Iterateur_EOF
     do
       begin
       bts.Iterateur_Suivant( BE);
       Inc( I);

       Colonne:= OffsetColonne+I;

       if Assigned( BE)
       then
           begin
           Cell:= BE.Cell[DrawInfo.Contexte];
           if BE is TbeClusterElement
           then
               begin
               beClusterElement:= TbeClusterElement( BE);
               beClusterElement.Ajoute( Colonne, Ligne);
               end
           end
       else
           Cell:= sys_Vide;

       DrawInfo.sg.Cells  [ Colonne, Ligne]:= Cell;
       DrawInfo.sg.Objects[ Colonne, Ligne]:= BE;
       end;
end;

procedure Charge_Colonne( DrawInfo: TDrawInfo; bts: TbtString;
                          Colonne, OffsetLigne: Integer); overload;
var
   Ligne: Integer;
   BE: TBatpro_Element;
   Cell: String;
begin
     Ligne:= -1;
     bts.Iterateur_Start;
     while not bts.Iterateur_EOF
     do
       begin
       bts.Iterateur_Suivant( BE);
       Inc( Ligne);

       if Assigned( BE)
       then
           Cell:= BE.Cell[ DrawInfo.Contexte]
       else
           Cell:= sys_Vide;
       DrawInfo.sg.Cells  [ Colonne, OffsetLigne+Ligne]:= Cell;
       DrawInfo.sg.Objects[ Colonne, OffsetLigne+Ligne]:= BE;
       end;
end;

procedure Charge_Colonne( DrawInfo: TDrawInfo; beEntete:TBatpro_Element; bts: TbtString;
                                Colonne,OffsetLigne:Integer); overload;
begin
     Charge_Cell   ( DrawInfo, beEntete, Colonne, OffsetLigne-1);
     Charge_Colonne( DrawInfo, bts      , Colonne, OffsetLigne  );
end;

function Hauteur_Ligne( DrawInfo: TDrawInfo;
                        Ligne: Integer;
                        TraiterClusters: Boolean = False): Integer;
var
   Colonne: Integer;
   be: TBatpro_Element;
   be_Height: Integer;
begin
     DrawInfo.Row:= Ligne;

     if TraiterClusters
     then
         Result:= DrawInfo.sg.RowHeights[ Ligne]
     else
         Result:= 0;

     for Colonne:= 0 to DrawInfo.sg.ColCount-1
     do
       begin
       be:= Batpro_Element_from_sg( DrawInfo.sg, Colonne, Ligne);
       if be = nil then continue;

       DrawInfo.Col:= Colonne;
            if not( TraiterClusters or  (be is TbeClusterElement))
       then
           begin
           be_Height:= be.Cell_Height( DrawInfo, DrawInfo.sg.ColWidths[Colonne]);
           if be_Height > Result
           then
               Result:= be_Height;
           end
       else if      TraiterClusters and (be is TbeClusterElement)
       then
           begin
           TbeClusterElement(be).CalculeHauteur( DrawInfo,
                                                 Colonne, Ligne,
                                                 Result);
           end;
       end;
end;

function Largeur_Colonne( DrawInfo: TDrawInfo; Colonne: Integer;
                          TraiterClusters: Boolean = False): Integer;
var
   Ligne: Integer;
   be: TBatpro_Element;
   be_Width: Integer;
begin
     DrawInfo.Col:= Colonne;

     if TraiterClusters
     then
         Result:= DrawInfo.sg.ColWidths[ Colonne]
     else
         Result:= 0;

     for Ligne:= 0 to DrawInfo.sg.RowCount-1
     do
       begin
       be:= Batpro_Element_from_sg( DrawInfo.sg, Colonne, Ligne);
       if be = nil then continue;
       DrawInfo.Row:= Ligne;

            if not( TraiterClusters or  (be is TbeClusterElement))
       then
           begin
           be_Width:= be.Cell_Width( DrawInfo);
           if be_Width > Result
           then
               Result:= be_Width;
           end
       else if      TraiterClusters and (be is TbeClusterElement)
       then
           begin
           TbeClusterElement(be).CalculeLargeur( DrawInfo,
                                                 Colonne, Ligne,
                                                 Result);
           end;
       end;
end;

procedure Traite_Hauteurs_Lignes( DrawInfo: TDrawInfo);
var
   Ligne: Integer;
   Max: Integer;
begin
     //première passe sur les cellules non-clusters
     for Ligne:= 0 to DrawInfo.sg.RowCount-1
     do
       begin
       Max:= Hauteur_Ligne( DrawInfo, Ligne, False);
       if Max > 0
       then
           DrawInfo.sg.RowHeights[ Ligne]:= Max;
       end;

     //seconde passe sur les cellules clusters
     for Ligne:= 0 to DrawInfo.sg.RowCount-1
     do
       begin
       Max:= Hauteur_Ligne( DrawInfo, Ligne, True);
       if Max > 0
       then
           DrawInfo.sg.RowHeights[ Ligne]:= Max;
       end;
end;

procedure Traite_Largeurs_Colonnes( _DrawInfo: TDrawInfo;
                                    _ColonneDebut: Integer= 0;
                                    _ColonneFin  : Integer= -1);
var
   Colonne: Integer;
   Max: Integer;
begin
     if _ColonneFin = -1
     then
         _ColonneFin:= _DrawInfo.sg.ColCount-1;

     //première passe sur les cellules non-clusters
     for Colonne:= _ColonneDebut to _ColonneFin
     do
       begin
       Max:= Largeur_Colonne( _DrawInfo, Colonne, False);
       if Max > 0
       then
           _DrawInfo.sg.ColWidths[ Colonne]:= Max;
       end;

     //seconde passe sur les cellules clusters
     for Colonne:= _ColonneDebut to _ColonneFin
     do
       begin
       Max:= Largeur_Colonne( _DrawInfo, Colonne, True);
       if Max > 0
       then
           _DrawInfo.sg.ColWidths[ Colonne]:= Max;
       end;
end;

procedure Egalise_Largeurs_Colonnes( sg: TStringGrid; ColonneDebut, ColonneFin: Integer);
var
   Colonne: Integer;
   Largeur, LargeurMax: Integer;
begin
     //première passe de détection de la largeur maxi
     LargeurMax:= 0;
     for Colonne:= ColonneDebut to ColonneFin
     do
       begin
       Largeur:= sg.ColWidths[ Colonne];
       if LargeurMax < Largeur
       then
           LargeurMax:= Largeur;
       end;

     //Seconde passe pour égaliser
     for Colonne:= ColonneDebut to ColonneFin
     do
       sg.ColWidths[ Colonne]:= LargeurMax;
end;

procedure Egalise_Hauteurs_Lignes  ( sg: TStringGrid; LigneDebut, LigneFin: Integer);
var
   Ligne: Integer;
   Hauteur, HauteurMax: Integer;
begin
     //première passe de détection de la Hauteur maxi
     HauteurMax:= 0;
     for Ligne:= LigneDebut to LigneFin
     do
       begin
       Hauteur:= sg.RowHeights[ Ligne];
       if HauteurMax < Hauteur
       then
           HauteurMax:= Hauteur;
       end;

     //Seconde passe pour égaliser
     for Ligne:= LigneDebut to LigneFin
     do
       sg.RowHeights[ Ligne]:= HauteurMax;
end;

procedure Initialise_dimensions( _DrawInfo: TDrawInfo;
                                 _ColonneDebut: Integer= 0);
var
   Colonne, Ligne: Integer;
begin
     for Colonne:= _ColonneDebut to _DrawInfo.sg.ColCount-1
     do
       with _DrawInfo.sg
       do
         ColWidths[ Colonne]:= DefaultColWidth;

     for Ligne:= 0 to _DrawInfo.sg.RowCount-1
     do
       with _DrawInfo.sg
       do
         RowHeights[ Ligne]:= DefaultRowHeight;
end;

procedure Ajuste_Largeur_Client( _DrawInfo: TDrawInfo; _ColonneDebut: Integer= 0);
var
   LargeurDisponible: Integer;
   GridLineWidth: Integer;
   NbColonnesAjustees: Integer;
   LargeurColonne_avec_GridLineWidth,
   LargeurColonne, Reste: Integer;
   Colonne: Integer;
begin
     GridLineWidth:= _DrawInfo.sg.GridLineWidth;

     LargeurDisponible:= _DrawInfo.sg.ClientWidth - GridLineWidth;
     for Colonne:= 0 to _ColonneDebut-1
     do
       begin
       Dec( LargeurDisponible, _DrawInfo.sg.ColWidths[ Colonne]);
       Dec( LargeurDisponible, GridLineWidth);
       end;

     NbColonnesAjustees:= _DrawInfo.sg.ColCount - _ColonneDebut;
     LargeurColonne_avec_GridLineWidth:= LargeurDisponible div NbColonnesAjustees;
     LargeurColonne:= LargeurColonne_avec_GridLineWidth - GridLineWidth;
     Reste:= LargeurDisponible - LargeurColonne_avec_GridLineWidth * NbColonnesAjustees;

     for Colonne:= _ColonneDebut to _DrawInfo.sg.ColCount-2
     do
       with _DrawInfo.sg
       do
         ColWidths[ Colonne]:= LargeurColonne;

     Colonne:= _DrawInfo.sg.ColCount-1;
     with _DrawInfo.sg
     do
       ColWidths[ Colonne]:= LargeurColonne+Reste;
end;

procedure Traite_Ratio( DrawInfo: TDrawInfo);
var
   Colonne, Ligne: Integer;
   Largeur, Hauteur,
   Printer_PageWidth, Printer_PageHeight: Integer;
   Ratio, Ratio_Printer: double;
   CX, CY: double;
begin
     Largeur:= 0;
     for Colonne:= 0 to DrawInfo.sg.ColCount-1
     do
       Inc( Largeur, DrawInfo.sg.ColWidths[ Colonne]);

     Hauteur:= 0;
     for Ligne:= 0 to DrawInfo.sg.RowCount-1
     do
       Inc( Hauteur, DrawInfo.sg.RowHeights[ Ligne]);

     if Largeur = 0 then exit;
     if Hauteur = 0 then exit;

     if Largeur > Hauteur
     then
         Printer.Orientation:= poLandscape
     else
         Printer.Orientation:= poPortrait;

     Printer_PageWidth := Printer.PageWidth ;
     Printer_PageHeight:= Printer.PageHeight;
     if Printer_PageWidth  = 0 then exit;
     if Printer_PageHeight = 0 then exit;

     Ratio        := Largeur           / Hauteur           ;
     Ratio_printer:= Printer_PageWidth / Printer_PageHeight;

     if Ratio = Ratio_printer then exit;

     if Ratio > Ratio_printer
     then
         begin
         CY:= Ratio / Ratio_printer;
         with DrawInfo.sg
         do
           for Ligne:= 0 to DrawInfo.sg.RowCount-1
           do
             RowHeights[ Ligne]:= Trunc( RowHeights[ Ligne] * CY);
         end
     else //Ratio < Ratio_printer
         begin
         CX:= Ratio_printer / Ratio;
         with DrawInfo.sg
         do
           for Colonne:= 0 to DrawInfo.sg.ColCount-1
           do
             ColWidths[ Colonne]:= Trunc( ColWidths[ Colonne] * CX);
         end;

end;

end.
