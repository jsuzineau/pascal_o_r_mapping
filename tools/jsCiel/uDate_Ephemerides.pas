unit uDate_Ephemerides;

{$mode Delphi}

interface

// Calculs d'aprés le livre Astronomical Algorithms de Jean MEEUS
uses
    uPublieur,
    uuStrings,
    uDate,
 Classes, SysUtils, Math;

type
  { T_Date_Ephemerides }
  T_Date_Ephemerides
  =
   class(T_Date) // remarque: état initial à équinoxe J2000
   //Gestion du cycle de vie
   protected
     procedure Init; override;
   public
     destructor Destroy; override;
   //constructeur de copie
   public
     procedure Copy_From( _Date: T_Date);override;
   //Attributs
   protected
     FTau: Extended;
     FTjy: Extended;
     procedure Set_Tau( _Value: Extended);
     procedure Set_Tjy( _Value: Extended);
   public
     Date_Ephemerides_Modify: TPublieur;
     property Tau  : Extended read FTau write Set_Tau;
     property Tjy  : Extended read FTjy write Set_Tjy;
     procedure DateChange;
   end;

implementation

{ T_Date_Ephemerides }

procedure T_Date_Ephemerides.Init;
begin
     inherited;
     Date_Ephemerides_Modify:= TPublieur.Create(ClassName+'.Date_Ephemerides_Modify');
     FTau:= 0;
     FTjy:= 0;
end;

destructor T_Date_Ephemerides.Destroy;
begin
     Date_Ephemerides_Modify.Free; Date_Ephemerides_Modify:= nil;
     inherited Destroy;
end;

procedure T_Date_Ephemerides.Copy_From(_Date: T_Date);
var
   DE: T_Date_Ephemerides;
begin
     if _Date <> nil
     then
         begin
         inherited Copy_From( _Date);
         if _Date is T_Date_Ephemerides
         then
             begin
             DE:= _Date as T_Date_Ephemerides;
             FTau:= DE.FTau;
             FTjy:= DE.FTjy;
             end;
         end;
end;

procedure T_Date_Ephemerides.DateChange;
begin
     FTau:=(FJour_Julien-2451545.0)/36525;
     FTjy:= FTau / 10;
     Date_Ephemerides_Modify.Publie;
end;

procedure T_Date_Ephemerides.Set_Tau( _Value: Extended);
begin
     FTau:=_Value;
     FJour_Julien:= 2451545.0 + FTau * 36525;
     From_Jour_Julien;
end;

procedure T_Date_Ephemerides.Set_Tjy( _Value: Extended);
begin
     Set_Tau( _Value * 10);
end;

end.

