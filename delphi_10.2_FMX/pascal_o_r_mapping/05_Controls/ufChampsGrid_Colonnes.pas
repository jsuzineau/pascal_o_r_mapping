﻿unit ufChampsGrid_Colonnes;
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            partly as freelance: http://www.mars42.com                          |
        and partly as employee : http://www.adinfo.com                          |
                                 http://www.adi-bat.com                         |
    Copyright 2017 Jean SUZINEAU - MARS42                                       |
    Copyright 2017 GROUPE ADINFO SOFTWARE                                       |
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
  Windows, Messages, SysUtils, Variants, Classes, FMX.Graphics, FMX.Controls, FMX.Forms,
  FMX.Dialogs, FMX.Grid, FMX.StdCtrls, FMX.ExtCtrls, ucBitBtn, FMX.Memo, System.UITypes,
  FMX.ScrollBox, FMX.Types, FMX.Controls.Presentation;

type
 TfChampsGrid_Colonnes
 =
  class(TForm)
    Panel1: TPanel;
    bOK: TButton;
    bCancel: TButton;
    m: TMemo;
  // Méthodes
  public
    function Execute( sl: TBatpro_StringList): Boolean;
  end;

function fChampsGrid_Colonnes: TfChampsGrid_Colonnes;

implementation

{$R *.fmx}

var
   FfChampsGrid_Colonnes: TfChampsGrid_Colonnes;

function fChampsGrid_Colonnes: TfChampsGrid_Colonnes;
begin
     Clean_Get( Result, FfChampsGrid_Colonnes, TfChampsGrid_Colonnes);
end;

{ TfChampsGrid_Colonnes }

function TfChampsGrid_Colonnes.Execute( sl: TBatpro_StringList): Boolean;
begin
     m.Lines.Assign( sl);
     Result:= ShowModal = mrOK;
     if Result
     then
         sl.Assign( m.Lines);
end;

initialization
              Clean_Create ( FfChampsGrid_Colonnes, TfChampsGrid_Colonnes);
finalization
              Clean_Destroy( FfChampsGrid_Colonnes);
end.
