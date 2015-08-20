unit ufg_ctr;
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
 Tfg_ctr
 =
  class(TfBase)
    procedure FormCreate(Sender: TObject);
    procedure bImprimerClick(Sender: TObject);
  public
    { Déclarations publiques }
    function Execute: Boolean; override;
  end;

function fg_ctr: Tfg_ctr;

implementation

uses
    uClean,

    upoolg_ctr, uPool;

{$R *.dfm}

var
   Ffg_ctr: Tfg_ctr;

function fg_ctr: Tfg_ctr;
begin
     Clean_Get( Result, Ffg_ctr, Tfg_ctr);
end;

{ Tfg_ctr }

procedure Tfg_ctr.FormCreate(Sender: TObject);
begin
     pool:= poolg_ctr;
     inherited;
end;

function Tfg_ctr.Execute: Boolean;
begin
     try
        //f_Execute_Before_Key
        _from_pool;
        Result:= inherited Execute;
     finally
            //f_Execute_After_Key
            end;
end;

procedure Tfg_ctr.bImprimerClick(Sender: TObject);
begin
     Batpro_Ligne_Printer.Execute( 'fg_ctr.stw',
                                   'g_ctr',[],[],[],[],
                                   ['g_ctr'],
                                   [poolg_ctr.slFiltre],
                                   [ nil],
                                   [ nil]);
end;

initialization
              Clean_Create ( Ffg_ctr, Tfg_ctr);
finalization
              Clean_Destroy( Ffg_ctr);
end.
