unit ufOOoModelSelect;
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            partly as freelance: http://www.mars42.com                          |
        and partly as employee : http://www.batpro.com                          |
    Contact: gilles.doutre@batpro.com                                           |
                                                                                |
    Copyright 2005,2008,2011,2012,2014 Jean SUZINEAU - MARS42                   |
    Copyright 2005,2008,2011,2012,2014 Cabinet Gilles DOUTRE - BATPRO           |
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
  Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, StdCtrls, FileCtrl, ExtCtrls;

type
 TfOOoModelSelect
 =
  class(TForm)
    Panel1: TPanel;
    flb: TFileListBox;
    bModifier: TButton;
    Panel2: TPanel;
    BitBtn2: TBitBtn;
    bOK: TBitBtn;
    lRepertoire: TLabel;
    procedure bModifierClick(Sender: TObject);
    procedure flbChange(Sender: TObject);
    procedure flbDblClick(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
    function Execute( RepertoireModeles: String): Boolean;
    function Modele_Selectionne: String;
  end;

function fOOoModelSelect: TfOOoModelSelect;

implementation

{$R *.dfm}

var
   FfOOoModelSelect: TfOOoModelSelect= nil;

procedure Cree_FfOOoModelSelect;
begin
     FfOOoModelSelect:= TfOOoModelSelect.Create( nil);
end;

function fOOoModelSelect: TfOOoModelSelect;
begin
     if FfOOoModelSelect = nil
     then
         Cree_FfOOoModelSelect;
     Result:= FfOOoModelSelect;
end;

{ TfOOoModelSelect }

function TfOOoModelSelect.Execute( RepertoireModeles: String): Boolean;
begin
     flb.Directory:= RepertoireModeles;
     lRepertoire.Caption:= 'Modèles dans '+RepertoireModeles;
     Result:= ShowModal = mrOk;
end;

function TfOOoModelSelect.Modele_Selectionne: String;
begin
     Result:= flb.FileName;
end;

procedure TfOOoModelSelect.bModifierClick(Sender: TObject);
var
   NomFichier: String;
begin
     NomFichier:= Modele_Selectionne;
     if not FileExists( NomFichier) then exit;
     (*UNO_DeskTop.OpenFile( NomFichier, False, False);*)
end;

procedure TfOOoModelSelect.flbChange(Sender: TObject);
var
   ModeleValide: Boolean;
begin
     ModeleValide:= FileExists( Modele_Selectionne);
     bOK      .Enabled:= ModeleValide;
     bModifier.Enabled:= ModeleValide;
end;

procedure TfOOoModelSelect.flbDblClick(Sender: TObject);
begin
     if bOK.Enabled then bOK.Click;
end;

initialization
              Cree_FfOOoModelSelect;
finalization
              FreeAndNil( FfOOoModelSelect);
end.
