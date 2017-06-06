unit ufdNom_de_la_classe;
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
    uBatpro_StringList,
    u_sys_,
    uChamps,
    uPublieur,

    ublNom_de_la_classe,

    upoolNom_de_la_classe,

    ufBatpro_Form,
    ufpBas,

  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ActnList, StdCtrls, ComCtrls, Buttons, ExtCtrls, ucChamp_Edit,
  ucBatproMasque, ucbmAFFAIRE, ucChamp_Label,
  ucChamp_Lookup_ComboBox, ucDockableScrollbox, ucChamp_Memo, Menus;

type
 TfdNom_de_la_classe
 =
  class(TfpBas)
    Panel1: TPanel;
    lNomChamp: TLabel;
    ceNomChamp: TChamp_Edit;
    {JoinPoint_LabelsPAS}
    {JoinPoint_Champ_EditPAS}
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  //Méthodes
  public
    function Execute( var _bl: TblNom_de_la_classe): Boolean; reintroduce;
  //bl
  private
    Fbl: TblNom_de_la_classe;
    procedure Setbl(const Value: TblNom_de_la_classe);
  public
    property bl: TblNom_de_la_classe read Fbl write Setbl;
  end;

function  fdNom_de_la_classe: TfdNom_de_la_classe;

implementation

{$R *.dfm}

var
   FfdNom_de_la_classe: TfdNom_de_la_classe;

function  fdNom_de_la_classe: TfdNom_de_la_classe;
begin
     Clean_Get( Result, FfdNom_de_la_classe, TfdNom_de_la_classe);
end;

{ TfdNom_de_la_classe }

procedure TfdNom_de_la_classe.FormCreate(Sender: TObject);
begin
     inherited;
     Maximiser:= False;
     Fbl:= nil;
end;

procedure TfdNom_de_la_classe.FormDestroy(Sender: TObject);
begin
     //
     inherited;
end;

function TfdNom_de_la_classe.Execute( var _bl: TblNom_de_la_classe): Boolean;
begin
     bl:= _bl;

     Result:= inherited Execute;

     if Result
     then
         _bl:= bl;
end;

procedure TfdNom_de_la_classe.Setbl(const Value: TblNom_de_la_classe);
begin
     Fbl:= Value;

     Champs_Affecte( bl,
                     [
                     {JoinPoint_Affecte}
                     ]);
end;

initialization
              Clean_Create ( FfdNom_de_la_classe, TfdNom_de_la_classe);
finalization
              Clean_Destroy( FfdNom_de_la_classe);
end.
