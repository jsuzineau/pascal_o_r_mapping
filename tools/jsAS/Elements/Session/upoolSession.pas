unit upoolSession;
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
{implementation_uses_key}

  ublSession,

  udmDatabase,
  udmBatpro_DataModule,
  uPool,
  

  uhfSession,
  SysUtils, Classes, DB, SqlDB;

type

 { TpoolSession }

 TpoolSession
 =
  class( TPool)
    procedure DataModuleCreate(Sender: TObject);  override;
  //Filtre
  public
    hfSession: ThfSession;
  //Accés général
  public
    function Get( _id: integer): TblSession;
  //Accés par clé
  protected
    procedure To_Params( _Params: TParams); override;
  public
    cookie_id: String;

    function Get_by_Cle( _cookie_id: String): TblSession;
    function Assure( _cookie_id: String): TblSession;
  //Indépendance par rapport au SGBD Informix ou MySQL
  protected
    function SQLWHERE_ContraintesChamps: String; override;
  //Méthode de création de test
  public
    function Test( _ApplicationKey: String;  _cookie_id: String;  _url: String):Integer;

  //Création d'itérateur
  protected
    class function Classe_Iterateur: TIterateur_Class; override;
  public
    function Iterateur: TIterateur_Session;
    function Iterateur_Decroissant: TIterateur_Session;
  end;

function poolSession: TpoolSession;

implementation



var
   FpoolSession: TpoolSession;

function poolSession: TpoolSession;
begin
     TPool.class_Get( Result, FpoolSession, TpoolSession);
end;

{ TpoolSession }

procedure TpoolSession.DataModuleCreate(Sender: TObject);
begin
     NomTable:= 'Session';
     Classe_Elements:= TblSession;
     Classe_Filtre:= ThfSession;

     inherited;

     hfSession:= hf as ThfSession;
end;

function TpoolSession.Get( _id: integer): TblSession;
begin
     Get_Interne_from_id( _id, Result);
end;

function TpoolSession.Get_by_Cle( _cookie_id: String): TblSession;
begin                               
     cookie_id:=  _cookie_id;
     sCle:= TblSession.sCle_from_( cookie_id);
     Get_Interne( Result);       
end;                             


function TpoolSession.Assure( _cookie_id: String): TblSession;
begin                               
     Result:= Get_by_Cle(  _cookie_id);
     if Assigned( Result) then exit;

     Nouveau_Base( Result);                        
       Result.cookie_id      := _cookie_id    ;
     Result.Save_to_database;
end;


procedure TpoolSession.To_Params( _Params: TParams);
begin
     inherited;
     with _Params
     do
       begin
       ParamByName( 'ApplicationKey'    ).AsString:= ApplicationKey;
       ParamByName( 'cookie_id'    ).AsString:= cookie_id;
       ParamByName( 'url'    ).AsString:= url;
       end;
end;

function TpoolSession.SQLWHERE_ContraintesChamps: String;
begin
     Result                                    
     :=                                        
       'where                        '#13#10+
       '         ApplicationKey  = :ApplicationKey '#13#10+
       '     and cookie_id       = :cookie_id      '#13#10+
       '     and url             = :url            ';
end;

function TpoolSession.Test( _ApplicationKey: String;  _cookie_id: String;  _url: String):Integer;
var                                                 
   bl: TblSession;                          
begin                                               
     Nouveau_Base( bl);                        
       bl.ApplicationKey := _ApplicationKey;
       bl.cookie_id      := _cookie_id    ;
       bl.url            := _url          ;
     bl.Save_to_database;                            
     Result:= bl.id;                                 
end;                                                 


class function TpoolSession.Classe_Iterateur: TIterateur_Class;
begin
     Result:= TIterateur_Session;
end;

function TpoolSession.Iterateur: TIterateur_Session;
begin
     Result:= TIterateur_Session( Iterateur_interne);
end;

function TpoolSession.Iterateur_Decroissant: TIterateur_Session;
begin
     Result:= TIterateur_Session( Iterateur_interne_Decroissant);
end;

initialization
finalization
              TPool.class_Destroy( FpoolSession);
end.
