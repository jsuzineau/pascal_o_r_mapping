unit ufdg_ctrcir;
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

    ublg_ctrcir,

    upoolg_ctrcir,

    ufBatpro_Form,
    ufpBas,

  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ActnList, StdCtrls, ComCtrls, Buttons, ExtCtrls, ucChamp_Edit,
  ucBatproMasque, ucbmAFFAIRE, ucChamp_Label,
  ucChamp_Lookup_ComboBox, ucDockableScrollbox, ucChamp_Memo, Menus;

type
 Tfdg_ctrcir
 =
  class(TfpBas)
    Panel1: TPanel;
    lNomChamp: TLabel;
    ceNomChamp: TChamp_Edit;
    lSOC: TLabel;
    lETS: TLabel;
    lTYPE: TLabel;
    lCIRCUIT: TLabel;
    lNO_REFERENCE: TLabel;
    lD1: TLabel;
    lD2: TLabel;
    lD3: TLabel;
    lOK_D1: TLabel;
    lOK_D2: TLabel;
    lOK_D3: TLabel;
    lDATE_OK1: TLabel;
    lDATE_OK2: TLabel;
    lDATE_OK3: TLabel;

    ceSOC: TChamp_Edit;
    ceETS: TChamp_Edit;
    ceTYPE: TChamp_Edit;
    ceCIRCUIT: TChamp_Edit;
    ceNO_REFERENCE: TChamp_Edit;
    ceD1: TChamp_Edit;
    ceD2: TChamp_Edit;
    ceD3: TChamp_Edit;
    ceOK_D1: TChamp_Edit;
    ceOK_D2: TChamp_Edit;
    ceOK_D3: TChamp_Edit;
    ceDATE_OK1: TChamp_Edit;
    ceDATE_OK2: TChamp_Edit;
    ceDATE_OK3: TChamp_Edit;

    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  //Méthodes
  public
    function Execute( var _bl: Tblg_ctrcir): Boolean; reintroduce;
  //bl
  private
    Fbl: Tblg_ctrcir;
    procedure Setbl(const Value: Tblg_ctrcir);
  public
    property bl: Tblg_ctrcir read Fbl write Setbl;
  end;

function  fdg_ctrcir: Tfdg_ctrcir;

implementation

{$R *.dfm}

var
   Ffdg_ctrcir: Tfdg_ctrcir;

function  fdg_ctrcir: Tfdg_ctrcir;
begin
     Clean_Get( Result, Ffdg_ctrcir, Tfdg_ctrcir);
end;

{ Tfdg_ctrcir }

procedure Tfdg_ctrcir.FormCreate(Sender: TObject);
begin
     inherited;
     Maximiser:= False;
     Fbl:= nil;
end;

procedure Tfdg_ctrcir.FormDestroy(Sender: TObject);
begin
     //
     inherited;
end;

function Tfdg_ctrcir.Execute( var _bl: Tblg_ctrcir): Boolean;
begin
     bl:= _bl;

     Result:= inherited Execute;

     if Result
     then
         _bl:= bl;
end;

procedure Tfdg_ctrcir.Setbl(const Value: Tblg_ctrcir);
begin
     Fbl:= Value;

     Champs_Affecte( bl,
                     [
                     ceSOC,
                     ceETS,
                     ceTYPE,
                     ceCIRCUIT,
                     ceNO_REFERENCE,
                     ceD1,
                     ceD2,
                     ceD3,
                     ceOK_D1,
                     ceOK_D2,
                     ceOK_D3,
                     ceDATE_OK1,
                     ceDATE_OK2,
                     ceDATE_OK3
                     ]);
end;

initialization
              Clean_Create ( Ffdg_ctrcir, Tfdg_ctrcir);
finalization
              Clean_Destroy( Ffdg_ctrcir);
end.
