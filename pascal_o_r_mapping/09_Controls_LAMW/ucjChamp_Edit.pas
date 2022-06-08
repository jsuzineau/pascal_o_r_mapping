unit ucjChamp_Edit;
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            http://www.mars42.com                                               |
                                                                                |
    Copyright 2017 Jean SUZINEAU - MARS42                                       |
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

{$mode delphi}

interface

uses
    uChamps,
    uChamp,
  Classes, SysUtils, Laz_And_Controls,And_jni_Bridge,AndroidWidget;

type

	{ TjChamp_Edit }

 TjChamp_Edit
 =
  class(jEditText, IChampsComponent)
  //Cycle de vie
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  //OnChange
  private
    procedure Change( _Sender: TObject; _txt: string; _count: integer);
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
  RegisterComponents('Android Bridges',[TjChamp_Edit]);
end;

{ TjChamp_Edit }

constructor TjChamp_Edit.Create(AOwner: TComponent);
begin
	    inherited Create(AOwner);
     //if not (csDesigning in ComponentState) then WriteLn( ClassName+'.Create');
     FChamps:= nil;
     Champs_Changing:= False;
     OnChange:= Change;
end;

destructor TjChamp_Edit.Destroy;
begin
	    inherited Destroy;
end;

procedure TjChamp_Edit.Change( _Sender: TObject; _txt: string; _count: integer);
begin
     //if not (csDesigning in ComponentState) then WriteLn( ClassName+'.Change( _Sender, _txt="', _txt,'", _count= ',_count,')');
     if not Champ_OK then exit;

     _to_Champs;
end;

function TjChamp_Edit.GetChamps: TChamps;
begin
     Result:= FChamps;
end;

procedure TjChamp_Edit.SetChamps(Value: TChamps);
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

function TjChamp_Edit.Champ_OK: Boolean;
begin
     Champ:= nil;

     Result:= Assigned( FChamps);
     //if not (csDesigning in ComponentState) then if not Result then WriteLn( ClassName+'.Champ_OK = False');
     if not Result then exit;

     Champ:= Champs.Champ_from_Field( Field);
     Result:= Assigned( Champ);
     //if not (csDesigning in ComponentState) then WriteLn( ClassName+'.Champ_OK = ', Result);
end;

procedure TjChamp_Edit._from_Champs;
begin
     //if not (csDesigning in ComponentState) then if Champs_Changing then WriteLn( ClassName+'._from_Champs: Champs_Changing= True');
     if Champs_Changing then exit;
     try
        Champs_Changing:= True;

        //if not (csDesigning in ComponentState) then WriteLn( ClassName+'._from_Champs: Champ.Chaine = ',Champ.Chaine);
        Text:= Champ.Chaine;
        //if not (csDesigning in ComponentState) then WriteLn( ClassName+'._from_Champs: FInitialized= ',FInitialized);
        if FInitialized
        then
            //jEditText_setText(FjEnv, FjObject , Champ.Chaine);
            if Champ.Chaine <> ''
            then
                jni_proc_h(gApp.jni.jEnv, FjObject, 'setText', Champ.Chaine)
            else
                Clear;
     finally
            Champs_Changing:= False;
            end;
end;

procedure TjChamp_Edit._to_Champs;
begin
     //if not (csDesigning in ComponentState) then if Champs_Changing then WriteLn( ClassName+'._to_Champs: Champs_Changing= True');
     if Champs_Changing then exit;
     try
        Champs_Changing:= True;

        Champ.Chaine:= Text;
        //if not (csDesigning in ComponentState) then WriteLn( ClassName+'._from_Champs: Champ.Chaine = ',Champ.Chaine);
     finally
            Champs_Changing:= False;
            end;
     if Champ.Bounce then _from_Champs;
end;

function TjChamp_Edit.GetComponent: TComponent;
begin
     Result:= Self;
end;

end.
