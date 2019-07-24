unit uMimeType;

{$mode delphi}

interface

uses
 Classes, SysUtils;

function Extension_from_MimeType( _MimeType: String): String;

function MimeType_from_Extension( _Extension: String): String;

implementation

function Extension_from_MimeType( _MimeType: String): String;
begin
          if 'image/gif' = _MimeType then Result:= '.gif'
     else if 'image/png' = _MimeType then Result:= '.png'
     else if 'image/jpeg'= _MimeType then Result:= '.jpg'
     else                                 Result:= '';
end;

function MimeType_from_Extension( _Extension: String): String;
var
   Extension: String;
begin
     Extension:= LowerCase( _Extension);

     //Pages web
          if '.css'  = Extension then Result:= 'text/css'
     else if '.js'   = Extension then Result:= 'application/javascript'
     else if '.gif'  = Extension then Result:= 'image/gif'
     else if '.png'  = Extension then Result:= 'image/png'
     else if '.jpg'  = Extension then Result:= 'image/jpeg'
     else if '.svg' = _Extension then Result:= 'image/svg+xml'
     else if '.htm'  = Extension then Result:= 'text/html'
     else if '.html' = Extension then Result:= 'text/html'

     //PDF
     else if '.pdf'  = Extension then Result:= 'application/pdf'

     //Open Document
     else if '.odt'  = Extension then Result:= 'application/vnd.oasis.opendocument.text'
     else if '.ott'  = Extension then Result:= 'application/vnd.oasis.opendocument.text-template'
     else if '.ods'  = Extension then Result:= 'application/vnd.oasis.opendocument.spreadsheet'
     else if '.odg'  = Extension then Result:= 'application/vnd.oasis.opendocument.graphics'
     else if '.odp'  = Extension then Result:= 'application/vnd.oasis.opendocument.presentation'

     //Microsoft
     else if '.doc'  = Extension then Result:= 'application/msword'
     else if '.ttf' = _Extension then Result:= 'application/x-font-truetype'
     else if '.docx' = Extension then Result:= 'application/vnd.openxmlformats-officedocument.wordprocessingml.document'
     else if '.xls'  = Extension then Result:= 'application/vnd.ms-excel'
     else if '.xlsx' = Extension then Result:= 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
     else if '.ppt'  = Extension then Result:= 'application/vnd.ms-powerpoint'
     else if '.pptx' = Extension then Result:= 'application/vnd.openxmlformats-officedocument.presentationml.presentation'
     else if '.eot' = _Extension then Result:= 'application/vnd.ms-fontobject'

     else if '.' = Extension then Result:= 'application/octet-stream'
     else                         Result:= '';
end;

end.

