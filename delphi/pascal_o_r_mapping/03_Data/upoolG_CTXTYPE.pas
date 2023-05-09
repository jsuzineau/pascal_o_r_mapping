unit upoolG_CTXTYPE;
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
    ublG_CTXTYPE,

    udmBatpro_DataModule,
    uPool,

    uhfG_CTXTYPE,

  SysUtils, Classes,
  FMTBcd, Provider, DBClient, DB, SqlExpr;

type

 { TpoolG_CTXTYPE }

 TpoolG_CTXTYPE
 =
  class( TPool)
    procedure DataModuleCreate(Sender: TObject);  override;
    procedure DataModuleDestroy(Sender: TObject);  override;
  private
    { Déclarations privées }
  protected
    { Déclarations protégées }
  public
    { Déclarations publiques }
  //Filtre
  public
    hfG_CTXTYPE: ThfG_CTXTYPE;
  //Accés général
  public
    function Get( _id: integer): TblG_CTXTYPE;
  //Gestion de la clé
  protected
    contextetype: String;

    procedure To_Params( _Params: TParams); override;
  public
    function Get_by_Cle( _contextetype: String): TblG_CTXTYPE;
  //Indépendance par rapport au SGBD Informix ou MySQL
  protected
    function SQLWHERE_ContraintesChamps: String; override;
  end;

function poolG_CTXTYPE: TpoolG_CTXTYPE;

implementation

uses
    uClean,
{implementation_uses_key}
    udmDatabase;



var
   FpoolG_CTXTYPE: TpoolG_CTXTYPE;

function poolG_CTXTYPE: TpoolG_CTXTYPE;
begin
     TPool.class_Get( Result, FpoolG_CTXTYPE, TpoolG_CTXTYPE);
end;

{ TpoolG_CTXTYPE }

procedure TpoolG_CTXTYPE.DataModuleCreate(Sender: TObject);
begin
     NomTable:= 'g_ctxtype';
     Classe_Elements:= TblG_CTXTYPE;
     Classe_Filtre:= ThfG_CTXTYPE;

     inherited;

     hfG_CTXTYPE:= hf as ThfG_CTXTYPE;
end;

procedure TpoolG_CTXTYPE.DataModuleDestroy(Sender: TObject);
begin
     inherited;
end;

function TpoolG_CTXTYPE.Get( _id: integer): TblG_CTXTYPE;
begin
     Get_Interne_from_id( _id, Result);
end;

function TpoolG_CTXTYPE.Get_by_Cle( _contextetype: String): TblG_CTXTYPE;
begin                               
     contextetype:=  _contextetype;
     sCle:= TblG_CTXTYPE.sCle_from_( contextetype);
     Get_Interne( Result);       
end;                             


procedure TpoolG_CTXTYPE.To_Params( _Params: TParams);
begin
     inherited;
     with _Params
     do
       begin
       ParamByName( 'contextetype'    ).AsString:= contextetype;
       end;
end;

function TpoolG_CTXTYPE.SQLWHERE_ContraintesChamps: String;
begin
     Result
     :=
       'where                        '#13#10+
       '         contextetype    = :contextetype   ';
end;

initialization
finalization
              TPool.class_Destroy( FpoolG_CTXTYPE);
end.
