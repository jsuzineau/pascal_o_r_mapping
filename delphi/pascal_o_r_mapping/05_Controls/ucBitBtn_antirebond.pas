unit ucBitBtn_antirebond;
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
  SysUtils, Classes, FMX.Controls, FMX.ExtCtrls, Types, FMX.Graphics,ucBitBtn;

type
 TBitBtn_antirebond
 =
  class(TBitBtn)
  //Gestion du cycle de vie
  public
    constructor Create( AOwner: TComponent); override;
    destructor Destroy; override;
  //Attributs
  private
    Click_running: Boolean;
  //Méthodes surchargées
  public
    procedure Click; override;
  end;

procedure Register;

implementation

procedure Register;
begin
     RegisterComponents('Batpro', [TBitBtn_antirebond]);
end;

{ TBitBtn_antirebond }

constructor TBitBtn_antirebond.Create(AOwner: TComponent);
begin
     inherited;
     Click_running:= False;
end;

destructor TBitBtn_antirebond.Destroy;
begin
     inherited;
end;

procedure TBitBtn_antirebond.Click;
begin
     if Click_running then exit;

     try
        Click_running:= True;
        inherited;
     finally
            Click_running:= False;
            end;
end;

end.
