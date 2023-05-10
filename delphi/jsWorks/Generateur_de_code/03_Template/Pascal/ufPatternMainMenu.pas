unit ufPatternMainMenu;
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
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ActnList, StdCtrls, ComCtrls, Buttons, ExtCtrls,
  {Uses_Key}
  uClean;

type
 TfPatternMainMenu
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
    {Declaration_Key}
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

function fPatternMainMenu: TfPatternMainMenu;

implementation

{$R *.dfm}

var
   FfPatternMainMenu: TfPatternMainMenu;

function fPatternMainMenu: TfPatternMainMenu;
begin
     Clean_Get( Result, FfPatternMainMenu, TfPatternMainMenu);
end;

{ TfPatternMainMenu }

procedure TfPatternMainMenu.FormCreate(Sender: TObject);
begin
     inherited;
     miVide        .Visible:= False;
     miRelationVide.Visible:= False;
     miBaseCalculeVide     .Visible:= False;
     miRelationsCalculeVide.Visible:= False;
end;

{Implementation_Key}

initialization
              Clean_Create ( FfPatternMainMenu, TfPatternMainMenu);
finalization
              Clean_Destroy( FfPatternMainMenu);
end.

