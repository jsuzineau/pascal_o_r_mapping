program jsNote;

{$mode objfpc}

uses
 JS, Classes, SysUtils, Web;
function Midi_from_note( _note: String): Integer;
//C4=60
   function Base_from_Octave( _Octave:Integer): Integer;
   begin
        case _Octave
        of
          -1:   Result:=   0;
           0:   Result:=  12;
           1:   Result:=  24;
           2:   Result:=  36;
           3:   Result:=  48;
           4:   Result:=  60;
           5:   Result:=  72;
           6:   Result:=  84;
           7:   Result:=  96;
           8:   Result:= 108;
          else Result:= 0;
          end;
   end;
   function Offset_from_Note( _Note: Char): Integer;
   begin
        case _Note
        of
          'C':   Result:=  0;
          'D':   Result:=  2;
          'E':   Result:=  4;
          'F':   Result:=  5;
          'G':   Result:=  7;
          'A':   Result:=  9;
          'B':   Result:= 11;
          else   Result:=  0;
          end;
   end;
var
   Octave: Integer;
   Note: Char;
begin
     Octave:= StrToInt( Copy(_Note, 2, 1));
     Note:= _Note[1];
     Result:= Base_from_Octave( Octave)+Offset_from_Note( Note);
end;
procedure PlayNote( _N: Integer);
begin

end;
begin
     WriteLn( Midi_from_note('C3'));
end.
