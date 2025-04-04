unit ujpDocksDetails;
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
 TjpDocksDetails
 =
  class( TJoinPoint)
  //Attributs
  public
    procedure Finalise; override;
  //Gestion du cycle de vie
  public
    constructor Create;
  //Gestion de la visite d'une classe
  public
    procedure Initialise(_cc: TContexteClasse); override;
    procedure VisiteDetail(s_Detail, sNomTableMembre: String); override;
  end;

var
   jpDocksDetails: TjpDocksDetails;

implementation

{ TjpDocksDetails }

constructor TjpDocksDetails.Create;
begin
     Cle:= '//Point d''insertion aggrégations faibles, docks de détails';
end;

procedure TjpDocksDetails.Initialise(_cc: TContexteClasse);
begin
     inherited;
end;

procedure TjpDocksDetails.VisiteDetail(s_Detail, sNomTableMembre: String);
begin
     inherited;
     if Valeur = ''
     then
         Valeur:= '		#region Aggrégations faibles, docks de détails'#13#10#13#10
     else
         Valeur:= Valeur + #13#10;
     Valeur
     :=
         Valeur
       + '    static public TdkDetail    dkd'+s_Detail
       + ' = new TdkDetail( "'+sNomTableMembre+'", "'+cc.NomTable
       + '", "'+s_Detail+'", fm.tc);';
end;

procedure TjpDocksDetails.Finalise;
begin
     inherited;
     if Valeur <> ''
     then
         Valeur:= Valeur + #13#10#13#10'   #endregion'#13#10;
end;

initialization
              jpDocksDetails:= TjpDocksDetails.Create;
finalization
              FreeAndNil( jpDocksDetails);
end.
