unit ufdTag_Work;
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

    ublTag_Work,

    upoolTag_Work,

    ufBatpro_Form,
    ufpBas,

  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ActnList, StdCtrls, ComCtrls, Buttons, ExtCtrls, ucChamp_Edit,
  ucBatproMasque, ucbmAFFAIRE, ucChamp_Label,
  ucChamp_Lookup_ComboBox, ucDockableScrollbox, ucChamp_Memo, Menus;

type
 TfdTag_Work
 =
  class(TfpBas)
    Panel1: TPanel;
    lNomChamp: TLabel;
    ceNomChamp: TChamp_Edit;
    lID: TLabel;
    lIDTAG: TLabel;
    lIDWORK: TLabel;

    ceID: TChamp_Edit;
    ceIDTAG: TChamp_Edit;
    ceIDWORK: TChamp_Edit;

    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  //Méthodes
  public
    function Execute( var _bl: TblTag_Work): Boolean; reintroduce;
  //bl
  private
    Fbl: TblTag_Work;
    procedure Setbl(const Value: TblTag_Work);
  public
    property bl: TblTag_Work read Fbl write Setbl;
  end;

function  fdTag_Work: TfdTag_Work;

implementation

{$R *.dfm}

var
   FfdTag_Work: TfdTag_Work;

function  fdTag_Work: TfdTag_Work;
begin
     Clean_Get( Result, FfdTag_Work, TfdTag_Work);
end;

{ TfdTag_Work }

procedure TfdTag_Work.FormCreate(Sender: TObject);
begin
     inherited;
     Maximiser:= False;
     Fbl:= nil;
end;

procedure TfdTag_Work.FormDestroy(Sender: TObject);
begin
     //
     inherited;
end;

function TfdTag_Work.Execute( var _bl: TblTag_Work): Boolean;
begin
     bl:= _bl;

     Result:= inherited Execute;

     if Result
     then
         _bl:= bl;
end;

procedure TfdTag_Work.Setbl(const Value: TblTag_Work);
begin
     Fbl:= Value;

     Champs_Affecte( bl,
                     [
                     ceID,
                     ceIDTAG,
                     ceIDWORK
                     ]);
end;

initialization
              Clean_Create ( FfdTag_Work, TfdTag_Work);
finalization
              Clean_Destroy( FfdTag_Work);
end.
