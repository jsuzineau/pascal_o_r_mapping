unit ucChamp_Float_SpinEdit;
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
    uChamps,
    uChamp,
  {$IFDEF MSWINDOWS}
  Windows,
  {$ENDIF}
  {$IFDEF FPC}
  LCLType,
  {$ENDIF}
  SysUtils, Classes, Controls, StdCtrls, Spin,
  ExtCtrls, Messages, Forms, Graphics, Menus, Buttons;

type
 TChamp_Float_SpinEdit
 =
  class( TFloatSpinEdit, IChampsComponent)
  //Gestion du cycle de vie
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  //Général
  protected
    procedure Loaded; override;
    procedure Change; override;
  //Propriété Champs
  private
    FChamps: TChamps;
    function GetChamps: TChamps;
    procedure SetChamps( Value: TChamps);
  public
    property Champs: TChamps read GetChamps write SetChamps;
  // Propriété Field
  private
    FField: String;
  published
    property Field: String read FField write FField;
  //Champ
  private
    Champ: TChamp;
    function Champ_OK: Boolean;
  //Gestion des mises à jours avec TChamps
  private
    Champs_Changing: Boolean;
    procedure _from_Champs;
    procedure _to_Champs;
  //accesseur à partir de l'interface
  private
    function GetComponent: TComponent;
  //Valeur
  private
    function  GetFloatValue: double;
    procedure SetFloatValue(const NewValue: double);
  public
    property FloatValue: double read GetFloatValue write SetFloatValue;
  end;

procedure Register;

implementation

procedure Register;
begin
     RegisterComponents('Batpro', [TChamp_Float_SpinEdit]);
end;

{ TChamp_Float_SpinEdit }

constructor TChamp_Float_SpinEdit.Create(AOwner: TComponent);
begin
     inherited;
     FChamps:= nil;
     Champs_Changing:= False;
end;

destructor TChamp_Float_SpinEdit.Destroy;
begin
     inherited;
end;

procedure TChamp_Float_SpinEdit.Loaded;
begin
     inherited;
end;

function TChamp_Float_SpinEdit.Champ_OK: Boolean;
begin
     Champ:= nil;

     Result:= Assigned( FChamps);
     if not Result then exit;

     Champ:= Champs.Champ_from_Field( Field);
     Result:= Assigned( Champ);
end;

procedure TChamp_Float_SpinEdit.SetChamps(Value: TChamps);
begin
     if Assigned( Champ)
     then
         Champ.OnChange.Desabonne( Self, _from_Champs);

     FChamps:= Value;
     if not Champ_OK then exit;

     Champ.OnChange.Abonne( Self, _from_Champs);
     _from_Champs;
end;

procedure TChamp_Float_SpinEdit.Change;
var
   Valeur: double;
begin
     inherited;
     if not Champ_OK then exit;
     if not TryStrToFloat( Text, Valeur) then exit;

     _to_Champs;
end;

procedure TChamp_Float_SpinEdit._from_Champs;
begin
     if Champs_Changing then exit;
     try
        Champs_Changing:= True;

        Text:= Champ.Chaine;
     finally
            Champs_Changing:= False;
            end;
end;

procedure TChamp_Float_SpinEdit._to_Champs;
var
   Champ_asDouble: double;
begin
     if Champ.asDouble = FloatValue then exit;

     if Champs_Changing then exit;
     try
        Champs_Changing:= True;

        Champ.asDouble:= FloatValue;

        Champ_asDouble:= Champ.asDouble;
        if Champ_asDouble <> FloatValue
        then
            FloatValue:= Champ_asDouble;
     finally
            Champs_Changing:= False;
            end;
     if Champ.Bounce then _from_Champs;
end;

function TChamp_Float_SpinEdit.GetChamps: TChamps;
begin
     Result:= FChamps;
end;

function TChamp_Float_SpinEdit.GetComponent: TComponent;
begin
     Result:= Self;
end;

function TChamp_Float_SpinEdit.GetFloatValue: double;
begin
     Result:= Value;
end;

procedure TChamp_Float_SpinEdit.SetFloatValue(const NewValue: double);
begin
     Value:= NewValue;
end;

end.
