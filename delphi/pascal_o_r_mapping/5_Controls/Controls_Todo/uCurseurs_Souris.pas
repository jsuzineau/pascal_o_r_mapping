unit uCurseurs_Souris;
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            partly as freelance: http://www.mars42.com                          |
        and partly as employee : http://www.adinfo.com                          |
                                 http://www.adi-bat.com                         |
    Copyright 2017 Jean SUZINEAU - MARS42                                       |
    Copyright 2017 GROUPE ADINFO SOFTWARE                                       |
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

const
     crCurseur_HandGrab=1;

implementation

uses
    uForms,
    Windows, Graphics, Forms, Dialogs, Controls;
{$R *.RES}

procedure Charge_curseur( _Index: Integer; _Resource_Name: String);
var
   HC: HCURSOR;
begin
     HC:= LoadCursor( HInstance, PChar(_Resource_Name));
     if HC = 0 then uForms_ShowMessage('uCurseurs_Souris: LoadCursor Failed');
     Screen.Cursors[ _Index]:= HC;
end;

initialization
              Charge_curseur( crCurseur_HandGrab, 'CRCURSEUR_HANDGRAB');
              Charge_curseur( crNoDrop          , 'CRNODROP_ROUGE'    );
finalization

end.
