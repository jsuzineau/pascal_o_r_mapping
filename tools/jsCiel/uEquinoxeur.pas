unit uEquinoxeur;

{$mode Delphi}

interface

uses
    uMath,
 Classes, SysUtils;

const
     JourJulienJ2000: Extended=2451545.0;{01/01/2000 à 12:00 TD, référence J2000}
     NbJoursParSiecleJulien: Extended = 36525;
     NbJoursParAnneeJulienne: Extended= 365.25;{pour la chaine d"équinoxe}

type
  { _A_s_t_r_o_n_o_m_i_c_a_l_ A_l_g_o_r_i_t_h_m_s_, Jean MEEUS, }
  { p 126-127                                                   }
  TEquinoxeur
  =
   class
   public
     Dzeta, z, Theta: Extended;
     EquinoxeFinal: Extended;
     procedure Initialise( _JD0, _JD: Extended);
     procedure Calcul( var _AD, De: Extended);
   end;

implementation

procedure TEquinoxeur.Initialise( _JD0, _JD: Extended);
{     _A_s_t_r_o_n_o_m_i_c_a_l_ A_l_g_o_r_i_t_h_m_s_, Jean MEEUS,      }
{     p 126-127                                                        }
var
   GT, pt: Extended;
   GT2{GT*GT}, pt2{pt*pt}, pt3{pt*pt*pt}: Extended;

   DzetaEtZ: Extended;
begin
     GT:= (_JD0 - JourJulienJ2000)/NbJoursParSiecleJulien;
     pt:= (_JD-_JD0)/NbJoursParSiecleJulien;

     GT2:= sqr(GT);
     pt2:= sqr(pt);
     pt3:= pt2*pt;

     DzetaEtZ:= (2306.2181+1.39656*GT-0.000139*GT2)*pt;
     Dzeta   := DzetaEtZ
                  +(0.30188-0.000344*GT)*pt2+0.017998*pt3;
     z       := DzetaEtZ
                  +(1.09468+0.000066*GT)*pt2+0.018203*pt3;
     Theta   := (2004.3109-0.85330*GT-0.000217*GT2)*pt
                  -(0.42665+0.000217*GT)*pt2-0.041833*pt3;

     {Conversion des secondes d"arc en degrés }

     Dzeta:= dg_from_dgsec(Dzeta);
     z    := dg_from_dgsec(z    );
     Theta:= dg_from_dgsec(Theta);

     {Conversion en radians}
     Dzeta:= rd_from_dg(Dzeta);
     z    := rd_from_dg(z    );
     Theta:= rd_from_dg(Theta);

     {pour affichage de l"équinoxe courant}
     EquinoxeFinal:= 2000+(_JD-JourJulienJ2000)/NbJoursParAnneeJulienne;
end;

procedure TEquinoxeur.Calcul( var _AD, De: Extended);
{     _A_s_t_r_o_n_o_m_i_c_a_l_ A_l_g_o_r_i_t_h_m_s_, Jean MEEUS,      }
{     p 126-127                                                        }
const
     ProchePole= 85.0*PI/180;{85 degrés}
var
   Alpha0PlusDzeta,
   cDelta0, sDelta0, cAlpha0PlusDzeta, sAlpha0PlusDzeta,
   cTheta, sTheta,
   cDelta0cAlpha0PlusDzeta,
   A, B, C, ADmoinsZ, cDe: Extended;
begin
     Alpha0PlusDzeta:= _AD+Dzeta;

     SinCos( De, sDelta0, cDelta0);

     SinCos( Alpha0PlusDzeta, sAlpha0PlusDzeta, cAlpha0PlusDzeta);

     SinCos( Theta, sTheta, cTheta);

     cDelta0cAlpha0PlusDzeta:= cDelta0*cAlpha0PlusDzeta;

     A:= cDelta0*sAlpha0PlusDzeta;
     B:= cTheta*cDelta0cAlpha0PlusDzeta-sTheta*sDelta0;
     C:= sTheta*cDelta0cAlpha0PlusDzeta+cTheta*sDelta0;

     ADmoinsZ:= Angle( B, A);

     _AD:= Modulo2PI( ADmoinsZ + Z );
     De:= ArcSin( C);
     if Abs(De) > ProchePole
     then
         begin
         cDe:= sqrt(sqr(A)+sqr(B));
         if De < 0
         then
             De:= -ArcCos( cDe)
         else
             De:= +ArcCos( cDe);
         end;
end;

end.

