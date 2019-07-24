unit upoolG_BECPCTX;
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
    uForms,
    uBatpro_StringList,
    uClean,

    ublG_BECPCTX,

    udmDatabase,
    udmBatpro_DataModule,
    uPool,

    uhfG_BECPCTX,

  SysUtils, Classes,
  FMTBcd, BufDataset, DB, SQLDB;

type
 TpoolG_BECPCTX
 =
  class( TPool)
    procedure DataModuleCreate(Sender: TObject);  override;
    procedure DataModuleDestroy(Sender: TObject);  override;
  //Filtre
  public
    hfG_BECPCTX: ThfG_BECPCTX;
  //Accés général
  public
    function Get( _id: integer): TblG_BECPCTX;
  //Gestion de la clé
  protected
    nomclasse: String;
    contexte: Integer;

    procedure To_Params( _Params: TParams); override;
  public
    function Get_by_Cle( _nomclasse: String; _contexte: Integer): TblG_BECPCTX;
  //Gestion de l'insertion
  protected
    function SQL_INSERT: String; override;
  //Indépendance par rapport au SGBD Informix ou MySQL
  protected
    function SQLWHERE_ContraintesChamps: String; override;
  //Chargement des lignes d'un contexte
  public
    procedure Charge_Contexte( _Contexte: Integer; slLoaded: TBatpro_StringList);
  //Chargement des lignes d'une classe
  public
    procedure Charge_Classe( _NomClasse: String; slLoaded: TBatpro_StringList);
  //Chargement de toutes les lignes
  public
    procedure Charge_Tout;
  end;

function poolG_BECPCTX: TpoolG_BECPCTX;

implementation



var
   FpoolG_BECPCTX: TpoolG_BECPCTX;

function poolG_BECPCTX: TpoolG_BECPCTX;
begin
     TpoolG_BECPCTX.class_Get( Result, FpoolG_BECPCTX, TpoolG_BECPCTX);
end;

{ TpoolG_BECPCTX }

procedure TpoolG_BECPCTX.DataModuleCreate(Sender: TObject);
begin
     NomTable:= 'g_becpctx';
     Classe_Elements:= TblG_BECPCTX;
     Classe_Filtre:= ThfG_BECPCTX;

     inherited;

     Creer_si_non_trouve:= True;
     hfG_BECPCTX:= hf as ThfG_BECPCTX;
end;

procedure TpoolG_BECPCTX.DataModuleDestroy(Sender: TObject);
begin
     //
     inherited;
end;

function TpoolG_BECPCTX.Get( _id: integer): TblG_BECPCTX;
begin
     Get_Interne_from_id( _id, Result);
end;

function TpoolG_BECPCTX.Get_by_Cle( _nomclasse: String; _contexte: Integer): TblG_BECPCTX;
begin                               
     nomclasse:=  _nomclasse;
     contexte:=  _contexte;
     sCle:= TblG_BECPCTX.sCle_from_( nomclasse, contexte);
     Get_Interne( Result);
end;

function TpoolG_BECPCTX.SQL_INSERT: String;
begin
     is_Base:= False;
     Result:=
'insert into g_becpctx(nomclasse, contexte) values (:nomclasse, :contexte)';

end;

procedure TpoolG_BECPCTX.To_Params( _Params: TParams);
begin
     inherited;
     with _Params
     do
       begin
       ParamByName( 'nomclasse'    ).AsString:= nomclasse;
       ParamByName( 'contexte'    ).AsInteger:= contexte;
       end;
end;

function TpoolG_BECPCTX.SQLWHERE_ContraintesChamps: String;
begin
     Result
     :=
       'where                        '#13#10+
       '         nomclasse       = :nomclasse      '#13#10+
       '     and contexte        = :contexte       ';
end;

procedure TpoolG_BECPCTX.Charge_Contexte( _Contexte : Integer; slLoaded: TBatpro_StringList);
var
   SQL: String;
begin
     SQL
     :=
 'select          '
+'      *         '
+'from            '
+'    g_becpctx   '
+'where           '
+'     contexte = '+IntToStr( _Contexte)
       ;
     Load( SQL, slLoaded);
end;

procedure TpoolG_BECPCTX.Charge_Classe  ( _NomClasse: String; slLoaded: TBatpro_StringList);
var
   SQL: String;
begin
     exit; //##### MODIF PROVISOIRE POUR TESTER CHARGE_TOUT

     SQL
     :=
 'select                            '
+'      *                           '
+'from                              '
+'    g_becpctx                     '
+'where                             '
+'     nomclasse = "'+_NomClasse+'" '
       ;
     Load( SQL, slLoaded);
end;

procedure TpoolG_BECPCTX.Charge_Tout;
var
   SQL: String;
begin
     //uForms_ShowMessage('poolG_BECPCTX.Charge_Tout');
     SQL
     :=
 'select         '
+'      *        '
+'from           '
+'    g_becpctx  '
       ;
     Load( SQL);
end;

initialization
finalization
              TPool.class_Destroy( FpoolG_BECPCTX);
end.

