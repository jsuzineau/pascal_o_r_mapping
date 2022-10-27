unit ufSession_cg;
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
 TfSession_cg
 =
  class(TfBase)
    procedure FormCreate(Sender: TObject);
    procedure bImprimerClick(Sender: TObject);
  public
    { Déclarations publiques }
    function Execute: Boolean; override;
  end;

function fSession_cg: TfSession_cg;

implementation

uses
    uClean,
{f_implementation_uses_key}
    upoolSession, uPool;

{$R *.dfm}

var
   FfSession_cg: TfSession_cg;

function fSession_cg: TfSession_cg;
begin
     Clean_Get( Result, FfSession_cg, TfSession_cg);
end;

{ TfSession_cg }

procedure TfSession_cg.FormCreate(Sender: TObject);
begin
     pool:= poolSession;
     inherited;
end;

function TfSession_cg.Execute: Boolean;
begin
     try
        //f_Execute_Before_Key
        _from_pool;
        Result:= inherited Execute;
     finally
            //f_Execute_After_Key
            end;
end;

procedure TfSession_cg.bImprimerClick(Sender: TObject);
begin
     Batpro_Ligne_Printer.Execute( 'fSession_cg.stw',
                                   'Session',[],[],[],[],
                                   ['Session'],
                                   [poolSession.slFiltre],
                                   [ nil],
                                   [ nil]);
end;

initialization
              Clean_Create ( FfSession_cg, TfSession_cg);
finalization
              Clean_Destroy( FfSession_cg);
end.
