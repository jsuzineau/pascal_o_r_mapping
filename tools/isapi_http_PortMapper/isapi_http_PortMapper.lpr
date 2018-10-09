library isapi_http_PortMapper;
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            http://www.mars42.com                                               |
                                                                                |
    Copyright 2014 Jean SUZINEAU - MARS42                                       |
                                                                                |
    This program is free software: you can redistribute it and/or modify        |
    it under the terms of the GNU Lesser General Public License as published by |
    the Free Software Foundation, either version 3 of the License, or           |
    (at your option) any later version.                                         |
                                                                                |
    This program is distributed in the hope that it will be useful,             |
    but WITHOUT ANY WARRANTY; without even the implied warranty of              |
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the               |
    GNU Lesser General Public License for more details.                         |
                                                                                |
    You should have received a copy of the GNU Lesser General Public License    |
    along with this program.  If not, see <http://www.gnu.org/licenses/>. 1     |
                                                                                |
|                                                                               }

{Adapted from The Micro Pascal WebServer, http://wiki.freepascal.org/Networking }
{Adapted from https://www.gocher.me/ISAPI-Interface-Example }

{$mode objfpc}{$H+}

uses
    {$ifdef unix}
      cthreads,
      cmem, // the c memory manager is on some systems much faster for multi-threading
    {$endif}
    uuStrings,
    uEXE_INI,
    uLog,
  Classes, blcksock, sockets, Synautil, SysUtils,fphttpclient,process,ISAPI;

type
{ TISAPI_Session }

TISAPI_Session
=
 class
 //Gestion du cycle de vie
 public
   constructor Create( _ECB: TEXTENSION_CONTROL_BLOCK);
   destructor Destroy; override;
 //Session
 private
   ECB: TEXTENSION_CONTROL_BLOCK;
 //Méthodes
 protected
   procedure ISAPI_Log_WriteLn( _S: String);
   procedure WriteClient( _S: String);
 private
   function http_getS( _URL: String): String;
   function http_get( _URL: String; out _Content_Type, _Server: String; _Body: String= ''): String;
   function http_Port_Valide( _Port: String): Boolean;
   function httpProgramme_Execute( _NomProgramme: String): String;
 public
   procedure Execute;
 end;

type
 { TConnectionThread }

 TConnectionThread
 =
  class( TThread)
  //Gestion du cycle de vie
  public
    constructor Create( _ECB: TEXTENSION_CONTROL_BLOCK);
    destructor Destroy; override;
  //Attributs
  public
    s: TISAPI_Session;
  //Méthodes surchargées
  protected
    procedure Execute; override;
  end;

const
     s_Validation         ='Validation';
     s_Validation_Response='pascal_o_r_mapping';

 { TISAPI_Session }

 constructor TISAPI_Session.Create(_ECB: TEXTENSION_CONTROL_BLOCK);
 begin
      ECB:= _ECB;
      ISAPI_Log_WriteLn( 'LogDir:'+Log.Repertoire);
 end;

 destructor TISAPI_Session.Destroy;
 begin
      inherited Destroy;
 end;

procedure TISAPI_Session.ISAPI_Log_WriteLn( _S: String);
var
   dwSizeOfBuffer: DWord;
begin
     _S:= 'TISAPI_Session($'+IntToHex(Int64(Pointer(Self)), 16)+'):'+_S;
     Log.PrintLn( _S);
     _S:=_S+',';
     dwSizeOfBuffer:= Length( _S);
     ECB.ServerSupportFunction( ECB.ConnID, HSE_APPEND_LOG_PARAMETER, Pointer(_S), @dwSizeOfBuffer, nil);
end;

procedure TISAPI_Session.WriteClient( _S: String);
var
   dwSizeOfBuffer: DWord;
begin
     //à revoir dans le cas UTF8
     dwSizeOfBuffer:= Length( _S);
     ECB.WriteClient( ECB.ConnID, Pointer(_S), dwSizeOfBuffer, 0);
end;

function TISAPI_Session.http_getS( _URL: String): String;
var
   c: TFPHttpClient;
begin
     try
        c:= TFPHttpClient.Create( nil);
        try
           Result:= c.Get( _URL);
        finally
               FreeAndNil( c);
               end;
     except
           on E: Exception
           do
             begin
             Result:= '';
             ISAPI_Log_WriteLn(  'http_getS( '+_URL+'): '+E.Message);
             end;
           end;

     ISAPI_Log_WriteLn( 'http_getS( '+_URL+')= ');
     ISAPI_Log_WriteLn( '################');
     ISAPI_Log_WriteLn( Result);
     ISAPI_Log_WriteLn( '################')
end;

function TISAPI_Session.http_get( _URL: String; out _Content_Type, _Server: String; _Body: String= ''): String;
var
   c: TFPHttpClient;
   procedure Parse_headers;
   var
      I: Integer;
      S: String;
      Key, Value: String;
   begin
        _Content_Type:= '';
        _Server      := '';
        for I:= 0 to c.ResponseHeaders.Count-1
        do
          begin
          S:= c.ResponseHeaders.Strings[I];
          Key:= StrToK(':', S); Key:= UpperCase( Key);
          Value:= S;
               if 'CONTENT-TYPE'= Key then _Content_Type:= Value
          else if 'SERVER'      = Key then _Server      := Value;
          end;
   end;
begin
     ISAPI_Log_WriteLn(  'http_get( '+_URL+')= ');
     try
        c:= TFPHttpClient.Create( nil);
        try
           if '' = _Body
           then
               begin
               ISAPI_Log_WriteLn( '  c.Get( _URL)');
               Result:= c.Get( _URL);
               end
           else
               begin
               ISAPI_Log_WriteLn( '  c.FormPost( _URL, _Body)');
               ISAPI_Log_WriteLn( _Body);
               Result:= c.FormPost( _URL, _Body);
               end;
           ISAPI_Log_WriteLn( '  aprés c.Get / c.FormPost');
           Parse_headers;
           ISAPI_Log_WriteLn( '####Headers#####');
           ISAPI_Log_WriteLn( c.ResponseHeaders.Text);

           ISAPI_Log_WriteLn( '#########');
           ISAPI_Log_WriteLn( '_Content_Type='+_Content_Type);
           ISAPI_Log_WriteLn( '_Server='      +_Server      );
        finally
               FreeAndNil( c);
               end;
     except
           on E: Exception
           do
             begin
             Result:= '';
             ISAPI_Log_WriteLn(  'http_get( '+_URL+'): '+E.Message);
             end;
           end;

     ISAPI_Log_WriteLn( '###Result#####');
     ISAPI_Log_WriteLn( Result);
     ISAPI_Log_WriteLn( '################');
end;

function TISAPI_Session.http_Port_Valide( _Port: String): Boolean;
var
   URL: String;
begin
     URL:= 'http://localhost:'+_Port+'/'+s_Validation;
     Result:= s_Validation_Response = http_getS( URL);
end;

function TISAPI_Session.httpProgramme_Execute( _NomProgramme: String): String;
const Taille=1024;
var
   NomResultat: String;
   p: TProcess;
   procedure Result_from_NomResultat;
   var
      NbTests: Integer;
   begin
        NbTests:= 0;
        repeat
              Result:= String_from_File( NomResultat);
              if '' <> Result then break;
              Sleep( 1000);
        until NbTests > 5;
        Result:= Trim(Result);
   end;
   procedure Result_from_stdout;
   var
      Read_Length: Integer;
   begin
        SetLength( Result, Taille);
        Read_Length:= p.Output.Read( Result[1], Taille);
        SetLength( Result, Read_Length);
        Result:= Trim(Result);
   end;
begin
     NomResultat:= ChangeFileExt( _NomProgramme, '_URL.txt');
     DeleteFile( NomResultat);
     p:= TProcess.Create( nil);
     try
        p.Executable:= _NomProgramme;
        p.Options := [poUsePipes];
        ISAPI_Log_WriteLn( 'httpProgramme_Execute: avant TProcess.execute sur '+_NomProgramme);
        p.Execute;
        ISAPI_Log_WriteLn( 'httpProgramme_Execute: aprés TProcess.execute');
        //Result_from_NomResultat;
        Result_from_stdout;

        ISAPI_Log_WriteLn( 'httpProgramme_Execute: Result= '+Result);
     finally
            FreeAndNil( p);
            end;
end;

procedure TISAPI_Session.Execute;
var
   Method, QueryString, PathInfo, PathTranslated: string;
   cbTotalBytes: DWord;
   cbAvailable : DWord;
   Data: string;
   slData: TStringList;

   uri: String;
   sPort: String;
   nPort: Integer;

   Has_Body: Boolean;
   Content_Length: Integer;

   procedure Traite_Content_Length;
   const
        s_Content_Length='content-length:';
   var
      NBLignes: Integer;
      I: Integer;
      s: String;
   begin
        NBLignes:= slData.Count;
        if 0 = NBLignes then exit;

        for I:= 0 to NBLignes-1
        do
          begin
          s:= LowerCase( slData[I]);
          if 1 <> Pos(s_Content_Length, s) then continue;

          StrToK(s_Content_Length, s);
          Has_Body:= TryStrToInt( s, Content_Length);
          ISAPI_Log_WriteLn( 'content-length:'+s);
          break;
          end;
   end;
   procedure Send_Not_found;
   begin
        WriteClient( 'HTTP/1.0 404' + CRLF);
   end;
   procedure Send_Redirect( _URL: String);
   begin
        WriteClient( 'HTTP/1.1 303 See Other' + CRLF);
        WriteClient( 'Location: '+ _URL+ CRLF);
   end;
   procedure Send_Validation;
   begin
        WriteClient( 'HTTP/1.0 200' + CRLF);
        WriteClient( 'Content-type: text/plain' + CRLF);
        WriteClient( 'Content-length: ' + IntTostr(Length(s_Validation_Response)) + CRLF);
        WriteClient( 'Connection: close' + CRLF);
        WriteClient( 'Date: ' + Rfc822DateTime(now) + CRLF);
        WriteClient( 'Server: http_PortMapper' + CRLF);
        WriteClient( '' + CRLF);

       //  if ASocket.lasterror <> 0 then HandleError;

        WriteClient( s_Validation_Response);
   end;
   procedure Send_Forward;
   var
      Body: String;
      Forward_URL: String;
      Forward_Result      : String;
      Forward_Content_Type: String;
      Forward_Server      : String;
   begin
        if not http_Port_Valide( sPort)
        then
            begin
            Send_Not_found;
            exit;
            end;

        Forward_URL:= 'http://localhost:'+sPort+'/'+uri;

        if Has_Body
        then
            Body:= slData.Text
        else
            Body:= '';

        Forward_Result:= http_get( Forward_URL, Forward_Content_Type, Forward_Server, Body);

        ECB.dwHTTPStatusCode:= 200;
        WriteClient( 'HTTP/1.0 '+IntToStr(ECB.dwHTTPStatusCode) + CRLF);
        WriteClient( 'Content-type: '+Forward_Content_Type + CRLF);
        WriteClient( 'Content-length: ' + IntTostr(Length(Forward_Result)) + CRLF);
        WriteClient( 'Connection: close' + CRLF);
        WriteClient( 'Date: ' + Rfc822DateTime(now) + CRLF);
        WriteClient( 'Server: '+Forward_Server + CRLF);
        WriteClient( '' + CRLF);
        WriteClient( Forward_Result);
   end;
   function httpLauncher_: Boolean;
   var
      Key: String;
      NomProgramme: String;
   begin
        Result:= True;

        Key:= sPort; //pas propre, il faudrait renommer sPort

        NomProgramme:= EXE_INI.ReadString( 'httpLauncher', Key, '#');
        ISAPI_Log_WriteLn(  'httpLauncher_: NomProgramme('+Key+')='+NomProgramme);
        if '#' = NomProgramme            then exit;
        if not FileExists( NomProgramme) then exit;
        ISAPI_Log_WriteLn(  'httpLauncher_: OK');
        Send_Redirect( httpProgramme_Execute( NomProgramme));
        Result:= False;
   end;
begin
     ISAPI_Log_WriteLn( 'Received headers+document from browser:');

     Method        := StrPas( ECB.lpszMethod        );
     QueryString   := StrPas( ECB.lpszQueryString   );
     PathInfo      := StrPas( ECB.lpszPathInfo      );
     PathTranslated:= StrPas( ECB.lpszPathTranslated);
     cbTotalBytes:= ECB.cbTotalBytes;
     cbAvailable := ECB.cbAvailable;
     ISAPI_Log_WriteLn( 'Method: '       + Method                 );
     ISAPI_Log_WriteLn( 'QueryString:'   + QueryString            );
     ISAPI_Log_WriteLn( 'PathInfo:'      + PathInfo               );
     ISAPI_Log_WriteLn( 'PathTranslated:'+ PathTranslated         );
     ISAPI_Log_WriteLn( 'cbTotalBytes:'  + IntToStr( cbTotalBytes));
     ISAPI_Log_WriteLn( 'cbAvailable:'   + IntToStr( cbAvailable ));

     slData:= TStringList.Create;
     try
        if cbTotalBytes <> cbAvailable
        then
            ISAPI_Log_WriteLn( 'Cas cbTotalBytes <> cbAvailable non géré')
        else if 0 <> cbAvailable
        then
            begin
            ISAPI_Log_WriteLn( 'Lecture');
            //pas trop propre si l'on a de l'UTF8
            SetLength( Data, ECB.cbAvailable);
            Move( ECB.lpbData^, Data[1], ECB.cbAvailable);
            slData.Text:= Data;
            end;

        ISAPI_Log_WriteLn( 'Data:'+ Data);

        Has_Body:= False;
        Content_Length:= 0;
        Traite_Content_Length;
        while (slData.Count > 0) and ('' <> slData[0]) do slData.Delete(0);
        if (slData.Count>0)and('' = slData[0]) then slData.Delete(0);

        // Now write the document to the output stream
        uri:= PathInfo;
        StrTok( '/', uri);//enlève le  premier /
        StrTok( '/', uri);//enlève l'alias
        sPort:= StrTok( '/', uri);
        ISAPI_Log_WriteLn( 'sPort:'+sPort);

             if TryStrToInt( sPort, nPort) then Send_Forward
        else if s_Validation = sPort       then Send_Validation
        else if httpLauncher_              then Send_Not_found;

     finally
            FreeAndNil( slData);
            end;
     ECB.ServerSupportFunction( ECB.ConnID, HSE_REQ_DONE_WITH_SESSION, nil, nil, nil);
end;

{ TConnectionThread }

constructor TConnectionThread.Create( _ECB: TEXTENSION_CONTROL_BLOCK);
begin
     s:= TISAPI_Session.Create( _ECB);
     FreeOnTerminate := True;
     inherited Create( False);
end;

destructor TConnectionThread.Destroy;
begin
     FreeAndNil( s);
     inherited Destroy;
end;

procedure TConnectionThread.Execute;
begin
     s.Execute;
end;

function GetExtensionVersion(var pVer: THSE_VERSION_INFO): BOOL; stdcall;
begin
     pVer.dwExtensionVersion:= LONG((WORD(HSE_VERSION_MINOR)) or ((DWORD(WORD(HSE_VERSION_MAJOR))) shl 16));
     pVer.lpszExtensionDesc := 'http_PortMapper ISAPI DLL'#0;
     Result:= True;
end;

function TerminateExtension(dwFlags: DWORD): BOOL; stdcall;
begin
     // This is so that the Apache web server will know what "True" really is
     Integer(result) := 1;
end;

function HttpExtensionProc(var _ECB: TEXTENSION_CONTROL_BLOCK): DWORD; stdcall;
    procedure Async;
    begin
         TConnectionThread.Create( _ECB);
         Result := HSE_STATUS_PENDING;
    end;
    procedure Sync;
    var
       s: TISAPI_Session;
    begin
         s:= TISAPI_Session.Create( _ECB);
         try
            s.Execute;
         finally
                FreeAndNil(s);
                end;
         Result := HSE_STATUS_SUCCESS;
    end;
begin
     Log.PrintLn( 'HttpExtensionProc, '+_ECB.lpszPathInfo+', Début');
     Result := HSE_STATUS_ERROR;
     //Async;
     Sync;
     Log.PrintLn( 'HttpExtensionProc, '+_ECB.lpszPathInfo+', Fin');
end;

exports GetExtensionVersion, HttpExtensionProc, TerminateExtension;

end.


