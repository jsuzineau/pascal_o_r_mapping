unit ujpAngular_TypeScript_html_editeurs_champs;
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            http://www.mars42.com                          |
                                                                                |
    Copyright 2019 Jean SUZINEAU - MARS42                                       |
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
    uGenerateur_de_code_Ancetre,
    uContexteClasse,
    uContexteMembre,
    uJoinPoint,
  SysUtils, Classes;

type
 TjpAngular_TypeScript_html_editeurs_champs
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
   jpAngular_TypeScript_html_editeurs_champs: TjpAngular_TypeScript_html_editeurs_champs;

implementation

{ TjpAngular_TypeScript_html_editeurs_champs }

constructor TjpAngular_TypeScript_html_editeurs_champs.Create;
begin
     Cle:= '<!-- Angular_TypeScript_html_editeurs_champs -->';
end;

procedure TjpAngular_TypeScript_html_editeurs_champs.Initialise(_cc: TContexteClasse);
begin
     inherited;
end;

procedure TjpAngular_TypeScript_html_editeurs_champs.VisiteMembre(_cm: TContexteMembre);
begin
     inherited;
     if Valeur <> ''
     then
         Valeur:= Valeur + #13#10;

     Valeur
     :=
        Valeur
       +'<tr>'
       +'  <td>'+_cm.sNomChamp+':</td>'
       +'<td>'
       +'<span (click)="onClick( '+_cm.cc.Nom_de_la_classe+')" class="'+_cm.cc.Nom_de_la_classe+'_'+_cm.sNomChamp+'">'
       +'  <span *ngIf="!'+_cm.cc.Nom_de_la_classe+'.modifie">{{'+_cm.cc.Nom_de_la_classe+'.'+_cm.sNomChamp+'}}</span>'
       +'  <span *ngIf= "'+_cm.cc.Nom_de_la_classe+'.modifie"><input type="text" (keydown)="onKeyDown($event)" [(ngModel)]="'+_cm.cc.Nom_de_la_classe+'.'+_cm.sNomChamp+'"/></span>'
       +'</span>'
       +'/td'
       +'/tr';
end;

procedure TjpAngular_TypeScript_html_editeurs_champs.Finalise;
begin
     inherited;
end;

initialization
              jpAngular_TypeScript_html_editeurs_champs:= TjpAngular_TypeScript_html_editeurs_champs.Create;
finalization
              FreeAndNil( jpAngular_TypeScript_html_editeurs_champs);
end.
