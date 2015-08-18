unit ufdWork;
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

    ublWork,

    upoolWork,

    ufBatpro_Form,
    ufpBas,

  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ActnList, StdCtrls, ComCtrls, Buttons, ExtCtrls, ucChamp_Edit,
  ucBatproMasque, ucbmAFFAIRE, ucChamp_Label,
  ucChamp_Lookup_ComboBox, ucDockableScrollbox, ucChamp_Memo, Menus;

type
 TfdWork
 =
  class(TfpBas)
    Panel1: TPanel;
    lNomChamp: TLabel;
    ceNomChamp: TChamp_Edit;
    lID: TLabel;
    lNPROJECT: TLabel;
    lBEGINNING: TLabel;
    lEND: TLabel;
    lDESCRIPTION: TLabel;
    lNUSER: TLabel;

    ceID: TChamp_Edit;
    ceNPROJECT: TChamp_Edit;
    ceBEGINNING: TChamp_Edit;
    ceEND: TChamp_Edit;
    ceDESCRIPTION: TChamp_Edit;
    ceNUSER: TChamp_Edit;

    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  //Méthodes
  public
    function Execute( var _bl: TblWork): Boolean; reintroduce;
  //bl
  private
    Fbl: TblWork;
    procedure Setbl(const Value: TblWork);
  public
    property bl: TblWork read Fbl write Setbl;
  end;

function  fdWork: TfdWork;

implementation

{$R *.dfm}

var
   FfdWork: TfdWork;

function  fdWork: TfdWork;
begin
     Clean_Get( Result, FfdWork, TfdWork);
end;

{ TfdWork }

procedure TfdWork.FormCreate(Sender: TObject);
begin
     inherited;
     Maximiser:= False;
     Fbl:= nil;
end;

procedure TfdWork.FormDestroy(Sender: TObject);
begin
     //
     inherited;
end;

function TfdWork.Execute( var _bl: TblWork): Boolean;
begin
     bl:= _bl;

     Result:= inherited Execute;

     if Result
     then
         _bl:= bl;
end;

procedure TfdWork.Setbl(const Value: TblWork);
begin
     Fbl:= Value;

     Champs_Affecte( bl,
                     [
                     ceID,
                     ceNPROJECT,
                     ceBEGINNING,
                     ceEND,
                     ceDESCRIPTION,
                     ceNUSER
                     ]);
end;

initialization
              Clean_Create ( FfdWork, TfdWork);
finalization
              Clean_Destroy( FfdWork);
end.
