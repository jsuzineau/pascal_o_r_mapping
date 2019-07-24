{
http://www.gocher.me/ISAPI

Copyright (c) 2007-2015, Udo Schmal <udo.schmal@t-online.de>

Permission to use, copy, modify, and/or distribute the software for any purpose
with or without fee is hereby granted, provided that the above copyright notice
and this permission notice appear in all copies.

THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH
REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND
FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT,
INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM
LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE
OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
PERFORMANCE OF THIS SOFTWARE.
}
library helloworld;
{$ifdef fpc}
  {$mode objfpc}{$H+}
{$endif}

uses SysUtils, Classes, ISAPI;

function GetExtensionVersion(var pVer: THSE_VERSION_INFO): BOOL; stdcall;
begin
  pVer.dwExtensionVersion := LONG((WORD(HSE_VERSION_MINOR)) or ((DWORD(WORD(HSE_VERSION_MAJOR))) shl 16));
  pVer.lpszExtensionDesc := 'Simple ISAPI DLL' + #0;
  result := true;
end;

function TerminateExtension(dwFlags: DWORD): BOOL; stdcall;
begin
  // This is so that the Apache web server will know what "True" really is
  Integer(result) := 1;
end;

function HttpExtensionProc(var pECB: TEXTENSION_CONTROL_BLOCK): DWORD; stdcall;
var
  HTTPStatusCode: integer;
  dwLen: Cardinal;
  sResponse: string;
begin
  HTTPStatusCode := 200;
  result := HSE_STATUS_ERROR;
  sResponse := '<?xml version="1.0" encoding="utf-8"?>'#13#10 +
               '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">'#13#10 +
               '<html xmlns="http://www.w3.org/1999/xhtml" lang="de" xml:lang="de">'#13#10 +
               '  <head>'#13#10 +
               '    <meta http-equiv="content-type" content="text/html; charset=utf-8" />'#13#10 +
               '    <meta http-equiv="content-language" content="de" />'#13#10 +
               '    <title>Hallo Welt</title>'#13#10 +
               '  </head>'#13#10 + 
               '  <body>'#13#10 +
               '    <p>Hallo Welt!</p>'#13#10 +
               '  </body>'#13#10 +
               '</html>';
  sResponse := 'HTTP/1.1 '+ IntToStr(HTTPStatusCode) + #13#10 +
               'Content-Type: text/html' + #13#10 +
               'Content-Length: ' + Format('%d', [Length(sResponse)]) + #13#10 +
               'Content:'#13#10#13#10 + sResponse;

  pECB.dwHTTPStatusCode := HTTPStatusCode;
  dwLen := Length(sResponse);
  pECB.WriteClient(pECB.ConnID, Pointer(sResponse), dwLen, 0);
  Result := HSE_STATUS_SUCCESS;
end;

exports GetExtensionVersion, HttpExtensionProc, TerminateExtension;

end.
