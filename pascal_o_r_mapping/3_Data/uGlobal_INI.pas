unit uGlobal_INI;
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
    uClean,
    u_sys_,
    u_ini_,
    u_db_,
    uBatpro_StringList,
  {$IFDEF MSWINDOWS}
  Windows, //DBTables,
  {$ENDIF}
  SysUtils, Classes, INIFiles;

type
 TGlobal_INIFile
 =
  class( TINIFile)
  //Appel depuis batpro6, sélection SendNotifyMessage/SendMessage
  private
    function Getweb_SendNotifyMessage: Boolean;
    procedure Setweb_SendNotifyMessage(const Value: Boolean);
  public
    property web_SendNotifyMessage: Boolean read Getweb_SendNotifyMessage write Setweb_SendNotifyMessage;
    {$IFDEF MSWINDOWS}
    procedure SendMessage( _wm: UINT;
                           _WindowSource: HWND= 0;
                           _WindowCible: HWND= HWND_BROADCAST);
    {$ENDIF}
  end;

var
   Global_INI: TGlobal_INIFile;

implementation

const
     inik_web_SendNotifyMessage='web_SendNotifyMessage';

{ TGlobal_INIFile }

function TGlobal_INIFile.Getweb_SendNotifyMessage: Boolean;
var
   S: String;
begin
     Result:= ReadBool( ini_Options, inik_web_SendNotifyMessage, False);
     S:= ReadString( ini_Options, inik_web_SendNotifyMessage, '');
     if S = ''
     then
         web_SendNotifyMessage:= Result;
end;

procedure TGlobal_INIFile.Setweb_SendNotifyMessage(const Value: Boolean);
begin
     WriteBool( ini_Options, inik_web_SendNotifyMessage, Value);
end;

{$IFDEF MSWINDOWS}
procedure TGlobal_INIFile.SendMessage( _wm: UINT;
                                       _WindowSource: HWND= 0;
                                       _WindowCible: HWND= HWND_BROADCAST);
begin
     //if web_SendNotifyMessage
     //then
         (*SendNotifyMessage( _WindowCible, _wm, _WindowSource, 0)*)
     //else
     //    Windows.SendMessage( HWND_BROADCAST, wm, 0, 0);
end;
{$ENDIF}

var
   Nom: String;
initialization
              Nom:= ExtractFilePath( ParamStr(0)) + 'etc\_Configuration.ini';
              Global_INI:= TGlobal_INIFile.Create( Nom);
finalization
              Global_INI.UpdateFile;
              Free_nil( Global_INI);
end.
