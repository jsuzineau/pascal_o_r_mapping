unit ufdg_becp;
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

    ublg_becp,

    upoolg_becp,

    ufBatpro_Form,
    ufpBas,

  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ActnList, StdCtrls, ComCtrls, Buttons, ExtCtrls, ucChamp_Edit,
  ucBatproMasque, ucbmAFFAIRE, ucChamp_Label,
  ucChamp_Lookup_ComboBox, ucDockableScrollbox, ucChamp_Memo, Menus;

type
 Tfdg_becp
 =
  class(TfpBas)
    Panel1: TPanel;
    lNomChamp: TLabel;
    ceNomChamp: TChamp_Edit;
    lNOMCLASSE: TLabel;
    lLIBELLE: TLabel;

    ceNOMCLASSE: TChamp_Edit;
    ceLIBELLE: TChamp_Edit;

    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  //Méthodes
  public
    function Execute( var _bl: Tblg_becp): Boolean; reintroduce;
  //bl
  private
    Fbl: Tblg_becp;
    procedure Setbl(const Value: Tblg_becp);
  public
    property bl: Tblg_becp read Fbl write Setbl;
  end;

function  fdg_becp: Tfdg_becp;

implementation

{$R *.dfm}

var
   Ffdg_becp: Tfdg_becp;

function  fdg_becp: Tfdg_becp;
begin
     Clean_Get( Result, Ffdg_becp, Tfdg_becp);
end;

{ Tfdg_becp }

procedure Tfdg_becp.FormCreate(Sender: TObject);
begin
     inherited;
     Maximiser:= False;
     Fbl:= nil;
end;

procedure Tfdg_becp.FormDestroy(Sender: TObject);
begin
     //
     inherited;
end;

function Tfdg_becp.Execute( var _bl: Tblg_becp): Boolean;
begin
     bl:= _bl;

     Result:= inherited Execute;

     if Result
     then
         _bl:= bl;
end;

procedure Tfdg_becp.Setbl(const Value: Tblg_becp);
begin
     Fbl:= Value;

     Champs_Affecte( bl,
                     [
                     ceNOMCLASSE,
                     ceLIBELLE
                     ]);
end;

initialization
              Clean_Create ( Ffdg_becp, Tfdg_becp);
finalization
              Clean_Destroy( Ffdg_becp);
end.
