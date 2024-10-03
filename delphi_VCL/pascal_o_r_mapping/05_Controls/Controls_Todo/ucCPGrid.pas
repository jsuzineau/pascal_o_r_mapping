unit ucCPGrid;
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            partly as freelance: http://www.mars42.com                          |
        and partly as employee : http://www.adinfo.com                          |
                                 http://www.adi-bat.com                         |
    Copyright 2017 Jean SUZINEAU - MARS42                                       |
    Copyright 2017 GROUPE ADINFO SOFTWARE                                       |
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
    uDessin,
    uWinUtils,
    uWindows,
    uDataUtilsU,
    uChamps,
    uChampDefinitions,
    uChamp,
    uChampDefinition,
    Windows, SysUtils, Classes, VCL.Controls, DB, Grids,VCL.Dialogs, VCL.StdCtrls, Buttons;

type

 TCPGrid
 =
  class( TStringGrid)
  //Gestion du cycle de vie
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  //Gestion des modifications
  private
    procedure InplaceEdit_EditButtonClick( Sender: TObject);
  protected
    function CreateEditor: TInplaceEdit; override;
    procedure SetEditText(ACol, ARow: Longint; const Value: string); override;
    function GetEditStyle(ACol, ARow: Longint): TEditStyle; override;
  //Gestion de la sélection
  private
    ChampsProvider: TChampsProvider;
    Champ: TChamp;
    ChampDefinition: TChampDefinition;
    function _from_Selection: Boolean;
    function _from_XY( X, Y: Integer): Boolean;
  public
    function ChampsProvider_from_XY( X, Y: Integer): TChampsProvider;
  //Contexte
  public
    Contexte: Integer;
  end;

procedure Register;

implementation

procedure Register;
begin
     RegisterComponents('Batpro', [TCPGrid]);
end;

{ TCPGrid }

constructor TCPGrid.Create(AOwner: TComponent);
begin
     inherited;
     Contexte:= 0;
end;

destructor TCPGrid.Destroy;
begin
     inherited;
end;

function TCPGrid._from_XY(X, Y: Integer): Boolean;
begin
     Result:= False;

     ChampsProvider:= ChampsProvider_from_XY( X, Y);
     if ChampsProvider = nil then exit;

     Champ:= ChampsProvider.Champ_a_editer( Contexte);
     if Champ = nil then exit;

     ChampDefinition:= Champ.Definition;
     if ChampDefinition = nil then exit;

     Result:= True;
end;

function TCPGrid._from_Selection: Boolean;
begin
     Result:= _from_XY( Col, Row);
end;

procedure TCPGrid.InplaceEdit_EditButtonClick(Sender: TObject);
var
   iel: TInplaceEditList;
   P: TPoint;
   Chaine: String;
begin
     if not _from_Selection then exit;

     iel:= InplaceEditor as TInplaceEditList;
     P:= PointF( iel.BoundsRect.Left, iel.BoundsRect.Bottom);
     P:= ClientToScreen( P);
     if Champ.Edite( P)
     then
         begin
         Chaine  := Champ.Chaine;
         iel.Text:= Chaine;
         end;
end;

function TCPGrid.CreateEditor: TInplaceEdit;
var
   iel: TInplaceEditList;
begin
     iel:= TInplaceEditList.Create(Self);
     iel.OnEditButtonClick:= InplaceEdit_EditButtonClick;

     Result:= iel;
end;

procedure TCPGrid.SetEditText(ACol, ARow: Integer; const Value: string);
var
   OldSelStart, OldSelLength: Integer;
begin
     if not _from_Selection then exit;

     inherited;

     if Champ.Chaine = Value then exit;

     OldSelStart := InplaceEditor.SelStart ;
     OldSelLength:= InplaceEditor.SelLength;
     Champ.Chaine:= Value;
     InplaceEditor.SelStart := OldSelStart ;
     InplaceEditor.SelLength:= OldSelLength;
end;

function TCPGrid.GetEditStyle( ACol, ARow: Integer): TEditStyle;
begin
     Result:= inherited GetEditStyle( ACol, ARow);

     if not _from_XY( ACol, ARow) then exit;
     Result:= ChampDefinition.GetEditStyle;
end;

function TCPGrid.ChampsProvider_from_XY(X, Y: Integer): TChampsProvider;
begin
     Result:= TChampsProvider( Objects[ X, Y]);
     CheckClass( Result, TChampsProvider);
end;

end.
