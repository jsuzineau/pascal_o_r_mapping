unit uTemps;

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
 Classes, SysUtils, Math;

type
  T_Temps {s"initialise en heure légale, donne les résultats en TU}
  =
   class( TObject)
   //Gestion du cycle de vie
   public
     constructor Create( _Lieu: TLieu;_LieuOrdinateur: TLieu);
     destructor Destroy; override;

     constructor Create_From( _Temps: T_Temps; _Lieu: TLieu; _LieuOrdinateur: TLieu);
     procedure Copy_From( _Temps: T_Temps);

     procedure Init(_Lieu: TLieu; _LieuOrdinateur: TLieu);

   {Penser à modifier Copy_From si rajout de champs (utilisation de Move)}
   protected{Ceci empêche de modifier directement les champs sans mise à jour}
            {globale, ce qui peut être source de bogues difficiles à déceler.}
            {ce qui suit dans cette déclaration n"est accessible que dans les}
            { routines de cette unité.(=déclaration en partie IMPLEMENTATION.}
     Lieu: TLieu;
     LieuOrdinateur: TLieu;

     inCalcul          : Boolean;
     procedure TLOChange;
     procedure TLChange;
     procedure TUChange;
     procedure TDChange;
     procedure TLO_to_TL;
     procedure TL_to_TLO;
     procedure TL_to_TU;
     procedure TU_to_TD;
     procedure TD_to_TU;
     procedure TU_to_TL;
     function DeltaT_en_jours(_JD: Extended): Extended; {bascule et renvoie l"ancien}
   public
     Modify: TPublieur;
     TLO: T_Date;           // Legal     time de l'ordinateur
     TL : T_Date;            // Legal     time
     TU : T_Date;            // Universal time
     TD : T_Date_Ephemerides;// Dynamical time
     DeltaT_en_secondes: Extended; // TD-TU

   //HeureEte
   public
     HeureEte: Boolean;

     function SetHeureEte( _HeureEte: Boolean): Boolean;{True si changement}
     function ToggleHeureEte: Boolean;
   //Log
   public
     procedure Log( _Prefix: String);
   end;

implementation

constructor T_Temps.Create( _Lieu: TLieu;_LieuOrdinateur: TLieu);
begin
     inherited Create;
     Init( _Lieu, _LieuOrdinateur);
end;

destructor T_Temps.Destroy;
begin
     TLO.Modify                 .Desabonne( Self, TLOChange    );
     TL .Modify                 .Desabonne( Self, TLChange     );
     TU .Modify                 .Desabonne( Self, TUChange     );
     TD .Modify                 .Desabonne( TD  , TD.DateChange);
     TD .Date_Ephemerides_Modify.Desabonne( Self, TDChange     );

     FreeAndNil( TLO   );
     FreeAndNil( TL    );
     FreeAndNil( TU    );
     FreeAndNil( TD    );
     FreeAndNil( Modify);
     inherited Destroy;
end;

constructor T_Temps.Create_From( _Temps: T_Temps; _Lieu: TLieu; _LieuOrdinateur: TLieu);
begin
     inherited Create;
     Init( _Lieu, _LieuOrdinateur);
     Copy_From( _Temps);
end;

procedure T_Temps.Init( _Lieu: TLieu; _LieuOrdinateur: TLieu);
begin
     Lieu          := _Lieu;
     LieuOrdinateur:= _LieuOrdinateur;

     TLO:= T_Date.Create;
     TL := T_Date.Create;
     TU := T_Date.Create;
     TD := T_Date_Ephemerides.Create;
     Modify:= TPublieur.Create( ClassName+'.Modify');

     TLO.Modify                 .Abonne( Self, TLOChange    );
     TL .Modify                 .Abonne( Self, TLChange     );
     TU .Modify                 .Abonne( Self, TUChange     );
     TD .Modify                 .Abonne( TD  , TD.DateChange);
     TD .Date_Ephemerides_Modify.Abonne( Self, TDChange     );

     inCalcul:= False;
end;

procedure T_Temps.Copy_From( _Temps: T_Temps);
begin
     if _Temps <> NIL
     then
         begin
         inCalcul := _Temps.inCalcul ;
         TLO.Copy_From( _Temps.TLO);
         TL .Copy_From( _Temps.TL);
         TU .Copy_From( _Temps.TU);
         TD .Copy_From( _Temps.TD);
         end;
end;

function T_Temps.SetHeureEte( _HeureEte: Boolean): Boolean;
begin
     if HeureEte <> _HeureEte
     then
         begin
         HeureEte:= _HeureEte;
         TLChange;
         Result:= True;
         end
     else
         Result:= False;
end;

function T_Temps.ToggleHeureEte: Boolean;
begin
     Result:= HeureEte;
     HeureEte:= not HeureEte;
     TLChange;
end;

procedure T_Temps.TLO_to_TL;
var
   jd: Extended;
   Delta: Extended;
begin
     jd:= TLO.Jour_Julien;

     {Prise en compte du fuseau horaire}
     Delta:=   Lieu          .Decalage_Heure_Locale
             - LieuOrdinateur.Decalage_Heure_Locale;
     jd:= jd + Delta / 24 ;

     {Prise en compte de l"heure d"été ......}
     Delta:=   Lieu          .Decalage_Heure_Ete
             - LieuOrdinateur.Decalage_Heure_Ete;
     if HeureEte
     then
         jd:= jd + Delta / 24 ;

     TL.Set_Jour_Julien_to( jd);
end;

procedure T_Temps.TL_to_TLO;
var
   jd: Extended;
   Delta: Extended;
begin
     jd:= TL.Jour_Julien;

     {Prise en compte du fuseau horaire}
     Delta:=   LieuOrdinateur.Decalage_Heure_Locale
             - Lieu          .Decalage_Heure_Locale;
     jd:= jd + Delta / 24 ;

     {Prise en compte de l"heure d"été ......}
     Delta:=   LieuOrdinateur.Decalage_Heure_Ete
             - Lieu          .Decalage_Heure_Ete;
     if HeureEte
     then
         jd:= jd + Delta / 24 ;

     TLO.Set_Jour_Julien_to( jd);
end;

procedure T_Temps.TL_to_TU;
var
   jd: Extended;
begin
     jd:= TL.Jour_Julien;

     {Prise en compte du fuseau horaire}
     jd:= jd - Lieu.Decalage_Heure_Locale/24 ;

     {Prise en compte de l"heure d"été ......}
     if HeureEte
     then
         jd:=jd-Lieu.Decalage_Heure_Ete/24;

     TU.Set_Jour_Julien_to( jd);
end;

procedure T_Temps.TU_to_TL;
var
   jd: Extended;
begin
     jd:= TU.Jour_Julien;

     {Prise en compte du fuseau horaire}
     jd:= jd + Lieu.Decalage_Heure_Locale/24 ;

     {Prise en compte de l"heure d"été ......}
     if HeureEte
     then
         jd:=jd+Lieu.Decalage_Heure_Ete/24;

     TL.Set_Jour_Julien_to( jd);
end;

// Calcul de TD-TU, cas général, _Astronomical_Algorithms_, MEEUS, p73
function T_Temps.DeltaT_en_jours( _JD: Extended): Extended;
begin
     DeltaT_en_secondes:= -15+ sqr(_JD-2382148)/41048480;

     Result:= (DeltaT_en_secondes/3600) /24;
end;

procedure T_Temps.TU_to_TD;// calcul du Temps Dynamique
var
   JD: Extended;
begin
     JD:= TU.Jour_Julien;
     TD.Set_Jour_Julien_To( JD+DeltaT_en_jours(JD));
end;

// remarque: DeltaT varie trés lentement, prendre JD en TU ou en TD n'amène pas
// de grosse modification DeltaT( TU.JD) ~ DeltaT( TU.JD+DeltaT )
procedure T_Temps.TD_to_TU;
var
   JD: Extended;
begin
     JD:= TD.Jour_Julien;
     TU.Set_Jour_Julien_To( JD-DeltaT_en_jours(JD));
end;

procedure T_Temps.TLOChange;
begin
     if inCalcul then exit;
     inCalcul:= True;
     try
        TLO_to_TL;
        TL_to_TU;
        TU_to_TD;
     finally
            inCalcul:= False;
            end;
     Modify.Publie;
end;

procedure T_Temps.TLChange;
begin
     if inCalcul then exit;
     inCalcul:= True;
     try
        TL_to_TLO;
        TL_to_TU;
        TU_to_TD;
     finally
            inCalcul:= False;
            end;
     Modify.Publie;
end;

procedure T_Temps.TUChange;
begin
     if inCalcul then exit;
     inCalcul:= True;
     try
        TU_to_TD;
        TU_to_TL;
        TL_to_TLO;
     finally
            inCalcul:= False;
            end;
     Modify.Publie;
end;

procedure T_Temps.TDChange;
begin
     if inCalcul then exit;
     inCalcul:= True;
     try
        TD_to_TU;
        TU_to_TL;
        TL_to_TLO;
     finally
            inCalcul:= False;
            end;
     Modify.Publie;
end;

procedure T_Temps.Log( _Prefix: String);
begin
     TLO.Log( _Prefix+' TLO:'); // Legal     time de l'ordinateur
     TL .Log( _Prefix+' TL :'); // Legal     time
     TU .Log( _Prefix+' TU :'); // Universal time
     TD .Log( _Prefix+' TD :'); // Dynamical time
end;

end.

