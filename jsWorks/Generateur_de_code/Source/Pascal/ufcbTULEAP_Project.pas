unit ufcbTULEAP_Project;
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
 TfcbTULEAP_Project
 =
  class(TfcbBase)
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

function fcbTULEAP_Project: TfcbTULEAP_Project;

function DerouleTULEAP_Project( E: TObject; Resultat: TIntegerField):Boolean;

implementation

uses
    uClean,
    upoolTULEAP_Project,
    ufTULEAP_Project;

{$R *.dfm}

var
   FfcbTULEAP_Project: TfcbTULEAP_Project;

function fcbTULEAP_Project: TfcbTULEAP_Project;
begin
     Clean_Get( Result, FfcbTULEAP_Project, TfcbTULEAP_Project);
end;

var
   FiltreTULEAP_Project: String = '';

function DerouleTULEAP_Project(E: TObject; Resultat: TIntegerField): Boolean;
begin
     fcbTULEAP_Project.eFiltre.Text:= FiltreTULEAP_Project;
//     Result
//     :=
//       fcbTULEAP_Project.DerouleListe( E, dmaTULEAP_Project.ds, fTULEAP_Project.Execute,
//                                 Resultat, dmaTULEAP_Project.qNumero);
     FiltreTULEAP_Project:= fcbTULEAP_Project.eFiltre.Text;
     Result:= False;
end;


initialization
              Clean_Create ( FfcbTULEAP_Project, TfcbTULEAP_Project);
finalization
              Clean_Destroy( FfcbTULEAP_Project);
end.
