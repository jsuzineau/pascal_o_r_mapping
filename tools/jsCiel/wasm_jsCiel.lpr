library wasm_jsCiel;

{$mode objfpc}
{$h+}
{$codepage UTF8}

uses
    NoThreads, SysUtils, StrUtils, JOB.Shared, JOB_Web, JOB.JS, uObservation, uPublieur,
    uLieu, uCoordonnee, uDate, uDate_Ephemerides, uTemps, uEquinoxeur, uMath,
    uCiel, uSysteme_Solaire, uObjets_du_Systeme_Solaire, uObjet_non_ponctuel,
    uObjets, uSexa_radians, uTheories_Planetaires,uDataUtilsU, uJSDate;

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
    dLever_Soleil: IJSHTMLDivElement;
    function Lever_Soleil: String;
    function HHMM_Legal(const ad :Extended):String;
  //Parametres
  private
    iDecalage_Heure_Ete       : IJSHTMLInputElement;
    iDecalage_Heure_Locale    : IJSHTMLInputElement;
    iParametres_Lieu_Latitude : IJSHTMLInputElement;
    iParametres_Lieu_Longitude: IJSHTMLInputElement;
    iParametres_Date          : IJSHTMLInputElement;
    bCalcul: IJSHTMLButtonElement;
    procedure bCalcul_Show;
    procedure bCalcul_Hide;
    procedure iDecalage_Heure_EteInput       (Event: IJSEvent);
    procedure iDecalage_Heure_LocaleInput    (Event: IJSEvent);
    procedure iParametres_Lieu_LatitudeInput (Event: IJSEvent);
    procedure iParametres_Lieu_LongitudeInput(Event: IJSEvent);
    procedure iParametres_DateInput          (Event: IJSEvent);
    procedure bCalculClick(Event: IJSEvent);
    procedure _from_Parametres;
  //Resultat
  private
    dCalcul_Resultat: IJSHTMLDivElement;
    procedure Affiche;
  //Carte Leaflet
  private
    LeafLet_initialized: Boolean;
    Leaflet: TJSObject;
    map: TJSObject;
    procedure mapClick(_e: IJSEvent);
    procedure RefreshMap;
    procedure Set_Map_to( _Latitude, _Longitude: Extended);
    procedure Assure_LeafLet_initialized;
  //GeoLocation
  private
    procedure DoGeoLocation;
    procedure successCallback(_Position : IJSGeolocationPosition);
    procedure errorCallback(_Value : IJSGeolocationPositionError);
    procedure Traite_Lieu( _Latitude, _Longitude: Extended);
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
     adh:=ad*12/pi + Ciel.Observation.Temps.Decalage_TL_from_TU;
     adh:= Trunc(adh) mod 24+Frac(adh);

     hhh:=round(adh-0.5);mmm:=round(frac(adh)*60);
     if mmm=60 then begin mmm:=0;hhh:=hhh+1;end;
     if hhh=24 then hhh:=0;

     str(hhh:2,hhs);if hhs[1]=' ' then hhs[1]:='0';
     str(mmm:2,mms);if mms[1]=' ' then mms[1]:='0';

     Result:= hhs+ ':'+ mms;
end;

function Twasm_jsCiel.Lever_Soleil: String;
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
   sSigneDecalage:String;
   Decalage: double;
begin
     Ciel.Observation.Temps.SetHeureEte( Ciel.Observation.Temps.TU.EteHiver_);
     Decalage:= Ciel.Observation.Temps.Decalage_TL_from_TU;

     if 0 = Ciel.Observation.Lieu.Decalage_Heure_Ete
     then
         sHeureEte:= ''
     else
         if Ciel.Observation.Temps.HeureEte
         then
             sHeureEte:= 'heure d''été'
         else
             sHeureEte:= 'heure d''hiver';

     sSigneDecalage:= IfThen( Decalage>0, '+', '');

     if 0 = Frac(Decalage)
     then
         sHeureEte:= sHeureEte + Format( ' UTC%s%d',[sSigneDecalage,Trunc(Decalage)])
     else
         sHeureEte:= sHeureEte + Format( ' UTC%s%f',[sSigneDecalage,Decalage]);
     Ciel.SSOL.Soleil.LeMeCo(0);
     Result
     :=
        Ciel.Observation.Temps.TL.sJour+' '
       +Mois[Ciel.Observation.Temps.TL.Mois]
       +': '
       +HHMM_Legal( Ciel.SSOL.Soleil.hl)
       +' ('+sHeureEte+')'+ ', Azimuth: '+Ciel.SSOL.Soleil.AzS_Lever;
end;

procedure Twasm_jsCiel.Affiche;
var
   sResultat: String;
   sLevers_Soleil: String;
begin
     iDecalage_Heure_Ete   .valueAsNumber:= Ciel.Observation.Lieu.Decalage_Heure_Ete   ;
     iDecalage_Heure_Locale.valueAsNumber:= Ciel.Observation.Lieu.Decalage_Heure_Locale;

     //WriteLn(ClassName+'.Affiche: Latitude: ',UTF8Encode(iParametres_Lieu_Latitude.value));
     iParametres_Lieu_Latitude.value:= UTF8Decode(Ciel.Observation.Lieu.La.Str);
     //WriteLn(ClassName+'.Affiche: Longitude: ',UTF8Encode(iParametres_Lieu_Longitude.value));
     iParametres_Lieu_Longitude.value:= UTF8Decode(Ciel.Observation.Lieu.Lg.Str);

     iParametres_Date.value:= UTF8Decode( Ciel.Observation.Temps.TL.AsDateTimeSQL_sans_quotes);

     DefaultFormatSettings.ThousandSeparator:= ' ';
     DefaultFormatSettings.DecimalSeparator:= ',';

     sResultat
     :=
        'Latitude:'+Ciel.Observation.Lieu.La.Str+'<br/>'
       +'Longitude:'+Ciel.Observation.Lieu.Lg.Str+'<br/>'
       +'Temps universel TU (UTC): '+Ciel.Observation.Temps.TU.sDate+' '+Ciel.Observation.Temps.TU.sHeure+'<br/>'
       +'Temps dynamique TD      : '+Ciel.Observation.Temps.TD.sDate+' '+Ciel.Observation.Temps.TD.sHeure+'<br/>'
       +'TD-TU: '+Format('%.2f',[Ciel.Observation.Temps.DeltaT_en_secondes])+' secondes <br/>'
       +'TD: Tau: '+Format('%.10f',[Ciel.Observation.Temps.TD.Tau])+UTF8Encode('(en siècles juliens par rapport à J2000)<br/>')
       +'TD: Jour Julien: '+Ciel.Observation.Temps.TD.sJour_Julien                              +'<br/>'
       +UTF8Encode('Temps sidéral:')+Ciel.Observation.Temps_sideral_en_heures                   +'<br/>'
       ;
     dCalcul_Resultat.innerHTML:= UTF8Decode( sResultat);

     //dLever_Soleil
     sLevers_Soleil:= Lever_Soleil+'<br/>';
     Ciel.Observation.Temps.TD.Add_To_Julian_Date( +1);
     sLevers_Soleil:= sLevers_Soleil + Lever_Soleil+'<br/>';
     Ciel.Observation.Temps.TD.Add_To_Julian_Date( -1);
     dLever_Soleil.innerHTML:= UTF8Decode( sLevers_Soleil);

     RefreshMap;
end;

procedure Twasm_jsCiel._from_Parametres;
begin
     Ciel.Observation.Lieu.Decalage_Heure_Ete   :=iDecalage_Heure_Ete   .valueAsNumber;
     Ciel.Observation.Lieu.Decalage_Heure_Locale:=iDecalage_Heure_Locale.valueAsNumber;

     //WriteLn(ClassName+'._from_Parametres: Latitude: ',UTF8Encode(iParametres_Lieu_Latitude.value));
     Ciel.Observation.Lieu.La.Set_Str( UTF8Encode(iParametres_Lieu_Latitude.value));

     //WriteLn(ClassName+'._from_Parametres: Longitude: ',UTF8Encode(iParametres_Lieu_Longitude.value));
     Ciel.Observation.Lieu.Lg.Set_Str( UTF8Encode(iParametres_Lieu_Longitude.value));

     //WriteLn(ClassName+'._from_Parametres: Date: ',iParametres_Date.value);
     Ciel.Observation.Temps.TL.Set_to_Datetime( DateTime_from_DateTime_ISO8601_sans_quotes( UTF8Encode(iParametres_Date.value)));

     Affiche;
     bCalcul_Hide;
end;

procedure Twasm_jsCiel.bCalculClick(Event: IJSEvent);
begin
     _from_Parametres;
end;

procedure Twasm_jsCiel.bCalcul_Show;
begin
     //WriteLn(ClassName+'.bCalcul_Show');
     WriteLn(ClassName+'.bCalcul_Show: bCalcul.style.cssText:' ,bCalcul.style.cssText);
     //bCalcul.style.setProperty('visibility','visible');
     bCalcul.style.cssText:= 'visibility: visible;';
end;

procedure Twasm_jsCiel.bCalcul_Hide;
begin
     //bCalcul.style.setProperty('visibility','hidden');
     bCalcul.style.cssText:= 'visibility: hidden;';
end;

procedure Twasm_jsCiel.iDecalage_Heure_EteInput(Event: IJSEvent);
begin
     bCalcul_Show;
end;

procedure Twasm_jsCiel.iDecalage_Heure_LocaleInput(Event: IJSEvent);
begin
     bCalcul_Show;
end;

procedure Twasm_jsCiel.iParametres_Lieu_LatitudeInput(Event: IJSEvent);
begin
     bCalcul_Show;
end;

procedure Twasm_jsCiel.iParametres_Lieu_LongitudeInput(Event: IJSEvent);
begin
     bCalcul_Show;
end;

procedure Twasm_jsCiel.iParametres_DateInput(Event: IJSEvent);
begin
     bCalcul_Show;
end;

procedure Twasm_jsCiel.mapClick(_e: IJSEvent);
var
   latlng: TJSObject;
   lat, lng: double;
   procedure dump_latlng_variables;
   var
      latlng_variables: TJSObject;
   begin
        latlng_variables:= JSObject.InvokeJSObjectResult( 'keys'    ,[latlng],TJSObject);
        WriteLn( ClassName+'.Set_Map_To global_variables: type', latlng_variables.JSClassName, 'valeur: ', latlng_variables.toString);
   end;
begin
     //WriteLn( Classname+'.mapClick: _e.type_:',_e.type_);
     latlng:= _e.ReadJSPropertyObject('latlng', TJSObject);
     //dump_latlng_variables;
     lat:= latlng.ReadJSPropertyDouble('lat');
     lng:= latlng.ReadJSPropertyDouble('lng');
     Traite_Lieu( lat, -lng);
end;

type
 TOnMapClickCallback = procedure (_e: IJSEvent) of object;

 { IJSLeafletMap }

 IJSLeafletMap
 =
  interface(IJSObject)
   ['{622B2D01-0F15-480B-BC46-FCB926059823}']
   procedure Set_onClick(const _Callback: TOnMapClickCallback);
  end;

 { TJSLeafletMap }

 TJSLeafletMap
 =
  class(TJSObject,IJSLeafletMap)
  public
    procedure Set_onClick(const _Callback: TOnMapClickCallback);
    class function JSClassName: UnicodeString; override;
    class function Cast(const Intf: IJSObject): IJSLeafletMap;
  end;

function JOBCallOnMapClickCallback(const _Method: TMethod; var _H: TJOBCallbackHelper): PByte;
var
   o: TJSObject;
   e: IJSEvent;
begin
     o:=_H.GetObject(TJSObject);
     e:= TJSEvent.Cast( o);
     TOnMapClickCallback(_Method)( e);
     Result:=_H.AllocUndefined;
end;


procedure TJSLeafletMap.Set_onClick(const _Callback: TOnMapClickCallback);
var
   m: TJOB_Method;
begin
     m:=TJOB_Method.Create(TMethod(_Callback),@JOBCallOnMapClickCallback);
     try
        InvokeJSNoResult('on',['click',m]);
     finally
            m.free;
            end;
end;

class function TJSLeafletMap.JSClassName: UnicodeString;
begin
     Result:= 'Map';
end;
class function TJSLeafletMap.Cast(const Intf: IJSObject): IJSLeafletMap;
begin
     Result:= TJSLeafletMap.JOBCast(Intf);
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
   procedure set_map_on_click;
   //var
      //m: IJSLeafletMap;
      //m: IJSEventTarget;
      procedure Test4;
      var
         m: TJOB_Method;
      begin
           m:=TJOB_Method.Create(TMethod(@mapClick),@JOBCallOnMapClickCallback);
           try
              map.InvokeJSNoResult('on',['click',m]);
           finally
                  m.free;
                  end;
      end;
   begin
        //m:= TJSLeafletMap.Cast( map);
        //m.Set_onClick( @mapClick);

        //m:= TJSEventTarget.Cast( map);
        //m.addEventListener('click',@mapClick);

        //map.InvokeJSNoResult( 'on',)
        Test4;
   end;
begin
     if LeafLet_initialized then exit;

     Leaflet:= JSWindow.ReadJSPropertyObject('L', TJSObject);
     map:= Leaflet.InvokeJSObjectResult( 'map',['dMap'], TJSObject);
     L_tileLayer;
     //WriteLn( Classname+'.Assure_LeafLet_initialized: map jsclassname:',map.JSClassName);
     set_map_on_click;

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

procedure Twasm_jsCiel.Traite_Lieu(_Latitude, _Longitude: Extended);
begin
     Ciel.Initialise( _Latitude, _Longitude);
     Ciel.Log( ClassName+'.Traite_Lieu: ');
     Affiche;
end;

procedure Twasm_jsCiel.successCallback(_Position : IJSGeolocationPosition);
   //procedure dump_latlng_variables;
   //var
   //   latlng_variables: TJSObject;
   //begin
   //     latlng_variables:= JSObject.InvokeJSObjectResult( 'keys'    ,[latlng],TJSObject);
   //     WriteLn( ClassName+'.Set_Map_To global_variables: type', latlng_variables.JSClassName, 'valeur: ', latlng_variables.toString);
   //end;
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

procedure Twasm_jsCiel.Run;
begin
     iDecalage_Heure_Ete       :=TJSHTMLInputElement .Cast(JSDocument.getElementById('iDecalage_Heure_Ete'       ));
     iDecalage_Heure_Locale    :=TJSHTMLInputElement .Cast(JSDocument.getElementById('iDecalage_Heure_Locale'    ));
     iParametres_Lieu_Latitude :=TJSHTMLInputElement .Cast(JSDocument.getElementById('iParametres_Lieu_Latitude' ));
     iParametres_Lieu_Longitude:=TJSHTMLInputElement .Cast(JSDocument.getElementById('iParametres_Lieu_Longitude'));
     iParametres_Date          :=TJSHTMLInputElement .Cast(JSDocument.getElementById('iParametres_Date'          ));
     bCalcul                   :=TJSHTMLButtonElement.Cast(JSDocument.getElementById('bCalcul'                   ));
     dLever_Soleil             :=TJSHTMLDivElement   .Cast(JSDocument.getElementById('dLever_Soleil'             ));
     dCalcul_Resultat          :=TJSHTMLDivElement   .Cast(JSDocument.getElementById('dCalcul_Resultat'          ));

     iDecalage_Heure_Ete       .addEventListener('input', @iDecalage_Heure_EteInput       );
     iDecalage_Heure_Locale    .addEventListener('input', @iDecalage_Heure_LocaleInput    );
     iParametres_Lieu_Latitude .addEventListener('input', @iParametres_Lieu_LatitudeInput );
     iParametres_Lieu_Longitude.addEventListener('input', @iParametres_Lieu_LongitudeInput);
     iParametres_Date          .addEventListener('input', @iParametres_DateInput          );
     bCalcul                   .addEventListener('click' ,@bCalculClick                   );

     DoGeoLocation;
end;

var
   Application: Twasm_jsCiel;
begin
     Application:=Twasm_jsCiel.Create;
     Application.Run;
end.

