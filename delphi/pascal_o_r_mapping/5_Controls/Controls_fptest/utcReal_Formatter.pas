unit utcReal_Formatter;
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
    SysUtils, Classes,
    TestFrameWork,
    uReal_Formatter;

type
 TtcReal_Formatter
 =
  class(TTestCase)
  private
    Value: Extended;
    sValue: String;
    Tronque: Boolean;
    Precision: Integer;
    procedure SetValue( _Value: Extended);
    procedure CheckText( Text: String); overload;
    procedure TestValue( _Value: Extended; see, s00, s000: String);
    procedure Dot_to_DecimalSeparator( var S: String);
  published
    procedure Teste;
  end;

implementation

{ TReal_Field_FormattersTests }

procedure TtcReal_Formatter.SetValue(_Value: Extended);
begin
     Value:= _Value;
     sValue:= Format('%.10f',[Value]);
end;

procedure TtcReal_Formatter.CheckText(Text: String);
var
   DisplayText: String;
   Messag: String;
begin
     DisplayText:= Format_Float( Value, Tronque, Precision);
     Messag:= Format( ' %s, Tronque:%s, Precision: %d'+
                      ' => %s, attendu: %s',
                      [ sValue,
                        BoolToStr(Tronque),
                        Precision,
                        DisplayText,
                        Text]);
     Check( DisplayText = Text, Messag);
end;

procedure TtcReal_Formatter.Dot_to_DecimalSeparator(var S: String);
var
   I: Integer;
begin
     for I:= 1 to Length( S) do if S[I]= '.' then S[I]:= DecimalSeparator;
end;

procedure TtcReal_Formatter.TestValue( _Value: Extended; see, s00, s000: String);
begin
     SetValue( _Value);
     Dot_to_DecimalSeparator( see  );
     Dot_to_DecimalSeparator( s00  );
     Dot_to_DecimalSeparator( s000 );

     Tronque:= True ;Precision:= 2;
     CheckText( see  );

     Tronque:= False;Precision:= 2;
     CheckText( s00  );

     Tronque:= False;Precision:= 3;
     CheckText( s000 );
end;

procedure TtcReal_Formatter.Teste;
begin
     TestValue( 0      , ' '   , ' '   , ' '    );
     TestValue( 0.00001, ' '   , ' '   , ' '    );
     TestValue( 1      , '1   ', '1.00', '1.000');
     TestValue( 1.2    , '1.2 ', '1.20', '1.200');
     TestValue( 1.25   , '1.25', '1.25', '1.250');
     TestValue( 1.256  , '1.26', '1.26', '1.256');
     TestValue( 1.2567 , '1.26', '1.26', '1.257');
     TestValue( 100000.2567 , '100 000.26', '100 000.26', '100 000.257');
end;

initialization
              TestFramework.RegisterTest( 'utcReal_Formatter Suite',
                                          TtcReal_Formatter.Suite);

end.

