unit upoolAnnee;
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

  udmDatabase,
  udmBatpro_DataModule,
  uPool,

  ublAnnee,

    ublMois,
    upoolMois,


  uhfAnnee,
  SysUtils, Classes, DB, SqlDB;

type

 { TpoolAnnee }

 TpoolAnnee
 =
  class( TPool)
    procedure DataModuleCreate(Sender: TObject);  override;
  //Filtre
  public
    hfAnnee: ThfAnnee;
  //Accés général
  public
    function Get( _id: integer): TblAnnee;
  //Nouveau
  public
    function Nouveau: TblAnnee;
  //Accés par clé
  protected
    procedure To_Params( _Params: TParams); override;
  public
    Annee: Integer;

    function Get_by_Cle( _Annee: Integer): TblAnnee;
    function Assure( _Annee: Integer): TblAnnee;
  //Indépendance par rapport au SGBD Informix ou MySQL
  protected
    function SQLWHERE_ContraintesChamps: String; override;
  //Méthode de création de test
  public
    function Test( _Annee: Integer;  _Declare: Double):Integer;

//Details_Pascal_upool_charge_detail_declaration_pas
  //Création d'itérateur
  protected
    class function Classe_Iterateur: TIterateur_Class; override;
  public
    function Iterateur: TIterateur_Annee;
    function Iterateur_Decroissant: TIterateur_Annee;
  end;

function poolAnnee: TpoolAnnee;

implementation



var
   FpoolAnnee: TpoolAnnee;

function poolAnnee: TpoolAnnee;
begin
     TPool.class_Get( Result, FpoolAnnee, TpoolAnnee);

     if nil = ublMois_poolAnnee
     then
         ublMois_poolAnnee:= Result;

end;

{ TpoolAnnee }

procedure TpoolAnnee.DataModuleCreate(Sender: TObject);
begin
     NomTable:= 'Annee';
     Classe_Elements:= TblAnnee;
     Classe_Filtre:= ThfAnnee;

     inherited;

     hfAnnee:= hf as ThfAnnee;
end;

function TpoolAnnee.Get( _id: integer): TblAnnee;
begin
     Get_Interne_from_id( _id, Result);
end;

function TpoolAnnee.Nouveau: TblAnnee;
begin
     Nouveau_Base( Result);
end;

function TpoolAnnee.Get_by_Cle( _Annee: Integer): TblAnnee;
begin                               
     Annee:=  _Annee;
     sCle:= TblAnnee.sCle_from_( Annee);
     Get_Interne( Result);       
end;                             


function TpoolAnnee.Assure( _Annee: Integer): TblAnnee;
begin                               
     Result:= Get_by_Cle(  _Annee);
     if Assigned( Result) then exit;

     Nouveau_Base( Result);                        
       Result.Annee          := _Annee        ;
     Result.Save_to_database;
end;


procedure TpoolAnnee.To_Params( _Params: TParams);
begin
     with _Params
     do
       begin
       ParamByName( 'Annee'    ).AsInteger:= Annee;
       end;
end;

function TpoolAnnee.SQLWHERE_ContraintesChamps: String;
begin
     Result                                    
     :=                                        
       'where                        '#13#10+
       '         Annee           = :Annee          ';
end;

function TpoolAnnee.Test( _Annee: Integer;  _Declare: Double):Integer;
var                                                 
   bl: TblAnnee;                          
begin                                               
          Nouveau_Base( bl);                        
       bl.Annee          := _Annee        ;
       bl.Declare        := _Declare      ;
     bl.Save_to_database;                            
     Result:= bl.id;                                 
end;                                                 


//Details_Pascal_upool_charge_detail_implementation_pas

class function TpoolAnnee.Classe_Iterateur: TIterateur_Class;
begin
     Result:= TIterateur_Annee;
end;

function TpoolAnnee.Iterateur: TIterateur_Annee;
begin
     Result:= TIterateur_Annee( Iterateur_interne);
end;

function TpoolAnnee.Iterateur_Decroissant: TIterateur_Annee;
begin
     Result:= TIterateur_Annee( Iterateur_interne_Decroissant);
end;

initialization
finalization
              TPool.class_Destroy( FpoolAnnee);
end.
