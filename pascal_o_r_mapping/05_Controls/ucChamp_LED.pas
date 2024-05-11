unit ucChamp_LED;
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            http://www.mars42.com                                               |
                                                                                |
    Copyright 2016 Jean SUZINEAU - MARS42                                       |
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

{$mode delphi}

interface

uses
    u_sys_,
    uChamps,
    uChamp,
  Classes, SysUtils, ExtCtrls, Graphics;

type

 { TChamp_LED }

 TChamp_LED
 =
  class(TShape, IChampsComponent)
  //Général
  protected
    procedure Loaded; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
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
    procedure Champ_Destroyed;
  //Gestion des mises à jours avec TChamps
  private
    Champs_Changing: Boolean;
    procedure _from_Champs;
    procedure Efface;
    procedure Transparent;
  //accesseur à partir de l'interface
  private
    function GetComponent: TComponent;
  //Gestion du hint
  public
    hint_defined: Boolean;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Batpro',[TChamp_LED]);
end;

{ TChamp_LED }

constructor TChamp_LED.Create(AOwner: TComponent);
begin
     inherited;
     FChamps:= nil;
     Champs_Changing:= False;
end;

destructor TChamp_LED.Destroy;
begin
     inherited;
end;

procedure TChamp_LED.Loaded;
begin
     inherited;
     hint_defined:= Hint <> '';
     ShowHint:= True;
end;

function TChamp_LED.Champ_OK: Boolean;
begin
     Champ:= nil;

     Result:= Assigned( FChamps);
     if not Result then exit;

     Champ:= Champs.Champ_from_Field( Field);
     Result:= Assigned( Champ);
end;

procedure TChamp_LED.Champ_Destroyed;
begin
     SetChamps( nil);
end;

procedure TChamp_LED.SetChamps( Value: TChamps);
begin
     if Assigned( Champ)
     then
         begin
         Champ.OnChange .Desabonne( Self, _from_Champs   );
         Champ.OnDestroy.Desabonne( Self, Champ_Destroyed);
         end;

     Efface;
     FChamps:= Value;
     if not Champ_OK then exit;

     Champ.OnChange .Abonne( Self, _from_Champs   );
     Champ.OnDestroy.Abonne( Self, Champ_Destroyed);
     _from_Champs;
end;

procedure TChamp_LED.Efface;
begin
     if Champs_Changing then exit;
     try
        Champs_Changing:= True;
        Transparent;
     finally
            Champs_Changing:= False;
            end;
end;

procedure TChamp_LED.Transparent;
begin
     Brush.Style:= bsClear;
end;

procedure TChamp_LED._from_Champs;
begin
     if Champs_Changing then exit;
     try
        Champs_Changing:= True;
        if Champs = nil
        then
            Transparent
        else
            try
               Brush.Style:= bsSolid;
               Brush.Color:= Champ.asInteger;
            except
                  on E: Exception
                  do
                    Transparent;
                  end;
     finally
            Champs_Changing:= False;
            end;
end;

function TChamp_LED.GetChamps: TChamps;
begin
     Result:= FChamps;
end;

function TChamp_LED.GetComponent: TComponent;
begin
     Result:= Self;
end;

end.
