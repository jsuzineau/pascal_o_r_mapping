unit Unit1;

{$mode objfpc}{$H+}

interface

uses
Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

{ TForm1 }

TForm1 = class(TForm)
 m: TMemo;
  procedure FormCreate(Sender : TObject);
private
  { private declarations }
public
  { public declarations }
end;

var
Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

function FloatToTextFmt( Buffer : PChar;
                         Value : extended;
                         format : PChar;
                         FormatSettings : TFormatSettings) : integer;

var
   Digits: string[40];                         { String Of Digits                 }
   Exponent: string[8];                        { Exponent strin                   }
   FmtStart, FmtStop: PChar;                   { Start And End Of relevant part   }
   { Of format String                 }
   ExpFmt, ExpSize: integer;                   { Type And Length Of               }
   { exponential format chosen        }
   Placehold: array[1..4] of integer;          { Number Of placeholders In All    }
   { four Sections                    }
   thousand: boolean;                          { thousand separators?             }
   UnexpectedDigits: integer;                  { Number Of unexpected Digits that }
   { have To be inserted before the   }
   { First placeholder.               }
   UnexpectedDigitsStart: integer;
   { Location in Digits where first unexpected Digit is located }
   DigitExponent: integer;

   { Exponent Of First digit In       }
   { Digits Array.                    }

   { Find end of format section starting at P. False, if empty }

   function GetSectionEnd(var P : PChar) : boolean;
   var
      C: char;
      SQ, DQ: boolean;
   begin
        Result := False;
        SQ := False;
        DQ := False;
        C := P[0];
        while (C<>#0) and ((C<>';') or SQ or DQ)
        do
          begin
          Result := True;
          case C
          of
            #34: if not SQ then DQ := not DQ;
            #39: if not DQ then SQ := not SQ;
            end;
          Inc(P);
          C := P[0];
          end;
   end;

   { Find start and end of format section to apply. If section doesn't exist,
     use section 1. If section 2 is used, the sign of value is ignored.       }

   procedure GetSectionRange(section : integer);
   var
      Sec: array[1..3] of PChar;
      SecOk: array[1..3] of boolean;
   begin
        Sec[1] := format;
        SecOk[1] := GetSectionEnd(Sec[1]);
        if section > 1
        then
            begin
            Sec[2] := Sec[1];
            if Sec[2][0] <> #0 then Inc(Sec[2]);
            SecOk[2] := GetSectionEnd(Sec[2]);
            if section > 2
            then
                begin
                Sec[3] := Sec[2];
                if Sec[3][0] <> #0 then Inc(Sec[3]);
                SecOk[3] := GetSectionEnd(Sec[3]);
                end;
            end;
        if not SecOk[1]
        then
            FmtStart := nil
        else
            begin
                 if not SecOk[section] then section := 1
            else if section = 2        then Value := -Value;   { Remove sign }
            if section = 1
            then
                FmtStart := format
            else
                begin
                FmtStart := Sec[section - 1];
                Inc(FmtStart);
                end;
            FmtStop := Sec[section];
            end;
   end;

  { Find format section ranging from FmtStart to FmtStop. }

  procedure GetFormatOptions;
  var
     Fmt: PChar;
     SQ, DQ: boolean;
     area: integer;
  begin
       SQ := False;
       DQ := False;
       Fmt := FmtStart;
       ExpFmt := 0;
       area := 1;
       thousand := False;
       Placehold[1] := 0;
       Placehold[2] := 0;
       Placehold[3] := 0;
       Placehold[4] := 0;
       while Fmt < FmtStop
       do
         case Fmt[0]
         of
           #34:
             begin
             if not SQ then DQ := not DQ;
             Inc(Fmt);
             end;
           #39:
             begin
             if not DQ then SQ := not SQ;
             Inc(Fmt);
             end;
           else
             { if not in quotes, then interpret}
             if not (SQ or DQ)
             then
                 begin
                 case Fmt[0]
                 of
                   '0':
                     begin
                     case area
                     of
                       1: area := 2;
                       4:
                         begin
                         area := 3;
                         Inc(Placehold[3], Placehold[4]);
                         Placehold[4] := 0;
                         end;
                       end;
                     Inc(Placehold[area]);
                     Inc(Fmt);
                     end;

                   '#':
                     begin
                     if area = 3 then area := 4;
                     Inc(Placehold[area]);
                     Inc(Fmt);
                     end;
                   '.':
                     begin
                     if area<3 then area := 3;
                     Inc(Fmt);
                     end;
                   ',':
                     begin
                     thousand := DefaultFormatSettings.ThousandSeparator<>#0;
                     Inc(Fmt);
                     end;
                   'e', 'E':
                     if ExpFmt = 0
                     then
                         begin
                         if (Fmt[0] = 'E')
                         then
                             ExpFmt := 1
                         else
                             ExpFmt := 3;
                         Inc(Fmt);
                         if (Fmt<FmtStop)
                         then
                             begin
                             case Fmt[0]
                             of
                               '+': ;
                               '-': Inc(ExpFmt);
                               else ExpFmt := 0;
                               end;
                             if ExpFmt <> 0
                             then
                                 begin
                                 Inc(Fmt);
                                 ExpSize := 0;
                                 while      (Fmt<FmtStop)
                                       and  (ExpSize<4)
                                       and  (Fmt[0] in ['0'..'9'])
                                 do
                                   begin
                                   Inc(ExpSize);
                                   Inc(Fmt);
                                   end;
                                 end;
                             end
                         else
                             { just e/E without subsequent +/- -> not exponential format,
                             but we have to simply print e/E literally }
                             ExpFmt := 0;
                         end
                     else
                         Inc(Fmt);
                   else { Case } Inc(Fmt);
                   end; { Case }
                 end  { Begin }
             else
                 Inc(Fmt);
           end{ Case }; { While .. Begin }
  end;

  procedure FloatToStr;
  var
     I, J, Exp, Width, Decimals, DecimalPoint, len: integer;
  begin
       if ExpFmt = 0
       then
           begin
           { Fixpoint }
           Decimals:= Placehold[3]+Placehold[4];
           Width := Placehold[1]+Placehold[2]+Decimals;
                if (Decimals = 0) then Str(Value: Width  : 0       , Digits)
           else if Value>=0       then Str(Value: Width+1: Decimals, Digits)
           else                        Str(Value: Width+2: Decimals, Digits);
           len:= Length(Digits);
           { Find the decimal point }
           if (Decimals = 0)
           then
               DecimalPoint:= len+1
           else
               DecimalPoint := len-Decimals;
           { If value is very small, and no decimal places
           are desired, remove the leading 0.            }
           if (Abs(Value) < 1) and (Placehold[2] = 0)
           then
               if (Placehold[1] = 0)
               then
                   Delete(Digits, DecimalPoint-1, 1)
               else
                   Digits[DecimalPoint-1] := ' ';
           { Convert optional zeroes to spaces. }
           I := len;
           J := DecimalPoint+Placehold[3];
           while (I>J) and (Digits[I] = '0')
           do
             begin
             Digits[I] := ' ';
             Dec(I);
             end;
           { If integer value and no obligatory decimal
           places, remove decimal point. }
           if (DecimalPoint < len) and (Digits[DecimalPoint + 1] = ' ')
           then
               Digits[DecimalPoint] := ' ';
           { Convert spaces left from obligatory decimal point to zeroes.
           MVC : If - sign is encountered, replace it too, and put at position 1}
           I := DecimalPoint-Placehold[2];
           J := 0;
           while (I<DecimalPoint) and (Digits[I] in [' ', '-'])
           do
             begin
             if Digits[i] = '-' then J:= I;
             Digits[I] := '0';
             Inc(I);
             end;
           if (J<>0) then Digits[1] := '-';
           Exp := 0;
           end
       else
           begin
      { Scientific: exactly <Width> Digits With <Precision> Decimals
        And adjusted Exponent. }
      if Placehold[1]+Placehold[2] = 0 then
        Placehold[1] := 1;
      Decimals := Placehold[3] + Placehold[4];
      Width := Placehold[1]+Placehold[2]+Decimals;
      { depending on the maximally supported precision, the exponent field }
      { is longer/shorter                                                  }
{$ifdef FPC_HAS_TYPE_EXTENDED}
      Str(Value: Width+8, Digits);
{$else FPC_HAS_TYPE_EXTENDED}
{$ifdef FPC_HAS_TYPE_DOUBLE}
      Str(Value: Width+7, Digits);
{$else FPC_HAS_TYPE_DOUBLE}
      Str(Value: Width+6, Digits);
{$endif FPC_HAS_TYPE_DOUBLE}
{$endif FPC_HAS_TYPE_EXTENDED}

      { Find and cut out exponent. Always the
        last 6 characters in the string.
        -> 0000E+0000
        *** No, not always the last 6 characters, this depends on
            the maximally supported precision (JM)}
      I := Pos('E', Digits);
      Val(Copy(Digits, I+1, 255), Exp, J);
      Exp := Exp+1-(Placehold[1]+Placehold[2]);
      Delete(Digits, I, 255);
      { Str() always returns at least one digit after the decimal point.
        If we don't want it, we have to remove it. }
      if (Decimals = 0) and (Placehold[1]+Placehold[2]<= 1) then
      begin
        if (Digits[4]>='5') then
        begin
          Inc(Digits[2]);
          if (Digits[2]>'9') then
          begin
            Digits[2] := '1';
            Inc(Exp);
          end;
        end;
        Delete(Digits, 3, 2);
        DecimalPoint := Length(Digits) + 1;
      end
      else
      begin
        { Move decimal point at the desired position }
        Delete(Digits, 3, 1);
        DecimalPoint := 2+Placehold[1]+Placehold[2];
        if (Decimals<>0) then
          Insert('.', Digits, DecimalPoint);
      end;

      { Convert optional zeroes to spaces. }
      I := Length(Digits);
      J := DecimalPoint + Placehold[3];
      while (I > J) and (Digits[I] = '0') do
      begin
        Digits[I] := ' ';
        Dec(I);
      end;

      { If integer number and no obligatory decimal paces, remove decimal point }

      if (DecimalPoint<Length(Digits)) and  (Digits[DecimalPoint+1] = ' ') then
        Digits[DecimalPoint] := ' ';
      if (Digits[1] = ' ') then
      begin
        Delete(Digits, 1, 1);
        Dec(DecimalPoint);
      end;
      { Calculate exponent string }
      Str(Abs(Exp), Exponent);
      while Length(Exponent)<ExpSize do
        Insert('0', Exponent, 1);
      if Exp >= 0 then
      begin
        if (ExpFmt in [1, 3]) then
          Insert('+', Exponent, 1);
      end
      else
        Insert('-', Exponent, 1);
      if (ExpFmt<3) then
        Insert('E', Exponent, 1)
      else
        Insert('e', Exponent, 1);
    end;
    DigitExponent := DecimalPoint-2;
    I := 1;
    while (I<=Length(Digits)) and (Digits[i] in [' ', '-'])
    do
      begin
      Dec(DigitExponent);
      Inc(i);
      end;
    UnexpectedDigits := DecimalPoint-1-(Placehold[1]+Placehold[2]);
  end;

  function PutResult : longint;
  var
     SQ, DQ: boolean;
     Fmt, Buf: PChar;
     Dig, N: integer;
  begin
       SQ := False;
       DQ := False;
       Fmt := FmtStart;
       Buf := Buffer;
       Dig := 1;
       while (Fmt<FmtStop)
       do
         case Fmt[0]
         of
           #34:
             begin
             if not SQ then DQ := not DQ;
             Inc(Fmt);
             end;
           #39:
             begin
             if not DQ then SQ := not SQ;
             Inc(Fmt);
             end;
           else
               if not (SQ or DQ)
               then
                   begin
                   case Fmt[0]
                   of
                     '0', '#', '.':
                       begin
                       if (Dig = 1) and (UnexpectedDigits>0)
                       then
                           begin
                           { Everything unexpected is written before the first digit }
                           for N := 1 to UnexpectedDigits
                           do
                             begin
                             if (Digits[N]<>' ')
                             then
                                 begin
                                 Buf[0] := Digits[N];
                                 Inc(Buf);
                                 end;
                             if thousand and (not (Digits[N] in [' ', '-']))
                             then
                                 begin
                                 if (DigitExponent mod 3 = 0) and (DigitExponent>0)
                                 then
                                     begin
                                     Buf[0] := FormatSettings.ThousandSeparator;
                                     Inc(Buf);
                                     end;
                                 Dec(DigitExponent);
                                 end;
                             end;
                           Inc(Dig, UnexpectedDigits);
                           end;
                       if (Digits[Dig]<>' ')
                       then
                           begin
                           if (Digits[Dig] = '.')
                           then
                               Buf[0] := FormatSettings.DecimalSeparator
                           else
                               Buf[0] := Digits[Dig];
                           Inc(Buf);
                           if     thousand
                              and (DigitExponent mod 3 = 0)
                              and (  DigitExponent > 0) and (Digits[Dig]<>'-')
                           then
                               begin
                               Buf[0] := FormatSettings.ThousandSeparator;
                               Inc(Buf);
                               end;
                           end;
                       if Digits[Dig]<>'-'  then Dec(DigitExponent);
                       Inc(Dig);
                       Inc(Fmt);
                       end;
                     'e', 'E':
                       if ExpFmt <> 0
                       then
                           begin
                           Inc(Fmt);
                           if Fmt < FmtStop
                           then
                               begin
                               if Fmt[0] in ['+', '-']
                               then
                                   begin
                                   Inc(Fmt, ExpSize);
                                   for N := 1 to Length(Exponent)
                                   do
                                     Buf[N-1] := Exponent[N];
                                   Inc(Buf, Length(Exponent));
                                   ExpFmt := 0;
                                   end;
                               Inc(Fmt);
                               end;
                           end
                       else
                           begin
                           { No legal exponential format.
                           Simply write the 'E' to the result. }
                           Buf[0] := Fmt[0];
                           Inc(Buf);
                           Inc(Fmt);
                           end;
                     else { Case }
                         begin
                         { Usual character }
                         if (Fmt[0]<>',')
                         then
                             begin
                             Buf[0] := Fmt[0];
                             Inc(Buf);
                             end;
                         Inc(Fmt);
                         end;
                     end; { Case }
                   end
               else { IF }
                    begin
                    { Character inside single or double quotes }
                    Buf[0] := Fmt[0];
                    Inc(Buf);
                    Inc(Fmt);
                    end;
               end//      WriteLn('Treating : "',Fmt[0],'"');
    { Case }; { While .. Begin }
    Result := PtrUInt(Buf)-PtrUInt(Buffer);
  end;

begin
          if (Value>0) then GetSectionRange(1)
     else if (Value<0) then GetSectionRange(2)
     else                   GetSectionRange(3);
     if FmtStart = nil
     then
         Result := FloatToText(Buffer, Value, ffGeneral, 15, 4, FormatSettings)
     else
         begin
         GetFormatOptions;
         if (ExpFmt = 0) and (Abs(Value) >= 1E18)
         then
             Result := FloatToText(Buffer, Value, ffGeneral, 15, 4, FormatSettings)
         else
             begin
             FloatToStr;
             Result := PutResult;
             end;
         end;
end;

function FormatFloat( const Format : string;
                      Value : extended;
                      const FormatSettings : TFormatSettings) : string;
var
   buf: array[0..1024] of char;

begin // not changed to pchar(pointer(). Possibly not safe
     Buf[Unit1.FloatToTextFmt(@Buf[0], Value, PChar(Format), FormatSettings)] := #0;
     Result := StrPas(@Buf[0]);
end;

function FormatFloat(const format : string; Value : extended) : string;

begin
     Result := Unit1.FormatFloat(Format, Value, DefaultFormatSettings);
end;

function French_FormatFloat( _Value: Extended): String;
var
   iDecimalSeparator: Integer;
   iMax: Integer;
   I: Integer;
begin
     Result:= FormatFloat( '#.00', _Value);
     iDecimalSeparator:= Pos( DefaultFormatSettings.DecimalSeparator, Result);
     if 0 = iDecimalSeparator
     then
         iDecimalSeparator:= Length( Result)+1;

     for I:= iDecimalSeparator-1 downto 2
     do
       begin
       if (I-iDecimalSeparator) mod 3  = 0 then Insert(#$00A0, Result, I);
       end;
end;

procedure TForm1.FormCreate(Sender : TObject);
var
   T, D: Char;
     procedure TestCase( _Value: extended; _Format, _Expected: String);
     var
        S: String;
     begin
          S
          :=
              ' Format:'  + Format( '%:15s',[_Format])
            + ' Obtained:'+ Format( '%:8s' ,[FormatFloat( _Format, _Value)])
            + ' Expected:'+_Expected
            ;
          m.Lines.Add( S);
     end;
     procedure Test_French_FormatFloat( _Value: Extended);
     begin
          m.Lines.Add( ' French_FormatFloat:'+Format('%:20s',[French_FormatFloat( _Value)]));
     end;
begin
     m.Clear;
     T:= DefaultFormatSettings.ThousandSeparator;
     D:= DefaultFormatSettings.DecimalSeparator;
     m.Lines.Add( '#34='#34);
     m.Lines.Add( '#39='#39);
     m.Lines.Add( 'ThousandSeparator: '+IntToStr(Ord(T))+'='+T);
     TestCase( 9999.99, '###,###,###.00','9'+T+'999'+D+'99');
     TestCase( 9999.99,  '##,###,###.00','9'+T+'999'+D+'99');
     TestCase( 9999.99,   '#,###,###.00','9'+T+'999'+D+'99');
     TestCase( 9999.99,     '###,###.00','9'+T+'999'+D+'99');
     TestCase( 9999.99,      '##,###.00','9'+T+'999'+D+'99');
     TestCase( 9999.99,       '#,###.00','9'+T+'999'+D+'99');
     TestCase( 9999.99,         '###.00',' 9999'+D+'99');

     Test_French_FormatFloat(     9999.99);
     Test_French_FormatFloat(    99999.99);
     Test_French_FormatFloat(   999999.99);
     Test_French_FormatFloat(  9999999.99);
     Test_French_FormatFloat( 99999999.99);
     Test_French_FormatFloat( 999999999.99);
     Test_French_FormatFloat( 9999999999.99);
     Test_French_FormatFloat( 99999999999.99);
     Test_French_FormatFloat( -99999999999.99);
     Test_French_FormatFloat( -999999999999.99);

end;

end.





