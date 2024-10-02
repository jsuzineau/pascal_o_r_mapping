﻿unit ufcb;
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
  Windows, Messages, SysUtils, Classes, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs,
  FMX.Grid, FMX.ExtCtrls, DB, System.Types;

type
  Tfcb = class(TForm)
    dbg: TGrid;
    procedure dbgCellClick(Column: TColumn);
    procedure dbgKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Déclarations privées }
  public
    function Execute( C: TControl; DropDownRows: Integer;
                      ds: TDataSource; F: TField): Boolean;
    { Déclarations publiques }
  end;

function fcb: Tfcb;

implementation

uses
    uClean;

{$R *.fmx}

var
   Ffcb: Tfcb;

function fcb: Tfcb;
begin
     Clean_Get( Result, Ffcb, Tfcb);
end;

function Tfcb.Execute( C: TControl; DropDownRows: Integer;
                       ds: TDataSource; F: TField): Boolean;
var
   HauteurLigne: Single;
   Largeur, Hauteur: Single;
   WorkArea: TRect;
   P: TPointF;
   Colonne: TColumn;
   LargeurColonne: Integer;
begin
     // d'aprés code source de TDBGrid
     with dbg
     do
       begin
       HauteurLigne:= Canvas.TextHeight('Wg') + 3;
       {
       if dgRowLines in Options
       then
           Inc( HauteurLigne, 1(*GridLineWidth*));
       }
       end;

     Largeur:= C.Width;
     Hauteur:=   DropDownRows * HauteurLigne;

     SystemParametersInfo( SPI_GETWORKAREA, 0, @WorkArea, 0);

     //P:= C.Parent.ClientToScreen( PointF( C.Left, C.Top+C.Height));
     with P
     do
       begin
       if X < WorkArea.Left   then X:= WorkArea.Left          ;
       if X > WorkArea.Right  then X:= WorkArea.Right-Largeur ;
       if Y < WorkArea.Top    then Y:= WorkArea.Top           ;
       if Y > WorkArea.Bottom then Y:= WorkArea.Bottom-Hauteur;

       Left  := Trunc(X);
       Top   := Trunc(Y);
       Width := Trunc(Largeur);
       Height:= Trunc(Hauteur);
       end;

     {
     dbg.DataSource:= ds;
     dbg.ReadOnly:= True;

     dbg.Columns.Clear;
     Colonne:= dbg.Columns.Add;
     Colonne.Field:= F;
     LargeurColonne:= dbg.ClientWidth;
     Colonne.Width:= LargeurColonne;

     Result:= ShowModal = mrOK;

     dbg.Columns.Clear;
     dbg.DataSource:= nil;
     }
end;

procedure Tfcb.dbgCellClick(Column: TColumn);
begin
     //ModalResult:= mrOK;
end;

procedure Tfcb.dbgKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
     {
     if Key in [VK_RETURN, VK_ESCAPE]
     then
         ModalResult:= mrOK;
     }
end;

initialization
              Clean_CreateD( Ffcb, Tfcb);
finalization
              Clean_Destroy( Ffcb);
end.

