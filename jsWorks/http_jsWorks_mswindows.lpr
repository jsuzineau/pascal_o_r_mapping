program http_jsWorks_mswindows;
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

//{$mode objfpc}{$H+}

uses
  uBatpro_StringList,
  uuStrings,
  ublCategorie, ublDevelopment,
  ublProject, ublState, ublWork,
  uhfCategorie, uhfDevelopment,
  uhfJour_ferie, uhfProject, uhfState, uhfWork, upoolCategorie,
  upoolDevelopment, upoolProject, upoolState, upoolWork, uPool,
  upoolG_BECP, uHTTP_Interface,
  Interfaces, // this includes the LCL widgetset
Classes, blcksock, sockets, Synautil,SysUtils;

{$ifdef fpc}
 {$mode delphi}
{$endif}

//{$apptype console}

begin
     poolCategorie.ToutCharger;
     poolState    .ToutCharger;

     HTTP_Interface.Racine:= ExtractFilePath(ParamStr(0))+'..'+PathDelim+'www'+PathDelim+'index.html';
     HTTP_Interface.Register_pool( poolProject    );
     HTTP_Interface.Register_pool( poolWork       );
     HTTP_Interface.Register_pool( poolDevelopment);
     HTTP_Interface.Register_pool( poolCategorie  );
     HTTP_Interface.Register_pool( poolState      );

     HTTP_Interface.Init;

     //Exécution monotâche
     //HTTP_Interface.Run;

     //Exécution asynchrone en thread séparé
     HTTP_Interface.Start;
     repeat
           sleep(1000);
     until False;
end.
