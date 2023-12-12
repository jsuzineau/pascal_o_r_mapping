unit ufPatternMainMenu_dsb;
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            http://www.mars42.com                                               |
                                                                                |
    Copyright 2022 Jean SUZINEAU - MARS42                                       |
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
    along with this program.  If not, see <http://www.gnu.org/licenses/>. 1     |
                                                                                |
|                                                                               }

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ActnList, StdCtrls, ComCtrls, Buttons, ExtCtrls,
//pattern_Pascal_ufPatternMainMenu_dsb_uses
  uClean;

type
 TfPatternMainMenu_dsb
 =
  class(TForm)
    mm: TMainMenu;
    miBase: TMenuItem;
    miVide: TMenuItem;
    miRelations: TMenuItem;
    miRelationVide: TMenuItem;
    miBaseCalcule: TMenuItem;
    miBaseCalculeVide: TMenuItem;
    miRelationsCalcule: TMenuItem;
    miRelationsCalculeVide: TMenuItem;
    procedure FormCreate(Sender: TObject);
//pattern_Pascal_ufPatternMainMenu_dsb_methods_declaration
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

function fPatternMainMenu_dsb: TfPatternMainMenu_dsb;

implementation

{$R *.lfm}

var
   FfPatternMainMenu_dsb: TfPatternMainMenu_dsb;

function fPatternMainMenu_dsb: TfPatternMainMenu_dsb;
begin
     Clean_Get( Result, FfPatternMainMenu_dsb, TfPatternMainMenu_dsb);
end;

{ TfPatternMainMenu_dsb }

procedure TfPatternMainMenu_dsb.FormCreate(Sender: TObject);
begin
     inherited;
     miVide        .Visible:= False;
     miRelationVide.Visible:= False;
     miBaseCalculeVide     .Visible:= False;
     miRelationsCalculeVide.Visible:= False;
end;

//pattern_Pascal_ufPatternMainMenu_dsb_methods_implementation

initialization
              Clean_Create ( FfPatternMainMenu_dsb, TfPatternMainMenu_dsb);
finalization
              Clean_Destroy( FfPatternMainMenu_dsb);
end.

