unit ubeSerie;
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
    uBatpro_Element,
  {$IFDEF MSWINDOWS}
  Graphics,
  {$ENDIF}
  SysUtils, Classes;

type
 TbeSerie
 =
  class( TBatpro_Element)
  //Gestion du cycle de vie
  public
    constructor Create( _sl: TBatpro_StringList; _Style: TStyleSerie);
  //Gestion du texte de cellule
  protected
    function GetCell(Contexte: Integer): String; override;
  end;

function beSerie_from_sl( sl: TBatpro_StringList; Index: Integer): TbeSerie;

implementation

function beSerie_from_sl( sl: TBatpro_StringList; Index: Integer): TbeSerie;
begin
     _Classe_from_sl( Result, TbeSerie, sl, Index);
end;

constructor TbeSerie.Create( _sl: TBatpro_StringList; _Style: TStyleSerie);
var
   CP: IblG_BECP;
begin
     CP:= Init_ClassParams;
     if Assigned( CP)
     then
         begin
         CP.Libelle:= 'classe Série générique';
         {$IFDEF MSWINDOWS}
         CP.Font.Name:= sys_SmallFonts;
         CP.Font.Size:= 6;
         with CP.Font do Style:= Style + [fsBold];
         {$ENDIF}
         end;

     inherited Create( _sl);
     Cree_Serie;
     Serie.Style:= _Style;
end;

function TbeSerie.GetCell(Contexte: Integer): String;
begin
     with Serie
     do
       Result:= IntToStr(Fin-Debut+1)+'j';
end;

end.
