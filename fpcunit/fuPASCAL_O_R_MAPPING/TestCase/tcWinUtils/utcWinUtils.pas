unit utcWinUtils;
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

{$mode objfpc}{$H+}

interface

uses
    uftcWinUtils,
 Classes, SysUtils, fpcunit, testutils, testregistry;

type

 TtcWinUtils
 =
  class(TTestCase)
  protected
   procedure SetUp; override;
   procedure TearDown; override;
  published
   procedure TestHookUp;
  end;

implementation

procedure TtcWinUtils.SetUp;
begin
end;

procedure TtcWinUtils.TearDown;
begin
end;

procedure TtcWinUtils.TestHookUp;
var
   f: TftcWinUtils;
begin
     f:= TftcWinUtils.Create( nil);
     f.ShowModal;
     FreeAndNil( f);
end;

initialization

 RegisterTest(TtcWinUtils);
end.

