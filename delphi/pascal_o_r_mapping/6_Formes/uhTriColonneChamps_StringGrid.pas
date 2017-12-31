unit uhTriColonneChamps_StringGrid;
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
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, FMTBcd, DB, Provider, DBClient, SqlExpr, Grids, DBGrids, StdCtrls,
    uClean,
    u_sys_,
    uuStrings,
    uDataUtilsU,
    uChampDefinition,
    uPool;

type
 ThTriColonneChamps_StringGrid__NomChamp_from_Col
 =
  function ( _Col: Integer): String of object;

 ThTriColonneChamps_StringGrid
 =
  class
  //Gestion du cycle de vie
  public
    constructor Create( _sg: TStringGrid; _pool: TPool; _l: TLabel= nil);
    destructor Destroy; override;
  //Attributs
  protected
    sg: TStringGrid;
    pool: TPool;
    l: TLabel;
  public
    NomChamp_from_Col: ThTriColonneChamps_StringGrid__NomChamp_from_Col;
  //Méthodes
  public
    procedure Reset;
  //Évènements de grille
  private
    LastShift: TShiftState;
    Old_sgMouseDown: TMouseEvent;
    Old_sgSelectCell: TSelectCellEvent;
  protected
    procedure sgMouseDown( Sender: TObject; Button: TMouseButton;
                            Shift: TShiftState; X, Y: Integer);
    procedure sgSelectCell(Sender:TObject;ACol,ARow:Longint;var CanSelect:Boolean);
  end;

implementation

{ ThTriColonneChamps_StringGrid }

constructor ThTriColonneChamps_StringGrid.Create( _sg: TStringGrid; _pool: TPool;
                                       _l: TLabel= nil);
begin
     sg  := _sg;
     pool:= _pool;
     l := _l;
     NomChamp_from_Col:= nil;

     Old_sgMouseDown:= sg.OnMouseDown;
     sg.OnMouseDown:= sgMouseDown;

     Old_sgSelectCell:= sg.OnSelectCell;
     sg.OnSelectCell:= sgSelectCell;
end;

destructor ThTriColonneChamps_StringGrid.Destroy;
begin
     sg.OnSelectCell:= nil;
     inherited;
end;

procedure ThTriColonneChamps_StringGrid.sgMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
     LastShift:= Shift;
     if Assigned(Old_sgMouseDown)
     then
         Old_sgMouseDown( Sender, Button, Shift, X, Y);
end;

procedure ThTriColonneChamps_StringGrid.sgSelectCell( Sender: TObject; ACol, ARow: Integer; var CanSelect: Boolean);
var
   NomChamp: String;
   procedure AjouteChamp( Reset: Boolean);
   var
      OldCroissant, NewCroissant: Integer;
   begin
        OldCroissant:= pool.ChampTri[NomChamp];
        case OldCroissant
        of
          0:   NewCroissant:= 1;
          else NewCroissant:= - OldCroissant;
          end;
        if Reset
        then
            pool.Reset_ChampsTri;

        pool.ChampTri[ NomChamp]:= NewCroissant;
   end;
begin
     try
        if pool               = nil then exit;
        if @NomChamp_from_Col = nil then exit;

        NomChamp:= NomChamp_from_Col( ACol);

        AjouteChamp( not (ssShift in LastShift));

        sg.Cells[ACol,0]:= pool.LibelleChampTri( NomChamp);

        if l = nil then exit;
        l.Visible:= True;
        l.Caption:= 'Tri par '+ pool.LibelleTri+
                    ' (Majuscule + Clic pour ajouter des colonnes)';
     finally
            if Assigned(Old_sgSelectCell)
            then
                Old_sgSelectCell( Sender, ACol, ARow, CanSelect);
            end;
end;

procedure ThTriColonneChamps_StringGrid.Reset;
begin
     pool.Reset_ChampsTri;
     if Assigned( l)
     then
         begin
         l.Visible:= True;
         l.Caption:= 'Aucun tri';
         end;
end;

end.
