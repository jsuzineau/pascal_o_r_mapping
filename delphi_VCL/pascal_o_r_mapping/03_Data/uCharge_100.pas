unit uCharge_100;
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
    uClean,
    u_sys_,
    uBatpro_StringList,
    uDataUtilsF,

    uBatpro_Ligne,

    uPool,

  SysUtils, Classes, DB, SqlExpr;

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
    jsdc: TjsDataContexte;
    SQL_Original: String;
    jsdcNB_LIGNES: TjsDataContexte;
  public
    sl: TBatpro_StringList;
  //Gestion des paramètres
  private
    Params_Names : array of String;
    Params_Values: array of Variant;
    OrderBy: String;
    procedure jsdc_from_Params;
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

     jsdc:= pool.Connection.Cree_Contexte( ClassName+'.jsdc');

     jsdcNB_LIGNES:= pool.Connection.Cree_Contexte( ClassName+'.jsdcNB_LIGNES');
     jsdcNB_LIGNES.SQL:= _SQL_NB_LIGNES;

     sl    := TBatpro_StringList.Create;

     FNB_LIGNES:= 0;
     SetLength( Params_Names , 0);
     SetLength( Params_Values, 0);
     SQL_Original:= _SQL;
end;

destructor TCharge_100.Destroy;
begin
     Free_Nil( sl           );
     Free_Nil( jsdcNB_LIGNES);
     Free_Nil( jsdc         );
     inherited;
end;

procedure TCharge_100.jsdc_from_Params;
var
   I: Integer;
begin
     with jsdc.Params
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
     jsdc.SQL:= SQL;
     jsdc_from_Params;
     //AfficheRequete( sqlq);
     jsdc.RefreshQuery;
end;

procedure TCharge_100.Execute;
begin
     pool.Load_N_rows_by_id( jsdc, sl, nil, 100);
end;

function TCharge_100.GetNB_LIGNES: Integer;
var
   I: Integer;
begin
     if FNB_LIGNES = 0
     then
         begin
         with jsdcNB_LIGNES.Params
         do
           begin
           for I:= Low( Params_Names) to High( Params_Names)
           do
             ParamByName( Params_Names [I]).Value:= Params_Values[I];
           end;
         jsdc.RefreshQuery;
         FNB_LIGNES:= jsdcNB_LIGNES.Champ_by_Index(0).AsInteger;
         jsdcNB_LIGNES.Close;
         end;

     Result:= FNB_LIGNES;
end;

end.
