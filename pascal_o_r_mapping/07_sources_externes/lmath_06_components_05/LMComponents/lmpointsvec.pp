unit lmPointsVec;
{$mode objfpc}{$H+}
interface
uses
  Classes, SysUtils, uTypes, uSorting;

type
 { TPoints }

 ERealPointsException = class(Exception)
 end;

 TPoints = class
 protected
   function GetBuffer(I: integer): pointer;
   function GetX(ind:integer):Float;
   function GetY(ind:integer):Float;
   procedure SetX(ind:integer; value:Float);
   procedure SetY(ind:integer; value:Float);
   function GetPoint(ind:integer):TRealPoint;
   procedure SetPoint(ind:integer; Value:TRealPoint);
 public
   Points:TRealPointVector;
   Capacity:integer;
   Count:integer;
   Index:integer;
   constructor Create(ACapacity:integer);

   // Combine(XVector,YVector:TVector; Lb, Ub:integer)
   //combines TPoints from two TVector
   constructor Combine(XVector,YVector:TVector; Lb, Ub:integer);

   destructor Destroy; override;

   // Append(APoint:TRealPoint)
   //appends a point to the end (Count position). If Capacity riches, outomatically reallocates more space
    procedure Append(APoint:TRealPoint);

    //removes min(ACount, Count-Ind) points starting from Ind, moves rest to left. Returns count of actually removed points.
   function RemovePoints(Ind: integer; ACount:integer):integer;
   function Reallocate(Step:integer):integer; //<Reallocate(Step:integer) increases Capacity by Step
   procedure FreePoints; virtual;

   //AllocatePoints(ACapacity:integer) allocate given capacity, regardless of what was before
   procedure AllocatePoints(ACapacity:integer);

   // sorts by X
   procedure SortX(descending:boolean);

   function MaxX: Float; virtual; //< Maximal X value. After call, Index field points to element with this value
   function MaxY: Float; virtual; //< Maximal Y value. After call, Index field points to element with this value
   function MinX: Float; virtual; //< Minimal X value. After call, Index field points to element with this value
   function MinY: Float; virtual; //< Minimal Y value. After call, Index field points to element with this value
   function Range: Float; virtual; //< Range = MaxX - MinX
   function RangeY: Float; virtual; //< RangeY = MaxY - MinY
   //SortY(descending:boolean) sorts by Y
   procedure SortY(descending:boolean);

   // ExtractX(var AXVector:TVector; Lb, Ub: integer) extracts all X from [Lb..Ub] as TVector
   procedure ExtractX(var AXVector:TVector; Lb, Ub: integer);

   // ExtractY(var AYVector:TVector; Lb, Ub: integer) extracts all Y from [Lb..Ub] as TVector
   procedure ExtractY(var AYVector:TVector; Lb, Ub: integer);

   property X[I:integer]:Float read GetX write SetX;
   property Y[I:integer]:Float read GetY write SetY;
   property ThePoints[I:integer]:TRealPoint read GetPoint write SetPoint; default;

   //DataBuffer[I:integer]:pointer
   //pointer to Points[I]. Useful for fast low-level fill-in
   property DataBuffer[I:integer]:pointer read GetBuffer;
 end;

implementation

procedure TPoints.Append(APoint: TRealPoint);
begin
  if Count = Capacity then Reallocate(Capacity div 2 + 1);
  Points[Count] := APoint;
  inc(Count);
end;

function TPoints.RemovePoints(Ind: integer; ACount: integer):integer;
var
  I:integer;
begin
  if ACount = 0 then
  begin
    Result := 0;
    Exit;
  end;
  {$ifdef Debug}
  if Ind >= Count then
   Raise ERealPointsException.Create('Remove points: Points index out of range!') at
      get_caller_addr(get_frame),get_caller_frame(get_frame);
  {$endif}
  if Ind + ACount >= Count - 1 then
  begin
    Result := Count - Ind;
    Count := Ind;
  end
  else begin
    for I := Ind to Count - ACount - 1 do
      Points[I] := Points[I+ACount];
    Dec(Count, ACount);
    Result := ACount;
  end;
end;

procedure TPoints.AllocatePoints(ACapacity: integer);
begin
  Count := 0;
  SetLength(Points,ACapacity);
  Capacity := ACapacity;
end;

procedure TPoints.SortX(descending:boolean);
begin
  HeapSortX(Points,0,Count-1,Descending);
end;

procedure TPoints.SortY(descending:boolean);
begin
  HeapSortX(Points,0,Count-1,Descending);
end;

procedure TPoints.ExtractX(var AXVector:TVector; Lb, Ub: integer);
var
  I, L:integer;
begin
  if Lb > Count - 1 then
    Exit;
  if Ub > Count - 1 then
    Ub := Count - 1;
  L := Ub - Lb;
  if High(AXVector) < L then
    DimVector(AXVector, L);
  for I := Lb to Ub do
    AXVector[I-Lb] := Points[I].X;
end;

procedure TPoints.ExtractY(var AYVector:TVector; Lb, Ub: integer);
var
  I, L:integer;
begin
  if Lb > Count - 1 then
    Exit;
  if Ub > Count - 1 then
    Ub := Count - 1;
  L := Ub - Lb;
  if High(AYVector) < L then
    DimVector(AYVector, L);
  for I := Lb to Ub do
    AYVector[I-Lb] := Points[I].Y;
end;

function TPoints.GetX(ind: integer): Float;
begin
  {$ifdef Debug}if (ind >= 0) and (ind < Count) then{$endif}
    Result := Points[ind].X
  {$ifdef Debug}
  else
    Raise ERealPointsException.Create('Get X: Points index > Points count') at
      get_caller_addr(get_frame),get_caller_frame(get_frame);
  {$endif}
end;

function TPoints.MaxX: Float;
var
  I:integer;
begin
  Result := -MaxNum;
  for I := 0 to Count-1 do
    if Points[I].X > Result then
    begin
      Result := Points[I].X;
      Index := I;
    end;
end;

function TPoints.MaxY: Float;
var
  I:Integer;
begin
  Result := -MaxNum;
  for I := 0 to Count-1 do
    if Points[I].Y > Result then
    begin
      Result := Points[I].Y;
      Index := I;
    end;
end;

function TPoints.MinX: Float;
var
  I:Integer;
begin
  Result := MaxNum;
  for I := 0 to Count-1 do
    if Points[I].X < Result then
    begin
      Result := Points[I].X;
      Index := I;
    end;
end;

function TPoints.MinY: Float;
var
  I:Integer;
begin
  Result := MaxNum;
  for I := 0 to Count-1 do
    if Points[I].Y < Result then
    begin
      Result := Points[I].Y;
      Index := I;
    end;
end;

function TPoints.Range: Float;
begin
  Result := MaxX - MinX;
end;

function TPoints.RangeY: Float;
begin
  Result := MaxY - MinY;
end;

function TPoints.GetBuffer(I: integer): pointer;
begin
  Result := Addr(Points[I]);
end;

function TPoints.GetY(ind: integer): Float;
begin
  {$ifdef Debug}  if (ind >= 0) and (ind < Count) then {$endif}
    Result := Points[ind].Y
    {$ifdef Debug}  else
    Raise ERealPointsException.Create('Get Y: Points index > Points count') at
      get_caller_addr(get_frame),get_caller_frame(get_frame); {$endif}
end;

procedure TPoints.SetX(ind: integer; value: Float);
begin
  if ind < Capacity then
  begin
    Points[ind].X := value;
    if ind >= Count then
      Count := ind+1;
  end
  {$ifdef Debug}
  else
  Raise ERealPointsException.Create('Set X: Points index > capacity!') at
     get_caller_addr(get_frame),get_caller_frame(get_frame); {$endif}
end;

procedure TPoints.SetY(ind: integer; value: Float);
begin
  {$ifdef Debug}  if ind < Capacity then  {$endif}
  begin
    Points[ind].Y := value;
    if ind >= Count then
      Count := ind+1;
  end
  {$ifdef Debug}
  else
  Raise ERealPointsException.Create('Set Y: Points index > capacity!') at
     get_caller_addr(get_frame),get_caller_frame(get_frame); {$endif}
end;

function TPoints.GetPoint(ind: integer): TRealPoint;
begin
  {$ifdef Debug}  if ind < Count then {$endif}
    Result := Points[ind]
{$ifdef Debug}  else
    Raise ERealPointsException.Create('Get Point: Points index > Count') at
       get_caller_addr(get_frame),get_caller_frame(get_frame); {$endif}
end;

procedure TPoints.SetPoint(ind: integer; Value: TRealPoint);
begin
  {$ifdef Debug}  if ind < Capacity then  {$endif}
  begin
    Points[ind] := value;
    if ind >= Count then
      Count := ind+1;
  end {$ifdef Debug} else
  Raise ERealPointsException.Create('Set point: index > Capacity') at
     get_caller_addr(get_frame),get_caller_frame(get_frame);  {$endif}
end;

constructor TPoints.Create(ACapacity: integer);
begin
  inherited Create;
  setLength(Points,ACapacity);
  Capacity := ACapacity;
end;

constructor TPoints.Combine(XVector, YVector: TVector; Lb, Ub: integer);
var
  I:Integer;
begin
  inherited Create;
  Capacity := Ub - Lb + 1;
  setLength(Points,Capacity);
  Count := Capacity;
  for I := 0 to Count - 1 do
  begin
    if IsNAN(XVector[I+Lb]) or IsNAN(YVector[I+Lb]) then
      Continue;
    Points[I].X := XVector[I+Lb];
    Points[I].Y := YVector[I+Lb];
  end;
end;

destructor TPoints.Destroy;
begin
  inherited;
  Finalize(Points);
end;

procedure TPoints.FreePoints;
begin
  Finalize(Points);
  Capacity := 0;
  Count := 0;
  Index := 0;
end;

function TPoints.Reallocate(Step: integer):integer;
begin
  try
    SetLength(Points,Capacity+Step);
    Capacity := Capacity + Step;
    Result := Capacity;
  except
    on E:Exception do
      Result := 0;
   end;
end;

end.

