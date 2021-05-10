unit ufInfrason;

{$mode objfpc}{$H+}

interface

uses
    uuStrings,
    uInfrason,
    ublMesure,
    upoolMesure,
    Classes, SysUtils, FileUtil, Forms, Controls, TAGraph,
    TASources, TASeries, TAIntervalSources, TATransformations, Graphics,
    Dialogs, StdCtrls, ExtCtrls, ComCtrls, IniPropStorage, Serial, LazSerial,
    lazsynaser, lmcoordsys, utypes, uSpline, ufft;

type
  { TfInfrason }

  TfInfrason = class(TForm)
    bDemarrer: TButton;
   bStop: TButton;
   bFermer: TButton;
   bParametres: TButton;
   bPLU_from_Courant: TButton;
   cFFT: TChart;
   cbUse_PLU: TCheckBox;
   c: TChart;
   ChartAxisTransformations1: TChartAxisTransformations;
   ChartAxisTransformations1LogarithmAxisTransform1: TLogarithmAxisTransform;
   clsPressure: TLineSeries;
   clsFFT: TLineSeries;
   cs: TCoordSys;
   eCommande: TEdit;
   ics: TIntervalChartSource;
   ips: TIniPropStorage;
   Label1: TLabel;
   lDelta: TLabel;
   ls: TLazSerial;
   mLog: TMemo;
   PageControl1: TPageControl;
   Panel1: TPanel;
   TabSheet1: TTabSheet;
   tsCoordSys: TTabSheet;
   tsGraphe: TTabSheet;
   tsLog: TTabSheet;
   procedure cbUse_PLUChange(Sender: TObject);
   procedure csDrawData(Sender: TObject);
   procedure FormCreate(Sender: TObject);
   procedure bDemarrerClick(Sender: TObject);
   procedure bFermerClick(Sender: TObject);
   procedure bParametresClick(Sender: TObject);
   procedure bStopClick(Sender: TObject);
   procedure FormDestroy(Sender: TObject);
  public
  //Gestion boutons
  public
    procedure Boutons_Initialise;
    procedure Boutons_Finalise;
   //Infrason
   private
     Infrason: TInfrason;
     procedure Infrason_Data_change;
     procedure Infrason_Command_Result_Log;
  //FFT
  private
    FFT_Max, FFT_Size: Integer;
    FFT_Index: Integer;
    FFT_Time_Start: Float;
    FFT_Time_Step: Float;
    FFT_Pressure_Min, FFT_Pressure_Max: Float;
    FFT_Pressure_Sum_Min, FFT_Pressure_Sum_Max: Float;

    Time           : TVector;
    Pressure       : TVector;
    Pressure_dv    : TVector;
    Pressure_Spline: TVector;
    cPressure      : TCompVector;
    cFFT_Pressure  : TCompVector;
    Frequency      : TVector;
    FFT_Pressure   : TVector;
    FFT_Pressure_Sum: TVector;
    rpvFFT         : TRealPointVector;

    function FFT_Time( _i: Integer): Float;
    procedure FFT_Init;
    procedure FFT_Add;
    procedure FFT_Traite;
  end;

var
  fInfrason: TfInfrason;

implementation

{$R *.lfm}

{ TfInfrason }

procedure TfInfrason.FormCreate(Sender: TObject);
begin
     ips.IniFileName:= 'etc'+DirectorySeparator+'_Configuration.ini';
     Infrason:= TInfrason.Create( ls, mLog);
     Infrason.Mesure_CallBack:= @Infrason_Data_change;
     FFT_Init;

     bStop.Hide;
     {$IFDEF LINUX}
     ls.Device:= '/dev/ttyUSB0';
     {$ENDIF}
end;

procedure TfInfrason.FormDestroy(Sender: TObject);
begin
     FreeAndNil( Infrason);
end;

procedure TfInfrason.bParametresClick(Sender: TObject);
begin
     ls.ShowSetupDialog;
end;

procedure TfInfrason.Boutons_Initialise;
begin
     bDemarrer.Hide;
     bStop.Show;
     bFermer.Hide;
end;

procedure TfInfrason.Boutons_Finalise;
begin
     bDemarrer.Show;
     bFermer.Show;
end;

procedure TfInfrason.bDemarrerClick(Sender: TObject);
begin
     Infrason.Arreter:= False;
     clsPressure.Clear;

     ls.Open;
     Boutons_Initialise;
end;

procedure TfInfrason.bStopClick(Sender: TObject);
begin
     Infrason.Arreter:= True;
     bStop.Hide;
     if ls.Active
     then
         begin
         ls.Close;
         Boutons_Finalise;
         end;
end;

procedure TfInfrason.bFermerClick(Sender: TObject);
begin
     Application.Terminate;
end;

procedure TfInfrason.Infrason_Data_change;
var
   iDernier: Integer;
begin
     Infrason_Command_Result_Log;

     iDernier:= clsPressure.Count-1;
     clsPressure.AddXY( Infrason.Time, Infrason.Pressure);
     poolMesure.Ajoute( Infrason.Time, Infrason.Pressure);
     if iDernier > 1000
     then
         clsPressure.Delete(0);
     FFT_Add;
end;


procedure TfInfrason.Infrason_Command_Result_Log;
begin
     mLog.Lines.Add( IntToStr( Infrason.Time) + ':'+Infrason.Commande_Result);
end;

function TfInfrason.FFT_Time( _i: Integer): Float;
begin
     Result:= FFT_Time_Start + _i * FFT_Time_Step;
end;

procedure TfInfrason.FFT_Init;
var
   I: Integer;
begin
     FFT_Size:= 512;
     FFT_Max:= FFT_Size-1;

     SetLength( Time           , FFT_Size);
     SetLength( Pressure       , FFT_Size);
     SetLength( Pressure_dv    , FFT_Size);
     SetLength( Pressure_Spline, FFT_Size);
     SetLength( cPressure      , FFT_Size);
     SetLength( cFFT_Pressure  , FFT_Size);
     SetLength( Frequency      , FFT_Size);
     SetLength( FFT_Pressure   , FFT_Size);
     SetLength( FFT_Pressure_Sum, FFT_Size);
     SetLength( rpvFFT         , FFT_Size);

     FFT_Index:= 0;
     for I:= 0 to FFT_Max
     do
       FFT_Pressure_Sum[I]:= 0;
end;

procedure TfInfrason.FFT_Add;
begin
     Time    [FFT_Index]:= Infrason.Time    ;
     Pressure[FFT_Index]:= Infrason.Pressure;
     Inc(FFT_Index);
     if FFT_Index = FFT_Size
     then
         begin
         FFT_Index:= 0;
         FFT_Traite;
         end;
end;

procedure TfInfrason.FFT_Traite;
var
   I: Integer;
   F, FFTP, FFTP_Sum: Float;
   iFMin, iFMax: Integer;
begin
     FFT_Time_Start:= Time[0];
     //FFT_Time_Step:= (Time[FFT_Max]-FFT_Time_Start)/FFT_Size;
     FFT_Time_Step:= 12;
     InitSpline( Time, Pressure, Pressure_dv, 0, FFT_Max);
     for I:= 0 to FFT_Max
     do
       Pressure_Spline[I]:= SplInt( FFT_Time( I), Time, Pressure, Pressure_dv, 0, FFT_Max);
     for I:= 0 to FFT_Max
     do
       with cPressure[I]
       do
         begin
         X:= Pressure_Spline[I];
         Y:= 0;
         end;

     FFT( FFT_Size, cPressure, cFFT_Pressure);

     for I:= 0 to FFT_Max
     do
       begin
       Frequency   [I]:= (I/FFT_Size)*(1000/FFT_Time_Step);
       with cFFT_Pressure[I] do FFT_Pressure[I]:= sqrt(X*X+Y*Y);
       end;
     FFT_Pressure_Min:= -1;
     FFT_Pressure_Max:= -1;
     FFT_Pressure_Sum_Min:= -1;
     FFT_Pressure_Sum_Max:= -1;
     iFMin:= 1;
     iFMax:= FFT_Max div 16;
     clsFFT.Clear;
     for I:= iFMin to iFMax
     do
       begin
       F:= Frequency   [I];
       FFTP:= FFT_Pressure[I];
       rpvFFT[I].X:= F;
       rpvFFT[I].Y:= FFTP;
       if (FFTP < FFT_Pressure_Min)or (-1 = FFT_Pressure_Min) then FFT_Pressure_Min:= FFTP;
       if (FFTP > FFT_Pressure_Max)then FFT_Pressure_Max:= FFTP;

       FFTP_Sum:= FFT_Pressure_Sum[I] + FFTP;
       FFT_Pressure_Sum[I]:= FFTP_Sum;
       if (FFTP_Sum < FFT_Pressure_Sum_Min)or (-1 = FFT_Pressure_Sum_Min) then FFT_Pressure_Sum_Min:= FFTP_Sum;
       if (FFTP_Sum > FFT_Pressure_Sum_Max)then FFT_Pressure_Sum_Max:= FFTP_Sum;

       clsFFT.AddXY( F, FFTP);
       //clsFFT.AddXY( F, FFTP_Sum);
       end;

     cs.MinX:= Frequency[iFMin];
     cs.MaxX:= Frequency[iFMax];
     cs.MinY:= FFT_Pressure_Min;
     cs.MaxY:= FFT_Pressure_Max;
end;

procedure TfInfrason.cbUse_PLUChange(Sender: TObject);
begin
     Infrason_Data_change;
end;

procedure TfInfrason.csDrawData(Sender: TObject);
begin
     cs.FastDraw( rpvFFT, 0, FFT_Max);
end;


end.



