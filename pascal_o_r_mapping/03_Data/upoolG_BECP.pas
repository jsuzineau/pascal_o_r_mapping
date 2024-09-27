unit upoolG_BECP;
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
    ubtString,
    uBatpro_StringList,
    u_sys_,

    uBatpro_Element,
    ublG_BECP,

    udmBatpro_DataModule,
    uPool,

    uhfG_BECP,

  SysUtils, Classes,
  FMTBcd, BufDataset, DB, SQLDB;

type
 TpoolG_BECP
 =
  class( TPool)
    procedure DataModuleCreate(Sender: TObject);  override;
  //Filtre
  public
    hfG_BECP: ThfG_BECP;
  //Accés général
  public
    function Get( _id: integer): TblG_BECP;
  //Gestion de la clé
  protected
    nomclasse: String;

    procedure To_Params( _Params: TParams); override;
  public
    function Get_by_Cle( _nomclasse: String): TblG_BECP;
  //Gestion de l'insertion
  protected
    function SQL_INSERT: String; override;
  //Indépendance par rapport au SGBD Informix ou MySQL
  protected
    function SQLWHERE_ContraintesChamps: String; override;
  //Interface pour uBatpro_Element
  private
    function Cree( _NomClasse: String): IblG_BECP;
    function Get_btsCle: TbtString;
    function Get_T: TBatpro_StringList;
  end;

function poolG_BECP: TpoolG_BECP;

var
   blClasse_TBatpro_Element: TblG_BECP= nil;
   blClasse_TblG_BECP      : TblG_BECP= nil;
   blClasse_TblG_BECPCTX   : TblG_BECP= nil;

implementation

uses
    uClean,
{implementation_uses_key}
    udmDatabase;

var
   FpoolG_BECP: TpoolG_BECP;

function poolG_BECP: TpoolG_BECP;
begin
     TPool.class_Get( Result, FpoolG_BECP, TpoolG_BECP);
end;

procedure Cree_blG_BECP_classe_speciale( NomClasse: String;
                                         var blG_BECP: TblG_BECP;
                                         Is_blClasse_TBatpro_Element: Boolean = False);
begin
     blG_BECP:= TblG_BECP.Create_New( NomClasse);
     blG_BECP.Is_blClasse_TBatpro_Element:= Is_blClasse_TBatpro_Element;
     //FpoolG_BECP.T.AddObject( NomClasse, blG_BECP)
end;

{ TpoolG_BECP }

procedure TpoolG_BECP.DataModuleCreate(Sender: TObject);
begin
     NomTable:= 'g_becp';
     Classe_Elements:= TblG_BECP;
     Classe_Filtre:= ThfG_BECP;

     inherited;

     Creer_si_non_trouve:= True;
     hfG_BECP:= hf as ThfG_BECP;
end;

function TpoolG_BECP.Get( _id: integer): TblG_BECP;
begin
     Get_Interne_from_id( _id, Result);
end;

function TpoolG_BECP.Get_by_Cle( _nomclasse: String): TblG_BECP;
begin
     Result:= blClasse_TBatpro_Element;
     if not dmDatabase.jsDataConnexion.Ouvert then exit;

     nomclasse:=  _nomclasse;
     sCle:= TblG_BECP.sCle_from_( nomclasse);
     Get_Interne( Result);
end;

function TpoolG_BECP.SQL_INSERT: String;
begin
     is_Base:= False;
     Result:= 'insert into g_becp (nomclasse) values (:nomclasse)';
end;

procedure TpoolG_BECP.To_Params( _Params: TParams);
begin
     inherited;
     with _Params
     do
       begin
       ParamByName( 'nomclasse'    ).AsString:= nomclasse;
       end;
end;

function TpoolG_BECP.SQLWHERE_ContraintesChamps: String;
begin
     Result
     :=
       'where                        '#13#10+
       '         nomclasse       = :nomclasse      ';
end;

function TpoolG_BECP.Cree( _NomClasse: String): IblG_BECP;
var
   bl: TblG_BECP;
begin
     Result:= nil;

     bl:= Get_by_Cle( _NomClasse);
     if bl = nil then exit;

     Result:= bl.asBECP;
     if bl.Libelle = sys_Vide
     then
         begin
         bl.Libelle:= _NomClasse;
         bl.Save_to_database;
         end;
end;

function TpoolG_BECP.Get_btsCle: TbtString;
begin
     Result:= btsCle;
end;

function TpoolG_BECP.Get_T: TBatpro_StringList;
begin
     Result:= slT;
end;

initialization
              TPool.class_Create( FpoolG_BECP, TpoolG_BECP, nil);
              uBatpro_Element.poolG_BECP_Cree            := FpoolG_BECP.Cree;
              uBatpro_Element.Batpro_ElementClassesParams:= FpoolG_BECP.Get_btsCle;

              Cree_blG_BECP_classe_speciale( sys_TBatpro_Element, blClasse_TBatpro_Element, True);
              Cree_blG_BECP_classe_speciale( sys_TblG_BECP      , blClasse_TblG_BECP      );
              Cree_blG_BECP_classe_speciale( sys_TblG_BECPCTX   , blClasse_TblG_BECPCTX   );

              Classe_TBatpro_Element:= blClasse_TBatpro_Element.asBECP;
              Classe_TblG_BECP      := blClasse_TblG_BECP      .asBECP;
              Classe_TblG_BECPCTX   := blClasse_TblG_BECPCTX   .asBECP;
finalization
              Free_nil( blClasse_TBatpro_Element);

              uBatpro_Element.Batpro_ElementClassesParams:= nil;
              uBatpro_Element.poolG_BECP_Cree:= nil;

              TPool.class_Destroy( FpoolG_BECP);
end.
