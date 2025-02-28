unit ujpPascal_Assure_Implementation;
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
    uGenerateur_de_code_Ancetre,
    uContexteClasse,
    uContexteMembre,
    uJoinPoint;

type
 TjpPascal_Assure_Implementation
 =
  class( TJoinPoint)
  //Attributs
  public
    sGet_by_Cle: String;
    Body: String;
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
   jpPascal_Assure_Implementation: TjpPascal_Assure_Implementation;

implementation

{ TjpPascal_Assure_Implementation }

constructor TjpPascal_Assure_Implementation.Create;
begin
     Cle:= '//pattern_Assure_Implementation';
end;

procedure TjpPascal_Assure_Implementation.Initialise(_cc: TContexteClasse);
begin
     inherited;
     sGet_by_Cle:= '';
     Body:= '';
end;

procedure TjpPascal_Assure_Implementation.VisiteMembre(_cm: TContexteMembre);
begin
     inherited;

     if not cm.Belongs_to_sCle then exit;

     if Valeur = ''
     then
         Valeur:= 'function Tpool'+cc.Nom_de_la_classe+'.Assure('
     else
         Valeur:= Valeur + '; ';

     Valeur:= Valeur+cm.sPascal_DeclarationParametre;

     if sGet_by_Cle = ''
     then
         sGet_by_Cle:= '     Result:= Get_by_Cle( '
     else
         sGet_by_Cle:= sGet_by_Cle+', ';

     sGet_by_Cle:= sGet_by_Cle + cm.sParametre;

     if Body = ''
     then
         Body
         :=
         '     Nouveau_Base( Result);                        '#13#10;
     Body:= Body + '       Result.'+TailleNom(cm.sNomChamp)+':='+TailleNom(cm.sParametre)+';'#13#10;

end;

procedure TjpPascal_Assure_Implementation.Finalise;
begin
     inherited;
     if Valeur = '' then exit;

     Body
     :=
      sGet_by_Cle+');'#13#10
     +'     if Assigned( Result) then exit;'#13#10
     +#13#10
     +Body
     +'     Result.Save_to_database;'#13#10;
     Valeur
     :=
         Valeur+'): Tbl'+cc.Nom_de_la_classe+';'#13#10
       + 'begin                               '#13#10
       + Body
       + 'end;'#13#10
end;

initialization
              jpPascal_Assure_Implementation:= TjpPascal_Assure_Implementation.Create;
finalization
              FreeAndNil( jpPascal_Assure_Implementation);
end.
