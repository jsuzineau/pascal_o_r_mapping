unit ufdDevelopment;
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

    ublDevelopment,

    upoolDevelopment,

    ufBatpro_Form,
    ufpBas,

  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ActnList, StdCtrls, ComCtrls, Buttons, ExtCtrls, ucChamp_Edit,
  ucBatproMasque, ucbmAFFAIRE, ucChamp_Label,
  ucChamp_Lookup_ComboBox, ucDockableScrollbox, ucChamp_Memo, Menus;

type
 TfdDevelopment
 =
  class(TfpBas)
    Panel1: TPanel;
    lNomChamp: TLabel;
    ceNomChamp: TChamp_Edit;
    lNPROJECT: TLabel;
    lNSTATE: TLabel;
    lNCREATIONWORK: TLabel;
    lNSOLUTIONWORK: TLabel;
    lDESCRIPTION: TLabel;
    lSTEPS: TLabel;
    lORIGIN: TLabel;
    lSOLUTION: TLabel;
    lNCATEGORIE: TLabel;
    lISBUG: TLabel;
    lNDEMANDER: TLabel;
    lNSHEETREF: TLabel;

    ceNPROJECT: TChamp_Edit;
    ceNSTATE: TChamp_Edit;
    ceNCREATIONWORK: TChamp_Edit;
    ceNSOLUTIONWORK: TChamp_Edit;
    ceDESCRIPTION: TChamp_Edit;
    ceSTEPS: TChamp_Edit;
    ceORIGIN: TChamp_Edit;
    ceSOLUTION: TChamp_Edit;
    ceNCATEGORIE: TChamp_Edit;
    ceISBUG: TChamp_Edit;
    ceNDEMANDER: TChamp_Edit;
    ceNSHEETREF: TChamp_Edit;

    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  //Méthodes
  public
    function Execute( var _bl: TblDevelopment): Boolean; reintroduce;
  //bl
  private
    Fbl: TblDevelopment;
    procedure Setbl(const Value: TblDevelopment);
  public
    property bl: TblDevelopment read Fbl write Setbl;
  end;

function  fdDevelopment: TfdDevelopment;

implementation

{$R *.dfm}

var
   FfdDevelopment: TfdDevelopment;

function  fdDevelopment: TfdDevelopment;
begin
     Clean_Get( Result, FfdDevelopment, TfdDevelopment);
end;

{ TfdDevelopment }

procedure TfdDevelopment.FormCreate(Sender: TObject);
begin
     inherited;
     Maximiser:= False;
     Fbl:= nil;
end;

procedure TfdDevelopment.FormDestroy(Sender: TObject);
begin
     //
     inherited;
end;

function TfdDevelopment.Execute( var _bl: TblDevelopment): Boolean;
begin
     bl:= _bl;

     Result:= inherited Execute;

     if Result
     then
         _bl:= bl;
end;

procedure TfdDevelopment.Setbl(const Value: TblDevelopment);
begin
     Fbl:= Value;

     Champs_Affecte( bl,
                     [
                     ceNPROJECT,
                     ceNSTATE,
                     ceNCREATIONWORK,
                     ceNSOLUTIONWORK,
                     ceDESCRIPTION,
                     ceSTEPS,
                     ceORIGIN,
                     ceSOLUTION,
                     ceNCATEGORIE,
                     ceISBUG,
                     ceNDEMANDER,
                     ceNSHEETREF
                     ]);
end;

initialization
              Clean_Create ( FfdDevelopment, TfdDevelopment);
finalization
              Clean_Destroy( FfdDevelopment);
end.
