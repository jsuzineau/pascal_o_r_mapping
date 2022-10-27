unit ufdSession;
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            http://www.mars42.com                                               |
                                                                                |
    Copyright 2019 Jean SUZINEAU - MARS42                                       |
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

    ublSession,

    upoolSession,

    ufBatpro_Form,
    ufpBas,

  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ActnList, StdCtrls, ComCtrls, Buttons, ExtCtrls, ucChamp_Edit,
  ucBatproMasque, ucbmAFFAIRE, ucChamp_Label,
  ucChamp_Lookup_ComboBox, ucDockableScrollbox, ucChamp_Memo, Menus;

type
 TfdSession
 =
  class(TfpBas)
    Panel1: TPanel;
    lNomChamp: TLabel;
    ceNomChamp: TChamp_Edit;
    lAPPLICATIONKEY: TLabel;
    lCOOKIE_ID: TLabel;
    lURL: TLabel;

    ceAPPLICATIONKEY: TChamp_Edit;
    ceCOOKIE_ID: TChamp_Edit;
    ceURL: TChamp_Edit;

    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  //Méthodes
  public
    function Execute( var _bl: TblSession): Boolean; reintroduce;
  //bl
  private
    Fbl: TblSession;
    procedure Setbl(const Value: TblSession);
  public
    property bl: TblSession read Fbl write Setbl;
  end;

function  fdSession: TfdSession;

implementation

{$R *.dfm}

var
   FfdSession: TfdSession;

function  fdSession: TfdSession;
begin
     Clean_Get( Result, FfdSession, TfdSession);
end;

{ TfdSession }

procedure TfdSession.FormCreate(Sender: TObject);
begin
     inherited;
     Maximiser:= False;
     Fbl:= nil;
end;

procedure TfdSession.FormDestroy(Sender: TObject);
begin
     //
     inherited;
end;

function TfdSession.Execute( var _bl: TblSession): Boolean;
begin
     bl:= _bl;

     Result:= inherited Execute;

     if Result
     then
         _bl:= bl;
end;

procedure TfdSession.Setbl(const Value: TblSession);
begin
     Fbl:= Value;

     Champs_Affecte( bl,
                     [
                     ceAPPLICATIONKEY,
                     ceCOOKIE_ID,
                     ceURL
                     ]);
end;

initialization
              Clean_Create ( FfdSession, TfdSession);
finalization
              Clean_Destroy( FfdSession);
end.
