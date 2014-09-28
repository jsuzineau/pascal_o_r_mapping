unit ucChamp_Lookup_ComboBox;
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
    uBatpro_StringList,
    uClean,
    uChamps,
    uChamp;

type
 TChamp_Lookup_ComboBox
 =
  class( TComboBox, IChampsComponent)
  //Général
  protected
    procedure Loaded; override;
    procedure Change; override;
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
  //Données de Lookup
  private
    Keys  : TBatpro_StringList;
    Labels: TStrings;
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
     RegisterComponents('Batpro', [TChamp_Lookup_ComboBox]);
end;

{ TChamp_Lookup_ComboBox }

constructor TChamp_Lookup_ComboBox.Create(AOwner: TComponent);
begin
     inherited;
     FChamps:= nil;
     Keys  := TBatpro_StringList.Create;
     Labels:= Items;
     Champs_Changing:= False;
end;

destructor TChamp_Lookup_ComboBox.Destroy;
begin
     Free_nil( Keys  );
     Labels:= nil;
     inherited;
end;

procedure TChamp_Lookup_ComboBox.Loaded;
begin
     inherited;
     Style:= csDropDownList;
end;

function TChamp_Lookup_ComboBox.Champ_OK: Boolean;
begin
     Champ:= nil;
     
     Result:= Assigned( FChamps);
     if not Result then exit;

     Champ:= Champs.Champ_from_Field( Field);
     Result:= Assigned( Champ);
end;

procedure TChamp_Lookup_ComboBox.SetChamps( Value: TChamps);
begin
     if Assigned( Champ)
     then
         Champ.LookupKey.OnChange.Desabonne( Self, _from_Champs);

     Keys  .Clear;
     Items .Clear;

     FChamps:= Value;
     if not Champ_OK                   then exit;
     if not Champ.Definition.Is_Lookup then exit;

     Champ.LookupKey.OnChange.Abonne( Self, _from_Champs);
     _from_Champs;
end;

procedure TChamp_Lookup_ComboBox.Change;
begin
     if not Champ_OK then exit;
     _to_Champs;

     inherited;
end;

procedure TChamp_Lookup_ComboBox._from_Champs;
var
   Current_Key: String;
begin
     if Champs_Changing then exit;
     try
        Champs_Changing:= True;

        Current_Key:= Champ.LookupKey.Chaine;
        Champ.OnGetLookupListItems( Current_Key, Keys, Items, Champ.LookupConnection);
        ItemIndex:= Keys.IndexOf( Current_Key);
     finally
            Champs_Changing:= False;
            end;
end;

procedure TChamp_Lookup_ComboBox._to_Champs;
var
   I: Integer;
begin
     if Champs_Changing then exit;
     try
        Champs_Changing:= True;

         I:= ItemIndex;

         Champ.LookupKey.Chaine:= Keys  .Strings[ I];
         //Champ          .Chaine:= Items.Strings[ I];
     finally
            Champs_Changing:= False;
            end;
     _from_Champs;
end;

function TChamp_Lookup_ComboBox.GetChamps: TChamps;
begin
     Result:= FChamps;
end;

function TChamp_Lookup_ComboBox.GetComponent: TComponent;
begin
     Result:= Self;
end;

end.
