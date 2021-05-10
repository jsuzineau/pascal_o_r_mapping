unit uDFT;
//This unit merged "ftbase.pas" and "fft.pas" of ALGLIB 2.6 and did some modification.

{$mode objfpc}{$H+}

interface

uses
  SysUtils, utypes, uMinMax, uMath, ucomplex;

{1-dimensional complex FFT.
INPUT PARAMETERS
    A   -   array[0..N-1] - complex Function to be transformed
    N   -   problem size
OUTPUT PARAMETERS
    A   -   DFT of a input array, array[0..N-1]
            A_out[j] = SUM(A_in[k]*exp(-2*pi*sqrt(-1)*j*k/N), k = 0..N-1)
Array size N may be arbitrary number }
Procedure FFTC1D(var A:TCompVector; Lb,Ub:Integer);

{1-dimensional complex inverse FFT.
INPUT PARAMETERS
    A   -   array[0..N-1] - complex array to be transformed
    N   -   problem size
OUTPUT PARAMETERS
    A   -   inverse DFT of a input array, array[0..N-1]
            A_out[j] = SUM(A_in[k]/N*exp(+2*pi*sqrt(-1)*j*k/N), k = 0..N-1)
Array size N may be arbitrary number}
Procedure FFTC1DInv(var A:TCompVector; Lb,Ub:Integer);

{1-dimensional real FFT.
INPUT PARAMETERS
    A   -   array[0..N-1] - real Function to be transformed
    N   -   problem size
OUTPUT PARAMETERS
    F   -   DFT of a input array, array[0..N-1]
            F[j] = SUM(A[k]*exp(-2*pi*sqrt(-1)*j*k/N), k = 0..N-1)
NOTE:
    F[] satisfies symmetry property F[k] = conj(F[N-k]),  so just one half
of  array  is  usually needed. But for convinience subroutine returns full
complex array (with frequencies above N/2), so its result may be  used  by
other FFT-related subroutines.}
Procedure FFTR1D(const A:TVector; Lb,Ub:Integer; var F:TCompVector);

{1-dimensional real inverse FFT.
INPUT PARAMETERS
    F   -   array[0..floor(N/2)] - frequencies from forward real FFT
    N   -   problem size
OUTPUT PARAMETERS
    A   -   inverse DFT of a input array, array[0..N-1]
}
Procedure FFTR1DInv(const F:TCompVector; Lb,Ub:Integer; var A:TVector);

implementation
{//FTBase procedures & functions(just for internal)
Procedure FTBaseGenerateComplexFFTPlan(N:Integer; var Plan:FTPlan);
Procedure FTBaseGenerateRealFFTPlan(N:Integer; var Plan:FTPlan);
Procedure FTBaseGenerateRealFHTPlan(N:Integer; var Plan:FTPlan);
Procedure FTBaseExecutePlan(var A:TVector; AOffset,N:Integer; var Plan:FTPlan);
Procedure FTBaseExecutePlanRec(var A:TVector; AOffset:Integer; var Plan:FTPlan; EntryOffset,StackPtr:Integer);
Procedure FTBaseFactorize(N:Integer; var Factor1,Factor2:Integer);
Function FTBaseIsSmooth(N:Integer):Boolean;
Function FTBaseFindSmooth(N:Integer):Integer;
Function FTBaseFindSmoothEven(N:Integer):Integer;
Function FTBaseGetFLOPEstimate(N:Integer):Double;//}
{//Internal-only procedures
Procedure FFTR1DInternalEven(var A:TVector; N:Integer; var Buf:TVector; var Plan:FTPlan);
Procedure FFTR1DInvInternalEven(var A:TVector; N:Integer; var Buf:TVector; var Plan:FTPlan);//}

type
  TFTPlan = record
    Plan : TIntVector;
    Precomputed : TVector;
    TmpBuf : TVector;
    StackBuf : TVector;
  end;

Const
  FTBasePlanEntrySize:Integer     = 8;
  FTBaseCFFTTask:Integer          = 0;
  FTBaseRFHTTask:Integer          = 1;
  FTBaseRFFTTask:Integer          = 2;
  FFTCooleyTukeyPlan:Integer      = 0;
  FFTBluesteinPlan:Integer        = 1;
  FFTCodeletPlan:Integer          = 2;
  FHTCooleyTukeyPlan:Integer      = 3;
  FHTCodeletPlan:Integer          = 4;
  FFTRealCooleyTukeyPlan:Integer  = 5;
  FFTEmptyPlan:Integer            = 6;
  FHTN2Plan:Integer               = 999;
  FTBaseUpdateTw:Integer          = 4;
  FTBaseCodeletRecommended:Integer = 5;
  FTBaseInefficiencyFactor:Float  = 1.3;
  FTBaseMaxSmoothFactor:Integer   = 5;

Procedure FTBaseFactorize(N:Integer; var Factor1, Factor2:Integer);
//Factorize an Integer N to Factor1*Factor2
//The original Function uses "while loop" to do the "for loop" behavior. Rewrite it to "for loop".
var
  J,J2:Integer;

begin
  Factor1:=0;
  Factor2:=0;

  //try to find good codelet
  if ((Factor1*Factor2)<>N) then
  begin
    for J := 2 to FTBaseCodeletRecommended do
    begin
      J2:=FTBaseCodeletRecommended+2-J;
      if ((N mod J2)=0) then
      begin
        Factor1:=J2;
        Factor2:=N div J2;
        Break;
      end;
    end;
  end;

  //try to factorize N
  if ((Factor1*Factor2)<>N) then
  begin
    for J := (FTBaseCodeletRecommended+1) to (N-1) do
    begin
      if ((N mod J)=0) then
      begin
        Factor1:=J;
        Factor2:=N div J;
        Break;
      end;
    end;
  end;

  //N is prime number?
  if ((Factor1*Factor2)<>N) then
  begin
    Factor1:=1;
    Factor2:=N;
  end;

  //normalize
  if (Factor2=1) and (Factor1<>1) then
  begin
    Factor2:=Factor1;
    Factor1:=1;
  end;
end;

Function FTBaseIsSmooth(N:Integer):Boolean;
(*************************************************************************
Is number smooth?

  -- ALGLIB --
     Copyright 01.05.2009 by Bochkanov Sergey
*************************************************************************)
//The original Function uses "while loop" to do the "for loop" behavior. Rewrite it to "for loop".
var
I:Integer;

begin
  Result:=False;
  for I := 2 to FTBaseMaxSmoothFactor do
  begin
    while ((N mod I)=0) do
    begin
      N:=N div I;
    end;
  end;
  if (N=1) then Result:=True;
end;

Procedure FTBaseFindSmoothRec(N:Integer; Seed:Integer; LeastFactor:Integer; var Best:Integer);
(*************************************************************************
recurrent subroutine for FFTFindSmoothRec

  -- ALGLIB --
     Copyright 01.05.2009 by Bochkanov Sergey
*************************************************************************)
//Find the Smallest(but greater than or equal to N) Integer, which is divisible only by 2, 3, or 5.
//The original Procedure is recursive. For more understandable, redesign the workflow with "while loop".
var
TMPSeed2,TMPSeed3,TMPSeed5:Integer;

begin
  if (LeastFactor>5) and (Seed>=N) then
  begin
    Best:=Min(Best,Seed);
    Exit;
  end;

  if (LeastFactor<=2) then
  begin
    TMPSeed2:=Seed;
    while (TMPSeed2<N) do
    begin
      TMPSeed3:=TMPSeed2;
      while (TMPSeed3<N) do
      begin
        TMPSeed5:=TMPSeed3;
        while (TMPSeed5<N) do
        begin
          TMPSeed5:=TMPSeed5*5;
        end;
        Best:=Min(Best,TMPSeed5);
        TMPSeed3:=TMPSeed3*3;
      end;
      Best:=Min(Best,TMPSeed3);
      TMPSeed2:=TMPSeed2*2;
    end;
    Best:=Min(Best,TMPSeed2);
    Exit;
  end;

  if (LeastFactor<=3) then
  begin
    TMPSeed3:=Seed;
    while (TMPSeed3<N) do
    begin
      TMPSeed5:=TMPSeed3;
      while (TMPSeed5<N) do
      begin
        TMPSeed5:=TMPSeed5*5;
      end;
      Best:=Min(Best,TMPSeed5);
      TMPSeed3:=TMPSeed3*3;
    end;
    Best:=Min(Best,TMPSeed3);
    Exit;
  end;

  if (LeastFactor<=5) then
  begin
    TMPSeed5:=Seed;
    while (TMPSeed5<N) do
    begin
      TMPSeed5:=TMPSeed5*5;
    end;
    Best:=Min(Best,TMPSeed5);
    Exit;
  end;
end;

Function FTBaseFindSmooth(N:Integer):Integer;
(*************************************************************************
Returns smallest smooth (divisible only by 2, 3, 5) number that is greater
than or equal to max(N,2)

  -- ALGLIB --
     Copyright 01.05.2009 by Bochkanov Sergey
*************************************************************************)
//Returns smallest smooth (divisible only by 2, 3, 5) number that is greater than or equal to max(N,2)
var
  Best:Integer;

begin
  Best:=2;
  while (Best<N) do
  begin
    Best:=2*Best;
  end;
  FTBaseFindSmoothRec(N,1,2,Best);
  Result:=Best;
end;

Function FTBaseFindSmoothEven(N:Integer):Integer;
(*************************************************************************
Returns  smallest  smooth  (divisible only by 2, 3, 5) even number that is
greater than or equal to max(N,2)

  -- ALGLIB --
     Copyright 01.05.2009 by Bochkanov Sergey
*************************************************************************)
var
  Best:Integer;

begin
  Best:=2;
  while (Best<N) do
  begin
    Best:=2*Best;
  end;
  FTBaseFindSmoothRec(N,2,2,Best);
  Result:=Best;
end;

Function FTBaseGetFLOPEstimate(N:Integer):Float;
(*************************************************************************
Returns estimate of FLOP count for the FFT.

It is only an estimate based on operations count for the PERFECT FFT
and relative inefficiency of the algorithm actually used.

N should be power of 2, estimates are badly wrong for non-power-of-2 N's.

  -- ALGLIB --
     Copyright 01.05.2009 by Bochkanov Sergey
*************************************************************************)
begin
  Result:=FTBaseInefficiencyFactor*(4*N*Ln(N)/Ln(2)-6*N+8);
end;

Procedure FFTArrayResize(var A:TIntVector;var ASize:Integer;NewASize:Integer);
(*************************************************************************
Internal subroutine: array resize

  -- ALGLIB --
     Copyright 01.05.2009 by Bochkanov Sergey
*************************************************************************)
//Rewrited with object pascal's api
var
  TMP:TIntVector;

begin
  SetLength(TMP, ASize);
  Move(A[0],TMP[0],Asize*SizeOf(Integer)); //In FPC, the memory of elements in 1D dynamic array must be continuous.

  SetLength(A, NewASize);
  Move(TMP[0],A[0],Min(Asize,NewASize)*SizeOf(Integer)); //In FPC, the memory of 1D elements in dynamic array must be continuous.

  ASize:=NewASize;
end;

Procedure RefFHT(var A:TVector; N,Offs:Integer);
(*************************************************************************
Reference FHT stub
*************************************************************************)
//The original Procedure uses "while loop" to do the "for loop" behavior. Rewrite it to "for loop".
var
  Buf:TVector;
  I:Integer;
  J:Integer;
  V:Float;

begin
  Assert(N>0, 'RefFHTR1D: incorrect N!');
  SetLength(Buf, N);

  for I := 0 to (N-1) do
  begin
    V:=0;
    for J := 0 to (N-1) do
    begin
      V:=V+A[Offs+J]*(Cos(2*Pi*I*J/N)+Sin(2*Pi*I*J/N));
    end;
    Buf[I]:=V;
  end;

  for I := 0 to (N-1) do
  begin
    A[Offs+I]:= Buf[I];
  end;
end;

Procedure FFTICLTRec(var A:TVector; AStart,AStride:Integer; var B : TVector; BStart,BStride,M,N:Integer);
(*************************************************************************
Recurrent subroutine for a InternalComplexLinTranspose

Write A^T to B, where:
* A is m*n complex matrix stored in array A as pairs of real/image values,
  beginning from AStart position, with AStride stride
* B is n*m complex matrix stored in array B as pairs of real/image values,
  beginning from BStart position, with BStride stride
stride is measured in complex numbers, i.e. in real/image pairs.

  -- ALGLIB --
     Copyright 01.05.2009 by Bochkanov Sergey
*************************************************************************)
//Comment out small matrix check to skip unknown-purpose recursion
//The original Procedure uses "while loop" to do the "for loop" behavior. Rewrite it to "for loop".
var
  I,J,Idx1,Idx2,M2:Integer;

begin
  if (M=0) or (N=0) then Exit;

  M2:=2*BStride;
  for I := 0 to (M-1) do
  begin
    Idx1:=BStart+2*I;
    Idx2:=AStart+2*I*AStride;
    for J := 0 to (N-1) do
    begin
      B[Idx1+0]:=A[Idx2+0];
      B[Idx1+1]:=A[Idx2+1];
      Inc(Idx1,M2); //Idx1:=Idx1+M2;
      Inc(Idx2,2); //Idx2:=Idx2+2;
    end;
  end;

end;

Procedure FFTIRLTRec(var A:TVector; AStart,AStride:Integer; var B:TVector; BStart,BStride,M,N:Integer);
(*************************************************************************
Recurrent subroutine for a InternalRealLinTranspose


  -- ALGLIB --
     Copyright 01.05.2009 by Bochkanov Sergey
*************************************************************************)
//Comment out small matrix check to skip unknown-purpose recursion
//The original Procedure uses "while loop" to do the "for loop" behavior. Rewrite it to "for loop".
var
  I,J,Idx1,Idx2:Integer;

begin
  if (M=0) or (N=0) then Exit;

  for I := 0 to (M-1) do
  begin
    Idx1:=BStart+I;
    Idx2:=AStart+I*AStride;
    for J := 0 to (N-1) do
    begin
      B[Idx1]:=A[Idx2];
      Inc(Idx1,BStride); //Idx1:=Idx1+BStride;
      Inc(Idx2); //Idx2:=Idx2+1;
    end;
  end;

end;

Procedure InternalComplexLinTranspose(var A:TVector; M,N,AStart:Integer; var Buf:TVector);
(*************************************************************************
Linear transpose: transpose complex matrix stored in 1-dimensional array

  -- ALGLIB --
     Copyright 01.05.2009 by Bochkanov Sergey
*************************************************************************)
begin
  FFTICLTRec(A, AStart, N, Buf, 0, M, M, N);
  Move(Buf[0],A[AStart],(2*M*N)*SizeOf(Float));
end;

Procedure InternalRealLinTranspose(var A:TVector; M,N,AStart:Integer; var Buf:TVector);
(*************************************************************************
Linear transpose: transpose real matrix stored in 1-dimensional array

  -- ALGLIB --
     Copyright 01.05.2009 by Bochkanov Sergey
*************************************************************************)
begin
  FFTIRLTRec(A, AStart, N, Buf, 0, M, M, N);
  Move(Buf[0],A[AStart],(M*N)*SizeOf(Float));
end;

Procedure FFTTwCalc(var A : TVector; AOffset,N1,N2:Integer); //Translate from C# Code of ALGLIB v3.16
(*************************************************************************
Twiddle factors calculation

  -- ALGLIB --
     Copyright 01.05.2009 by Bochkanov Sergey
*************************************************************************)
var
  I,J2,N,HalfN1,Offs,UpdateTW2:Integer;
  X,Y,TwXM1,TwY,TwBaseXM1,TwBaseY,TwRowXM1,TwRowY,TmpX,TmpY,V:Float;

begin
// Multiplication by twiddle factors for complex Cooley-Tukey FFT
// with N factorized as N1*N2.
//
// Naive solution to this problem is given below:
//
//     > for K:=1 to N2-1 do
//     >     for J:=1 to N1-1 do
//     >     begin
//     >         Idx:=K*N1+J;
//     >         X:=A[AOffset+2*Idx+0];
//     >         Y:=A[AOffset+2*Idx+1];
//     >         TwX:=Cos(-2*Pi()*K*J/(N1*N2));
//     >         TwY:=Sin(-2*Pi()*K*J/(N1*N2));
//     >         A[AOffset+2*Idx+0]:=X*TwX-Y*TwY;
//     >         A[AOffset+2*Idx+1]:=X*TwY+Y*TwX;
//     >     end;
//
// However, there are exist more efficient solutions.
//
// Each pass of the inner cycle corresponds to multiplication of one
// entry of A by W[k,j]=exp(-I*2*pi*k*j/N). This factor can be rewritten
// as exp(-I*2*pi*k/N)^j. So we can replace costly exponentiation by
// repeated multiplication: W[k,j+1]=W[k,j]*exp(-I*2*pi*k/N), with
// second factor being computed once in the beginning of the iteration.
//
// Also, exp(-I*2*pi*k/N) can be represented as exp(-I*2*pi/N)^k, i.e.
// we have W[K+1,1]=W[K,1]*W[1,1].
//
// In our loop we use following variables:
// * [TwBaseXM1,TwBaseY] =   [cos(2*pi/N)-1,     sin(2*pi/N)]
// * [TwRowXM1, TwRowY]  =   [cos(2*pi*I/N)-1,   sin(2*pi*I/N)]
// * [TwXM1,    TwY]     =   [cos(2*pi*I*J/N)-1, sin(2*pi*I*J/N)]
//
// Meaning of the variables:
// * [TwXM1,TwY] is current twiddle factor W[I,J]
// * [TwRowXM1, TwRowY] is W[I,1]
// * [TwBaseXM1,TwBaseY] is W[1,1]
//
// During inner loop we multiply current twiddle factor by W[I,1],
// during outer loop we update W[I,1].
  UpdateTw2:=8;
  HalfN1:=N1 div 2;
  N:=N1*N2;
  V:=-2*Pi/N;
  TwBaseXM1:=-2*IntPower(Sin(0.5*V),2);
  TwBaseY:=Sin(V);
  TwRowXM1:=0;
  TwRowY:=0;
  Offs:=AOffset;

  for I := 0 to (N2-1) do
  begin
    //
    // Initialize twiddle factor for current row
    //
    TwXM1:=0;
    TwY:=0;
    //
    // N1-point block is separated into 2-point chunks and residual 1-point chunk
    // (in case N1 is odd). Unrolled loop is several times faster.
    //
    for J2 := 0 to (HalfN1-1) do
    begin
      //
      // Processing:
      // * process first element in a chunk.
      // * update twiddle factor (unconditional update)
      // * process second element
      // * conditional update of the twiddle factor
      //
      X:=A[Offs+0];
      Y:=A[Offs+1];
      TmpX:=X*(1+TwXM1)-Y*TwY;
      TmpY:=X*TwY+Y*(1+TwXM1);
      A[Offs+0]:=TmpX;
      A[Offs+1]:=TmpY;
      TmpX:=(1+TwXM1)*TwRowXM1-TwY*TwRowY;
      TwY:=TwY+(1+TwXM1)*TwRowY+TwY*TwRowXM1;
      TwXM1:=TwXM1+TmpX;
      X:=A[Offs+2];
      Y:=A[Offs+3];
      TmpX:=X*(1+TwXM1)-Y*TwY;
      TmpY:=X*TwY+Y*(1+TwXM1);
      A[Offs+2]:=TmpX;
      A[Offs+3]:=TmpY;
      Inc(Offs,4);
      if (((J2+1) mod UpdateTw2)=0) and (J2<(HalfN1-1)) then
      begin
        //
        // Recalculate twiddle factor
        //
        V:=-(2*Pi*I*2*(J2+1)/N);
        TwXM1:=Sin(0.5*V);
        TwXM1:=-(2*TwXM1*TwXM1);
        TwY:=Sin(V);
      end
      else
      begin
        //
        // Update twiddle factor
        //
        TmpX:=(1+TwXM1)*TwRowXM1-TwY*TwRowY;
        TwY:=TwY+(1+TwXM1)*TwRowY+TwY*TwRowXM1;
        TwXM1:=TwXM1+TmpX;
      end;
    end;
    if Odd(N1) then
    begin
      //
      // Handle residual chunk
      //
      X:=A[Offs+0];
      Y:=A[Offs+1];
      TmpX:=X*(1+TwXM1)-Y*TwY;
      TmpY:=X*TwY+Y*(1+TwXM1);
      A[Offs+0]:=TmpX;
      A[Offs+1]:=TmpY;
      Inc(Offs,2);
    end;
    //
    // update TwRow: TwRow(new) = TwRow(old)*TwBase
    //
    if I<(N2-1) then
    begin
      if (((I+1) mod 16)=0) then
      begin
        V:=-2*Pi*(I+1)/N;
        TwRowXM1:=-2*IntPower(Sin(0.5*V),2);
        TwRowY:=Sin(V);
      end
      else
      begin
        TmpX:=TwBaseXM1+TwRowXM1*TwBaseXM1-TwRowY*TwBaseY;
        TmpY:=TwBaseY+TwRowXM1*TwBaseY+TwRowY*TwBaseXM1;
        TwRowXM1:=TwRowXM1+TmpX;
        TwRowY:=TwRowY+TmpY;
      end;
    end;
  end;
end;

Procedure FTBaseExecutePlanRec(var A:TVector; AOffset:Integer; var Plan:TFTPlan; EntryOffset,StackPtr:Integer);
(*************************************************************************
Recurrent subroutine for the FTBaseExecutePlan

Parameters:
    A           FFT'ed array
    AOffset     offset of the FFT'ed part (distance is measured in Floats)

  -- ALGLIB --
     Copyright 01.05.2009 by Bochkanov Sergey
*************************************************************************)
var
  I,J,K,N1,N2,N,M,Offs,Offs1,Offs2,OffsA,OffsB,OffsP:Integer;
  HK,HNK,X,Y,BX,BY,A0X,A0Y,A1X,A1Y,A2X,A2Y,A3X,A3Y,V0,V1,V2,V3,
  T1X,T1Y,T2X,T2Y,T3X,T3Y,T4X,T4Y,T5X,T5Y,
  M1X,M1Y,M2X,M2Y,M3X,M3Y,M4X,M4Y,M5X,M5Y,
  S1X,S1Y,S2X,S2Y,S3X,S3Y,S4X,S4Y,S5X,S5Y,
  C1,C2,C3,C4,C5:Float;

begin
  if Plan.Plan[EntryOffset+3]=FFTEmptyPlan then
  begin
    Exit;
  end;

  if Plan.Plan[EntryOffset+3]=FFTCooleyTukeyPlan then
  begin
    //
    // Cooley-Tukey plan
    // * transposition
    // * row-wise FFT
    // * twiddle factors:
    //   - TwBase is a basis twiddle factor for I=1, J=1
    //   - TwRow is a twiddle factor for a second element in a row (J=1)
    //   - Tw is a twiddle factor for a current element
    // * transposition again
    // * row-wise FFT again
    //
    N1:=Plan.Plan[EntryOffset+1];
    N2:=Plan.Plan[EntryOffset+2];
    InternalComplexLinTranspose(A,N1,N2,AOffset,Plan.TmpBuf);
    for I := 0 to (N2-1) do
    begin
      FTBaseExecutePlanRec(A,AOffset+I*N1*2,Plan,Plan.Plan[EntryOffset+5],StackPtr);
    end;
    FFTTwCalc(A,AOffset,N1,N2);
    InternalComplexLinTranspose(A,N2,N1,AOffset,Plan.TmpBuf);
    for I := 0 to (N1-1) do
    begin
      FTBaseExecutePlanRec(A,AOffset+I*N2*2,Plan,Plan.Plan[EntryOffset+6],StackPtr);
    end;
    InternalComplexLinTranspose(A,N1,N2,AOffset,Plan.TmpBuf);
    Exit;
  end;

  if Plan.Plan[EntryOffset+3]=FFTRealCooleyTukeyPlan then
  begin
    //
    // Cooley-Tukey plan
    // * transposition
    // * row-wise FFT
    // * twiddle factors:
    //   - TwBase is a basis twiddle factor for I=1, J=1
    //   - TwRow is a twiddle factor for a second element in a row (J=1)
    //   - Tw is a twiddle factor for a current element
    // * transposition again
    // * row-wise FFT again
    //
    N1:=Plan.Plan[EntryOffset+1];
    N2:=Plan.Plan[EntryOffset+2];
    InternalComplexLinTranspose(A,N2,N1,AOffset,Plan.TmpBuf);
    for I := 0 to ((N1 div 2)-1) do
    begin
      //
      // pack two adjacent smaller real FFT's together,
      // make one complex FFT,
      // unpack result
      //
      Offs:=AOffset+2*I*N2*2;
      for K := 0 to (N2-1) do
      begin
        A[Offs+2*K+1]:=A[Offs+2*N2+2*K+0];
      end;
      FTBaseExecutePlanRec(A,Offs,Plan,Plan.Plan[EntryOffset+6],StackPtr);
      Plan.TmpBuf[0]:=A[Offs+0];
      Plan.TmpBuf[1]:=0;
      Plan.TmpBuf[2*N2+0]:=A[Offs+1];
      Plan.TmpBuf[2*N2+1]:=0;
      for K := 1 to (N2-1) do
      begin
        Offs1:=2*K;
        Offs2:=2*N2+2*K;
        HK:=A[Offs+2*K+0];
        HNK:=A[Offs+2*(N2-K)+0];
        Plan.TmpBuf[Offs1+0]:=+0.5*(HK+HNK);
        Plan.TmpBuf[Offs2+1]:=-0.5*(HK-HNK);
        HK:=A[Offs+2*K+1];
        HNK:=A[Offs+2*(N2-K)+1];
        Plan.TmpBuf[Offs2+0]:=+0.5*(HK+HNK);
        Plan.TmpBuf[Offs1+1]:=+0.5*(HK-HNK);
      end;
      Move(Plan.TmpBuf[0],A[Offs],(2*N2*2)*SizeOf(Float));
    end;

    if (N1 mod 2)<>0 then
    begin
      FTBaseExecutePlanRec(A,AOffset+(N1-1)*N2*2,Plan,Plan.Plan[EntryOffset+6],StackPtr);
    end;
    FFTTwCalc(A,AOffset,N2,N1);
    InternalComplexLinTranspose(A,N1,N2,AOffset,Plan.TmpBuf);
    for I := 0 to (N2-1) do
    begin
      FTBaseExecutePlanRec(A,AOffset+I*N1*2,Plan,Plan.Plan[EntryOffset+5],StackPtr);
    end;
    InternalComplexLinTranspose(A,N2,N1,AOffset,Plan.TmpBuf);
    Exit;
  end;

  if Plan.Plan[EntryOffset+3]=FHTCooleyTukeyPlan then
  begin
    //
    // Cooley-Tukey FHT plan:
    // * transpose                    \
    // * smaller FHT's                |
    // * pre-process                  |
    // * multiply by twiddle factors  | corresponds to multiplication by H1
    // * post-process                 |
    // * transpose again              /
    // * multiply by H2 (smaller FHT's)
    // * final transposition
    //
    // For more details see Vitezslav Vesely, "Fast algorithms
    // of Fourier and Hartley transform and their implementation in MATLAB",
    // page 31.
    //
    N1:=Plan.Plan[EntryOffset+1];
    N2:=Plan.Plan[EntryOffset+2];
    N:=N1*N2;
    InternalRealLinTranspose(A,N1,N2,AOffset,Plan.TmpBuf);
    for I := 0 to (N2-1) do
    begin
      FTBaseExecutePlanRec(A,AOffset+I*N1,Plan,Plan.Plan[EntryOffset+5],StackPtr);
    end;
    for I := 0 to (N2-1) do
    begin
      for J := 0 to (N1-1) do
      begin
        OffsA:=AOffset+I*N1;
        HK:=A[OffsA+J];
        HNK:=A[OffsA+((N1-J) mod N1)];
        Offs:=2*(I*N1+J);
        Plan.TmpBuf[Offs+0]:=-0.5*(HNK-HK);
        Plan.TmpBuf[Offs+1]:=+0.5*(HK+HNK);
      end;
    end;
    FFTTwCalc(Plan.TmpBuf, 0, N1, N2);
    for J := 0 to (N1-1) do
    begin
      A[AOffset+J]:=Plan.TmpBuf[2*J+0]+Plan.TmpBuf[2*J+1];
    end;
    if N2 mod 2=0 then
    begin
      Offs:=2*(N2 div 2)*N1;
      OffsA:=AOffset+N2 div 2*N1;
      for J := 0 to (N1-1) do
      begin
        A[OffsA+J]:=Plan.TmpBuf[Offs+2*J+0]+Plan.TmpBuf[Offs+2*J+1];
      end;
    end;
    for I := 1 to (((N2+1) div 2)-1) do
    begin
      Offs:=2*I*N1;
      Offs2:=2*(N2-I)*N1;
      OffsA:=AOffset+I*N1;
      for J := 0 to (N1-1) do
      begin
        A[OffsA+J]:=Plan.TmpBuf[Offs+2*J+1]+Plan.TmpBuf[Offs2+2*J+0];
      end;
      OffsA:=AOffset+(N2-I)*N1;
      for J := 0 to (N1-1) do
      begin
        A[OffsA+J]:=Plan.TmpBuf[Offs+2*J+0]+Plan.TmpBuf[Offs2+2*J+1];
      end;
    end;
    InternalRealLinTranspose(A,N2,N1,AOffset,Plan.TmpBuf);
    for I := 0 to (N1-1) do
    begin
      FTBaseExecutePlanRec(A,AOffset+I*N2,Plan,Plan.Plan[EntryOffset+6],StackPtr);
    end;
    InternalRealLinTranspose(A,N1,N2,AOffset,Plan.TmpBuf);
    Exit;
  end;

  if Plan.Plan[EntryOffset+3]=FHTN2Plan then
  begin
    //
    // Cooley-Tukey FHT plan
    //
    N1:=Plan.Plan[EntryOffset+1];
    N2:=Plan.Plan[EntryOffset+2];
    N:=N1*N2;
    RefFHT(A,N,AOffset);
    Exit;
  end;

  if Plan.Plan[EntryOffset+3]=FFTCodeletPlan then
  begin
    N1:=Plan.Plan[EntryOffset+1];
    N2:=Plan.Plan[EntryOffset+2];
    N:=N1*N2;
    if N=2 then
    begin
      A0X:=A[AOffset+0];
      A0Y:=A[AOffset+1];
      A1X:=A[AOffset+2];
      A1Y:=A[AOffset+3];
      V0:=A0X+A1X;
      V1:=A0Y+A1Y;
      V2:=A0X-A1X;
      V3:=A0Y-A1Y;
      A[AOffset+0]:=V0;
      A[AOffset+1]:=V1;
      A[AOffset+2]:=V2;
      A[AOffset+3]:=V3;
      Exit;
    end;
    if N=3 then
    begin
      Offs:=Plan.Plan[EntryOffset+7];
      C1:=Plan.Precomputed[Offs+0];
      C2:=Plan.Precomputed[Offs+1];
      A0X:=A[AOffset+0];
      A0Y:=A[AOffset+1];
      A1X:=A[AOffset+2];
      A1Y:=A[AOffset+3];
      A2X:=A[AOffset+4];
      A2Y:=A[AOffset+5];
      T1X:=A1X+A2X;
      T1Y:=A1Y+A2Y;
      A0X:=A0X+T1X;
      A0Y:=A0Y+T1Y;
      M1X:=C1*T1X;
      M1Y:=C1*T1Y;
      M2X:=C2*(A1Y-A2Y);
      M2Y:=C2*(A2X-A1X);
      S1X:=A0X+M1X;
      S1Y:=A0Y+M1Y;
      A1X:=S1X+M2X;
      A1Y:=S1Y+M2Y;
      A2X:=S1X-M2X;
      A2Y:=S1Y-M2Y;
      A[AOffset+0]:=A0X;
      A[AOffset+1]:=A0Y;
      A[AOffset+2]:=A1X;
      A[AOffset+3]:=A1Y;
      A[AOffset+4]:=A2X;
      A[AOffset+5]:=A2Y;
      Exit;
    end;
    if N=4 then
    begin
      A0X:=A[AOffset+0];
      A0Y:=A[AOffset+1];
      A1X:=A[AOffset+2];
      A1Y:=A[AOffset+3];
      A2X:=A[AOffset+4];
      A2Y:=A[AOffset+5];
      A3X:=A[AOffset+6];
      A3Y:=A[AOffset+7];
      T1X:=A0X+A2X;
      T1Y:=A0Y+A2Y;
      T2X:=A1X+A3X;
      T2Y:=A1Y+A3Y;
      M2X:=A0X-A2X;
      M2Y:=A0Y-A2Y;
      M3X:=A1Y-A3Y;
      M3Y:=A3X-A1X;
      A[AOffset+0]:=T1X+T2X;
      A[AOffset+1]:=T1Y+T2Y;
      A[AOffset+4]:=T1X-T2X;
      A[AOffset+5]:=T1Y-T2Y;
      A[AOffset+2]:=M2X+M3X;
      A[AOffset+3]:=M2Y+M3Y;
      A[AOffset+6]:=M2X-M3X;
      A[AOffset+7]:=M2Y-M3Y;
      Exit;
    end;
    if N=5 then
    begin
      Offs:=Plan.Plan[EntryOffset+7];
      C1:=Plan.Precomputed[Offs+0];
      C2:=Plan.Precomputed[Offs+1];
      C3:=Plan.Precomputed[Offs+2];
      C4:=Plan.Precomputed[Offs+3];
      C5:=Plan.Precomputed[Offs+4];
      T1X:=A[AOffset+2]+A[AOffset+8];
      T1Y:=A[AOffset+3]+A[AOffset+9];
      T2X:=A[AOffset+4]+A[AOffset+6];
      T2Y:=A[AOffset+5]+A[AOffset+7];
      T3X:=A[AOffset+2]-A[AOffset+8];
      T3Y:=A[AOffset+3]-A[AOffset+9];
      T4X:=A[AOffset+6]-A[AOffset+4];
      T4Y:=A[AOffset+7]-A[AOffset+5];
      T5X:=T1X+T2X;
      T5Y:=T1Y+T2Y;
      A[AOffset+0]:=A[AOffset+0]+T5X;
      A[AOffset+1]:=A[AOffset+1]+T5Y;
      M1X:=C1*T5X;
      M1Y:=C1*T5Y;
      M2X:=C2*(T1X-T2X);
      M2Y:=C2*(T1Y-T2Y);
      M3X:=-C3*(T3Y+T4Y);
      M3Y:=C3*(T3X+T4X);
      M4X:=-C4*T4Y;
      M4Y:=C4*T4X;
      M5X:=-C5*T3Y;
      M5Y:=C5*T3X;
      S3X:=M3X-M4X;
      S3Y:=M3Y-M4Y;
      S5X:=M3X+M5X;
      S5Y:=M3Y+M5Y;
      S1X:=A[AOffset+0]+M1X;
      S1Y:=A[AOffset+1]+M1Y;
      S2X:=S1X+M2X;
      S2Y:=S1Y+M2Y;
      S4X:=S1X-M2X;
      S4Y:=S1Y-M2Y;
      A[AOffset+2]:=S2X+S3X;
      A[AOffset+3]:=S2Y+S3Y;
      A[AOffset+4]:=S4X+S5X;
      A[AOffset+5]:=S4Y+S5Y;
      A[AOffset+6]:=S4X-S5X;
      A[AOffset+7]:=S4Y-S5Y;
      A[AOffset+8]:=S2X-S3X;
      A[AOffset+9]:=S2Y-S3Y;
      Exit;
    end;
  end;

  if Plan.Plan[EntryOffset+3]=FHTCodeletPlan then
  begin
    N1:=Plan.Plan[EntryOffset+1];
    N2:=Plan.Plan[EntryOffset+2];
    N:=N1*N2;
    if N=2 then
    begin
      A0X:=A[AOffset+0];
      A1X:=A[AOffset+1];
      A[AOffset+0]:=A0X+A1X;
      A[AOffset+1]:=A0X-A1X;
      Exit;
    end;
    if N=3 then
    begin
      Offs:=Plan.Plan[EntryOffset+7];
      C1:=Plan.Precomputed[Offs+0];
      C2:=Plan.Precomputed[Offs+1];
      A0X:=A[AOffset+0];
      A1X:=A[AOffset+1];
      A2X:=A[AOffset+2];
      T1X:=A1X+A2X;
      A0X:=A0X+T1X;
      M1X:=C1*T1X;
      M2Y:=C2*(A2X-A1X);
      S1X:=A0X+M1X;
      A[AOffset+0]:=A0X;
      A[AOffset+1]:=S1X-M2Y;
      A[AOffset+2]:=S1X+M2Y;
      Exit;
    end;
    if N=4 then
    begin
      A0X:=A[AOffset+0];
      A1X:=A[AOffset+1];
      A2X:=A[AOffset+2];
      A3X:=A[AOffset+3];
      T1X:=A0X+A2X;
      T2X:=A1X+A3X;
      M2X:=A0X-A2X;
      M3Y:=A3X-A1X;
      A[AOffset+0]:=T1X+T2X;
      A[AOffset+1]:=M2X-M3Y;
      A[AOffset+2]:=T1X-T2X;
      A[AOffset+3]:=M2X+M3Y;
      Exit;
    end;
    if N=5 then
    begin
      Offs:=Plan.Plan[EntryOffset+7];
      C1:=Plan.Precomputed[Offs+0];
      C2:=Plan.Precomputed[Offs+1];
      C3:=Plan.Precomputed[Offs+2];
      C4:=Plan.Precomputed[Offs+3];
      C5:=Plan.Precomputed[Offs+4];
      T1X:=A[AOffset+1]+A[AOffset+4];
      T2X:=A[AOffset+2]+A[AOffset+3];
      T3X:=A[AOffset+1]-A[AOffset+4];
      T4X:=A[AOffset+3]-A[AOffset+2];
      T5X:=T1X+T2X;
      V0:=A[AOffset+0]+T5X;
      A[AOffset+0]:=V0;
      M2X:=C2*(T1X-T2X);
      M3Y:=C3*(T3X+T4X);
      S3Y:=M3Y-C4*T4X;
      S5Y:=M3Y+C5*T3X;
      S1X:=V0+C1*T5X;
      S2X:=S1X+M2X;
      S4X:=S1X-M2X;
      A[AOffset+1]:=S2X-S3Y;
      A[AOffset+2]:=S4X-S5Y;
      A[AOffset+3]:=S4X+S5Y;
      A[AOffset+4]:=S2X+S3Y;
      Exit;
    end;
  end;

  if Plan.Plan[EntryOffset+3]=FFTBluesteinPlan then
  begin
    //
    // Bluestein plan:
    // 1. multiply by precomputed coefficients
    // 2. make convolution: forward FFT, multiplication by precomputed FFT
    //    and backward FFT. backward FFT is represented as
    //
    //        invfft(x) = fft(x')'/M
    //
    //    for performance reasons reduction of inverse FFT to
    //    forward FFT is merged with multiplication of FFT components
    //    and last stage of Bluestein's transformation.
    // 3. post-multiplication by Bluestein factors
    //
    N:=Plan.Plan[EntryOffset+1];
    M:=Plan.Plan[EntryOffset+4];
    Offs:=Plan.Plan[EntryOffset+7];
    for I := (StackPtr+2*N) to (StackPtr+2*M-1) do
    begin
      Plan.StackBuf[I]:=0;
    end;
    OffsP:=Offs+2*M;
    OffsA:=AOffset;
    OffsB:=StackPtr;
    for I := 0 to (N-1) do
    begin
      BX:=Plan.Precomputed[OffsP+0];
      BY:=Plan.Precomputed[OffsP+1];
      X:=A[OffsA+0];
      Y:=A[OffsA+1];
      Plan.StackBuf[OffsB+0]:=X*BX-Y*-BY;
      Plan.StackBuf[OffsB+1]:=X*-BY+Y*BX;
      OffsP:=OffsP+2;
      OffsA:=OffsA+2;
      OffsB:=OffsB+2;
    end;
    FTBaseExecutePlanRec(Plan.StackBuf,StackPtr,Plan,Plan.Plan[EntryOffset+5],StackPtr+2*2*M);
    OffsB:=StackPtr;
    OffsP:=Offs;
    for I := 0 to (M-1) do
    begin
      X:=Plan.StackBuf[OffsB+0];
      Y:=Plan.StackBuf[OffsB+1];
      BX:=Plan.Precomputed[OffsP+0];
      BY:=Plan.Precomputed[OffsP+1];
      Plan.StackBuf[OffsB+0]:=X*BX-Y*BY;
      Plan.StackBuf[OffsB+1]:=-(X*BY+Y*BX);
      OffsB:=OffsB+2;
      OffsP:=OffsP+2;
    end;
    FTBaseExecutePlanRec(Plan.StackBuf,StackPtr,Plan,Plan.Plan[EntryOffset+5],StackPtr+2*2*M);
    OffsB:=StackPtr;
    OffsP:=Offs+2*M;
    OffsA:=AOffset;
    for I := 0 to (N-1) do
    begin
      X:=+Plan.StackBuf[OffsB+0]/M;
      Y:=-Plan.StackBuf[OffsB+1]/M;
      BX:=Plan.Precomputed[OffsP+0];
      BY:=Plan.Precomputed[OffsP+1];
      A[OffsA+0]:=X*BX-Y*-BY;
      A[OffsA+1]:=X*-BY+Y*BX;
      OffsP:=OffsP+2;
      OffsA:=OffsA+2;
      OffsB:=OffsB+2;
    end;
    Exit;
  end;
end;

Procedure FTBasePrecomputePlanRec(var Plan:TFTPlan; EntryOffset,StackPtr:Integer);
(*************************************************************************
Recurrent subroutine for precomputing FFT plans

  -- ALGLIB --
     Copyright 01.05.2009 by Bochkanov Sergey
*************************************************************************)
var
  I,N1,N2,N,M,Offs:Integer;
  V,BX,BY:Float;

begin
  if (Plan.Plan[EntryOffset+3]=FFTCooleyTukeyPlan) or (Plan.Plan[EntryOffset+3]=FFTRealCooleyTukeyPlan) or (Plan.Plan[EntryOffset+3]=FHTCooleyTukeyPlan) then
  begin
    FTBasePrecomputePlanRec(Plan,Plan.Plan[EntryOffset+5],StackPtr);
    FTBasePrecomputePlanRec(Plan,Plan.Plan[EntryOffset+6],StackPtr);
    Exit;
  end;
  if (Plan.Plan[EntryOffset+3]=FFTCodeletPlan) or (Plan.Plan[EntryOffset+3]=FHTCodeletPlan) then
  begin
    N1:=Plan.Plan[EntryOffset+1];
    N2:=Plan.Plan[EntryOffset+2];
    N:=N1*N2;
    if N=3 then
    begin
      Offs:=Plan.Plan[EntryOffset+7];
      Plan.Precomputed[Offs+0]:=Cos(2*Pi/3)-1;
      Plan.Precomputed[Offs+1]:=Sin(2*Pi/3);
      Exit;
    end;
    if N=5 then
    begin
      Offs:=Plan.Plan[EntryOffset+7];
      V:=2*Pi/5;
      Plan.Precomputed[Offs+0]:=(Cos(V)+Cos(2*V))/2-1;
      Plan.Precomputed[Offs+1]:=(Cos(V)-Cos(2*V))/2;
      Plan.Precomputed[Offs+2]:=-Sin(V);
      Plan.Precomputed[Offs+3]:=-(Sin(V)+Sin(2*V));
      Plan.Precomputed[Offs+4]:=Sin(V)-Sin(2*V);
      Exit;
    end;
  end;
  if Plan.Plan[EntryOffset+3]=FFTBluesteinPlan then
  begin
    FTBasePrecomputePlanRec(Plan,Plan.Plan[EntryOffset+5],StackPtr);
    N:=Plan.Plan[EntryOffset+1];
    M:=Plan.Plan[EntryOffset+4];
    Offs:=Plan.Plan[EntryOffset+7];
    for I := 0 to (2*M-1) do
    begin
      Plan.Precomputed[Offs+I]:=0;
    end;
    for I := 0 to (N-1) do
    begin
      BX:=Cos(Pi*I/N*I);
      BY:=Sin(Pi*I/N*I);
      Plan.Precomputed[Offs+2*I+0]:=BX;
      Plan.Precomputed[Offs+2*I+1]:=BY;
      Plan.Precomputed[Offs+2*M+2*I+0]:=BX;
      Plan.Precomputed[Offs+2*M+2*I+1]:=BY;
      if I>0 then
      begin
        Plan.Precomputed[Offs+2*(M-I)+0]:=BX;
        Plan.Precomputed[Offs+2*(M-I)+1]:=BY;
      end;
    end;
    FTBaseExecutePlanRec(Plan.Precomputed,Offs,Plan,Plan.Plan[EntryOffset+5],StackPtr);
    Exit;
  end;
end;

Procedure FTBaseGeneratePlanRec(N,TaskType:Integer; var Plan:TFTPlan; var PlanSize,PrecomputedSize,PlanArraySize,TmpMemSize,StackMemSize:Integer; StackPtr:Integer);
(*************************************************************************
Recurrent subroutine for the FFTGeneratePlan:

PARAMETERS:
    N                   plan size
    IsReal              whether input is real or not.
                        subroutine MUST NOT ignore this flag because real
                        inputs comes with non-initialized imaginary parts,
                        so ignoring this flag will result in corrupted output
    HalfOut             whether full output or only half of it from 0 to
                        floor(N/2) is needed. This flag may be ignored if
                        doing so will simplify calculations
    Plan                plan array
    PlanSize            size of used part (in integers)
    PrecomputedSize     size of precomputed array allocated yet
    PlanArraySize       plan array size (actual)
    TmpMemSize          temporary memory required size
    BluesteinMemSize    temporary memory required size

  -- ALGLIB --
     Copyright 01.05.2009 by Bochkanov Sergey
*************************************************************************)
var
  K,M,N1,N2,ESize,EntryOffset:Integer;

begin
  //
  // prepare
  //
  if (PlanSize+FTBasePlanEntrySize)>PlanArraySize then
  begin
    FFTArrayResize(Plan.Plan,PlanArraySize,8*PlanArraySize);
  end;
  EntryOffset:=PlanSize;
  ESize:=FTBasePlanEntrySize;
  PlanSize:=PlanSize+ESize;
  //
  // if N=1, generate empty plan and exit
  //
  if N=1 then
  begin
    Plan.Plan[EntryOffset+0]:=ESize;
    Plan.Plan[EntryOffset+1]:=-1;
    Plan.Plan[EntryOffset+2]:=-1;
    Plan.Plan[EntryOffset+3]:=FFTEmptyPlan;
    Plan.Plan[EntryOffset+4]:=-1;
    Plan.Plan[EntryOffset+5]:=-1;
    Plan.Plan[EntryOffset+6]:=-1;
    Plan.Plan[EntryOffset+7]:=-1;
    Exit;
  end;
  //
  // generate plans
  //
  N1:=0; //variable initialization to eliminate compiler hint message
  N2:=0; //variable initialization to eliminate compiler hint message
  FTBaseFactorize(N,N1,N2);
  if (TaskType=FTBaseCFFTTask) or (TaskType=FTBaseRFFTTask) then
  begin
    //
    // complex FFT plans
    //
    if N1<>1 then
    begin
      //
      // Cooley-Tukey plan (real or complex)
      //
      // Note that child plans are COMPLEX
      // (whether plan itself is complex or not).
      //
      TmpMemSize:=Max(TmpMemSize,2*N1*N2);
      Plan.Plan[EntryOffset+0]:=ESize;
      Plan.Plan[EntryOffset+1]:=N1;
      Plan.Plan[EntryOffset+2]:=N2;
      if TaskType=FTBaseCFFTTask then
      begin
        Plan.Plan[EntryOffset+3]:=FFTCooleyTukeyPlan;
      end
      else
      begin
        Plan.Plan[EntryOffset+3]:=FFTRealCooleyTukeyPlan;
      end;
      Plan.Plan[EntryOffset+4]:=0;
      Plan.Plan[EntryOffset+5]:=PlanSize;
      FTBaseGeneratePlanRec(N1,FTBaseCFFTTask,Plan,PlanSize,PrecomputedSize,PlanArraySize,TmpMemSize,StackMemSize,StackPtr);
      Plan.Plan[EntryOffset+6]:=PlanSize;
      FTBaseGeneratePlanRec(N2,FTBaseCFFTTask,Plan,PlanSize,PrecomputedSize,PlanArraySize,TmpMemSize,StackMemSize,StackPtr);
      Plan.Plan[EntryOffset+7]:=-1;
      Exit;
    end
    else
    begin
      if (N=2) or (N=3) or (N=4) or (N=5) then
      begin
        //
        // hard-coded plan
        //
        Plan.Plan[EntryOffset+0]:=ESize;
        Plan.Plan[EntryOffset+1]:=N1;
        Plan.Plan[EntryOffset+2]:=N2;
        Plan.Plan[EntryOffset+3]:=FFTCodeletPlan;
        Plan.Plan[EntryOffset+4]:=0;
        Plan.Plan[EntryOffset+5]:=-1;
        Plan.Plan[EntryOffset+6]:=-1;
        Plan.Plan[EntryOffset+7]:=PrecomputedSize;
        if N=3 then
        begin
          PrecomputedSize:=PrecomputedSize+2;
        end;
        if N=5 then
        begin
          PrecomputedSize:=PrecomputedSize+5;
        end;
        Exit;
      end
      else
      begin
        //
        // Bluestein's plan
        //
        // Select such M that M>=2*N-1, M is composite, and M's
        // factors are 2, 3, 5
        //
        K:=2*N2-1;
        M:=FTBaseFindSmooth(K);
        TmpMemSize:=Max(TmpMemSize,2*M);
        Plan.Plan[EntryOffset+0]:=ESize;
        Plan.Plan[EntryOffset+1]:=N2;
        Plan.Plan[EntryOffset+2]:=-1;
        Plan.Plan[EntryOffset+3]:=FFTBluesteinPlan;
        Plan.Plan[EntryOffset+4]:=M;
        Plan.Plan[EntryOffset+5]:=PlanSize;
        StackPtr:=StackPtr+2*2*M;
        StackMemSize:=Max(StackMemSize,StackPtr);
        FTBaseGeneratePlanRec(M,FTBaseCFFTTask,Plan,PlanSize,PrecomputedSize,PlanArraySize,TmpMemSize,StackMemSize,StackPtr);
        StackPtr:=StackPtr-2*2*M;
        Plan.Plan[EntryOffset+6]:=-1;
        Plan.Plan[EntryOffset+7]:=PrecomputedSize;
        PrecomputedSize:=PrecomputedSize+2*M+2*N;
        Exit;
      end;
    end;
  end;
  if TaskType=FTBaseRFHTTask then
  begin
    //
    // real FHT plans
    //
    if N1<>1 then
    begin
      //
      // Cooley-Tukey plan
      //
      //
      TmpMemSize:=Max(TmpMemSize,2*N1*N2);
      Plan.Plan[EntryOffset+0]:=ESize;
      Plan.Plan[EntryOffset+1]:=N1;
      Plan.Plan[EntryOffset+2]:=N2;
      Plan.Plan[EntryOffset+3]:=FHTCooleyTukeyPlan;
      Plan.Plan[EntryOffset+4]:=0;
      Plan.Plan[EntryOffset+5]:=PlanSize;
      FTBaseGeneratePlanRec(N1,TaskType,Plan,PlanSize,PrecomputedSize,PlanArraySize,TmpMemSize,StackMemSize,StackPtr);
      Plan.Plan[EntryOffset+6]:=PlanSize;
      FTBaseGeneratePlanRec(N2,TaskType,Plan,PlanSize,PrecomputedSize,PlanArraySize,TmpMemSize,StackMemSize,StackPtr);
      Plan.Plan[EntryOffset+7]:=-1;
      Exit;
    end
    else
    begin
      //
      // N2 plan
      //
      Plan.Plan[EntryOffset+0]:=ESize;
      Plan.Plan[EntryOffset+1]:=N1;
      Plan.Plan[EntryOffset+2]:=N2;
      Plan.Plan[EntryOffset+3]:=FHTN2Plan;
      Plan.Plan[EntryOffset+4]:=0;
      Plan.Plan[EntryOffset+5]:=-1;
      Plan.Plan[EntryOffset+6]:=-1;
      Plan.Plan[EntryOffset+7]:=-1;
      if (N=2) or (N=3) or (N=4) or (N=5) then
      begin
        //
        // hard-coded plan
        //
        Plan.Plan[EntryOffset+0]:=ESize;
        Plan.Plan[EntryOffset+1]:=N1;
        Plan.Plan[EntryOffset+2]:=N2;
        Plan.Plan[EntryOffset+3]:=FHTCodeletPlan;
        Plan.Plan[EntryOffset+4]:=0;
        Plan.Plan[EntryOffset+5]:=-1;
        Plan.Plan[EntryOffset+6]:=-1;
        Plan.Plan[EntryOffset+7]:=PrecomputedSize;
        if N=3 then
        begin
          PrecomputedSize:=PrecomputedSize+2;
        end;
        if N=5 then
        begin
          PrecomputedSize:=PrecomputedSize+5;
        end;
        Exit;
      end;
      Exit;
    end;
  end;
end;

Procedure FTBaseExecutePlan(var A:TVector; AOffset:Integer; var Plan : TFTPlan);
(*************************************************************************
This subroutine executes FFT/FHT plan.

If Plan is a:
* complex FFT plan  -   sizeof(A)=2*N,
                        A contains interleaved real/imaginary values
* real FFT plan     -   sizeof(A)=2*N,
                        A contains real values interleaved with zeros
* real FHT plan     -   sizeof(A)=2*N,
                        A contains real values interleaved with zeros

  -- ALGLIB --
     Copyright 01.05.2009 by Bochkanov Sergey
*************************************************************************)
var
  StackPtr:Integer;

begin
  StackPtr:=0;
  FTBaseExecutePlanRec(A,AOffset,Plan,0,StackPtr);
end;

Procedure FTBaseGenerateComplexFFTPlan(N:Integer; out Plan:TFTPlan);
(*************************************************************************
This subroutine generates FFT plan - a decomposition of a N-length FFT to
the more simpler operations. Plan consists of the root entry and the child
entries.

Subroutine parameters:
    N               task size

Output parameters:
    Plan            plan

  -- ALGLIB --
     Copyright 01.05.2009 by Bochkanov Sergey
*************************************************************************)
var
  PlanArraySize,PlanSize,PrecomputedSize,TmpMemSize,StackMemSize,StackPtr:Integer;

begin
  PlanArraySize:=1;
  PlanSize:=0;
  PrecomputedSize:=0;
  StackMemSize:=0;
  StackPtr:=0;
  TmpMemSize:=2*N;
  SetLength(Plan.Plan,PlanArraySize);
  FTBaseGeneratePlanRec(N,FTBaseCFFTTask,Plan,PlanSize,PrecomputedSize,PlanArraySize,TmpMemSize,StackMemSize,StackPtr);
  Assert(StackPtr=0,'Internal error in FTBaseGenerateComplexFFTPlan: stack ptr!');
  SetLength(Plan.StackBuf,Max(StackMemSize,1));
  SetLength(Plan.TmpBuf,Max(TmpMemSize,1));
  SetLength(Plan.Precomputed,Max(PrecomputedSize,1));
  StackPtr:=0;
  FTBasePrecomputePlanRec(Plan,0,StackPtr);
  Assert(StackPtr=0,'Internal error in FTBaseGenerateComplexFFTPlan: stack ptr!');
end;

Procedure FTBaseGenerateRealFFTPlan(N:Integer; var Plan:TFTPlan);
(*************************************************************************
Generates real FFT plan
*************************************************************************)
var
  PlanArraySize,PlanSize,PrecomputedSize,TmpMemSize,StackMemSize,StackPtr:Integer;

begin
  PlanArraySize:=1;
  PlanSize:=0;
  PrecomputedSize:=0;
  StackMemSize:=0;
  StackPtr:=0;
  TmpMemSize:=2*N;
  SetLength(Plan.Plan,PlanArraySize);
  FTBaseGeneratePlanRec(N,FTBaseRFFTTask,Plan,PlanSize,PrecomputedSize,PlanArraySize,TmpMemSize,StackMemSize,StackPtr);
  Assert(StackPtr=0,'Internal error in FTBaseGenerateRealFFTPlan: stack ptr!');
  SetLength(Plan.StackBuf,Max(StackMemSize,1));
  SetLength(Plan.TmpBuf,Max(TmpMemSize,1));
  SetLength(Plan.Precomputed,Max(PrecomputedSize,1));
  StackPtr:=0;
  FTBasePrecomputePlanRec(Plan,0,StackPtr);
  Assert(StackPtr=0,'Internal error in FTBaseGenerateRealFFTPlan: stack ptr!');
end;

Procedure FTBaseGenerateRealFHTPlan(N:Integer; var Plan:TFTPlan);
(*************************************************************************
Generates real FHT plan
*************************************************************************)
var
  PlanArraySize,PlanSize,PrecomputedSize,TmpMemSize,StackMemSize,StackPtr:Integer;

begin
  PlanArraySize:=1;
  PlanSize:=0;
  PrecomputedSize:=0;
  StackMemSize:=0;
  StackPtr:=0;
  TmpMemSize:=N;
  SetLength(Plan.Plan,PlanArraySize);
  FTBaseGeneratePlanRec(N,FTBaseRFHTTask,Plan,PlanSize,PrecomputedSize,PlanArraySize,TmpMemSize,StackMemSize,StackPtr);
  Assert(StackPtr=0,'Internal error in FTBaseGenerateRealFHTPlan: stack ptr!');
  SetLength(Plan.StackBuf,Max(StackMemSize,1));
  SetLength(Plan.TmpBuf,Max(TmpMemSize,1));
  SetLength(Plan.Precomputed,Max(PrecomputedSize,1));
  StackPtr:=0;
  FTBasePrecomputePlanRec(Plan,0,StackPtr);
  Assert(StackPtr=0,'Internal error in FTBaseGenerateRealFHTPlan: stack ptr!');
end;

//
//End of FTBase content---------------------------------------------------------
//

Procedure FFTR1DInternalEven(var A:TVector; N:Integer; var Buf:TVector; var Plan:TFTPlan);
(*************************************************************************
Internal subroutine. Never call it directly!


  -- ALGLIB --
     Copyright 01.06.2009 by Bochkanov Sergey
*************************************************************************)
var
  X,Y:Float;
  I,N2,Idx:Integer;
  Hn,HmnC,V:Complex;

begin
  Assert((N>0) and ((N mod 2)=0),'FFTR1DEvenInplace: incorrect N!');
  //
  // Special cases:
  // * N=2
  //
  // After this block we assume that N is strictly greater than 2
  //
  if N=2 then
  begin
    X:=A[0]+A[1];
    Y:=A[0]-A[1];
    A[0]:=X;
    A[1]:=Y;
    Exit;
  end;
  //
  // even-size real FFT, use reduction to the complex task
  //
  N2:=N div 2;
  Move(A[0],Buf[0],N*SizeOf(Float));
  FTBaseExecutePlan(Buf,0,Plan);
  A[0]:=Buf[0]+Buf[1];
  for I := 1 to (N2-1) do
  begin
    Idx:=2*(I mod N2);
    Hn.X:=Buf[Idx+0];
    Hn.Y:=Buf[Idx+1];
    Idx:=2*(N2-I);
    HmnC.X:=Buf[Idx+0];
    HmnC.Y:=-Buf[Idx+1];
    V.X:=-Sin(-2*Pi*I/N);
    V.Y:=Cos(-2*Pi*I/N);
    V:=(Hn+HmnC)-(V*(Hn-HmnC));
    A[2*I+0]:=0.5*V.X;
    A[2*I+1]:=0.5*V.Y;
  end;
  A[1]:=Buf[0]-Buf[1];
end;

Procedure FFTR1DInvInternalEven(var A:TVector; N:Integer; var Buf:TVector; var Plan:TFTPlan);
(*************************************************************************
Internal subroutine. Never call it directly!


  -- ALGLIB --
     Copyright 01.06.2009 by Bochkanov Sergey
*************************************************************************)
var
  X,Y,T:Float;
  I,N2:Integer;

begin
  Assert((N>0) and ((N mod 2)=0),'FFTR1DInvInternalEven: incorrect N!');
  //
  // Special cases:
  // * N=2
  //
  // After this block we assume that N is strictly greater than 2
  //
  if N=2 then
  begin
    X:=0.5*(A[0]+A[1]);
    Y:=0.5*(A[0]-A[1]);
    A[0]:=X;
    A[1]:=Y;
    Exit;
  end;
  //
  // inverse real FFT is reduced to the inverse real FHT,
  // which is reduced to the forward real FHT,
  // which is reduced to the forward real FFT.
  //
  // Don't worry, it is really compact and efficient reduction :)
  //
  N2:=N div 2;
  Buf[0]:=A[0];
  for I := 1 to (N2-1) do
  begin
    X:=A[2*I+0];
    Y:=A[2*I+1];
    Buf[I]:=X-Y;
    Buf[N-I]:=X+Y;
  end;
  Buf[N2]:=A[1];
  FFTR1DInternalEven(Buf,N,A,Plan);
  A[0]:=Buf[0]/N;
  T:=1/N;
  for I := 1 to (N2-1) do
  begin
    X:=Buf[2*I+0];
    Y:=Buf[2*I+1];
    A[I]:=T*(X-Y);
    A[N-I]:=T*(X+Y);
  end;
  A[N2]:=Buf[1]/N;
end;

Procedure FFTC1D(var A:TCompVector; Lb,Ub:Integer);
(*************************************************************************
1-dimensional complex FFT.

Array size N may be arbitrary number (composite or prime).  Composite  N's
are handled with cache-oblivious variation of  a  Cooley-Tukey  algorithm.
Small prime-factors are transformed using hard coded  codelets (similar to
FFTW codelets, but without low-level  optimization),  large  prime-factors
are handled with Bluestein's algorithm.

Fastests transforms are for smooth N's (prime factors are 2, 3,  5  only),
most fast for powers of 2. When N have prime factors  larger  than  these,
but orders of magnitude smaller than N, computations will be about 4 times
slower than for nearby highly composite N's. When N itself is prime, speed
will be 6 times lower.

Algorithm has O(N*logN) complexity for any N (composite or prime).

INPUT PARAMETERS
    A   -   array[0..N-1] - complex Function to be transformed
    N   -   problem size

OUTPUT PARAMETERS
    A   -   DFT of a input array, array[0..N-1]
            A_out[j] = SUM(A_in[k]*exp(-2*pi*sqrt(-1)*j*k/N), k = 0..N-1)


  -- ALGLIB --
     Copyright 29.05.2009 by Bochkanov Sergey
*************************************************************************)
var
  Plan:TFTPlan;
  I,N:Integer;
  Buf:TVector;

begin
  if (Lb<Low(A)) or (Ub>High(A)) or (Lb>Ub) then Exit;

  N:=Ub-Lb+1;

  Assert(N>0,'FFTC1D: incorrect N!');
  //
  // Special case: N=1, FFT is just identity transform.
  // After this block we assume that N is strictly greater than 1.
  //
  if N=1 then
  begin
    Exit;
  end;
  //
  // convert input array to the more convinient format
  //
  SetLength(Buf,2*N);
  Move(A[Lb],Buf[0],N*SizeOf(Complex));

  //
  // Generate plan and execute it.
  //
  // Plan is a combination of a successive factorizations of N and
  // precomputed data. It is much like a FFTW plan, but is not stored
  // between subroutine calls and is much simpler.
  //
  FTBaseGenerateComplexFFTPlan(N,Plan);
  FTBaseExecutePlan(Buf,0,Plan);
  //
  // result
  //
  Move(Buf[0],A[Lb],N*SizeOf(Complex));
end;

Procedure FFTC1DInv(var A:TCompVector; Lb,Ub:Integer);
(*************************************************************************
1-dimensional complex inverse FFT.

Array size N may be arbitrary number (composite or prime).  Algorithm  has
O(N*logN) complexity for any N (composite or prime).

See FFTC1D() description for more information about algorithm performance.

INPUT PARAMETERS
    A   -   array[0..N-1] - complex array to be transformed
    N   -   problem size

OUTPUT PARAMETERS
    A   -   inverse DFT of a input array, array[0..N-1]
            A_out[j] = SUM(A_in[k]/N*exp(+2*pi*sqrt(-1)*j*k/N), k = 0..N-1)


  -- ALGLIB --
     Copyright 29.05.2009 by Bochkanov Sergey
*************************************************************************)
var
  I,N:Integer;

begin
  if (Lb<Low(A)) or (Ub>High(A)) or (Lb>Ub) then Exit;

  N:=Ub-Lb+1;

  Assert(N>0,'FFTC1DInv: incorrect N!');
  //
  // Inverse DFT can be expressed in terms of the DFT as
  //
  //     invfft(x) = fft(x')'/N
  //
  // here x' means conj(x).
  //
  for I := Lb to Ub do
  begin
    A[I].Y:=-A[I].Y;
  end;
  FFTC1D(A,Lb,Ub);
  for I := Lb to Ub do
  begin
    A[I].X:=A[I].X/N;
    A[I].Y:=-A[I].Y/N;
  end;
end;

Procedure FFTR1D(const A:TVector; Lb,Ub:Integer; var F:TCompVector);
(*************************************************************************
1-dimensional real FFT.

Algorithm has O(N*logN) complexity for any N (composite or prime).

INPUT PARAMETERS
    A   -   array[0..N-1] - real Function to be transformed
    N   -   problem size

OUTPUT PARAMETERS
    F   -   DFT of a input array, array[0..N-1]
            F[j] = SUM(A[k]*exp(-2*pi*sqrt(-1)*j*k/N), k = 0..N-1)

NOTE:
    F[] satisfies symmetry property F[k] = conj(F[N-k]),  so just one half
of  array  is  usually needed. But for convinience subroutine returns full
complex array (with frequencies above N/2), so its result may be  used  by
other FFT-related subroutines.


  -- ALGLIB --
     Copyright 01.06.2009 by Bochkanov Sergey
*************************************************************************)
var
  I,N2,Idx,N:Integer;
  Hn,HmnC,V:Complex;
  Buf:TVector;
  Plan:TFTPlan;

begin
  if (Lb<Low(A)) or (Ub>High(A)) or (Lb>Ub) then Exit;

  N:=Ub-Lb+1;

  Assert(N>0,'FFTR1D: incorrect N!');
  //
  // Special cases:
  // * N=1, FFT is just identity transform.
  // * N=2, FFT is simple too
  //
  // After this block we assume that N is strictly greater than 2
  //
  if N=1 then
  begin
    SetLength(F,1); //F must be zero-based
    F[0]:=Cmplx(A[Lb],0);
    Exit;
  end;

  if N=2 then
  begin
    SetLength(F,2); //F must be zero-based
    F[0].X:=A[Lb]+A[Ub];
    F[0].Y:=0;
    F[1].X:=A[Lb]-A[Ub];
    F[1].Y:=0;
    Exit;
  end;
  //
  // Choose between odd-size and even-size FFTs
  //
  if (N mod 2)=0 then
  begin
    //
    // even-size real FFT, use reduction to the complex task
    //
    N2:=N div 2;
    SetLength(Buf,N);
    Move(A[Lb],Buf[0],N*SizeOf(Float));
    FTBaseGenerateComplexFFTPlan(N2,Plan);
    FTBaseExecutePlan(Buf,0,Plan);
    SetLength(F,N); //F must be zero-based
    for I := 0 to (N2) do
    begin
      Idx:=2*(I mod N2);
      Hn.X:=Buf[Idx+0];
      Hn.Y:=Buf[Idx+1];
      Idx:=2*((N2-I) mod N2);
      HmnC.X:=Buf[Idx+0];
      HmnC.Y:=-Buf[Idx+1];
      V.X:=-Sin(-2*Pi*I/N);
      V.Y:=Cos(-2*Pi*I/N);
      F[I]:=(Hn+HmnC)-(V*(Hn-HmnC));
      F[I].X:=0.5*F[I].X;
      F[I].Y:=0.5*F[I].Y;
    end;
    for I := (N2+1) to (N-1) do
    begin
      F[I]:=CConj(F[N-I]);
    end;
    Exit;
  end
  else
  begin
    //
    // use complex FFT
    //
    SetLength(F,N); //F must be zero-based
    for I := Lb to Ub do
    begin
      F[I]:=Cmplx(A[I],0);
    end;
    FFTC1D(F,0,(N-1));
    Exit;
  end;
end;

Procedure FFTR1DInv(const F:TCompVector; Lb,Ub:Integer; var A:TVector);
(*************************************************************************
1-dimensional real inverse FFT.

Algorithm has O(N*logN) complexity for any N (composite or prime).

INPUT PARAMETERS
    F   -   array[0..floor(N/2)] - frequencies from forward real FFT
    N   -   problem size

OUTPUT PARAMETERS
    A   -   inverse DFT of a input array, array[0..N-1]

NOTE:
    F[] should satisfy symmetry property F[k] = conj(F[N-k]), so just  one
half of frequencies array is needed - elements from 0 to floor(N/2).  F[0]
is ALWAYS real. If N is even F[floor(N/2)] is real too. If N is odd,  then
F[floor(N/2)] has no special properties.

Relying on properties noted above, FFTR1DInv subroutine uses only elements
from 0th to floor(N/2)-th. It ignores imaginary part of F[0],  and in case
N is even it ignores imaginary part of F[floor(N/2)] too.  So you can pass
either frequencies array with N elements or reduced array with roughly N/2
elements - subroutine will successfully transform both.


  -- ALGLIB --
     Copyright 01.06.2009 by Bochkanov Sergey
*************************************************************************)
var
  I,N:Integer;
  H:TVector;
  FH:TCompVector;

begin
  if (Lb<Low(F)) or (Ub>High(F)) or (Lb>Ub) then Exit;

  N:=Ub-Lb+1;

  Assert(N>0, 'FFTR1DInv: incorrect N!');
  //
  // Special case: N=1, FFT is just identity transform.
  // After this block we assume that N is strictly greater than 1.
  //
  if N=1 then
  begin
    SetLength(A,1); //A must be zero-based
    A[0]:=F[Lb].X;
    Exit;
  end;
  //
  // inverse real FFT is reduced to the inverse real FHT,
  // which is reduced to the forward real FHT,
  // which is reduced to the forward real FFT.
  //
  // Don't worry, it is really compact and efficient reduction :)
  //
  SetLength(H,N);
  SetLength(A,N); //A must be zero-based
  H[0]:=F[Lb+0].X;
  for I := 1 to ((N div 2)-1) do
  begin
    H[I]:=F[Lb+I].X-F[Lb+I].Y;
    H[N-I]:=F[Lb+I].X+F[Lb+I].Y;
  end;
  if (N mod 2)=0 then
  begin
    H[(N div 2)]:=F[Lb+(N div 2)].X;
  end
  else
  begin
    H[(N div 2)]:=F[Lb+(N div 2)].X-F[Lb+(N div 2)].Y;
    H[(N div 2)+1]:=F[Lb+(N div 2)].X+F[Lb+(N div 2)].Y;
  end;
  FFTR1D(H,0,(N-1),FH);
  for I := 0 to (N-1) do
  begin
    A[I]:=(FH[I].X-FH[I].Y)/N;
  end;
end;

end. 
