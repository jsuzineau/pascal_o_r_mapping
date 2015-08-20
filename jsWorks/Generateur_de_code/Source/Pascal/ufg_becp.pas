unit ufg_becp;
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
 Tfg_becp
 =
  class(TfBase)
    procedure FormCreate(Sender: TObject);
    procedure bImprimerClick(Sender: TObject);
  public
    { Déclarations publiques }
    function Execute: Boolean; override;
  end;

function fg_becp: Tfg_becp;

implementation

uses
    uClean,

    upoolg_becp, uPool;

{$R *.dfm}

var
   Ffg_becp: Tfg_becp;

function fg_becp: Tfg_becp;
begin
     Clean_Get( Result, Ffg_becp, Tfg_becp);
end;

{ Tfg_becp }

procedure Tfg_becp.FormCreate(Sender: TObject);
begin
     pool:= poolg_becp;
     inherited;
end;

function Tfg_becp.Execute: Boolean;
begin
     try
        //f_Execute_Before_Key
        _from_pool;
        Result:= inherited Execute;
     finally
            //f_Execute_After_Key
            end;
end;

procedure Tfg_becp.bImprimerClick(Sender: TObject);
begin
     Batpro_Ligne_Printer.Execute( 'fg_becp.stw',
                                   'g_becp',[],[],[],[],
                                   ['g_becp'],
                                   [poolg_becp.slFiltre],
                                   [ nil],
                                   [ nil]);
end;

initialization
              Clean_Create ( Ffg_becp, Tfg_becp);
finalization
              Clean_Destroy( Ffg_becp);
end.
