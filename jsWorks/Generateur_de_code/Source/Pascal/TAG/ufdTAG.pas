unit ufdTag;
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

    ublTag,

    upoolTag,

    ufBatpro_Form,
    ufpBas,

  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ActnList, StdCtrls, ComCtrls, Buttons, ExtCtrls, ucChamp_Edit,
  ucBatproMasque, ucbmAFFAIRE, ucChamp_Label,
  ucChamp_Lookup_ComboBox, ucDockableScrollbox, ucChamp_Memo, Menus;

type
 TfdTag
 =
  class(TfpBas)
    Panel1: TPanel;
    lNomChamp: TLabel;
    ceNomChamp: TChamp_Edit;
    lIDTYPE: TLabel;
    lNAME: TLabel;

    ceIDTYPE: TChamp_Edit;
    ceNAME: TChamp_Edit;

    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  //Méthodes
  public
    function Execute( var _bl: TblTag): Boolean; reintroduce;
  //bl
  private
    Fbl: TblTag;
    procedure Setbl(const Value: TblTag);
  public
    property bl: TblTag read Fbl write Setbl;
  end;

function  fdTag: TfdTag;

implementation

{$R *.dfm}

var
   FfdTag: TfdTag;

function  fdTag: TfdTag;
begin
     Clean_Get( Result, FfdTag, TfdTag);
end;

{ TfdTag }

procedure TfdTag.FormCreate(Sender: TObject);
begin
     inherited;
     Maximiser:= False;
     Fbl:= nil;
end;

procedure TfdTag.FormDestroy(Sender: TObject);
begin
     //
     inherited;
end;

function TfdTag.Execute( var _bl: TblTag): Boolean;
begin
     bl:= _bl;

     Result:= inherited Execute;

     if Result
     then
         _bl:= bl;
end;

procedure TfdTag.Setbl(const Value: TblTag);
begin
     Fbl:= Value;

     Champs_Affecte( bl,
                     [
                     ceIDTYPE,
                     ceNAME
                     ]);
end;

initialization
              Clean_Create ( FfdTag, TfdTag);
finalization
              Clean_Destroy( FfdTag);
end.
