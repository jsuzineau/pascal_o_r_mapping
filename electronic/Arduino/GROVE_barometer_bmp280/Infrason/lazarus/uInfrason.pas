unit uInfrason;

{$mode objfpc}{$H+}

interface

uses
 uReels,
 uuStrings,
 uPublieur,
 Classes, SysUtils, LazSerial, stdctrls, Graphics;

type
{
TGROVE_barometer_bmp280_Value
 =
  class
    Temperature: ValReal;
    Pressure: ValReal;
  end;

  Temp: 21.70C
  Pressure: 100562.00Pa
  Pression corrigée 118 m Gagnac: 101980.42Pa
  Altitude: 63.71m

}
 TGROVE_barometer_bmp280_Callback= procedure of object;

 { TInfrason }

 TInfrason
 =
  class
  //Gestion du cycle de vie
  public
    constructor Create( _ls: TLazSerial; _mLog: TMemo);
    destructor Destroy; override;
  //Connection série
  private
    ls: TLazSerial;
    procedure lsRxData(Sender: TObject);
  //Arreter
  public
    Arreter: Boolean;
  //Tampon
  public
    Tampon: String;
  // Log
  private
    mLog: TMemo;
  //Commande
  private
    procedure Traite_Commande;
    procedure Traite_Mesure;
  public
    Commande_Result: String;
    Time: DWord;
    Pressure: ValReal;
    Pression_Gagnac: ValReal;
    Mesure_CallBack: TGROVE_barometer_bmp280_Callback;
  end;


implementation

{ TInfrason }

constructor TInfrason.Create(_ls: TLazSerial; _mLog: TMemo);
begin
     inherited Create;
     ls:= _ls;
     mLog:= _mLog;
     ls.OnRxData:= @lsRxData;
end;

destructor TInfrason.Destroy;
begin
     ls.OnRxData:= nil;
     inherited Destroy;
end;

procedure TInfrason.lsRxData(Sender: TObject);
var
   I: Integer;
  procedure delchar( _c: Char);
  var
     I: Integer;
  begin
       I:= Pos( _c, Commande_Result);
       if 0 = I then exit;
       Delete( Commande_Result, I, 1);
  end;
begin
     if Arreter then exit;
     Tampon:= Tampon+ls.ReadData;

     I:= Pos( #10, Tampon);
     if I = 0 then exit;

     Commande_Result:= StrToK( #10, Tampon);
     delchar(#13);
     Traite_Commande;
end;

procedure TInfrason.Traite_Commande;
begin
     Traite_Mesure;
end;

procedure TInfrason.Traite_Mesure;
var
   sTime, sPressure: String;
   Erreur: Integer;
begin
     sTime:= StrToK( ';', Commande_Result);
     sPressure:= Commande_Result;
     if not TryStrToDWord( sTime, Time) then Time:= 0;

     Val( Commande_Result, Pressure   , Erreur);
     //coef pression/altitude pour gagnac altitude 118m
     //>>> a=(1-(0.0065*118)/288.15)**5.255
     //>>> a
     //0.9860911829528476
     //Pression_Gagnac:=Pressure/0.9860911829528476;

     Mesure_CallBack;
end;


end.

