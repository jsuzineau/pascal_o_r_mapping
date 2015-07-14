unit ufTAG_DEVELOPMENT;
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
 TfTAG_DEVELOPMENT
 =
  class(TfBase)
    procedure FormCreate(Sender: TObject);
    procedure bImprimerClick(Sender: TObject);
  public
    { Déclarations publiques }
    function Execute: Boolean; override;
  end;

function fTAG_DEVELOPMENT: TfTAG_DEVELOPMENT;

implementation

uses
    uClean,

    upoolTAG_DEVELOPMENT, uPool;

{$R *.dfm}

var
   FfTAG_DEVELOPMENT: TfTAG_DEVELOPMENT;

function fTAG_DEVELOPMENT: TfTAG_DEVELOPMENT;
begin
     Clean_Get( Result, FfTAG_DEVELOPMENT, TfTAG_DEVELOPMENT);
end;

{ TfTAG_DEVELOPMENT }

procedure TfTAG_DEVELOPMENT.FormCreate(Sender: TObject);
begin
     pool:= poolTAG_DEVELOPMENT;
     inherited;
end;

function TfTAG_DEVELOPMENT.Execute: Boolean;
begin
     try
        //f_Execute_Before_Key
        _from_pool;
        Result:= inherited Execute;
     finally
            //f_Execute_After_Key
            end;
end;

procedure TfTAG_DEVELOPMENT.bImprimerClick(Sender: TObject);
begin
     Batpro_Ligne_Printer.Execute( 'fTAG_DEVELOPMENT.stw',
                                   'TAG_DEVELOPMENT',[],[],[],[],
                                   ['TAG_DEVELOPMENT'],
                                   [poolTAG_DEVELOPMENT.slFiltre],
                                   [ nil],
                                   [ nil]);
end;

initialization
              Clean_Create ( FfTAG_DEVELOPMENT, TfTAG_DEVELOPMENT);
finalization
              Clean_Destroy( FfTAG_DEVELOPMENT);
end.
