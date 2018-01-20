unit ufChamp_Date;
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
  System.SysUtils, System.Variants, System.Classes,System.Types,
  FMX.Graphics, FMX.Controls, FMX.Forms,
  FMX.Dialogs, FMX.ExtCtrls, FMX.Types, FMX.Controls.Presentation,
  FMX.Calendar,
  System.UITypes;

type
  TfChamp_Date = class(TForm)
    c: TCalendar;
    procedure cKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
    function Execute( _Position: TPoint; var D: TDateTime): Boolean;
  end;

function fChamp_Date: TfChamp_Date;

implementation

uses
    uClean;

{$R *.fmx}

var
   FfChamp_Date: TfChamp_Date;

function fChamp_Date: TfChamp_Date;
begin
     Clean_Get( Result, FfChamp_Date, TfChamp_Date);
end;

{ TfChamp_Date }

function TfChamp_Date.Execute( _Position: TPoint; var D: TDateTime): Boolean;
var
   WorkArea: TRect;
begin
     Left:= _Position.X;
     Top := _Position.Y;
     {
     SystemParametersInfo( SPI_GETWORKAREA, 0, @WorkArea, 0);
     if BoundsRect.Bottom > WorkArea.Bottom
     then
         Top:= WorkArea.Bottom - Height;
     if BoundsRect.Right > WorkArea.Right
     then
         Left:= WorkArea.Right - Width;
     }

     c.Date:= Int( D);
     Result:= ShowModal = mrOK;
     if Result
     then
         D:= Int(c.Date)+Frac(D);
end;

procedure TfChamp_Date.cKeyDown(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
     case Key
     of
       vkReturn: ModalResult:= mrOk;
       vkEscape,
       vkCancel: ModalResult:= mrCancel;
       end;
end;

initialization
finalization
              Clean_Destroy( FfChamp_Date);
end.
