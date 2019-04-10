unit uAngular_TypeScript_ApplicationHandler;
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            http://www.mars42.com                          |
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
    uuStrings,
    uGenerateur_de_code_Ancetre,
    uBatpro_StringList,
    uContexteClasse,
    uPatternHandler,
    SysUtils, Classes;

type

 { TAngular_TypeScript_ApplicationHandler }

 TAngular_TypeScript_ApplicationHandler
 =
  class
  //Gestion du cycle de vie
  public
    constructor Create( _g: TGenerateur_de_code_Ancetre);
    destructor Destroy; override;
  //Attributs
  private
    g: TGenerateur_de_code_Ancetre;
    APP_MODULE_TS        : TPatternHandler;
    APP_ROUTING_MODULE_TS: TPatternHandler;
  public
    sAPP_MODULE_TS_IMPORT_LIST : String;
    sAPP_MODULE_TS_DECLARATIONS: String;

    sAPP_ROUTING_MODULE_TS_IMPORT_LIST: String;
    sAPP_ROUTING_MODULE_TS_ROUTES: String;

    slParametres: TBatpro_StringList;
    procedure Init;
    procedure Add( _cc: TContexteClasse; IsRelation: Boolean);
    procedure Produit;
  end;

implementation

const
     s_APP_MODULE_TS_IMPORT_LIST_Key = '//APP_MODULE_TS_IMPORT_LIST';
     s_APP_MODULE_TS_DECLARATIONS_Key= '//APP_MODULE_TS_DECLARATIONS';

     s_APP_ROUTING_MODULE_TS_IMPORT_LIST_Key= '//APP_ROUTING_MODULE_TS_IMPORT_LIST';
     s_APP_ROUTING_MODULE_TS_ROUTES_Key     = '//APP_ROUTING_MODULE_TS_ROUTES';

{ TAngular_TypeScript_ApplicationHandler }

constructor TAngular_TypeScript_ApplicationHandler.Create( _g: TGenerateur_de_code_Ancetre);
begin
     g:= _g;

     slParametres:= TBatpro_StringList.Create;
     APP_MODULE_TS        :=TPatternHandler.Create( g, s_RepertoireAngular_TypeScript+'app.module.ts'        ,slParametres);
     APP_ROUTING_MODULE_TS:=TPatternHandler.Create( g, s_RepertoireAngular_TypeScript+'app-routing.module.ts',slParametres);
     Init;
end;

destructor TAngular_TypeScript_ApplicationHandler.Destroy;
begin
     FreeAndNil( APP_MODULE_TS        );
     FreeAndNil( APP_ROUTING_MODULE_TS);
     FreeAndNil( slParametres);
     inherited;
end;

procedure TAngular_TypeScript_ApplicationHandler.Init;
begin
     sAPP_MODULE_TS_IMPORT_LIST := '';
     sAPP_MODULE_TS_DECLARATIONS:= '';

     sAPP_ROUTING_MODULE_TS_IMPORT_LIST:= '';
     sAPP_ROUTING_MODULE_TS_ROUTES     := '';
end;

procedure TAngular_TypeScript_ApplicationHandler.Add( _cc: TContexteClasse; IsRelation: Boolean);
     procedure Traite_import_list( var _import_list: String);
     begin
          // cl component list Liste de lignes
          Formate_Liste
           (
           _import_list,
           #13#10,
           'import { Tcl'+_cc.Nom_de_la_classe+'} from ''./01_Elements/'+_cc.Nom_de_la_classe+'/ucl'+_cc.Nom_de_la_classe+''';'
           );
          //c component Détail
          Formate_Liste
           (
           _import_list,
           #13#10,
           'import { Tc'+_cc.Nom_de_la_classe+'} from ''./01_Elements/'+_cc.Nom_de_la_classe+'/uc'+_cc.Nom_de_la_classe+''';'
           );
     end;
begin
     //APP_MODULE_TS
     Traite_import_list( sAPP_MODULE_TS_IMPORT_LIST);
     //cl
     Formate_Liste
      (
      sAPP_MODULE_TS_DECLARATIONS,
      #13#10'    ',
      'Tcl'+_cc.Nom_de_la_classe+','
      );
     //c
     Formate_Liste
      (
      sAPP_MODULE_TS_DECLARATIONS,
      #13#10'    ',
      'Tc'+_cc.Nom_de_la_classe+','
      );

     //APP_ROUTING_MODULE_TS
     Traite_import_list( sAPP_ROUTING_MODULE_TS_IMPORT_LIST);
     //cl
     Formate_Liste
      (
      sAPP_ROUTING_MODULE_TS_ROUTES,
      #13#10'    ',
      '{ path: '''+_cc.Nom_de_la_classe+'s''   , component: Tcl'+_cc.Nom_de_la_classe+'},'
      );
     //c
     Formate_Liste
      (
      sAPP_ROUTING_MODULE_TS_ROUTES,
      #13#10'    ',
      '{ path: '''+_cc.Nom_de_la_classe+'''   , component: Tc'+_cc.Nom_de_la_classe+'},'
      );
end;

procedure TAngular_TypeScript_ApplicationHandler.Produit;
   procedure Finalise( var _sListe: String; _Terminateur: String);
   begin
        if _sListe <> '' then _sListe:= _sListe+_Terminateur;
   end;
begin
     //Finalisation
     Finalise( sAPP_MODULE_TS_IMPORT_LIST        , #13#10      );
     Finalise( sAPP_MODULE_TS_DECLARATIONS       , #13#10'    ');

     Finalise( sAPP_ROUTING_MODULE_TS_IMPORT_LIST, #13#10      );
     Finalise( sAPP_ROUTING_MODULE_TS_ROUTES     , #13#10'    ');

     //Paramètres
     slParametres.Clear;

     slParametres.Values[s_APP_MODULE_TS_IMPORT_LIST_Key ]:= sAPP_MODULE_TS_IMPORT_LIST;
     slParametres.Values[s_APP_MODULE_TS_DECLARATIONS_Key]:= sAPP_MODULE_TS_DECLARATIONS;

     slParametres.Values[s_APP_ROUTING_MODULE_TS_IMPORT_LIST_Key]:= sAPP_ROUTING_MODULE_TS_IMPORT_LIST;
     slParametres.Values[s_APP_ROUTING_MODULE_TS_ROUTES_Key     ]:= sAPP_ROUTING_MODULE_TS_ROUTES     ;

     //Production
     APP_MODULE_TS        .Produit;
     APP_ROUTING_MODULE_TS.Produit;
end;

end.
