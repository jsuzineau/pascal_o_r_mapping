library wasm_jsCiel;

{$mode objfpc}
{$h+}
{$codepage UTF8}

uses
    NoThreads, SysUtils, JOB.Shared, JOB_Web, JOB.JS, uObservation, uPublieur,
    uLieu, uCoordonnee, uDate, uDate_Ephemerides, uTemps, uEquinoxeur, uMath,
    uCiel, uSysteme_Solaire, uObjets_du_Systeme_Solaire, uObjet_non_ponctuel,
    uObjets, uSexa_radians, uTheories_Planetaires,uDataUtilsU;

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
    procedure bCalculClick(Event: IJSEvent);
    procedure DoGeoLocation;
    procedure successCallback(_Position : IJSGeolocationPosition);
    procedure errorCallback(_Value : IJSGeolocationPositionError);
    procedure Levers_Soleil;
    procedure Traite_Lieu( _Latitude, _Longitude: Extended);
    function HHMM_Legal(const ad :Extended):String;
    procedure Affiche;
  //Carte Leaflet
  private
    LeafLet_initialized: Boolean;
    Leaflet: TJSObject;
    map: TJSObject;
    procedure RefreshMap;
    procedure Set_Map_to( _Latitude, _Longitude: Extended);
    procedure Assure_LeafLet_initialized;

  //Exécution
  public
    procedure Run;
  end;

{ Twasm_jsCiel }

constructor Twasm_jsCiel.Create;
begin
     inherited;
     LeafLet_initialized:= False;
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
              ' (',sHeureEte,')', ', Azimuth: ',Ciel.SSOL.Soleil.AzS_Lever);
end;

procedure Twasm_jsCiel.Traite_Lieu(_Latitude, _Longitude: Extended);
begin
     Ciel.Initialise( _Latitude, _Longitude);
     //Ciel.Log( ClassName+'.GeoLocation_OK: ');
     Affiche;
     Levers_Soleil;
     Ciel.Observation.Temps.TD.Add_To_Julian_Date( +1);
     Levers_Soleil;
     RefreshMap;
end;

procedure Twasm_jsCiel.successCallback(_Position : IJSGeolocationPosition);
begin
     //La longitude donnée par le navigateur est négative vers l'Ouest
     //mais dans les algorithmes de calcul de Jean MEEUS
     //elle est négative vers l'Est d'où le -
     Traite_Lieu( _Position.coords.latitude, -_Position.coords.longitude);

end;
procedure Twasm_jsCiel.errorCallback(_Value : IJSGeolocationPositionError);
begin
     WriteLn( ClassName+'.b_Click: geolocation.getCurrentPosition: ', _Value.message);
     Traite_Lieu( 43.604312,-1.4436825);//Toulouse
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

procedure Twasm_jsCiel.Affiche;
var
   iCalcul_Lieu_Latitude : IJSHTMLInputElement;
   iCalcul_Lieu_Longitude: IJSHTMLInputElement;
   iCalcul_Date: IJSHTMLInputElement;
   dCalcul_Resultat: IJSHTMLDivElement;
   sResultat: String;
begin
     iCalcul_Lieu_Latitude:=TJSHTMLInputElement.Cast(JSDocument.getElementById('iCalcul_Lieu_Latitude'));
     //WriteLn(ClassName+'.Affiche: Latitude: ',UTF8Encode(iCalcul_Lieu_Latitude.value));
     iCalcul_Lieu_Latitude.value:= UTF8Decode(Ciel.Observation.Lieu.La.Str);
     iCalcul_Lieu_Longitude:=TJSHTMLInputElement.Cast(JSDocument.getElementById('iCalcul_Lieu_Longitude'));
     //WriteLn(ClassName+'.Affiche: Longitude: ',UTF8Encode(iCalcul_Lieu_Longitude.value));
     iCalcul_Lieu_Longitude.value:= UTF8Decode(Ciel.Observation.Lieu.Lg.Str);

     iCalcul_Date:=TJSHTMLInputElement.Cast(JSDocument.getElementById('iCalcul_Date'));
     iCalcul_Date.value:= UTF8Decode( Ciel.Observation.Temps.TL.AsDateTimeSQL_sans_quotes);

     DefaultFormatSettings.ThousandSeparator:= ' ';
     DefaultFormatSettings.DecimalSeparator:= ',';

     sResultat
     :=
        'Latitude:'+Ciel.Observation.Lieu.La.Str+'<br/>'
       +'Longitude:'+Ciel.Observation.Lieu.Lg.Str+'<br/>'
       +'Temps universel TU (UTC): '+Ciel.Observation.Temps.TU.sDate+' '+Ciel.Observation.Temps.TU.sHeure+'<br/>'
       +'Temps dynamique TD      : '+Ciel.Observation.Temps.TD.sDate+' '+Ciel.Observation.Temps.TD.sHeure+'<br/>'
       +'TU: Jour Julien: '+Ciel.Observation.Temps.TU.sJour_Julien                              +'<br/>'
       +'TD: Jour Julien: '+Ciel.Observation.Temps.TD.sJour_Julien                              +'<br/>'
       +UTF8Encode('Temps sidéral:')+Ciel.Observation.Temps_sideral_en_heures                   +'<br/>'
       ;
     dCalcul_Resultat:=TJSHTMLDivElement.Cast(JSDocument.getElementById('dCalcul_Resultat'));
     dCalcul_Resultat.innerHTML:= UTF8Decode( sResultat);
end;

procedure Twasm_jsCiel.bCalculClick(Event: IJSEvent);
var
   iCalcul_Lieu_Latitude : IJSHTMLInputElement;
   iCalcul_Lieu_Longitude: IJSHTMLInputElement;
   iCalcul_Date: IJSHTMLInputElement;
begin
     iCalcul_Lieu_Latitude:=TJSHTMLInputElement.Cast(JSDocument.getElementById('iCalcul_Lieu_Latitude'));
     //WriteLn(ClassName+'.bCalculClick: Latitude: ',UTF8Encode(iCalcul_Lieu_Latitude.value));
     Ciel.Observation.Lieu.La.Set_Str( UTF8Encode(iCalcul_Lieu_Latitude.value));

     iCalcul_Lieu_Longitude:=TJSHTMLInputElement.Cast(JSDocument.getElementById('iCalcul_Lieu_Longitude'));
     //WriteLn(ClassName+'.bCalculClick: Longitude: ',UTF8Encode(iCalcul_Lieu_Longitude.value));
     Ciel.Observation.Lieu.Lg.Set_Str( UTF8Encode(iCalcul_Lieu_Longitude.value));

     iCalcul_Date:=TJSHTMLInputElement.Cast(JSDocument.getElementById('iCalcul_Date'));
     //WriteLn(ClassName+'.bCalculClick: Date: ',iCalcul_Date.value);
     Ciel.Observation.Temps.TL.Set_to_Datetime( DateTime_from_DateTime_ISO8601_sans_quotes( UTF8Encode(iCalcul_Date.value)));

     Affiche;
     RefreshMap;
end;

procedure Twasm_jsCiel.Assure_LeafLet_initialized;
   procedure L_tileLayer;
   var
      params: TJSObject;
   begin
        //L
        // .tileLayer( 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
        //             {
        //             attribution: 'Map data &copy; <a href="https://www.openstreetmap.org/">OpenStreetMap</a> contributors',
        //             maxZoom: 19,
        //             }
        //           )
        // .addTo(map);

        params:= TJSObject.JOBCreate([]);
        params.Properties['attribution']:= 'Map data &copy; <a href="https://www.openstreetmap.org/">OpenStreetMap</a> contributors';
        params.Properties['maxZoom'    ]:= 19;

        Leaflet
         .InvokeJSObjectResult( 'tileLayer', ['https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', params], TJSObject)
         .InvokeJSNoResult('addTo', [map]);
   end;
begin
     if LeafLet_initialized then exit;

     Leaflet:= JSWindow.ReadJSPropertyObject('L', TJSObject);
     map:= Leaflet.InvokeJSObjectResult( 'map',['dMap'], TJSObject);
     L_tileLayer;

     LeafLet_initialized:= True;
end;

procedure Twasm_jsCiel.Set_Map_to(_Latitude, _Longitude: Extended);
   procedure dump_global_variables;
   var
      global_variables: TJSObject;
   begin
        global_variables:= JSObject.InvokeJSObjectResult( 'keys'    ,[JSWindow],TJSObject);
        WriteLn( ClassName+'.Set_Map_To global_variables: type', global_variables.JSClassName, 'valeur: ', global_variables.toString);
   end;
   procedure L_map_SetView;
   var
      latlng: TJOB_ArrayOfDouble;
   begin
        //const map = L.map('map').setView([latitude, longitude], 13);
        latlng:= TJOB_ArrayOfDouble.Create( [_Latitude, -_Longitude]);
        map.InvokeJSObjectResult( 'setView',[latlng, 13],TJSObject);
   end;
begin
     Assure_LeafLet_initialized;
     //dump_global_variables;

     L_map_SetView;
end;

procedure Twasm_jsCiel.RefreshMap;
begin
     Set_Map_to( Ciel.Observation.Lieu.La.Degres, Ciel.Observation.Lieu.Lg.Degres);
end;

procedure Twasm_jsCiel.Run;
var
   bCalcul: IJSHTMLButtonElement;
   //c: IJSHTMLCollection;
begin
     //writeln('TWasmApp.Run getElementById "playground" ...');
     // get reference of HTML element "playground" and type cast it to Div
     //JSDiv:=TJSHTMLDivElement.Cast(JSDocument.getElementById('playground'));

     // create button
     //writeln('TWasmApp.Run create button ...');
     //JSButton:=TJSHTMLButtonElement.Cast(JSDocument.createElement('button'));
     //writeln('TWasmApp.Run set button caption ...');
     //JSButton.InnerHTML:='Click me!';

     // add button to div
     //writeln('TWasmApp.Run add button to div ...');
     //JSDiv.append(JSButton);

     // add event listener OnButtonClick
     //writeln('TWasmApp.Run addEventListener OnButtonClick ...');
     //JSButton.addEventListener('click',@OnButtonClick);

     //writeln('TWasmApp.Run END');

     bCalcul:=TJSHTMLButtonElement.Cast(JSDocument.getElementById('bCalcul'));
     bCalcul.addEventListener('click',@bCalculClick);

     //c:= JSDocument.getElementsByTagName('L');
     //WriteLn(ClassName+'.Run: c.Length_: ',c.Length_);

     DoGeoLocation;
end;

var
   Application: Twasm_jsCiel;
begin
     Application:=Twasm_jsCiel.Create;
     Application.Run;
end.

