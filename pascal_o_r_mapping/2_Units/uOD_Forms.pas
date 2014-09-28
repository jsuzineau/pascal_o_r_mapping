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
{$IFDEF FPC}
{$DEFINE uOD_Forms_console}
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

function uOD_Forms_EXE_Name: String;
begin
     Result:= ParamStr( 0);
end;

{$IFDEF uOD_Forms_console}
procedure uOD_Forms_ProcessMessages;
begin

end;
procedure uOD_Forms_Terminate;
begin
     Halt;
end;

function  uOD_Forms_Terminated: Boolean;
begin
     Result:= False;
end;

procedure uOD_Forms_Set_Hint( _S: String);
begin
     {$IF DEFINED(FPC) AND NOT DEFINED(MSWINDOWS)}
     WriteLn( _S);
     {$ENDIF}
end;

function  uOD_Forms_Title: string;
begin
     Result:= uOD_Forms_EXE_Name;
end;

procedure uOD_Forms_CancelHint;
begin
     {$IF DEFINED(FPC) AND NOT DEFINED(MSWINDOWS)}
     WriteLn;
     {$ENDIF}
end;

procedure uOD_Forms_ShowMessage( _S: String);
begin
     {$IF DEFINED(FPC) AND NOT DEFINED(MSWINDOWS)}
     WriteLn( _S);
     {$ENDIF}
end;
{$ELSE}
uses
    Forms, Dialogs;

procedure uOD_Forms_ProcessMessages;
begin
     Application.ProcessMessages;
end;

procedure uOD_Forms_Terminate;
begin
     Application.Terminate;
end;

function  uOD_Forms_Terminated: Boolean;
begin
     Result:= Application.Terminated;
end;

procedure uOD_Forms_Set_Hint( _S: String);
begin
     Application.Hint:= _S;
end;

function  uOD_Forms_Title: string;
begin
     Result:= Application.Title;
end;

procedure uOD_Forms_CancelHint;
begin
     Application.CancelHint;
end;
procedure uOD_Forms_ShowMessage( _S: String);
begin
     ShowMessage( _S);
end;
{$ENDIF}

initialization
finalization
end.
