unit ucBatpro_OptionButton;
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
    ucBatpro_SpeedButton,
  SysUtils, Classes, Controls, (*SRColBtn,*) Graphics, Buttons;

type
 TBatpro_OptionButton
 =
  class(TBatpro_SpeedButton)
  //Gestion du cycle de vie
  public
    constructor Create(AOwner: TComponent); override;
  //Méthodes internes
  protected
    procedure Definit_Parametres; override;
  end;

procedure Register;

implementation

procedure Register;
begin
     RegisterComponents('Batpro', [TBatpro_OptionButton]);
end;

{ TBatpro_OptionButton }

constructor TBatpro_OptionButton.Create( AOwner: TComponent);
begin
     inherited;
     AllowAllUp:= True;
end;


procedure TBatpro_OptionButton.Definit_Parametres;
begin
     inherited;
     (*Grouped:= True;*)
end;

end.
