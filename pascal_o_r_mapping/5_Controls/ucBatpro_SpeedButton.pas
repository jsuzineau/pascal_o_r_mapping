unit ucBatpro_SpeedButton;
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
  SysUtils, Classes, Controls, (*SRColBtn, *)Graphics, Buttons;

type
 TBatpro_SpeedButton
 =
  class((*TSRColorButton*) TSpeedButton)
  //Gestion du cycle de vie
  public
    constructor Create(AOwner: TComponent); override;
  //Surcharges de méthodes
  public
    procedure Loaded; override;
  //Gestion de la souris
  protected
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
  //Gestion du changement de Down
  protected
    procedure SetDown( newValue: boolean); (*override;*)
  //Gestion de la couleur
  private
    FColorDown: TColor;
    FColorUp: TColor;
    FColorStartDown: TColor;
    FColorStartUp: TColor;
    procedure SetColorDown(const Value: TColor);
    procedure SetColorUp(const Value: TColor);
    procedure SetStartColorDown(const Value: TColor);
    procedure SetStartColorUp(const Value: TColor);
    //procedure SetColorStartDown(const Value: TColor);
    //procedure SetColorStartUp(const Value: TColor);
    procedure Color_from_;
  published
    property ColorUp  : TColor read FColorUp   write SetColorUp  ;
    property ColorDown: TColor read FColorDown write SetColorDown;
    property ColorStartUp  : TColor read FColorStartUp   write SetStartColorUp  ;
    property ColorStartDown: TColor read FColorStartDown write SetStartColorDown;
  //Méthodes internes
  protected
    procedure Definit_Parametres; virtual;
  end;

procedure Register;

implementation

procedure Register;
begin
     RegisterComponents('Batpro', [TBatpro_SpeedButton]);
end;

{ TBatpro_SpeedButton }

constructor TBatpro_SpeedButton.Create(AOwner: TComponent);
begin
     inherited;
     Definit_Parametres;
end;

procedure TBatpro_SpeedButton.Definit_Parametres;
begin
     ColorUp     := $00F3F3EF;//gris clair
     ColorStartUp:= $00F3F3EF;//gris foncé
     ColorDown     := $00ECFFEC;//vert pastel
     ColorStartDown:= $0028FF28;//vert foncé
     (*GradientStyle:= gsVertical;
     GradientDirection:= gdDownRight;*)
end;

procedure TBatpro_SpeedButton.Loaded;
begin
     inherited;
     Definit_Parametres;
end;

procedure TBatpro_SpeedButton.Color_from_;
begin
     (*if Down
     then
         begin
         Color      := ColorDown;
         Color_Start:= ColorStartDown;
         end
     else
         begin
         Color      := ColorUp;
         Color_Start:= ColorStartUp;
         end;*)
end;

procedure TBatpro_SpeedButton.MouseDown(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
     inherited;

end;

procedure TBatpro_SpeedButton.MouseUp(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
     inherited;
     Color_from_;
end;

//procedure TBatpro_SpeedButton.SetColorStartDown(const Value: TColor);
//begin
//     FColorStartDown:= Value;
//     Color_from_;
//end;

procedure TBatpro_SpeedButton.SetColorDown(const Value: TColor);
begin
     FColorDown := Value;
     Color_from_;
end;

//procedure TBatpro_SpeedButton.SetColorStartUp(const Value: TColor);
//begin
//     FColorStartUp:= Value;
//     Color_from_;
//end;

procedure TBatpro_SpeedButton.SetColorUp(const Value: TColor);
begin
     FColorUp := Value;
     Color_from_;
end;

procedure TBatpro_SpeedButton.SetDown(newValue: boolean);
begin
     inherited;
     Color_from_;
end;

procedure TBatpro_SpeedButton.SetStartColorDown(const Value: TColor);
begin
  FColorStartDown := Value;
end;

procedure TBatpro_SpeedButton.SetStartColorUp(const Value: TColor);
begin
  FColorStartUp := Value;
end;

end.
