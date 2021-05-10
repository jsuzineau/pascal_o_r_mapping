{ This file is part of NVUtils suite.
  Home of the project: http://sourceforge.net/projects/nvcomponents.nestopatch.p/
  Copyright (C) 2013-2015 Viatcheslav Nesterov

  This source is free software; you can redistribute it and/or modify it under the terms of the GNU General Public
  License as published by the Free Software Foundation; either version 2 of the License, or (at your option) any later
  version.

  This code is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
  warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
  details.

  A copy of the GNU General Public License is available on the World Wide Web at
  <http://www.gnu.org/copyleft/gpl.html>. You can also obtain it by writing to the Free Software Foundation, Inc., 59
  Temple Place - Suite 330, Boston, MA 02111-1307, USA. }
unit lmcoordsys;
{ TODO : Write DrawSpline for separate X and Y arrays }
interface

uses
  {$ifndef fpc}Windows, Messages,{$endif}
  SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, uTypes, uIntervals, uspline, lmPointsVec, LResources;

const
  AxisUp    = 0;{<Constants, defining direction of Y-axis}
  AxisDown  = 1;
  AxisRight = 0;{<Of X-Axis}
  AxisLeft  = 1;

  ColorAxis      =  clBlack; {<Black. Default colors of corresponding elements. May be changed by SetColors}
  ColorBack      =  clSilver; {<LightGray}
  ColorText      =  clRed; {<Red}
  ColorGridLines = clWhite; {<White}
  ColorOutput    =  clBlue; {<Blue. Default color of user data, put by PutPoint,
                      PutLine, LineTo. May be changed by SetOutputColor}

  DashLength = 5;

{everything outside [LowerLimitForFixedFormat..UpperLimitForFixedFormat] is written in ingeneer notation (e.g.1.0E9)}
  UpperLimitForFixedFormat = 1E7;
  LowerLimitForFixedFormat = 1E-4;

type

  { TCoordSys }

  TCoordSys = class(TPanel)
  private
    FAxisPen:TPen;
    FOutputPen:TPen;
    FGridPen:TPen;
    FPenPos:TRealPoint;
    FXAxisLabel,FYAxisLabel:String;{<Text labels for axis}
    FMinX,FMinY,FMaxX,FMaxY:Float;  {<limits of user coordinates}
    FXPos,  FYPos  : Float; {<Axis positions in user coords. May differ from zero}
    FOnPaint:TNotifyEvent;
    FXGridDist,FYGridDist:Float; {<Distances between grid lines or dashes at axis}
 //   FXGridLines,FYGridLines:boolean;{Whether GridLines (if true) or dashes at axis are drawn}
 //   FXNumbers, FYNumbers:boolean;{Write numbers near gridlines or dashes or not}
    FLeftMargin, FRightMargin, FUpperMargin, FLowerMargin:integer;
    FXGridNumbersPrecision, FXGridNumbersDecimals : integer;
    FYGridNumbersPrecision, FYGridNumbersDecimals : integer;
  protected
    function GetFont:TFont;
    procedure SetXAxisLabel(const ALabel:String);virtual;{<Texts of axis labels}
    function GetXAxisLabel:string; virtual;
    procedure SetYAxisLabel(const ALabel:String);virtual;{<Texts of axis labels}
    function GetYAxisLabel:string; virtual;
    procedure SetMinX(AMinX:Float); virtual;
    procedure SetMaxX(AMaxX:Float); virtual;
    procedure SetMinY(AMinY:Float); virtual;
    procedure SetMaxY(AMaxY:Float); virtual;
    procedure DrawAxis; virtual;
    procedure DrawHorGridLine(YGridPos:float); virtual;
    procedure DrawVertGridLine(XGridPos:float); virtual;
    procedure DrawGridLines; virtual;
    procedure DrawAxisLabels; virtual; abstract; {<Writes text labels near the ends of axis, if defined}
    procedure SetLeftMargin(AMargin:integer); virtual;
    procedure SetRightMargin(AMargin:integer); virtual;
    procedure SetLowerMargin(AMargin:integer); virtual;
    procedure SetUpperMargin(AMargin:integer); virtual;
    procedure SetXPos(AXPos:Float); virtual;
    procedure SetYPos(AYPos:Float); virtual;
    procedure SetXGridDist(AXGridDist:Float); virtual;
    procedure SetYGridDist(AYGridDist:Float); virtual;
    procedure SetAxisPen(APen:TPen); virtual;
    procedure SetGridPen(APen:TPen); virtual;
    procedure SetOutputPen(APen:TPen); virtual;
    procedure SetPenPos(APenPos:TRealPoint); virtual;
    {length and position of axis dashes and numbers. }
    procedure SetGridDir; virtual; abstract;
  public
    ScaleX, ScaleY:Float; {<pix per user unit}
    {used both for LineTo and PutNewPoint}
    property PenPos: TRealPoint read FPenPos write SetPenPos;
    constructor Create(AOwner:TComponent); override;
    destructor Destroy; override;
    procedure Paint; override;
    procedure LineTo(APoint:TRealPoint); overload; {< draws line from PenPos to APoint and moves PenPos there}
    procedure LineTo(X,Y:Float); overload;
    {Sets new user limits, calls RedrawCoordSys}
    procedure NewLimits(AMinX,AMinY,AMaxX,AMaxY:Float); virtual;
    {sets MinX to AX and modifies MaxX accordingly}
    procedure XScrollTo(AX:Float); virtual;
    {sets MinY to AY and modifies MaxY accordingly}
    procedure YScrollTo(AY:Float); virtual;
    {Puts line of OutputColor from (X1,Y1) to (X2,Y2)}
    procedure PutLine(P1,P2:TRealPoint); overload;
    procedure PutLine(X1,Y1,X2,Y2:Float); overload;
    {in SX, SY screen coords for users X,Y}
    function UserToScreen(UP:TRealPoint):TPoint;virtual;
    {screen X-coordinate corresponding to user abscissa}
    function  XUserToScreen(X:Float):integer;virtual;
    {screen Y-coordinate corresponding to user ordinate}
    function  YUserToScreen(Y:Float):integer;virtual;
    {Screen coordinate to user-space coordinate}
    function  XScreenToUser(X:integer):Float; virtual;
    {Screen coordinate to user-space coordinate}
    function  YScreenToUser(Y:integer):Float; virtual;
    {draws circle with center in user-coordinate space and radius in pixels}
    procedure Circle(Center:TRealPoint; R:integer); virtual;
    {draws circle with cross. Center in user-coordinate space and radius in pixels}
    procedure Aim(Center: TRealPoint; R: integer); virtual;
    procedure FillRect(X1,Y1,X2,Y2:Float); overload;
    procedure Fillrect(P1,P2:TRealPoint); overload;
     procedure GoToXY(X,Y:Float); {< sets PenPos}
    {screen coordinates o user-space coordinates transition}
    function ScreenToUser(SP:TPoint):TRealPoint; virtual;
    // multiply all coordinates, axes and grid positions by a factos CoeffX and CoeffY
    procedure ReScale(CoeffX, CoeffY:Float);
    //fast optimized drawing of large (>10000) arrays of TRealPoint
    // Only if "X" is sorted in ascending order
    procedure FastDraw(APoints:TRealPointVector; Lb, Ub: integer);
    // draw spline through the points Apoints[Lb]..APoints[Ub]
    procedure DrawSpline(APoints:TPoints; Lb, Ub: integer);
    //draws TParamFunc (function(X:Float; Params:Pointer):Float from LeftX to RightX.
    //If they are outside MinX..MaxX they are cropped
    procedure DrawFunc(AFunc:TParamFunc; Params:Pointer; LeftX, RightX : Float); virtual;
  published                                    
    property XAxisLabel:string read FXAxisLabel write FXAxisLabel;
    property YAxisLabel:string read FYAxisLabel write FYAxisLabel;
    property MinX:Float read FMinX write SetMinX; {< MinX,MinY,MaxX,MaxY define window bounds in user coord. space}
    property MinY:Float read FMinY write SetMinY;
    property MaxX:Float read FMaxX write SetMaxX;
    property MaxY:Float read FMaxY write SetMaxY;
    // position of x-axis
    property XPos:Float read FXPos write SetXPos;
    // position of Y-axis
    property YPos:Float read FYPos write SetYPos;
    property Font:TFont read GetFont;
    // pen to draw axis
    property AxisPen:TPen read FAxisPen write SetAxisPen;
    //pen to draw user's output (from OnDrawData event)
    property OutputPen:TPen read FOutputPen write SetOutputPen;
    // pen to draw gridlines
    property GridPen:TPen read FGridPen write SetGridPen;
    {Margin values in pixels}
    property LeftMargin:integer read FLeftMargin write SetLeftMargin default 0;
    property RightMargin:integer read FRightMargin write SetRightMargin default 0;
    property LowerMargin:integer read FLowerMargin write SetLowerMargin default 0;
    property UpperMargin:integer read FUpperMargin write SetUpperMargin default 0;
    //distance between grids in user space coords
    property XGridDist:Float read FXGridDist write SetXGridDist;
    //distance between grids in user space coords
    property YGridDist:Float read FYGridDist write SetYGridDist;
    // Precision parameter for FloatToStrF call for grid numbering
    property XGridNumbersPrecision: integer read FXGridNumbersPrecision write FXGridNumbersPrecision default 5;
    // Decimals parameter for FloatToStrF call for grid numbering
    property XGridNumbersDecimals: integer read FXGridNumbersDecimals write FXGridNumbersDecimals default 2;
    // Precision parameter for FloatToStrF call for grid numbering
    property YGridNumbersPrecision: integer read FYGridNumbersPrecision write FYGridNumbersPrecision default 9;
    // Decimals parameter for FloatToStrF call for grid numbering
    property YGridNumbersDecimals: integer read FYGridNumbersDecimals write FYGridNumbersDecimals default 4;
    property Canvas;
    // all drawing of user data (like drawfunction, fastdraw, all user-defined drawing etc) must be done in this event.
    property OnDrawData:TNotifyEvent read FOnPaint write FOnPaint;
  end;

  operator := (P:TPoint) R:TIntegerPoint;
  operator := (P:TIntegerPoint) R:TPoint;
procedure Register;

implementation

constructor TCoordSys.Create(AOwner:TComponent);
begin
  inherited Create(AOwner);
  ScaleX := 1;
  FAxisPen := TPen.Create;
  FAxisPen.Color := ColorAxis;
  FOutputPen := TPen.Create;
  FOutputPen.Color := ColorOutput;
  FGridPen := TPen.Create;
  FGridPen.Color := ColorGridLines;
  FMinX := -5; FMaxX := 5;
  FMinY := -5; FMaxY := 5;
  FUpperMargin := 1;
  FLowerMargin := 1;
  FLeftMargin := 1;
  FRightMargin := 1;
end;

destructor TCoordSys.Destroy;
begin
  FGridPen.Free;
  FOutputPen.Free;
  FAxisPen.Free;
  inherited Destroy;
end;

procedure TCoordSys.Paint;
begin
  if FMaxY > FMinY then
    ScaleY := (Height-LowerMargin-UpperMargin)/(FMaxY-FMinY)
  else
    ScaleY := 1;
  if FMaxX > FMinX then
    ScaleX := (Width-LeftMargin-RightMargin)/(FMaxX-FMinX)
  else ScaleX := 1;
  inherited Paint;
  DrawGridLines;
  DrawAxis;
  Canvas.Pen.Assign(OutputPen);
  if Assigned(OnDrawData) then OnDrawData(Self);
end;

procedure TCoordSys.SetPenPos(APenPos:TRealPoint);
begin
  FPenPos := APenPos;
  Canvas.PenPos := UserToScreen(FPenPos);
end;

procedure TCoordSys.GoToXY(X,Y:Float);
begin
  FPenPos.X := X;
  FPenPos.Y := Y;
  Canvas.PenPos := UserToScreen(FPenPos);
end;

procedure TCoordSys.SetMinX(AMinX:Float);
begin
  FMinX := AMinX;
  Invalidate;
end;

procedure TCoordSys.SetMaxX(AMaxX:Float);
begin
  FMaxX := AMaxX;
  Invalidate;
end;

procedure TCoordSys.SetMinY(AMinY:Float);
begin
  FMinY := AMinY;
  Invalidate;
end;

procedure TCoordSys.SetMaxY(AMaxY:Float);
begin
  FMaxY := AMaxY;
  Invalidate;
end;

function TCoordSys.XUserToScreen(X:Float):integer;
begin
  if X >= MaxX then XUserToScreen := Width-RightMargin else
  if X <= MinX then XUserToScreen := LeftMargin else
  XUserToScreen := LeftMargin+Round((X - MinX) * ScaleX)
end;

function TCoordSys.YUserToScreen(Y:Float):integer;
begin
  if Y >= MaxY then YUserToScreen := UpperMargin else
  if Y <= MinY then YUserToScreen := Height-LowerMargin else
  YUserToScreen := Height-LowerMargin - Round((Y - MinY) * ScaleY)
end;

function TCoordSys.UserToScreen(UP:TRealPoint):TPoint;
begin
  Result.X := XUserToScreen(UP.X);
  Result.Y := YUserToScreen(UP.Y);
end;

function TCoordSys.GetFont:TFont;
begin
  GetFont := Canvas.Font;
end;

procedure TCoordSys.SetXAxisLabel(const ALabel:String);
begin
  FXAxisLabel := ALabel;
end;

function TCoordSys.GetXAxisLabel:string;
begin
  GetXAxisLabel := FXAxisLabel;
end;

procedure TCoordSys.SetYAxisLabel(const ALabel:String);
begin
  FYAxisLabel := ALabel;
end;

function TCoordSys.GetYAxisLabel:string;
begin
  GetYAxisLabel := FYAxisLabel;
end;

procedure TCoordSys.LineTo(APoint:TRealPoint);
var
  SP:TPoint;
begin
  SP := UserToScreen(APoint);
  with Canvas.PenPos do
    if (X <> SP.X) or (Y <> SP.Y) then
    Canvas.LineTo(SP.X,SP.Y);
  FPenPos := APoint;
end;

procedure TCoordSys.LineTo(X,Y:Float);
var
  SX, SY:word;
begin
  SX := XUserToScreen(X);
  SY := YUserToScreen(Y);
  with Canvas.PenPos do
    if (X <> SX) or (Y <> SY) then
      Canvas.LineTo(SX,SY);
  FPenPos.X := X; FPenPos.Y := Y;
end;

procedure TCoordSys.NewLimits(AMinX, AMinY, AMaxX, AMaxY: Float);
begin
  if AMinX > AMaxX then
    Raise Exception.Create('Min X cannot be more then Max X') at
      get_caller_addr(get_frame),get_caller_frame(get_frame);
  if AMinY > AMaxY then
    Raise Exception.Create('Min Y cannot be more then Max Y') at
      get_caller_addr(get_frame),get_caller_frame(get_frame);
  FMinX := AMinX; FMinY := AMinY; FMaxX := AMaxX; FMaxY := AMaxY;
  Invalidate;
end;

procedure TCoordSys.XScrollTo(AX: Float);
var
  Range:Float;
begin
  Range := MaxX - MinX;
  FMinX := AX;
  FMaxX := FMinX + Range;
  Invalidate;
end;

procedure TCoordSys.YScrollTo(AY: Float);
var
  Range:Float;
begin
  Range := MaxY - MinY;
  FMinY := AY;
  FMaxY := FMinY + Range;
  Invalidate;
end;

procedure TCoordSys.PutLine(P1,P2: TRealPoint);
begin
  PenPos := P1;
  LineTo(P2);
end;

procedure TCoordSys.PutLine(X1, Y1, X2, Y2: Float);
begin
  GoToXY(X1,Y1);
  LineTo(X2,Y2);
end;

procedure TCoordSys.SetLeftMargin(AMargin:integer);
begin
  FLeftMargin := AMargin;
  Invalidate;
end;

procedure TCoordSys.SetUpperMargin(AMargin:integer);
begin
  FUpperMargin := AMargin;
  Invalidate;
end;

procedure TCoordSys.SetRightMargin(AMargin:integer);
begin
  FRightMargin := AMargin;
  Invalidate;
end;

procedure TCoordSys.SetLowerMargin(AMargin:integer);
begin
  FLowerMargin := AMargin;
  Invalidate;
end;

procedure TCoordSys.SetXPos(AXPos:Float);
begin
  if AXpos > MaxY
    then FXPos := MaxY
  else if AXPos < MinY
    then FXPos := MinY
  else
    FXPos := AXPos;
  invalidate;
end;

procedure TCoordSys.SetYPos(AYPos:Float);
begin
  if AYpos > MaxX
    then FYPos := MaxX
  else if AYPos < MinX
    then FYPos := MinX
  else
    FYPos := AYPos;
  invalidate;
end;

procedure TCoordSys.DrawAxis;
var
  XP, YP:integer;
begin
  Canvas.Pen.Assign(AxisPen);
  YP := XUserToScreen(YPos);
  XP := YUserToScreen(XPos);
  Canvas.MoveTo(YP,UpperMargin);
  Canvas.LineTo(YP,Height-LowerMargin);
  Canvas.MoveTo(LeftMargin,XP);
  Canvas.LineTo(Width-RightMargin,XP);
end;

procedure TCoordSys.SetXGridDist(AXGridDist:Float);
begin
  FXGridDist := AXGridDist;
  invalidate;
end;

procedure TCoordSys.SetYGridDist(AYGridDist:Float);
begin
  FYGridDist := AYGridDist;
  invalidate;
end;

procedure TCoordSys.DrawHorGridLine(YGridPos:float);
var
  S:string;
begin
  PutLine(MinX, YGridPos, MaxX, YGridPos);
  if ((abs(FMinY) < LowerLimitForFixedFormat) and (abs(FMaxY) < LowerLimitForFixedFormat))
  or (FMaxY > UpperLimitForFixedFormat) or (abs(FMinY) > UpperLimitForFixedFormat)
  then
    S := FloatToStrF(YGridPos,ffExponent,YGridNumbersPrecision,YGridNumbersDecimals)
  else
    S := FloatToStrF(YGridPos,ffFixed,YGridNumbersPrecision,YGridNumbersDecimals);
  Canvas.TextOut(1,YUserToScreen(YGridPos)-Canvas.TextHeight(S) div 2,S);
end;

procedure TCoordSys.DrawVertGridLine(XGridPos:float);
var
  S:String;
begin
  PutLine(XGridPos,MinY,XGridPos,MaxY);
  if ((abs(FMinX) < LowerLimitForFixedFormat) and (abs(FMaxX) < LowerLimitForFixedFormat))
  or (FMaxX > UpperLimitForFixedFormat) or (abs(FMinX) > UpperLimitForFixedFormat)
  then
    S := FloatToStrF(XGridPos,ffExponent,XGridNumbersPrecision,XGridNumbersDecimals)
  else
    S := FloatToStrF(XGridPos,ffFixed,XGridNumbersPrecision,XGridNumbersDecimals);
  Canvas.TextOut(XUserToScreen(XGridPos)-Canvas.TextWidth(S) div 2,
        Height-Canvas.TextHeight(S)-1, S);
end;

procedure TCoordSys.DrawGridLines;
var
  I : integer;
  C:Float;

  procedure YForward;
  begin
    while C <= MaxY do
    begin
      DrawHorGridLine(C);
      C := C + YGridDist;
    end
  end;

  procedure YBackward;
  begin
    while C >= MinY do
    begin
      DrawHorGridLine(C);
      C := C - YGridDist;
    end
  end;

  procedure XForward;
  begin
    while C <= MaxX do
    begin
      DrawVertGridLine(C);
      C := C + XGridDist;
    end
  end;

  procedure XBackward;
  begin
    while C >= MinX do
    begin
      DrawVertGridLine(C);
      C := C - XGridDist;
    end
  end;

begin
  Canvas.Pen.Assign(GridPen);
  {starting to draw vertical grid}
  if YGridDist <> 0 then
  begin
    C := XPos;
    if XPos < MinY then
    begin
      repeat
        C := C + YGridDist
      until C > MinY;
      YForward;
    end else
    if XPos > MaxY then
    begin
      repeat
        C := C - YGridDist
      until C < MaxY;
      YBackward;
    end else
    begin
      C := C + YGridDist;
      YForward;
      C := XPos - YGridDist;
      YBackward;
    end;
  end;

  if XGridDist <> 0 then
  begin
    C := YPos;
    if YPos < MinX then
    begin
      repeat
        C := C + XGridDist
      until C > MinX;
      XForward;
    end else
    if YPos > MaxX then
    begin
      repeat
        C := C - XGridDist
      until C < MaxX;
      XBackward;
    end else
    begin
      C := C + XGridDist;
      XForward;
      C := YPos - XGridDist;
      XBackward;
    end;
  end;
end;

procedure TCoordSys.SetAxisPen(APen: TPen);
begin
  FAxisPen.Color := APen.Color;
  FAxisPen.Style := APen.Style;
  FAxisPen.Mode := APen.Mode;
  FAxisPen.Width := APen.Width;
end;

procedure TCoordSys.SetGridPen(APen: TPen);
begin
  FGridPen.Color := APen.Color;
  FGridPen.Style := APen.Style;
  FGridPen.Mode := APen.Mode;
  FGridPen.Width := APen.Width;
end;

procedure TCoordSys.SetOutputPen(APen: TPen);
begin
  FOutputPen.Color := APen.Color;
  FOutputPen.Style := APen.Style;
  FOutputPen.Mode := APen.Mode;
  FOutputPen.Width := APen.Width;
end;

{procedure TCoordSys.DrawAxisLabels;
var
  SX, SY:integer;
  X,Y:Float;
begin
  if XAxisLabel <> '' then
  begin
  end;
end;}

function TCoordSys.ScreenToUser(SP:TPoint):TRealPoint;
begin
  Result.X := XScreenToUser(SP.X);
  Result.Y := YScreenToUser(SP.Y);
end;

function TCoordSys.XScreenToUser(X: integer): Float;
begin
  if IsZero(ScaleX) then XScreenToUser := 0 else
    XScreenToUser := MinX + (X-LeftMargin)/ScaleX;
end;

function TCoordSys.YScreenToUser(Y: integer): Float;
begin
  if IsZero(ScaleY) then YScreenToUser := 0 else
    YScreenToUser := MinY + (Height - LowerMargin-Y)/ScaleY;
end;


procedure TCoordSys.FillRect(X1, Y1, X2, Y2: Float);
begin
  Canvas.FillRect(XUserToScreen(X1),YUserToScreen(Y2),XUserToScreen(X2), YUserToScreen(Y1));
end;

procedure TCoordSys.Fillrect(P1, P2: TRealPoint);
var P:TRect;
begin
  P.TopLeft := UserToScreen(P1);
  P.BottomRight := UserToScreen(P2);
  Canvas.FillRect(P);
end;

procedure TCoordSys.Circle(Center: TRealPoint; R: integer);
var
  CS:TPoint;
begin
  CS := UserToScreen(Center);
  Canvas.Ellipse(CS.x-R,CS.y-R,CS.x+R,CS.y+R);
end;

procedure TCoordSys.Aim(Center: TRealPoint; R: integer);
var
  CS:TPoint;
begin
  CS := UserToScreen(Center);
  Canvas.Ellipse(CS.x-R,CS.y-R,CS.x+R,CS.y+R);
  Canvas.Line(CS.X,CS.y-R,CS.X,CS.Y+R);
  Canvas.Line(CS.X-R,CS.Y,CS.X+R,CS.Y);
end;

procedure TCoordSys.ReScale(CoeffX, CoeffY:Float);
begin
  MinX := FMinX*CoeffX;
  MinY := MinY*CoeffY;
  MaxX := FMaxX*CoeffX;
  MaxY := FMaxY*CoeffY;
  XPos := FXPos*CoeffY;
  YPos := FYPos*CoeffX;
  XGridDist := FXGridDist*CoeffX;
  YGridDist := FYGridDist*CoeffY;
  Invalidate;
end;

//idea is that in large arrays many points share the same screen "X". However,
// "noise" of "Y" data lead to call of drawing almost for every of these points
//even if "PutNewLine" is used. Therefore, for every such group of points
//sharing same screen "X" we find min and max and then draw one vertical line
// and then line connecting last point in this group to first in the next group.
procedure TCoordSys.FastDraw(APoints: TRealPointVector; Lb, Ub: integer);
var
  SXSt, SXE: word;
  J: integer;
  MinLY, MaxLY: Float;
begin
  SXSt := XUserToScreen(APoints[Lb].X);
  SXE := XUserToScreen(APoints[Ub].X);
  if (SXSt < SXE) and ((Ub - Lb) div (SXE - SXSt) > 5) then
  begin
    J := Lb;
    while J <= Ub do
    begin
      MinLY := APoints[J].Y; MaxLY := MinLY;
      while XUserToScreen(APoints[J].X) = SXSt do
      begin
        if APoints[J].Y < MinLY then
          MinLY := APoints[J].Y;
        if APoints[J].Y > MaxLY then
          MaxLY := APoints[J].Y;
        inc(J);
        if J > Ub then
        begin
          Canvas.Line(SXSt,YUserToScreen(MinLY),SXSt,YUserToScreen(MaxLY));
          PenPos := APoints[Ub];
          Exit;
        end;
      end;
      Canvas.Line(SXSt,YUserToScreen(MinLY),SXSt,YUserToScreen(MaxLY));
      PutLine(APoints[J-1],APoints[J]);
      SxSt := Canvas.PenPos.X;
    end;
  end else
  begin
    PenPos := APoints[Lb];
    for J := Lb + 1 to Ub do
        LineTo(APoints[J]);
  end;
end;

procedure TCoordSys.DrawSpline(APoints: TPoints; Lb, Ub: integer);
var
  WinXInterval, FuncXInterval : TInterval;
  DInt : TInterval;
  Delta, Curr : Float;
  XV, YV, D2 : TVector;
  N : integer;
begin
  WinXInterval := DefineInterval(MinX, MaxX);
  FuncXInterval := DefineInterval(APoints[Lb].X, APoints[Ub].X);
  DInt := intersection(WinXInterval, FuncXInterval);
  if IntervalDefined(DInt) then
  begin
    Delta := (Dint.Hi - Dint.Lo)/(XUserToScreen(DInt.Hi) - XUserToScreen(DInt.Lo));
    Curr := Dint.Lo;
    N := Ub - Lb + 1;
    SetLength(XV,N);
    SetLength(YV, N);
    SetLength(D2, N);
    APoints.ExtractX(XV, Lb, Ub);
    APoints.ExtractY(YV, Lb, Ub);
    InitSpline(XV, YV, D2, Lb, Ub);
    Curr := DInt.Lo;
    GoToXY(Curr,SplInt(Curr, XV, YV, D2, Lb, Ub)); // at the beginning of interval
    while Curr <= DInt.Hi do
    begin
      Curr := Curr + Delta;
      LineTo(Curr, SplInt(Curr, XV, YV, D2, Lb, Ub));
    end;
  end;
end;

procedure TCoordSys.DrawFunc(AFunc: TParamFunc; Params: Pointer; LeftX, RightX: Float);
var
  XInterval:TInterval;
  FuncRange:TInterval;
  DInt:TInterval;
  Delta, Curr: Float;
  Val : Float;
  Drawing :boolean;
begin
  XInterval := DefineInterval(MinX, MaxX);
  FuncRange := DefineInterval(LeftX, RightX);
  DInt := intersection(XInterval, FuncRange);
  if IntervalDefined(DInt) then
  begin
    Delta := (Dint.Hi - Dint.Lo)/(XUserToScreen(DInt.Hi) - XUserToScreen(DInt.Lo));
    Curr := Dint.Lo;
    while Curr < DInt.Hi do
    begin
      try                         // This stuff is needed if function is not defined
        Val := AFunc(Curr, Params);
        if not Inside(Val,MinY,MaxY) then
        begin
          Curr := Curr + Delta;
          Continue;
        end;
        GoToXY(Curr,Val); // at the beginning of interval
        Drawing := true;  // so we look for a first value where it returns
        Break;            // correct value
      Except
        On Exception do
          Curr := Curr + Delta;
      end;
    end;
    while Curr < DInt.Hi do
    begin
      Curr := Curr + Delta;
      try
        Val := AFunc(Curr, Params);
        if inside(Val,MinY,MaxY) then
        begin
          if Drawing then
            LineTo(Curr, Val)
          else begin
            GoToXY(Curr,Val);
            Drawing := true;
          end;
        end else
          Drawing := false;
      except
        On Exception do
          Curr := Curr + Delta;
      end;
    end;
  end;
end;

procedure Register;
begin
  RegisterComponents('LMComponents', [TCoordSys]);
end;

operator := (P:TPoint) R:TIntegerPoint;
begin
  R.X := P.X;
  R.Y := P.Y;
end;

operator := (P:TIntegerPoint) R:TPoint;
begin
  R.X := P.X;
  R.Y := P.Y;
end;


initialization
  {$I nv_icons.lrs}
end.
