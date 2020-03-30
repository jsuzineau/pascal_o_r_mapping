unit uFrequence;

{$mode delphi}

interface

uses
 Classes, SysUtils;

function sFrequence( _Frequence: double): String;

implementation

function sFrequence( _Frequence: double): String;
   procedure  Hz;begin Result:= FloatToStr( _Frequence     )+'  Hz'; end;
   procedure KHz;begin Result:= FloatToStr( _Frequence/1E3 )+' KHz'; end;
   procedure MHz;begin Result:= FloatToStr( _Frequence/1E6 )+' MHz'; end;
   procedure GHz;begin Result:= FloatToStr( _Frequence/1E9 )+' GHz'; end;
   procedure THz;begin Result:= FloatToStr( _Frequence/1E12)+' THz'; end;
begin
          if _Frequence < 1E3  then  Hz
     else if _Frequence < 1E6  then KHz
     else if _Frequence < 1E9  then MHz
     else if _Frequence < 1E12 then GHz
     else                           THz;
end;

end.

