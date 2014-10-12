unit ujpPascal_Test_Implementation_Key;
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
 TjpPascal_Test_Implementation_Key
 =
  class( TJoinPoint)
  //Attributs
  public
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
   jpPascal_Test_Implementation_Key: TjpPascal_Test_Implementation_Key;

implementation

{ TjpPascal_Test_Implementation_Key }

constructor TjpPascal_Test_Implementation_Key.Create;
begin
     Cle:= '{Test_Implementation_Key}';
end;

procedure TjpPascal_Test_Implementation_Key.Initialise(_cc: TContexteClasse);
begin
     inherited;
     Body:= '';
end;

procedure TjpPascal_Test_Implementation_Key.VisiteMembre(_cm: TContexteMembre);
begin
     inherited;

     if Valeur = ''
     then
         Valeur:= 'function Tpool'+cc.Nom_de_la_classe+'.Test('
     else
         Valeur:= Valeur + '; ';

     Valeur:= Valeur+cm.sPascal_DeclarationParametre;

     if Body = ''
     then
         Body
         :=
         'var                                                 '#13#10+
         '   bl: Tbl'+cc.Nom_de_la_classe+';                          '#13#10+
         'begin                                               '#13#10+
         '          Nouveau_Base( bl);                        '#13#10;
     Body:= Body + '       bl.'+TailleNom(cm.sNomChamp)+':='+TailleNom(cm.sParametre)+';'#13#10;
end;

procedure TjpPascal_Test_Implementation_Key.Finalise;
begin
     inherited;
     if Body <> ''
     then
         Body
         :=
           Body+
           '     bl.Save_to_database;                            '#13#10+
           '     Result:= bl.id;                                 '#13#10+
           'end;                                                 '#13#10;
     if Valeur <> ''
     then
         Valeur
         :=
            Valeur
           +'):Integer;'#13#10
           +Body
       ;
end;

initialization
              jpPascal_Test_Implementation_Key:= TjpPascal_Test_Implementation_Key.Create;
finalization
              FreeAndNil( jpPascal_Test_Implementation_Key);
end.
