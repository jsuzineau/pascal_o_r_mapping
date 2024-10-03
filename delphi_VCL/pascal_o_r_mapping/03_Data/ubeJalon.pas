unit ubeJalon;
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
    uSVG,
    uDrawInfo,
    uBatpro_Element,
    uContextes,
    uVide,
  {$IFDEF MSWINDOWS}
  Windows, VCL.Graphics, VCL.Controls, System.UITypes,
  {$ENDIF}
  SysUtils, Classes;

type
 TbeJalon
 =
  class( TBatpro_Element)
  public
    Forme: TTypeJalon;
    CouleurJalon: TColor;
    CouleurJalon_Contour : TColor;
    constructor Create( un_sl: TBatpro_StringList;
                        _Forme: TTypeJalon;
                        _CouleurJalon: TColor;
                        _CouleurJalon_Contour : TColor= clBlack);
    procedure Draw(DrawInfo: TDrawInfo); override;
    function Cell_Width( DrawInfo: TDrawInfo): Integer; override;
  //Affichage SVG
  public
    procedure svgDraw( DrawInfo: TDrawInfo); override;
  end;

function beJalon_from_sl( sl: TBatpro_StringList; Index: Integer): TbeJalon;

implementation

uses
    ufAccueil_Erreur;

function beJalon_from_sl( sl: TBatpro_StringList; Index: Integer): TbeJalon;
begin
     _Classe_from_sl( Result, TbeJalon, sl, Index);
end;

{ TbeJalon }

constructor TbeJalon.Create( un_sl: TBatpro_StringList;
                             _Forme               : TTypeJalon;
                             _CouleurJalon        : TColor;
                             _CouleurJalon_Contour: TColor= clBlack);
var
   CP: IblG_BECP;
begin
     CP:= Init_ClassParams;
     if Assigned( CP)
     then
         begin
         CP.Titre:= 'Jalon isolé';
         end;

     inherited Create( un_sl);

     Forme               := _Forme               ;
     CouleurJalon        := _CouleurJalon        ;
     CouleurJalon_Contour:= _CouleurJalon_Contour;


end;

procedure TbeJalon.Draw( DrawInfo: TDrawInfo);
begin
     DrawJalon( DrawInfo, Forme, CouleurJalon, CouleurJalon_Contour);
end;

procedure TbeJalon.svgDraw( DrawInfo: TDrawInfo);
begin
     {svg}Draw( DrawInfo);
end;

function TbeJalon.Cell_Width( DrawInfo: TDrawInfo): Integer;
begin
     //Result:= inherited Cell_Width( DrawInfo);
     //Result:= 42;
     Result:= 14;
end;

end.
