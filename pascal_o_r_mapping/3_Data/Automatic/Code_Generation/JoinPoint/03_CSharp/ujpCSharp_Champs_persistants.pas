unit ujpCSharp_Champs_persistants;
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
    SysUtils, Classes,
    uGenerateur_Delphi_Ancetre,
    uContexteClasse,
    uContexteMembre,
    uJoinPoint;

type
 TjpCSharp_Champs_persistants
 =
  class( TJoinPoint)
  //Attributs
  public
  //Gestion du cycle de vie
  public
    constructor Create;
  //Gestion de la visite d'une classe
  public
    procedure Initialise(_cc: TContexteClasse); override;
    procedure VisiteMembre(_cm: TContexteMembre); override;
    procedure Finalise; override;
  end;

function jpCSharp_Champs_persistants: TjpCSharp_Champs_persistants;

implementation

{ TjpCSharp_Champs_persistants }
var
   FjpCSharp_Champs_persistants: TjpCSharp_Champs_persistants= nil;

function jpCSharp_Champs_persistants: TjpCSharp_Champs_persistants;
begin
     if nil = FjpCSharp_Champs_persistants
     then
         FjpCSharp_Champs_persistants:= TjpCSharp_Champs_persistants.Create;

     Result:= FjpCSharp_Champs_persistants;
end;

constructor TjpCSharp_Champs_persistants.Create;
begin
     inherited;
     Cle:= '//Point d''insertion champs persistants';
end;

procedure TjpCSharp_Champs_persistants.Initialise(_cc: TContexteClasse);
begin
     inherited;
end;

procedure TjpCSharp_Champs_persistants.VisiteMembre(_cm: TContexteMembre);
begin
     inherited;
     if Valeur = ''
     then
         Valeur:= '		#region Champs persistants'#13#10#13#10
     else
         Valeur:= Valeur + #13#10;
     Valeur:= Valeur+CS_from_Type( cm.sNomChamp,cm.sTypChamp);
end;

procedure TjpCSharp_Champs_persistants.Finalise;
begin
     inherited;
     if Valeur <> ''
     then
         Valeur
         := Valeur+#13#10#13#10'		#endregion'#13#10;
end;

initialization
finalization
              FreeAndNil( FjpCSharp_Champs_persistants);
end.
