unit ucChamp_CheckBox;
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
    SysUtils, Classes, Controls, StdCtrls,
    uChamps,
    uChamp;

type

 { TChamp_CheckBox }

 TChamp_CheckBox
 =
  class(TCheckBox, IChampsComponent)
  //Général
  protected
    procedure Loaded; override;
    procedure DoClickOnChange; override;
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
  // Propriété ValueTrue
  private
    FValueTrue: String;
  published
    property ValueTrue: String read FValueTrue write FValueTrue;
  // Propriété ValueFalse
  private
    FValueFalse: String;
  published
    property ValueFalse: String read FValueFalse write FValueFalse;
  //Champ
  private
    Champ: TChamp;
    function Champ_OK: Boolean;
    procedure Champ_Destroyed;
  //Gestion des mises à jours avec TChamps
  private
    Champs_Changing: Boolean;
    procedure _from_Champs;
    procedure _to_Champs;
  //accesseur à partir de l'interface
  private
    function GetComponent: TComponent;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Batpro', [TChamp_CheckBox]);
end;

constructor TChamp_CheckBox.Create(AOwner: TComponent);
begin
     inherited;
     FChamps:= nil;
     Champs_Changing:= False;
     ValueFalse:= '0';
     ValueTrue:= '-1';
end;

destructor TChamp_CheckBox.Destroy;
begin
     inherited;
end;

procedure TChamp_CheckBox.Loaded;
begin
     inherited;
end;

function TChamp_CheckBox.Champ_OK: Boolean;
begin
     Champ:= nil;

     Result:= Assigned( FChamps);
     if not Result then exit;

     Champ:= Champs.Champ_from_Field( Field);
     Result:= Assigned( Champ);
end;

procedure TChamp_CheckBox.Champ_Destroyed;
begin
     SetChamps( nil);
end;

procedure TChamp_CheckBox.SetChamps( Value: TChamps);
begin
     if Assigned( Champ)
     then
         begin
         Champ.OnChange .Desabonne( Self, _from_Champs   );
         Champ.OnDestroy.Desabonne( Self, Champ_Destroyed);
         end;

     FChamps:= Value;
     if not Champ_OK then exit;

     Champ.OnChange .Abonne( Self, _from_Champs   );
     Champ.OnDestroy.Abonne( Self, Champ_Destroyed);
     _from_Champs;
end;

procedure TChamp_CheckBox.DoClickOnChange;
begin
     inherited DoClickOnChange;
     if not Champ_OK then exit;

     _to_Champs;
end;

procedure TChamp_CheckBox._from_Champs;
begin
     if Champs_Changing then exit;
     try
        Champs_Changing:= True;

        Checked:= Champ.Chaine = ValueTrue;
     finally
            Champs_Changing:= False;
            end;
end;

procedure TChamp_CheckBox._to_Champs;
begin
     if Champs_Changing then exit;
     try
        Champs_Changing:= True;

        if Checked
        then
            Champ.Chaine:= ValueTrue
        else
            Champ.Chaine:= ValueFalse;
     finally
            Champs_Changing:= False;
            end;
     _from_Champs;
end;

function TChamp_CheckBox.GetChamps: TChamps;
begin
     Result:= FChamps;
end;

function TChamp_CheckBox.GetComponent: TComponent;
begin
     Result:= Self;
end;

end.
