unit ubeCoche;
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
    uBatpro_StringList,
    u_sys_,
    u_loc_,
    uDataUtils,
    uuStrings,
    uDrawInfo,
    uBatpro_Element,
    uContextes,
    uVide,
    Windows, SysUtils, Classes, VCL.Graphics, VCL.Controls, System.UITypes;

type
 TbeCoche
 =
  class( TBatpro_Element)
  public
    ref: TBatpro_Element;
    constructor Create( un_sl: TBatpro_StringList; _ref: TBatpro_Element);
    procedure Draw(DrawInfo: TDrawInfo); override;
    function Cell_Width( DrawInfo: TDrawInfo): Integer; override;
  //Affichage SVG
  public
    procedure svgDraw( DrawInfo: TDrawInfo); override;
  end;

function beCoche_from_sl( sl: TBatpro_StringList; Index: Integer): TbeCoche;

procedure Cree_Coches( slCible, slSource: TBatpro_StringList);

implementation

uses
    ufAccueil_Erreur;

function beCoche_from_sl( sl: TBatpro_StringList; Index: Integer): TbeCoche;
begin
     _Classe_from_sl( Result, TbeCoche, sl, Index);
end;

procedure Cree_Coches( slCible, slSource: TBatpro_StringList);
var
   I: Integer;
   be: TBatpro_Element;
   beCoche: TbeCoche;
begin
     Vide_StringList( slCible);

     for I:= 0 to slSource.Count - 1
     do
       begin
       be:= Batpro_Element_from_sl( slSource, I);
       beCoche:= TbeCoche.Create( slCible, be);
       slCible.AddObject( beCoche.sCle, beCoche);
       end;
end;

{ TbeCoche }

constructor TbeCoche.Create( un_sl: TBatpro_StringList; _ref: TBatpro_Element);
var
   CP: IblG_BECP;
begin
     ref:= _ref;
     if ref = nil
     then
         begin
         fAccueil_Erreur( 'Erreur à signaler au développeur: '+
                          'TbeCoche.Create: la référence fournie est à nil');
         exit;
         end;

     CP:= Init_ClassParams;
     if Assigned( CP)
     then
         begin
         CP.Titre:= 'Coche de sélection';
         CP.Font.Name:= ref.ClassParams.Font.Name;
         CP.Font.Size:= ref.ClassParams.Font.Size;
         end;

     inherited Create( un_sl);
end;

procedure TbeCoche.Draw( DrawInfo: TDrawInfo);
begin
     Dessinne_Coche( DrawInfo.Canvas, Fond, clBlue, DrawInfo.Rect, ref.Selected);
end;

procedure TbeCoche.svgDraw( DrawInfo: TDrawInfo);
begin
     DrawInfo.svgDessinne_Coche( Fond, clBlue, ref.Selected);
end;

function TbeCoche.Cell_Width( DrawInfo: TDrawInfo): Integer;
begin
     Result:= 42;
end;

end.
