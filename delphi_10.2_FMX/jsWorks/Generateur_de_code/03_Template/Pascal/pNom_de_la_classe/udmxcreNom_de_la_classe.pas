unit udmxcreNom_de_la_classe;
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
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB,

  udmBatpro_DataModule,
  udmxCreator,  FMTBcd, SqlExpr;

type
 TdmxcreNom_de_la_classe
 =
  class(TdmxCreator)
    sqlq: TSQLQuery;
  private
    function Traite_Index( NomChamp: String): Boolean;
  public
    { Déclarations publiques }
    function Ouverture(Edition: Boolean): Boolean; override;
  end;

function dmxcreNom_de_la_classe: TdmxcreNom_de_la_classe;

implementation

uses
    uClean,
    udmDatabase;

{$R *.dfm}

var
   FdmxcreNom_de_la_classe: TdmxcreNom_de_la_classe;

function dmxcreNom_de_la_classe: TdmxcreNom_de_la_classe;
begin
     Clean_Get( Result, FdmxcreNom_de_la_classe, TdmxcreNom_de_la_classe);
end;

{ TdmxcreNom_de_la_classe }

function TdmxcreNom_de_la_classe.Ouverture(Edition: Boolean): Boolean;
begin
     Result:= Traite_Table( '', 'Nom_de_la_table', sqlq, sqlq);
{Traite_Index_key}
end;

function TdmxcreNom_de_la_classe.Traite_Index(NomChamp: String): Boolean;
begin
     //inutile pour l'instant
     Result:= True;
end;

initialization
              Clean_Create ( FdmxcreNom_de_la_classe, TdmxcreNom_de_la_classe);
finalization
              Clean_Destroy( FdmxcreNom_de_la_classe);
end.

