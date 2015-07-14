unit ufdTAG_DEVELOPMENT;
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

    ublTAG_DEVELOPMENT,

    upoolTAG_DEVELOPMENT,

    ufBatpro_Form,
    ufpBas,

  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ActnList, StdCtrls, ComCtrls, Buttons, ExtCtrls, ucChamp_Edit,
  ucBatproMasque, ucbmAFFAIRE, ucChamp_Label,
  ucChamp_Lookup_ComboBox, ucDockableScrollbox, ucChamp_Memo, Menus;

type
 TfdTAG_DEVELOPMENT
 =
  class(TfpBas)
    Panel1: TPanel;
    lNomChamp: TLabel;
    ceNomChamp: TChamp_Edit;
    lID: TLabel;
    lIDTAG: TLabel;
    lIDDEVELOPMENT: TLabel;

    ceID: TChamp_Edit;
    ceIDTAG: TChamp_Edit;
    ceIDDEVELOPMENT: TChamp_Edit;

    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  //Méthodes
  public
    function Execute( var _bl: TblTAG_DEVELOPMENT): Boolean; reintroduce;
  //bl
  private
    Fbl: TblTAG_DEVELOPMENT;
    procedure Setbl(const Value: TblTAG_DEVELOPMENT);
  public
    property bl: TblTAG_DEVELOPMENT read Fbl write Setbl;
  end;

function  fdTAG_DEVELOPMENT: TfdTAG_DEVELOPMENT;

implementation

{$R *.dfm}

var
   FfdTAG_DEVELOPMENT: TfdTAG_DEVELOPMENT;

function  fdTAG_DEVELOPMENT: TfdTAG_DEVELOPMENT;
begin
     Clean_Get( Result, FfdTAG_DEVELOPMENT, TfdTAG_DEVELOPMENT);
end;

{ TfdTAG_DEVELOPMENT }

procedure TfdTAG_DEVELOPMENT.FormCreate(Sender: TObject);
begin
     inherited;
     Maximiser:= False;
     Fbl:= nil;
end;

procedure TfdTAG_DEVELOPMENT.FormDestroy(Sender: TObject);
begin
     //
     inherited;
end;

function TfdTAG_DEVELOPMENT.Execute( var _bl: TblTAG_DEVELOPMENT): Boolean;
begin
     bl:= _bl;

     Result:= inherited Execute;

     if Result
     then
         _bl:= bl;
end;

procedure TfdTAG_DEVELOPMENT.Setbl(const Value: TblTAG_DEVELOPMENT);
begin
     Fbl:= Value;

     Champs_Affecte( bl,
                     [
                     ceID,
                     ceIDTAG,
                     ceIDDEVELOPMENT
                     ]);
end;

initialization
              Clean_Create ( FfdTAG_DEVELOPMENT, TfdTAG_DEVELOPMENT);
finalization
              Clean_Destroy( FfdTAG_DEVELOPMENT);
end.
