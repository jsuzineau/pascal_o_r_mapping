unit uftcWinUtils;
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            http://www.mars42.com                                               |
                                                                                |
    Copyright 2017 Jean SUZINEAU - MARS42                                       |
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
    along with this program.  If not, see <http://www.gnu.org/licenses/>. 1     |
                                                                                |
|                                                                               }

{$mode delphi}

interface

uses
    uWinUtils, uhdmTestWinUtils, Classes, SysUtils, FileUtil, Forms, Controls,
    Graphics, Dialogs, ExtCtrls, Spin, StdCtrls,LCLIntf,LCLType;

type

 { TftcWinUtils }

 TftcWinUtils
 =
  class(TForm)
   Button1: TButton;
   m: TMemo;
   Panel1: TPanel;
   pb: TPaintBox;
   procedure FormCreate(Sender: TObject);
   procedure FormDestroy(Sender: TObject);
   procedure pbPaint(Sender: TObject);

  //hdm
  protected
    hdm: ThdmTestWinUtils;
  end;

implementation

{$R *.lfm}

{ TftcWinUtils }

procedure TftcWinUtils.FormCreate(Sender: TObject);
begin
     hdm:= ThdmTestWinUtils.Create;
end;

procedure TftcWinUtils.FormDestroy(Sender: TObject);
begin
     FreeAndNil(hdm);
end;

procedure TftcWinUtils.pbPaint(Sender: TObject);
const
     S= 'soustotal__cdn3libelle';
var
   W: Integer;
   H: Integer;
   R: TRect;
begin
     W:= LargeurTexte( pb.Font, S);
     H:= HauteurTexte( pb.Font, S, W);
     R:= Rect( 0,0,W, H);
     pb.Canvas.Rectangle( R);
     LCLIntf.DrawText( pb.Canvas.Handle, PChar(S), Length(S), R, DT_INTERNAL);

     m.Clear;
     m.Lines.Add( 'Largeur: '+IntToStr(W));
     m.Lines.Add( 'Hauteur: '+IntToStr(H));
end;

end.

