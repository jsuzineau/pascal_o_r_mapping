unit ubeCurseur;
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
    u_sys_,
    u_loc_,
    uDataUtils,
    uuStrings,
    uDrawInfo,
    uBatpro_Element,
    ubeClusterElement,
    uContextes,
    uVide,
    {$IFDEF WINDOWS_GRAPHIC}
    uDessin,
    {$ENDIF}
  SysUtils, Classes;

type
 TbeCurseur
 =
  class( TBatpro_Element)
  public
    constructor Create( un_sl: TBatpro_StringList);
    procedure {svg}Draw(DrawInfo: TDrawInfo); override;
    function Cell_Width( DrawInfo: TDrawInfo): Integer; override;
  //Affichage SVG
  public
    procedure svgDraw( DrawInfo: TDrawInfo); override;
  end;

function beCurseur_from_sl( sl: TBatpro_StringList; Index: Integer): TbeCurseur;

implementation

uses
    ufAccueil_Erreur;

function beCurseur_from_sl( sl: TBatpro_StringList; Index: Integer): TbeCurseur;
begin
     _Classe_from_sl( Result, TbeCurseur, sl, Index);
end;

{ TbeCurseur }

constructor TbeCurseur.Create( un_sl: TBatpro_StringList);
var
   CP: IblG_BECP;
begin
     CP:= Init_ClassParams;
     if Assigned( CP)
     then
         begin
         CP.Titre:= 'Curseur de sélection';
         end;

     inherited Create( un_sl);
end;

procedure TbeCurseur.Draw( DrawInfo: TDrawInfo);
begin
     {$IFDEF WINDOWS_GRAPHIC}
     DrawJalon( DrawInfo, tj_Triangle_vers_droite, clBlack);
     {$ENDIF}
end;

procedure TbeCurseur.svgDraw( DrawInfo: TDrawInfo);
begin
     {svg}Draw( DrawInfo);
end;

function TbeCurseur.Cell_Width( DrawInfo: TDrawInfo): Integer;
begin
     Result:= 14;
end;

end.
