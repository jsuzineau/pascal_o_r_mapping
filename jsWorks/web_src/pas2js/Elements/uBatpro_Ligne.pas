unit uBatpro_Ligne;

{$mode ObjFPC}

interface

uses
 Classes, SysUtils,Types, JS,Web,
 uPAS2JS_utils;

type
    TBatpro_Ligne=class;
    T_from_Batpro_Ligne_procedure= procedure ( _bl: TBatpro_Ligne) of object;

    { TBatpro_Ligne }

    TBatpro_Ligne
    =
     class
       _from: T_from_Batpro_Ligne_procedure;
       constructor Create( _data: JSValue);virtual;
       procedure Ecrire;virtual;
       procedure Append_to( _tbody: TJSHTMLElement; __from: T_from_Batpro_Ligne_procedure);virtual;
       function click( aEvent : TJSMouseEvent) : boolean;
     end;

    TBatpro_Ligne_class= class of TBatpro_Ligne;

      { TslBatpro_Ligne }

      TslBatpro_Ligne
      =
       class
         Nom: String;
         JSON_Debut: Integer;
         JSON_Fin  : Integer;
         Count: Integer;
         Elements: array of TBatpro_Ligne;
         Element_class: TBatpro_Ligne_class;
         constructor Create( _data: JSValue; _Element_class: TBatpro_Ligne_class);
         procedure Ecrire;
         procedure Append_to( _tbody: TJSHTMLElement;
                              _from: T_from_Batpro_Ligne_procedure);

       end;

procedure Requete( _URL: String;
                   _tbody_id:String;
                   _Element_Class: TBatpro_Ligne_class;
                   __from: T_from_Batpro_Ligne_procedure);

procedure Poste( _URL, _body: String;
                 _Element_Class: TBatpro_Ligne_class;
                 __from: T_from_Batpro_Ligne_procedure);

implementation

procedure Requete( _URL: String;
                   _tbody_id:String;
                   _Element_Class: TBatpro_Ligne_class;
                   __from: T_from_Batpro_Ligne_procedure);
var
   hr:TJSXMLHttpRequest;
begin
     hr:= TJSXMLHttpRequest.new;
     hr.Open('GET', _URL);
     hr.addEventListener
       (
       'load',
       procedure
       var
          json: String;
          data: JSValue;
          sl: TslBatpro_Ligne;
          s: string;
          tbody: TJSHTMLElement;
       begin
            //window.fetch();

            json:= hr.responseText;
            data:= TJSJSON.parse( json);

            tbody:= element_from_id( _tbody_id);

            sl:= TslBatpro_Ligne.Create(data, _Element_Class);

            //Writeln( 'json:');
            //Writeln( json);
            //Writeln( 'data:');
            //Writeln( data);
            //sl.Ecrire;

            sl.Append_to(tbody, __from);
            if sl.Count > 0
            then
                __From( sl.Elements[0]);
       end
       );
     hr.send;
end;

procedure Poste( _URL, _body: String;
                 _Element_Class: TBatpro_Ligne_class;
                 __from: T_from_Batpro_Ligne_procedure);
var
   hr:TJSXMLHttpRequest;
begin
     hr:= TJSXMLHttpRequest.new;
     hr.Open('Post', _URL);
     hr.addEventListener
       (
       'load',
       procedure
       var
          json: String;
          data: JSValue;
          bl: TBatpro_Ligne;
       begin
            json:= hr.responseText;
            data:= TJSJSON.parse( json);

            //Writeln( 'json:');
            //Writeln( json);
            //Writeln( 'data:');
            //Writeln( data);
            bl:= _Element_Class.Create( data);
            __From( bl);
       end
       );
     hr.send( _body);
end;


{ TBatpro_Ligne }

constructor TBatpro_Ligne.Create(_data: JSValue);
var
   O: TJSObject;
   O_keys: TStringDynArray;
   i: Integer;
   key: String;
   prop: JSValue;
begin
     O:= TJSObject(_data);
     O_keys:= TJSObject.keys( O);
     for i:= Low(O_keys) to High(O_keys)
     do
       begin
       key:= O_keys[i];
       prop:= o.Properties[key];
       //Writeln( key,':',prop);
       asm
          this[key]= prop;
       end;
       end;
end;

procedure TBatpro_Ligne.Ecrire;
begin

end;

procedure TBatpro_Ligne.Append_to( _tbody: TJSHTMLElement;
                                   __from: T_from_Batpro_Ligne_procedure);
begin
     _from:= __from;
end;

function TBatpro_Ligne.click(aEvent: TJSMouseEvent): boolean;
begin
     _from( self);
end;

{ TslBatpro_Ligne }

constructor TslBatpro_Ligne.Create( _data: JSValue;
                                    _Element_class: TBatpro_Ligne_class);
   procedure init_asm;
   begin
        asm
           this.Nom= _data.Nom;
           this.JSON_Debut=_data.JSON_Debut;
           this.JSON_Fin=_data.JSON_Fin;
           this.Count=_data.Count;
        end;
   end;
   procedure init_object;
   var
      O: TJSObject;
      A: TJSArray;
      i: Integer;
      bl: TBatpro_Ligne;
   begin
        O:= TJSObject( _data);
        Nom       := String  (O.Properties['Nom'       ]);
        JSON_Debut:= Integer (O.Properties['JSON_Debut']);
        JSON_Fin  := Integer (O.Properties['JSON_Fin'  ]);
        Count     := Integer (O.Properties['Count'     ]);
        A         := TJSArray(O.Properties['Elements'  ]);
        SetLength( Elements, A.Length);
        for i:= Low(Elements) to High(Elements)
        do
          begin
          bl:= Element_class.Create( A.Elements[i]);
          Elements[i]:= bl;
          end;
   end;
begin
     Element_class:= _Element_class;
     //init_asm;
     init_object;
end;

procedure TslBatpro_Ligne.Ecrire;
var
   i: Integer;
begin
     Writeln( 'Nom: ', Nom);
     Writeln( 'JSON_Debut: ', JSON_Debut);
     Writeln( 'JSON_Fin: ', JSON_Fin);
     Writeln( 'Count: ', Count);
     for i:= 0 to Count -1
     do
       begin
       Writeln( 'i=',i);
       Elements[i].Ecrire;
       WriteLn;
       end;
end;

procedure TslBatpro_Ligne.Append_to( _tbody: TJSHTMLElement;
                                     _from: T_from_Batpro_Ligne_procedure);
var
   i: Integer;
begin
     _tbody.innerHTML:= '';
     for i:= 0 to Count -1
     do
       Elements[i].Append_to( _tbody, _from);
end;

end.

