unit ufdg_ctx;
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

    ublg_ctx,

    upoolg_ctx,

    ufBatpro_Form,
    ufpBas,

  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ActnList, StdCtrls, ComCtrls, Buttons, ExtCtrls, ucChamp_Edit,
  ucBatproMasque, ucbmAFFAIRE, ucChamp_Label,
  ucChamp_Lookup_ComboBox, ucDockableScrollbox, ucChamp_Memo, Menus;

type
 Tfdg_ctx
 =
  class(TfpBas)
    Panel1: TPanel;
    lNomChamp: TLabel;
    ceNomChamp: TChamp_Edit;
    lCONTEXTE: TLabel;
    lCONTEXTETYPE: TLabel;
    lLIBELLE: TLabel;

    ceCONTEXTE: TChamp_Edit;
    ceCONTEXTETYPE: TChamp_Edit;
    ceLIBELLE: TChamp_Edit;

    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  //Méthodes
  public
    function Execute( var _bl: Tblg_ctx): Boolean; reintroduce;
  //bl
  private
    Fbl: Tblg_ctx;
    procedure Setbl(const Value: Tblg_ctx);
  public
    property bl: Tblg_ctx read Fbl write Setbl;
  end;

function  fdg_ctx: Tfdg_ctx;

implementation

{$R *.dfm}

var
   Ffdg_ctx: Tfdg_ctx;

function  fdg_ctx: Tfdg_ctx;
begin
     Clean_Get( Result, Ffdg_ctx, Tfdg_ctx);
end;

{ Tfdg_ctx }

procedure Tfdg_ctx.FormCreate(Sender: TObject);
begin
     inherited;
     Maximiser:= False;
     Fbl:= nil;
end;

procedure Tfdg_ctx.FormDestroy(Sender: TObject);
begin
     //
     inherited;
end;

function Tfdg_ctx.Execute( var _bl: Tblg_ctx): Boolean;
begin
     bl:= _bl;

     Result:= inherited Execute;

     if Result
     then
         _bl:= bl;
end;

procedure Tfdg_ctx.Setbl(const Value: Tblg_ctx);
begin
     Fbl:= Value;

     Champs_Affecte( bl,
                     [
                     ceCONTEXTE,
                     ceCONTEXTETYPE,
                     ceLIBELLE
                     ]);
end;

initialization
              Clean_Create ( Ffdg_ctx, Tfdg_ctx);
finalization
              Clean_Destroy( Ffdg_ctx);
end.
