unit ufSession_dsb;
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
    uDataUtilsU,
    ufpBas,
    ufBase_dsb,
    //uBatpro_Ligne_Printer,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DBCtrls, Grids, DBGrids, ActnList, StdCtrls, ComCtrls, Buttons,
  ExtCtrls, DB;

type
 TfSession_dsb
 =
  class(TfBase_dsb)
    procedure FormCreate(Sender: TObject);
    procedure bImprimerClick(Sender: TObject);
  public
    { D�clarations publiques }
    function Execute: Boolean; override;
  end;

function fSession_dsb: TfSession_dsb;

implementation

uses
    uClean,
{f_implementation_uses_key}
    upoolSession, uPool;

{$R *.lfm}

var
   FfSession_dsb: TfSession_dsb;

function fSession_dsb: TfSession_dsb;
begin
     Clean_Get( Result, FfSession_dsb, TfSession_dsb);
end;

{ TfSession_dsb }

procedure TfSession_dsb.FormCreate(Sender: TObject);
begin
     pool:= poolSession;
     inherited;
end;

function TfSession_dsb.Execute: Boolean;
begin
     try
        //f_Execute_Before_Key
        _from_pool;
        Result:= inherited Execute;
     finally
            //f_Execute_After_Key
            end;
end;

procedure TfSession_dsb.bImprimerClick(Sender: TObject);
begin
     {
     Batpro_Ligne_Printer.Execute( 'fSession_dsb.stw',
                                   'Session',[],[],[],[],
                                   ['Session'],
                                   [poolSession.slFiltre],
                                   [ nil],
                                   [ nil]);
     }
end;

initialization
              Clean_Create ( FfSession_dsb, TfSession_dsb);
finalization
              Clean_Destroy( FfSession_dsb);
end.