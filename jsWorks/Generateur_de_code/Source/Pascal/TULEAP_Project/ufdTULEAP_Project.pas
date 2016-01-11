unit ufdTULEAP_Project;
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

    ublTULEAP_Project,

    upoolTULEAP_Project,

    ufBatpro_Form,
    ufpBas,

  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ActnList, StdCtrls, ComCtrls, Buttons, ExtCtrls, ucChamp_Edit,
  ucBatproMasque, ucbmAFFAIRE, ucChamp_Label,
  ucChamp_Lookup_ComboBox, ucDockableScrollbox, ucChamp_Memo, Menus;

type
 TfdTULEAP_Project
 =
  class(TfpBas)
    Panel1: TPanel;
    lNomChamp: TLabel;
    ceNomChamp: TChamp_Edit;
    lURI: TLabel;
    lLABEL: TLabel;
    lSHORTNAME: TLabel;
    lRESOURCES: TLabel;
    lADDITIONAL_INFORMATIONS: TLabel;

    ceURI: TChamp_Edit;
    ceLABEL: TChamp_Edit;
    ceSHORTNAME: TChamp_Edit;
    ceRESOURCES: TChamp_Edit;
    ceADDITIONAL_INFORMATIONS: TChamp_Edit;

    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  //Méthodes
  public
    function Execute( var _bl: TblTULEAP_Project): Boolean; reintroduce;
  //bl
  private
    Fbl: TblTULEAP_Project;
    procedure Setbl(const Value: TblTULEAP_Project);
  public
    property bl: TblTULEAP_Project read Fbl write Setbl;
  end;

function  fdTULEAP_Project: TfdTULEAP_Project;

implementation

{$R *.dfm}

var
   FfdTULEAP_Project: TfdTULEAP_Project;

function  fdTULEAP_Project: TfdTULEAP_Project;
begin
     Clean_Get( Result, FfdTULEAP_Project, TfdTULEAP_Project);
end;

{ TfdTULEAP_Project }

procedure TfdTULEAP_Project.FormCreate(Sender: TObject);
begin
     inherited;
     Maximiser:= False;
     Fbl:= nil;
end;

procedure TfdTULEAP_Project.FormDestroy(Sender: TObject);
begin
     //
     inherited;
end;

function TfdTULEAP_Project.Execute( var _bl: TblTULEAP_Project): Boolean;
begin
     bl:= _bl;

     Result:= inherited Execute;

     if Result
     then
         _bl:= bl;
end;

procedure TfdTULEAP_Project.Setbl(const Value: TblTULEAP_Project);
begin
     Fbl:= Value;

     Champs_Affecte( bl,
                     [
                     ceURI,
                     ceLABEL,
                     ceSHORTNAME,
                     ceRESOURCES,
                     ceADDITIONAL_INFORMATIONS
                     ]);
end;

initialization
              Clean_Create ( FfdTULEAP_Project, TfdTULEAP_Project);
finalization
              Clean_Destroy( FfdTULEAP_Project);
end.
