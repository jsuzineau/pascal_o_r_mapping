unit uHTTP_Interface;
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
    along with this program.  If not, see <http://www.gnu.org/licenses/>.       |
                                                                                |
|                                                                               }

{$mode delphi}

interface

uses
    uClean,
    uuStrings,
    uBatpro_StringList,
    uBatpro_Element,
 {$ifdef fpc}
 blcksock, sockets, Synautil, fphttpclient,
 {$endif}
 Classes, SysUtils;

type

 { THTTP_Interface }

 THTTP_Interface
 =
  class
  //Gestion du cycle de vie
  public
    constructor Create;
    destructor Destroy; override;
  //Attributs
  public
    S: TTCPBlockSocket;
    Racine: String;
    slPool: Tslpool_Ancetre_Ancetre;
  //méthodes d'envoi de données
  public
    procedure Send_Data(_Content_type, _Data: String);
    procedure Send_HTML(_HTML: String);
    procedure Send_JSON(_JSON: String);
    procedure Send_Not_found;
    procedure Traite_racine;
  //enregistrement d'un pool
  public
    procedure Register_pool( _pool: Tpool_Ancetre_Ancetre);
  //Traitement des appels
  private
    procedure Traite_pool;
  public
    uri: String;
    function Prefixe( _Prefixe: String): Boolean;
    procedure Traite( _uri: String);
  end;

function HTTP_Interface: THTTP_Interface;

implementation

var
   FHTTP_Interface: THTTP_Interface= nil;

function HTTP_Interface: THTTP_Interface;
begin
     if nil = FHTTP_Interface
     then
         FHTTP_Interface:= THTTP_Interface.Create;
     Result:= FHTTP_Interface;
end;

{ THTTP_Interface }

constructor THTTP_Interface.Create;
begin
     S:= nil;
     Racine:= '';
     slPool:= Tslpool_Ancetre_Ancetre.Create( ClassName+'.slPool');
end;

destructor THTTP_Interface.Destroy;
begin
     Free_nil( slPool);
     inherited Destroy;
end;

procedure THTTP_Interface.Send_Data( _Content_type, _Data: String);
begin
     S.SendString('HTTP/1.0 200' + CRLF);
     S.SendString('Content-type: '+_Content_type + CRLF);
     S.SendString('Content-length: ' + IntTostr(Length(_Data)) + CRLF);
     S.SendString('Connection: close' + CRLF);
     S.SendString('Date: ' + Rfc822DateTime(now) + CRLF);
     S.SendString('Server: http_jsWorks' + CRLF);
     S.SendString('' + CRLF);

    //  if S.lasterror <> 0 then HandleError;

     S.SendString(_Data);
end;

procedure THTTP_Interface.Send_HTML( _HTML: String);
begin
     Send_Data( 'Text/Html', _HTML);
end;

procedure THTTP_Interface.Send_JSON( _JSON: String);
begin
     Send_Data( 'text/json;charset=utf-8', _JSON);
end;

procedure THTTP_Interface.Send_Not_found;
begin
     S.SendString('HTTP/1.0 404' + CRLF);
end;

procedure THTTP_Interface.Traite_racine;
var
   sl: TStringList;
begin
     sl:= TStringList.Create;
     sl.LoadFromFile( Racine);
     Send_HTML( sl.Text);
     FreeAndNil( sl);
end;

procedure THTTP_Interface.Register_pool(_pool: Tpool_Ancetre_Ancetre);
begin
     slPool.AddObject( _pool.NomTable_public, _pool);
end;

function THTTP_Interface.Prefixe( _Prefixe: String): Boolean;
begin
     Result:= 1=Pos( _Prefixe, uri);
     if not Result then exit;
     StrTok( _Prefixe, uri);
end;

procedure THTTP_Interface.Traite_pool;
var
   I: TIterateur_pool_Ancetre_Ancetre;
   pool: Tpool_Ancetre_Ancetre;
begin
     I:= slPool.Iterateur;

     while I.Continuer
     do
       begin
       if I.not_Suivant( pool) then continue;

       if not Prefixe( pool.NomTable_public) then continue;

       if not pool.Traite_HTTP
       then
           Send_Not_found;
       exit; //Sortie normale
       end;

     Send_Not_found; //Erreur, aucun pool trouvé
end;

procedure THTTP_Interface.Traite( _uri: String);
begin
     uri:= _uri;

     StrTok( '/', uri);
     if '' = uri
     then
         Traite_racine
     else
         Traite_pool  ;
end;


initialization

finalization
            FreeAndNil( FHTTP_Interface);
end.

