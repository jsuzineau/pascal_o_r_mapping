unit udmdNomTable;
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
  Dialogs, FMTBcd, Provider, DBClient, DB, SqlExpr, mySQLDbTables,
  udmDataModule,
  udmt,
  udmdBase;

type
 TdmdNomTable
 =
  class( TdmdBase)
    qNumero: TIntegerField;
    qLibelle: TStringField;
    procedure qCalcFields(DataSet: TDataSet);
    procedure DataModuleCreate(Sender: TObject);
    procedure qAfterPost(DataSet: TDataSet);
  private
    { Déclarations privées }
  protected
    { Déclarations protégées }
    function GetDatasetTypeOuverture( D: TDataSet): TTypeOuverture;override;
  public
    { Déclarations publiques }
    function Ouverture(Edition: Boolean): Boolean; override;
  end;

function dmdNomTable: TdmdNomTable;

implementation

uses
    uClean,
{implementation_uses_key}
    uhrNomTable,
    udmcreNomTable,
    udmDatabase,
    udmlkNomTable;

{$R *.dfm}

var
   FdmdNomTable: TdmdNomTable;

function dmdNomTable: TdmdNomTable;
begin
     Clean_Get( Result, FdmdNomTable, TdmdNomTable);
end;

{ TdmdNomTable }

procedure TdmdNomTable.DataModuleCreate(Sender: TObject);
begin
     Classe_Handler:= ThrNomTable;
     t.AfterPost:= nil;
     inherited;
     hr.AfterPost:= qAfterPost;
end;

function TdmdNomTable.GetDatasetTypeOuverture( D: TDataSet): TTypeOuverture;
begin
     Result:= inherited GetDatasetTypeOuverture( D);

     if (t = D)
     then
         Result:=  to_Edition;
end;

procedure TdmdNomTable.qCalcFields(DataSet: TDataSet);
begin
     inherited;
{qCalcFields_Key}
end;

function TdmdNomTable.Ouverture(Edition: Boolean): Boolean;
begin
{Ouverture_key}
     Result:= inherited Ouverture( Edition);
end;

procedure TdmdNomTable.qAfterPost(DataSet: TDataSet);
begin
     inherited;
     if dmlkNomTable.Ouvert
     then
         begin
         dmlkNomTable.Fermer;
         dmlkNomTable.Ouvrir_LectureSeule;
         end;
end;

initialization
              Clean_Create ( FdmdNomTable, TdmdNomTable);
finalization
              Clean_destroy( FdmdNomTable);
end.
