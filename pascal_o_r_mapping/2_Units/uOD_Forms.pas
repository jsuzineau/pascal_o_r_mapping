unit uOD_Forms;
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
{$IFDEF LINUX}
  {$DEFINE uOD_Forms_console}
  {$UNDEF  uOD_Forms_graphic}
{$ENDIF}
{$IFDEF MSWINDOWS}
  {$UNDEF  uOD_Forms_console}
  {$DEFINE uOD_Forms_graphic}
{$ENDIF}

interface

function uOD_Forms_EXE_Name: String;

procedure uOD_Forms_ProcessMessages;

procedure uOD_Forms_Terminate;
function  uOD_Forms_Terminated: Boolean;

procedure uOD_Forms_Set_Hint( _S: String);

function  uOD_Forms_Title: string;

procedure uOD_Forms_CancelHint;

procedure uOD_Forms_ShowMessage( _S: String);

implementation

{$IFDEF uOD_Forms_graphic}
uses
    Forms, Dialogs;
{$ENDIF}

function uOD_Forms_EXE_Name: String;
begin
     Result:= ParamStr( 0);
end;

procedure uOD_Forms_ProcessMessages;
begin
     {$IFDEF uOD_Forms_graphic}
     Application.ProcessMessages;
     {$ENDIF}
end;
procedure uOD_Forms_Terminate;
begin
     {$IFDEF uOD_Forms_graphic}
     Application.Terminate;
     {$ENDIF}

     {$IFDEF uOD_Forms_console}
     Halt;
     {$ENDIF}
end;

function  uOD_Forms_Terminated: Boolean;
begin
     {$IFDEF uOD_Forms_graphic}
     Result:= Application.Terminated;
     {$ENDIF}
     {$IFDEF uOD_Forms_console}
     Result:= False;
     {$ENDIF}
end;

procedure uOD_Forms_Set_Hint( _S: String);
begin
     {$IFDEF uOD_Forms_graphic}
     Application.Hint:= _S;
     {$ENDIF}

     {$IFDEF uOD_Forms_console}
     WriteLn( _S);
     {$ENDIF}
end;

function  uOD_Forms_Title: string;
begin
     {$IFDEF uOD_Forms_graphic}
     Result:= Application.Title;
     {$ENDIF}
     {$IFDEF uOD_Forms_console}
     Result:= uOD_Forms_EXE_Name;
     {$ENDIF}
end;

procedure uOD_Forms_CancelHint;
begin
     {$IFDEF uOD_Forms_graphic}
     Application.CancelHint;
     {$ENDIF}
     {$IFDEF uOD_Forms_console}
     WriteLn;
     {$ENDIF}
end;

procedure uOD_Forms_ShowMessage( _S: String);
begin
     {$IFDEF uOD_Forms_graphic}
     ShowMessage( _S);
     {$ENDIF}
     {$IFDEF uOD_Forms_console}
     WriteLn( _S);
     {$ENDIF}
end;

initialization
finalization
end.
