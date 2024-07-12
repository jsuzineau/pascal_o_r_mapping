unit uObjets;

{$mode Delphi}

interface

uses
    uMath,
    uSexa_radians,
    uObservation,
 Classes, SysUtils;

type
    // 07/02/2000 suppression du champ EquinoxeJ2000 qui ne sert à rien
    //            juste initialisé à True ici, à False ds le Syssol
    //            et recopié par le copy_from
    TypePersistant= (tp_Caduc, tp_Persistant);
    TypCircumpolaire= (tc_pas_circumpolaire, tc_leve, tc_couche);

    T_Objet
    =
     class
     protected
       Observation: TObservation;

       Magnitude        : Extended;
       J2000_Ascension_Droite : Extended;
       J2000_Declinaison      : Extended;
       _Ascension_Droite : Extended;
       _Declinaison      : Extended;
       Angle_Horaire    : Extended;
       Azimuth , Hauteur: Extended;
       Azimuth_KDir     : Extended; {Az - kAz}

       // calculé dan Calcul
       sDe, cDe,
       sJ2000_De, cJ2000_De,
       // calculé dan Azimuthal_from_equatorial
       sAz,cAz,
       {Photo}
       DA, SDA, CDA, H: Extended;

       // Persistance de l'objet entre les calculs (les objets NGC persistent
       // mais les objets PPM sont détruits resélectionnés à chaque fois)
       FPersistant: TypePersistant;
       function GetMagS: String; virtual;
       function GetADS: String; // valeur J2000 ou courant changeant selon option EquinoxeCourant
       function GetDeS: String; // valeur J2000 ou courant changeant selon option EquinoxeCourant
       function GetAHS: String;
       function GetAzS: String;
       function GetHtS: String;

       function GetDenomination: String; virtual;
       function GetCommentaire: String; virtual;
       function GetMagnitude: Extended; virtual;
       procedure Azimuthal_from_Equatorial;
     public
       Visible: Boolean;{au sens de visible dans la fenêtre courante}
       SuivantSouris: T_Objet;
       property Mag   : Extended read GetMagnitude         ;
       property AD    : Extended read _Ascension_Droite  ;
       property De    : Extended read _Declinaison       ;
       property J2000_AD: Extended read J2000_Ascension_Droite  ;
       property J2000_De: Extended read J2000_Declinaison       ;
       property Denom : String read GetDenomination   ;
       property Comm  : String read GetCommentaire    ;
       property AH    : Extended read Angle_Horaire     ;
       property Az    : Extended read Azimuth           ;
       property AzKDir: Extended read Azimuth_KDir      ;{ Az-kAz }
       property Ht    : Extended read Hauteur           ;

       property MagS  : String read GetMagS           ;
       property ADS   : String read GetADS            ;
       property DeS   : String read GetDeS            ;
       property AHS   : String read GetAHS            ;
       property AzS   : String read GetAzS            ;
       property HtS   : String read GetHtS            ;
       property Persistant: TypePersistant read FPersistant;

       constructor Create( _Observation: TObservation; unPersistant: TypePersistant);
       constructor Create_J2000( _Observation: TObservation; UneAscension_Droite: Extended;
                                 UneDeclinaison     : Extended;
                                 unPersistant: TypePersistant);
       constructor Create_from(_Observation: TObservation; UnObjet: T_Objet);

       procedure   J2000_Set_to    ( UneAscension_Droite: Extended;
                                     UneDeclinaison     : Extended);
       procedure        _Set_to    ( UneAscension_Droite: Extended;
                                     UneDeclinaison     : Extended
                                     );
       function    EgalPoint( UnObjet: T_Objet): Boolean;

       procedure Calcul; virtual;

       procedure   Copy_from( UnObjet: T_Objet);
       function    EgalObjet( UnObjet: T_Objet): Boolean;

       procedure J2000_vers_EquinoxeCourant;
       procedure EquinoxeCourant_vers_J2000;
       procedure Montre_Catalogue; virtual;
       function Circumpolaire( zx: Extended): TypCircumpolaire;
       // zx: hauteur sur l'horizon pour le calcul de circumpolarité
     end;


implementation

constructor T_Objet.Create( _Observation: TObservation; unPersistant: TypePersistant);
begin
     inherited Create;
     Observation:= _Observation;
     FPersistant:= unPersistant;
end;

CONSTRUCTOR T_Objet.Create_J2000( _Observation: TObservation;
                                  UneAscension_Droite: Extended;
                                  UneDeclinaison     : Extended;
                                  unPersistant       : TypePersistant);
begin
     Create( _Observation, unPersistant);
     J2000_Ascension_Droite:= UneAscension_Droite;
     J2000_Declinaison     := UneDeclinaison;
end;

CONSTRUCTOR T_Objet.Create_from( _Observation: TObservation;
                                 UnObjet: T_Objet);
begin
     Create( _Observation, unObjet.Persistant);
     Copy_from( UnObjet);
end;

PROCEDURE   T_Objet.Copy_from( UnObjet: T_Objet);
begin
     Magnitude       := UnObjet.Magnitude;
     _Ascension_Droite:= UnObjet._Ascension_Droite;
     _Declinaison     := UnObjet._Declinaison;
     J2000_Ascension_Droite:= UnObjet.J2000_Ascension_Droite;
     J2000_Declinaison     := UnObjet.J2000_Declinaison;
end;

{ Routines de calcul des champs                                         }

{ Sous - routine de calcul des coordonnées azimuthales                 }
{ un trés lointain descendant de la procédure AzHt de PC_Ciel          }
procedure T_Objet.Azimuthal_from_Equatorial;
var
   cAH, sAH, cLa, sLa: Extended;
   sHt:Extended;
begin
     Angle_Horaire:= Modulo2PI( Observation.Temps_sideral_en_radians -_Ascension_Droite);

     sLa:= Observation.Lieu.La.  sinus;
     cLa:= Observation.Lieu.La.cosinus;

     SinCos( Angle_Horaire, sAH, cAH);

     sHt:= sLa*sDe + cLa*cDe*cAH;
     Hauteur:= ArcSin( sHt);

     sAz:= cDe*sAH;
     cAz:= cAH*cDe*sLa-cLa*sDe;

     // il apparaît des formules ci-dessus qu'on arrive à avoir
     // sqr(sAz) + sqr(cAz) <> 1
     // donc on doit "normaliser" à 1 pour bien avoir le sin et le cos.
     xy_to_sincos( cAz, sAz);

     Azimuth:= AnglePositif( cAz, sAZ);
end;

procedure T_Objet.Calcul;
var
   TheKAZ: Extended;
begin
     J2000_vers_EquinoxeCourant;
     SinCos( _Declinaison, sDe, cDe);

     Azimuthal_from_Equatorial;
end;

{ Routines d"initialisation sous diverse formes                        }

PROCEDURE   T_Objet.J2000_Set_to        ( UneAscension_Droite: Extended;
                                    UneDeclinaison     : Extended);
begin
     J2000_Ascension_Droite:= UneAscension_Droite;
     J2000_Declinaison     := UneDeclinaison;
     Calcul;
end;

PROCEDURE   T_Objet.    _Set_to        ( UneAscension_Droite: Extended;
                                    UneDeclinaison     : Extended);
begin
     _Ascension_Droite:= UneAscension_Droite;
     _Declinaison     := UneDeclinaison;
     EquinoxeCourant_vers_J2000;
     Calcul;
end;

{ Routine opérateur test d"égalité                                     }
FUNCTION T_Objet.EgalObjet( UnObjet: T_Objet): Boolean;
begin
     EgalObjet:= (Magnitude        = UnObjet.Magnitude       ) and
                  EgalPoint( UnObjet);
end;

procedure T_Objet.J2000_vers_EquinoxeCourant;
begin
     _Ascension_Droite:= J2000_Ascension_Droite;
     _Declinaison:= J2000_Declinaison;
     Observation.J2000_Vers_EquinoxeCourant.Calcul(      _Ascension_Droite,      _Declinaison);
end;

procedure T_Objet.EquinoxeCourant_vers_J2000;
begin
     J2000_Ascension_Droite:= _Ascension_Droite;
     J2000_Declinaison    := _Declinaison     ;
     Observation.EquinoxeCourant_Vers_J2000.Calcul( J2000_Ascension_Droite, J2000_Declinaison);
end;

FUNCTION T_Objet.EgalPoint( UnObjet: T_Objet): Boolean;
begin
     EgalPoint:= (_Ascension_Droite = UnObjet._Ascension_Droite) and
            (_Declinaison      = UnObjet._Declinaison     );
end;

{
FUNCTION HeurePourHauteurDonnee( unHT: Extended):Extended;
var
   sinHT, sinDe, cosDe, La,sinLa, cosLa, cosAH: Extended;
begin
     La:= Observation.Lieu.La;
     SinCos( La, sinLa, cosLa);

     sinHt:= sin(unHt);

     SinCos( De, sinDe, cosDe);

     cosAH:= (sinHt- sinLa*sinDe)/(cosLa*cosDe);

     sinHt:=  + cosdDe*cosDe*cosAH;
end;
}

FUNCTION T_Objet.GetAzS:String;
begin Result:= Degres360MinutesSecondes( Azimuth);end;

FUNCTION T_Objet.GetHtS:String;
begin Result:= Degres90MinutesSecondes( Hauteur);end;

// valeur J2000 ou courant changeant selon option EquinoxeCourant
FUNCTION T_Objet.GetADS: String;
begin
     if Observation.EquinoxeCourant
     then
         Result:= HeureMinutesSecondes(      _Ascension_Droite)
     else
         Result:= HeureMinutesSecondes( J2000_Ascension_Droite);
end;

FUNCTION T_Objet.GetAHS: String;
begin
     Result:= HeureMinutesSecondes( Angle_Horaire);
end;

// valeur J2000 ou courant changeant selon option EquinoxeCourant
FUNCTION T_Objet.GetDeS: String;
begin
     if Observation.EquinoxeCourant
     then
         Result:= Degres90MinutesSecondes(      _Declinaison)
     else
         Result:= Degres90MinutesSecondes( J2000_Declinaison);
end;

FUNCTION Str5_2(r:Extended):String;begin Str( r:5:2, Result); end;
FUNCTION T_Objet.GetMagS: String;
begin
     Result:= Str5_2( Mag);
end;

function T_Objet.GetDenomination: String; begin Result:= ''; end;

function T_Objet.GetCommentaire: String; begin Result:= ''; end;

function T_Objet.GetMagnitude: Extended;
begin
     Result:= Magnitude;
end;

procedure T_Objet.Montre_Catalogue;
begin

end;

function T_Objet.Circumpolaire( zx: Extended): TypCircumpolaire;
var
   La: Extended;
   Hemisphere_Nord_Declinaison_Maxi_pour_toujours_couche,
   Hemisphere_Nord_Declinaison_Mini_pour_toujours_leve,
   Hemisphere_Sud__Declinaison_Mini_pour_toujours_couche,
   Hemisphere_Sud__Declinaison_Maxi_pour_toujours_leve: Extended;
begin
     La:= Observation.Lieu.La.Radians;

          if La < 0
     then
         begin
         Hemisphere_Sud__Declinaison_Mini_pour_toujours_couche:=   PI/2 + La - zx;
         Hemisphere_Sud__Declinaison_Maxi_pour_toujours_leve  := -(PI/2 + La + zx);
              if _Declinaison < Hemisphere_Sud__Declinaison_Maxi_pour_toujours_leve
         then
             Result:= tc_leve
         else if _Declinaison < Hemisphere_Sud__Declinaison_Mini_pour_toujours_couche
         then
             Result:= tc_Couche
         else
             Result:= tc_pas_circumpolaire;
         end
     else if La = 0
     then
         Result:= tc_pas_circumpolaire
     else //0 < La
         begin
         Hemisphere_Nord_Declinaison_Maxi_pour_toujours_couche:= -(PI/2-La - zx);
         Hemisphere_Nord_Declinaison_Mini_pour_toujours_leve  :=   PI/2-La + zx ;
              if _Declinaison <= Hemisphere_Nord_Declinaison_Maxi_pour_toujours_couche
         then
             Result:= tc_couche
         else if _Declinaison <= Hemisphere_Nord_Declinaison_Mini_pour_toujours_leve
         then
             Result:= tc_pas_circumpolaire
         else
             Result:= tc_leve;
         end;
end;

end.

