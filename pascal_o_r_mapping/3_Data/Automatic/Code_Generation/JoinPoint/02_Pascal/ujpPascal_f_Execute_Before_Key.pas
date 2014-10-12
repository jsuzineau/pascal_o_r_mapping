unit ujpPascal_f_Execute_Before_Key;
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
    uGenerateur_Delphi_Ancetre,
    uContexteClasse,
    uContexteMembre,
    uJoinPoint,
  SysUtils, Classes;

type

 { TjpPascal_f_Execute_Before_Key }

 TjpPascal_f_Execute_Before_Key
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
    procedure VisiteDetail( s_Detail, sNomTableMembre: String); override;
    procedure Finalise; override;
  end;

var
   jpPascal_f_Execute_Before_Key: TjpPascal_f_Execute_Before_Key;

implementation

{ TjpPascal_f_Execute_Before_Key }

constructor TjpPascal_f_Execute_Before_Key.Create;
begin
     Cle:= '               //f_Execute_Before_Key';
end;

procedure TjpPascal_f_Execute_Before_Key.Initialise(_cc: TContexteClasse);
begin
     inherited;
end;

procedure TjpPascal_f_Execute_Before_Key.VisiteMembre(_cm: TContexteMembre);
begin
     inherited;
end;

procedure TjpPascal_f_Execute_Before_Key.VisiteDetail( s_Detail, sNomTableMembre: String);
var
   s_dkd: String;
   s_dkd_Accroche: String;
begin
     inherited VisiteDetail(s_Detail, sNomTableMembre);
     s_dkd:= 'dkd'+s_Detail;
     s_dkd_Accroche
     :=
       '               '+s_dkd+'.Accroche( dm'+sNomTableMembre+', pc);'#13#10;
     Valeur:= Valeur + s_dkd_Accroche;
end;

procedure TjpPascal_f_Execute_Before_Key.Finalise;
begin
     inherited;
end;

initialization
              jpPascal_f_Execute_Before_Key:= TjpPascal_f_Execute_Before_Key.Create;
finalization
              FreeAndNil( jpPascal_f_Execute_Before_Key);
end.
