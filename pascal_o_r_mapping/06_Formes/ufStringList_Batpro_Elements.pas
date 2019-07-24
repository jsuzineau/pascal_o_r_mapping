unit ufStringList_Batpro_Elements;
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
  Dialogs,
    uBatpro_StringList,
  ufpBas, Grids, ActnList, StdCtrls, ComCtrls, Buttons, ExtCtrls,
  uhDessinnateur,
  uDataClasses,
  uVide, Menus;

type
 TfStringList_Batpro_Elements
 =
  class(TfpBas)
    sg: TStringGrid;
    sg0: TStringGrid;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
    hd: ThDessinnateur;
    hd0: ThDessinnateur;
    function Execute( sl: TBatpro_StringList): Boolean; reintroduce;
  end;

function fStringList_Batpro_Elements: TfStringList_Batpro_Elements;

implementation

uses
    uClean;

{$R *.dfm}

var
   FfStringList_Batpro_Elements: TfStringList_Batpro_Elements;

function fStringList_Batpro_Elements: TfStringList_Batpro_Elements;
begin
     Clean_Get( Result, FfStringList_Batpro_Elements, TfStringList_Batpro_Elements);
end;

{ TfStringList_Batpro_Elements }

procedure TfStringList_Batpro_Elements.FormCreate(Sender: TObject);
begin
     inherited;
     hd := ThDessinnateur.Create(-1,sg ,'', nil);
     hd0:= ThDessinnateur.Create( 0,sg0,'', nil);
     Maximiser:= False;
end;

procedure TfStringList_Batpro_Elements.FormDestroy(Sender: TObject);
begin
     Free_nil(hd0);
     Free_nil(hd );
     inherited;
end;

function TfStringList_Batpro_Elements.Execute( sl: TBatpro_StringList): Boolean;
begin
     sg .RowCount:= sl.Count;
     sg0.RowCount:= sl.Count;
     hd .Charge_Colonne( sl, 0, 0);
     hd0.Charge_Colonne( sl, 0, 0);
     hd.Traite_Dimensions;
     try
        Result:= inherited Execute;
     finally
            Vide_StringGrid( sg0);
            Vide_StringGrid( sg );
            end;
end;

initialization
              Clean_CreateD( FfStringList_Batpro_Elements, TfStringList_Batpro_Elements);
finalization
              Clean_Destroy( FfStringList_Batpro_Elements);
end.
