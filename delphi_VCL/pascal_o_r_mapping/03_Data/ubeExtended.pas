unit ubeExtended;
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
    uuStrings,
    uReels,
    uWindows,
    uWinUtils,
    u_sys_,
    u_sys_Batpro_Element,
    uDrawInfo,
    uBatpro_Element,
    Windows, SysUtils, Classes, VCL.Graphics, VCL.Controls, VCL.Dialogs, System.UITypes;

type
 TbeExtended
 =
  class( TBatpro_Element)
  public
    DisplayFormat: String;
    E: Extended;
    S: String;
    Align: TbeAlignement;
    constructor Create( un_sl: TBatpro_StringList; unDisplayFormat: String;
                        un_Fond: TColor);
    function GetCell( Contexte: Integer): String; override;
    procedure SetE( Value: Extended; _S: String= '');
    procedure Inc_E( Delta: Extended; _Delta_S: String= '');
    function Get_Alignement(Contexte: Integer): TbeAlignement; override;
    function sfE: String;
    function Cell_Width( DrawInfo: TDrawInfo): Integer; override;
  //Gestion du Hint
  public
    function Contenu( Contexte: Integer; Col, Row: Integer): String; override;
  end;

function beExtended_from_sl( sl: TBatpro_StringList; Index: Integer): TbeExtended;

function beExtended_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TbeExtended;

implementation

function beExtended_from_sl( sl: TBatpro_StringList; Index: Integer): TbeExtended;
begin
     _Classe_from_sl( Result, TbeExtended, sl, Index);
end;

function beExtended_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TbeExtended;
begin
     _Classe_from_sl_sCle( Result, TbeExtended, sl, sCle);
end;

constructor TbeExtended.Create( un_sl: TBatpro_StringList; unDisplayFormat: String;
                                un_Fond: TColor);
var
   CP: IblG_BECP;
begin
     CP:= Init_ClassParams;
     if Assigned( CP)
     then
         begin
         CP.Titre:= 'Valeur (nombre réel)';
         CP.Font.Name:= sys_SmallFonts;
         CP.Font.Size:= 6;
         end;

     inherited Create( un_sl);

     DisplayFormat:= unDisplayFormat;

     Fond:= un_Fond;
     E:= 0;
     S:= sys_Vide;

     Align.H:= bea_Centre_Horiz ;
     Align.V:= bea_Centre_Vertic;
end;

function TbeExtended.GetCell( Contexte: Integer): String;
begin
     if E = 0
     then
         Result:= ' '//sys_Vide
     else
         Result:= '  '+FormatFloat( DisplayFormat, E);
end;

procedure TbeExtended.SetE( Value: Extended; _S: String= '');
begin
     E:= Value;
     S:= _S;
     if Value < 0
     then
         Fond:= clRed
     else
         Fond:= clWhite;
end;

procedure TbeExtended.Inc_E( Delta: Extended; _Delta_S: String= '');
begin
     if not Reel_Zero( Delta)
     then
         begin
         if _Delta_S <> sys_Vide
         then
             _Delta_S:= Format('%4.0f', [Delta])+' '+_Delta_S;
         SetE( E + Delta, Formate_Liste([ S, _Delta_S], sys_N));
         end;
end;

function TbeExtended.Get_Alignement(Contexte: Integer): TbeAlignement;
begin
     Result:= Align;
end;

function TbeExtended.sfE: String;
begin
     Result:= sf_Millionieme( E);
end;

function TbeExtended.Cell_Width( DrawInfo: TDrawInfo): Integer;
begin
     Result:= inherited Cell_Width( DrawInfo);

     //pour test pb largeurs colonnes
     //bidouille rapide, à revoir, on enlève l'effet de Width_Externe_from_Interne
     //Result:= Result - 2*( CXEDGE + Batpro_Element_Marge);
end;

function TbeExtended.Contenu( Contexte, Col, Row: Integer): String;
begin
     Result:= inherited Contenu( Contexte, Col, Row);

     Result:= Formate_Liste([ Result, S], sys_N);
end;

end.
