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
     OnSet: TOnSet;
     OnSet2: TOnSet;//pas propre provisoire pour tests
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
     OnSet:= nil;
     OnSet2:=nil;
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
begin
     if Assigned( OnSet) then OnSet( _propertyKey, _value);
     if Assigned( OnSet2) then OnSet2( _propertyKey, _value);
end;

end.

