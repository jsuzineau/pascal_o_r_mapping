unit ufGROVE_barometer_bmp280;

{$mode objfpc}{$H+}

interface

uses
    uuStrings,
    uDataUtilsU,
    udmDatabase,
    uGROVE_barometer_bmp280,
    ublMesure,
    upoolMesure,
    Classes, SysUtils, FileUtil, Forms, Controls, TAGraph,
    TASources, TASeries, Graphics, Dialogs, StdCtrls, ExtCtrls, ComCtrls, Spin,
    Serial, LazSerial, lazsynaser, TAChartAxisUtils, TAIntervalSources;

type
  { TfGROVE_barometer_bmp280 }

  TfGROVE_barometer_bmp280 = class(TForm)
    bDemarrer: TButton;
   bStop: TButton;
   bFermer: TButton;
   bParametres: TButton;
   b48h: TButton;
   b24h: TButton;
   bPeriode: TButton;
   bTout: TButton;
   c: TChart;
   clsPressure: TLineSeries;
   dtics: TDateTimeIntervalChartSource;
   Label1: TLabel;
   ls: TLazSerial;
   mLog: TMemo;
   PageControl1: TPageControl;
   Panel1: TPanel;
   seHeures: TSpinEdit;
   tsGraphe: TTabSheet;
   tsLog: TTabSheet;
   procedure b24hClick(Sender: TObject);
   procedure b48hClick(Sender: TObject);
   procedure bPeriodeClick(Sender: TObject);
   procedure bToutClick(Sender: TObject);
   procedure cAxisList1MarkToText(var AText: String; AMark: Double);
   procedure FormCreate(Sender: TObject);
   procedure bDemarrerClick(Sender: TObject);
   procedure bFermerClick(Sender: TObject);
   procedure bParametresClick(Sender: TObject);
   procedure bStopClick(Sender: TObject);
   procedure FormDestroy(Sender: TObject);
  public
    constructor Create(TheOwner: TComponent); override;
  //Gestion boutons
  public
    procedure Boutons_Initialise;
    procedure Boutons_Finalise;
  //AS72651
  private
    GROVE_barometer_bmp280: TGROVE_barometer_bmp280;
    procedure GROVE_barometer_bmp280_Data_change;
    procedure AS72651_Command_Result_Log;
  //attributs
  private
    slMesure: TslMesure;
    Premier, Dernier: TDateTime;
    procedure Charge_24h;
    procedure Charge_48h;
    procedure Charge_Tout;
  //Chargement d'une période
  private
    procedure Charge;
  public
    procedure Charge_Periode( _Debut, _Fin: TDatetime);
  end;

var
  fGROVE_barometer_bmp280: TfGROVE_barometer_bmp280;

implementation

{$R *.lfm}

{ TfGROVE_barometer_bmp280 }

constructor TfGROVE_barometer_bmp280.Create(TheOwner: TComponent);
begin
     inherited Create(TheOwner);
     slMesure:= TslMesure.Create( ClassName+'.sl24h');

     dmDatabase.Ouvre_db;
end;

procedure TfGROVE_barometer_bmp280.FormCreate(Sender: TObject);
begin
     GROVE_barometer_bmp280:= TGROVE_barometer_bmp280.Create( ls, mLog);
     GROVE_barometer_bmp280.Mesure_CallBack:= @GROVE_barometer_bmp280_Data_change;

     bStop.Hide;
     {$IFDEF LINUX}
     ls.Device:= '/dev/ttyUSB0';
     {$ENDIF}
     c.AxisList.Axes[1].Intervals.NiceSteps:= FloatToStr( 0.25/24);
end;

procedure TfGROVE_barometer_bmp280.FormDestroy(Sender: TObject);
begin
     FreeAndNil( GROVE_barometer_bmp280);
     FreeAndNil( slMesure);
     dmDatabase.Ferme_db;
end;

procedure TfGROVE_barometer_bmp280.Charge;
var
   I: TIterateur_Mesure;
   bl: TblMesure;
   dTemps: TDateTime;
begin
     clsPressure.Clear;
     I:= slMesure.Iterateur;
     while I.Continuer
     do
       begin
       if I.not_Suivant( bl) then continue;

       dTemps:= bl.dTemps;
       if 0 = dTemps then continue;

       clsPressure.AddXY( dTemps, bl.pression);
       end;
end;

procedure TfGROVE_barometer_bmp280.Charge_Tout;
begin
     poolMesure.ToutCharger( slMesure);
     Charge;
end;

procedure TfGROVE_barometer_bmp280.Charge_Periode(_Debut, _Fin: TDatetime);
begin
     poolMesure.Charge_Periode( _Debut, _Fin, slMesure);
     Charge;
end;

procedure TfGROVE_barometer_bmp280.Charge_24h;
begin
     Charge_Periode( Now-1, Now);
end;

procedure TfGROVE_barometer_bmp280.Charge_48h;
begin
     Charge_Periode( Now-2, Now);
end;

procedure TfGROVE_barometer_bmp280.bParametresClick(Sender: TObject);
begin
     ls.ShowSetupDialog;
end;

procedure TfGROVE_barometer_bmp280.Boutons_Initialise;
begin
     bDemarrer.Hide;
     bStop.Show;
     bFermer.Hide;
end;

procedure TfGROVE_barometer_bmp280.Boutons_Finalise;
begin
     bDemarrer.Show;
     bFermer.Show;
end;

procedure TfGROVE_barometer_bmp280.bDemarrerClick(Sender: TObject);
begin
     GROVE_barometer_bmp280.Continuer:= True;
     clsPressure.Clear;
     Charge_48h;

     ls.Open;
     Boutons_Initialise;
end;

procedure TfGROVE_barometer_bmp280.bStopClick(Sender: TObject);
begin
     GROVE_barometer_bmp280.Continuer:= False;
     bStop.Hide;
     if ls.Active
     then
         begin
         ls.Close;
         Boutons_Finalise;
         end;
end;

procedure TfGROVE_barometer_bmp280.bFermerClick(Sender: TObject);
begin
     Application.Terminate;
end;

procedure TfGROVE_barometer_bmp280.GROVE_barometer_bmp280_Data_change;
const
     _1_h = 1/24;
     _15_min = 15/(24*60);
     _5_min = 5/(24*60);
var
   iDernier: Integer;
   Maintenant: TDateTime;
   Pression_hPa: double;
begin
     AS72651_Command_Result_Log;

     Maintenant:= Now;
     iDernier:= clsPressure.Count-1;
     if iDernier < 0
     then
         begin
         Premier:= Maintenant;
         Dernier:= Maintenant-1;
         end
     else
         begin
         Premier:= clsPressure.GetXValue(0);
         Dernier:= clsPressure.GetXValue(iDernier);
         end;
     if (Maintenant - Dernier > _5_min)or (iDernier< 3)
     then
         begin
         Pression_hPa:= GROVE_barometer_bmp280.Pression_Gagnac/100;
         poolMesure.Ajoute( DateTimeSQL_sans_quotes(Maintenant), Pression_hPa);
         clsPressure.AddXY( Maintenant, Pression_hPa, ' ');
         if Maintenant-Premier > 2 // jour
         then
             clsPressure.Delete(0);
         end;
end;


procedure TfGROVE_barometer_bmp280.AS72651_Command_Result_Log;
begin
     mLog.Lines.Add( GROVE_barometer_bmp280.slResult.Text);
end;

procedure TfGROVE_barometer_bmp280.cAxisList1MarkToText(var AText: String; AMark: Double);
var
   DateRange: ValReal;
begin
     DateRange:= Dernier - Premier;
     AText:= FormatDateTime('hh:nn',AMark);
     if 3 = Pos( ':00', AText) then Delete( AText, 3, 3);
     if 1 = Pos( '0'  , AText) then Delete( AText, 1, 1);
     if 1 < DateRange
     then
         AText:= Lettre_from_DateTime( AMark)+AText;
end;

procedure TfGROVE_barometer_bmp280.b48hClick(Sender: TObject);
begin
     Charge_48h;
end;

procedure TfGROVE_barometer_bmp280.b24hClick(Sender: TObject);
begin
     Charge_24h;
end;

procedure TfGROVE_barometer_bmp280.bPeriodeClick(Sender: TObject);
begin
     Charge_Periode(Now-seHeures.Value/24, Now);
end;

procedure TfGROVE_barometer_bmp280.bToutClick(Sender: TObject);
begin
     Charge_Tout;
end;


end.



