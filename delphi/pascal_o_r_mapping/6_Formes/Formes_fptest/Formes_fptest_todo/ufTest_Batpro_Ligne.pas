unit ufTest_Batpro_Ligne;
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
    Windows, Messages, SysUtils, Variants, Classes, FMX.Graphics, FMX.Controls, FMX.Forms,
    FMX.Dialogs, Spin, FMX.StdCtrls, FMX.ActnList, FMX.ComCtrls, Buttons, FMX.ExtCtrls,
    uClean,
    ucChamp_Integer_SpinEdit,
    ucChamp_Edit,
    ucChamp_Lookup_ComboBox,
    ufpBas,
    uBatpro_Ligne,
    ublTest_Batpro_Ligne;

type
 TfTest_Batpro_Ligne
 =
  class( TfpBas)
    clkcb: TChamp_Lookup_ComboBox;
    ce: TChamp_Edit;
    cise: TChamp_Integer_SpinEdit;
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
    function Execute( bl: TblTest_Batpro_Ligne): Boolean; reintroduce;
  end;

function fTest_Batpro_Ligne: TfTest_Batpro_Ligne;

implementation

{$R *.dfm}

var
   FfTest_Batpro_Ligne: TfTest_Batpro_Ligne;

function fTest_Batpro_Ligne: TfTest_Batpro_Ligne;
begin
     Clean_Get( Result, FfTest_Batpro_Ligne, TfTest_Batpro_Ligne);
end;

{ TfTest_Batpro_Ligne }

function TfTest_Batpro_Ligne.Execute( bl: TblTest_Batpro_Ligne): Boolean;
begin
     //clkcb.Champ:= bl.
     ce  .Champs:= bl.Champs;
     cise.Champs:= bl.Champs;

     Result:= inherited Execute;

     ce  .Champs:= nil;
     cise.Champs:= nil;
end;

initialization
              Clean_Create ( FfTest_Batpro_Ligne, TfTest_Batpro_Ligne);
finalization
              Clean_Destroy( FfTest_Batpro_Ligne);
end.
