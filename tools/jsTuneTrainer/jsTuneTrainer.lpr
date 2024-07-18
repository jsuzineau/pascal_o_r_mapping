program jsTuneTrainer;

{$mode objfpc}

uses
 BrowserConsole, BrowserApp, JS, Classes, SysUtils, Web, websvg, types,
 uFrequence;

type

 { TNote }

 TNote
 =
  record
    Note: String;
    c: TJSSVGCircleElement;
  end;

 { TjsTuneTrainer }

 TjsTuneTrainer
 =
  class(TBrowserApplication)
  //Gestion du cycle de vie
  public
    constructor Create(aOwner : TComponent); override;
  private
    procedure DoRun; override;
  //SVG
  private
    svg: TJSSVGSVGElement;
  //Elements
  private
    cA5: TJSSVGCircleElement;
    cG5: TJSSVGCircleElement;
    cF5: TJSSVGCircleElement;
    cE5: TJSSVGCircleElement;
    cD5: TJSSVGCircleElement;
    cC5: TJSSVGCircleElement;
    cB4: TJSSVGCircleElement;
    cA4: TJSSVGCircleElement;
    cG4: TJSSVGCircleElement;
    cF4: TJSSVGCircleElement;
    cE4: TJSSVGCircleElement;
    cD4: TJSSVGCircleElement;
    cC4: TJSSVGCircleElement;
  //Source
  private
    iSource: TJSHTMLInputElement;
    function iSourceInput(Event: TEventListenerEvent): boolean;
    procedure _from_Source;
  //Notes
  private
    x_offset: Integer;
    x_ecart: Integer;
    x: Integer;
    Notes: array of TNote;
    procedure Notes_Vide;
    function Copie( _id: String): TJSSVGCircleElement;
  //Reponse
  private
    bDebut: TJSHTMLButtonElement;
    bDo : TJSHTMLButtonElement;
    bRe : TJSHTMLButtonElement;
    bMi : TJSHTMLButtonElement;
    bFa : TJSHTMLButtonElement;
    bSol: TJSHTMLButtonElement;
    bLa : TJSHTMLButtonElement;
    bSi : TJSHTMLButtonElement;
    iReponse: Integer;
    procedure Check_Note( _Note: String);
    function bDebutClick(aEvent : TJSMouseEvent) : boolean;
    function bDoClick(aEvent : TJSMouseEvent) : boolean;
    function bReClick(aEvent : TJSMouseEvent) : boolean;
    function bMiClick(aEvent : TJSMouseEvent) : boolean;
    function bFaClick(aEvent : TJSMouseEvent) : boolean;
    function bSolClick(aEvent : TJSMouseEvent) : boolean;
    function bLaClick(aEvent : TJSMouseEvent) : boolean;
    function bSiClick(aEvent : TJSMouseEvent) : boolean;
  end;
var
   Application: TjsTuneTrainer;

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

function circle_from_id( _id: String): TJSSVGCircleElement;
begin
     Result:= TJSSVGCircleElement(document.getElementById(_id))
end;

procedure dump_element_variables( _id: String);
var
   o: TJSObject;
   s: String;
begin
     o:= document.getElementById(_id);

     WriteLn( 'dump_element_variables(',_id,'): keys');
     for s in TJSObject.keys( o) do WriteLn( '  ',s);

     WriteLn( 'dump_element_variables(',_id,'): to_string');
     WriteLn( '  ',o.toString);

     WriteLn( 'dump_element_variables(',_id,'): OwnPropertyNames');
     for s in TJSObject.getOwnPropertyNames( o) do WriteLn( '  ',s);
end;

function on_click(Event: TJSEvent): boolean;
begin
     WriteLn( 'clicked');
end;

procedure Set_on_click( _id: String);
var
   et: TJSEventTarget;
begin
     et:= TJSEventTarget( document.getElementById(_id));
     et.addEventListener('click', @on_click);
end;

procedure dump_element_attributes( _name: string; _e: TJSElement);
var
   attributes: TJSNamedNodeMap;
   i: Integer;
   attr: TJSAttr;
   s: String;
begin
     WriteLn( 'dump_element_attributes(',_name,'): attributes');
     attributes:= _e.attributes;
     for i:= 0 to attributes.length-1
     do
       begin
       attr:= attributes.item(i);

       WriteLn( '  name:', attr.name,' value:', attr.value, ' prefix:', attr.prefix, ' localName:',attr.localName, ' namespaceURI:',attr.namespaceURI);
       end;
end;

procedure Copy_element_attributes( _name: string; _cible, _source: TJSElement);
var
   attributes: TJSNamedNodeMap;
   i: Integer;
   attr: TJSAttr;
   s: String;
begin
     WriteLn( 'Copy_element_attributes(',_name,'): attributes');
     attributes:= _source.attributes;
     for i:= 0 to attributes.length-1
     do
       begin
       attr:= attributes.item(i);
       if attr.name = 'id' then continue;
       _cible.setAttributeNS( attr.namespaceURI, attr.name, String( attr.value));
       WriteLn( '  name:', attr.name,' value:', attr.value, ' prefix:', attr.prefix, ' localName:',attr.localName, ' namespaceURI:',attr.namespaceURI);
       end;
end;

//recopié depuis uuStrings
function StrToK( Key: String; var S: String): String;
var
   I: Integer;
begin
     I:= Pos( Key, S);
     if I = 0
     then
         begin
         Result:= S;
         S:= '';
         end
     else
         begin
         Result:= Copy( S, 1, I-1);
         Delete( S, 1, (I-1)+Length( Key));
         end;
end;

{ TjsTuneTrainer }

constructor TjsTuneTrainer.Create(aOwner: TComponent);
begin
     inherited Create(aOwner);
     Notes:= [];
     x_offset:= 400;//324;
     x_ecart:= 400;
     x:= 0;
end;

procedure TjsTuneTrainer.Notes_Vide;
var
   I: Integer;
   n: TNote;
begin
     for I:= Low(Notes) to High(Notes)
     do
       begin
       n:= Notes[I];
       if n.c = nil then continue;

       svg.removeChild(n.c);
       end;
     SetLength( Notes, 0);
     x:= x_offset;
end;

function TjsTuneTrainer.Copie(_id: String): TJSSVGCircleElement;
var
   c: TJSSVGCircleElement;
   style: string;
   i: Integer;
begin
     //WriteLn( 'Copie(',_id,'): svg.to_string');
     //WriteLn( '  ',svg.toString);
     Result:= nil;

     c:= circle_from_id(_id);
     if c = nil then exit;

     Result:= TJSSVGCircleElement( c.cloneNode(true));
     Result.setAttribute('id', _id+'_copie');
     Result.setAttribute('cx', IntToStr(x));
     style:= Result.getAttribute('style');
     i:= Pos('visibility: hidden;', style);
     delete( style, i, length(style));
     Result.setAttribute('style', style);

     Result:= TJSSVGCircleElement( svg.appendChild(Result));
     //Copy_element_attributes( 'copie:= c', Result, c);
     //WriteLn( 'Copie(',_id,'): copie.to_string');
     //WriteLn( '  ',Result.toString);
     //dump_element_variables( _id);
     //dump_element_attributes( 'c', c);
     //dump_element_attributes( 'Result', Result);
     Inc(x, x_ecart);
end;

procedure TjsTuneTrainer._from_Source;
   procedure Cree_Notes;
   var
      Source: String;
      Note: String;
   begin
        Source:= iSource.value;
        while Source <> ''
        do
          begin
          Note:= StrTok( ' ', Source);
          Note:= Note_Octave( Midi_from_Note( Note));
          SetLength( Notes, Length( Notes)+1);
          Notes[High(Notes)].Note:= Note;
          end;
   end;
   procedure Copie_Notes;
   var
      i: Integer;
   begin
        //WriteLn( ClassName+'_from_Source:  Copie_Notes; window.innerWidth:',window.innerWidth);
        //x_ecart:= Trunc((window.innerWidth - x_offset)/(Length(Notes)-1));
        x_ecart:= Trunc((2670{svg.viewport} - x_offset)/Length(Notes));

        //2670
        //svg.viewportElement.Attrs[];
        for i:= Low(Notes) to High(Notes)
        do
          with Notes[i] do c:= Copie( Note);
   end;
begin
     Notes_Vide;
     Cree_Notes;
     Copie_Notes;
end;

function TjsTuneTrainer.iSourceInput(Event: TEventListenerEvent): boolean;
begin
     _from_Source;
end;

procedure TjsTuneTrainer.Check_Note(_Note: String);
begin
     if iReponse >= Length( Notes) then exit;
     if Pos( _Note, Notes[iReponse].Note) <> 1
     then
         window.alert( 'Ce n''est pas la bonne note! '+_Note+' attendu '+Notes[iReponse].Note)
     else
         begin
         Inc(iReponse);
         if iReponse >= Length( Notes)
         then
             window.alert( 'Réussi!')
         end;
end;

function TjsTuneTrainer.bDebutClick(aEvent: TJSMouseEvent): boolean;
begin
     iReponse:= 0;
end;

function TjsTuneTrainer.bDoClick(aEvent: TJSMouseEvent): boolean;
begin
     Check_Note( 'C');
end;

function TjsTuneTrainer.bReClick(aEvent: TJSMouseEvent): boolean;
begin
     Check_Note( 'D');
end;

function TjsTuneTrainer.bMiClick(aEvent: TJSMouseEvent): boolean;
begin
     Check_Note( 'E');
end;

function TjsTuneTrainer.bFaClick(aEvent: TJSMouseEvent): boolean;
begin
     Check_Note( 'F');
end;

function TjsTuneTrainer.bSolClick(aEvent: TJSMouseEvent): boolean;
begin
     Check_Note( 'G');
end;

function TjsTuneTrainer.bLaClick(aEvent: TJSMouseEvent): boolean;
begin
     Check_Note( 'A');
end;

function TjsTuneTrainer.bSiClick(aEvent: TJSMouseEvent): boolean;
begin
     Check_Note( 'B');
end;

procedure TjsTuneTrainer.DoRun;
begin
     inherited DoRun;

     svg:= TJSSVGSVGElement(document.getElementById('svg'));

     cA5:= circle_from_id( 'A5');
     cG5:= circle_from_id( 'G5');
     cF5:= circle_from_id( 'F5');
     cE5:= circle_from_id( 'E5');
     cD5:= circle_from_id( 'D5');
     cC5:= circle_from_id( 'C5');
     cB4:= circle_from_id( 'B4');
     cA4:= circle_from_id( 'A4');
     cG4:= circle_from_id( 'G4');
     cF4:= circle_from_id( 'F4');
     cE4:= circle_from_id( 'E4');
     cD4:= circle_from_id( 'D4');
     cC4:= circle_from_id( 'C4');

     iSource:= input_from_id( 'iSource');
     iSource.oninput:= @iSourceInput;
     _from_Source;

     bDo := button_from_id('bDo' );bDo .onclick:= @bDoClick;
     bRe := button_from_id('bRe' );bRe .onclick:= @bReClick;
     bMi := button_from_id('bMi' );bMi .onclick:= @bMiClick;
     bFa := button_from_id('bFa' );bFa .onclick:= @bFaClick;
     bSol:= button_from_id('bSol');bSol.onclick:= @bSolClick;
     bLa := button_from_id('bLa' );bLa .onclick:= @bLaClick;
     bSi := button_from_id('bSi' );bSi .onclick:= @bSiClick;

end;

begin
     Application:= TjsTuneTrainer.Create( nil);
     Application.Initialize;
     Application.Run;

     //dump_element_variables( 'C4');
     //Set_on_click( 'C4');
     //Copie( 'svg', 'G4');
     //Copie( 'svg', 'A4');
     //Copie( 'svg', 'F4');
     //Copie( 'svg', 'B4');
end.
