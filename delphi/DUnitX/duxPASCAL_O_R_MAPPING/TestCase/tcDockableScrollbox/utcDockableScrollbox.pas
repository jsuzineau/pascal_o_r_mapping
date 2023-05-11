unit utcDockableScrollbox;
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
{$mode objfpc}{$H+}
{$ENDIF}


interface

uses
    uftcDockableScrollbox,
 Classes, DUnitX.TestFramework, System.SysUtils, Winapi.Windows, Winapi.ShellAPI;

type

 [TestFixture] TtcDockableScrollbox
 =
  class(TObject)
  public
   [Setup]    procedure SetUp;
   [TearDown] procedure TearDown;
  public
   [TestCase('TestHookUp','')] procedure TestHookUp;
  end;

implementation

procedure TtcDockableScrollbox.SetUp;
begin
end;

procedure TtcDockableScrollbox.TearDown;
begin
end;

procedure TtcDockableScrollbox.TestHookUp;
var
   f: TftcDockableScrollbox;
begin
     f:= TftcDockableScrollbox.Create( nil);
     f.ShowModal;
     FreeAndNil( f);
end;

initialization
              TDUnitX.RegisterTestFixture( TtcDockableScrollbox);
end.

