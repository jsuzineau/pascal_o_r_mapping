unit ucWChamp_Edit;
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            http://www.mars42.com                                               |
                                                                                |
    Copyright 2019 Jean SUZINEAU - MARS42                                       |
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
    SysUtils, Classes, Controls, StdCtrls, WebCtrls,JS,uJSChamps;

type

 { TWChamp_Edit }

 TWChamp_Edit
 =
  class(TWEdit)
  //Cycle de vie
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  //Général
  protected
    procedure Change; override;
  //Propriété Champs
  private
    FChamps: TJSChamps;
    function GetChamps: TJSChamps;
    procedure SetChamps( Value: TJSChamps);
  public
    property Champs: TJSChamps read GetChamps write SetChamps;
  // Propriété Field
  private
    FField: String;
  published
    property Field: String read FField write FField;
  //Champ
  private
    //Champ: TChamp;
    function Champ_OK: Boolean;
    procedure Champs_OnSet( _propertyKey, _value: TJSObject);
  //Gestion des mises à jours avec TChamps
  private
    Champs_Changing: Boolean;
    procedure _from_Champs_interne( _Value: JSValue);
    procedure _from_Champs;
    procedure _to_Champs;
  end;

implementation

{ TWChamp_Edit }

constructor TWChamp_Edit.Create(AOwner: TComponent);
begin
     inherited;
     FChamps:= nil;
     Champs_Changing:= False;
end;

destructor TWChamp_Edit.Destroy;
begin
     inherited;
end;

function TWChamp_Edit.Champ_OK: Boolean;
begin
     Result:= Assigned( FChamps);
     if not Result then exit;

     Result:= FChamps.proxy.hasOwnProperty( Field);
end;

procedure TWChamp_Edit.Champs_OnSet(_propertyKey, _value: TJSObject);
begin
     if Champs_Changing then exit;


     if Field <> _propertyKey.toString then exit;

     _from_Champs_interne( _value);
end;

procedure TWChamp_Edit.SetChamps(Value: TJSChamps);
begin
     if Assigned( FChamps)
     then
         FChamps.OnSet.Remove(@Champs_OnSet);

     FChamps:= nil;
     Text:= '';
     FChamps:= Value;
     if not Champ_OK then exit;

     FChamps.OnSet.Add( @Champs_OnSet);
     _from_Champs;
end;

procedure TWChamp_Edit.Change;
begin
     inherited;
     if not Champ_OK then exit;

     _to_Champs;
end;

procedure TWChamp_Edit._from_Champs_interne(_Value: JSValue);
begin
     if Champs_Changing then exit;
     try
        Champs_Changing:= True;

        Text:= String( _Value);
     finally
            Champs_Changing:= False;
            end;
end;

procedure TWChamp_Edit._from_Champs;
begin
     if Champs_Changing then exit;
     _from_Champs_interne( FChamps.proxy.Properties[Field]);
end;

procedure TWChamp_Edit._to_Champs;
begin
     if Champs_Changing then exit;
     try
        Champs_Changing:= True;

        FChamps.proxy.Properties[Field]:= Text;
     finally
            Champs_Changing:= False;
            end;
     //if Champ.Bounce then _from_Champs;
end;

function TWChamp_Edit.GetChamps: TJSChamps;
begin
     Result:= FChamps;
end;

end.
