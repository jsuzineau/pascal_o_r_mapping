unit uLookupConnection_Ancetre;
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
    uClean,
    uBatpro_StringList,
    SysUtils, Classes;

type
 TLookupConnection_Ancetre
 =
  class
  //Gestion du cycle de vie
  public
    constructor Create;
    destructor Destroy; override;
  //Attributs
  public
    slLiens,
    slContraintes: TBatpro_StringList;
  //Méthodes
  public
    procedure Ajoute_Lien      ( NomChamp_Detail: String; NomChamp_Maitre: String = '');
    procedure Ajoute_Contrainte( NomChamp_Detail: String; Valeur         : String);
  end;

implementation

{ TLookupConnection_Ancetre }

constructor TLookupConnection_Ancetre.Create;
begin
     slLiens      := TBatpro_StringList.Create;
     slContraintes:= TBatpro_StringList.Create;
end;

destructor TLookupConnection_Ancetre.Destroy;
begin
     Free_nil( slLiens      );
     Free_nil( slContraintes);
     inherited;
end;

procedure TLookupConnection_Ancetre.Ajoute_Lien( NomChamp_Detail: String; NomChamp_Maitre: String='');
begin
     if NomChamp_Maitre = ''
     then
         NomChamp_Maitre:= NomChamp_Detail;
     slLiens.Values[ NomChamp_Detail]:= NomChamp_Maitre;
end;

procedure TLookupConnection_Ancetre.Ajoute_Contrainte( NomChamp_Detail: String; Valeur: String);
begin
     slContraintes.Values[ NomChamp_Detail]:= Valeur;
end;

end.
