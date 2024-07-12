unit uDate;

{$mode Delphi}

interface

// Calculs d'aprés le livre Astronomical Algorithms de Jean MEEUS
uses
    uPublieur,
    uuStrings,
    uDataUtilsU,
 Classes, SysUtils, Math;

const
     MaxModuleAnnee= 10000;
     // limite purement empirique non liée à la précision des calculs
     // au delà on peut avoir des erreurs sur les nombres flottants.
const
     Jour_sur_Jour_sideral= 1.00273790935;//MEEUS p 83
     Jour_Sideral= 1/Jour_sur_Jour_sideral;
     Duree_Lunaison= 29.530588853;// MEEUS p 319

type
  { T_Date }

  T_Date {s"initialise en heure légale, donne les résultats en TU}
  =
   class
   //Gestion du cycle de vie
   protected
     procedure Init;virtual;
   public
     constructor Create;
     destructor Destroy; override;
   //constructeur de copie
   public
     constructor Create_From( _Date: T_Date);
     procedure Copy_From( _Date: T_Date); virtual;
   //attributs
   public
     Calcul_Automatique: Boolean;
     Modify: TPublieur;
   //méthodes d'initialisation
   public
     procedure Set_to_Datetime( _d: TDatetime);

     procedure Set_from_computer_date;
     {initialisation à partir de l"heure donnée par MS-DOS. Appelle Set_To}

     function Set_to_S( _sDat, _sHe: String): Byte;{0:OK, 1:Mauvaise sHe, 2:... sDat}

     procedure Set_to(_aa,_mm,Unjj, _he, _mi: Integer; _SS: Extended);
     {initialisation à partir d"une heure donnée}
     {cette procédure est appelée par les deux constructeurs précédents et par Set_to_computer}
     {Appelle Calcul}

   //Annee
   protected
     FAnnee: Integer;
     procedure Set_Annee( _Value: Integer);
     function Get_sAnnee: String;
   public
     function CheckAnnee: Boolean;
     property Annee: Integer read FAnnee write Set_Annee;
     property sAnnee: String read Get_sAnnee;
   //Mois
   protected
     FMois: Integer;
     procedure Set_Mois( _Value: Integer);
   public
     property Mois: Integer read FMois write Set_Mois;
     function sMois: String;
   //Lunaison
   public
     procedure LunaisonSuivante;
     procedure LunaisonPrecedente;
   //Jour
   protected
     FJour: Integer;
     procedure Set_Jour( _Value: Integer);
     function Get_sJour: String;
   public
     procedure Set_Jour_0h( _Jour: Integer);
     procedure CheckDay;
     property  Jour: Integer read FJour write Set_Jour;
     property sJour: String read Get_sJour;
   //Heures
   protected
     FHeures: Integer;
     procedure Set_Heures( _Value: Integer);
   public
     property Heures: Integer read FHeures write Set_Heures;
   //Minutes
   protected
     FMinutes: Integer;
     procedure Set_Minutes( _Value: Integer);
     function Get_sMinutes: String;
   public
     property Minutes: Integer read FMinutes write Set_Minutes;
     property sMinutes: String read Get_sMinutes;
   //Secondes
   protected
     FSecondes: Extended;
     procedure Set_Secondes( _Value: Extended);
   public
     property Secondes: Extended  read FSecondes write Set_Secondes;
   //Fraction_Jour
   protected
     FFraction_Jour: Extended;
   public
     property  Fraction_Jour: Extended read FFraction_Jour;
   //FJour sidéral
   public
     procedure JourSideralPrecedent;
     procedure JourSideralSuivant;
   //Jour_Julien
   protected
     FJour_Julien: Extended;
     function GetsJour_Julien: String;
   public
     procedure From_Jour_Julien;
     procedure To_Jour_Julien;
     procedure Set_Jour_Julien_To( _jd: Extended);
     procedure Add_To_Julian_Date( _DeltaJD: Extended);
     property Jour_Julien: Extended read FJour_Julien ;
     property sJour_Julien: String read GetsJour_Julien;
   //inCalcul
   protected
     inCalcul: Boolean;
   //sDate
   protected
     function Get_sDate: String;
   public
     property sDate: String read Get_sDate;
   //sHeure
   protected
     function Get_sHeure: String;
   public
     property sHeure: String read Get_sHeure;
   //Divers
   public
     function AsDateTime: TDateTime;
     function AsDateSQL_ISO8601: String;
     function AsDateTimeSQL_sans_quotes: String;
     function EteHiver_: Boolean;
     function JourSem: String;
     function Jour_de_l_annee: Integer;
     function Bissextile: Boolean;
     procedure Log( _Prefix: String); virtual;
   end;

// Ceci est utilisé pour la date de passage au périhélie des comètes avec le jour
// calendaire est exprimé en décimal
procedure Date_From_JourJulien( var _JJ: Extended; var _MM,_AAAA: Integer;
                                _JD: Extended);
function JourJulien_From_Date( _JJ: Extended; _MM,_AAAA: Integer): Extended;


implementation

{  T_Date  }

procedure T_Date.Init;
begin
     inCalcul:= False;
     Calcul_Automatique:= True;
     Modify:= TPublieur.Create( ClassName+'.Modify');
     FAnnee:= 2000;
     FMois:= 1;
     FJour:= 1;
     FHeures:= 0;
     FMinutes:= 0;
     FSecondes:= 0;
     FFraction_Jour:= 0;
     FJour_Julien:= 2451545.0;
end;

destructor T_Date.Destroy;
begin
     FreeAndNil( Modify);
     inherited Destroy;
end;


constructor T_Date.Create;
begin
     inherited Create;
     Init;
end;

procedure T_Date.Set_to_Datetime( _d: TDatetime);
var
   wAn, wMois, wJour,
   wHeure, wMinutes, wSecondes, msec    :word;
begin
     DecodeDate( _d, wAn, wMois, wJour);
     DecodeTime( _d, wHeure, wMinutes, wSecondes, msec);
     Set_To( wAn, wMois, wJour, wHeure, wMinutes, wSecondes+msec/1000.0);
end;

procedure T_Date.Set_from_computer_date;
begin
     Set_to_Datetime( Now);
end;

function T_Date.AsDateTime: TDateTime;
begin
     Result:= EncodeDate( Annee, Mois, Jour)+EncodeTime( Heures, Minutes, Trunc(Secondes), Trunc(Frac(Secondes)*1000));
end;

function T_Date.AsDateSQL_ISO8601: String;
begin
     Result:= DateSQL_ISO8601( AsDateTime);
end;

function T_Date.AsDateTimeSQL_sans_quotes: String;
begin
     Result:= DateTimeSQL_sans_quotes( AsDateTime);
end;

function T_Date.EteHiver_: Boolean;
var
   D: TDateTime;
   Borne: TDateTime;
   //sD, sBorne: String;
   function DernierDimanche( _D: TDateTime): TDateTime;
   begin
        Result:=Trunc(_D)-DayOfWeek(_D)+1;
   end;
begin
          if (Mois <  3)or (10 < Mois) then Result:= False//aprés octobre et avant mars
     else if ( 3 < Mois)and(Mois < 10) then Result:= True //aprés mars et avant octobre
     else //çà se complique
         case Mois
         of
           3:
             begin
             Borne //dernier dimanche de mars à 1h du matin
             :=
                DernierDimanche( EncodeDate( Annee, 03, 31))
               +EncodeTime( 1,0,0,0);
             D:= AsDateTime;
             //sD    := FormatDateTime( 'dddddd tt',D);
             //sBorne:= FormatDateTime( 'dddddd tt',Borne);
             Result:= D > Borne;
             end;
           10:
             begin
             Borne //dernier dimanche de octobre à 1h du matin
             :=
                DernierDimanche( EncodeDate( Annee, 10, 31))
               +EncodeTime( 1,0,0,0);
             D:= AsDateTime;
             //sD    := FormatDateTime( 'dddddd tt',D);
             //sBorne:= FormatDateTime( 'dddddd tt',Borne);
             Result:= D < Borne;
             end;
           else
               begin
               //Erreur impossible
               end;
           end;
end;

constructor T_Date.Create_From( _Date: T_Date);
begin
     inherited Create;
     Init;
     Copy_From( _Date);
end;

procedure T_Date.Copy_From( _Date: T_Date);
begin
     if _Date <> NIL
     then
         begin
         FAnnee             := _Date.FAnnee             ;
         FMois              := _Date.FMois              ;
         FJour              := _Date.FJour              ;
         FHeures            := _Date.FHeures            ;
         FMinutes           := _Date.FMinutes           ;
         FFraction_Jour     := _Date.FFraction_Jour     ;
         FJour_Julien      := _Date.FJour_Julien      ;
         inCalcul          := _Date.inCalcul          ;
         end;
end;

function T_Date.Set_to_S( _sDat, _sHe: String): Byte;
var
   strJJ,strMM,strHE,strMI: String[2];
   strAA            : String[4];
begin
     Result:= 2;

     strJJ:= _sDat;
     if not TryStrToInt( strJJ, FJour) then exit;
     if FJour>31                       then exit;

     strMM:=Copy( _sDat,4,2);
     if not TryStrToInt( strMM, FMois) then exit;
     if FMois>12                       then exit;

     strAA:= Copy( _sDat, 7,4);
     if not TryStrToInt( strAA, FAnnee) then exit;
     CheckAnnee; //restriction sur l'année désactivée

     Result:= 1;

     strHE:= _sHe;
     if not TryStrToInt( strHE, FHeures) then exit;
     if FHeures>23                       then exit;

     strMI:= Copy( _sHe, 4,2);
     if not TryStrToInt( strMI, FMinutes) then exit;
     if FMinutes>59                       then exit;

     FSecondes:= 0;

     Result:= 0;

     To_Jour_Julien;
end;


procedure T_Date.Set_to( _aa,_mm,Unjj, _he, _mi: Integer; _SS: Extended);
begin
     FAnnee:= _aa; CheckAnnee;

     FMois    := _mm; FJour:= Unjj;
     FHeures  := _he; FMinutes:= _mi;
     FSecondes:= _SS;
     To_Jour_Julien;
end;

procedure T_Date.Set_Jour_0h( _Jour: Integer);
begin
     FJour    := _Jour;
     FHeures  := 0;
     FMinutes := 0;
     FSecondes:= 0;
     To_Jour_Julien;
end;

function T_Date.Get_sDate:String;
var
   strAA: String;
   strMM, strJJ: String;
begin
     if FAnnee <= 0
     then
         // D'aprés MEEUS A_s_t_r_o_n_o_m_i_c_a_l__A_l_g_o_r_i_t_h_m_s , p 60
         //Année Historique   Année Astronomique
         //  585 AVJC       =     -584
         begin
         Str((1-FAnnee):4, strAA);
         strAA:= strAA + ' AVJC';
         end
     else
         Str(FAnnee:4, strAA);
     Str(FMois:2,strMM);if strMM[1]=' ' then strMM[1]:='0';
     Str(FJour:2,strJJ);if strJJ[1]=' ' then strJJ[1]:='0';
     Result:= strJJ+'-'+strMM+'-'+strAA;
end;

function T_Date.Get_sHeure:String;
begin
     Result:= Format( '%.2d:%.2d:%s', [FHeures,FMinutes,Fixe_Min0( Format('%.2f',[FSecondes]),5)]);
end;

function JourJulien_From_Date( _JJ: Extended; _MM,_AAAA: Integer): Extended;
var
   a,b    : Real;
begin
     if _MM<3 then begin Inc( _MM, 12); Dec( _AAAA);end;
     a:=Floor(_AAAA/100);
     b:=2-a+Floor(a/4);
     if( _AAAA <  1582) then B:= 0;
     if( _AAAA <= 1582) and (_MM < 10 ) then B:= 0;
     if( _AAAA <= 1582) and (_MM = 10) and (_JJ < 15 ) then B:= 0;
     Result:=Floor(365.25*(_AAAA+4716))+Floor(30.6001*(_MM+1))+b-1524.5+_JJ;
end;

procedure T_Date.To_Jour_Julien;
var
   nMois,nAnnee: Integer;
   A,B    : Extended;
begin
     if inCalcul then exit;
     inCalcul:= True;
     try
        FFraction_Jour:=(FHeures+(FMinutes+FSecondes/60)/60)/24;

        if FMois > 2
        then
            begin
            nMois:= FMois;
            nAnnee:= FAnnee;
            end
        else
            begin
            nMois:= FMois+12;
            nAnnee:= FAnnee-1;
            end;

        A:= Floor( nAnnee / 100); // Int( nAnnee/100); suite à une remarque de Free Pascal
        B:=2-A+Floor( A/4);

        //#modif pour cyclage To_Jour_Julien / From_Jour_Julien
        // avant on restait toujours en grégorien dans To_Jour_Julien,
        // alors que From_Jour_Julien gère le passage du Julien au Grégorien
        if( FAnnee <  1582) then B:= 0;
        if( FAnnee <= 1582) and (FMois < 10 ) then B:= 0;
        if( FAnnee <= 1582) and (FMois = 10) and (FJour < 15 ) then B:= 0;
        //~modif pour cyclage To_Jour_Julien / From_Jour_Julien


        FJour_Julien
        :=
          Floor( 365.25 *(nAnnee+4716))
         +Floor( 30.6001*(nMois+1   ))
         + b-1524.5 + FJour + FFraction_Jour;
        CheckDay;
     finally
            inCalcul:= False;
            end;
     Modify.Publie;
end;

procedure T_Date.Set_Jour_Julien_To( _jd: Extended);
begin
     FJour_Julien:= _jd;
     From_Jour_Julien;
end;

procedure Date_From_JourJulien( var _JJ: Extended; var _MM,_AAAA: Integer;
                                _JD: Extended);
var
   z,f,alpha,a,b,d        : Extended;
   c,e: Integer;
   jd05: Extended;
begin
     jd05:= _JD+0.5;
     z:= Floor(jd05);
     f:= jd05-Z;

     a:=z;

     if z>=2299161
     then
         begin
         alpha:=Floor((z-1867216.25)/36524.25);
         a:=z+1+alpha-Floor(alpha/4);
         end;

     b:=a+1524;
     c:=Floor((b-122.1)/365.25);
     d:=Floor(365.25*c);
     e:=Floor((b-d)/30.6001);

     _JJ:=b-d-Floor(30.6001*e)+f;

     _MM:=e-1;

     if e>13.5 then _MM:=e-13;

     _AAAA:=c-4716;

     if _MM<2.5 then _AAAA:=c-4715;

     if _AAAA<1 then _AAAA:=_AAAA-1;
end;

procedure T_Date.From_Jour_Julien;
var
   Z,F,A, B, D: Extended;
   C: Integer;
   E: Integer;
   DD            : Extended;    {FJour décimal}
   Alpha: Extended;
   jd05: Extended;
begin
     jd05:= FJour_Julien+0.5;

     Z:= Floor( jd05);
     F:= jd05 - Z;

     if Z < 2299161
     then
         A:=Z
     else
         begin
         Alpha:= Floor( (Z-1867216.25)/36524.25);
         A    := Z+1+Alpha-Floor( Alpha/4);
         end;

     B:= A+1524;

     C:= Floor( (B-122.1)/365.25);

     D:= Floor( 365.25*C);

     E:= Floor( (B-D)/30.6001);

     DD:= B-D-Floor( 30.6001*e)+f;

     if E < 14
     then
         FMois:= E-1
     else // if (E= 14) or (E=15)
         FMois:= E - 13;

     if  FMois > 2
     then
         FAnnee:= C - 4716
     else // if (FMois=1) or (FMois=2)
         FAnnee:= C - 4715;

     FJour:=Floor(dd);
     dd:= dd-FJour;
     FFraction_Jour:= dd;
     dd:= dd * 24;
     FHeures:=Floor(dd);
     dd:= (dd-FHeures)*60;
     FMinutes:=Floor( dd);
     FSecondes:= (dd-FMinutes)*60;

     if not inCalcul
     then
         if CheckAnnee
         then
             To_Jour_Julien
         else
             Modify.Publie;
end;

procedure T_Date.Add_To_Julian_Date( _DeltaJD: Extended);
begin
     FJour_Julien:= FJour_Julien+_DeltaJD;
     From_Jour_Julien;
end;

function T_Date.GetsJour_Julien: String;
begin
     Result:= FormatFloat('0,000,000.0000000000',FJour_Julien);
end;

function T_Date.sMois: String;
const
     tag_mmstr: array[0..11] of
     {$IFDEF WIN32}
     String
     {$ELSE}
     PChar
     {$ENDIF}
     =
      ('Janvier','Février','Mars','Avril','Mai','Juin',
       'Juillet','Août','Septembre','Octobre','Novembre',
       'Décembre');
begin
     Result:= tag_mmstr[FMois-1];
end;

function T_Date.JourSem: String;
const
     jsem: array[0..6] of String
     =
      ('Lun','Mar','Mer','Jeu','Ven','Sam','Dim');
var
   z: Integer;
   x: Extended;
begin
     x:=FJour_Julien-2415020-FFraction_Jour-0.4995;
     z:=trunc(frac(x/7)*7);
     if z=7 then z:=0;
     JourSem:=jsem[z];
end;

function T_Date.Bissextile: Boolean;
begin
     Result
     :=
          (( FAnnee mod 4   =  0) and ( FAnnee mod 100 <> 0))
       or  ( FAnnee mod 400 =  0);
end;

function T_Date.Get_sAnnee:String;
var
   S: String;
begin
     str( FAnnee:4, S);
     Result:= S;
end;

function T_Date.Get_sJour: String;
var
   S: String;
begin
     str( FJour:2, S);
     Result:= S;
end;

function T_Date.Get_sMinutes: String;
var
   S: String;
begin
     str( FMinutes:2, S);
     if S[1]=' ' then S[1]:= '0';
     Result:= S;
end;

function T_Date.Jour_de_l_annee: Integer;
var
   ja: Integer;
begin
     if FMois<3
     then
         ja:=round(30.6001*(FMois-1))+FJour
     else
         begin
         ja:=59+round(30.6001*(FMois-3))+FJour;
         if Bissextile then ja:=ja+1;
         end;
     Jour_de_l_annee:= ja;
end;

procedure T_Date.Set_Annee( _Value: Integer);
begin
     if FAnnee <> _Value
     then
         begin
         FAnnee:= _Value;
         CheckAnnee;
         if Calcul_Automatique then To_Jour_Julien;
         end;
end;

// procedure "durcie" pour accepter un mois supérieur à 12
// venant de ufEdite_Mois lors de l'ajout d'un certain nombre de mois.
procedure T_Date.Set_Mois( _Value: Integer);
begin
     if FMois <> _Value
     then
         begin
         FMois:= _Value;

         while FMois <= 0
         do
           begin
           Dec(FAnnee);
           Inc( FMois, 12);
           end;

         while FMois > 12
         do
           begin
           Inc(FAnnee);
           Dec( FMois, 12);
           end;
         if Calcul_Automatique then To_Jour_Julien;
         end;
end;

procedure T_Date.Set_Jour( _Value: Integer);
begin
     if FJour <> _Value
     then
         begin
         FJour:= _Value;
         if Calcul_Automatique then To_Jour_Julien;
         end;
end;

procedure T_Date.Set_Heures( _Value: Integer);
begin
     if FHeures <> _Value
     then
         begin
         FHeures:= _Value;
         if Calcul_Automatique then To_Jour_Julien;
         end;
end;

procedure T_Date.Set_Minutes( _Value: Integer);
begin
     if FMinutes <> _Value
     then
         begin
         FMinutes:= _Value;
         if Calcul_Automatique then To_Jour_Julien;
         end;
end;

procedure T_Date.Set_Secondes( _Value: Extended);
begin
     if FSecondes <> _Value
     then
         begin
         FSecondes:= _Value;
         if Calcul_Automatique then To_Jour_Julien;
         end;
end;

procedure T_Date.CheckDay;
const
     nbj: array[1..12] of Byte {nombre de jours des mois}
     =
     (31,28,31,30,31,30,31,31,30,31,30,31);
var
   Day_per_Month: Integer;
begin
     if FMois = 2
     then
         if Bissextile
         then
             Day_per_Month:= 29
         else
             Day_per_Month:= 28
     else
         Day_per_Month:= nbj[FMois];

     if FJour > Day_per_Month then From_Jour_Julien;
end;

procedure T_Date.LunaisonSuivante;
begin
     Add_To_Julian_Date( Duree_Lunaison);
end;

procedure T_Date.LunaisonPrecedente;
begin
     Add_To_Julian_Date( -Duree_Lunaison);
end;

procedure T_Date.JourSideralPrecedent;
begin
     Add_To_Julian_Date( -Jour_Sideral);
end;

procedure T_Date.JourSideralSuivant;
begin
     Add_To_Julian_Date( +Jour_Sideral);
end;


function T_Date.CheckAnnee: Boolean;
begin
     if Abs(FAnnee) > MaxModuleAnnee
     then
         begin
         Result:= True;
         if FAnnee < 0
         then
             FAnnee:= -MaxModuleAnnee
         else
             FAnnee:= +MaxModuleAnnee;
         end
     else
         Result:= False;
end;

procedure T_Date.Log( _Prefix: String);
begin
     WriteLn( _Prefix+' Date       : ', sDate       );
     WriteLn( _Prefix+' Heure      : ', sHeure      );
     WriteLn( _Prefix+' Jour Julien: ', sJour_Julien);
end;

end.

