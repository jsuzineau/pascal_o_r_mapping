unit ufcbState;
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
 TfcbState
 =
  class(TfcbBase)
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

function fcbState: TfcbState;

function DerouleState( E: TObject; Resultat: TIntegerField):Boolean;

implementation

uses
    uClean,
    upoolState,
    ufState;

{$R *.dfm}

var
   FfcbState: TfcbState;

function fcbState: TfcbState;
begin
     Clean_Get( Result, FfcbState, TfcbState);
end;

var
   FiltreState: String = '';

function DerouleState(E: TObject; Resultat: TIntegerField): Boolean;
begin
     fcbState.eFiltre.Text:= FiltreState;
//     Result
//     :=
//       fcbState.DerouleListe( E, dmaState.ds, fState.Execute,
//                                 Resultat, dmaState.qNumero);
     FiltreState:= fcbState.eFiltre.Text;
     Result:= False;
end;


initialization
              Clean_Create ( FfcbState, TfcbState);
finalization
              Clean_Destroy( FfcbState);
end.
