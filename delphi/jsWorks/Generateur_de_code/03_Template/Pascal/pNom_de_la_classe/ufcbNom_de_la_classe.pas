unit ufcbNom_de_la_classe;
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
 TfcbNom_de_la_classe
 =
  class(TfcbBase)
  private
    { D�clarations priv�es }
  public
    { D�clarations publiques }
  end;

function fcbNom_de_la_classe: TfcbNom_de_la_classe;

function DerouleNom_de_la_classe( E: TObject; Resultat: TIntegerField):Boolean;

implementation

uses
    uClean,
    upoolNom_de_la_classe,
    ufNom_de_la_classe;

{$R *.dfm}

var
   FfcbNom_de_la_classe: TfcbNom_de_la_classe;

function fcbNom_de_la_classe: TfcbNom_de_la_classe;
begin
     Clean_Get( Result, FfcbNom_de_la_classe, TfcbNom_de_la_classe);
end;

var
   FiltreNom_de_la_classe: String = '';

function DerouleNom_de_la_classe(E: TObject; Resultat: TIntegerField): Boolean;
begin
     fcbNom_de_la_classe.eFiltre.Text:= FiltreNom_de_la_classe;
//     Result
//     :=
//       fcbNom_de_la_classe.DerouleListe( E, dmaNom_de_la_classe.ds, fNom_de_la_classe.Execute,
//                                 Resultat, dmaNom_de_la_classe.qNumero);
     FiltreNom_de_la_classe:= fcbNom_de_la_classe.eFiltre.Text;
     Result:= False;
end;


initialization
              Clean_Create ( FfcbNom_de_la_classe, TfcbNom_de_la_classe);
finalization
              Clean_Destroy( FfcbNom_de_la_classe);
end.