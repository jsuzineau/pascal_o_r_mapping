program jsTuneTrainer;

{$mode objfpc}

uses
 BrowserConsole, JS, Classes, SysUtils, Web, websvg,types;

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

const Ecart_x= 400;
var x: Integer= 0;
procedure Copie( _svg_id, _id: String);
var
   c: TJSSVGCircleElement;
   copie: TJSSVGCircleElement;
   parent : TJSElement;
   style: string;
   i: Integer;
begin
     Inc(x, Ecart_x);
     parent:= TJSElement( document.getElementById(_svg_id));
     WriteLn( 'Copie(',_id,'): parent.to_string');
     WriteLn( '  ',parent.toString);

     c:= TJSSVGCircleElement( document.getElementById(_id));
     //copie:= TJSSVGCircleElement(document.createElementNS('http://www.w3.org/2000/svg', 'circle'));
     //TJSObject.assign( copie, c);
     copie:= TJSSVGCircleElement( c.cloneNode(true));
     copie.setAttribute('id', _id+'_copie');
     copie.setAttribute('cx', IntToStr(x));
     style:= copie.getAttribute('style');
     i:= Pos('visibility: hidden;', style);
     delete( style, i, length(style));
     copie.setAttribute('style', style);

     parent.appendChild(copie);
     //Copy_element_attributes( 'copie:= c', copie, c);
     WriteLn( 'Copie(',_id,'): copie.to_string');
     WriteLn( '  ',copie.toString);
     dump_element_variables( _id);
     dump_element_attributes( 'c', c);
     dump_element_attributes( 'copie', copie);
end;

begin
     dump_element_variables( 'C4');
     Set_on_click( 'C4');
     Copie( 'svg2', 'G4');
     Copie( 'svg2', 'A4');
     Copie( 'svg2', 'F4');
     Copie( 'svg2', 'B4');
end.
