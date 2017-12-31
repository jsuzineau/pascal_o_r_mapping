unit udmxTest_Batpro_Ligne;
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            partly as freelance: http://www.mars42.com                          |
        and partly as employee : http://www.adinfo.com                          |
                                 http://www.adi-bat.com                         |
    Copyright 2017 Jean SUZINEAU - MARS42                                       |
    Copyright 2017 GROUPE ADINFO SOFTWARE                                       |
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
  ucBatproVerifieur,
  ucbvQuery_Datasource,
  uhRequete,
  udmx,
  ublTest_Batpro_Ligne;

type
 TdmxTest_Batpro_Ligne
 =
  class( Tdmx)
    sqlqnumero: TIntegerField;
    sqlqtest_string: TStringField;
    sqlqtest_memo: TMemoField;
    sqlqtest_date: TDateField;
    sqlqtest_integer: TIntegerField;
    sqlqtest_smallint: TSmallintField;
    sqlqtest_currency: TFMTBCDField;
    sqlqtest_datetime: TSQLTimeStampField;
    sqlqtest_double: TFloatField;
    cdnumero: TIntegerField;
    cdtest_string: TStringField;
    cdtest_memo: TMemoField;
    cdtest_date: TDateField;
    cdtest_integer: TIntegerField;
    cdtest_smallint: TSmallintField;
    cdtest_currency: TFMTBCDField;
    cdtest_datetime: TSQLTimeStampField;
    cdtest_double: TFloatField;
    cdtest_champ_calcule: TStringField;
    procedure DataModuleCreate(Sender: TObject);
    procedure cdCalcFields(DataSet: TDataSet);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

function dmxTest_Batpro_Ligne: TdmxTest_Batpro_Ligne;

implementation

uses
    uClean,
    udmxcreTest_Batpro_Ligne;

{$R *.dfm}

var
   FdmxTest_Batpro_Ligne: TdmxTest_Batpro_Ligne;

function dmxTest_Batpro_Ligne: TdmxTest_Batpro_Ligne;
begin
     Clean_Get( Result, FdmxTest_Batpro_Ligne, TdmxTest_Batpro_Ligne);
end;

procedure TdmxTest_Batpro_Ligne.DataModuleCreate(Sender: TObject);
begin
     inherited;
     Classe_Handler := ThRequete;
     Classe_Elements:= TblTest_Batpro_Ligne;
     cd.OnCalcFields:= nil;
     Cree_hr;
     hr.OnCalcFields:= cdCalcFields;
end;

procedure TdmxTest_Batpro_Ligne.cdCalcFields(DataSet: TDataSet);
begin
     inherited;
     cdtest_champ_calcule.Value:= 'ce champ est calculé';
end;

initialization
              if not dmxcreTest_Batpro_Ligne.Ouvert
              then
                  dmxcreTest_Batpro_Ligne.Ouvrir_Edition;
              Clean_Create ( FdmxTest_Batpro_Ligne, TdmxTest_Batpro_Ligne);
finalization
              Clean_Destroy( FdmxTest_Batpro_Ligne);
end.
