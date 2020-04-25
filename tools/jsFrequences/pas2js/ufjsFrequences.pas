unit ufjsFrequences;

{$mode objfpc}
{$MODESWITCH EXTERNALCLASS}

interface

uses
    uFrequence,
    uFrequences,
    uCPL_G3,
    uFrequencesCharter,
 Classes, SysUtils, JS, Web, Math, ChartJS, Types;

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
    iOctave: TJSHTMLInputElement;
    iFrequence: TJSHTMLInputElement;
    sFrequence: TJSHTMLElement;
    dOctave: TJSHTMLElement;
    dFrequence: TJSHTMLElement;
    dCPL_G3: TJSHTMLElement;
    dInfos: TJSHTMLElement;
    procedure Connecte_Interface;
    function iOctaveInput( _Event: TEventListenerEvent): boolean;
    function iFrequenceInput( _Event: TEventListenerEvent): boolean;
    procedure Traite_CPL_G3;
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

     iOctave:= input_from_id('iOctave');
     iOctave.oninput:=@iOctaveInput;

     iFrequence:= input_from_id( 'iFrequence');
     iFrequence.oninput:=@iFrequenceInput;
     sFrequence:= element_from_id('sFrequence');

     //cFrequence
     //Draw_Chart;
     dOctave   := element_from_id('dOctave'   );
     dFrequence:= element_from_id('dFrequence');


     dCPL_G3:= element_from_id('dCPL_G3');
     Traite_CPL_G3;

     dInfos:= element_from_id('dInfos');
     dInfos.innerHTML
     :=
        'compilé avec pas2js version '+{$I %FPCVERSION%}+'<br>'
       +'target: '+{$I %FPCTARGETCPU%}+' - '+{$I %FPCTARGETOS%}+'<br>'
       +'os: '+{$I %FPCTARGETOS%}+'<br>'
       +'cpu: '+{$I %FPCTARGETCPU%}+'<br>'
       +'compilé le '+{$I %DATE%}+' à '+{$I %TIME%}+'<br>'
       +'langue du navigateur: '+window.navigator.language;
end;

procedure TfjsFrequences.Traite_CPL_G3;
begin
     FrequencesCharter.Draw_Chart_from_Frequences( 7, 2, 'Porteuses CPL G3' , CPL_G3.F, 'cCPL_G3');
     dCPL_G3.innerHTML:= CPL_G3.Liste;
end;

function TfjsFrequences.iOctaveInput(_Event: TEventListenerEvent): boolean;
var
   Octave: Integer;
begin
     if not TryStrToInt( iOctave.value, Octave) then exit;

     FrequencesCharter.Draw_Chart_from_Octave( Octave, 'cOctave');
     dOctave.innerHTML:= Frequences.Liste( Octave);
end;

function TfjsFrequences.iFrequenceInput(_Event: TEventListenerEvent): boolean;
var
   Frequence: double;
begin
     if not TryStrToFloat( iFrequence.value, Frequence) then exit;

     FrequencesCharter.Draw_Chart_from_Frequence( uFrequence.sFrequence( Frequence), Frequence, 'cFrequence');
     dFrequence.innerHTML:= Frequences.Liste_from_Frequence( Frequence);
     sFrequence .innerHTML:= uFrequence.sFrequence( Frequence);
end;

end.

