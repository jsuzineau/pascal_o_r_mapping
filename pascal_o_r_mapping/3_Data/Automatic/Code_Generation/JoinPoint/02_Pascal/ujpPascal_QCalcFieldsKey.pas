unit ujpPascal_QCalcFieldsKey;
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
 TjpPascal_QCalcFieldsKey
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
   jpPascal_QCalcFieldsKey: TjpPascal_QCalcFieldsKey;

implementation

{ TjpPascal_QCalcFieldsKey }

constructor TjpPascal_QCalcFieldsKey.Create;
begin
     Cle:= '{qCalcFields_Key}';

end;

procedure TjpPascal_QCalcFieldsKey.Initialise(_cc: TContexteClasse);
begin
     inherited;
end;

procedure TjpPascal_QCalcFieldsKey.VisiteMembre(_cm: TContexteMembre);
begin
     inherited;
     if Valeur = ''
     then
         Valeur
         :=
           '     Result                                    '#13#10+
           '     :=                                        '#13#10+
           '       ''where                        ''#13#10+'#13#10+
           '       ''         '
     else
         Valeur
         :=
            Valeur
           +'''#13#10+'#13#10'       ''     and ';

     Valeur:= Valeur+TailleNom(cm.sNomChamp)+' = :'+TailleNom(cm.sNomChamp);
end;

procedure TjpPascal_QCalcFieldsKey.Finalise;
begin
     inherited;
     if Valeur <> ''
     then
         Valeur:= Valeur+''';';
end;

initialization
              jpPascal_QCalcFieldsKey:= TjpPascal_QCalcFieldsKey.Create;
finalization
              FreeAndNil( jpPascal_QCalcFieldsKey);
end.
