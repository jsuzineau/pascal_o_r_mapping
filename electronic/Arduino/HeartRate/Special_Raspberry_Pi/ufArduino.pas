unit ufArduino;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, TAGraph, TASources, TASeries, Forms, Controls,
  Graphics, Dialogs, StdCtrls, ExtCtrls, ComCtrls, Serial, LazSerial, synaser;

type

  { TfArduino }

  TfArduino = class(TForm)
    bDemarrer: TButton;
   bStop: TButton;
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
   procedure FormCreate(Sender: TObject);
   procedure lsRxData( Sender: TObject);
   procedure lsStatus( Sender: TObject; Reason: THookSerialReason; const Value: string);
   procedure Panel1Click(Sender: TObject);
  private
    Continuer: Boolean;
  public
    Start: TDateTime;
    procedure Ajoute_Valeur( _sPouls: String);
  //Gestion boutons
  public
    procedure Boutons_Initialise;
    procedure Boutons_Finalise;
  //version lazserial
  public
    Tampon: String;

  end;

var
  fArduino: TfArduino;

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

{ TfArduino }

procedure TfArduino.bStopClick(Sender: TObject);
begin
     Continuer:= False;
     bStop.Hide;
     if ls.Active
     then
         begin
         ls.Close;
         Boutons_Finalise;
         end;
end;

procedure TfArduino.bFermerClick(Sender: TObject);
begin
     Application.Terminate;
end;

procedure TfArduino.bParametresClick(Sender: TObject);
begin
     ls.ShowSetupDialog;
end;

procedure TfArduino.bDemarrerClick(Sender: TObject);
begin
     Continuer:= True;
     cls.Clear;
     Start:= Now;

     Tampon:= '';
     ls.Open;
     Boutons_Initialise;
end;

procedure TfArduino.FormCreate(Sender: TObject);
begin
     bStop.Hide;
end;

procedure TfArduino.lsRxData(Sender: TObject);
var
   sPouls: String;
   I: Integer;
  procedure delchar( _c: Char);
  var
     I: Integer;
  begin
       I:= Pos( _c, sPouls);
       if 0 = I then exit;
       Delete( sPouls, I, 1);
  end;
begin
     Tampon:= Tampon+ls.ReadData;
     if not Continuer then ls.Close;

     I:= Pos( #10, Tampon);
     if I = 0 then exit;

     sPouls:= StrToK( #10, Tampon);
     delchar(#13);
     Ajoute_Valeur( sPouls);
end;

procedure TfArduino.lsStatus(Sender: TObject;Reason: THookSerialReason; const Value: string);
begin

end;

procedure TfArduino.Panel1Click(Sender: TObject);
begin

end;

procedure TfArduino.Ajoute_Valeur(_sPouls: String);
var
   iPouls: Integer;
   Secondes: double;
   sSecondes: String;
begin
     Secondes:= (Now-Start)*24*3600;
     sSecondes:= IntToStr( Trunc(Secondes));
     while Length(sSecondes)<4 do sSecondes:= ' '+sSecondes;
     m.Lines.Add( sSecondes+' Pouls:'+_sPouls);
     if TryStrToInt( _sPouls, iPouls)
     then
         if (iPouls>30) and (iPouls<200)
         then
             begin
             cls.AddXY( Secondes, iPouls);
             if cls.Count > 50 then cls.Delete(0);
             end;
end;

procedure TfArduino.Boutons_Initialise;
begin
     bDemarrer.Hide;
     bStop.Show;
     bFermer.Hide;
end;

procedure TfArduino.Boutons_Finalise;
begin
     bDemarrer.Show;
     bFermer.Show;
end;

end.

