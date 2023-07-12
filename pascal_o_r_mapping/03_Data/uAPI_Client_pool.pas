unit uAPI_Client_pool;
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            http://www.mars42.com                                               |
                                                                                |
    Copyright 2023 Jean SUZINEAU - MARS42                                       |
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
    uDataUtilsU,
    uLog,
    uAPI_Client,
    uPool,
    upoolJSON,
    uuStrings,
 Classes, SysUtils,
 fphttpclient, opensslsockets,
 httpsend, ssl_openssl,
 fpjson, jsonparser,
 base64;

type
 { TAPI_Client_pool }

 TAPI_Client_pool
 =
  class( TAPI_Client)
  //Pool
  public
    function pool_Delete( _Pool_Name: String; _id: Integer= 0): Boolean;
  end;

implementation

{ TAPI_Client_pool }

function TAPI_Client_pool.pool_Delete(_Pool_Name: String; _id: Integer): Boolean;
var
   MethodName: String;
begin
     MethodName:= _Pool_Name+'_Delete';
     Result:= '1' = POST( MethodName, Root_URL+MethodName+IntToStr(_id),'');
end;

end.

