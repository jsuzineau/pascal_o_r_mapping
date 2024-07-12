unit uObservation;

{$mode Delphi}

interface

// Calculs d'aprés le livre Astronomical Algorithms de Jean MEEUS
uses
    uPublieur,
    uuStrings,
    uCoordonnee,
    uLieu,
    uDate,
    uDate_Ephemerides,
    uTemps,
    uEquinoxeur,
 Classes, SysUtils, Math;

type
  { TObservation }

  TObservation
  =
   class
   //Gestion du cycle de vie
   public
     constructor Create;
     destructor Destroy; override;
   //constructeur de copie
   public
     constructor Create_From( _Observation: TObservation);
     procedure Copy_From( _Observation: TObservation);
   //Attributs
   public
     EquinoxeCourant : Boolean;
     Lieu: TLieu;
     Temps: T_Temps;
     procedure Log(_Prefix: String);
   private {Ceci empêche de modifier directement les champs sans mise à jour}
           {globale, ce qui peut être source de bogues difficiles à déceler.}
           {ce qui suit dans cette déclaration n"est accessible que dans les}
           { routines de cette unité.(=déclaration en partie IMPLEMENTATION.}
     FTemps_sideral_en_radians: Real;
     FTemps_sideral_en_heures: String;
     function GetLegale_Civile: String;
     function GetEquinoxe: String;
     procedure Temps_Change;
     procedure LieuChange;
     procedure Init;
   public
     EquinoxeCourant_Vers_J2000, J2000_Vers_EquinoxeCourant:
       TEquinoxeur;
     DeltaJ2000: Extended;
     Modify: TPublieur;
     property Temps_sideral_en_radians  : Real   read FTemps_sideral_en_radians;
     property Temps_sideral_en_heures: String read FTemps_sideral_en_heures;
     property LegCiv: String read GetLegale_Civile; {"Légale" ou "Civile"}
     property Equinoxe: String read GetEquinoxe;

     procedure Calcul;{TSid20} virtual;
     function GetHeureLocale: String;
   end;

function ZeroSigne( signe, valeur: Integer): String;

implementation

function ZeroSigne( signe, valeur: Integer): String;
begin
     if signe < 0
     then
         Result:= '-'
     else
         Result:= '+';
     Result:= Result+IntToStr(valeur);
end;

{ TObservation }

constructor TObservation.Create;
begin
     inherited;
     Init;
end;

destructor TObservation.Destroy;
begin
     Lieu          .ModifyCoordonnees.Desabonne( Self,    LieuChange);
     Temps         .Modify           .Desabonne( Self,  Temps_Change);

     FreeAndNil( EquinoxeCourant_Vers_J2000);
     FreeAndNil( J2000_Vers_EquinoxeCourant);
     FreeAndNil( Temps                     );
     FreeAndNil( Lieu                      );
     FreeAndNil( Modify                    );
     inherited;
end;

procedure TObservation.Init;
begin
     Lieu:= TLieu.Create;
     Lieu.Decalage_Heure_Locale:= 1;
     Lieu.Decalage_Heure_Ete   := 1;

     Temps:= T_Temps.Create( Lieu, Lieu);

     Modify:= TPublieur.Create(ClassName+'.Modify');

     Lieu          .ModifyCoordonnees.Abonne( Self,   LieuChange);
     Temps         .Modify           .Abonne( Self, Temps_Change);

     EquinoxeCourant_Vers_J2000:= TEquinoxeur.Create;
     J2000_Vers_EquinoxeCourant:= TEquinoxeur.Create;
     EquinoxeCourant:= False;
end;

constructor TObservation.Create_From( _Observation: TObservation);
begin
     inherited Create;
     Init;

     Copy_from( _Observation);
end;

procedure TObservation.Copy_From( _Observation: TObservation);
begin
     if _Observation <> NIL
     then
         begin
         Temps.Copy_from( _Observation.Temps);
         Lieu.Copy_from( _Observation.Lieu);
         FTemps_sideral_en_radians  := _Observation.FTemps_sideral_en_radians;
         FTemps_sideral_en_heures:= _Observation.FTemps_sideral_en_heures;
         end;
end;


procedure TObservation.Calcul;
{ _A_s_t_r_o_n_o_m_i_c_a_l_ A_l_g_o_r_i_t_h_m_s_, Jean MEEUS, }
{ p 83                                                        }
var
   t0,tsh : Real;
   hh,mm  : Real;
   hhs,mms: String;
begin
     //WriteLn( ClassName+'.Calcul Tau: ',Format('%.10f',[Temps.TD.Tau]));
     //WriteLn( ClassName+'.Calcul Fraction_Jour: ',Format('%.10f',[Temps.TD.Fraction_Jour]));
     //WriteLn( ClassName+'.Calcul Longitude: ',Format('%.10f',[Lieu.lg.Radians]));
     //calcule le temps sidéral en radians à partir de Siecle_Julien et de Fraction_Jour
     //pour une longitude lg; fournit aussi une chaîne HH:MM:SS
     t0:=Temps.TD.Tau-Temps.TD.Fraction_Jour/36525;
     //WriteLn( ClassName+'.Calcul t0: ',Format('%.10f',[t0]));
     FTemps_sideral_en_radians:=1.753368558+628.3319706*t0+6.771E-06*t0*t0;
     //WriteLn( ClassName+'.Calcul intermédiaire 1: ',Format('%.10f',[FTemps_sideral_en_radians]));
     //FTemps_sideral_en_radians:= FTemps_sideral_en_radians+
     //                                    Temps.TD.fj*1.002733791  *2*pi-Lieu.lg.Radians;
     FTemps_sideral_en_radians:= FTemps_sideral_en_radians+
                                Temps.TD.Fraction_Jour*1.00273790935*2*pi-Lieu.lg.Radians;
     //WriteLn( ClassName+'.Calcul intermédiaire 2: ',Format('%.10f',[FTemps_sideral_en_radians]));
     //                       re MEEUS p83: 1.00273790935
     FTemps_sideral_en_radians:=frac(FTemps_sideral_en_radians/2/pi)*2*pi;
     //WriteLn( ClassName+'.Calcul intermédiaire 3: ',Format('%.10f',[FTemps_sideral_en_radians]));
     if FTemps_sideral_en_radians < 0
     then
         FTemps_sideral_en_radians:= FTemps_sideral_en_radians + 2*pi;
     tsh:=FTemps_sideral_en_radians*12/pi;

     hh:=int(tsh);
     str(hh:2:0,hhs);
     if hhs[1]=' ' then hhs[1]:='0';
     mm:=int((tsh-hh)*60);
     str(mm:2:0,mms);
     if mms[1]=' ' then mms[1]:='0';

     FTemps_sideral_en_heures:= hhs+':'+mms;

     EquinoxeCourant_Vers_J2000.Initialise( Temps.TD.Jour_Julien, JourJulienJ2000);
     J2000_Vers_EquinoxeCourant.Initialise( JourJulienJ2000, Temps.TD.Jour_Julien);

     DeltaJ2000:= (Temps.TD.Jour_Julien-JourJulienJ2000)/ NbJoursParAnneeJulienne;
     Modify.Publie;
end;

function Str4_2(r:Extended):String;begin Str( r:4:2, Result); end;

function TObservation.GetHeureLocale: String;
var
   t   : String;
begin
     if Lieu.Decalage_Heure_Ete <> 0
     then
         if Temps.HeureEte
         then
             t:= 'Heure légale ( Eté ): '
         else
             t:= 'Heure légale (Hiver): '
     else
         t:= 'Heure Civile: ';

     Result:= t+Temps.TL.sHeure+'  (fuseau: '+Str4_2(Lieu.Decalage_Heure_Locale)+')';
end;

function TObservation.GetLegale_Civile: String;
begin
     if Lieu.Decalage_Heure_Ete=0 then Result:= 'Civile' else Result:= 'Légale';
end;

function TObservation.GetEquinoxe: String;
begin
     if EquinoxeCourant
     then
         Result:= Format( 'J%7.2f',[J2000_Vers_EquinoxeCourant.EquinoxeFinal])
     else
         Result:= 'J2000.00';
end;

procedure TObservation.Temps_Change;
begin
     Calcul;
end;

procedure TObservation.LieuChange;
begin
     Temps.TLO.Modify.Publie;
//     Temps.TL.To_Jour_Julien;
//     Modify.Publish;
end;

procedure TObservation.Log( _Prefix: String);
begin
     Lieu .Log(_Prefix+' Lieu : ');
     Temps.Log(_Prefix+' Temps: ');
     WriteLn( _Prefix+' Temps sidéral: ',FTemps_sideral_en_heures);
end;


end.

