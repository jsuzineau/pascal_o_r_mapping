unit ufjsFrequences;

{$mode objfpc}
{$MODESWITCH EXTERNALCLASS}

interface

uses
    uFrequence,
    uFrequences,
    uCPL_G3, uGamme,
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
    iOctave: TJSHTMLInputElement;
    iFrequence: TJSHTMLInputElement;
    sFrequence: TJSHTMLElement;
    dOctave: TJSHTMLElement;
    dFrequence: TJSHTMLElement;
    dCPL_G3: TJSHTMLElement;
    dCouleur: TJSHTMLElement;
    dInfos: TJSHTMLElement;
    procedure Connecte_Interface;
    function iOctaveInput( _Event: TEventListenerEvent): boolean;
    function iFrequenceInput( _Event: TEventListenerEvent): boolean;
    procedure Traite_Octave;
    procedure Traite_Frequence;
    procedure Traite_CPL_G3;
    procedure Traite_Couleur;
    procedure Traite_Gamme_Temperee( _Diapason: Integer; _Gamme_Temperee: TGamme_Temperee);
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
     iOctave:= input_from_id('iOctave');
     iOctave.oninput:=@iOctaveInput;

     iFrequence:= input_from_id( 'iFrequence');
     iFrequence.oninput:=@iFrequenceInput;
     sFrequence:= element_from_id('sFrequence');

     //cFrequence
     //Draw_Chart;
     dOctave   := element_from_id('dOctave'   );
     dFrequence:= element_from_id('dFrequence');

     Traite_Octave;
     Traite_Frequence;

     Traite_Gamme_Temperee( 418, Gamme_418Hz);
     Traite_Gamme_Temperee( 432, Gamme_432Hz);
     Traite_Gamme_Temperee( 440, Gamme_440Hz);

     dCPL_G3:= element_from_id('dCPL_G3');
     Traite_CPL_G3;

     dCouleur:= element_from_id('dCouleur');
     Traite_Couleur;

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

function TfjsFrequences.iOctaveInput(_Event: TEventListenerEvent): boolean;
begin
     Traite_Octave;
end;

procedure TfjsFrequences.Traite_Octave;
var
   Octave: Integer;
begin
     iOctave:= input_from_id('iOctave');
     if not TryStrToInt( iOctave.value, Octave) then exit;

     FrequencesCharter.Draw_Chart_from_Octave( Octave, 'cOctave');
     dOctave   := element_from_id('dOctave'   );
     dOctave.innerHTML:= Frequences.Liste( Octave);
end;

function TfjsFrequences.iFrequenceInput(_Event: TEventListenerEvent): boolean;
begin
     Traite_Frequence;
end;

procedure TfjsFrequences.Traite_Frequence;
var
   Frequence: double;
begin
     if not TryStrToFloat( iFrequence.value, Frequence) then exit;

     FrequencesCharter.Draw_Chart_from_Frequence( uFrequence.sFrequence( Frequence), Frequence, 'cFrequence');
     dFrequence.innerHTML:= Frequences.Liste_from_Frequence( Frequence);
     sFrequence .innerHTML:= uFrequence.sFrequence( Frequence);
end;

procedure TfjsFrequences.Traite_CPL_G3;
begin
     FrequencesCharter.Draw_Chart_from_Frequences( 7, 2, 'Porteuses CPL G3' , CPL_G3.F, 'cCPL_G3');
     dCPL_G3.innerHTML:= CPL_G3.Liste;
end;

procedure TfjsFrequences.Traite_Couleur;
const Octave=40;
begin
     FrequencesCharter.Draw_Chart_from_Octave( Octave, 'cCouleur', 2, False);
     dCouleur.innerHTML:= Frequences.Liste( Octave, 2);
end;

procedure TfjsFrequences.Traite_Gamme_Temperee( _Diapason: Integer; _Gamme_Temperee: TGamme_Temperee);
var
   sDiapason: String;
begin
     //WriteLn( ClassName+'.Traite_Gamme_Temperee(',_Diapason);
     sDiapason:= IntToStr( _Diapason);
     //WriteLn( 'sDiapason: ',sDiapason);
     FrequencesCharter.Draw_Chart_from_Frequences( 0, 1, 'Gamme tempérée diapason '+sDiapason+' Hz' , _Gamme_Temperee.Base, 'c'+sDiapason+'Hz');
     element_from_id('d'+sDiapason+'Hz').innerHTML:= _Gamme_Temperee.Liste(0);
end;

end.

