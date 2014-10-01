unit udmxtNomTable;
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
  Dialogs, FMTBcd, Provider, DBClient, DB, SqlExpr,

  TestFrameWork,
  uDataUtilsU,

  ucBatproVerifieur,
  ucbvQuery_Datasource,

  udmxG3_UTI,
  udmBatpro_DataModule,
  udmx,
  udmxSOC_ETS;

type
 TdmxtNomTable
 =
  class( TdmxSOC_ETS)
  private
    { Déclarations privées }
  protected
    { Déclarations protégées }
    function Register_Dataset( D: TDataset): TypeDataset;override;
  public
    { Déclarations publiques }
    function Ouverture(Edition: Boolean): Boolean; override;


{Test_Declaration_Key}
    function Genere( tc: TTestCase): String;
  end;

function dmxtNomTable: TdmxtNomTable;

implementation

uses
    uClean,
{implementation_uses_key}
    udmDatabase;

{$R *.dfm}

var
   FdmxtNomTable: TdmxtNomTable;

function dmxtNomTable: TdmxtNomTable;
begin
     Clean_Get( Result, FdmxtNomTable, TdmxtNomTable);
end;

{ TdmxtNomTable }

function TdmxtNomTable.Register_Dataset( D: TDataset): TypeDataset;
begin
     Result:= inherited Register_Dataset( D);

     if (cd = D)
     then
         Result:=  td_Edition;
end;

function TdmxtNomTable.Ouverture(Edition: Boolean): Boolean;
begin
{Ouverture_key}
     Result:= inherited Ouverture( Edition);
end;

{Test_Implementation_Key}

function TdmxtNomTable.Genere(tc: TTestCase): String;
begin
     Result:= Genere_Cle_8;

     tc.Check( Ouvrir_Edition, 'TdmxtNomTable.Genere: Ouvrir_Edition');
{Test_Call_Key}
     Fermer;
end;

initialization
              Clean_Create ( FdmxtNomTable, TdmxtNomTable);
finalization
              Clean_destroy( FdmxtNomTable);
end.
