unit uberef;
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
    ufAccueil_Erreur,
    uBatpro_StringList,
    u_sys_,
    u_loc_,
    uDataUtils,
    uuStrings,
    uSVG,
    uDrawInfo,
    uBatpro_Element,
    ubeClusterElement,
    uContextes,
    uVide,
  {$IFDEF MSWINDOWS}
  Windows, Graphics, Controls,
  {$ENDIF}
  SysUtils, Classes;

type
 Tberef
 =
  class( TBatpro_Element)
  protected
    procedure SetSelected(Value: Boolean); override;
  public
    ref: TBatpro_Element;
    constructor Create( un_sl: TBatpro_StringList; _ref: TBatpro_Element);
    function GetCell(Contexte: Integer): String; override;
    function sCle: String; override;
    function Contenu( Contexte: Integer; Col, Row: Integer): String; override;
    function Get_Alignement(Contexte: Integer): TbeAlignement; override;
    procedure Draw(DrawInfo: TDrawInfo); override;
    function Draw_Text( DrawInfo: TDrawInfo; Alignement: TbeAlignement;
                        Text: String; Font: TFont): Integer; override;
    function Cell_Height(DrawInfo: TDrawInfo; Cell_Width: Integer): Integer;override;
    function Cell_Width(DrawInfo: TDrawInfo): Integer; override;
  //Affichage SVG
  public
    procedure svgDraw( DrawInfo: TDrawInfo); override;
  end;

function beref_from_sl( sl: TBatpro_StringList; Index: Integer): Tberef;

procedure Cree_Reference( slCible, slSource: TBatpro_StringList);
procedure Cree_Reference_Cluster( slCibleReference, slCible, slSource: TBatpro_StringList);

implementation

function beref_from_sl( sl: TBatpro_StringList; Index: Integer): Tberef;
begin
     _Classe_from_sl( Result, Tberef, sl, Index);
end;

procedure Cree_Reference( slCible, slSource: TBatpro_StringList);
var
   I: Integer;
   be: TBatpro_Element;
   beref: Tberef;
begin
     Vide_StringList( slCible);

     for I:= 0 to slSource.Count - 1
     do
       begin
       be:= Batpro_Element_from_sl( slSource, I);
       beref:= Tberef.Create( slCible, be);
       slCible.AddObject( beref.sCle, beref);
       end;
end;

procedure Cree_Reference_Cluster( slCibleReference, slCible, slSource: TBatpro_StringList);
var
   I: Integer;
   be_Source, be_Source_Reference, Old_be_Source_Reference: TBatpro_Element;
   bece_Source, bece_Cible: TbeClusterElement;
   beref_Cible, beref_CibleReference, Old_beref_CibleReference: Tberef;
begin
     Vide_StringList( slCibleReference);
     Vide_StringList( slCible         );
     Old_be_Source_Reference := nil;
     Old_beref_CibleReference:= nil;

     for I:= 0 to slSource.Count - 1
     do
       begin
       be_Source:= Batpro_Element_from_sl( slSource, I);
            if be_Source = nil
       then
           slCible.AddObject( slSource[I], nil)
       else if be_Source is TbeClusterElement
       then
           begin
           bece_Source:= TbeClusterElement( be_Source);
           be_Source_Reference:= bece_Source.beCluster;
           if Old_be_Source_Reference = be_Source_Reference
           then
               beref_CibleReference:= Old_beref_CibleReference
           else
               begin
               beref_CibleReference:= Tberef.Create( slCibleReference,
                                                     be_Source_Reference);
               slCibleReference.AddObject( beref_CibleReference.sCle,
                                           beref_CibleReference     );
               beref_CibleReference.Cree_Cluster;
               end;

           bece_Cible:= TbeClusterElement.Create( slCible, beref_CibleReference);
           slCible.AddObject( bece_Cible.sCle,
                              bece_Cible);

           Old_be_Source_Reference := be_Source_Reference ;
           Old_beref_CibleReference:= beref_CibleReference;
           end
       else
           begin
           beref_Cible:= Tberef.Create( slCible, be_Source);
           slCible.AddObject( beref_Cible.sCle, beref_Cible);
           end;
       end;
end;

{ Tberef }

constructor Tberef.Create( un_sl: TBatpro_StringList; _ref: TBatpro_Element);
var
   CP: IblG_BECP;
begin
     ref:= _ref;
     if ref = nil
     then
         begin
         fAccueil_Erreur( 'Erreur à signaler au développeur: '+
                          'Tberef.Create: la référence fournie est à nil');
         exit;
         end;

     CP:= Init_ClassParams;
     if Assigned( CP)
     then
         begin
         CP.Titre:= 'Référence à un <'+ref.ClassParams.Titre+'>';
         {$IFDEF MSWINDOWS}
         CP.Font.Name:= ref.ClassParams.Font.Name;
         CP.Font.Size:= ref.ClassParams.Font.Size;
         {$ENDIF}
         end;

     inherited Create( un_sl);

     Fond:= ref.Fond;
end;

function Tberef.Contenu( Contexte: Integer; Col, Row: Integer): String;
begin
     Result:= ref.Contenu( Contexte, Col, Row);
end;

function Tberef.Get_Alignement( Contexte: Integer): TbeAlignement;
begin
     Result:= ref.Get_Alignement( Contexte);
end;

function Tberef.GetCell( Contexte: Integer): String;
begin
     Result:= ref.Cell[ Contexte];
end;

function Tberef.sCle: String;
begin
     Result:= ref.sCle;
end;

procedure Tberef.Draw(DrawInfo: TDrawInfo);
begin
     ref.Draw( DrawInfo);
end;

procedure Tberef.svgDraw(DrawInfo: TDrawInfo);
begin
     ref.svgDraw( DrawInfo);
end;

function Tberef.Draw_Text(DrawInfo: TDrawInfo; Alignement: TbeAlignement;
  Text: String; Font: TFont): Integer;
begin
     Result:= ref.Draw_Text( DrawInfo, Alignement, Text, Font);
end;

function Tberef.Cell_Height( DrawInfo: TDrawInfo; Cell_Width: Integer): Integer;
begin
     Result:= ref.Cell_Height( DrawInfo, Cell_Width);
end;

function Tberef.Cell_Width( DrawInfo: TDrawInfo): Integer;
begin
     Result:= ref.Cell_Width( DrawInfo);
end;

procedure Tberef.SetSelected(Value: Boolean);
begin
     inherited;
     ref.Selected:= Value;
end;

end.
