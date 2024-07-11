library wasm_jsCiel;

{$mode objfpc}
{$h+}
{$codepage UTF8}

uses
    NoThreads, SysUtils, JOB.Shared, JOB_Web, JOB.JS, uObservation, uPublieur,
    uLieu, uCoordonnee, uDate, uDate_Ephemerides, uTemps, uEquinoxeur, uMath,
    uCiel, uSysteme_Solaire, uObjets_du_Systeme_Solaire, uObjet_non_ponctuel,
    uObjets, uSexa_radians, uTheories_Planetaires;

type

  { Twasm_jsCiel }

 Twasm_jsCiel
 =
  class
  //Gestion du cycle de vie
  public
    constructor Create;
    destructor Destroy; override;
  //Attributs
  private
    Ciel: TCiel;
    HeureEte: Boolean;
    procedure OnButtonClick(Event: IJSEvent);
    procedure DoGeoLocation;
    procedure successCallback(_Position : IJSGeolocationPosition);
    procedure errorCallback(_Value : IJSGeolocationPositionError);
    procedure Levers_Soleil;
    function HHMM_Legal(const ad :Extended):String;
  public
    procedure Run;
  end;

{ Twasm_jsCiel }

constructor Twasm_jsCiel.Create;
begin
     inherited;
     Ciel:= TCiel.Create;
end;

destructor Twasm_jsCiel.Destroy;
begin
     Freeandnil( Ciel);
     inherited;
end;

function Twasm_jsCiel.HHMM_Legal(const ad :Extended):String;
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

procedure Twasm_jsCiel.Levers_Soleil;
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


procedure Twasm_jsCiel.successCallback(_Position : IJSGeolocationPosition);
begin
     Ciel.Initialise( _Position.coords.latitude, _Position.coords.longitude);
     Ciel.Log( ClassName+'.GeoLocation_OK: ');
     Levers_Soleil;
     Ciel.Observation.Temps.TD.Add_To_Julian_Date( +1);
     Levers_Soleil;
end;
procedure Twasm_jsCiel.errorCallback(_Value : IJSGeolocationPositionError);
begin
     WriteLn( ClassName+'.b_Click: geolocation.getCurrentPosition: ', _Value.message);
end;

procedure Twasm_jsCiel.DoGeoLocation;
begin
     if  true//window.navigator.hasOwnProperty('geoLocation')
     then
         JSWindow.navigator.geolocation.getCurrentPosition(@successCallback, @errorCallback)
     else
         WriteLn(ClassName+'.b_Click: GeoLocation indisponible');
end;

procedure Twasm_jsCiel.OnButtonClick(Event: IJSEvent);
begin
     DoGeoLocation;
end;

procedure Twasm_jsCiel.Run;
var
  JSDiv: IJSHTMLDivElement;
  JSButton: IJSHTMLButtonElement;
begin
     //writeln('TWasmApp.Run getElementById "playground" ...');
     // get reference of HTML element "playground" and type cast it to Div
     JSDiv:=TJSHTMLDivElement.Cast(JSDocument.getElementById('playground'));

     // create button
     //writeln('TWasmApp.Run create button ...');
     JSButton:=TJSHTMLButtonElement.Cast(JSDocument.createElement('button'));
     //writeln('TWasmApp.Run set button caption ...');
     JSButton.InnerHTML:='Click me!';

     // add button to div
     //writeln('TWasmApp.Run add button to div ...');
     JSDiv.append(JSButton);

     // add event listener OnButtonClick
     //writeln('TWasmApp.Run addEventListener OnButtonClick ...');
     JSButton.addEventListener('click',@OnButtonClick);

     //writeln('TWasmApp.Run END');

     DoGeoLocation;
end;

var
   Application: Twasm_jsCiel;
begin
     Application:=Twasm_jsCiel.Create;
     Application.Run;
end.

