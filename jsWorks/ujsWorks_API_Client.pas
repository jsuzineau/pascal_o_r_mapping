unit ujsWorks_API_Client;
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
    uChrono,
    uAPI_Client,
    uAPI_Client_pool,
    upoolJSON,
    uuStrings,
 Classes, SysUtils,
 fphttpclient, opensslsockets,
 httpsend, ssl_openssl,
 fpjson, jsonparser,
 base64;

type
 { TjsWorks_API_Client }

 TjsWorks_API_Client
 =
  class( TAPI_Client_pool)
  //Work
  public
    function Work_Delete( _id: Integer= 0): Boolean;
    function Work_from_Periode( _Debut, _Fin: TDateTime; _idTag: Integer= 0): String;
  end;


implementation

{ TjsWorks_API_Client }

function TjsWorks_API_Client.Work_Delete(_id: Integer): Boolean;
begin
     Result:= pool_Delete( 'Work', _id);
end;

function TjsWorks_API_Client.Work_from_Periode( _Debut, _Fin: TDateTime; _idTag: Integer): String;
var
   sDebut: String;
   sFin  : String;
   jo: TJSONObject;
   Request_Body: String;
begin
     Chrono.Stop('Début TjsWorks_API_Client.Work_from_Periode');
     sDebut:= DateTimeSQL_sans_quotes( _Debut);
     sFin  := DateTimeSQL_sans_quotes( _Fin  );
     jo:= TJSONObject.Create;
     try
        jo.Add( 'Debut', sDebut);
        jo.Add( 'Fin'  , sFin  );
        jo.Add( 'idTag', _idTag);
        Request_Body:= jo.AsJSON;
     finally
            FreeAndNil( jo);
            end;
     Chrono.Stop('Avant TjsWorks_API_Client.POST');
     Result:= POST( 'Work_from_Periode', Root_URL+'Work_from_Periode',Request_Body);
     Chrono.Stop('Aprés TjsWorks_API_Client.POST');
end;

end.

