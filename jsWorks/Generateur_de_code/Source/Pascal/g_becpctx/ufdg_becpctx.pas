unit ufdg_becpctx;
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

    ublg_becpctx,

    upoolg_becpctx,

    ufBatpro_Form,
    ufpBas,

  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ActnList, StdCtrls, ComCtrls, Buttons, ExtCtrls, ucChamp_Edit,
  ucBatproMasque, ucbmAFFAIRE, ucChamp_Label,
  ucChamp_Lookup_ComboBox, ucDockableScrollbox, ucChamp_Memo, Menus;

type
 Tfdg_becpctx
 =
  class(TfpBas)
    Panel1: TPanel;
    lNomChamp: TLabel;
    ceNomChamp: TChamp_Edit;
    lNOMCLASSE: TLabel;
    lCONTEXTE: TLabel;
    lLOGFONT: TLabel;
    lSTRINGLIST: TLabel;

    ceNOMCLASSE: TChamp_Edit;
    ceCONTEXTE: TChamp_Edit;
    ceLOGFONT: TChamp_Edit;
    ceSTRINGLIST: TChamp_Edit;

    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  //Méthodes
  public
    function Execute( var _bl: Tblg_becpctx): Boolean; reintroduce;
  //bl
  private
    Fbl: Tblg_becpctx;
    procedure Setbl(const Value: Tblg_becpctx);
  public
    property bl: Tblg_becpctx read Fbl write Setbl;
  end;

function  fdg_becpctx: Tfdg_becpctx;

implementation

{$R *.dfm}

var
   Ffdg_becpctx: Tfdg_becpctx;

function  fdg_becpctx: Tfdg_becpctx;
begin
     Clean_Get( Result, Ffdg_becpctx, Tfdg_becpctx);
end;

{ Tfdg_becpctx }

procedure Tfdg_becpctx.FormCreate(Sender: TObject);
begin
     inherited;
     Maximiser:= False;
     Fbl:= nil;
end;

procedure Tfdg_becpctx.FormDestroy(Sender: TObject);
begin
     //
     inherited;
end;

function Tfdg_becpctx.Execute( var _bl: Tblg_becpctx): Boolean;
begin
     bl:= _bl;

     Result:= inherited Execute;

     if Result
     then
         _bl:= bl;
end;

procedure Tfdg_becpctx.Setbl(const Value: Tblg_becpctx);
begin
     Fbl:= Value;

     Champs_Affecte( bl,
                     [
                     ceNOMCLASSE,
                     ceCONTEXTE,
                     ceLOGFONT,
                     ceSTRINGLIST
                     ]);
end;

initialization
              Clean_Create ( Ffdg_becpctx, Tfdg_becpctx);
finalization
              Clean_Destroy( Ffdg_becpctx);
end.
