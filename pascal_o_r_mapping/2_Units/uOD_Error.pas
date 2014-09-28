unit uOD_Error;
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
    uOD_Forms,
  SysUtils, Classes, Variants;

type
 Tprocedure_OD_Error_CallBack= procedure ( _Message: String) of Object;
 TOD_Error
 =
  class
  //cycle de vie
  public
    constructor Create;
    destructor Destroy; override;
  //Callback
  public
    CallBack: Tprocedure_OD_Error_CallBack;
  //Methodes
  public
    procedure Execute( _Message: String);
  end;

function OD_Error: TOD_Error;
  
implementation

var
   FOD_Error: TOD_Error = nil;

function OD_Error: TOD_Error;
begin
     if FOD_Error = nil
     then
         FOD_Error:= TOD_Error.Create;

     Result:= FOD_Error;
end;

{ TOD_Error }

constructor TOD_Error.Create;
begin
     CallBack:= nil;
end;

destructor TOD_Error.Destroy;
begin
     inherited;
end;

procedure TOD_Error.Execute(_Message: String);
begin
     if Assigned( CallBack)
     then
         CallBack( _Message)
     else
         uOD_Forms_ShowMessage( _Message);
end;

initialization

finalization
            FreeAndNil( FOD_Error);
end.
