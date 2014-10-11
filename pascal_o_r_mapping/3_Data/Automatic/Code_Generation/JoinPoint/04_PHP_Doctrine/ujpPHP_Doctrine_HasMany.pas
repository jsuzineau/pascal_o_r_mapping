unit ujpPHP_Doctrine_HasMany;
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
 TjpPHP_Doctrine_HasMany
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
    procedure VisiteDetail( s_Detail,sNomTableMembre: String); override;
    procedure Finalise; override;
  end;

var
   jpPHP_Doctrine_HasMany: TjpPHP_Doctrine_HasMany;

implementation

{ TjpPHP_Doctrine_HasMany }

constructor TjpPHP_Doctrine_HasMany.Create;
begin
     Cle:= '//Point d''insertion PHP_Doctrine_HasMany';

end;

procedure TjpPHP_Doctrine_HasMany.Initialise(_cc: TContexteClasse);
begin
     inherited;
end;

procedure TjpPHP_Doctrine_HasMany.VisiteDetail(s_Detail,sNomTableMembre: String);
begin
     inherited;
     if cm.CleEtrangere
     then
         begin
         if Valeur <> ''
         then
             Valeur:= Valeur + #13#10;
         Valeur
         :=
             Valeur

           + '    	$this->hasMany( '''+sNomTableMembre+' as '+s_Detail+''', '
           + '    		             array( ''local'' => ''id'',                     '
           + '    			                  ''foreign'' => ''id'+sNomTableMembre+'''          '
           + '    		                    )                                          '
           + '    	               );                                                ';
         end;
end;

procedure TjpPHP_Doctrine_HasMany.Finalise;
begin
     inherited;
end;

initialization
              jpPHP_Doctrine_HasMany:= TjpPHP_Doctrine_HasMany.Create;
finalization
              FreeAndNil( jpPHP_Doctrine_HasMany);
end.
