unit ucChamp_Label;
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
    u_sys_,
    uChamps,
    uChamp,
    SysUtils, Classes, Controls, StdCtrls;

type

 { TChamp_Label }

 TChamp_Label
 =
  class(TLabel, IChampsComponent)
  //G�n�ral
  protected
    procedure Loaded; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  //Propri�t� Champs
  private
    FChamps: TChamps;
    function GetChamps: TChamps;
    procedure SetChamps( Value: TChamps);
  public
    property Champs: TChamps read GetChamps write SetChamps;
  // Propri�t� Field
  private
    FField: String;
  published
    property Field: String read FField write FField;
  //Champ
  private
    Champ: TChamp;
    function Champ_OK: Boolean;
    procedure Champ_Destroyed;
  //Gestion des mises � jours avec TChamps
  private
    Champs_Changing: Boolean;
    procedure _from_Champs;
    procedure Efface;
  //accesseur � partir de l'interface
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
  RegisterComponents('Batpro', [TChamp_Label]);
end;

{ TChamp_Label }

constructor TChamp_Label.Create(AOwner: TComponent);
begin
     inherited;
     FChamps:= nil;
     Champs_Changing:= False;
end;

destructor TChamp_Label.Destroy;
begin
     inherited;
end;

procedure TChamp_Label.Loaded;
begin
     inherited;
     hint_defined:= Hint <> '';
     ShowHint:= True;
end;

function TChamp_Label.Champ_OK: Boolean;
begin
     Champ:= nil;

     Result:= Assigned( FChamps);
     if not Result then exit;

     Champ:= Champs.Champ_from_Field( Field);
     Result:= Assigned( Champ);
end;

procedure TChamp_Label.Champ_Destroyed;
begin
     SetChamps( nil);
end;

procedure TChamp_Label.SetChamps( Value: TChamps);
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

procedure TChamp_Label.Efface;
begin
     if Champs_Changing then exit;
     try
        Champs_Changing:= True;
        Text:= sys_Vide;
     finally
            Champs_Changing:= False;
            end;
end;

procedure TChamp_Label._from_Champs;
var
   S: String;
begin
     if Champs_Changing then exit;
     try
        Champs_Changing:= True;
        if Champs = nil
        then
            s:= sys_Vide
        else
            try
               S:= Champ.Chaine;
            except
                  on E: Exception
                  do
                    S:= E.Message;
                  end;
        Text:= S; //� surveiller, je ne trouve la propri�t� Text dans TLabel
        if not hint_defined
        then
            Hint:= S;
     finally
            Champs_Changing:= False;
            end;
end;

function TChamp_Label.GetChamps: TChamps;
begin
     Result:= FChamps;
end;

function TChamp_Label.GetComponent: TComponent;
begin
     Result:= Self;
end;

end.
