unit uacCloud_Filter;

{$mode Delphi}

interface

uses
    uClean,
    uDataUtilsU,
    uLog,
    uChrono,
    uAPI_Client,
    uuStrings,
 Classes, SysUtils,StrUtils;

type

 { TacCloud_Filter }

 TacCloud_Filter
 =
  class( TAPI_Client)
    function Bad_reputation( _ip: String): Boolean;
  end;

implementation

{ TacCloud_Filter }

function TacCloud_Filter.Bad_reputation(_ip: String): Boolean;
var
   html: String;
   i: Integer;
begin
     html
     :=
       GET( 'Bad_reputation',
            'https://cloudfilt.com/ip-reputation/lookup?ip='+_ip);
     i:= Pos( _ip+' Has a bad reputation', html);
     Result:= i > 0;
end;

end.

