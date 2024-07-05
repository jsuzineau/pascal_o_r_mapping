library wasm_jsCiel;

{$mode objfpc}
{$h+}
{$codepage UTF8}

uses
    NoThreads, SysUtils, JOB.Shared, JOB_Web, JOB.JS;

type

  { Twasm_jsCiel }

  Twasm_jsCiel = class
  private
    procedure OnButtonClick(Event: IJSEvent);
    procedure successCallback(_Position : IJSGeolocationPosition);
    procedure errorCallback(_Value : IJSGeolocationPositionError);
  public
    procedure Run;
  end;

{ Twasm_jsCiel }

procedure Twasm_jsCiel.successCallback(_Position : IJSGeolocationPosition);
begin
     WriteLn( ClassName+'.GeoLocation_OK: latitude:', _Position.coords.latitude, ' longitude:',_Position.coords.longitude);
end;
procedure Twasm_jsCiel.errorCallback(_Value : IJSGeolocationPositionError);
begin
     WriteLn( 'Tjs_jsCiel..b_Click: geolocation.getCurrentPosition: ', _Value.message);
end;
procedure Twasm_jsCiel.OnButtonClick(Event: IJSEvent);
begin
  writeln('TWasmApp.OnButtonClick ');
  if Event=nil then ;

  JSWindow.Alert('You triggered TWasmApp.OnButtonClick');

  WriteLn(ClassName+'.OnButtonClick');
  if  true//window.navigator.hasOwnProperty('geoLocation')
  then
      JSWindow.navigator.geolocation.getCurrentPosition(@successCallback, @errorCallback)
  else
      WriteLn(ClassName+'.b_Click: GeoLocation indisponible');
end;

procedure Twasm_jsCiel.Run;
var
  JSDiv: IJSHTMLDivElement;
  JSButton: IJSHTMLButtonElement;
begin
  writeln('TWasmApp.Run getElementById "playground" ...');
  // get reference of HTML element "playground" and type cast it to Div
  JSDiv:=TJSHTMLDivElement.Cast(JSDocument.getElementById('playground'));

  // create button
  writeln('TWasmApp.Run create button ...');
  JSButton:=TJSHTMLButtonElement.Cast(JSDocument.createElement('button'));
  writeln('TWasmApp.Run set button caption ...');
  JSButton.InnerHTML:='Click me!';

  // add button to div
  writeln('TWasmApp.Run add button to div ...');
  JSDiv.append(JSButton);

  // add event listener OnButtonClick
  writeln('TWasmApp.Run addEventListener OnButtonClick ...');
  JSButton.addEventListener('click',@OnButtonClick);

  writeln('TWasmApp.Run END');
end;

var
  Application: Twasm_jsCiel;
begin
  Application:=Twasm_jsCiel.Create;
  Application.Run;
end.

