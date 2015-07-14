unit ufcbTAG_WORK;
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
 TfcbTAG_WORK
 =
  class(TfcbBase)
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

function fcbTAG_WORK: TfcbTAG_WORK;

function DerouleTAG_WORK( E: TObject; Resultat: TIntegerField):Boolean;

implementation

uses
    uClean,
    upoolTAG_WORK,
    ufTAG_WORK;

{$R *.dfm}

var
   FfcbTAG_WORK: TfcbTAG_WORK;

function fcbTAG_WORK: TfcbTAG_WORK;
begin
     Clean_Get( Result, FfcbTAG_WORK, TfcbTAG_WORK);
end;

var
   FiltreTAG_WORK: String = '';

function DerouleTAG_WORK(E: TObject; Resultat: TIntegerField): Boolean;
begin
     fcbTAG_WORK.eFiltre.Text:= FiltreTAG_WORK;
//     Result
//     :=
//       fcbTAG_WORK.DerouleListe( E, dmaTAG_WORK.ds, fTAG_WORK.Execute,
//                                 Resultat, dmaTAG_WORK.qNumero);
     FiltreTAG_WORK:= fcbTAG_WORK.eFiltre.Text;
     Result:= False;
end;


initialization
              Clean_Create ( FfcbTAG_WORK, TfcbTAG_WORK);
finalization
              Clean_Destroy( FfcbTAG_WORK);
end.
