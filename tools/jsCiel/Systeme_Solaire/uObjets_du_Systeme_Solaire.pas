unit uObjets_du_Systeme_Solaire;

{$mode Delphi}

interface

uses
    uMath,
    uObservation,
    uObjets,
    uObjet_non_ponctuel,

    uTheories_Planetaires,
 Classes, SysUtils,Math;

TYPE
{Système solaire}
    T_Soleil= class;

    T_Objet_du_Systeme_Solaire
    = { cette classe abstraite factorise les constructeurs/destructeur}
     class( T_Objet_non_ponctuel) {des types soleil, lune et planète}
     protected
       Soleil: T_Soleil;
       Terre: T_Objet_du_Systeme_Solaire;
       i: Integer;
       Coefficient_de_phase: Extended;
       Longitude_Heliocentrique,
       Distance_au_Soleil: Extended; // en ua
       {spécial Draw}
       elo                   : Extended; {élongation en degrés}
       GD                    : Extended; //GD (Grand Delta) = distance Terre-planète  en UA
       procedure CalculADDe( tt: Extended); virtual; abstract;
       procedure PNLMC( var zx,tt0,mm0,de0 :Extended);
       procedure PSLMC( var zx,tt0,mm0,de0 :Extended);
     public
       PixSec  : Extended; {pixels par " d"arc}
       cx, cy, ra            : Integer;
       xh, yh, zh: Extended; // coordonnées rectangulaires héliocentriques de l'objet
       hl, hm, hc:Extended;{heure lever, heure coucher en radians, valides aprés LeMeCo}
       AzS_Lever: String;//Azimuth du lever aprés LeMeCo
       Az_Lever: Extended;//Azimuth du lever aprés LeMeCo
       property KA  : Extended read Coefficient_de_phase;
       property LH  : Extended read Longitude_Heliocentrique;
       property RH  : Extended read Distance_au_Soleil;
       property IndiceObjet: Integer read i;

       constructor Create( _Observation: TObservation;
                           unSoleil: T_Soleil;
                           uneTerre: T_Objet_du_Systeme_Solaire;
                           UnI: Integer;
                           unPersistant: TypePersistant);
       destructor  Destroy; override;

       function LeMeCo(zx: Extended): TypCircumpolaire;

       procedure Calcul; override;
     end;

    { T_Soleil }

    T_Soleil
    =
     class( T_Objet_du_Systeme_Solaire)
     public
       xs, ys, rs,//ok
       ms,    // Mean Anomaly of Sun, M
       ls,    // Apparent Longitude of Sun, lambda
       tls, stls, ctls,   // True Longitude of Sun, theta
       ep, cep, sep: Extended; // Obliquity of Ecliptic, epsilon
       gP, gL0, gB0, nro: Extended;

       constructor Create( _Observation: TObservation; UnI: Integer);
       procedure Calcul; override;
       procedure CalculADDe( tt: Extended);override;

       function GetMS : Extended;
       function GetLS : Extended;
       function GetXS : Extended;
       function GetYS : Extended;
       function GetEP : Extended;
       function GetgP : Extended;
       function GetgL0: Extended;
       function GetgB0: Extended;
       function Getnro: Extended;
     end;

procedure NormaliseADDe( var A,D: Extended);

const
     ep_J2000= 23.43929111* PI/180;// obliquity of the ecliptic in J2000
var
   cep_J2000: Extended; // cos ep_J2000
   sep_J2000: Extended; // sin ep_J2000

function HHMM(var ad :Extended):String;

implementation

function HHMMM(var ad :Extended):String;
{transforme une asc.droite ad en radians en chaîne HH:MM.M (min+1 décimales}
var
   hhh,mmm: Extended;
   hhs    : String[2];
   mms    : String[4];
begin
     hhh:=int(ad*12/pi);mmm:=int((ad-hhh*pi/12)*7200/pi+0.5)/10;
     if mmm=60 then begin mmm:=0;hhh:=hhh+1;end;
     if hhh=24 then hhh:=0;
     str(hhh:2:0,hhs);if hhs[1]=' ' then hhs[1]:='0';
     str(mmm:4:1,mms);if mms[1]=' ' then mms[1]:='0';

     Result:= hhs+':'+mms;
end;
{--------------------------------------------------------------------------}

function HHMM(var ad :Extended):String;
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

     str(hhh:2,hhs);if hhs[1]=' ' then hhs[1]:='0';
     str(mmm:2,mms);if mms[1]=' ' then mms[1]:='0';

     Result:= hhs+ ':'+ mms;
end;

CONSTRUCTOR T_Objet_du_Systeme_Solaire.Create( _Observation: TObservation;
                                               unSoleil: T_Soleil;
                                               uneTerre: T_Objet_du_Systeme_Solaire;
                                               UnI: Integer; unPersistant: TypePersistant);
begin
     inherited Create( _Observation, unPersistant);
     Soleil:= unSoleil;
     Terre := uneTerre;
     I:= UnI;
     Magnitude:= -100;
end;

DESTRUCTOR  T_Objet_du_Systeme_Solaire.Destroy;
begin
     inherited Destroy;
end;

{Calcul spécial Pôle Nord}
procedure T_Objet_du_Systeme_Solaire.PNLMC(var zx,tt0,mm0,de0 :Extended);
var
   tt2    :Extended;
   mm     :Extended;
begin
     tt2:=tt0+1/36525;

     Soleil.CalculADDe( tt2);
     CalculADDe( tt2);

     if ((de0<zx) and (_Declinaison<zx))
      {la planète ne se lève pas dans la journée}
     then
         begin
         hl:= -2;
         hm:= -2;
         hc:= -2;
         end
     else if ((de0>=zx) and (_Declinaison>=zx))
     {la planète ne se couche pas dans la journée}
     then
         begin
         hl:= -2;
         hm:= -2;
         hc:= -2;
         end
     {la planète se lève ou se couche dans la journée}
     else
         begin
         mm:=(zx-de0)/(_Declinaison-de0)*2*pi;
         if de0<zx
         {la planète se lève}
         then
             begin
             hl:= mm;
             if mm>mm0 then hm:= -2;
             hc:= -2;
             end
         {la planète se couche}
         else
             begin
             hl:= -2;
             if mm<mm0 then hm:= -2;
             hc:= mm;
             end;
         end;
end;

{Calcul spécial Pôle Sud}
procedure T_Objet_du_Systeme_Solaire.PSLMC( var zx,tt0,mm0,de0 :Extended);
var
   tt2                         :Extended;
   mm                          :Extended;
begin
     tt2:=tt0+1/36525;

     Soleil.CalculADDe( tt2);
     CalculADDe( tt2);

     if ((de0>-zx) and (_Declinaison>-zx))
      {la planète ne se lève pas dans la journée}
     then
         begin
         hl:= -2;
         hm:= -2;
         hc:= -2;
         end
     else if ((de0<-zx) and (_Declinaison<-zx))
     {la planète ne se couche pas dans la journée}
     then
         begin
         hl:= -2;
         hc:= -2;
         end
     {la planètel se lève ou se couche dans la journée}
     else
         begin
         mm:=(-zx-de0)/(_Declinaison-de0)*2*pi;
         if de0>-zx
         {la planète se lève}
         then
             begin
             hl:= mm;
             if mm>mm0 then hm:= -2;
             hc:= -2;
             end
         {la planète se couche}
         else
             begin
             hl:= -2;
             if mm<mm0 then hm:= -2;
             hc:= mm;
             end;
         end;
end;


// Last known good ...
function T_Objet_du_Systeme_Solaire.LeMeCo(zx: Extended): TypCircumpolaire;
//cf MEEUS, Astronomical Algorithms, ch 14, p97-100
// modification/nettoyage sur le sens de zx. maintenant zx=h0 de MEEUS
//   et ht1 = hauteur effective au lieu de sinus de la hauteur effective
// Optimisation des calculs de sinus/cosinus
var
   szx,          // zx: hauteur au lever/coucher = h0 de MEEUS  et  szx= sin(zx)
   La, sLa, cLa, // Latitude
   Lg,           // Longitude
   tt0,          // Tau à 0h00
   tsg0,         // Temps sidéral de Greenwich à 0h00
   De0, sDe0, cDe0, // Déclinaison à 0h00
   Dem, sDem, cDem, // Déclinaison au passage au méridien
   Deml, sDeml, cDeml, // Déclinaison au passage au méridien - PI, coté lever
   Demc, sDemc, cDemc, // Déclinaison au passage au méridien - PI, coté lever
   ah0, // passage méridien   = H0 de MEEUS
   ahc, // cos( ah)
   AHReel, // Angle horaire recalculé dans CalculePosition
   mmReel, // recalculé à partir du tt et du tt0
   AHSpeed, // Période de l'objet en angle horaire / étoiles
   ht1,
   mm0             :Extended;
   procedure Initialisation;
   // initialisation de la latitude et de la hauteur sur l'horizon cherchée
   begin
        with Observation.Lieu.La
        do
          begin
          La:= Radians;
          sLa:= sinus;
          cLa:= cosinus;
          end;
        Lg:= Observation.Lieu.Lg.Radians;

        // zx hauteur au lever/coucher
        if zx=0
        then
            if i=1
            then
                {zx:=0.0047}// 0°16'09.44"
                {#déboguage Jacques Dubreuil}
                zx:=0.005 //0°17'11.32" avec arcsin => 0°17'11.33"
                {~déboguage Jacques Dubreuil}
            else
                zx:=-0.01064; //-0°36'34" avec arcsin => 0°36'34.37"

        szx:= sin( zx);

        if i= 1
        then
            AHSpeed:= 1.0366
        else
            AHSpeed:= 1;
   end;
   procedure Calcule_Position( var tt: Extended);
   var
      tsg: Extended;
   begin
        Soleil.CalculADDe( tt);
        CalculADDe( tt);
        SinCos( _Declinaison, sDe, cDe);

        //tt:=tt0+mm0/2/pi/36525;
        //tt-tt0= mm0/(2*PI*36525)
        mmReel:= (tt-tt0) * (2*PI*36525);
        tsg:=R2PI20(tsg0+mmReel*1.002738);

        AHReel:= tsg-Lg-_Ascension_Droite;
        if AHReel>PI then AHReel:= AHReel - 2*PI;
        if AHReel < 0 then AHReel:= -AHReel;
   end;
   procedure Calcul_Passage_au_meridien_jour( JourDelta: Integer);
   var
      tt: Extended;
      tsg: Extended;
      AH: Extended;
   begin
        //Calcul de Tau à 0h00 pour le jour JourDelta
        with Observation.Temps.TD
        do
          tt0:= Tau+(JourDelta-Fraction_Jour)/36525;

        // calcul du temps sidéral de Greenwich à 0h00 pour le jour JourDelta
        tsg0:=1.753368558+tt0*(628.3319706+6.770708E-06*tt0);
        tsg0:=R2Pi20(tsg0);

        //Calcul de la position du Soleil et de l'objet à 0h00 pour le jour JourDelta
        Calcule_Position( tt0);

   {passage au méridien - hms}

        //mm0 = - angle horaire de l'objet à 0h00 pour le jour JourDelta
        //    = temps pour arriver au méridien si ascension droite constante
        mm0:=_Ascension_Droite+Lg-tsg0;
        mm0:=R2Pi20(mm0);

        //de0 = déclinaison de l'objet à 0h00 pour le jour JourDelta
        De0:=_Declinaison; {conservation pour calcul lever et coucher}
        sDe0:= sDe;
        cDe0:= cDe;

        //tsg = temps sidéral de Greenwich pour le passage au méridien si ascension droite constante
        tsg:=R2PI20(tsg0+mm0*1.002738);
        {     if tsg1>2*pi then tsg1:=tsg1-2*pi; #déboguage Jacques Dubreuil}

        // tt = Tau du passage au méridien si ascension droite constante
        tt:=tt0+mm0/2/pi/36525;

        //Calcul de la position du Soleil et de l'objet au passage au méridien de l'objet si ascension droite constante
        Calcule_Position( tt);

        // AH = angle horaire recalculé de l'objet au passage au méridien de l'objet si ascension droite constante
        AH:=tsg-Lg-_Ascension_Droite;
        {#déboguage Jacques Dubreuil}
        if AH>PI then AH:= AH - 2*PI;
        {~déboguage Jacques Dubreuil}
        //if i=1 then AH:=AH*1.0366; // cas spécial Lune

        // Affinage de mm0
        //mm0 = temps pour arriver "vraiment"(1 itération) au méridien depuis 0h00 pour le jour JourDelta
        mm0:=mm0-AH;

        // Récupération de l'heure en radians du passage au méridien
        if JourDelta = 0
        then
            begin
            Result:= Circumpolaire( zx);
            if ((mm0<0) or (mm0>2*pi))
            then
                hm:= -1
            else
                hm:= mm0;
            end;

        // passage au méridien
        tt:=tt0+(mm0)/2/pi/36525;
        Calcule_Position( tt);
        Dem:= _Declinaison;
        SinCos( Dem, sDem, cDem);

        // pseudo antimériden coté lever
        tt:=tt0+(-PI)/2/pi/36525;
        Calcule_Position( tt);
        Deml:= _Declinaison;
        SinCos( Deml, sDeml, cDeml);

        // pseudo antimériden coté coucher
        tt:=tt0+(+PI)/2/pi/36525;
        Calcule_Position( tt);
        Demc:= _Declinaison;
        SinCos( Demc, sDemc, cDemc);

   end;
   function mmEvenement_from_AH( var ah: Extended; Signe: Integer; Saut: Boolean): Extended;
   begin
        if Saut
        then
            ah:= 2*PI-ah;
        Result:= mm0+Signe*ah*AHSpeed;
   end;
   // L'ascension droite d'objets comme la Lune varie beaucoup avec le temps
   // et donc l'angle horaire "dérape" par rapport à mm, il ne correspond pas
   // au temps mis pour le trajet au passage au méridien
   // Pour corriger cela, je "recale" mm0 pour que la relation
   //    mm:= mm0+Signe*ah*AHSpeed  soit vraie .
   // mm0 correspond alors à une sorte de "passage au méridien instantanné"
   // vu depuis l'instant mm.
   procedure mm0_from_AH_mm( ah, mm: Extended; Signe: Integer);
   begin
        //mm:= mm0+Signe*ah*_0_95;
        mm0:= mm-Signe*ah*AHSpeed;
   end;
   procedure Calcul_AH0_from_De( sDeclinaison, cDeclinaison: Extended);
   begin
        {semi-arc diurne - 1ère approximation}

        // ahc= cosinus de l'angle horaire à l'horizon d'aprés la déclinaison à 0h00
        ahc:=(szx-sLa *sDeclinaison)/(cLa*cDeclinaison);

        // ah0 = angle horaire à l'horizon d'aprés la déclinaison à 0h00
        if ahc=0
        then
            ah0:=pi/2
        else if ahc>=1
        then
            ah0:=0
        else if ahc<=-1
        then
            ah0:=pi
        else
            ah0:= ArcCos( ahc);
   end;

   procedure AHC_from_mm( mm: Extended);
   var
      tt: Extended;
   begin
        // tt = Tau à heure mm
        tt:=tt0+mm/2/pi/36525;

        //Calcul de la position du Soleil et de l'objet à heure mm
        Calcule_Position( tt);

        // ahc= cosinus de l'angle horaire à heure mm
        ahc:=(szx-sLa*sDe) / (cLa*cDe);
   end;
   procedure AH_from_AHC( Signe: Integer; var ah, mm: Extended; Saut: Boolean);
   var
      tsg: Extended;
   begin
        // AH = Angle horaire à à 5% de 5% de l'horizon sur le trajet au méridien sur le trajet au méridien
        // d'aprés l'ascension droite à 5% aprés le lever sur le trajet au méridien
        if ahc=0
        then
            AH:=pi/2
        else
            begin
            ah0:= ArcCos( ahc);

            // mm = heure en radians à 5% aprés 5% aprés le lever sur le trajet au méridien sur le trajet au méridien
            mm:= mmEvenement_from_AH( ah0, Signe, Saut);

            //tsg = temps sidéral de Greenwich à 5% aprés 5% aprés le lever sur le trajet au méridien sur le trajet au méridien
            tsg:=tsg0+mm*1.002738;
            if tsg>2*pi then tsg:=tsg-2*pi;

            AH:=tsg-Lg-_Ascension_Droite;
            {#déboguage Jacques Dubreuil}
            if AH>PI then AH:= AH - 2*PI;
            {~déboguage Jacques Dubreuil}
            end;
   end;
   // rajouté juste pour le test de qualité final
   //var
   //   T: Text;// juste pour test qualité
   procedure Calcule_AH_from_mm( var AH: Extended; mm: Extended);
   var
      tsg: Extended;
      tt: Extended;
   begin
        tt:=tt0+mm/(2*pi*36525);
        Soleil.CalculADDe( tt);
        CalculADDe( tt);
        SinCos( _Declinaison, sDe, cDe);
        //if I=1
        //then
        //    Write( T, Format('%.10f;%.10f',[tt,_Declinaison*180/pi]), ';');
        tsg:=tsg0+mm*1.002738; // temps sidéral de Greenwich à l'heure mm

        AH:= tsg-Lg-_Ascension_Droite;
   end;
   function Calcul_Evenement( JourDelta, Signe: Integer; var mm: Extended; Saut: Boolean): Boolean;
   var
      AH, sAH, cAH: Extended; // Angle horaire
      mm_brut, mm1: Extended;
      Erreur_brut, Erreur1, Erreur, ErreurMin: Extended;
      function Calcul_AHC( SautPasEffectue: Boolean): Boolean;
      begin
           mm:= mmEvenement_from_AH( ah0, Signe, Saut and SautPasEffectue);

           AHC_from_mm( mm);

           Result:= abs( ahc) <= 1;
      end;
   begin
        Calcul_Passage_au_meridien_jour( JourDelta);
        Calcul_AH0_from_De( sDe0, cDe0);

        if ahc > 0
        then
            Calcul_AH0_from_De( sDem, cDem)
        else
            if Signe < 0
            then
                Calcul_AH0_from_De( sDeml, cDeml)
            else
                Calcul_AH0_from_De( sDemc, cDemc);
{
                 Calcul_AHC( True);         essai pour corriger bug ci dessous
        mm0_from_AH_mm( AHReel, mm, Signe); //10/12/2000, lat= +73°15' long: 0°
        Result:= Calcul_AHC( False);
}
        Result:= Calcul_AHC( True);

        if not Result
        then
            exit;

        // ah0 = angle horaire à 5% aprés le lever sur le trajet au méridien // cas circumpolaire
        AH_from_AHC( Signe, AH, mm, Saut);

        SinCos( AH, sAH, cAH);
        // ht1 = hauteur à 5% de 5% de l'horizon sur le trajet au méridien sur le trajet au méridien
        ht1:=ArcSin( sLa*sDe+cLa*cDe*cAH); // label lmc2

        mm_brut:= mm; // sauvegarde de la valeur de mm
        Erreur_brut:= ht1-zx;

        // Affinage de mm pour arriver au lever
        // mm = heure en radians au lever
        // pas d'amélioration si on multiplie la correction par AHSpeed
        mm:=mm+ Erreur_brut / (cDe*cLa*sAH);


        //AssignFile( T, 'C:\_Projets\Vision_du_Ciel\Qualite.csv');
        //if FileExists( 'C:\_Projets\Vision_du_Ciel\Qualite.csv')
        //then
        //    Append( T)
        //else
        //    Rewrite( T);

        // test du cyclage sur la Lune
        if I= 1
        then
            begin
            Calcule_AH_from_mm( AH, mm);

            SinCos( AH, sAH, cAH);
            ht1:=ArcSin( sLa*sDe+cLa*cDe*cAH);
            mm1:= mm; // sauvegarde de la valeur de mm
            Erreur1:= ht1-zx;
            mm:=mm+ Erreur1 / (cDe*cLa*sAH);
            end
        else
            begin
            mm1:= mm_brut;
            Erreur1:= Erreur_brut;
            end;

        // test de la hauteur réellement obtenue
        Calcule_AH_from_mm( AH, mm);

        SinCos( AH, sAH, cAH);

        //début rajout calcul azimuth
        sAz:= cDe*sAH;
        cAz:= cAH*cDe*sLa-cLa*sDe;

        // il apparaît des formules ci-dessus qu'on arrive à avoir
        // sqr(sAz) + sqr(cAz) <> 1
        // donc on doit "normaliser" à 1 pour bien avoir le sin et le cos.
        xy_to_sincos( cAz, sAz);

        Azimuth:= AnglePositif( cAz, sAZ);
        //fin rajout calcul azimuth

        //calcul hauteur
        ht1:=ArcSin( sLa*sDe+cLa*cDe*cAH);
        Erreur:= ht1-zx;
        //if I=1
        //then
        //    begin
        //    Write  ( T, Format('%.10f',[Erreur_brut*180/pi]), ';');
        //    Write  ( T, Format('%.10f',[Erreur1    *180/pi]), ';');
        //    WriteLn( T, Format('%.10f',[Erreur     *180/pi]));
        //    end;
        //CloseFile( T);

        Erreur     := Abs( Erreur     );
        Erreur1    := Abs( Erreur1    );
        Erreur_brut:= Abs( Erreur_brut);

        ErreurMin:= Min_3( Erreur, Erreur1, Erreur_brut);

        if ErreurMin = Erreur1     then mm:= mm1    ;
        if ErreurMin = Erreur_brut then mm:= mm_brut;

        // bug la 80°21'59" lg -2°20' 4/12/2000
        //        89 21 59            7/12/2000
        // avec bug pôles: -0.8 , 1.22 ° avant  -1,86, 2.01 ° aprés
        // Paris/Pôle Nord: -0.54, 0.76         -1.46, 1.49
        // résultat de l'étude sous Excel du fichier obtenu:
        // De temps à autre le calcul dégrade la précision, d'autant plus
        // que l'on se rapproche du pôle
        // on reteste avec le AHSpeed: c'est moins bien au pôles, on dépasse 2° de dégradation
        // on sélectionne la meilleur valeur mm ou mm_brut
        // test sans ahspeed maxi 18' d'erreur vers le pôle, 9 ' ailleurs
        // test avec ahspeed: pas mieux


   end;
   procedure TrouveEvenement( Signe: Integer; var Heure: Extended);
   var
      JourDeltaResultat: Integer;
        procedure Teste_JourDelta_oppose_Signe;
        var
           JourDelta: Integer;
        begin
             JourDelta:= -Signe;
             if Calcul_Evenement( JourDelta, Signe, Heure, False)
             then
                 begin
                 Heure:= Heure + JourDelta*2*PI;
                 if (Heure < 0) or (2*PI < Heure)
                 then
                     Heure:= -1;
                 end
             else
                 Heure:= -3; // |ahc| > 1
        end;
        procedure Teste_en_passant_sous_l_horizon;
        begin
             if Calcul_Evenement( 0, -Signe, Heure, True)
             then
                 begin
                 if (Heure < 0) or (2*PI < Heure)
                 then
                     Heure:= -1;
                 end
             else
                 Heure:= -1; // |ahc| > 1
        end;
   begin
        if Calcul_Evenement( 0, Signe, Heure, False)
        then
            begin
            JourDeltaResultat:= Floor( Heure/(2*PI));

                 if JourDeltaResultat = Signe
            then
                Teste_JourDelta_oppose_Signe
            else if JourDeltaResultat = -Signe
            then // Pas sûr que çà existe
                Heure:= -1;
            end
        else // |ahc| > 1
            Teste_JourDelta_oppose_Signe;
        if Heure = -3
        then
            Teste_en_passant_sous_l_horizon;
   end;
   procedure Calcul_Lever;
   begin
        TrouveEvenement( -1, hl);
        AzS_Lever:= GetAzS;
        Az_Lever:= Azimuth;
   end;
   procedure Calcul_Coucher;
   begin
        TrouveEvenement( +1, hc);
   end;
begin
     Initialisation;

     if cLa =0   {pôle Nord ou Sud}
     then
         begin
         Calcul_Passage_au_meridien_jour( 0);
         if La >0
         then
             PNLMC(zx,tt0,mm0,de0) // Pôle Nord
         else
             PSLMC(zx,tt0,mm0,de0); // Pôle Sud
         end
     else
         begin
         Calcul_Lever;
         Calcul_Coucher;
         end;

end;// Last Known Good

procedure   T_Objet_du_Systeme_Solaire.Calcul;
{$IFNDEF WIN32}
var
   ADFish, DeFish: extended;
{$ENDIF}
   procedure To_J2000;
   begin
        {$IFDEF WIN32}
        Observation.EquinoxeCourant_Vers_J2000
        .
         Calcul(J2000_Ascension_Droite,J2000_Declinaison);
        {$ELSE}
        ADFish:= J2000_Ascension_Droite; //fpc ne supporte pas le passage par
        DeFish:= J2000_Declinaison     ; //adresse de membres protégés
        Observation.EquinoxeCourant_Vers_J2000.Calcul(ADFish, DeFish);
        J2000_Ascension_Droite:= ADFish;
        J2000_Declinaison     := DeFish;
        {$ENDIF}
   end;

begin
     {CalPlan}
     if i <> 10 {on exclut le calcul de l"azimuth de la Terre dans le ciel ... }
     then
         begin
         {Passage de l"équinoxe courant à l"équinoxe J2000 }

         J2000_Ascension_Droite:= _Ascension_Droite;
         J2000_Declinaison     := _Declinaison     ;

         if (i < 2) or (10 < i)
         then
             To_J2000
         else
             case Planetary_Theory_Used
             of
               pt_VSOP82: To_J2000;
               pt_VSOP87: To_J2000;
               pt_PS1996: ;
               else       To_J2000;
               end;

         inherited Calcul;{ AzHt et PXPY}
         //if KDir in [k_Sud..k_Zenith]
         //then
         //    Visible:= Azimuthal.Visible( Azimuth, Hauteur);
         end;
end;

constructor T_Soleil.Create(_Observation: TObservation; UnI: Integer);
begin
     inherited Create( _Observation, Self, nil, UnI, tp_Persistant);
end;

procedure T_Soleil.CalculADDe(tt: Extended);
// Sol20
{calcule la position du Soleil (ms et ls = longitude moyenne               }
{ms et ls sont utiles pour le calcul Lune et phases des planètes           }
{xs et ys sont les coordonnées rectangulaires écliptiques géocentriques    }
{calcule aussi l'angle écliptique ep utilisé dans les procédures suivantes }
var
   l0, //Geometric Mean Longitude L0
   es, //Eccentricty of the earth's orbit, e
   cs,vs:Extended;
   gomg,epa       :Extended;  // gomg: grand omega

begin
     l0:=4.895063+tt*(628.331967+5.2887E-06*tt); //Geometric Mean Longitude L0
     l0:=R2pi20(l0);
     if l0<0 then l0:=l0+2*pi;

     // Mean Anomaly of Sun M
     ms:=6.240060127+tt*(628.3019552+tt*(2.680825731E-06+((PI/180)*(1/24490000))*tt));

     ms:=R2pi20(ms);
     if ms<0 then ms:=ms+2*pi;

     es:=0.016708617-tt*(4.2037E-05-tt*1.236E-07); //Eccentricty of the earth's orbit, e

     cs:=(3.3416074E-02-tt*8.407251E-05-tt*+tt*2.4435E-07)*sin(ms)
         +(3.48944E-04-tt*1.76278E-06)*sin(2*ms)
         +5.06145E-06*sin(3*ms);

     tls:=l0+cs;     { true longitude of Sun      }
     SinCos( tls, stls, ctls);

     vs:=ms+cs;

     rs:=1.000001018*(1-es*es)/(1+es*cos(vs));

     xs:=rs*ctls;     {coordonnées rectangulaires ...     }
     ys:=rs*stls;     {... géocentriques écliptiques      }


     gomg:=2.182360-33.757041*tt;
     ls:=tls-9.93092E-05-8.34267E-05*sin(gomg);// Apparent Longitude of Sun, lambda

     ep:=0.409092804-tt*(2.269655E-04+tt*2.8604E-09);  //Obliquity of Ecliptic, Epsilon
     SinCos( ep, sep, cep);

     epa:=ep+4.46804E-05*cos(gomg);

     _Ascension_Droite:= Angle( ctls, cos(epa)*stls);

     _Ascension_Droite:= Normalise_Ascension_Droite( _Ascension_Droite);

     sde:=sin(epa)*stls;
     _Declinaison:=arctan(sde/sqrt(1-sde*sde));
end;


procedure T_Soleil.Calcul;
const
     _18_degres_en_radians= 18 * PI / 180;
var
   tt, jd:Extended;
   tet,eta,gI,gK       :Extended;
   x,y                 :Extended;
   sgB0                :Extended; {sin de B0  }
   xro                 :Extended;

begin
     tt:= Observation.Temps.TD.Tau;
     JD:= Observation.Temps.TD.Jour_Julien;

     CalculADDe( tt);

     {SolPhy20}
     { méthode MEEUS Ast.Alg. page 178 }

     tet:=R2pi20((JD+1/1440-2398220)*2*pi/25.38);
     gI:=1.265363708E-01;
     gK:=1.285726464+2.436189E-02*(JD+1/1440-2396758)/36525;

     x:=arctan(-cos(ls)*sin(ep)/cos(ep));
     y:=arctan(-cos(ls-gK)*sin(gI)/cos(gI));
     gP:=x+y;

     sgB0:=sin(ls-gK)*sin(gI);
     gB0:=arctan(sgB0/sqrt(1-sgB0*sgB0));

     eta:=arctan(sin(ls-gK)/cos(ls-gK)*cos(gI));

     if cos(ls-gK)>0 then eta:=eta+pi;

     gL0:=R2pi20(eta-tet);

     xro:=(JD-2398140.2270)/27.27523;
     nro:=int(xro);
     xro:=frac(xro);
     if (gL0>5.655) and (xro>0.9) then nro:=nro+1;
     if (gL0<0.628) and (xro<0.1) then nro:=nro-1;
     xro:=int((2*pi-gL0)/2/pi*1000+0.5)/1000;
     if xro=1 then begin xro:=0;nro:=nro+1;end;
     nro:=nro+xro;

     {#modif Jean SUZINEAU}
       GD:= rs; {"distance Terre-planète"= distance Terre-Soleil, ici}
       Magnitude:= -26;
     {~modif Jean SUZINEAU}

     {CalPlan}
     inherited Calcul;{ AzHt et PXPY}

     //     if  0      < Hauteur
     //then
     //    Lumiere_Solaire:= 255
     //else if Hauteur < -_18_degres_en_radians
     //then
     //    Lumiere_Solaire:= 0
     //else
     //    Lumiere_Solaire:= Trunc( (1+Hauteur/_18_degres_en_radians)*255);

     //Soleil_Couche:= Hauteur <= -0.10;
end;

function T_Soleil.GetMS: Extended; begin GetMS := MS ; end;
function T_Soleil.GetLS: Extended; begin GetLS := LS ; end;
function T_Soleil.GetXS: Extended; begin GetXS := XS ; end;
function T_Soleil.GetYS: Extended; begin GetYS := YS ; end;
function T_Soleil.GetEP: Extended; begin GetEP := EP ; end;
function T_Soleil.GetgP: Extended; begin GetgP := gP ; end;
function T_Soleil.GetgL0: Extended; begin GetgL0:= gL0; end;
function T_Soleil.GetgB0: Extended; begin GetgB0:= gB0; end;
function T_Soleil.Getnro: Extended; begin Getnro:= nro; end;
//function T_Soleil.GetLetter: Char; begin GetLetter:= 'S'; end;

procedure NormaliseADDe( var A,D: Extended);
begin
     if D<-PI/2 then begin D:=-PI-D;A:=PI+A;end;
     if D>+PI/2 then begin D:=+PI-D;A:=PI+A;end;
     if A>2*PI  then A:= A-2*PI;
end;

end.

