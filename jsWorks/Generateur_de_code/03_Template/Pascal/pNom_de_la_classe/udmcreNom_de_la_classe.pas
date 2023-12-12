unit udmcreNomTable;
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            http://www.mars42.com                                               |
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
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, mySQLDbTables,

  udmDataModule,
  udmCreator;

type
 TdmcreNomTable
 =
  class(TdmCreator)
    q: TmySQLQuery;
  private
  public
    { Déclarations publiques }
    function Ouverture(Edition: Boolean): Boolean; override;
  end;

function dmcreNomTable: TdmcreNomTable;

implementation

uses
    uClean,
    udmDatabase;

{$R *.dfm}

var
   FdmcreNomTable: TdmcreNomTable;

function dmcreNomTable: TdmcreNomTable;
begin
     Clean_Get( Result, FdmcreNomTable, TdmcreNomTable);
end;

{ TdmcreNomTable }

function TdmcreNomTable.Ouverture(Edition: Boolean): Boolean;
begin
     Result:= Traite_Table( '', 'NomTable', q);
{Traite_Index_key}     
end;

initialization
              Clean_Create ( FdmcreNomTable, TdmcreNomTable);
finalization
              Clean_Destroy( FdmcreNomTable);
end.

