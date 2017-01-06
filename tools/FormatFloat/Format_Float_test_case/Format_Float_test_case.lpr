program Format_Float_test_case;

uses
    SysUtils;

procedure Test;
var
   T, D: Char;
   procedure TestCase( _Value: extended; _Format, _Expected: String);
   var
      Obtained: String;
      S: String;
      Bug: String;
   begin
        Obtained:= Format( '%:20s' ,[FormatFloat( _Format, _Value)]);
        if Trim(Obtained) = Trim(_Expected)
        then
            Bug:=' OK '
        else
            Bug:=' Bug';
        S
        :=
            ' Format:'  + Format( '%:20s',[_Format])
          + Bug
          + ' Obtained:'+ Obtained
          + ' Expected:'+_Expected
          ;
        WriteLn( S);
   end;
begin
     T:= DefaultFormatSettings.ThousandSeparator;
     D:= DefaultFormatSettings.DecimalSeparator;
     TestCase(  9999.99,  '#,###,###,###,###.00','9'+T+'999'+D+'99');
     TestCase(  9999.99,    '###,###,###,###.00','9'+T+'999'+D+'99');
     TestCase(  9999.99,     '##,###,###,###.00','9'+T+'999'+D+'99');
     TestCase(  9999.99,      '#,###,###,###.00','9'+T+'999'+D+'99');
     TestCase(  9999.99,        '###,###,###.00','9'+T+'999'+D+'99');
     TestCase(  9999.99,         '##,###,###.00','9'+T+'999'+D+'99');
     TestCase(  9999.99,          '#,###,###.00','9'+T+'999'+D+'99');
     TestCase(  9999.99,            '###,###.00','9'+T+'999'+D+'99');
     TestCase(  9999.99,             '##,###.00','9'+T+'999'+D+'99');
     TestCase(  9999.99,              '#,###.00','9'+T+'999'+D+'99');
     TestCase(  9999.99,                '###.00',' 9999'+D+'99');
     TestCase( -9999.99,        '###,###,###.00','-9'+T+'999'+D+'99');
     TestCase( -9999.99,         '##,###,###.00','-9'+T+'999'+D+'99');
     TestCase( -9999.99,          '#,###,###.00','-9'+T+'999'+D+'99');
     TestCase( -9999.99,            '###,###.00','-9'+T+'999'+D+'99');
     TestCase( -9999.99,             '##,###.00','-9'+T+'999'+D+'99');
     TestCase( -9999.99,              '#,###.00','-9'+T+'999'+D+'99');
     TestCase( -9999.99,                '###.00','-9999'+D+'99');
     TestCase( -10     ,        '###,###,##0.00','-10.00'); //bug freepascal 13076
end;

begin
     Test;
end.

