unit utc_MailTo;
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

uses
    uClean,
    uBatpro_StringList,
    uMailTo,
  TestFrameWork,
  Windows, SysUtils, Classes, uOD_Forms;

type
 Ttc_MailTo
 =
  class( TTestCase)
  published
    // Test methods
    procedure Test_MailTo;
  end;

implementation

{ Ttc_MailTo }

procedure Ttc_MailTo.Test_MailTo;
var
   sl: TBatpro_StringList;
   NomPieceJointe: String;
begin
     NomPieceJointe:= ChangeFileExt( uOD_Forms_EXE_Name, '_PieceJointe.txt');
     sl:= TBatpro_StringList.Create;
     try
        sl.Text:= 'Test pièce jointe';
        sl.SaveToFile( NomPieceJointe);
     finally
            Free_nil( sl);
            end;

     MailTo( '','support@batpro.com','Test envoi de mail', 'Corps du mail', [NomPieceJointe]);
     //Check
end;

initialization
  TestFramework.RegisterTest('Test de MailTo',Ttc_MailTo.Suite);
end.

