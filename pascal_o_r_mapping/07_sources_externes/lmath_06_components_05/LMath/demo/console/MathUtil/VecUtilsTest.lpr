program VecUtilsTest;
uses uTypes, uVectorHelper, uVecUtils;
var
  I,J:integer;
  M1,M2:TMatrix;
  V1,V2:TVector;
  IV1,IV2:TIntVector;
  IM1,IM2:TIntMatrix;
function DivBy10(V:float):boolean;
begin
  Result := Trunc(V) mod 10 = 0;
end;

function IDivBy10(V:integer):boolean;
begin
  Result := V mod 10 = 0;
end;

begin
  V1.FillWithArr(1,[2,4,5,7,8,10,11,12]);
  IV1.FillWithArr(1,[2,4,5,7,8,16,11,12]);
  if Any(V1,1,High(V1),@DivBy10) then
    writeln('V1 has an element divisibly by 10')
  else
    writeln('Element divisible by 10 in V1 not found');
  if Any(IV1,1,High(IV1),@IDivBy10) then
    writeln('IV1 has an element divisibly by 10')
  else
    writeln('Element divisible by 10 in IV1 not found');
  readln;
end.

