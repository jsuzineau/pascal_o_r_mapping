unit uCharge_100;
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
    uClean,
    u_sys_,
    uBatpro_StringList,
    uDataUtilsF,

    uBatpro_Ligne,

    uPool,

  SysUtils, Classes, DB, SQLDB;

type
 TCharge_100
 =
  class
  //Gestion du cycle de vie
  public
    constructor Create( _pool: TPool;
                        _SQL: String;
                        _SQL_NB_LIGNES: String);
    destructor Destroy; override;
  //Attributs
  private
    pool: TPool;
    sqlq: TSQLQuery;
    sqlqid: TLongintField;
    SQL_Original: String;
    sqlqNB_LIGNES: TSQLQuery;
  public
    sl: TBatpro_StringList;
  //Gestion des paramètres
  private
    Params_Names : array of String;
    Params_Values: array of Variant;
    OrderBy: String;
    procedure sqlq_from_Params;
  public
    procedure SetParams( _Params_Names : array of String;
                         _Params_Values: array of Variant;
                         _OrderBy: String);
  //Exécution
  public
    procedure Execute;
  //Nombre total de lignes
  private
    FNB_LIGNES: Integer;
    function GetNB_LIGNES: Integer;
  public
    property NB_LIGNES: Integer read GetNB_LIGNES;
  end;

implementation

{ TCharge_100 }

constructor TCharge_100.Create( _pool: TPool;
                                _SQL: String;
                                _SQL_NB_LIGNES: String);
begin
     pool     := _pool;

     sqlq:= TSQLQuery.Create( nil);
     sqlq.Database:= pool.Connection;
     sqlq.Name:= 'sqlq';

     sqlqid:= TLongintField.Create( sqlq);
     sqlqid.FieldName:= 'id';
     sqlqid.DataSet:= sqlq;

     sqlqNB_LIGNES:= TSQLQuery.Create( nil);
     sqlqNB_LIGNES.Database:= pool.Connection;
     sqlqNB_LIGNES.Name:= 'sqlqNB_LIGNES';
     sqlqNB_LIGNES.SQL.Text:= _SQL_NB_LIGNES;

     sl    := TBatpro_StringList.Create;

     FNB_LIGNES:= 0;
     SetLength( Params_Names , 0);
     SetLength( Params_Values, 0);
     SQL_Original:= _SQL;
end;

destructor TCharge_100.Destroy;
begin
     Free_Nil( sl    );
     inherited;
end;

procedure TCharge_100.sqlq_from_Params;
var
   I: Integer;
begin
     with sqlq.Params
     do
       begin
       for I:= Low( Params_Names) to High( Params_Names)
       do
         ParamByName( Params_Names [I]).Value:= Params_Values[I];
       end;
end;

procedure TCharge_100.SetParams( _Params_Names : array of String;
                                 _Params_Values: array of Variant;
                                 _OrderBy: String);
var
   I, L: Integer;
   SQL: String;
begin
     L:= Length( _Params_Names);
     SetLength( Params_Names , L);
     SetLength( Params_Values, L);

     for I:= Low( Params_Names) to High( Params_Names)
     do
       begin
       Params_Names [I]:= _Params_Names [I];
       Params_Values[I]:= _Params_Values[I];
       end;

     OrderBy:= _OrderBy;

     FNB_LIGNES:= 0;
     sl.Clear;
     SQL:= SQL_Original;
     if OrderBy <> ''
     then
         SQL
         :=
            SQL + sys_N
           +'order by'+sys_N
           +'      '+OrderBy;
     sqlq.SQL.Text:= SQL;
     sqlq_from_Params;
     //AfficheRequete( sqlq);
     RefreshQuery( sqlq);
end;

procedure TCharge_100.Execute;
begin
     pool.Load_N_rows_by_id( sqlq, sqlqid, sl, nil, 100);
end;

function TCharge_100.GetNB_LIGNES: Integer;
var
   I: Integer;
begin
     if FNB_LIGNES = 0
     then
         begin
         with sqlqNB_LIGNES.Params
         do
           begin
           for I:= Low( Params_Names) to High( Params_Names)
           do
             ParamByName( Params_Names [I]).Value:= Params_Values[I];
           end;
         RefreshQuery( sqlqNB_LIGNES);
         FNB_LIGNES:= sqlqNB_LIGNES.Fields[0].AsInteger;
         sqlqNB_LIGNES.Close;
         end;

     Result:= FNB_LIGNES;
end;

end.
