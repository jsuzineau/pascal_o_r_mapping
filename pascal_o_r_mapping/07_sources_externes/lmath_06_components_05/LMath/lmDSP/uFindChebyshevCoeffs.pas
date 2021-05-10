 //CHEBYSHEV FILTER- RECURSION COEFFICIENT CALCULATION
unit uFindChebyshevCoeffs;
interface
uses uTypes, uErrors, uMath, uTrigo, uMeanSD, uMatrix, uConvolutions, uVectorHelper;

procedure FindChebyshevCoeffs(ASamplingRate, ACutFreq: float; AHighPass : boolean; PR: float;
   NPoles: integer; out A,B:TVector);

implementation
type
  TOne = array[0..2] of Float;

procedure ChebyshevParams(FC, PR : float; P, NP : integer; AHighPass: boolean; out AOne:TOne; out BOne:TOne);
var
  RP, IP, ES, VX, KX, T, W, M, D, K, X0, X1, X2, Y1, Y2 : float;
  Tquad : float;
// Calculate the pole location on the unit circle
begin
  RP := -cos(PiDiv2/NP + (P-1)*Pi/NP);
  IP :=  sin(PiDiv2/NP + (P-1)*Pi/NP);
// Warp from a circle to an ellipse
  IF PR <> 0 then 
  begin
    ES := Sqrt(Sqr(100/(100-PR)) - 1);
    VX := 1/NP*Log(1/ES + Sqrt(1/Sqr(ES) + 1));
    KX := 1/NP*Log(1/ES + Sqrt(1/Sqr(ES) - 1));
    KX := (EXP(KX) + EXP(-KX))/2;
    RP := RP * ((EXP(VX) - EXP(-VX)) /2 )/KX;
    IP := IP * ((EXP(VX) + EXP(-VX)) /2 )/KX;
  end;
  //s-domain to z-domain conversion
  T  := 2 * Tan(1/2);
  TQuad := T*T;
  W  := TwoPi*FC;
  M  := RP*RP + IP*IP;
  D  := 4 - 4*RP*T + M*TQuad;
  X0 := TQuad/D;
  X1 := 2*TQuad/D;
  X2 := TQuad/D;
  Y1 := (8 - 2*M*TQuad)/D;
  Y2 := (-4 - 4*RP*T - M*TQuad)/D;

 // LP TO LP, or LP TO HP transform
  IF AHighPass THEN 
    K := -Cos(W/2 + 1/2) / Cos(W/2 - 1/2)
  else
    K :=  Sin(1/2 - W/2) / Sin(1/2 + W/2);
  D  := 1 + Y1*K - Y2*K*K;
  AOne[0] := (X0 - X1*K + X2*K*K)/D;
  AOne[1] := (-2*X0*K + X1 + X1*K*K - 2*X2*K)/D;
  AOne[2] := (X0*K*K- X1*K + X2)/D;
  BOne[0] := 1;
  BOne[1] := (2*K + Y1 + Y1*K*K - 2*Y2*K)/D;
  BOne[2] := (-(K*K) - Y1*K + Y2)/D;
  IF AHighPass then
  begin
    AOne[1] := -AOne[1];
    BOne[1] := -BOne[1];
  end;
end;

// AHighPass: if we need high or low pass filter; PR percent of ripple in step response, 0 to 29
// NPoles must be even
procedure FindChebyshevCoeffs(ASamplingRate, ACutFreq: float; AHighPass : boolean; PR: float; 
   NPoles: integer; out A,B:TVector);
var
  TA, TB : TVector;
  FC: Float;
  I,J:integer;
  SA, SB, Gain: float;
  AOne:TOne;
  BOne:TOne;
  NP2:integer;
begin
  if NPoles Mod 2 <> 0 then
  begin
    A := nil;
    B := nil;
    SetErrCode(lmPolesNumError);
    exit;
  end;
  DimVector(A,NPoles); DimVector(TA,NPoles);
  DimVector(B,NPoles); DimVector(TB,NPoles);
  NP2 := NPoles + 2;
  A[0] := 1.0;
  B[0] := 1.0;

  FC := ACutFreq/ASamplingRate;
  FOR I := 1 to NPoles div 2 do //LOOP FOR EACH POLE-PAIR
  begin
    ChebyshevParams(FC, PR, I, NPoles, AHighPass, AOne, BOne);
    for J := 1 to 2 do
      BOne[J] := -BOne[J];
    TA.FillWithArr(0,A);
    TB.FillWithArr(0,B);
    Convolve(TA[0..(I-1)*2],AOne,A);
    Convolve(TB[0..(I-1)*2],BOne,B);
  end;

  B[0] := 0; //Finish combining coefficients B[0] := 0;
  B := B*(-1);
  SA := 0; SB := 0;
  FOR I := 0 to NPoles do
  begin
    if AHighPass and ((I mod 2) = 1) then
    begin
      SA := SA - A[I];
      SB := SB - B[I];
    end else
    begin
      SA := SA + A[I];
      SB := SB + B[I];
    end;
  end;
  GAIN := SA / (1 - SB);
  FOR I := 0 TO NPoles do
    A[I] := A[I] / GAIN;
//The final recursion coefficients are in A[ ] and B[ ]
end;

end.

