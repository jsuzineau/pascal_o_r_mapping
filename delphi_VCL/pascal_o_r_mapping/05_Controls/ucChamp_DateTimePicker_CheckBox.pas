unit ucChamp_DateTimePicker_CheckBox;
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
    uReels,
    uChamps,
    uChamp,
  SysUtils, Classes, VCL.Controls, DB, VCL.StdCtrls, VCL.ExtCtrls, VCL.ComCtrls;

type
 TChamp_DateTimePicker_CheckBox
 =
  class( TPanel, IChampsComponent)
  //Gestion du cycle de vie
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  //Checkbox
  private
    procedure cbDTPClick(Sender: TObject);
  public
    cbDTP: TCheckBox;
  //DateTimePicker
  private
    procedure dtpChange( Sender: TObject);
  public
    dtp: TDateTimePicker;
  //Gestion de l'affichage
  private
    procedure Layout;
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
  end;

procedure Register;

implementation

procedure Register;
begin
     RegisterComponents('Batpro', [TChamp_DateTimePicker_CheckBox]);
end;

{ TChamp_DateTimePicker_CheckBox }

constructor TChamp_DateTimePicker_CheckBox.Create(AOwner: TComponent);
begin
     inherited;

     cbDTP:= TCheckBox.Create( Self);
     cbDTP.Parent:= Self;
     cbDTP.OnClick:= cbDTPClick;

     dtp:= TDateTimePicker.Create( Self);
     dtp.Parent:= Self;
     dtp.OnChange:= dtpChange;

     Layout;

     FChamps:= nil;
     Champs_Changing:= False;
end;

destructor TChamp_DateTimePicker_CheckBox.Destroy;
begin

     inherited;
end;

procedure TChamp_DateTimePicker_CheckBox.Layout;
begin
     cbDTP.Top  :=0;
     cbDTP.Left := 0;
     cbDTP.Width:= 15;

     dtp.Left:= 15;
     dtp.Top:= 0;
     dtp.Width:= Width - dtp.Left;
     //with dtp do Anchors:= Anchors + [akRight];
end;

function TChamp_DateTimePicker_CheckBox.Champ_OK: Boolean;
begin
     Champ:= nil;

     Result:= Assigned( FChamps);
     if not Result then exit;

     Champ:= Champs.Champ_from_Field( Field);
     Result:= Assigned( Champ);
end;

procedure TChamp_DateTimePicker_CheckBox.SetChamps(Value: TChamps);
begin
     if Assigned( Champ)
     then
         Champ.OnChange.Desabonne( Self, _from_Champs);

     FChamps:= Value;

     if not Champ_OK then exit;

     Champ.OnChange.Abonne( Self, _from_Champs);
     _from_Champs;
end;

procedure TChamp_DateTimePicker_CheckBox.dtpChange(Sender: TObject);
begin
     inherited;
     if not Champ_OK then exit;

     _to_Champs;
end;

procedure TChamp_DateTimePicker_CheckBox._from_Champs;
var
   Value: TDateTime;
   ValueDefined: Boolean;
begin
     if Champs_Changing then exit;
     try
        Champs_Changing:= True;

        case Champ.Definition.Typ
        of
          ftDate     : Value:= PDateTime( Champ.Valeur)^;
          ftDateTime : Value:= PDateTime( Champ.Valeur)^;
          ftTimeStamp: Value:= PDateTime( Champ.Valeur)^;
          else         Value:= 0;
          end;
        ValueDefined:= not Reel_Zero( Value);
        cbDTP.Checked:= ValueDefined;
        if ValueDefined
        then
            dtp.DateTime:= Value;
        dtp.Enabled:= ValueDefined;
     finally
            Champs_Changing:= False;
            end;
end;

procedure TChamp_DateTimePicker_CheckBox._to_Champs;
var
   Value: TDateTime;
begin
     if Champs_Changing then exit;
     try
        Champs_Changing:= True;

        if cbDTP.Checked
        then
            Value:= dtp.DateTime
        else
            Value:= 0;

        case Champ.Definition.Typ
        of
          ftDate     : Champ.asDatetime:= Value;
          ftDateTime : Champ.asDatetime:= Value;
          ftTimeStamp: Champ.asDatetime:= Value;
          end;
        Champ.Publie_Modifications;
     finally
            Champs_Changing:= False;
            end;
     _from_Champs;
end;

function TChamp_DateTimePicker_CheckBox.GetChamps: TChamps;
begin
     Result:= FChamps;
end;

function TChamp_DateTimePicker_CheckBox.GetComponent: TComponent;
begin
     Result:= Self;
end;

procedure TChamp_DateTimePicker_CheckBox.cbDTPClick(Sender: TObject);
begin
     dtp.Enabled:= cbDTP.Checked;
     _to_Champs;
end;

end.
