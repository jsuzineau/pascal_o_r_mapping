unit ufjsWordpress;

{$mode objfpc}{$H+}

interface

uses
    ujsWordpress_API_Client,
 Classes, SysUtils, Forms, Controls, Graphics, Dialogs,fpjson;

type

 { TfjsWordpress }

 TfjsWordpress = class(TForm)
 private

 public
   function Pages_from_slug( _slug: String): TJSONData;
 end;

var
 fjsWordpress: TfjsWordpress;

implementation

{$R *.lfm}

{ TfjsWordpress }

function TfjsWordpress.Pages_from_slug( _slug: String): TJSONData;
var
   wp: T_wp_v2_pages_get;
begin
     wp:= T_wp_v2_pages_get.Create;
     try
        wp.slug    ( _slug);
        wp.per_page( '100');
     finally
            FreeAndNil( wp);
            end;
end;

end.

