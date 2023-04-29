unit ufTestChampGrid;
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
  Windows, Messages, SysUtils, Variants, Classes, FMX.Graphicso, FMX.Controls, FMX.Forms,
  FMX.Dialogs,
    uBatpro_StringList,
  ufpBas, Grids, ucChampsGrid, FMX.ActnList, FMX.StdCtrls, FMX.ComCtrls, Buttons,
  FMX.ExtCtrls, FMX.Menus;

type
 TfTestChampGrid
 =
  class( TfpBas)
    cg: TChampsGrid;
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
    function Execute( sl: TBatpro_StringList; _Titre: String=''): Boolean; reintroduce;
  end;

function fTestChampGrid: TfTestChampGrid;

implementation

uses
    uClean;

{$R *.fmx}

var
   FfTestChampGrid: TfTestChampGrid;

function fTestChampGrid: TfTestChampGrid;
begin
     Clean_Get( Result, FfTestChampGrid, TfTestChampGrid);
end;

{ TfTestChampGrid }

function TfTestChampGrid.Execute(sl: TBatpro_StringList; _Titre: String=''): Boolean;
begin
     if _Titre = ''
     then
         Caption:= 'fTestChampGrid'
     else
         Caption:= _Titre;
     try
        cg.sl:= sl;
        Result:= inherited Execute;
     finally
            cg.sl:= nil;
            end;
end;

initialization
              Clean_Create ( FfTestChampGrid, TfTestChampGrid);
finalization
              Clean_Destroy( FfTestChampGrid);
end.
