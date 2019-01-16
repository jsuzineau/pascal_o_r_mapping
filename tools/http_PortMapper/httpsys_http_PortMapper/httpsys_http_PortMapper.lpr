{
    This file is part of the Free Component Library (FCL)
    Copyright (c) 2017-2018 by the Free Pascal development team

    Windows HTTP Server API based TCustomWebApplication

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}

//duplicated from fpc\packages\fcl-web\examples\echo\httpsys\echo.lpr
program httpsys_http_PortMapper;

uses
    uEXE_INI,
    uuStrings,
  fpHTTPSys, custHTTPSys, HttpApi, uwm_http_PortMapper;

{
  Before using this example you need to add the URL to the system using a
  comand like the following (executed with Administrator priviledges):

  netsh http add urlacl url=http://+:80/fpweb user=DOMAIN\User

  Whereby DOMAIN\User is the user or group you want to execute this example in.
}
begin
  Application.Initialize;
  Traite_URLs;
  Application.LegacyRouting:= True;
  Application.Run;
end.

