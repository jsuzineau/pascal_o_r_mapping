unit ufTag_Development;
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
 TfTag_Development
 =
  class(TfBase)
    procedure FormCreate(Sender: TObject);
    procedure bImprimerClick(Sender: TObject);
  public
    { Déclarations publiques }
    function Execute: Boolean; override;
  end;

function fTag_Development: TfTag_Development;

implementation

uses
    uClean,

    upoolTag_Development, uPool;

{$R *.dfm}

var
   FfTag_Development: TfTag_Development;

function fTag_Development: TfTag_Development;
begin
     Clean_Get( Result, FfTag_Development, TfTag_Development);
end;

{ TfTag_Development }

procedure TfTag_Development.FormCreate(Sender: TObject);
begin
     pool:= poolTag_Development;
     inherited;
end;

function TfTag_Development.Execute: Boolean;
begin
     try
        //f_Execute_Before_Key
        _from_pool;
        Result:= inherited Execute;
     finally
            //f_Execute_After_Key
            end;
end;

procedure TfTag_Development.bImprimerClick(Sender: TObject);
begin
     Batpro_Ligne_Printer.Execute( 'fTag_Development.stw',
                                   'Tag_Development',[],[],[],[],
                                   ['Tag_Development'],
                                   [poolTag_Development.slFiltre],
                                   [ nil],
                                   [ nil]);
end;

initialization
              Clean_Create ( FfTag_Development, TfTag_Development);
finalization
              Clean_Destroy( FfTag_Development);
end.
