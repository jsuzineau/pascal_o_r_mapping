unit ubeString;
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

    uClean,
    u_sys_,

    uDrawInfo,

    uBatpro_Element,
    Windows, SysUtils, Classes, VCL.Graphics, VCL.Controls,
    System.UITypes;

type
 TbeString
 =
  class( TBatpro_Element)
  private
    bCustomFont: Boolean;
    CustomFont: TFont;
    FontName : String;
    FontSize : Integer;
    FontStyle: TFontStyles;
  public
    beAlignement: TbeAlignement;
    S: String;
    Orientation: Integer;
    constructor Create( un_sl: TBatpro_StringList; unS: String; un_Fond: TColor;
                        H: TbeAlignementH; _Orientation: Integer= 0);
    destructor Destroy; override;
    function GetCell(Contexte: Integer): String; override;
    function Get_Alignement(Contexte: Integer): TbeAlignement; override;
    function OrientationTexte( DrawInfo: TDrawInfo): Integer; override;
    function ClassFont(DrawInfo: TDrawInfo): TFont; override;
    procedure SetFont(_FontName:String;_FontSize:Integer;_FontStyle:TFontStyles);
  //Gestion de la clé
  public
    function sCle: String; override;
  end;

function beString_from_sl( sl: TBatpro_StringList; Index: Integer): TbeString;

implementation

function beString_from_sl( sl: TBatpro_StringList; Index: Integer): TbeString;
begin
     _Classe_from_sl( Result, TbeString, sl, Index);
end;

constructor TbeString.Create( un_sl: TBatpro_StringList; unS: String; un_Fond: TColor;
                              H: TbeAlignementH; _Orientation: Integer= 0);
var
   CP: IblG_BECP;
begin
     CP:= Init_ClassParams;
     if Assigned( CP)
     then
         begin
         CP.Titre:= 'Chaine de caractères';
         CP.Font.Name:= sys_Courier_New;
         CP.Font.Size:= 8;
         with CP.Font do Style:= Style + [fsBold];
         end;

     inherited Create( un_sl);

     S:= unS;

     Fond:= un_Fond;
     beAlignement.H:= H;
     beAlignement.V:= bea_Centre_Vertic;
     Orientation:= _Orientation;

     CustomFont:= nil;
     bCustomFont:= False;
     FontName:= sys_Vide;
     FontSize:= 0;
end;

procedure TbeString.SetFont( _FontName : String     ;
                             _FontSize : Integer    ;
                             _FontStyle: TFontStyles);
begin
     bCustomFont:= True;
     FontName := _FontName ;
     FontSize := _FontSize ;
     FontStyle:= _FontStyle;
end;

function TbeString.ClassFont(DrawInfo: TDrawInfo): TFont;
begin
     if bCustomFont
     then
         begin
         if CustomFont = nil
         then
             CustomFont:= TFont.Create;
         CustomFont.Assign( inherited ClassFont( DrawInfo));

         if FontName <> sys_Vide then CustomFont.Name := FontName;
         if FontSize <> 0        then CustomFont.Size := FontSize;
         CustomFont.Style:= FontStyle;

         Result:= CustomFont;
         end
     else
         Result:= inherited ClassFont( DrawInfo);
end;

function TbeString.GetCell( Contexte: Integer): String;
begin
     Result:= S;
end;

function TbeString.Get_Alignement(Contexte: Integer): TbeAlignement;
begin
     Result:= beAlignement;
end;

function TbeString.OrientationTexte( DrawInfo: TDrawInfo): Integer;
begin
     Result:= Orientation;
end;

destructor TbeString.Destroy;
begin
     Free_nil( CustomFont);
     inherited;
end;

function TbeString.sCle: String;
begin
     Result:= S;
end;

end.
