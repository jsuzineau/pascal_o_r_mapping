unit ufChamp_Lookup;
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
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, CommCtrl, ExtCtrls, StdCtrls,
    uBatpro_StringList;

type
  TfChamp_Lookup = class(TForm)
    Panel1: TPanel;
    lb: TListBox;
    procedure lbKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure lbClick(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
    Keys  : TBatpro_StringList;
    Labels: TStrings;
    function Execute(Position:TPoint;var Cle:String;out Libelle:String):Boolean;
  end;

function fChamp_Lookup: TfChamp_Lookup;

implementation

uses
    uClean, Types;

{$R *.dfm}

var
   FfChamp_Lookup: TfChamp_Lookup;

function fChamp_Lookup: TfChamp_Lookup;
begin
     Clean_Get( Result, FfChamp_Lookup, TfChamp_Lookup);
end;

{ TfChamp_Lookup }

procedure TfChamp_Lookup.FormCreate(Sender: TObject);
begin
     Keys  := TBatpro_StringList.Create;
     Labels:= lb.Items;
end;

procedure TfChamp_Lookup.FormDestroy(Sender: TObject);
begin
     Free_nil( Keys  );
     Labels:= nil;
end;

function TfChamp_Lookup.Execute( Position: TPoint;
                                 var Cle    : String;
                                 out Libelle: String): Boolean;
var
   WorkArea: TRect;
   I: Integer;
begin
     Left:= Position.X;
     Top := Position.Y;
     SystemParametersInfo( SPI_GETWORKAREA, 0, @WorkArea, 0);
     if BoundsRect.Bottom > WorkArea.Bottom
     then
         Top:= WorkArea.Bottom - Height;
     if BoundsRect.Right > WorkArea.Right
     then
         Left:= WorkArea.Right - Width;

     lb.ItemIndex:= Keys.IndexOf( Cle);

     Result:= ShowModal = mrOK;
     if Result
     then
         begin
         I:= lb.ItemIndex;
         Cle    := Keys  .Strings[ I];
         Libelle:= Labels.Strings[ I];
         end;
end;

procedure TfChamp_Lookup.lbKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
     case Key
     of
       VK_RETURN: ModalResult:= mrOk;
       VK_ESCAPE,
       VK_CANCEL: ModalResult:= mrCancel;
       end;
end;

procedure TfChamp_Lookup.lbClick(Sender: TObject);
begin
     ModalResult:= mrOk;
end;

initialization
finalization
              Clean_Destroy( FfChamp_Lookup);
end.
