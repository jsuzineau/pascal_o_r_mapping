unit ufNom_de_la_classe;
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            http://www.mars42.com                                               |
                                                                                |
    Copyright 2019 Jean SUZINEAU - MARS42                                       |
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
  ucChampsGrid,
  uDataUtilsU,
  ufpBas,
  ufBase,
  uBatpro_Ligne_Printer;

type
 TfNom_de_la_classe
 =
  class(TfBase)
    procedure FormCreate(Sender: TObject);
    procedure bImprimerClick(Sender: TObject);
  public
    { D�clarations publiques }
    function Execute: Boolean; override;
  end;

function fNom_de_la_classe: TfNom_de_la_classe;

implementation

uses
    uClean,
{f_implementation_uses_key}
    upoolNom_de_la_classe, uPool;

{$R *.dfm}

var
   FfNom_de_la_classe: TfNom_de_la_classe;

function fNom_de_la_classe: TfNom_de_la_classe;
begin
     Clean_Get( Result, FfNom_de_la_classe, TfNom_de_la_classe);
end;

{ TfNom_de_la_classe }

procedure TfNom_de_la_classe.FormCreate(Sender: TObject);
begin
     pool:= poolNom_de_la_classe;
     inherited;
end;

function TfNom_de_la_classe.Execute: Boolean;
begin
     try
        //f_Execute_Before_Key
        _from_pool;
        Result:= inherited Execute;
     finally
            //f_Execute_After_Key
            end;
end;

procedure TfNom_de_la_classe.bImprimerClick(Sender: TObject);
begin
     Batpro_Ligne_Printer.Execute( 'fNom_de_la_classe.stw',
                                   'Nom_de_la_classe',[],[],[],[],
                                   ['Nom_de_la_classe'],
                                   [poolNom_de_la_classe.slFiltre],
                                   [ nil],
                                   [ nil]);
end;

initialization
              Clean_Create ( FfNom_de_la_classe, TfNom_de_la_classe);
finalization
              Clean_Destroy( FfNom_de_la_classe);
end.
