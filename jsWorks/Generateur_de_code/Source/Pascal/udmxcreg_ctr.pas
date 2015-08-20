unit udmxcreg_ctr;
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
 Tdmxcreg_ctr
 =
  class(TdmxCreator)
    sqlq: TSQLQuery;
  private
    function Traite_Index( NomChamp: String): Boolean;
  public
    { Déclarations publiques }
    function Ouverture(Edition: Boolean): Boolean; override;
  end;

function dmxcreg_ctr: Tdmxcreg_ctr;

implementation

uses
    uClean,
    udmDatabase;

{$R *.dfm}

var
   Fdmxcreg_ctr: Tdmxcreg_ctr;

function dmxcreg_ctr: Tdmxcreg_ctr;
begin
     Clean_Get( Result, Fdmxcreg_ctr, Tdmxcreg_ctr);
end;

{ Tdmxcreg_ctr }

function Tdmxcreg_ctr.Ouverture(Edition: Boolean): Boolean;
begin
     Result:= Traite_Table( '', 'g_ctr', sqlq, sqlq);

end;

function Tdmxcreg_ctr.Traite_Index(NomChamp: String): Boolean;
begin
     //inutile pour l'instant
     Result:= True;
end;

initialization
              Clean_Create ( Fdmxcreg_ctr, Tdmxcreg_ctr);
finalization
              Clean_Destroy( Fdmxcreg_ctr);
end.

