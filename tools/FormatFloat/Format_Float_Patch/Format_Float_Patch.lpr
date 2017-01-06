program Format_Float_Patch;

uses
    SysUtils;


Function FloatToTextFmt_Original(Buffer: PChar; Value: Extended; format: PChar;FormatSettings : TFormatSettings): Integer;

Var
  Digits: String[40];                         { String Of Digits                 }
  Exponent: String[8];                        { Exponent strin                   }
  FmtStart, FmtStop: PChar;                   { Start And End Of relevant part   }
                                              { Of format String                 }
  ExpFmt, ExpSize: Integer;                   { Type And Length Of               }
                                              { exponential format chosen        }
  Placehold: Array[1..4] Of Integer;          { Number Of placeholders In All    }
                                              { four Sections                    }
  thousand: Boolean;                          { thousand separators?             }
  UnexpectedDigits: Integer;                  { Number Of unexpected Digits that }
                                              { have To be inserted before the   }
                                              { First placeholder.               }
  UnexpectedDigitsStart: Integer;             { Location in Digits where first unexpected Digit is located }
  DigitExponent: Integer;                     { Exponent Of First digit In       }
                                              { Digits Array.                    }

  { Find end of format section starting at P. False, if empty }

  Function GetSectionEnd(Var P: PChar): Boolean;
  Var
    C: Char;
    SQ, DQ: Boolean;
  Begin
    Result := False;
    SQ := False;
    DQ := False;
    C := P[0];
    While (C<>#0) And ((C<>';') Or SQ Or DQ) Do
      Begin
      Result := True;
      Case C Of
        #34: If Not SQ Then DQ := Not DQ;
        #39: If Not DQ Then SQ := Not SQ;
      End;
      Inc(P);
      C := P[0];
      End;
  End;

  { Find start and end of format section to apply. If section doesn't exist,
    use section 1. If section 2 is used, the sign of value is ignored.       }

  Procedure GetSectionRange(section: Integer);
  Var
    Sec: Array[1..3] Of PChar;
    SecOk: Array[1..3] Of Boolean;
  Begin
    Sec[1] := format;
    SecOk[1] := GetSectionEnd(Sec[1]);
    If section > 1 Then
      Begin
      Sec[2] := Sec[1];
      If Sec[2][0] <> #0 Then
        Inc(Sec[2]);
      SecOk[2] := GetSectionEnd(Sec[2]);
      If section > 2 Then
        Begin
        Sec[3] := Sec[2];
        If Sec[3][0] <> #0 Then
          Inc(Sec[3]);
        SecOk[3] := GetSectionEnd(Sec[3]);
        End;
      End;
    If Not SecOk[1] Then
      FmtStart := Nil
    Else
      Begin
      If Not SecOk[section] Then
        section := 1
      Else If section = 2 Then
        Value := -Value;   { Remove sign }
      If section = 1 Then FmtStart := format Else
        Begin
        FmtStart := Sec[section - 1];
        Inc(FmtStart);
        End;
      FmtStop := Sec[section];
      End;
  End;

  { Find format section ranging from FmtStart to FmtStop. }

  Procedure GetFormatOptions;
  Var
    Fmt: PChar;
    SQ, DQ: Boolean;
    area: Integer;
  Begin
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
    While Fmt < FmtStop Do
      Begin
      Case Fmt[0] Of
        #34:
          Begin
          If Not SQ Then
            DQ := Not DQ;
          Inc(Fmt);
          End;
        #39:
          Begin
          If Not DQ Then
            SQ := Not SQ;
          Inc(Fmt);
          End;
      Else
       { if not in quotes, then interpret}
        If Not (SQ Or DQ) Then
          Begin
          Case Fmt[0] Of
            '0':
              Begin
              Case area Of
                1:
                  area := 2;
                4:
                  Begin
                  area := 3;
                  Inc(Placehold[3], Placehold[4]);
                  Placehold[4] := 0;
                  End;
              End;
              Inc(Placehold[area]);
              Inc(Fmt);
              End;

            '#':
              Begin
              If area=3 Then
                area:=4;
              Inc(Placehold[area]);
              Inc(Fmt);
              End;
            '.':
              Begin
              If area<3 Then
                area:=3;
              Inc(Fmt);
              End;
            ',':
              Begin
              thousand := DefaultFormatSettings.ThousandSeparator<>#0;
              Inc(Fmt);
              End;
            'e', 'E':
              If ExpFmt = 0 Then
                Begin
                If (Fmt[0]='E') Then
                  ExpFmt:=1
                Else
                  ExpFmt := 3;
                Inc(Fmt);
                If (Fmt<FmtStop) Then
                  Begin
                  Case Fmt[0] Of
                    '+':
                      Begin
                      End;
                    '-':
                      Inc(ExpFmt);
                  Else
                    ExpFmt := 0;
                  End;
                  If ExpFmt <> 0 Then
                    Begin
                    Inc(Fmt);
                    ExpSize := 0;
                    While (Fmt<FmtStop) And
                          (ExpSize<4) And
                          (Fmt[0] In ['0'..'9']) Do
                      Begin
                      Inc(ExpSize);
                      Inc(Fmt);
                      End;
                    End;
                  End
                Else
                  { just e/E without subsequent +/- -> not exponential format,
                    but we have to simply print e/E literally }
                  ExpFmt:=0;
                End
              Else
                Inc(Fmt);
          Else { Case }
            Inc(Fmt);
          End; { Case }
          End  { Begin }
        Else
          Inc(Fmt);
      End; { Case }
      End; { While .. Begin }
  End;

  Procedure FloatToStr;

  Var
    I, J, Exp, Width, Decimals, DecimalPoint, len: Integer;

  Begin
    If ExpFmt = 0 Then
      Begin
      { Fixpoint }
      Decimals:=Placehold[3]+Placehold[4];
      Width:=Placehold[1]+Placehold[2]+Decimals;
      If (Decimals=0) Then
        Str(Value:Width:0,Digits)
      Else if Value>=0 then
        Str(Value:Width+1:Decimals,Digits)
      else
        Str(Value:Width+2:Decimals,Digits);
      len:=Length(Digits);
      { Find the decimal point }
      If (Decimals=0) Then
        DecimalPoint:=len+1
      Else
        DecimalPoint:=len-Decimals;
      { If value is very small, and no decimal places
        are desired, remove the leading 0.            }
      If (Abs(Value) < 1) And (Placehold[2] = 0) Then
        Begin
        If (Placehold[1]=0) Then
          Delete(Digits,DecimalPoint-1,1)
        Else
          Digits[DecimalPoint-1]:=' ';
        End;
      { Convert optional zeroes to spaces. }
      I:=len;
      J:=DecimalPoint+Placehold[3];
      While (I>J) And (Digits[I]='0') Do
        Begin
        Digits[I] := ' ';
        Dec(I);
        End;
      { If integer value and no obligatory decimal
        places, remove decimal point. }
      If (DecimalPoint < len) And (Digits[DecimalPoint + 1] = ' ') Then
          Digits[DecimalPoint] := ' ';
      { Convert spaces left from obligatory decimal point to zeroes.
        MVC : If - sign is encountered, replace it too, and put at position 1}
      I:=DecimalPoint-Placehold[2];
      J:=0;
      While (I<DecimalPoint) And (Digits[I] in [' ','-']) Do
        Begin
        If Digits[i]='-' then
          J:=I;
        Digits[I] := '0';
        Inc(I);
        End;
      If (J<>0) then
        Digits[1]:='-';
      Exp := 0;
      End
    Else
      Begin
      { Scientific: exactly <Width> Digits With <Precision> Decimals
        And adjusted Exponent. }
      If Placehold[1]+Placehold[2]=0 Then
        Placehold[1]:=1;
      Decimals := Placehold[3] + Placehold[4];
      Width:=Placehold[1]+Placehold[2]+Decimals;
      { depending on the maximally supported precision, the exponent field }
      { is longer/shorter                                                  }
{$ifdef FPC_HAS_TYPE_EXTENDED}
      Str(Value:Width+8,Digits);
{$else FPC_HAS_TYPE_EXTENDED}
{$ifdef FPC_HAS_TYPE_DOUBLE}
      Str(Value:Width+7,Digits);
{$else FPC_HAS_TYPE_DOUBLE}
      Str(Value:Width+6,Digits);
{$endif FPC_HAS_TYPE_DOUBLE}
{$endif FPC_HAS_TYPE_EXTENDED}

      { Find and cut out exponent. Always the
        last 6 characters in the string.
        -> 0000E+0000
        *** No, not always the last 6 characters, this depends on
            the maximally supported precision (JM)}
      I:=Pos('E',Digits);
      Val(Copy(Digits,I+1,255),Exp,J);
      Exp:=Exp+1-(Placehold[1]+Placehold[2]);
      Delete(Digits, I, 255);
      { Str() always returns at least one digit after the decimal point.
        If we don't want it, we have to remove it. }
      If (Decimals=0) And (Placehold[1]+Placehold[2]<= 1) Then
        Begin
        If (Digits[4]>='5') Then
          Begin
          Inc(Digits[2]);
          If (Digits[2]>'9') Then
            Begin
            Digits[2] := '1';
            Inc(Exp);
            End;
          End;
        Delete(Digits, 3, 2);
        DecimalPoint := Length(Digits) + 1;
        End
      Else
        Begin
        { Move decimal point at the desired position }
        Delete(Digits, 3, 1);
        DecimalPoint:=2+Placehold[1]+Placehold[2];
        If (Decimals<>0) Then
          Insert('.',Digits,DecimalPoint);
        End;

      { Convert optional zeroes to spaces. }
      I := Length(Digits);
      J := DecimalPoint + Placehold[3];
      While (I > J) And (Digits[I] = '0') Do
        Begin
        Digits[I] := ' ';
        Dec(I);
        End;

      { If integer number and no obligatory decimal paces, remove decimal point }

      If (DecimalPoint<Length(Digits)) And
         (Digits[DecimalPoint+1]=' ') Then
          Digits[DecimalPoint]:=' ';
      If (Digits[1]=' ') Then
        Begin
        Delete(Digits, 1, 1);
        Dec(DecimalPoint);
        End;
      { Calculate exponent string }
      Str(Abs(Exp), Exponent);
      While Length(Exponent)<ExpSize Do
        Insert('0',Exponent,1);
      If Exp >= 0 Then
        Begin
        If (ExpFmt In [1,3]) Then
          Insert('+', Exponent, 1);
        End
      Else
        Insert('-',Exponent,1);
      If (ExpFmt<3) Then
        Insert('E',Exponent,1)
      Else
        Insert('e',Exponent,1);
      End;
    DigitExponent:=DecimalPoint-2;
    I:=1;
    While (I<=Length(Digits)) and (Digits[i] in [' ','-']) do
      begin
      Dec(DigitExponent);
      Inc(i);
      end;
    UnexpectedDigits:=DecimalPoint-1-(Placehold[1]+Placehold[2]);
  End;

  Function PutResult: LongInt;

  Var
    SQ, DQ: Boolean;
    Fmt, Buf: PChar;
    Dig, N: Integer;

  Begin
    SQ := False;
    DQ := False;
    Fmt := FmtStart;
    Buf := Buffer;
    Dig := 1;
    While (Fmt<FmtStop) Do
      Begin
//      WriteLn('Treating : "',Fmt[0],'"');
      Case Fmt[0] Of
        #34:
          Begin
          If Not SQ Then
            DQ := Not DQ;
          Inc(Fmt);
          End;
        #39:
          Begin
          If Not DQ Then
            SQ := Not SQ;
          Inc(Fmt);
          End;
      Else
        If Not (SQ Or DQ) Then
          Begin
          Case Fmt[0] Of
            '0', '#', '.':
              Begin
              If (Dig=1) And (UnexpectedDigits>0) Then
                Begin
                { Everything unexpected is written before the first digit }
                For N := 1 To UnexpectedDigits Do
                  Begin
                    if (Digits[N]<>' ') Then
                    begin
                      Buf[0] := Digits[N];
                      Inc(Buf);
                    end;
                  If thousand And (Not (Digits[N] in [' ','-'])) Then
                    Begin
                    If (DigitExponent Mod 3 = 0) And (DigitExponent>0) Then
                      Begin
                      Buf[0] := FormatSettings.ThousandSeparator;
                      Inc(Buf);
                      End;
                    Dec(DigitExponent);
                    End;
                  End;
                Inc(Dig, UnexpectedDigits);
                End;
              If (Digits[Dig]<>' ') Then
                Begin
                If (Digits[Dig]='.') Then
                  Buf[0] := FormatSettings.DecimalSeparator
                Else
                  Buf[0] := Digits[Dig];
                Inc(Buf);
                If thousand And (DigitExponent Mod 3 = 0) And (DigitExponent > 0) and (Digits[Dig]<>'-') Then
                  Begin
                  Buf[0] := FormatSettings.ThousandSeparator;
                  Inc(Buf);
                  End;
                End;
              if Digits[Dig]<>'-' then
                Dec(DigitExponent);
              Inc(Dig);
              Inc(Fmt);
              End;
            'e', 'E':
              Begin
              If ExpFmt <> 0 Then
                Begin
                Inc(Fmt);
                If Fmt < FmtStop Then
                  Begin
                  If Fmt[0] In ['+', '-'] Then
                    Begin
                    Inc(Fmt, ExpSize);
                    For N:=1 To Length(Exponent) Do
                      Buf[N-1] := Exponent[N];
                    Inc(Buf,Length(Exponent));
                    ExpFmt:=0;
                    End;
                  Inc(Fmt);
                  End;
                End
              Else
                Begin
                { No legal exponential format.
                  Simply write the 'E' to the result. }
                Buf[0] := Fmt[0];
                Inc(Buf);
                Inc(Fmt);
                End;
              End;
          Else { Case }
            { Usual character }
            If (Fmt[0]<>',') Then
              Begin
              Buf[0] := Fmt[0];
              Inc(Buf);
              End;
            Inc(Fmt);
          End; { Case }
          End
        Else { IF }
          Begin
          { Character inside single or double quotes }
          Buf[0] := Fmt[0];
          Inc(Buf);
          Inc(Fmt);
          End;
      End; { Case }
    End; { While .. Begin }
    Result:=PtrUInt(Buf)-PtrUInt(Buffer);
  End;

Begin
  If (Value>0) Then
    GetSectionRange(1)
  Else If (Value<0) Then
    GetSectionRange(2)
  Else
    GetSectionRange(3);
  If FmtStart = Nil Then
    Begin
    Result := FloatToText(Buffer, Value, ffGeneral, 15, 4, FormatSettings);
    End
  Else
    Begin
    GetFormatOptions;
    If (ExpFmt = 0) And (Abs(Value) >= 1E18) Then
      Result := FloatToText(Buffer, Value, ffGeneral, 15, 4, FormatSettings)
    Else
      Begin
      FloatToStr;
      Result := PutResult;
      End;
    End;
End;


Function FloatToTextFmt(Buffer: PChar; Value: Extended; format: PChar;FormatSettings : TFormatSettings): Integer;

Var
  Digits: String[40];                         { String Of Digits                 }
  Exponent: String[8];                        { Exponent strin                   }
  FmtStart, FmtStop: PChar;                   { Start And End Of relevant part   }
                                              { Of format String                 }
  ExpFmt, ExpSize: Integer;                   { Type And Length Of               }
                                              { exponential format chosen        }
  Placehold: Array[1..4] Of Integer;          { Number Of placeholders In All    }
                                              { four Sections                    }
  thousand: Boolean;                          { thousand separators?             }
  UnexpectedDigits: Integer;                  { Number Of unexpected Digits that }
                                              { have To be inserted before the   }
                                              { First placeholder.               }
  UnexpectedDigitsStart: Integer;             { Location in Digits where first unexpected Digit is located }
  DigitExponent: Integer;                     { Exponent Of First digit In       }
                                              { Digits Array.                    }

  { Find end of format section starting at P. False, if empty }

  Function GetSectionEnd(Var P: PChar): Boolean;
  Var
    C: Char;
    SQ, DQ: Boolean;
  Begin
    Result := False;
    SQ := False;
    DQ := False;
    C := P[0];
    While (C<>#0) And ((C<>';') Or SQ Or DQ) Do
      Begin
      Result := True;
      Case C Of
        #34: If Not SQ Then DQ := Not DQ;
        #39: If Not DQ Then SQ := Not SQ;
      End;
      Inc(P);
      C := P[0];
      End;
  End;

  { Find start and end of format section to apply. If section doesn't exist,
    use section 1. If section 2 is used, the sign of value is ignored.       }

  Procedure GetSectionRange(section: Integer);
  Var
    Sec: Array[1..3] Of PChar;
    SecOk: Array[1..3] Of Boolean;
  Begin
    Sec[1] := format;
    SecOk[1] := GetSectionEnd(Sec[1]);
    If section > 1 Then
      Begin
      Sec[2] := Sec[1];
      If Sec[2][0] <> #0 Then
        Inc(Sec[2]);
      SecOk[2] := GetSectionEnd(Sec[2]);
      If section > 2 Then
        Begin
        Sec[3] := Sec[2];
        If Sec[3][0] <> #0 Then
          Inc(Sec[3]);
        SecOk[3] := GetSectionEnd(Sec[3]);
        End;
      End;
    If Not SecOk[1] Then
      FmtStart := Nil
    Else
      Begin
      If Not SecOk[section] Then
        section := 1
      Else If section = 2 Then
        Value := -Value;   { Remove sign }
      If section = 1 Then FmtStart := format Else
        Begin
        FmtStart := Sec[section - 1];
        Inc(FmtStart);
        End;
      FmtStop := Sec[section];
      End;
  End;

  { Find format section ranging from FmtStart to FmtStop. }

  Procedure GetFormatOptions;
  Var
    Fmt: PChar;
    SQ, DQ: Boolean;
    area: Integer;
  Begin
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
    While Fmt < FmtStop Do
      Begin
      Case Fmt[0] Of
        #34:
          Begin
          If Not SQ Then
            DQ := Not DQ;
          Inc(Fmt);
          End;
        #39:
          Begin
          If Not DQ Then
            SQ := Not SQ;
          Inc(Fmt);
          End;
      Else
       { if not in quotes, then interpret}
        If Not (SQ Or DQ) Then
          Begin
          Case Fmt[0] Of
            '0':
              Begin
              Case area Of
                1:
                  area := 2;
                4:
                  Begin
                  area := 3;
                  Inc(Placehold[3], Placehold[4]);
                  Placehold[4] := 0;
                  End;
              End;
              Inc(Placehold[area]);
              Inc(Fmt);
              End;

            '#':
              Begin
              If area=3 Then
                area:=4;
              Inc(Placehold[area]);
              Inc(Fmt);
              End;
            '.':
              Begin
              If area<3 Then
                area:=3;
              Inc(Fmt);
              End;
            ',':
              Begin
              thousand := DefaultFormatSettings.ThousandSeparator<>#0;
              Inc(Fmt);
              End;
            'e', 'E':
              If ExpFmt = 0 Then
                Begin
                If (Fmt[0]='E') Then
                  ExpFmt:=1
                Else
                  ExpFmt := 3;
                Inc(Fmt);
                If (Fmt<FmtStop) Then
                  Begin
                  Case Fmt[0] Of
                    '+':
                      Begin
                      End;
                    '-':
                      Inc(ExpFmt);
                  Else
                    ExpFmt := 0;
                  End;
                  If ExpFmt <> 0 Then
                    Begin
                    Inc(Fmt);
                    ExpSize := 0;
                    While (Fmt<FmtStop) And
                          (ExpSize<4) And
                          (Fmt[0] In ['0'..'9']) Do
                      Begin
                      Inc(ExpSize);
                      Inc(Fmt);
                      End;
                    End;
                  End
                Else
                  { just e/E without subsequent +/- -> not exponential format,
                    but we have to simply print e/E literally }
                  ExpFmt:=0;
                End
              Else
                Inc(Fmt);
          Else { Case }
            Inc(Fmt);
          End; { Case }
          End  { Begin }
        Else
          Inc(Fmt);
      End; { Case }
      End; { While .. Begin }
  End;

  Procedure FloatToStr;

  Var
    I, J, Exp, Width, Decimals, DecimalPoint, len: Integer;

  Begin
    If ExpFmt = 0 Then
      Begin
      { Fixpoint }
      Decimals:=Placehold[3]+Placehold[4];
      Width:=Placehold[1]+Placehold[2]+Decimals;
      If (Decimals=0) Then
        Str(Value:Width:0,Digits)
      Else if Value>=0 then
        Str(Value:Width+1:Decimals,Digits)
      else
        Str(Value:Width+2:Decimals,Digits);
      len:=Length(Digits);
      { Find the decimal point }
      If (Decimals=0) Then
        DecimalPoint:=len+1
      Else
        DecimalPoint:=len-Decimals;
      { If value is very small, and no decimal places
        are desired, remove the leading 0.            }
      If (Abs(Value) < 1) And (Placehold[2] = 0) Then
        Begin
        If (Placehold[1]=0) Then
          Delete(Digits,DecimalPoint-1,1)
        Else
          Digits[DecimalPoint-1]:=' ';
        End;
      { Convert optional zeroes to spaces. }
      I:=len;
      J:=DecimalPoint+Placehold[3];
      While (I>J) And (Digits[I]='0') Do
        Begin
        Digits[I] := ' ';
        Dec(I);
        End;
      { If integer value and no obligatory decimal
        places, remove decimal point. }
      If (DecimalPoint < len) And (Digits[DecimalPoint + 1] = ' ') Then
          Digits[DecimalPoint] := ' ';
      { Convert spaces left from obligatory decimal point to zeroes.
        MVC : If - sign is encountered, replace it too, and put at position 1}
      I:=DecimalPoint-Placehold[2];
      J:=0;
      While (I<DecimalPoint) And (Digits[I] in [' ','-']) Do
        Begin
        If Digits[i]='-' then
          J:=I;
        Digits[I] := '0';
        Inc(I);
        End;
      If (J<>0) then
        Digits[1]:='-';
      Exp := 0;
      End
    Else
      Begin
      { Scientific: exactly <Width> Digits With <Precision> Decimals
        And adjusted Exponent. }
      If Placehold[1]+Placehold[2]=0 Then
        Placehold[1]:=1;
      Decimals := Placehold[3] + Placehold[4];
      Width:=Placehold[1]+Placehold[2]+Decimals;
      { depending on the maximally supported precision, the exponent field }
      { is longer/shorter                                                  }
{$ifdef FPC_HAS_TYPE_EXTENDED}
      Str(Value:Width+8,Digits);
{$else FPC_HAS_TYPE_EXTENDED}
{$ifdef FPC_HAS_TYPE_DOUBLE}
      Str(Value:Width+7,Digits);
{$else FPC_HAS_TYPE_DOUBLE}
      Str(Value:Width+6,Digits);
{$endif FPC_HAS_TYPE_DOUBLE}
{$endif FPC_HAS_TYPE_EXTENDED}

      { Find and cut out exponent. Always the
        last 6 characters in the string.
        -> 0000E+0000
        *** No, not always the last 6 characters, this depends on
            the maximally supported precision (JM)}
      I:=Pos('E',Digits);
      Val(Copy(Digits,I+1,255),Exp,J);
      Exp:=Exp+1-(Placehold[1]+Placehold[2]);
      Delete(Digits, I, 255);
      { Str() always returns at least one digit after the decimal point.
        If we don't want it, we have to remove it. }
      If (Decimals=0) And (Placehold[1]+Placehold[2]<= 1) Then
        Begin
        If (Digits[4]>='5') Then
          Begin
          Inc(Digits[2]);
          If (Digits[2]>'9') Then
            Begin
            Digits[2] := '1';
            Inc(Exp);
            End;
          End;
        Delete(Digits, 3, 2);
        DecimalPoint := Length(Digits) + 1;
        End
      Else
        Begin
        { Move decimal point at the desired position }
        Delete(Digits, 3, 1);
        DecimalPoint:=2+Placehold[1]+Placehold[2];
        If (Decimals<>0) Then
          Insert('.',Digits,DecimalPoint);
        End;

      { Convert optional zeroes to spaces. }
      I := Length(Digits);
      J := DecimalPoint + Placehold[3];
      While (I > J) And (Digits[I] = '0') Do
        Begin
        Digits[I] := ' ';
        Dec(I);
        End;

      { If integer number and no obligatory decimal paces, remove decimal point }

      If (DecimalPoint<Length(Digits)) And
         (Digits[DecimalPoint+1]=' ') Then
          Digits[DecimalPoint]:=' ';
      If (Digits[1]=' ') Then
        Begin
        Delete(Digits, 1, 1);
        Dec(DecimalPoint);
        End;
      { Calculate exponent string }
      Str(Abs(Exp), Exponent);
      While Length(Exponent)<ExpSize Do
        Insert('0',Exponent,1);
      If Exp >= 0 Then
        Begin
        If (ExpFmt In [1,3]) Then
          Insert('+', Exponent, 1);
        End
      Else
        Insert('-',Exponent,1);
      If (ExpFmt<3) Then
        Insert('E',Exponent,1)
      Else
        Insert('e',Exponent,1);
      End;
    DigitExponent:=DecimalPoint-2;
    I:=1;
    While (I<=Length(Digits)) and (Digits[i] in [' ','-']) do
      begin
      Dec(DigitExponent);
      if ' ' = Digits[i]
      then
          begin
          Delete( Digits, I, 1);
          Inc(FmtStart);
          end
      else
          Inc(i);
      end;
    UnexpectedDigits:=DecimalPoint-1-(Placehold[1]+Placehold[2]);
  End;

  Function PutResult: LongInt;

  Var
    SQ, DQ: Boolean;
    Fmt, Buf: PChar;
    Dig, N: Integer;

  Begin
    SQ := False;
    DQ := False;
    Fmt := FmtStart;
    Buf := Buffer;
    Dig := 1;
    While (Fmt<FmtStop) Do
      Begin
//      WriteLn('Treating : "',Fmt[0],'"');
      Case Fmt[0] Of
        #34:
          Begin
          If Not SQ Then
            DQ := Not DQ;
          Inc(Fmt);
          End;
        #39:
          Begin
          If Not DQ Then
            SQ := Not SQ;
          Inc(Fmt);
          End;
      Else
        If Not (SQ Or DQ) Then
          Begin
          Case Fmt[0] Of
            '0', '#', '.':
              Begin
              If (Dig=1) And (UnexpectedDigits>0) Then
                Begin
                { Everything unexpected is written before the first digit }
                For N := 1 To UnexpectedDigits Do
                  Begin
                    if (Digits[N]<>' ') Then
                    begin
                      Buf[0] := Digits[N];
                      Inc(Buf);
                    end;
                  If thousand And (Not (Digits[N] in [' ','-'])) Then
                    Begin
                    If (DigitExponent Mod 3 = 0) And (DigitExponent>0) Then
                      Begin
                      Buf[0] := FormatSettings.ThousandSeparator;
                      Inc(Buf);
                      End;
                    Dec(DigitExponent);
                    End;
                  End;
                Inc(Dig, UnexpectedDigits);
                End;
              If (Digits[Dig]<>' ') Then
                Begin
                If (Digits[Dig]='.') Then
                  Buf[0] := FormatSettings.DecimalSeparator
                Else
                  Buf[0] := Digits[Dig];
                Inc(Buf);
                If thousand And (DigitExponent Mod 3 = 0) And (DigitExponent > 0) and (Digits[Dig]<>'-') Then
                  Begin
                  Buf[0] := FormatSettings.ThousandSeparator;
                  Inc(Buf);
                  End;
                End;
              if Digits[Dig]<>'-' then
                Dec(DigitExponent);
              Inc(Dig);
              if Dig > Length( Digits)
              then
                  Fmt:= FmtStop;
              Inc(Fmt);
              End;
            'e', 'E':
              Begin
              If ExpFmt <> 0 Then
                Begin
                Inc(Fmt);
                If Fmt < FmtStop Then
                  Begin
                  If Fmt[0] In ['+', '-'] Then
                    Begin
                    Inc(Fmt, ExpSize);
                    For N:=1 To Length(Exponent) Do
                      Buf[N-1] := Exponent[N];
                    Inc(Buf,Length(Exponent));
                    ExpFmt:=0;
                    End;
                  Inc(Fmt);
                  End;
                End
              Else
                Begin
                { No legal exponential format.
                  Simply write the 'E' to the result. }
                Buf[0] := Fmt[0];
                Inc(Buf);
                Inc(Fmt);
                End;
              End;
          Else { Case }
            { Usual character }
            If (Fmt[0]<>',') Then
              Begin
              Buf[0] := Fmt[0];
              Inc(Buf);
              End;
            Inc(Fmt);
          End; { Case }
          End
        Else { IF }
          Begin
          { Character inside single or double quotes }
          Buf[0] := Fmt[0];
          Inc(Buf);
          Inc(Fmt);
          End;
      End; { Case }
    End; { While .. Begin }
    Result:=PtrUInt(Buf)-PtrUInt(Buffer);
  End;

Begin
  If (Value>0) Then
    GetSectionRange(1)
  Else If (Value<0) Then
    GetSectionRange(2)
  Else
    GetSectionRange(3);
  If FmtStart = Nil Then
    Begin
    Result := FloatToText(Buffer, Value, ffGeneral, 15, 4, FormatSettings);
    End
  Else
    Begin
    GetFormatOptions;
    If (ExpFmt = 0) And (Abs(Value) >= 1E18) Then
      Result := FloatToText(Buffer, Value, ffGeneral, 15, 4, FormatSettings)
    Else
      Begin
      FloatToStr;
      Result := PutResult;
      End;
    End;
End;



Function FormatFloat(Const Format : String; Value : Extended; Const FormatSettings: TFormatSettings) : String;

Var
  buf : Array[0..1024] of char;

Begin // not changed to pchar(pointer(). Possibly not safe
  Buf[FloatToTextFmt(@Buf[0],Value,Pchar(Format),FormatSettings)]:=#0;
  Result:=StrPas(@Buf[0]);
End;

Function FormatFloat(Const format: String; Value: Extended): String;

begin
  Result:=FormatFloat(Format,Value,DefaultFormatSettings);
end;

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

