unit uPAS2JS_utils;

{$mode ObjFPC}

interface

uses
 Classes, SysUtils, JS, Web;

function element_from_id( _id: String): TJSHTMLElement;
function button_from_id( _id: String): TJSHTMLButtonElement;
function input_from_id( _id: String): TJSHTMLInputElement;

procedure Set_inner_HTML( _id: String; _inner_HTML: String);
procedure Set_input_value( _id: String; _value: String; _onchange: TJSEventHandler);
procedure Get_input_value( _id: String; var _value: String);

function Decode_Date( _S: String): TDateTime;

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

procedure Set_inner_HTML( _id: String; _inner_HTML: String);
var
   e: TJSHTMLElement;
begin
     e:= element_from_id( _id);
     if nil = e then Exit;

     e.innerHTML:= _inner_HTML;
end;

procedure Set_input_value( _id: String; _value: String; _onchange: TJSEventHandler);
var
   i: TJSHTMLInputElement;
begin
     i:= input_from_id( _id);
     if nil = i then Exit;

     i.value:= _value;
     i.onchange:= _onchange;
end;

procedure Get_input_value( _id: String; var _value: String);
var
   i: TJSHTMLInputElement;
begin
     i:= input_from_id( _id);
     if nil = i then Exit;

     _value:= i.value;
end;

function Decode_Date( _S: String): TDateTime;
var
   sYYYY, sMM, sDD, sHH, sNN: String;
   YYYY, MM, DD, HH, NN: Integer;
   OK: Boolean;
begin
     //F.ShortDateFormat:= 'YYYY/MM/DD HH:NN';
     //                     1234567890123456
     //                              1
     sYYYY:= Copy( _S,  1, 4);
     sMM  := Copy( _S,  6, 2);
     sDD  := Copy( _S,  9, 2);
     sHH  := Copy( _S, 12, 2);
     sNN  := Copy( _S, 15, 2);


     YYYY:= 0;
     MM  := 0;
     DD  := 0;
     HH  := 0;
     NN  := 0;

     OK:= True;
     if not TryStrToInt( sYYYY, YYYY) then OK:= False;
     if not TryStrToInt( sMM  , MM  ) then OK:= False;
     if not TryStrToInt( sDD  , DD  ) then OK:= False;
     if not TryStrToInt( sHH  , HH  ) then OK:= False;
     if not TryStrToInt( sNN  , NN  ) then OK:= False;

     if OK
     then
         Result:= EncodeDate( YYYY, MM, DD) + EncodeTime(HH,NN,0,0)
     else
         Result:= 0;
end;


end.

