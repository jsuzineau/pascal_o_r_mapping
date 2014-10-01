unit ujpPHP_Doctrine_HasOne;
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
    uGlobal,
    uContexteClasse,
    uContexteMembre,
    uJoinPoint;

type
 TjpPHP_Doctrine_HasOne
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

var
   jpPHP_Doctrine_HasOne: TjpPHP_Doctrine_HasOne;

implementation

{ TjpPHP_Doctrine_HasOne }

constructor TjpPHP_Doctrine_HasOne.Create;
begin
     Cle:= '//Point d''insertion PHP_Doctrine_HasOne';

end;

procedure TjpPHP_Doctrine_HasOne.Initialise(_cc: TContexteClasse);
begin
     inherited;
end;

procedure TjpPHP_Doctrine_HasOne.VisiteMembre(_cm: TContexteMembre);
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

           + '    	$this->hasOne( '''+cm.sNomTableMembre+' as '+cm.Member_Name+''', '
           + '    		             array( ''foreign'' => ''id'',                     '
           + '    			                  ''local'' => '''+cm.sNomChamp+'''          '
           + '    		                    )                                          '
           + '    	               );                                                ';
         end;
end;

procedure TjpPHP_Doctrine_HasOne.Finalise;
begin
     inherited;
end;

initialization
              jpPHP_Doctrine_HasOne:= TjpPHP_Doctrine_HasOne.Create;
finalization
              FreeAndNil( jpPHP_Doctrine_HasOne);
end.
