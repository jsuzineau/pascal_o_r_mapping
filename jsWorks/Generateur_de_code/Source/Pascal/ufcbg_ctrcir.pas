unit ufcbg_ctrcir;
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
 Tfcbg_ctrcir
 =
  class(TfcbBase)
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

function fcbg_ctrcir: Tfcbg_ctrcir;

function Derouleg_ctrcir( E: TObject; Resultat: TIntegerField):Boolean;

implementation

uses
    uClean,
    upoolg_ctrcir,
    ufg_ctrcir;

{$R *.dfm}

var
   Ffcbg_ctrcir: Tfcbg_ctrcir;

function fcbg_ctrcir: Tfcbg_ctrcir;
begin
     Clean_Get( Result, Ffcbg_ctrcir, Tfcbg_ctrcir);
end;

var
   Filtreg_ctrcir: String = '';

function Derouleg_ctrcir(E: TObject; Resultat: TIntegerField): Boolean;
begin
     fcbg_ctrcir.eFiltre.Text:= Filtreg_ctrcir;
//     Result
//     :=
//       fcbg_ctrcir.DerouleListe( E, dmag_ctrcir.ds, fg_ctrcir.Execute,
//                                 Resultat, dmag_ctrcir.qNumero);
     Filtreg_ctrcir:= fcbg_ctrcir.eFiltre.Text;
     Result:= False;
end;


initialization
              Clean_Create ( Ffcbg_ctrcir, Tfcbg_ctrcir);
finalization
              Clean_Destroy( Ffcbg_ctrcir);
end.
