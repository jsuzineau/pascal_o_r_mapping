unit uftest_Audacity;

{$mode objfpc}{$H+}
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            http://www.mars42.com                                               |
                                                                                |
    Copyright 2022 Jean SUZINEAU - MARS42                                       |
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

interface

uses
 Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls;

const
     _to_name  = '\\.\pipe\ToSrvPipe'  ;
     _from_name= '\\.\pipe\FromSrvPipe';

type

 { Tftest_Audacity }

 Tftest_Audacity
 =
  class(TForm)
   bSend: TButton;
   bTest_Select_seconds: TButton;
   eSend: TEdit;
   m: TMemo;
   Panel1: TPanel;
   tStart: TTimer;
   procedure bSendClick(Sender: TObject);
   procedure bTest_Select_secondsClick(Sender: TObject);
   procedure FormCreate(Sender: TObject);
   procedure FormDestroy(Sender: TObject);
   procedure tTimer(Sender: TObject);
  private
   _to, _from: Text;
   Ouvert: Boolean;
   BatchCommand_finished: String;
   procedure Ouvrir;
   procedure Fermer;
   procedure Send_command( _command: String);
   function Get_response: string;
   procedure do_command( _command: String);
   procedure Test;
   procedure Log( _s: String);
   function Log_Ferme: Boolean;
   procedure Select_seconds( _Start, _End: double);
   procedure Test_Select_seconds;
  public

  end;

var
 ftest_Audacity: Tftest_Audacity;

implementation

{$R *.lfm}

{ Tftest_Audacity }

procedure Tftest_Audacity.FormCreate(Sender: TObject);
begin
     Ouvert:= False;
     AssignFile( _to  , _to_name  );
     AssignFile( _from, _from_name);
     tStart.Enabled:= True;
end;

procedure Tftest_Audacity.FormDestroy(Sender: TObject);
begin
     Fermer;
end;

procedure Tftest_Audacity.tTimer(Sender: TObject);
begin
     tStart.Enabled:= False;
     Ouvrir;
     Test;
end;

procedure Tftest_Audacity.Log(_s: String);
begin
     m.Lines.Add( _s);
     m.CaretPos:= TPoint.Create(1, m.Lines.Count-1);
end;

function Tftest_Audacity.Log_Ferme: Boolean;
begin
     Result:= not Ouvert;
     if Ouvert then exit;

     Log('Fermé');
end;

procedure Tftest_Audacity.Ouvrir;
begin
     Fermer;
     m.Text:= '';

     try
        Rewrite( _to  );
     except
           on Exception
           do
             begin
             Log('Echec à l''ouverture de '+_to_name);
             exit;
             end;
           end;
     try
        Reset  ( _from);
     except
           on Exception
           do
             begin
             CloseFile( _to);
             Log('Echec à l''ouverture de '+_from_name);
             end;
           end;

     Ouvert:= True;
end;

procedure Tftest_Audacity.Fermer;
begin
     if not Ouvert then exit;

     CloseFile( _to  );
     CloseFile( _from);
     Ouvert:= False;
     Log('Fermé');
end;

procedure Tftest_Audacity.Send_command( _command: String);
begin
     if Log_Ferme then exit;

     WriteLn( _to, _command);
     Flush( _to);
end;

function Tftest_Audacity.Get_response: string;
var
   Line: String;
   function process_BatchCommand_finished: Boolean;
   const
        s_BatchCommand_finished='BatchCommand finished:';
   begin
        Result:= 1 = Pos( s_BatchCommand_finished, Line);
        if not Result then exit;

        BatchCommand_finished
        :=
          Copy( Line,
                1+Length(s_BatchCommand_finished),
                Length(Line));
   end;
begin
     Result:= '';
     Line:= '';
     BatchCommand_finished:= '';

     if Log_Ferme then exit;

     while True
     do
       begin
       Readln( _from, Line);
       if ('' = Line) and ('' <> Result) then break;
       if process_BatchCommand_finished  then continue;
       Result:= Result + LineEnding + Line;
       end;
end;

procedure Tftest_Audacity.do_command(_command: String);
var
   response: String;
begin
     if Log_Ferme then exit;

     Log( 'Sent: '+_command);
     Send_command( _command);

     Log( 'Received: ');
     response:= Get_response;
     Log( response);
     Log( 'BatchCommand finished value : '+BatchCommand_finished);
end;

procedure Tftest_Audacity.Test;
begin
     if Log_Ferme then exit;

     do_command('Help: Command=Help');
     do_command('Help: Command="GetInfo"');
     do_command('Help:');
end;

procedure Tftest_Audacity.Select_seconds(_Start, _End: double);
begin
     //Send_command('Select:End="4327,532" Mode="Set" RelativeTo="ProjectStart" Start="4324,918"');
     Send_command(Format('Select:End="%.3f" Mode="Set" RelativeTo="ProjectStart" Start="%.3f"', [_End, _Start]));
end;

procedure Tftest_Audacity.Test_Select_seconds;
begin
     //Send_command('Select:End="4327,532" Mode="Set" RelativeTo="ProjectStart" Start="4324,918"');

     Select_seconds( 4324.918, 4327.532);
end;

procedure Tftest_Audacity.bSendClick(Sender: TObject);
begin
     do_command(eSend.Text);
     eSend.Text:= '';
end;

procedure Tftest_Audacity.bTest_Select_secondsClick(Sender: TObject);
begin
     Test_Select_seconds;
end;


end.

