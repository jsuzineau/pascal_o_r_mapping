unit upoolMesure;
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
  uClean,
  uBatpro_StringList,
  uDataUtilsU,

  ublMesure,

  udmDatabase,
  udmBatpro_DataModule,
  uPool,
  

  uhfMesure,
  SysUtils, Classes, DB, SqlDB;

type

 { TpoolMesure }

 TpoolMesure
 =
  class( TPool)
    procedure DataModuleCreate(Sender: TObject);  override;
  //Filtre
  public
    hfMesure: ThfMesure;
  //Accés général
  public
    function Get( _id: integer): TblMesure;
  //Accés par clé
  protected
    temps: String;
    pression: double;
    procedure To_Params( _Params: TParams); override;
  public
  //Indépendance par rapport au SGBD Informix ou MySQL
  protected
    function SQLWHERE_ContraintesChamps: String; override;
  //Méthode de création de test
  public
    function Test(_temps: String; _pression: Double): Integer;
  //Ajout d'une nouvelle mesure
  public
    function Ajoute(_temps: String; _pression: Double): TblMesure;
  //Chargement d'une période
  public
    procedure Charge_Periode( _Debut, _Fin: TDatetime; _slLoaded: TBatpro_StringList= nil);
  //Chargement des dernières 24h
  public
    procedure Charge_24h( _slLoaded: TBatpro_StringList= nil);
  end;

function poolMesure: TpoolMesure;

implementation



var
   FpoolMesure: TpoolMesure;

function poolMesure: TpoolMesure;
begin
     TPool.class_Get( Result, FpoolMesure, TpoolMesure);
end;

{ TpoolMesure }

procedure TpoolMesure.DataModuleCreate(Sender: TObject);
begin
     NomTable:= 'Mesure';
     Classe_Elements:= TblMesure;
     Classe_Filtre:= ThfMesure;

     inherited;

     hfMesure:= hf as ThfMesure;
end;

function TpoolMesure.Get( _id: integer): TblMesure;
begin
     Get_Interne_from_id( _id, Result);
end;

procedure TpoolMesure.To_Params( _Params: TParams);
begin
     inherited;
     with _Params
     do
       begin
       ParamByName( 'temps'    ).AsString:= temps;
       ParamByName( 'pression' ).AsFloat := pression;
       end;
end;

function TpoolMesure.SQLWHERE_ContraintesChamps: String;
begin
     Result                                    
     :=                                        
       'where                        '#13#10+
       '         temps           = :temps          '#13#10+
       '     and pression        = :pression       ';
end;

function TpoolMesure.Test(_temps: String; _pression: Double): Integer;
var                                                 
   bl: TblMesure;                          
begin                                               
     Nouveau_Base( bl);
     bl.temps          := _temps        ;
     bl.pression       := _pression     ;
     bl.Save_to_database;                            
     Result:= bl.id;                                 
end;

function TpoolMesure.Ajoute(_temps: String; _pression: Double): TblMesure;
begin
     Nouveau_Base( Result);
     Result.temps   := _temps   ;
     Result.pression:= _pression;
     Result.Save_to_database;
end;

procedure TpoolMesure.Charge_Periode( _Debut, _Fin: TDatetime; _slLoaded: TBatpro_StringList);
var
   SQL: String;
   P: TParams;
   pDebut, pFin: TParam;
begin
     SQL
     :=
        'select                                '#13#10
       +'      Mesure.*                        '#13#10
       +'from                                  '#13#10
       +'    Mesure                            '#13#10
       +'where                                 '#13#10
       +'     :Debut <= temps and temps <= :Fin'#13#10;
     P:= TParams.Create;
     try
        pDebut:= CreeParam( P, 'Debut');
        pFin  := CreeParam( P, 'Fin'  );
        pDebut.AsString:= DateTimeSQL_sans_quotes( _Debut);
        pFin  .AsString:= DateTimeSQL_sans_quotes( _Fin  );
        Load( SQL, _slLoaded, nil, P);
     finally
            FreeAndNil( P);
            end;
end;

procedure TpoolMesure.Charge_24h( _slLoaded: TBatpro_StringList);
var
   Maintenant: ValReal;
begin
     Maintenant:= Now;
     Charge_Periode( Maintenant-1, Maintenant, _slLoaded);
end;


initialization
finalization
              TPool.class_Destroy( FpoolMesure);
end.
