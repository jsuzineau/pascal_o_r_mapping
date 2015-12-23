unit ufTULEAP_Project;
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
  ucChampsGrid,
  uDataUtilsU,
  ufpBas,
  ufBase,
  uBatpro_Ligne_Printer;

type
 TfTULEAP_Project
 =
  class(TfBase)
    procedure FormCreate(Sender: TObject);
    procedure bImprimerClick(Sender: TObject);
  public
    { Déclarations publiques }
    function Execute: Boolean; override;
  end;

function fTULEAP_Project: TfTULEAP_Project;

implementation

uses
    uClean,

    upoolTULEAP_Project, uPool;

{$R *.dfm}

var
   FfTULEAP_Project: TfTULEAP_Project;

function fTULEAP_Project: TfTULEAP_Project;
begin
     Clean_Get( Result, FfTULEAP_Project, TfTULEAP_Project);
end;

{ TfTULEAP_Project }

procedure TfTULEAP_Project.FormCreate(Sender: TObject);
begin
     pool:= poolTULEAP_Project;
     inherited;
end;

function TfTULEAP_Project.Execute: Boolean;
begin
     try
        //f_Execute_Before_Key
        _from_pool;
        Result:= inherited Execute;
     finally
            //f_Execute_After_Key
            end;
end;

procedure TfTULEAP_Project.bImprimerClick(Sender: TObject);
begin
     Batpro_Ligne_Printer.Execute( 'fTULEAP_Project.stw',
                                   'TULEAP_Project',[],[],[],[],
                                   ['TULEAP_Project'],
                                   [poolTULEAP_Project.slFiltre],
                                   [ nil],
                                   [ nil]);
end;

initialization
              Clean_Create ( FfTULEAP_Project, TfTULEAP_Project);
finalization
              Clean_Destroy( FfTULEAP_Project);
end.
