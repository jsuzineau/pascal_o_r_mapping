unit ucWChamp_Edit;
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            http://www.mars42.com                                               |
                                                                                |
    Copyright 2019 Jean SUZINEAU - MARS42                                       |
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
    LResources,
    SysUtils, Classes, Controls, StdCtrls, WebCtrls;

type

 { TWChamp_Edit }

 TWChamp_Edit
 =
  class(TWEdit)
  //Cycle de vie
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  // Propriété Field
  private
    FField: String;
  published
    property Field: String read FField write FField;
  end;

procedure Register;

implementation

procedure Register;
begin
     {$I ucWChamp_Edit.lrs}
     RegisterComponents('Mars42 js', [TWChamp_Edit]);
end;

{ TWChamp_Edit }

constructor TWChamp_Edit.Create(AOwner: TComponent);
begin
     inherited;
end;

destructor TWChamp_Edit.Destroy;
begin
     inherited;
end;

end.
