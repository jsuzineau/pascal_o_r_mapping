unit udmaNomTable;
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
  Dialogs, FMTBcd, Provider, DBClient, DB, SqlExpr, mySQLDbTables,
  udmDataModule,
  udmq;

type
 TdmaNomTable
 =
  class( Tdmq)
    qNumero: TIntegerField;
    qLibelle: TStringField;
    procedure qCalcFields(DataSet: TDataSet);
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    { Déclarations privées }
  protected
    { Déclarations protégées }
    function GetDatasetTypeOuverture( D: TDataSet): TTypeOuverture;override;
  public
    { Déclarations publiques }
    function Ouverture(Edition: Boolean): Boolean; override;
  //Gestion du suivi de ligne courante à la fermeture de dm
  private
    dm_Numero: Integer;
    procedure dm_BeforeFermeture;
    procedure dm_AfterFermeture;
  end;

function dmaNomTable: TdmaNomTable;

implementation

uses
    uClean,
    uDataUtilsF,
{implementation_uses_key}
    udmcreNomTable,
    udmNomTable,
    udmDatabase;

{$R *.dfm}

var
   FdmaNomTable: TdmaNomTable;

function dmaNomTable: TdmaNomTable;
begin
     Clean_Get( Result, FdmaNomTable, TdmaNomTable);
end;

{ TdmaNomTable }

procedure TdmaNomTable.DataModuleCreate(Sender: TObject);
begin
     inherited;
     dmNomTable.dpBeforeFermeture.Subscribe( Self, dm_BeforeFermeture, False);
     dmNomTable.dpAfterFermeture .Subscribe( Self, dm_AfterFermeture , False);
end;

procedure TdmaNomTable.DataModuleDestroy(Sender: TObject);
begin
     dmNomTable.dpBeforeFermeture.UnSubscribe( Self, dm_BeforeFermeture);
     dmNomTable.dpAfterFermeture .UnSubscribe( Self, dm_AfterFermeture );
     inherited;
end;

function TdmaNomTable.GetDatasetTypeOuverture( D: TDataSet): TTypeOuverture;
begin
     Result:= inherited GetDatasetTypeOuverture( D);

     if (q = D)
     then
         Result:=  to_LectureSeule;
end;

procedure TdmaNomTable.qCalcFields(DataSet: TDataSet);
begin
     inherited;
{qCalcFields_Key}
end;

function TdmaNomTable.Ouverture(Edition: Boolean): Boolean;
begin
{Ouverture_key}
     Result:= inherited Ouverture( Edition);
end;

procedure TdmaNomTable.dm_BeforeFermeture;
begin
     Poste( dmNomTable.t);
     dm_Numero:= dmNomTable.qNumero.Value;
end;

procedure TdmaNomTable.dm_AfterFermeture;
begin
     if Ouvert
     then
         begin
         RefreshQuery( q);
         q.Locate( 'Numero', dm_Numero, []);
         end;
end;

initialization
              Clean_Create ( FdmaNomTable, TdmaNomTable);
finalization
              Clean_destroy( FdmaNomTable);
end.
