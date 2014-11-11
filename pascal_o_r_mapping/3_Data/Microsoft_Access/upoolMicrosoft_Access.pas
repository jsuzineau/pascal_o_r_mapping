unit upoolMicrosoft_Access;
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

interface

uses
    uClean,
    uBatpro_StringList,
    uhAggregation,
    uDataUtilsU,
    uMicrosoft_Access_Connection,

    uBatpro_Element,

    udmDatabase,
    uPool,

    uHTTP_Interface,

  SysUtils, Classes,
  DB, sqldb;

type

 { TpoolMicrosoft_Access }

 TpoolMicrosoft_Access
 =
  class( TPool)
    procedure DataModuleCreate(Sender: TObject);
  //Microsoft_Access_Connection
  public
    mac: TMicrosoft_Access_Connection;
  //Gestion de la connection
  public
    function Connection: TDatabase; override;
  end;

implementation

{$R *.lfm}

{ TpoolMicrosoft_Access }

procedure TpoolMicrosoft_Access.DataModuleCreate(Sender: TObject);
begin
     inherited;
     UsePrimaryKeyAsKey:= False;
end;

function TpoolMicrosoft_Access.Connection: TDatabase;
begin
     Result:= mac.c;
     if Assigned( Result) then exit;

     Result:= inherited Connection;
end;

end.
