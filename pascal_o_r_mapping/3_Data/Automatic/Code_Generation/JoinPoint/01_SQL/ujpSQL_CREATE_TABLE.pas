unit ujpSQL_CREATE_TABLE;
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
 TjpSQL_CREATE_TABLE
 =
  class( TJoinPoint)
  //Attributs
  public
    SQL: String;
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
   jpSQL_CREATE_TABLE: TjpSQL_CREATE_TABLE;

implementation

{ TjpSQL_CREATE_TABLE }

constructor TjpSQL_CREATE_TABLE.Create;
begin
     Cle:= 'CREATE_TABLE';
end;

procedure TjpSQL_CREATE_TABLE.Initialise( _cc: TContexteClasse);
begin
     inherited;
     Valeur
     :=
       'CREATE TABLE '+cc.Nom_de_la_table+s_SQL_saut+
       '  ('+s_SQL_saut+
       '  '+TailleNom('Numero')+
            ' INTEGER AUTO_INCREMENT PRIMARY KEY';
end;

procedure TjpSQL_CREATE_TABLE.VisiteMembre(_cm: TContexteMembre);
begin
     inherited;
     SQL:= '  ';
     if cm.CleEtrangere
     then
         SQL:= SQL+TailleNom( cm.sNomChamp)+' INTEGER'
     else
         SQL:= SQL+
               TailleNom( cm.sNomChamp_database_quote)+' '+SQL_from_Type( cm.sTypChamp);
     Valeur:= Valeur+','+s_SQL_saut+SQL;
end;

procedure TjpSQL_CREATE_TABLE.Finalise;
begin
     inherited;
     Valeur:= Valeur + '  )'+s_SQL_saut;
     slLog.Add( Valeur);
end;

initialization
              jpSQL_CREATE_TABLE:= TjpSQL_CREATE_TABLE.Create;
finalization
              FreeAndNil( jpSQL_CREATE_TABLE);
end.
