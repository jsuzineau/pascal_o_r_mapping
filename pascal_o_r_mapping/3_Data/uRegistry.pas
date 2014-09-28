unit uRegistry;
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            partly as freelance: http://www.mars42.com                          |
        and partly as employee : http://www.batpro.com                          |
    Contact: gilles.doutre@batpro.com                                           |
                                                                                |
    Copyright 2014 Jean SUZINEAU - MARS42                                       |
    Copyright 2014 Cabinet Gilles DOUTRE - BATPRO                               |
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

interface

uses
    uSGBD,
    {$IFDEF MSWINDOWS}
    Windows,
    {$ENDIF}

    SysUtils, Classes, Registry;

const
     sys_batpro     = 'batpro';// nom de la base par défaut
     sys_mysql      = 'mysql';
     sys_DriverName = 'DriverName';
     sys_HostName   = 'HostName';
     sys_Database   = 'Database';
     sys_Password   = 'Password';
     sys_User_Name  = 'User_Name';

     sys_MYSQL_3_23_41  = 'MYSQL_3_23_41';

     sys_Installed_Drivers= 'Installed Drivers';
     sys_GetDriverFunc    = 'GetDriverFunc';
     sys_LibraryName      = 'LibraryName';
     sys_VendorLib        = 'VendorLib';

     regk_Batpro_MySQL   ='\Software\Batpro\MySQL';
     regk_Batpro_Informix='\Software\Batpro\Informix';
     regv_HostName    ='HostName';
     regv_Password   = 'Password';
     regv_User_Name  = 'User_Name';
     regv_Database   = 'Database';
     regv_SchemaName = 'SchemaName';

var
   Registry_Informix: TRegistry= nil;

procedure Initialise_Registry_Informix;

implementation


procedure Initialise_Registry_Informix;
begin
     if Assigned( Registry_Informix) then exit;

     Registry_Informix:= TRegistry.Create;
     Registry_Informix.RootKey:= HKEY_LOCAL_MACHINE;
     Registry_Informix.OpenKey( regk_Batpro_Informix, True);
end;

initialization
              if sgbdINFORMIX
              then
                  Initialise_Registry_Informix;
finalization
            FreeAndNil( Registry_Informix);
end.



