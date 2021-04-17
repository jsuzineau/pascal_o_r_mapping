unit ufGROVE_barometer_bmp280;

{$mode objfpc}{$H+}

interface

uses
    uuStrings,
    uDataUtilsU,
    udmDatabase,
    uGROVE_barometer_bmp280,
    upoolMesure,
  Classes, SysUtils, FileUtil,  Forms, Controls,TAGraph, TASources, TASeries,
  Graphics, Dialogs, StdCtrls, ExtCtrls, ComCtrls, Serial, LazSerial, lazsynaser;

type
  { TfGROVE_barometer_bmp280 }

  TfGROVE_barometer_bmp280 = class(TForm)
    bDemarrer: TButton;
   bStop: TButton;
   bFermer: TButton;
   bParametres: TButton;
   bPLU_from_Courant: TButton;
   cbUse_PLU: TCheckBox;
   c: TChart;
   clsPressure: TLineSeries;
   eCommande: TEdit;
   Label1: TLabel;
   ls: TLazSerial;
   mLog: TMemo;
   PageControl1: TPageControl;
   Panel1: TPanel;
   tsGraphe: TTabSheet;
   tsLog: TTabSheet;
   procedure cbUse_PLUChange(Sender: TObject);
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
  end;

var
  fGROVE_barometer_bmp280: TfGROVE_barometer_bmp280;

implementation

{$R *.lfm}

{ TfGROVE_barometer_bmp280 }

constructor TfGROVE_barometer_bmp280.Create(TheOwner: TComponent);
begin
     inherited Create(TheOwner);
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
end;

procedure TfGROVE_barometer_bmp280.FormDestroy(Sender: TObject);
begin
     FreeAndNil( GROVE_barometer_bmp280);
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
var
   iDernier: Integer;
   Maintenant, Premier, Dernier: ValReal;
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
     if (Maintenant - Dernier > _15_min)or (iDernier< 3)
     then
         begin
         Pression_hPa:= GROVE_barometer_bmp280.Pression_Gagnac/100;
         poolMesure.Ajoute( DateTimeSQL_sans_quotes(Maintenant), Pression_hPa);
         clsPressure.AddXY( Maintenant, Pression_hPa, ' ');
         if Maintenant-Premier > 1 // jour
         then
             clsPressure.Delete(0);
         end;
end;


procedure TfGROVE_barometer_bmp280.AS72651_Command_Result_Log;
begin
     mLog.Lines.Add( GROVE_barometer_bmp280.slResult.Text);
end;

procedure TfGROVE_barometer_bmp280.cbUse_PLUChange(Sender: TObject);
begin
     GROVE_barometer_bmp280_Data_change;
end;


end.



