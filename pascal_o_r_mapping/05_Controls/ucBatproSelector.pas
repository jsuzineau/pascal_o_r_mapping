unit ucBatproSelector;
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
    uForms,
  {$IFNDEF FPC}
  Windows,
  {$ENDIF}
  {$IFDEF FPC}
  LCLType,
  {$ENDIF}
  Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
    DB, DBCtrls, StdCtrls, Buttons;

type
 TBatproSelector
 =
  class(TDBEdit)
  private
    { D�clarations priv�es }
    FDropDownCount: Integer;
    ButtonWidth: Integer;
    B: TSpeedButton;
    procedure Positionne;
    procedure BClick( Sender: TObject);
    procedure Execute;
  protected
    { D�clarations prot�g�es }
    procedure Resize; override;
    procedure Click; override;
    procedure CreateWnd; override;
  public
    { D�clarations publiques }
    constructor Create(AOwner: TComponent); override;
  published
    { D�clarations publi�es }
    property DropDownCount: Integer read FDropDownCount write FDropDownCount;
    property DataSource;
    property DataField;
    property Visible;
  end;

procedure Register;

implementation

uses
    ufcb;

procedure Register;
begin
  RegisterComponents('Batpro', [TBatproSelector]);
end;

constructor TBatproSelector.Create(AOwner: TComponent);
var
   Bitmap: HBitmap;
begin
     FDropDownCount:= 12;
     inherited;
     ButtonWidth:= 10(*GetSystemMetrics(SM_CXVSCROLL)*);

     ReadOnly:= True;

     B:= TSpeedButton.Create( Self);
     B.Width := ButtonWidth;
     B.Height:= ButtonWidth;
     B.Visible:= True;
     B.Parent:= Self;
     B.OnClick:= BClick;
     //Bitmap:= Windows.LoadBitmap( 0, PChar(OBM_COMBO));
     //B.Glyph.Handle:= Bitmap;
     //DeleteObject(Bitmap);g�n�re une erreur:TBitmap ne doit pas faire de copie
     b.Cursor:= crArrow;
end;

procedure TBatproSelector.Positionne;
var
   Largeur: Integer;
begin
     //uForms_ShowMessage( '1');
     Largeur:= ClientWidth-ButtonWidth;
     B.Left:= Largeur;
     B.Height:= ClientHeight;
end;

(*
procedure TBatproSelector.Paint;
begin
     inherited;
     //DrawFrameControl(Canvas.Handle, R, DFC_SCROLL, Flags);
     B.Refresh;
end;
*)
procedure TBatproSelector.Resize;
begin
     Positionne;
     inherited;
end;

procedure TBatproSelector.Execute;
begin
     fcb.Execute( Self, DropDownCount, DataSource,
                  DataSource.DataSet.FieldByName(DataField));
     uForms_ProcessMessages;
     B.Refresh;

     inherited Click;
end;

procedure TBatproSelector.BClick(Sender: TObject);
begin
     Execute;
end;

procedure TBatproSelector.Click;
begin
     Execute;
end;

procedure TBatproSelector.CreateWnd;
begin
     inherited;
     Positionne;
end;

end.
