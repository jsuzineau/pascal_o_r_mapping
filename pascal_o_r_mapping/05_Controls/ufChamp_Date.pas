unit ufChamp_Date;
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
  {$IFNDEF FPC}
  Windows,
  {$ENDIF}
  {$IFDEF FPC}
  LCLType,
  {$ENDIF}
  Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ExtCtrls, Calendar;

type
 TfChamp_Date
 =
  class(TForm)
    mc: TCalendar;
    procedure mcKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  protected
    procedure WndProc(var Message: TMessage); override;
  public
    function Execute( _Position: TPoint; var _D: TDateTime): Boolean;
  end;

function fChamp_Date: TfChamp_Date;

implementation

uses
    uClean, Types;

{$R *.lfm}

var
   FfChamp_Date: TfChamp_Date;

function fChamp_Date: TfChamp_Date;
begin
     Clean_Get( Result, FfChamp_Date, TfChamp_Date);
end;

{ TfChamp_Date }

function TfChamp_Date.Execute( _Position: TPoint; var _D: TDateTime): Boolean;
var
   WorkArea: TRect;
begin
     Left:= _Position.X;
     Top := _Position.Y;
     //SystemParametersInfo( SPI_GETWORKAREA, 0, @WorkArea, 0);
     if BoundsRect.Bottom > WorkArea.Bottom
     then
         Top:= WorkArea.Bottom - Height;
     if BoundsRect.Right > WorkArea.Right
     then
         Left:= WorkArea.Right - Width;

     mc.DateTime:= Int( _D);
     Result:= ShowModal = mrOK;
     if Result
     then
         _D:= Int(mc.DateTime)+Frac(_D);
end;

procedure TfChamp_Date.mcKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
     case Key
     of
       VK_RETURN: ModalResult:= mrOk;
       VK_ESCAPE,
       VK_CANCEL: ModalResult:= mrCancel;
       end;

end;

procedure TfChamp_Date.WndProc(var Message: TMessage);
begin
     inherited;
     (*
     if     (Message.Msg = WM_NOTIFY)
     then
         if TWMNotify(Message).NMHdr^.code =  MCN_SELECT
         then
             ModalResult:= mrOk;
     *)
end;

initialization
finalization
              Clean_Destroy( FfChamp_Date);
end.
