unit ufcbg_ctr;
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
  Dialogs, DB, StdCtrls, Buttons, ExtCtrls, Grids, DBGrids,
  ufcbBase;

type
 Tfcbg_ctr
 =
  class(TfcbBase)
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

function fcbg_ctr: Tfcbg_ctr;

function Derouleg_ctr( E: TObject; Resultat: TIntegerField):Boolean;

implementation

uses
    uClean,
    upoolg_ctr,
    ufg_ctr;

{$R *.dfm}

var
   Ffcbg_ctr: Tfcbg_ctr;

function fcbg_ctr: Tfcbg_ctr;
begin
     Clean_Get( Result, Ffcbg_ctr, Tfcbg_ctr);
end;

var
   Filtreg_ctr: String = '';

function Derouleg_ctr(E: TObject; Resultat: TIntegerField): Boolean;
begin
     fcbg_ctr.eFiltre.Text:= Filtreg_ctr;
//     Result
//     :=
//       fcbg_ctr.DerouleListe( E, dmag_ctr.ds, fg_ctr.Execute,
//                                 Resultat, dmag_ctr.qNumero);
     Filtreg_ctr:= fcbg_ctr.eFiltre.Text;
     Result:= False;
end;


initialization
              Clean_Create ( Ffcbg_ctr, Tfcbg_ctr);
finalization
              Clean_Destroy( Ffcbg_ctr);
end.
