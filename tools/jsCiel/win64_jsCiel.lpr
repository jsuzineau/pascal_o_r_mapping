program win64_jsCiel;

{$apptype console}
uses
    uObservation,
    uLieu,
    uCoordonnee,
    uDate,
    uDate_Ephemerides,
    uTemps,
    uEquinoxeur,
    uMath,
    uCiel,
    uObjets_du_Systeme_Solaire,
    uObjet_non_ponctuel,
    uObjets,
    uSexa_radians,
    uTheories_Planetaires, uuStrings,
    uSysteme_Solaire,
  SysUtils;

var
   Ciel: TCiel;
   HeureEte: Boolean;

function HHMM_Legal(const ad :Extended):String;
{transforme heure ou ad en radians en chaîne HH:MM              }
var
   adh    : Extended;
   hhh,mmm: integer;
   hhs,mms: String[2];
begin
     adh:=ad*12/pi;

     hhh:=round(adh-0.5);mmm:=round(frac(adh)*60);
     if mmm=60 then begin mmm:=0;hhh:=hhh+1;end;
     if hhh=24 then hhh:=0;

     if HeureEte
     then
         Inc( hhh, 2)
     else
         Inc( hhh, 1);

     str(hhh:2,hhs);if hhs[1]=' ' then hhs[1]:='0';
     str(mmm:2,mms);if mms[1]=' ' then mms[1]:='0';

     Result:= hhs+ ':'+ mms;
end;

procedure Levers_Soleil;
const
     Mois: array[1..12] of String =
       (
       'Janvier  ',
       'Février  ',
       'Mars     ',
       'Avril    ',
       'Mai      ',
       'Juin     ',
       'Juillet  ',
       'Août     ',
       'Septembre',
       'Octobre  ',
       'Novembre ',
       'Décembre '
       );
var
   sHeureEte: String;
begin
     HeureEte:= Ciel.Observation.Temps.TU.EteHiver_;
     if HeureEte
     then
         sHeureEte:= 'été  '
     else
         sHeureEte:= 'hiver';
     Ciel.SSOL.Soleil.LeMeCo(0);
     WriteLn( Ciel.Observation.Temps.TL.sJour,' ',
              Mois[Ciel.Observation.Temps.TL.Mois],
              ': ',
              HHMM_Legal( Ciel.SSOL.Soleil.hl),
              ' (',sHeureEte,')', ', Az: ',Ciel.SSOL.Soleil.AzS_Lever);
end;



begin
     Ciel:= TCiel.Create;
     try
        Ciel.Initialise( 43.604312,1.4436825);
        Ciel.Observation.Temps.TLO.Set_from_computer_date;
        Ciel.Log( 'win64_jsCiel: ');
        Levers_Soleil;
        Ciel.Observation.Temps.TD.Add_To_Julian_Date( +1);
        Levers_Soleil;
     finally
            Freeandnil( Ciel);
            end;
     Readln;
end.

