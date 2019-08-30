unit uJSChamps;

{$mode delphi}{$H+}
{$modeswitch externalclass}

interface

uses
 Classes, SysUtils, JS;

type
  TJSProxy
  =
   class external name 'Proxy'(TJSObject)
     constructor New( _Target, _Handler: TJSObject);

   end;

  TOnSet= procedure( _propertyKey, _value: TJSObject) of object;

  { TJSChamps }

  TJSChamps
  =
   class( TJSObject)
   //proxy
   public
     proxy: TJSProxy;
     OnSet: TList;
   private
     handler: TJSObject;
     procedure proxy_OnSet( _propertyKey, _value: TJSObject);
   //Gestion du cycle de vie
   public
    constructor Create; reintroduce;
   end;

implementation

{ TJSChamps }

constructor TJSChamps.Create;
begin
     OnSet:= TList.Create;
     handler:= nil;
     asm
        this.handler=
           {
           set(target, propertyKey, value, receiver)
             {
             target.proxy_OnSet( propertyKey, value);
             return Reflect.set(target, propertyKey, value, receiver);
             }
           }
     end;
     Writeln( 'handler:', TJSJSON.stringify( handler));
     proxy:= TJSProxy.New( Self, handler);
     proxy_OnSet( nil, nil);
end;

procedure TJSChamps.proxy_OnSet( _propertyKey, _value: TJSObject);
var
   jsv: JSValue;
   os: TOnSet;
begin
     for jsv in OnSet
     do
       begin
       if not Assigned( jsv)  then continue;
       os := TOnSet(jsv);
       os( _propertyKey, _value);
       end;
end;

end.

