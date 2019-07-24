unit ufOOo_NomFichier_Modele;
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
  uClean,
  ufpBas,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ActnList, StdCtrls, ComCtrls, Buttons, ExtCtrls, Menus;

type
 TfOOo_NomFichier_Modele
 =
  class(TfpBas)
    Label1: TLabel;
    lMasque: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    eSuffixe: TEdit;
    procedure FormCreate(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
    function Execute( Masque: String; var Suffixe: String): Boolean; reintroduce;
  end;

function fOOo_NomFichier_Modele: TfOOo_NomFichier_Modele;

implementation

{$R *.dfm}

var
   FfOOo_NomFichier_Modele: TfOOo_NomFichier_Modele;

function fOOo_NomFichier_Modele: TfOOo_NomFichier_Modele;
begin
     Clean_Get( Result, FfOOo_NomFichier_Modele, TfOOo_NomFichier_Modele);
end;

{ TfOOo_NomFichier_Modele }

procedure TfOOo_NomFichier_Modele.FormCreate(Sender: TObject);
begin
     inherited;
     Maximiser:= False;
end;

function TfOOo_NomFichier_Modele.Execute( Masque: String;
                                         var Suffixe: String): Boolean;
begin
     lMasque.Caption:= Masque;
     eSuffixe.Text:= Suffixe;
     Result:= inherited Execute;
     if Result
     then
         Suffixe:= eSuffixe.Text;
end;

initialization
              Clean_Create ( FfOOo_NomFichier_Modele, TfOOo_NomFichier_Modele);
finalization
              Clean_Destroy( FfOOo_NomFichier_Modele);
end.
