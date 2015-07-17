unit ufcbTYPE_TAG;
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
 TfcbTYPE_TAG
 =
  class(TfcbBase)
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

function fcbTYPE_TAG: TfcbTYPE_TAG;

function DerouleTYPE_TAG( E: TObject; Resultat: TIntegerField):Boolean;

implementation

uses
    uClean,
    upoolTYPE_TAG,
    ufTYPE_TAG;

{$R *.dfm}

var
   FfcbTYPE_TAG: TfcbTYPE_TAG;

function fcbTYPE_TAG: TfcbTYPE_TAG;
begin
     Clean_Get( Result, FfcbTYPE_TAG, TfcbTYPE_TAG);
end;

var
   FiltreTYPE_TAG: String = '';

function DerouleTYPE_TAG(E: TObject; Resultat: TIntegerField): Boolean;
begin
     fcbTYPE_TAG.eFiltre.Text:= FiltreTYPE_TAG;
//     Result
//     :=
//       fcbTYPE_TAG.DerouleListe( E, dmaTYPE_TAG.ds, fTYPE_TAG.Execute,
//                                 Resultat, dmaTYPE_TAG.qNumero);
     FiltreTYPE_TAG:= fcbTYPE_TAG.eFiltre.Text;
     Result:= False;
end;


initialization
              Clean_Create ( FfcbTYPE_TAG, TfcbTYPE_TAG);
finalization
              Clean_Destroy( FfcbTYPE_TAG);
end.
