unit ufcbTYPE_Tag;
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
 TfcbTYPE_Tag
 =
  class(TfcbBase)
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

function fcbTYPE_Tag: TfcbTYPE_Tag;

function DerouleTYPE_Tag( E: TObject; Resultat: TIntegerField):Boolean;

implementation

uses
    uClean,
    upoolTYPE_Tag,
    ufTYPE_Tag;

{$R *.dfm}

var
   FfcbTYPE_Tag: TfcbTYPE_Tag;

function fcbTYPE_Tag: TfcbTYPE_Tag;
begin
     Clean_Get( Result, FfcbTYPE_Tag, TfcbTYPE_Tag);
end;

var
   FiltreTYPE_Tag: String = '';

function DerouleTYPE_Tag(E: TObject; Resultat: TIntegerField): Boolean;
begin
     fcbTYPE_Tag.eFiltre.Text:= FiltreTYPE_Tag;
//     Result
//     :=
//       fcbTYPE_Tag.DerouleListe( E, dmaTYPE_Tag.ds, fTYPE_Tag.Execute,
//                                 Resultat, dmaTYPE_Tag.qNumero);
     FiltreTYPE_Tag:= fcbTYPE_Tag.eFiltre.Text;
     Result:= False;
end;


initialization
              Clean_Create ( FfcbTYPE_Tag, TfcbTYPE_Tag);
finalization
              Clean_Destroy( FfcbTYPE_Tag);
end.
