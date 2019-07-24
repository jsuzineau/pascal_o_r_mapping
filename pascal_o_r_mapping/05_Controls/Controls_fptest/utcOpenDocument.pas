unit utcOpenDocument;
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            partly as freelance: http://www.mars42.com                          |
        and partly as employee : http://www.batpro.com                          |
    Contact: gilles.doutre@batpro.com                                           |
                                                                                |
    Copyright 2012,2014 Jean SUZINEAU - MARS42                                  |
    Copyright 2012,2014 Cabinet Gilles DOUTRE - BATPRO                          |
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
    uOpenDocument,
  TestFrameWork,
  SysUtils, Classes;

type
 TtcOpenDocument
 =
  class(TTestCase)
  published
    procedure Test_CellName_from_XY;
    procedure Test_XY_from_CellName;
  end;

implementation

{ TtcOpenDocument }

procedure TtcOpenDocument.Test_CellName_from_XY;
   procedure Test( X, Y: Integer; Attendu: String);
   var
      Obtenu: String;
   begin
        Obtenu:= CellName_from_XY( X, Y);
        Check( Obtenu = Attendu,  'Echec de CellName_from_XY('+IntTosTr(X)+','+IntTosTr(Y)+'), '
                                 +'attendu '+Attendu
                                 +'obtenu  '+Obtenu );
   end;

begin
     Test( 0             , 0, 'A1'  );
     Test( 1             , 5, 'B6'  );
     Test( 26            , 2, 'AA3' );
     Test( 2*26*26+3*26+3, 2, 'BCD3');
end;

procedure TtcOpenDocument.Test_XY_from_CellName;
   procedure Test( CellName: String; Xattendu, Yattendu: Integer);
   var
      XObtenu, YObtenu: Integer;
   begin
        XY_from_CellName( CellName, XObtenu, YObtenu);
        Check( XObtenu = XAttendu,  'Echec de XY_from_CellName('+CellName+'), '
                                   +'X attendu '+IntToStr( XAttendu)+' '
                                   +'X obtenu  '+IntToStr( XObtenu ));
        Check( YObtenu = YAttendu,  'Echec de XY_from_CellName('+CellName+'), '
                                   +'Y attendu '+IntToStr( YAttendu)+' '
                                   +'Y obtenu  '+IntToStr( YObtenu ));
   end;
begin
     Test( 'A1'  , 0             , 0);
     Test( 'B6'  , 1             , 5);
     Test( 'AA3' , 26            , 2);
     Test( 'BCD3', 2*26*26+3*26+3, 2);
end;

initialization
  TestFramework.RegisterTest('utcOpenDocument Suite',
    TtcOpenDocument.Suite);

end.
