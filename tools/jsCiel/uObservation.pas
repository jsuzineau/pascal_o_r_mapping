unit uObservation;

{$mode Delphi}

interface

uses
    uPublieur,
    uuStrings,
 Classes, SysUtils, Math;

type

  { T_Coordonnee }

  T_Coordonnee
  =
   class
   private
     //FLatLon_ True: type Latitude -90..+90; False: Longitude -180..+180
     FLatLon_: Boolean;
     FStr: String;
     FSign, FDeg, FMin, FSec: Integer;
     FDegres, FRadians: Extended;
     procedure Set_Degres ( Value: Extended);
     procedure Set_Radians( Value: Extended);

     function  String_to_Sexagesimal: Byte;
     procedure Sexagesimal_to_String;
     procedure Sexagesimal_to_Degres;
     procedure Degres_to_Sexagesimal;
     procedure Degres_to_Radians;
     procedure Radians_to_Degres;

     function Check_Radians: Boolean;
     function Check_Degres: Boolean;
     function Check_Sexagesimal: Byte;

     procedure doModify;
   public
     Modify: TPublieur;
     sinus, cosinus: Extended;

     //procedure appelée par la latitude si l'on dépasse 90° en valeur absolue
     // dans ce cas on fait un demi tour en longitude et l'on recalcule la latitude
     Longitude_from_LatitudeOverflow: TAbonnement_Objet_Proc; // pour la coordonnée latitude
     procedure Retournement_Longitude;                  // pour la coordonnée longitude, le lien est fait par le lieu

     constructor Create( _LatLon_: Boolean);
     destructor Destroy; override;
     procedure Copy_From( uneCoordonnee: T_Coordonnee);
     function Set_To(aSign, aDeg, aMin, aSec: Integer): Byte;
     function Set_Str(Value: String): Byte;
     property LatLon_: Boolean read FLatLon_;
     property Str    : String  read FStr;
     property Sign   : integer read FSign;
     property Deg    : integer read FDeg;
     property Min    : Integer read FMin;
     property Sec    : Integer read FSec;
     property Degres : Extended  read FDegres  write Set_Degres ;
     property Radians: Extended  read FRadians write Set_Radians;
     procedure Add_km( Delta_en_km: Extended);
     procedure Nouveau;
   end;

  { TObservation }

  TObservation
  =
   class
   //Gestion du cycle de vie
   public
     constructor Create;
     destructor Destroy; override;
   //Attributs
   public
     latitude : T_Coordonnee;
     longitude: T_Coordonnee;
     d: TDateTime;
     procedure Log(_Prefix: String);
   end;

implementation

{ T_Coordonnee }

constructor T_Coordonnee.Create( _LatLon_: Boolean);
begin
     FLatLon_:= _LatLon_;
     Modify:= TPublieur.Create(ClassName+'.Modify');
     Longitude_from_LatitudeOverflow:= nil;
end;

destructor T_Coordonnee.Destroy;
begin
     FreeAndNil(Modify);
     inherited Destroy;
end;


const
     DegSize: array[False..True] of Byte = (4,3); // LatLon_
     MinSize= 3;
     SecSize= 3;
// 4: signe incorrect, 3: deg incorrect, 2: Min incorrect 1: Sec incorrect
// 0: OK
function T_Coordonnee.String_to_Sexagesimal: Byte;
var
   sSign, sDeg, sMin, sSec: String;
   S: String;
   cSign: Char;
begin
     S:= FStr;
     sSign:= StrReadString( S, 1);
     cSign:= sSign[1];

     sDeg:= StrReadString( S, DegSize[FLatLon_]);

     sMin:= StrReadString( S, MinSize);
     sSec:= StrReadString( S, SecSize);

     Delete( sDeg, DegSize[FLatLon_], 1);
     Delete( sMin, MinSize          , 1);
     if sSec = ''
     then
         sSec:= '0'
     else
         Delete( sSec, SecSize, 1);

     Result:= 4; if (cSign <> '-') and (cSign <> '+') then exit;

     Result:= 3; if not IsInt( sDeg) then exit;

     Result:= 2; if not IsInt( sMin) then exit;

     Result:= 1; if not IsInt( sSec) then exit;

     Result:= 0;

     case sSign[1]
     of
       '-': FSign:= -1;
       '+': FSign:= +1;
       end;
     FDeg:= StrToInt( sDeg);
     FMin:= StrToInt( sMin);
     FSec:= StrToInt( sSec);
end;

procedure T_Coordonnee.Sexagesimal_to_String;
var
   sSign, sDeg, sMin, sSec: String;
begin
     if FSign < 0
     then
         sSign:= '-'
     else
         sSign:= '+';

     sDeg:= IntToStr(FDeg)+'°';
     while Length(sDeg) < DegSize[LatLon_] do sDeg:= ' '+sDeg;

     sMin:= IntToStr(FMin)+ '''';
     while Length(sMin) < 3 do sMin:= ' '+sMin;

     sSec:= IntToStr(FSec)+'"';
     while Length(sSec) < 3 do sSec:= ' '+sSec;

     FStr:= sSign+sDeg+sMin+sSec;
end;

procedure T_Coordonnee.Sexagesimal_to_Degres;
begin
     FDegres:= FSign*(FDeg+(FMin+FSec/60.0)/60.0);
end;

procedure T_Coordonnee.Degres_to_Sexagesimal;
var
   d: Extended;
begin
     if FDegres < 0
     then
         begin
         FSign:= -1;
         d:= -FDegres;
         end
     else
         begin
         FSign:= +1;
         d:= FDegres;
         end;
     FDeg:= Trunc(d);
     d:= (d - FDeg) * 60;
     FMin:= Trunc(d);
     d:= (d - FMin) * 60;
     FSec:= Trunc( d);
end;

procedure T_Coordonnee.Degres_to_Radians;
begin
     FRadians:= FDegres * PI /180;
end;

procedure T_Coordonnee.Radians_to_Degres;
begin
     FDegres:= FRadians * 180 / PI;
end;

procedure T_Coordonnee.Set_Degres(Value: Extended);
begin
     if FDegres = Value then exit;
     FDegres:= Value;
     Check_Degres;
     Degres_to_Radians;
     Degres_to_Sexagesimal;Sexagesimal_to_String;
     doModify;
end;

procedure T_Coordonnee.Set_Radians(Value: Extended);
begin
     if FRadians = Value then exit;
     FRadians:= Value;
     Check_Radians;
     Radians_to_Degres; Degres_to_Sexagesimal; Sexagesimal_to_String;
     doModify;
end;

function T_Coordonnee.Set_To(aSign, aDeg, aMin, aSec: Integer): Byte;
begin
     Result:= 0;
     if (Sign = aSign) and (Deg = aDeg) and (Min = aMin) and (Sec = aSec) then exit;

     FSign:= aSign;
     FDeg:= aDeg;
     FMin:= aMin;
     FSec:= aSec;

     Sexagesimal_to_Degres;
     if Check_Degres
     then
         begin
         Result:= Check_Sexagesimal;
         Radians_to_Degres;
         Degres_to_Sexagesimal;
         exit;
         end;

     Degres_to_Radians;
     Sexagesimal_to_String;
     doModify;
end;

function T_Coordonnee.Set_Str(Value: String): Byte;
begin
     Result:= 0;
     if FStr = Value then exit;
     FStr:= Value;

     Result:= String_to_Sexagesimal;
     if Result > 0
     then
         begin
         Sexagesimal_to_String;
         exit;
         end;

     Sexagesimal_to_Degres;
     if Check_Degres
     then
         begin
         Result:= Check_Sexagesimal;
         Radians_to_Degres;

         Degres_to_Sexagesimal;
         Sexagesimal_to_String;
         exit;
         end;

     Degres_to_Radians;
     doModify;
end;

function T_Coordonnee.Check_Sexagesimal: Byte;
begin
     Result:= 4; if abs(FSign) <> 1 then exit;
     if LatLon_
     then
         begin
         Result:= 3; if (FDeg < 0)or( 89 < FDeg ) then exit;
         end
     else
         begin
         Result:= 3; if (FDeg < 0)or(179 < FDeg ) then exit;
         end;

     Result:= 2; if (FMin < 0)or(59 < FMin) then exit;
     Result:= 1; if (FSec < 0)or(59 < FMin) then exit;
     Result:= 0;
end;

function T_Coordonnee.Check_Degres: Boolean;
begin
     Result:= True;
     if LatLon_
     then
         if 90 < FDegres
         then
             FDegres:= 180 - FDegres
         else
             if FDegres < -90
             then
                 FDegres:= 180 + FDegres
             else
                 Result:= False
     else
         if 180 < FDegres
         then
             FDegres:= 360 - FDegres
         else
             if FDegres < -180
             then
                 FDegres:= 360 + FDegres
             else
                 Result:= False;
end;

function T_Coordonnee.Check_Radians: Boolean;
begin
     Result:= True;
     if LatLon_
     then
         if PI/2 < FRadians
         then
             begin
             if Assigned( Longitude_from_LatitudeOverflow)
             then
                 Longitude_from_LatitudeOverflow;
             FRadians:= PI - FRadians
             end
         else
             if FRadians < -PI/2
             then
                 begin
                 if Assigned( Longitude_from_LatitudeOverflow)
                 then
                     Longitude_from_LatitudeOverflow;
                 FRadians:= -PI - FRadians
                 end
             else
                 Result:= False
     else
              if PI < FRadians
         then
             FRadians:= FRadians - 2*PI
         else if FRadians < -PI
             then
                 FRadians:= 2*PI + FRadians
             else
                 Result:= False;
end;

const
     Circonference_Terre= 40000;
     Circonference_Terre2= Circonference_Terre / 2;

procedure T_Coordonnee.Add_km(Delta_en_km: Extended);
var
   Delta_en_radians: Extended;
begin
     Delta_en_radians:= Delta_en_km * PI / Circonference_Terre2;
     FRadians:= FRadians + Delta_en_radians;
     Check_Radians;

     Radians_To_Degres;
     Degres_to_Sexagesimal;
     Sexagesimal_to_String;
     doModify;
end;

procedure T_Coordonnee.Retournement_Longitude;
begin
     if LatLon_ then exit; // ceci ne s'appalique qu'à une coordonnée longitude.

     FRadians:= FRadians + PI;
     Check_Radians;

     Radians_To_Degres;
     Degres_to_Sexagesimal;
     Sexagesimal_to_String;
     doModify;
end;

procedure T_Coordonnee.Copy_From( uneCoordonnee: T_Coordonnee);
begin
     if uneCoordonnee = nil then exit;

     FLatLon_:= uneCoordonnee.FLatLon_;
     FStr    := uneCoordonnee.FStr    ;
     FSign   := uneCoordonnee.FSign   ;
     FDeg    := uneCoordonnee.FDeg    ;
     FMin    := uneCoordonnee.FMin    ;
     FSec    := uneCoordonnee.FSec    ;
     FDegres := uneCoordonnee.FDegres ;
     FRadians:= uneCoordonnee.FRadians;

     sinus   := uneCoordonnee.sinus   ;
     cosinus := uneCoordonnee.cosinus ;
end;

procedure T_Coordonnee.doModify;
begin
     SinCos( FRadians, sinus, cosinus);
     Modify.Publie;
end;

procedure T_Coordonnee.Nouveau;
begin
     // On garde les coordonnées actuelles
end;

{ TObservation }

constructor TObservation.Create;
begin
     inherited;
     d:= Now;
     latitude := T_Coordonnee.Create( True );
     longitude:= T_Coordonnee.Create( False);
end;

destructor TObservation.Destroy;
begin
     inherited;
end;

procedure TObservation.Log( _Prefix: String);
begin
     WriteLn( _Prefix+'latitude:', latitude.Str, ' longitude:',longitude.Str,' d:', DateTimeToStr(d));
end;

end.

