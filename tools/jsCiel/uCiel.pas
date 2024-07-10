unit uCiel;

{$mode Delphi}

interface

uses
    uPublieur,
    uObservation,

 Classes, SysUtils;

type
  { TCiel }
  TCiel
  =
   class
   //Gestion du cycle de vie
   public
     constructor Create;
     destructor Destroy; override;
   //Attributs
   private
     inCalcul: Boolean;
   public
     Observation: TObservation;
     Modify: TPublieur;
     procedure Initialise( _Latitude, _Longitude: Extended);
     procedure Calcul;
     procedure Log(_Prefix: String);
   end;


implementation

constructor TCiel.Create;
begin
     Observation:= TObservation.Create;
     inCalcul:= False;
     Modify:= TPublieur.Create( ClassName+'.Modify');
end;

destructor TCiel.Destroy;
begin
     FreeAndNil( Modify);
     inherited;
end;

procedure TCiel.Initialise(_Latitude, _Longitude: Extended);
begin
     if inCalcul then exit;
     inCalcul:= True;
     try
        Observation.Lieu.Debut_Edition;
        Observation.Lieu.La.Degres:= _Latitude;
        Observation.Lieu.Lg.Degres:= _Longitude;
        Observation.Lieu.Fin_Edition;

        Observation.Temps.HeureEte:= True;
        Observation.Temps.TU.Set_from_computer_date;
     finally
            inCalcul:= False;
            end;
     Calcul;
end;

procedure TCiel.Calcul;
begin
     if inCalcul then exit;
     inCalcul:= True;
     try
        Observation.Calcul;
        //SSol.Calcul;
     finally
            inCalcul:= False;
            end;
     Modify.Publie;
end;

procedure TCiel.Log(_Prefix: String);
begin
     Observation.Log(_Prefix+' Observation: ');
end;

end.

