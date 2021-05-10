{ ******************************************************************
  Mean and standard deviations, aware of missing data
  ****************************************************************** }

unit umeansd_md;

interface

uses
  utypes;

var
  MissingData: Float = NAN;

{returns true if F is NAN or Missing data}
function Undefined(F:Float):boolean;

{set missing data code}
procedure SetMD(aMD:float);

{Finds first defined element in array}
function FirstDefined(X:TVector; Lb,Ub:Integer):integer;

{valid (defined) number of elements in array}
function ValidN(X:TVector; Lb, Ub:Integer):integer;

{ Minimum of sample X }
function Min(X : TVector; Lb, Ub : Integer) : Float; overload;

{ Maximum of sample X }
function Max(X : TVector; Lb, Ub : Integer) : Float; overload;

{ Mean of sample X }
function Mean(X : TVector; Lb, Ub : Integer) : Float; overload;

{ Standard deviation estimated from sample X }
function StDev(X : TVector; Lb, Ub : Integer) : Float; overload;

{ Standard deviation of population }
function StDevP(X : TVector; Lb, Ub : Integer) : Float; overload;

implementation

function Undefined(F: Float): boolean;
begin
  Result := IsNAN(F) or (F = MissingData);
end;

procedure SetMD(aMD:float);
begin
  MissingData := aMD;
end;

function FirstDefined(X:TVector; Lb,Ub:Integer):integer;
var
  I:integer;
begin
  I := Lb;
  while Undefined(X[I]) and (I <= Ub) do inc(I);
  if Undefined(X[I]) then
    Result := Ub+1
  else
    Result := I;
end;

function ValidN(X:TVector; Lb, Ub:Integer):integer;
var
  I,S:integer;
begin
  S := 0;
  for I := Lb to Ub do
    if not Undefined(X[I]) then inc(S);
  Result := S;
end;

function Min(X : TVector; Lb, Ub : Integer) : Float;
var
  Xmin : Float;
  I,M    : Integer;
begin
  M := FirstDefined(X,Lb,Ub);
  if M > Ub then
    Result := MissingData
  else begin
    Xmin := X[M];
    for I := Succ(M) to Ub do
      if not Undefined(X[I]) and (X[I] < Xmin) then
        Xmin := X[I];
    Result := Xmin;
  end;
end;

function Max(X : TVector; Lb, Ub : Integer) : Float;
var
  Xmax : Float;
  I,M  : Integer;
begin
  M := FirstDefined(X,Lb,Ub);
  if Lb > Ub then
    Result := MissingData
  else begin
    Xmax := X[M];
    for I := Succ(M) to Ub do
      if not Undefined(X[I]) and (X[I] > Xmax) then
        Xmax := X[I];
    Result := Xmax;
  end;
end;

function Mean(X : TVector; Lb, Ub : Integer) : Float;
var
  SX     : Float;
  I,M,N  : Integer;
begin
  M := FirstDefined(X,Lb,Ub);
  SX := 0.0;
  if M > Ub then
    Result := MissingData
  else begin
    N := 0;
    for I := M to Ub do
    if not Undefined(X[I]) then
    begin
      SX := SX + X[I];
      inc(N);
    end;
    Mean := SX / N;
  end;
end;

function StDev(X : TVector; Lb, Ub : Integer) : Float;
var
  D, SD, SD2, V, MeanV: Float;
  I, N, M : Integer;
begin
  N := ValidN(X,Lb,Ub);
  if N = 0 then
  begin
    Result := MissingData;
    Exit;
  end;
  MeanV := Mean(X,Lb,Ub);
  M := FirstDefined(X,Lb,Ub);
  SD  := 0.0;  { Sum of deviations (used to reduce roundoff error) }
  SD2 := 0.0;  { Sum of squared deviations }
  for I := M to Ub do
  if not Undefined(X[I]) then
  begin
    D := X[I] - MeanV;
    SD := SD + D;
    SD2 := SD2 + Sqr(D)
  end;
  V := (SD2 - Sqr(SD) / N) / (N - 1);  { Variance }
  StDev := Sqrt(V);
end;

function StDevP(X : TVector; Lb, Ub : Integer) : Float;
var
  D, SD, SD2, V, MeanV : Float;
  I, N, M : Integer;
begin
  N := ValidN(X,Lb,Ub);
  if N = 0 then
  begin
    Result := MissingData;
    Exit;
  end;
  M := FirstDefined(X,Lb,Ub);
  MeanV := Mean(X,Lb,Ub);
  SD  := 0.0;  { Sum of deviations (used to reduce roundoff error) }
  SD2 := 0.0;  { Sum of squared deviations }
  for I := M to Ub do
  begin
    D := X[I] - MeanV;
    SD := SD + D;
    SD2 := SD2 + Sqr(D)
  end;
  V := (SD2 - Sqr(SD) / N) / N;  { Variance }
  StDevP := Sqrt(V);
end;

end.
