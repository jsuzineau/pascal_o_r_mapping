program jsTuneTrainer;

{$mode objfpc}
{$modeswitch advancedrecords}
uses
 uFrequence,
 BrowserConsole, BrowserApp, JS, Classes, SysUtils, Web, websvg, types,
 strutils;

type

 { TNote }

 TNote
 =
  record
    Note: String;
    non_coloriee: Boolean;
    c: TJSSVGCircleElement;
    x: Integer;
    procedure Init( _Note: String; _non_coloriee: Boolean);
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
    gA5 : TJSSVGGElement;
    cA5 : TJSSVGCircleElement;
    cGd5: TJSSVGCircleElement;
    cG5 : TJSSVGCircleElement;
    cFd5: TJSSVGCircleElement;
    cF5 : TJSSVGCircleElement;
    cE5 : TJSSVGCircleElement;
    cEb5: TJSSVGCircleElement;
    cD5 : TJSSVGCircleElement;
    cCd5: TJSSVGCircleElement;
    cC5 : TJSSVGCircleElement;
    cB4 : TJSSVGCircleElement;
    cBb4: TJSSVGCircleElement;
    cA4 : TJSSVGCircleElement;
    cGd4: TJSSVGCircleElement;
    cG4 : TJSSVGCircleElement;
    cFd4: TJSSVGCircleElement;
    cF4 : TJSSVGCircleElement;
    cE4 : TJSSVGCircleElement;
    cEb4: TJSSVGCircleElement;
    cD4 : TJSSVGCircleElement;
    cCd4: TJSSVGCircleElement;
    cC4 : TJSSVGCircleElement;
    gCd4: TJSSVGGElement;
    gC4 : TJSSVGGElement;
    rCurseur: TJSSVGRectElement;
  //Source
  private
    iSource: TJSHTMLInputElement;
    function iSourceInput(Event: TEventListenerEvent): boolean;
    procedure _from_Source;
  //Notes_non_coloriees
  private
    iNotes_non_coloriees: TJSHTMLInputElement;
    Notes_non_coloriees: TStringDynArray;
    function iNotes_non_colorieesInput(Event: TEventListenerEvent): boolean;
    procedure _from_Notes_non_coloriees;
    function Is_Note_non_coloriee( _Note: String): Boolean;
  //Notes
  private
    x_offset: Integer;
    x_ecart: Integer;
    x: Integer;
    Notes: array of TNote;
    procedure Notes_Vide;
    function Copie( _id: String; _non_coloriee: Boolean): TJSSVGCircleElement;
    function Copie_g( _id: String; _non_coloriee: Boolean): TJSSVGGElement;
  //Reponse
  private
    bDebut: TJSHTMLButtonElement;
    bDo  : TJSHTMLButtonElement;
    bDod : TJSHTMLButtonElement;
    bRe  : TJSHTMLButtonElement;
    bMib : TJSHTMLButtonElement;
    bMi  : TJSHTMLButtonElement;
    bFa  : TJSHTMLButtonElement;
    bFad : TJSHTMLButtonElement;
    bSol : TJSHTMLButtonElement;
    bSold: TJSHTMLButtonElement;
    bLa  : TJSHTMLButtonElement;
    bSib : TJSHTMLButtonElement;
    bSi  : TJSHTMLButtonElement;
    iReponse: Integer;
    procedure Check_Note( _Note: String);
    function bDebutClick(aEvent : TJSMouseEvent) : boolean;
    function bDoClick  (aEvent : TJSMouseEvent) : boolean;
    function bDodClick (aEvent : TJSMouseEvent) : boolean;
    function bReClick  (aEvent : TJSMouseEvent) : boolean;
    function bMibClick (aEvent : TJSMouseEvent) : boolean;
    function bMiClick  (aEvent : TJSMouseEvent) : boolean;
    function bFaClick  (aEvent : TJSMouseEvent) : boolean;
    function bFadClick (aEvent : TJSMouseEvent) : boolean;
    function bSolClick (aEvent : TJSMouseEvent) : boolean;
    function bSoldClick(aEvent : TJSMouseEvent) : boolean;
    function bLaClick  (aEvent : TJSMouseEvent) : boolean;
    function bSibClick (aEvent : TJSMouseEvent) : boolean;
    function bSiClick  (aEvent : TJSMouseEvent) : boolean;
  //Tests
  private
    bTestDieseBemol: TJSHTMLButtonElement;
    bTestNotes_non_coloriees: TJSHTMLButtonElement;
    b1: TJSHTMLButtonElement;
    b2: TJSHTMLButtonElement;
    b3: TJSHTMLButtonElement;
    function bTestDieseBemolClick(aEvent : TJSMouseEvent) : boolean;
    function bTestNotes_non_colorieesClick(aEvent : TJSMouseEvent) : boolean;
    function b1Click(aEvent : TJSMouseEvent) : boolean;
    function b2Click(aEvent : TJSMouseEvent) : boolean;
    function b3Click(aEvent : TJSMouseEvent) : boolean;
  //Curseur
  private
    procedure Curseur_from_iResponse;
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

       //WriteLn( '  name:', attr.name,' value:', attr.value, ' prefix:', attr.prefix, ' localName:',attr.localName, ' namespaceURI:',attr.namespaceURI);
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

{ TNote }

procedure TNote.Init(_Note: String; _non_coloriee: Boolean);
begin
     Note        := _Note;
     non_coloriee:= _non_coloriee;
end;

{ TjsTuneTrainer }

constructor TjsTuneTrainer.Create(aOwner: TComponent);
begin
     inherited Create(aOwner);
     Notes:= [];
     Notes_non_coloriees:=[];
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

function TjsTuneTrainer.Copie(_id: String; _non_coloriee: Boolean): TJSSVGCircleElement;
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

     //suppose que visibility est à la fin dy style
     i:= Pos('visibility: hidden;', style);
     delete( style, i, length(style));

     if _non_coloriee //suppose que le fill est juste avant visibility à la fin du style
     then
         begin
         i:= Pos('fill:', style);
         delete( style, i, length(style));
         end;

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

function TjsTuneTrainer.Copie_g(_id: String; _non_coloriee: Boolean): TJSSVGGElement;
var
   g: TJSSVGGElement;
   style: string;
   i: Integer;
begin
     //WriteLn( 'Copie_g(',_id,'): svg.to_string');
     //WriteLn( '  ',svg.toString);
     Result:= nil;

     g:= TJSSVGGElement(document.getElementById(_id));
     if g = nil then exit;

     Result:= TJSSVGGElement( g.cloneNode(true));
     Result.setAttribute('id', _id+'_copie');
     //Result.setAttribute('cx', IntToStr(x));
     Result.setAttribute('transform', 'translate('+IntToStr(x)+',0)');

     style:= Result.getAttribute('style');

     //suppose que visibility est à la fin dy style
     i:= Pos('visibility: hidden;', style);
     delete( style, i, length(style));

     if _non_coloriee //suppose que le fill est juste avant visibility à la fin du style
     then
         begin
         i:= Pos('fill:', style);
         delete( style, i, length(style));
         end;

     Result.setAttribute('style', style);

     Result:= TJSSVGGElement( svg.appendChild(Result));
     //Copy_element_attributes( 'copie:= c', Result, g);
     //WriteLn( 'Copie(',_id,'): copie.to_string');
     //WriteLn( '  ',Result.toString);
     //dump_element_variables( _id);
     //dump_element_attributes( 'c', g);
     //dump_element_attributes( 'Result', Result);
     Inc(x, x_ecart);
end;

procedure TjsTuneTrainer._from_Notes_non_coloriees;
var
   sNotes_non_coloriees: String;
   sa: TStringDynArray;
   i: Integer;
   S: String;
begin
     Notes_non_coloriees:= [];
     sNotes_non_coloriees:= iNotes_non_coloriees.value;
     if '' = sNotes_non_coloriees then exit;
     sa:= SplitString( sNotes_non_coloriees, ' ');
     for i:= low(sa) to high(sa)
     do
       sa[i]:= Note(Midi_from_Note(sa[i]));
     Notes_non_coloriees:= sa;
end;

function TjsTuneTrainer.Is_Note_non_coloriee( _Note: String): Boolean;
var
   Note: String;
begin
     Result:= False;
     for Note in Notes_non_coloriees
     do
       begin
       Result:= Note = _Note;
       if Result then break;
       end;
end;

procedure TjsTuneTrainer._from_Source;
   procedure Cree_Notes;
   var
      Source: String;
      sa: TStringDynArray;
      i: Integer;
      Source_Note: String;
      Midi_Note: Integer;
      Note: String;
      non_coloriee: Boolean;
   begin
        Source:= iSource.value;
        sa:= SplitString( Source, ' ');
        SetLength( Notes, Length( sa));
        for i:= low(sa) to high(sa)
        do
          begin
          Source_Note:= sa[i];

          Midi_Note:= Midi_from_Note( Source_Note);

          Note        := Note_Octave( Midi_Note);
          non_coloriee:= Is_Note_non_coloriee( uFrequence.Note(Midi_Note));

          Notes[i].Init( Note, non_coloriee);
          //Writeln(ClassName+'._from_Source :: Cree_Notes : Source_Note: ',Source_Note,', Midi_Note: ',Midi_Note,', Note: ',Note);
          end;
   end;
   procedure Copie_Notes;
   var
      i: Integer;
      N:String;
      nc: Boolean;
   begin
        //WriteLn( ClassName+'_from_Source:  Copie_Notes; window.innerWidth:',window.innerWidth);
        //x_ecart:= Trunc((window.innerWidth - x_offset)/(Length(Notes)-1));
        x_ecart:= Trunc((2670{svg.viewport} - x_offset)/Length(Notes));

        //2670
        //svg.viewportElement.Attrs[];
        for i:= Low(Notes) to High(Notes)
        do
          begin
          N:= Notes[i].Note;
          nc:= Notes[i].non_coloriee;
          Notes[i].x:= x;
          //WriteLn( ClassName+'._from_Source; Copie_Notes; Note:',Note);
          if    (N='G3')
             or (N='G#3')
             or (N='A3')
             or (N='Bb3')
             or (N='B3')
             or (N='C4')
             or (N='C#4')
             or (N='A5')
             or (N='Bb5')
             or (N='B5')
          then
              Notes[i].c:= TJSSVGCircleElement( Copie_g( 'g'+N, nc))
          else
              Notes[i].c:= Copie( N, nc);
          end;
   end;
begin
     Notes_Vide;
     Cree_Notes;
     Copie_Notes;
     Curseur_from_iResponse;
end;

function TjsTuneTrainer.iNotes_non_colorieesInput(Event: TEventListenerEvent): boolean;
begin
     _from_Notes_non_coloriees;
     _from_Source;
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
             begin
             iReponse:= 0;
             window.alert( 'Réussi!')
             end;
         Curseur_from_iResponse;
         end;
end;

procedure TjsTuneTrainer.Curseur_from_iResponse;
begin
     rCurseur.setAttribute('x', IntToStr(Notes[iReponse].x-(224 div 2)));
end;

function TjsTuneTrainer.bDebutClick(aEvent: TJSMouseEvent): boolean;
begin
     iReponse:= 0;
     Curseur_from_iResponse;
end;

function TjsTuneTrainer.bDoClick(aEvent: TJSMouseEvent): boolean;
begin
     Check_Note( 'C');
end;

function TjsTuneTrainer.bDodClick(aEvent: TJSMouseEvent): boolean;
begin
     Check_Note( 'C#');
end;

function TjsTuneTrainer.bReClick(aEvent: TJSMouseEvent): boolean;
begin
     Check_Note( 'D');
end;

function TjsTuneTrainer.bMibClick(aEvent: TJSMouseEvent): boolean;
begin
     Check_Note( 'Eb');
end;

function TjsTuneTrainer.bMiClick(aEvent: TJSMouseEvent): boolean;
begin
     Check_Note( 'E');
end;

function TjsTuneTrainer.bFaClick(aEvent: TJSMouseEvent): boolean;
begin
     Check_Note( 'F');
end;

function TjsTuneTrainer.bFadClick(aEvent: TJSMouseEvent): boolean;
begin
     Check_Note( 'F#');
end;

function TjsTuneTrainer.bSolClick(aEvent: TJSMouseEvent): boolean;
begin
     Check_Note( 'G');
end;

function TjsTuneTrainer.bSoldClick(aEvent: TJSMouseEvent): boolean;
begin
     Check_Note( 'G#');
end;

function TjsTuneTrainer.bLaClick(aEvent: TJSMouseEvent): boolean;
begin
     Check_Note( 'A');
end;

function TjsTuneTrainer.bSibClick(aEvent: TJSMouseEvent): boolean;
begin
     Check_Note( 'Bb');
end;

function TjsTuneTrainer.bSiClick(aEvent: TJSMouseEvent): boolean;
begin
     Check_Note( 'B');
end;

function TjsTuneTrainer.bTestDieseBemolClick(aEvent: TJSMouseEvent): boolean;
begin
     iSource.value:= 'sol2 sol#2 la2 sib2 si2 do do# re mib mi fa fa# sol sol# la sib si do4 do#4 re4 mib4 mi4 fa4 fa#4 sol4 sol#4 la4';
     iNotes_non_coloriees.value:= '';
     _from_Notes_non_coloriees;
     _from_Source;
end;

function TjsTuneTrainer.bTestNotes_non_colorieesClick(aEvent: TJSMouseEvent): boolean;
begin
     iSource.value:= 'do re mi fa sol la si do4 re4 mi4 fa4 sol4 la4';
     iNotes_non_coloriees.value:= 'la';
     _from_Notes_non_coloriees;
     _from_Source;
end;

function TjsTuneTrainer.b1Click(aEvent: TJSMouseEvent): boolean;
begin
     iSource.value:= 'sol2 la2 si2 do3 re3 mi3 fa3 sol3 la3 si3 do4 re4 mi4 fa4 sol4 la4 si4';
     iNotes_non_coloriees.value:= '';
     _from_Notes_non_coloriees;
     _from_Source;
end;

function TjsTuneTrainer.b2Click(aEvent: TJSMouseEvent): boolean;
begin
     iSource.value:= 'sol2 si2 re3 fa3 la3 do4 mi4 sol4 si4';
     iNotes_non_coloriees.value:= '';
     _from_Notes_non_coloriees;
     _from_Source;
end;

function TjsTuneTrainer.b3Click(aEvent: TJSMouseEvent): boolean;
begin
     iSource.value:= 'la2 do3 mi3 sol3 si3 re4 fa4 la4';
     iNotes_non_coloriees.value:= '';
     _from_Notes_non_coloriees;
     _from_Source;
end;

procedure TjsTuneTrainer.DoRun;
   procedure b( var _b: TJSHTMLButtonElement; _id: String; _onclick: THTMLClickEventHandler);
   begin
        _b:= button_from_id(_id);_b.onclick:= _onclick;
   end;
begin
     inherited DoRun;

     svg:= TJSSVGSVGElement(document.getElementById('svg'));

     gA5 := TJSSVGGElement(document.getElementById('gA5'));

     cA5 := circle_from_id( 'A5' );
     cGd5:= circle_from_id( 'Gd5');
     cG5 := circle_from_id( 'G5' );
     cFd5:= circle_from_id( 'Fd5');
     cF5 := circle_from_id( 'F5' );
     cE5 := circle_from_id( 'E5' );
     cEb5:= circle_from_id( 'Eb5');
     cD5 := circle_from_id( 'D5' );
     cCd5:= circle_from_id( 'Cd5');
     cC5 := circle_from_id( 'C5' );
     cB4 := circle_from_id( 'B4' );
     cBb4:= circle_from_id( 'Bb4');
     cA4 := circle_from_id( 'A4' );
     cGd4:= circle_from_id( 'Gd4');
     cG4 := circle_from_id( 'G4' );
     cFd4:= circle_from_id( 'Fd4');
     cF4 := circle_from_id( 'F4' );
     cE4 := circle_from_id( 'E4' );
     cEb4:= circle_from_id( 'Eb4');
     cD4 := circle_from_id( 'D4' );
     cCd4:= circle_from_id( 'Cd4');
     cC4 := circle_from_id( 'C4' );

     gCd4:= TJSSVGGElement(document.getElementById('gCd4'));
     gC4 := TJSSVGGElement(document.getElementById('gC4'));
     //Writeln( ClassName+'.DoRun; gC4:', gC4.toString);
     rCurseur:= TJSSVGRectElement(document.getElementById('rCurseur'));

     iSource:= input_from_id( 'iSource');
     iSource.oninput:= @iSourceInput;

     iNotes_non_coloriees:= input_from_id( 'iNotes_non_coloriees');
     iNotes_non_coloriees.oninput:= @iNotes_non_colorieesInput;

     _from_Notes_non_coloriees;
     _from_Source;

     b(bDebut                  ,'bDebut'                  ,@bDebutClick                  );
     b(bDo                     ,'bDo'                     ,@bDoClick                     );
     b(bDod                    ,'bDod'                    ,@bDodClick                    );
     b(bRe                     ,'bRe'                     ,@bReClick                     );
     b(bMib                    ,'bMib'                    ,@bMibClick                    );
     b(bMi                     ,'bMi'                     ,@bMiClick                     );
     b(bFa                     ,'bFa'                     ,@bFaClick                     );
     b(bFad                    ,'bFad'                    ,@bFadClick                    );
     b(bSol                    ,'bSol'                    ,@bSolClick                    );
     b(bSold                   ,'bSold'                   ,@bSoldClick                   );
     b(bLa                     ,'bLa'                     ,@bLaClick                     );
     b(bSib                    ,'bSib'                    ,@bSibClick                    );
     b(bSi                     ,'bSi'                     ,@bSiClick                     );
     b(bTestDieseBemol         ,'bTestDieseBemol'         ,@bTestDieseBemolClick         );
     b(bTestNotes_non_coloriees,'bTestNotes_non_coloriees',@bTestNotes_non_colorieesClick);
     b(b1                      ,'b1'                      ,@b1Click                      );
     b(b2                      ,'b2'                      ,@b2Click                      );
     b(b3                      ,'b3'                      ,@b3Click                      );
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
//do re mi fa sol la si do c5 ré4 ré3 d
