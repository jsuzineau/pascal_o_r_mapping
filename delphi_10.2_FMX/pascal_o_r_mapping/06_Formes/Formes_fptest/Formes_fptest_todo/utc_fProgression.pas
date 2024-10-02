unit utc_fProgression;
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
  ufProgression,
  uftc_fProgression,
  TestFrameWork;

type
  Ttc_fProgression = class(TTestCase)
  private

  protected

//    procedure SetUp; override;
//    procedure TearDown; override;

  published

    // Test methods
    procedure TestDemarre;
    procedure TestTermine;
    procedure TestAddProgress;
    procedure Test;
  end;

implementation

{ Ttc_fProgression }

procedure Ttc_fProgression.TestDemarre;
begin
     fProgression.Demarre( 'test', 1, 100);
     fProgression.Demarre( 'sous-test', 1, 100);
end;

procedure Ttc_fProgression.TestAddProgress;
begin
     fProgression.AddProgress( 50);
end;

procedure Ttc_fProgression.TestTermine;
begin
     fProgression.Termine;
     fProgression.Termine;
end;

procedure Ttc_fProgression.Test;
begin
     ftc_fProgression.Show;
end;

initialization
  TestFramework.RegisterTest( 'utc_fProgression Suite', Ttc_fProgression.Suite);

end.
 
