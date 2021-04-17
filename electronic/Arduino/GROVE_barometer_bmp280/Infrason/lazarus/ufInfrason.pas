unit ufInfrason;

{$mode objfpc}{$H+}

interface

uses
    uuStrings,
    uInfrason,
  Classes, SysUtils, FileUtil,  Forms, Controls,TAGraph, TASources, TASeries,
  Graphics, Dialogs, StdCtrls, ExtCtrls, ComCtrls, Serial, LazSerial, lazsynaser;

type
  { TfInfrason }

  TfInfrason = class(TForm)
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
   lDelta: TLabel;
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
  //Gestion boutons
  public
    procedure Boutons_Initialise;
    procedure Boutons_Finalise;
   //AS72651
   private
     Infrason: TInfrason;
     procedure GROVE_barometer_bmp280_Data_change;
     procedure AS72651_Command_Result_Log;
  end;

var
  fInfrason: TfInfrason;

implementation

{$R *.lfm}

{ TfInfrason }

procedure TfInfrason.FormCreate(Sender: TObject);
begin
     Infrason:= TInfrason.Create( ls, mLog);
     Infrason.Mesure_CallBack:= @GROVE_barometer_bmp280_Data_change;

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
     Infrason.Continuer:= True;
     clsPressure.Clear;

     ls.Open;
     Boutons_Initialise;
end;

procedure TfInfrason.bStopClick(Sender: TObject);
begin
     Infrason.Continuer:= False;
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

procedure TfInfrason.GROVE_barometer_bmp280_Data_change;
const
     _1_h = 1/24;
     _15_min = 15/(24*60);
var
   iDernier: Integer;
   Maintenant, Premier, Dernier, Delta: ValReal;
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
     //Delta:= (Maintenant-Dernier)*24*3600;

     //lDelta.Caption:= Format('%f',[Delta]);
     //lDelta.Caption:= Format('%f',[Frac(Maintenant)*24]);
     lDelta.Refresh;

     clsPressure.AddXY( Maintenant, Infrason.Pression_Gagnac/100, ' ');
     if iDernier > 250
     then
         clsPressure.Delete(0);
end;


procedure TfInfrason.AS72651_Command_Result_Log;
begin
     mLog.Lines.Add( Infrason.Commande_Result);
end;

procedure TfInfrason.cbUse_PLUChange(Sender: TObject);
begin
     GROVE_barometer_bmp280_Data_change;
end;


end.



