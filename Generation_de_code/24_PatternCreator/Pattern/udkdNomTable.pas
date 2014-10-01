unit udkdNomTable;
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
  Dialogs, DBCtrls, Grids, DBGrids, ActnList, StdCtrls, ComCtrls, Buttons,
  ExtCtrls, DB,
  uf,
  udkdBase;

type
 TdkdNomTable
 =
  class(TdkdBase)
    procedure dbgCellClick(Column: TColumn);
    procedure dbgKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure bImprimerClick(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

function dkdNomTable: TdkdNomTable;

implementation

uses
    uClean,
    uOOoDetailPrinter,
{dkd_implementation_uses_key}
    udmdNomTable;

{$R *.dfm}

var
   FdkdNomTable: TdkdNomTable;

function dkdNomTable: TdkdNomTable;
begin
     Clean_Get( Result, FdkdNomTable, TdkdNomTable);
end;

{ TdkdNomTable }

procedure TdkdNomTable.FormCreate(Sender: TObject);
begin
     dmd:= dmdNomTable;
     Nom:= 'NomTable';
     dbg.DataSource:= dmd.ds;
     dbn.DataSource:= dmd.ds;
     inherited;
end;

procedure TdkdNomTable.dbgCellClick(Column: TColumn);
begin
     inherited;
     //dkd_dbgCellClick_Key
end;

procedure TdkdNomTable.dbgKeyPress(Sender: TObject; var Key: Char);
//dkd_dbgKeyPress_Key_Variables
begin
     inherited;
     //dkd_dbgKeyPress_Key
end;

procedure TdkdNomTable.bImprimerClick(Sender: TObject);
var
   fLibelle: TField;
   sLibelle: String;
begin
     inherited;
     fLibelle:= dmt.t.FindField( 'Libelle');
     if Assigned( fLibelle)
     then
         sLibelle:= 'NomTable de '+fLibelle.DisplayText
     else
         sLibelle:= 'NomTable';
     OOoDetailPrinter.Execute( 'dkdNomTable.stw', sLibelle, [], [], dmt.t,dmdNomTable.t);
end;

initialization
              Clean_Create ( FdkdNomTable, TdkdNomTable);
finalization
              Clean_Destroy( FdkdNomTable);
end.
