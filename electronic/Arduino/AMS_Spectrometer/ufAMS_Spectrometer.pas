unit ufAMS_Spectrometer;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil,  Forms, Controls,TAGraph, TASources, TASeries,
  Graphics, Dialogs, StdCtrls, ExtCtrls, ComCtrls, Serial, LazSerial, lazsynaser;

type

  { TfAMS_Spectrometer }

  TfAMS_Spectrometer = class(TForm)
    bDemarrer: TButton;
   bStop: TButton;
   bDemarrer_linux: TButton;
   bFermer: TButton;
   bParametres: TButton;
   c: TChart;
   cls: TLineSeries;
   ls: TLazSerial;
   m: TMemo;
   PageControl1: TPageControl;
   Panel1: TPanel;
   tsGraphe: TTabSheet;
   tsLog: TTabSheet;
   procedure bDemarrerClick(Sender: TObject);
   procedure bFermerClick(Sender: TObject);
   procedure bParametresClick(Sender: TObject);
   procedure bStopClick(Sender: TObject);
   procedure bDemarrer_linuxClick(Sender: TObject);
   procedure FormCreate(Sender: TObject);
   procedure lsRxData(Sender: TObject);
   procedure lsStatus(Sender: TObject; Reason: THookSerialReason;
     const Value: string);
   procedure Panel1Click(Sender: TObject);
  private
    Continuer: Boolean;
  public
    Start: TDateTime;
    procedure Ajoute_Valeur( _S: String);
  //Gestion boutons
  public
    procedure Boutons_Initialise;
    procedure Boutons_Finalise;
  //port serie
  public
    T: Text;
    sh: TSerialHandle;
    procedure Serie_initialise;
    function Serie_Readln:String;
    procedure Serie_Finalise;
  //version lazserial
  public
    Tampon: String;

  end;

var
  fAMS_Spectrometer: TfAMS_Spectrometer;

implementation

{$R *.lfm}

function StrToK( Key: String; var S: String): String;
var
   I: Integer;
begin
     I:= Pos( Key, S);
     if I = 0
     then
         begin
         Result:= S;
         S:= '';
         end
     else
         begin
         Result:= Copy( S, 1, I-1);
         Delete( S, 1, (I-1)+Length( Key));
         end;
end;

{ TfAMS_Spectrometer }

procedure TfAMS_Spectrometer.bDemarrer_linuxClick(Sender: TObject);
var
   S: String;
begin
     Boutons_Initialise;
     Serie_initialise;
     try
        Continuer:= True;
        cls.Clear;
        Start:= Now;
        while Continuer
        do
          begin
          S:= Serie_Readln;
          if S <> ''
          then
              Ajoute_Valeur( S);
          Application.ProcessMessages;
          end;
     finally
            Boutons_Finalise;
            Serie_Finalise;
            end;
end;

procedure TfAMS_Spectrometer.bStopClick(Sender: TObject);
begin
     Continuer:= False;
     bStop.Hide;
     if ls.Active
     then
         begin
         ls.Close;
         Boutons_Finalise;
         bDemarrer_linux.Hide;
         end;
end;

procedure TfAMS_Spectrometer.bFermerClick(Sender: TObject);
begin
     Application.Terminate;
end;

procedure TfAMS_Spectrometer.bParametresClick(Sender: TObject);
begin
     ls.ShowSetupDialog;
end;

procedure TfAMS_Spectrometer.bDemarrerClick(Sender: TObject);
begin
     Continuer:= True;
     cls.Clear;
     Start:= Now;

     Tampon:= '';
     ls.Open;
     Boutons_Initialise;
end;

procedure TfAMS_Spectrometer.FormCreate(Sender: TObject);
begin
     bStop.Hide;
end;

procedure TfAMS_Spectrometer.lsRxData(Sender: TObject);
var
   S: String;
   I: Integer;
  procedure delchar( _c: Char);
  var
     I: Integer;
  begin
       I:= Pos( _c, S);
       if 0 = I then exit;
       Delete( S, I, 1);
  end;
begin
     Tampon:= Tampon+ls.ReadData;
     if not Continuer then ls.Close;

     I:= Pos( #10, Tampon);
     if I = 0 then exit;

     S:= StrToK( #10, Tampon);
     delchar(#13);
     Ajoute_Valeur( S);
end;

procedure TfAMS_Spectrometer.lsStatus(Sender: TObject;Reason: THookSerialReason; const Value: string);
begin

end;

procedure TfAMS_Spectrometer.Panel1Click(Sender: TObject);
begin

end;

procedure TfAMS_Spectrometer.Ajoute_Valeur(_S: String);
var
   I: Integer;
   Secondes: double;
   sSecondes: String;
begin
     Secondes:= (Now-Start)*24*3600;
     sSecondes:= IntToStr( Trunc(Secondes));
     while Length(sSecondes)<4 do sSecondes:= ' '+sSecondes;
     m.Lines.Add( sSecondes+' s:'+_S);
     if TryStrToInt( _S, I)
     then
         if (I>30) and (I<200)
         then
             begin
             cls.AddXY( Secondes, I);
             if cls.Count > 50 then cls.Delete(0);
             end;
end;

procedure TfAMS_Spectrometer.Boutons_Initialise;
begin
     bDemarrer_linux.Hide;
     bDemarrer.Hide;
     bStop.Show;
     bFermer.Hide;
end;

procedure TfAMS_Spectrometer.Boutons_Finalise;
begin
     bDemarrer_linux.Show;
     bDemarrer.Show;
     bFermer.Show;
end;

procedure TfAMS_Spectrometer.Serie_initialise;
begin
     //AssignFile( T, '/dev/ttyUSB0');
     //Reset( T);
     sh:= SerOpen( 'COM3:');
     //d'aprés documentation Arduino Serial.begin
     SerSetParams(  sh, 9600, 8, NoneParity, 1, []);
end;

function TfAMS_Spectrometer.Serie_Readln: String;
   function Do_Read: String;
   var
      L: Integer;
   begin
        //Readln( T, Result);
        L:= 1024;
        SetLength( Result, L);
        L:= SerRead( sh, Result[1], L);
        SetLength( Result, L);
        Application.ProcessMessages;
   end;
   procedure delchar( _c: Char);
   var
      I: Integer;
   begin
        I:= Pos( _c, Result);
        if 0 = I then exit;
        Delete( Result, I, 1);
   end;
begin
     Result:= '';
     repeat
           Result:= Result + Do_Read;
     until (0 <> Pos(#10, Result)) or  not Continuer;
     delchar( #13);
     delchar( #10);
end;

procedure TfAMS_Spectrometer.Serie_Finalise;
begin
     //CloseFile( T);
     SerClose( sh);
end;

end.

