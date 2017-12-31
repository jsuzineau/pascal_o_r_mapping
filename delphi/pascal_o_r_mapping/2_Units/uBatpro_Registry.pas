unit uBatpro_Registry;
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
    SysUtils, Classes, Registry,
    u_sys_,
    u_reg_,
    uClean;

type
 TBatpro_Registry
 =
  class( TRegistry)
  protected
    Racine: String;
  public
    constructor Create;
    function EcritChaine( Nom, Valeur: String): Boolean;
    function LitChaine( Nom, ValeurParDefaut: String): String;
  end;

implementation


{ TBatpro_Registry }

constructor TBatpro_Registry.Create;
begin
     inherited;
     Racine:=   UpperCase( ChangeFileExt(ExtractFileName(ParamStr(0)),sys_Vide))
              + '\';
end;

function TBatpro_Registry.EcritChaine(Nom, Valeur: String): Boolean;
begin
     Result:= OpenKey( regk_Racine_Batpro+Racine, True);
     if Result
     then
         try
            WriteString( Nom, Valeur);
         finally
                CloseKey;
                end;
end;

function TBatpro_Registry.LitChaine(Nom, ValeurParDefaut: String): String;
begin
     if OpenKey( regk_Racine_Batpro+Racine, True)
     then
         try
            if ValueExists( Nom)
            then
                Result:= ReadString( Nom)
            else
                Result:= ValeurParDefaut;
         finally
                CloseKey;
                end
     else
         Result:= ValeurParDefaut;
end;

end.
