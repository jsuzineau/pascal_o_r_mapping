unit utc_hDessinnateur_web;
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            partly as freelance: http://www.mars42.com                          |
        and partly as employee : http://www.batpro.com                          |
    Contact: gilles.doutre@batpro.com                                           |
                                                                                |
    Copyright 2016 Jean SUZINEAU - MARS42                                       |
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

{$mode objfpc}{$H+}

interface

uses
    uClean,
    uhDessinnateurWeb,
 Classes, SysUtils, fpcunit, testutils, testregistry;

type
 TTest_hDessinnateur_web
 =
  class(TTestCase)
  protected
   procedure SetUp; override;
   procedure TearDown; override;
  published
   procedure TestHookUp;
  //attributs
  private
    hdW: ThDessinnateurWeb;
  end;

implementation

procedure TTest_hDessinnateur_web.TestHookUp;
begin
     Fail('Écrivez votre propre test');
end;

procedure TTest_hDessinnateur_web.SetUp;
begin
     hdW:= ThDessinnateurWeb.Create( 1, 'Test', nil);
end;

procedure TTest_hDessinnateur_web.TearDown;
begin
     Free_nil( hdW);
end;

initialization

 RegisterTest(TTest_hDessinnateur_web);
end.

