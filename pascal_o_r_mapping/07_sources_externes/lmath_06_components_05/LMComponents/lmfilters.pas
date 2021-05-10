unit lmfilters;
(*
   Both OnInput and OnOutput events are called from Filter method, to get next
   value from the data stream been filtered. This technique makes the filter
   independent from an actual data format.
   
   simplest way is:
   var
     DataArr:TVector:
     .....
   function Main.MyFilterInputFunc(Index:integer):Float;
   begin
     Result := DataArr[Index];
   end;
   
   procedure Main.MyFilterOutputProc(Val:Float; Index:integer);
   begin
     DataArr[Index] := Val;
   end;

   Gaussian filter is implemented according to:
   Young I.T., L.J. van Vliet. Recursive implementation of the Gaussian Filter.
   Signal Processing, 44 (1995) 139-151
*)

{$mode objfpc}{$H+}
interface
uses
  Classes, SysUtils, uTypes;

//finds effective cutoff frequency of cascade of 2 gaussian filters
function GaussCascadeFreq(Freq1, Freq2:Float):Float;

// finds risetime (10-90%) of a gaussian filter with given cut-off frequency
function GaussRiseTime(Freq:Float):Float;

//risetime of moving average filter (0-100%)
function MovAvRiseTime(SamplingRate:Float; WLength:integer):Float;

//cut-off freq. of moving average filter, given sampling rate and window length
function MoveAvCutOffFreq(SamplingRate:Float; WLength:integer):Float;

//find required window length from desired cut-off freq. and sampling rate
function MoveAvFindWindow(SamplingRate, CutOffFreq:Float):Integer;

type
  EFilterException = class(exception)
  end;

  TInputFunc = function(Index:integer):Float of Object;
  TOutputproc = procedure(Val:Float; Index:integer) of Object;

    { **************** TDigFilter ***************************}

  TDigFilter = class(TComponent)
  protected
    FOnInput:TInputFunc;
    FOnOutput:TOutputProc;
  public
    //receives inpus signal values by calls OnInput, makes actual filtering and outputs result by calls of OnOutput
    procedure Filter(StartIndex, EndIndex:integer); virtual; abstract;
  published
    // function(Index:integer):Float; must provide value of input signal at index Index. Is called from procedure Filter
    property OnInput:TInputFunc read FOnInput write FOnInput;
    // procedure(Val:Float; Index:integer) receives value of filtered signal at Index and can do with it what a user needs
    // is called from Filter
    property OnOutput:TOutputProc read FOnOutput write FOnOutput;
  end;

  { **************** TOneFreqFilter ***************************}

  // abstract class which describes lowpass or highpass filters (but not pass- or stopband)
  TOneFreqFilter = class(TDigFilter)
  private
    FSamplingRate : Float;
    FCutFreq1     : Float;
  public
    constructor Create(AOwner:TComponent); override;
    procedure SetupFilter(ASamplingRate, ACutFreq1 : Float); virtual;
  published
    property SamplingRate : Float read FSamplingRate;
    property Cutfreq1     : Float read FCutFreq1;
  end;

  { **************** TFIRFilter *****************}

  TFIRFilter = class(TOneFreqFilter)
  protected
    FWinLength : integer;
    procedure SetWinLength(L:integer); virtual;
  public
    constructor Create(AOwner:TComponent); override;
  published
    property WinLength : integer read FWinLength write SetWinLength;
  end;

{ **************** TMovAvFilter ***************************}

//moving average filter
  TMovAvFilter = class(TFIRFilter)
  protected
    procedure SetWinLength(L:integer); override;
  public
    procedure Filter(StartIndex, EndIndex:integer); override;
    procedure SetupFilter(ASamplingRate, ACutFreq:Float); override;
  published
    property WinLength : integer read FWinLength write SetWinLength;
  end;

  { **************** TGaussFilter ***************************}

  //gaussian filter
  TGaussFilter = class(TOneFreqFilter)
  private
    FSigma : Float;
    Q      : Float;
    Bs     : array[0..3] of Float;
    BL     : Float;
    procedure FindParams;
    procedure ForwardFilter(StartIndex, EndIndex:integer);
    procedure BackwardFilter(StartIndex, EndIndex:integer);
  public
    constructor Create(AOwner:TComponent); override;
    procedure SetupFilter(ASamplingRate, ACutFreq1: Float); override;
    procedure Filter(StartIndex, EndIndex:integer); override;
  end;

    { **************** TMedianFilter ***************************}

  { TMedianFilter }

  TMedianFilter = class(TFIRFilter)
  private
    DataBuffer:array of Float;
    HalfWin, HighWin : integer;
  protected
    function FindMedian:Float;
    procedure SetWinLength(L:integer); override;
  public
    constructor Create(AOwner:TComponent); override;
    procedure filter(StartIndex, EndIndex:integer); override;
  end;

procedure Register;

implementation

{ ********************** TOneFreqFilter *************************}

constructor TOneFreqFilter.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  SetupFilter(14400, 4000);
end;

procedure TOneFreqFilter.SetupFilter(ASamplingRate, ACutFreq1: Float);
begin
  FSamplingRate := ASamplingRate;
  FCutFreq1     := ACutFreq1;
end;

{ **************** TFIRFilter *****************}
constructor TFIRFilter.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FWinLength := 5;
end;

procedure TFIRFilter.SetWinLength(L:integer);
begin
  FWinLength := L;
end;

{ ******************** TMedianFilter *************************** }
constructor TMedianFilter.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  setlength(DataBuffer, FWinLength);
end;

procedure TMedianFilter.SetWinLength(L: integer);
begin
  if L < 3  then
    Raise EFilterException.Create('Window length must be > 3 and odd for median filter');
  inherited SetWinLength(L);
  setlength(DataBuffer, L);
end;

function TMedianFilter.FindMedian:Float;
var
   I,J,M,L,R:integer;
   X,Buf:Float;
begin
   M := HalfWin + 1;
   L := 0; R := HighWin;
   while L < R - 1 do
   begin
     X := Self.DataBuffer[M];
     I := L; J := R;
     repeat
       while DataBuffer[I] < X do // they are in place; no need to exchange
         inc(I);
       while DataBuffer[J] > X do
         dec(J);
       if I <= J then  //pair to exchange found
       begin
         Buf := DataBuffer[I];
         DataBuffer[I] := DataBuffer[J];
         DataBuffer[J] := Buf;
         inc(I); dec(J);
       end;
     until I > J;
     if J < M then L := I;
     if I > M then R := J;
   end;
   Result := DataBuffer[M];
end;

procedure TMedianFilter.filter(StartIndex, EndIndex: integer);
var
  I, J: Integer;
  First:Float;
begin
  if FWinLength mod 2 = 0 then
    WinLength := FWinLength + 1;
  if FWinLength >= Endindex - StartIndex then
    Raise EFilterException.Create('Filter window is longer then data!');
  HalfWin := FWinLength div 2 - 1;
  HighWin := FWinLength - 1;
  First := FOnInput(StartIndex);
  (* Part one: padding actual data with first value *)
  for I := StartIndex to StartIndex + HalfWin do
  begin
    for J := 0 to HalfWin - I do
      DataBuffer[J] := First;
    for J := HalfWin - I + 1 to HighWin do
      DataBuffer[J] := FOnInput(I+J-HalfWin);
    FOnOutput(FindMedian, I);
  end;
  (* Part two: completely inside the actual data *)
  for I := StartIndex + HalfWin + 1 to EndIndex - HalfWin do
  begin
    for J := 0 to HighWin do
      DataBuffer[J] := FOnInput(I + J - HalfWin);
    FOnOutput(FindMedian, I);
  end;
  (* Part three: padding data at the end *)
  First := FOnInput(EndIndex);
  for I := EndIndex - HalfWin + 1 to EndIndex do
  begin
    for J := 0 to EndIndex - I do
      DataBuffer[J] := FOnInput(I - HalfWin + J);
    for J := EndIndex - I + 1 to HighWin do
      DataBuffer[J] := First;
    FOnOutput(FindMedian, I);
  end;
end;

{ ************************* TGaussFilter **************************** }

procedure TGaussFilter.FindParams;
var
  Q2, Q3 : extended;
begin
  FSigma := FSamplingrate*0.83/(2*Pi*FCutFreq1);
  if FSigma >= 2.5 then
    Q := 0.98711 * FSigma - 0.96330
  else
    Q := 3.97156 - 4.14554 * Sqrt(1 - 0.26891 * FSigma);
  Q2 := Q*Q;
  Q3 := Q2*Q;
  Bs[0] := 1.57825 + 2.44413*Q + 1.4281*Q2 + 0.422205*Q3;
  Bs[1] := 2.44413*Q + 2.85619*Q2 + 1.26661*Q3;
  Bs[2] := -1.4281*Q2 - 1.26661*Q3;
  Bs[3] := 0.422205*Q3;
  BL    := 1 - (Bs[1] + Bs[2] + Bs[3])/Bs[0];
end;

type
  TPT = 0..3;

procedure TGaussFilter.ForwardFilter(StartIndex, EndIndex:integer);
var
  WD : array[TPT] of Float;
  Pt : array [TPT] of TPT;
  I  : integer;
  J  : TPT;
begin
  WD[0] := FOnInput(StartIndex);
  Pt[0] := 0;
  for I := 1 to 3 do
  begin
    WD[I] := WD[0];  //data are padded before beginning with Data[StartIndex]
    Pt[I] := I;
  end;
  for I := startIndex to EndIndex - 1 do
  begin
    FOnOutput(WD[Pt[3]],I);
    WD[Pt[3]] := BL*FOnInput(I+1)+(WD[Pt[2]]*Bs[1]+WD[Pt[1]]*Bs[2]+Bs[3]*WD[Pt[0]])/Bs[0];
    for J := 0 to 3 do
      if Pt[J] < 3 then
        Pt[J] := Succ(Pt[J])
      else
        Pt[J] := 0;
  end;
  FOnOutput(WD[Pt[3]],Endindex);
end;

procedure TGaussFilter.BackwardFilter(StartIndex, EndIndex: integer);
var
  WD : array[TPT] of Float;
  Pt : array [TPT] of TPT;
  I  : integer;
  J  : TPT;
begin
  WD[0] := FOnInput(EndIndex);
  Pt[0] := 0;
  for J := 1 to 3 do
  begin
    Pt[J] := J;
    WD[J] := WD[0];
  end;
  for I := EndIndex downto StartIndex+1 do
  begin
    FOnOutput(WD[Pt[3]],I);
    WD[Pt[3]] := BL*FOnInput(I-1)+(WD[Pt[2]]*Bs[1]+WD[Pt[1]]*Bs[2]+Bs[3]*WD[Pt[0]])/Bs[0];
    for J := 0 to 3 do
      if Pt[J] < High(TPT) then
        Pt[J] := Succ(Pt[J])
      else
        Pt[J] := Low(TPT);
  end;
  FOnOutput(WD[Pt[3]],startindex);
end;

constructor TGaussFilter.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FindParams;
end;

procedure TGaussFilter.SetupFilter(ASamplingRate, ACutFreq1: Float);
begin
  inherited SetupFilter(ASamplingRate, ACutFreq1);
  FindParams;
end;

procedure TGaussFilter.Filter(StartIndex, EndIndex: integer);
begin
  ForwardFilter(StartIndex, EndIndex);
  BackwardFilter(StartIndex, EndIndex);
end;


{ **************************** TMovAvFilter ******************************** }

procedure TMovAvFilter.SetWinLength(L: integer);
begin
  FWinLength := L;
  FCutFreq1 := 0.44292/Sqrt(L*L-1)*FSamplingRate;
end;

procedure TMovAvFilter.Filter(StartIndex, EndIndex: integer);
var
  Buffer : extended;
  I,J,L:integer;
  WindowData:array of Float;
  PrevPtr:integer;
begin
  if WinLength >= Endindex - StartIndex then
    Raise EFilterException.Create('Averaging window is longer then data!');
  SetLength(WindowData, WinLength);
  Buffer := 0;
  for I := 0 to WinLength - 1 do
  begin
    WindowData[I] := FOnInput(StartIndex+I);
    Buffer := Buffer + WindowData[I];
  end;
  PrevPtr := 0;
  L := StartIndex; // next datapoint to be written
  J := StartIndex + WinLength; // points to next datapoint to be read
  repeat
     FOnOutput(Buffer/WinLength,L);
     Buffer := Buffer - WindowData[PrevPtr];
     WindowData[PrevPtr] := FOnInput(J);
     Buffer := Buffer + WindowData[PrevPtr];
     inc(PrevPtr);
     if PrevPtr = WinLength then
       PrevPtr := 0;
     inc(L); inc(J);
  until J > EndIndex;
  for I := L to EndIndex do
  begin
    Buffer := 0;
    for J := 0 to EndIndex - I do  // EndIndex - I is decreasing length of window
      Buffer := Buffer + WindowData[J];
    FOnOutput(Buffer/(EndIndex - I + 1),I);
  end;
end;

procedure TMovAvFilter.SetupFilter(ASamplingRate, ACutFreq: Float);
begin
  inherited SetupFilter(ASamplingRate, ACutFreq);
  FWinLength := MoveAvFindWindow(ASamplingRate,ACutFreq);
end;

{ ********************* General functions *********************************}
function GaussCascadeFreq(Freq1, Freq2: Float): Float;
begin
  if Freq1 = 0 then
    Result := Freq2
  else if Freq2 = 0 then
    Result := Freq1
  else
    Result := 1/Sqrt(1/Freq1/Freq1 + 1/Freq2/Freq2);
end;

function GaussRiseTime(Freq: Float): Float;
begin
  if Freq = 0 then
    Result := MaxNum
  else
    Result := 0.33/Freq;
end;

function MovAvRiseTime(SamplingRate: Float; WLength: integer): Float;
begin
  Result := WLength/SamplingRate;
end;

function MoveAvCutOffFreq(SamplingRate: Float; WLength: integer): Float;
begin
  Result := 0.44292/Sqrt(WLength*WLength-1)*SamplingRate;
end;

function MoveAvFindWindow(SamplingRate, CutOffFreq: Float): Integer;
var
  F:Float;
begin
  F := CutOffFreq/SamplingRate;
  Result := Round(Sqrt(0.196196+F*F)/F);
end;

procedure Register;
begin
  RegisterComponents('LMComponents', [TMovAvFilter, TGaussFilter, TMedianFilter]);
end;

end.

