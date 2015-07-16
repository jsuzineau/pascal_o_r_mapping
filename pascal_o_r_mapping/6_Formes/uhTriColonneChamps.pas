unit uhTriColonneChamps;
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
    uForms,
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, FMTBcd, DB, BufDataset, SQLDB, Grids, DBGrids, StdCtrls,
    uClean,
    u_sys_,
    uuStrings,
    uDataUtilsU,
    ucChampsGrid,
    uChampDefinition,
    uPool;

type
 ThTriColonneChamps
 =
  class
  protected
    LastShift: TShiftState;
    cg: TChampsGrid;
    pool: TPool;
    l: TLabel;
    procedure cgMouseDown( Sender: TObject; Button: TMouseButton;
                            Shift: TShiftState; X, Y: Integer);
    procedure cgSelectCell(Sender:TObject;ACol,ARow:Longint;var CanSelect:Boolean);
    procedure Retablit_Titres;
  public
    OnSelectCell: TOnSelectCellEvent;
    OnMouseDown: TMouseEvent;
    constructor Create( _cg: TChampsGrid; _pool: TPool; _l: TLabel= nil);
    destructor Destroy; override;
    procedure Reset;
    procedure Update_l;
  end;

implementation

{ ThTriColonneChamps }

constructor ThTriColonneChamps.Create( _cg: TChampsGrid; _pool: TPool;
                                       _l: TLabel= nil);
begin
     cg  := _cg;
     pool:= _pool;
     l := _l;
     OnSelectCell:= nil;

     if Assigned( cg.OnSelectCell)
     then
         uForms_ShowMessage( 'Erreur à signaler au développeur: ThTriColonneChamps.Create: '+
                      NamePath(cg)+'.OnSelectCell <> nil');
     cg.OnSelectCell:= cgSelectCell;

     if Assigned( cg.OnMouseDown)
     then
         uForms_ShowMessage( 'Erreur à signaler au développeur: ThTriColonneChamps.Create: '+
                      NamePath(cg)+'.OnMouseDown <> nil');
     cg.OnMouseDown:= cgMouseDown;
end;

destructor ThTriColonneChamps.Destroy;
begin
     Retablit_Titres;
     cg.OnSelectCell:= nil;
     inherited;
end;

procedure ThTriColonneChamps.cgMouseDown( Sender: TObject; Button: TMouseButton;
                                          Shift: TShiftState; X, Y: Integer);
var
   ARow, ACol: Integer;
   ChampDefinition: TChampDefinition;
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
            begin
            Retablit_Titres;
            pool.Reset_ChampsTri;
            end;

        pool.ChampTri[ NomChamp]:= NewCroissant;
   end;
begin
     LastShift:= Shift;

     //Gestion du tri
     cg.MouseToCell( X, Y, ACol, ARow);
     if ARow < cg.FixedRows
     then
         begin
         ChampDefinition:= cg.Definition( ACol);
         if Assigned( ChampDefinition)
         then
             begin
             NomChamp:= ChampDefinition.Nom;

             AjouteChamp( not (ssShift in LastShift));

             pool.TrierListe( cg.sl);
             cg.sl:= cg.sl;

             cg.Cells[ACol,0]:= pool.LibelleChampTri( NomChamp);

             if Assigned( l)
             then
                 begin
                 l.Visible:= True;
                 Update_l;
                 end;
             end;
         end;

     // Enchainement du  OnMouseDown
     if Assigned(OnMouseDown)
     then
         OnMouseDown( Sender, Button, Shift, X, Y);
end;

procedure ThTriColonneChamps.Retablit_Titres;
begin
     cg.Titres_from_Definitions;
end;

procedure ThTriColonneChamps.cgSelectCell( Sender: TObject; ACol, ARow: Integer; var CanSelect: Boolean);
begin
     if Assigned(OnSelectCell)
     then
         OnSelectCell( Sender, ACol, ARow, CanSelect);
end;

procedure ThTriColonneChamps.Reset;
begin
     Retablit_Titres;
     pool.Reset_ChampsTri;
     if Assigned( l)
     then
         begin
         l.Visible:= True;
         l.Caption:= 'Aucun tri';
         end;
end;

procedure ThTriColonneChamps.Update_l;
begin
     l.Caption:= 'Tri par '+ pool.LibelleTri+
                 ' (Majuscule + Clic pour ajouter des colonnes)';
end;

end.


