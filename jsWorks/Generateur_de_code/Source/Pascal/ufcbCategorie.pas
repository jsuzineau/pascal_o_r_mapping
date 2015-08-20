unit ufcbCategorie;
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
 TfcbCategorie
 =
  class(TfcbBase)
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

function fcbCategorie: TfcbCategorie;

function DerouleCategorie( E: TObject; Resultat: TIntegerField):Boolean;

implementation

uses
    uClean,
    upoolCategorie,
    ufCategorie;

{$R *.dfm}

var
   FfcbCategorie: TfcbCategorie;

function fcbCategorie: TfcbCategorie;
begin
     Clean_Get( Result, FfcbCategorie, TfcbCategorie);
end;

var
   FiltreCategorie: String = '';

function DerouleCategorie(E: TObject; Resultat: TIntegerField): Boolean;
begin
     fcbCategorie.eFiltre.Text:= FiltreCategorie;
//     Result
//     :=
//       fcbCategorie.DerouleListe( E, dmaCategorie.ds, fCategorie.Execute,
//                                 Resultat, dmaCategorie.qNumero);
     FiltreCategorie:= fcbCategorie.eFiltre.Text;
     Result:= False;
end;


initialization
              Clean_Create ( FfcbCategorie, TfcbCategorie);
finalization
              Clean_Destroy( FfcbCategorie);
end.
