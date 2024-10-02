unit uMotsCles;
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
    u_sys_,
    uClean,
    SysUtils, Classes, Types;

type
 TMotsCles
 =
  class
  //Gestion du cycle de vie
  public
    constructor Create;
    destructor Destroy; override;
  //attributs
  public
    Famille_Valeur: String;
    Nom, Valeur: TStringDynArray;
  //méthodes
  public
    procedure Ajoute_Nom( _Nom: String);
    procedure Ajoute    ( _Nom, _Valeur: String);
  end;

implementation

{ TMotsCles }

constructor TMotsCles.Create;
begin
     inherited;
     Famille_Valeur:= sys_Vide;
     SetLength( Nom   , 0);
     SetLength( Valeur, 0);
end;

destructor TMotsCles.Destroy;
begin

     inherited;
end;

procedure TMotsCles.Ajoute_Nom( _Nom: String);
var
   I: Integer;
begin
     I:= Length( Nom);
     SetLength( Nom, I+1);
     Nom[I]:= _Nom;
end;

procedure TMotsCles.Ajoute( _Nom, _Valeur: String);
var
   I, NewLength: Integer;
begin
     I:= Length( Nom);
     NewLength:= I+1;
     SetLength( Nom   , NewLength);
     SetLength( Valeur, NewLength);
     Nom   [I]:= _Nom   ;
     Valeur[I]:= _Valeur;
end;

end.
