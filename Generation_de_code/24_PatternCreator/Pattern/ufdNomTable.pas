unit ufdNomTable;
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
    uClean,
    uBatpro_StringList,
    u_sys_,
    uChamps,
    uPublieur,

    ublNomTable,

    upoolNomTable,

    ufBatpro_Form,
    ufpBas,

  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ActnList, StdCtrls, ComCtrls, Buttons, ExtCtrls, ucChamp_Edit,
  ucBatproMasque, ucbmAFFAIRE, ucChamp_Label,
  ucChamp_Lookup_ComboBox, ucDockableScrollbox, ucChamp_Memo, Menus;

type
 TfdNomTable
 =
  class(TfpBas)
    Panel1: TPanel;
    lNomChamp: TLabel;
    ceNomChamp: TChamp_Edit;
    {JoinPoint_LabelsPAS}
    {JoinPoint_Champ_EditPAS}
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  //Méthodes
  public
    function Execute( var _bl: TblNomTable): Boolean; reintroduce;
  //bl
  private
    Fbl: TblNomTable;
    procedure Setbl(const Value: TblNomTable);
  public
    property bl: TblNomTable read Fbl write Setbl;
  end;

function  fdNomTable: TfdNomTable;

implementation

{$R *.dfm}

var
   FfdNomTable: TfdNomTable;

function  fdNomTable: TfdNomTable;
begin
     Clean_Get( Result, FfdNomTable, TfdNomTable);
end;

{ TfdNomTable }

procedure TfdNomTable.FormCreate(Sender: TObject);
begin
     inherited;
     Maximiser:= False;
     Fbl:= nil;
end;

procedure TfdNomTable.FormDestroy(Sender: TObject);
begin
     //
     inherited;
end;

function TfdNomTable.Execute( var _bl: TblNomTable): Boolean;
begin
     bl:= _bl;

     Result:= inherited Execute;

     if Result
     then
         _bl:= bl;
end;

procedure TfdNomTable.Setbl(const Value: TblNomTable);
begin
     Fbl:= Value;

     Champs_Affecte( bl,
                     [
                     ]);
end;

initialization
              Clean_Create ( FfdNomTable, TfdNomTable);
finalization
              Clean_Destroy( FfdNomTable);
end.
