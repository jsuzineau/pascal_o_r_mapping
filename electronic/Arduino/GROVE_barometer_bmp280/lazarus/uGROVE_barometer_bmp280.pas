unit uGROVE_barometer_bmp280;

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

 { TGROVE_barometer_bmp280 }

 TGROVE_barometer_bmp280
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
  //Continuer
  public
    Continuer: Boolean;
  //Tampon
  public
    Tampon: String;
  // Log
  private
    mLog: TMemo;
  //Commande
  private
    Commande_Result: String;
    procedure Traite_Commande;
    procedure Traite_Mesure;
  public
    slResult: TStringList;
    Temperature: ValReal;
    Pressure: ValReal;
    Pression_Gagnac: ValReal;
    Mesure_CallBack: TGROVE_barometer_bmp280_Callback;
  end;


implementation

{ TGROVE_barometer_bmp280 }

constructor TGROVE_barometer_bmp280.Create(_ls: TLazSerial; _mLog: TMemo);
begin
     inherited Create;
     slResult:= TStringList.Create;
     ls:= _ls;
     mLog:= _mLog;
     ls.OnRxData:= @lsRxData;
end;

destructor TGROVE_barometer_bmp280.Destroy;
begin
     ls.OnRxData:= nil;
     FreeAndNil( slResult);
     inherited Destroy;
end;

procedure TGROVE_barometer_bmp280.lsRxData(Sender: TObject);
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
     Tampon:= Tampon+ls.ReadData;
     if not Continuer then ls.Close;

     I:= Pos( #10, Tampon);
     if I = 0 then exit;

     Commande_Result:= StrToK( #10, Tampon);
     delchar(#13);
     Traite_Commande;
end;

procedure TGROVE_barometer_bmp280.Traite_Commande;
begin
     if '#' = Commande_Result
     then
         begin
         Traite_Mesure;
         slResult.Clear;
         end
     else
         slResult.Add( Commande_Result);

end;

procedure TGROVE_barometer_bmp280.Traite_Mesure;
var
   Erreur: Integer;
begin
     Val( slResult.Values['Temperature'], Temperature, Erreur);
     Val( slResult.Values['Pressure'   ], Pressure   , Erreur);
     //coef pression/altitude pour gagnac altitude 118m
     //>>> a=(1-(0.0065*118)/288.15)**5.255
     //>>> a
     //0.9860911829528476
     Pression_Gagnac:=Pressure/0.9860911829528476;

     Mesure_CallBack;
end;


end.

