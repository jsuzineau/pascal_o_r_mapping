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
    bCPL_G3: TJSHTMLButtonElement;
    iOctave: TJSHTMLInputElement;
    iFrequence: TJSHTMLInputElement;
    sFrequence: TJSHTMLElement;
    divResultat: TJSHTMLElement;
    procedure Connecte_Interface;
    function bClick( _Event: TJSMouseEvent): boolean;
    function iOctaveInput( _Event: TEventListenerEvent): boolean;
    function iFrequenceInput( _Event: TEventListenerEvent): boolean;
  end;

implementation

function element_from_id( _id: String): TJSHTMLElement;
begin
     Result:= TJSHTMLElement( document.getElementById(_id));
end;

function button_from_id( _id: String): TJSHTMLButtonElement;
begin
     Result:= TJSHTMLButtonElement(document.getElementById(_id))
end;

function input_from_id( _id: String): TJSHTMLInputElement;
begin
     Result:= TJSHTMLInputElement(document.getElementById(_id))
end;
{ TfjsFrequences }

constructor TfjsFrequences.Create;
begin
     Connecte_Interface;
end;

destructor TfjsFrequences.Destroy;
begin
     inherited Destroy;
end;

procedure TfjsFrequences.Connecte_Interface;
begin
     d:= element_from_id('d');

     bCPL_G3:= button_from_id( 'bCPL_G3');
     bCPL_G3.onclick:= @bClick;

     iOctave:= input_from_id('iOctave');
     iOctave.oninput:=@iOctaveInput;

     iFrequence:= input_from_id( 'iFrequence');
     iFrequence.oninput:=@iFrequenceInput;
     sFrequence:= element_from_id('sFrequence');

     divResultat:= element_from_id('divResultat');
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

