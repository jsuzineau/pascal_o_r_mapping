unit ucChamp_Memo;
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
    SysUtils, Classes, Controls, StdCtrls,
    uChamps,
    uChamp;

type
 TChamp_Memo
 =
  class( TMemo, IChampsComponent)
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
     RegisterComponents('Batpro', [TChamp_Memo]);
end;

{ TChamp_Memo }

constructor TChamp_Memo.Create(AOwner: TComponent);
begin
     inherited;
     FChamps:= nil;
     Champs_Changing:= False;
end;

destructor TChamp_Memo.Destroy;
begin
     inherited;
end;

procedure TChamp_Memo.Loaded;
begin
     inherited;
end;

function TChamp_Memo.Champ_OK: Boolean;
begin
     Champ:= nil;

     Result:= Assigned( FChamps);
     if not Result then exit;

     Champ:= Champs.Champ_from_Field( Field);
     Result:= Assigned( Champ);
end;

procedure TChamp_Memo.SetChamps(Value: TChamps);
begin
     if Assigned( Champ)
     then
         Champ.OnChange.Desabonne( Self, _from_Champs);

     FChamps:= nil;
     Text:= '';
     FChamps:= Value;
     if not Champ_OK then exit;

     Champ.OnChange.Abonne( Self, _from_Champs);
     _from_Champs;
end;

procedure TChamp_Memo.Change;
begin
     inherited;
     if not Champ_OK then exit;

     _to_Champs;
end;

procedure TChamp_Memo._from_Champs;
var
   S: String;
begin
     if Champs_Changing then exit;
     try
        Champs_Changing:= True;

        S:= Champ.Chaine;
        Text:= S;
        Hint:= S;
     finally
            Champs_Changing:= False;
            end;
end;

procedure TChamp_Memo._to_Champs;
var
   S: String;
begin
     if Champs_Changing then exit;
     try
        Champs_Changing:= True;

        S:= Text;
        Champ.Chaine:= S;
        Hint:= S;
     finally
            Champs_Changing:= False;
            end;
     _from_Champs;
end;

function TChamp_Memo.GetChamps: TChamps;
begin
     Result:= FChamps;
end;

function TChamp_Memo.GetComponent: TComponent;
begin
     Result:= Self;
end;

end.
