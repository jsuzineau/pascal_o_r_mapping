unit uftcDockableScrollbox;
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

{$IFDEF FPC}
{$mode delphi}
{$ENDIF}

interface

uses
    ublTestDockableScrollbox,
    udkTestDockableScrollbox,
    uhdmTestDockableScrollbox,
    Classes, SysUtils, VCL.Forms, VCL.Controls,
    VCL.Graphics, VCL.Dialogs, VCL.ExtCtrls, VCL.StdCtrls,
    ucDockableScrollbox;

type

 { TftcDockableScrollbox }

 TftcDockableScrollbox
 =
  class(TForm)
   Button1: TButton;
   m: TMemo;
   Panel1: TPanel;
    dsb: TDockableScrollbox;
   procedure FormCreate(Sender: TObject);
   procedure FormDestroy(Sender: TObject);

  //hdm
  protected
    hdm: ThdmTestDockableScrollbox;
  end;

implementation

{$R *.dfm}

{ TftcDockableScrollbox }

procedure TftcDockableScrollbox.FormCreate(Sender: TObject);
begin
     hdm:= ThdmTestDockableScrollbox.Create;

     dsb.Classe_dockable:= TdkTestDockableScrollbox;
     dsb.Classe_Elements:= TblTestDockableScrollbox;

     hdm.Execute;
     dsb.sl:= hdm;
end;

procedure TftcDockableScrollbox.FormDestroy(Sender: TObject);
begin
     FreeAndNil(hdm);
end;

end.

