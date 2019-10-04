unit ufAMS_Spectrometer;

{$mode objfpc}{$H+}

interface

uses
    uuStrings,
    uAMS_AS7265x,
  Classes, SysUtils, FileUtil,  Forms, Controls,TAGraph, TASources, TASeries,
  Graphics, Dialogs, StdCtrls, ExtCtrls, ComCtrls, Serial, LazSerial, lazsynaser;

type
  { TfAMS_Spectrometer }

  TfAMS_Spectrometer = class(TForm)
   bATDATA: TButton;
   bATINTTIME_255: TButton;
   bATTEMP: TButton;
   bATVERHW: TButton;
    bDemarrer: TButton;
   bStop: TButton;
   bFermer: TButton;
   bParametres: TButton;
   bATCDATA: TButton;
   bATVERSW: TButton;
   bEnvoyer: TButton;
   bPLU_from_Courant: TButton;
   c: TChart;
   cbs: TBarSeries;
   cbUse_PLU: TCheckBox;
   cls: TLineSeries;
   eCommande: TEdit;
   Label1: TLabel;
   ls: TLazSerial;
   mLog: TMemo;
   PageControl1: TPageControl;
   Panel1: TPanel;
   tsGraphe: TTabSheet;
   tsLog: TTabSheet;
   procedure bATCDATAClick(Sender: TObject);
   procedure bATDATAClick(Sender: TObject);
   procedure bATINTTIME_255Click(Sender: TObject);
   procedure bATTEMPClick(Sender: TObject);
   procedure bATVERHWClick(Sender: TObject);
   procedure bATVERSWClick(Sender: TObject);
   procedure bEnvoyerClick(Sender: TObject);
   procedure bPLU_from_CourantClick(Sender: TObject);
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
     AS72651: TAS72651;
     procedure AS72651_Data_change;
     procedure AS72651_Command_Result_Log;
  end;

var
  fAMS_Spectrometer: TfAMS_Spectrometer;

implementation

{$R *.lfm}

{ TfAMS_Spectrometer }

procedure TfAMS_Spectrometer.FormCreate(Sender: TObject);
begin
     mLog.Lines.Add( uAMS_AS7265x_Verifie_constantes);

     AS72651:= TAS72651.Create( ls, mLog);

     bStop.Hide;
     {$IFDEF LINUX}
     ls.Device:= '/dev/ttyUSB0';
     {$ENDIF}
end;

procedure TfAMS_Spectrometer.FormDestroy(Sender: TObject);
begin
     FreeAndNil( AS72651);
end;

procedure TfAMS_Spectrometer.bParametresClick(Sender: TObject);
begin
     ls.ShowSetupDialog;
end;

procedure TfAMS_Spectrometer.Boutons_Initialise;
begin
     bDemarrer.Hide;
     bStop.Show;
     bFermer.Hide;
end;

procedure TfAMS_Spectrometer.Boutons_Finalise;
begin
     bDemarrer.Show;
     bFermer.Show;
end;

procedure TfAMS_Spectrometer.bDemarrerClick(Sender: TObject);
begin
     AS72651.Continuer:= True;
     cls.Clear;

     ls.Open;
     Boutons_Initialise;
end;

procedure TfAMS_Spectrometer.bStopClick(Sender: TObject);
begin
     AS72651.Continuer:= False;
     bStop.Hide;
     if ls.Active
     then
         begin
         ls.Close;
         Boutons_Finalise;
         end;
end;

procedure TfAMS_Spectrometer.bFermerClick(Sender: TObject);
begin
     Application.Terminate;
end;

procedure TfAMS_Spectrometer.bATCDATAClick(Sender: TObject);
begin
     bATCDATA.Enabled:= False;
     AS72651.ATCDATA( @AS72651_Data_change);
end;

procedure TfAMS_Spectrometer.bATDATAClick(Sender: TObject);
begin
     //bATDATA.Enabled:= False;
     AS72651.ATDATA( @AS72651_Data_change);
end;

procedure TfAMS_Spectrometer.AS72651_Data_change;
var
   Data: TAS7265x_ATCDATA_Result;
   I: Integer;
   lo: Integer;
   Valeur: double;
begin
     if AS72651.ATCDATA_Result_Invalid then exit;

     if cbUse_PLU.Checked
     then
         begin
         AS72651.Corrige;
         Data:= AS72651.ATCDATA_Result_Corrige_PLU;
         end
     else
         Data:= AS72651.ATCDATA_Result;
     cls.Clear;
     cbs.Clear;

     for I:= Low(Data) to High(Data)
     do
       begin
       Valeur:= Data[I];
       if Valeur > 0
       then
           begin
           lo:= longueurs_onde[I];
           //cls.AddXY( lo, Valeur, IntToStr(lo));
           cbs.AddXY( lo, Valeur, IntToStr(lo), Couleurs[I]);
           end;
       end;
     bATCDATA.Enabled:= True;
end;

procedure TfAMS_Spectrometer.bATVERSWClick(Sender: TObject);
begin
     AS72651.Commande( 'ATVERSW', @AS72651_Command_Result_Log);
end;

procedure TfAMS_Spectrometer.bATTEMPClick(Sender: TObject);
begin
     AS72651.Commande( 'ATTEMP', @AS72651_Command_Result_Log);
end;

procedure TfAMS_Spectrometer.bATVERHWClick(Sender: TObject);
begin
     AS72651.Commande( 'ATVERHW', @AS72651_Command_Result_Log);
end;

procedure TfAMS_Spectrometer.bEnvoyerClick(Sender: TObject);
begin
     AS72651.Commande( eCommande.Text, @AS72651_Command_Result_Log);
end;

procedure TfAMS_Spectrometer.bPLU_from_CourantClick(Sender: TObject);
begin
     AS72651.PLU_from_Courant;
end;

procedure TfAMS_Spectrometer.bATINTTIME_255Click(Sender: TObject);
begin
     AS72651.Commande( 'ATINTTIME=255', @AS72651_Command_Result_Log);
end;

procedure TfAMS_Spectrometer.AS72651_Command_Result_Log;
begin
     mLog.Lines.Add( AS72651.Commande_Result);
end;

procedure TfAMS_Spectrometer.cbUse_PLUChange(Sender: TObject);
begin
     AS72651_Data_change;
end;


end.



