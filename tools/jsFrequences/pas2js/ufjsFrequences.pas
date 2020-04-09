unit ufjsFrequences;

{$mode objfpc}

interface

uses
    uFrequence,
    uFrequences, uCPL_G3,
 Classes, SysUtils, JS, Web;

type

 { TfjsFrequences }

 TfjsFrequences
 =
  class
  //Gestion du cycle de vie
  public
    constructor Create;
    destructor Destroy; override;
  //Interface
  public
    d: TJSHTMLElement;
    b: TJSHTMLButtonElement;
    iOctave: TJSHTMLInputElement;
    iFrequence: TJSHTMLInputElement;
    sFrequence: TJSHTMLElement;
    divResultat: TJSHTMLElement;
    procedure Cree_Interface;
    function bClick( _Event: TJSMouseEvent): boolean;
    function iOctaveInput( _Event: TEventListenerEvent): boolean;
    function iFrequenceInput( _Event: TEventListenerEvent): boolean;
  end;

implementation

{ TfjsFrequences }

constructor TfjsFrequences.Create;
begin
     Cree_Interface;
end;

destructor TfjsFrequences.Destroy;
begin
     inherited Destroy;
end;

procedure TfjsFrequences.Cree_Interface;
begin
     d:= TJSHTMLElement( document.createElement('div'));
     document.body.append( d);

     b:= TJSHTMLButtonElement( document.createElement('button'));
     b.textContent:= 'CPL G3';
     b.onclick:= @bClick;
     d.append(b);

     d.append( 'Octave :');

     iOctave:= TJSHTMLInputElement(document.createElement('input'));
     d.append(iOctave);
     iOctave.oninput:=@iOctaveInput;

     d.append( 'Fréquence :');

     iFrequence:= TJSHTMLInputElement(document.createElement('input'));
     d.append(iFrequence);
     iFrequence.oninput:=@iFrequenceInput;
     sFrequence:= TJSHTMLElement(document.createElement('span'));
     d.append(sFrequence);

     divResultat:= TJSHTMLElement( document.createElement('div'));
     document.body.append( divResultat);
end;

function TfjsFrequences.bClick(_Event: TJSMouseEvent): boolean;
begin
     //divResultat.textContent:= CPL_G3.Liste;
     //divResultat.append( CPL_G3.Liste);
     divResultat.innerHTML:= CPL_G3.Liste;
end;

function TfjsFrequences.iOctaveInput(_Event: TEventListenerEvent): boolean;
var
   Octave: Integer;
begin
     if not TryStrToInt( iOctave.value, Octave) then exit;

     divResultat.innerHTML:= Frequences.Liste( Octave);
end;

function TfjsFrequences.iFrequenceInput(_Event: TEventListenerEvent): boolean;
var
   Frequence: double;
begin
     if not TryStrToFloat( iFrequence.value, Frequence) then exit;

     divResultat.innerHTML:= Frequences.Liste_from_Frequence( Frequence);
     sFrequence .innerHTML:= uFrequence.sFrequence( Frequence);
end;

end.

