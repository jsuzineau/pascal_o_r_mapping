unit ucChamp_DateTimePicker;
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
    ujsDataContexte,
    uChamps,
    uChamp,
  {$IFNDEF FPC}
  Windows,
  {$ENDIF}
  {$IFDEF FPC}
  LCLType,
  {$ENDIF}
  SysUtils, Classes, Controls, ComCtrls, DB, Messages, Graphics,
    RTLConsts, Editbtn;

type
 TChamp_DateTimePicker
 =
  class(TDateEdit, IChampsComponent)
  public
    constructor Create(AOwner: TComponent); override;
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
     RegisterComponents('Batpro', [TChamp_DateTimePicker]);
end;

{ TChamp_DateTimePicker }

constructor TChamp_DateTimePicker.Create(AOwner: TComponent);
begin
     inherited Create( AOwner);

     FChamps:= nil;
     Champs_Changing:= False;
end;

function TChamp_DateTimePicker.Champ_OK: Boolean;
begin
     Champ:= nil;

     Result:= Assigned( FChamps);
     if not Result then exit;

     Champ:= Champs.Champ_from_Field( Field);
     Result:= Assigned( Champ);
end;

procedure TChamp_DateTimePicker.SetChamps(Value: TChamps);
begin
     if Assigned( Champ)
     then
         Champ.OnChange.Desabonne( Self, _from_Champs);

     FChamps:= Value;

     if not Champ_OK then exit;

     Champ.OnChange.Abonne( Self, _from_Champs);
     _from_Champs;
end;

procedure TChamp_DateTimePicker._from_Champs;
begin
     if Champs_Changing then exit;
     try
        Champs_Changing:= True;

        case Champ.Definition.Info.jsDataType
        of
          jsdt_Date     : Date:= PDateTime( Champ.Valeur)^;
          jsdt_DateTime : Date:= PDateTime( Champ.Valeur)^;
          end;
     finally
            Champs_Changing:= False;
            end;
end;

procedure TChamp_DateTimePicker._to_Champs;
begin
     if Champs_Changing then exit;
     try
        Champs_Changing:= True;

        case Champ.Definition.Info.jsDataType
        of
          jsdt_Date    : Champ.asDatetime:= Date;
          jsdt_DateTime: Champ.asDatetime:= Date;
          end;
        Champ.Publie_Modifications;
     finally
            Champs_Changing:= False;
            end;
     _from_Champs;
end;

function TChamp_DateTimePicker.GetChamps: TChamps;
begin
     Result:= FChamps;
end;

function TChamp_DateTimePicker.GetComponent: TComponent;
begin
     Result:= Self;
end;

end.
