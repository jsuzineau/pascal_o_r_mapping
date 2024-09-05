unit upoolTexte;
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            http://www.mars42.com                                               |
                                                                                |
    Copyright 2024 Jean SUZINEAU - MARS42                                       |
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

  ublTexte,

    ublTiming,
    upoolTiming,


  uhfTexte,
  SysUtils, Classes, DB, SqlDB;

type

 { TpoolTexte }

 TpoolTexte
 =
  class( TPool)
    procedure DataModuleCreate(Sender: TObject);  override;
  //Filtre
  public
    hfTexte: ThfTexte;
  //Accés général
  public
    function Get( _id: integer): TblTexte;
  //Nouveau
  public
    function Nouveau: TblTexte;
  public
    function Assure( _id: integer): TblTexte;
  //Accés par clé
  protected
    procedure To_Params( _Params: TParams); override;
  public
//pattern_Declaration_cle
//pattern_Get_by_Cle_Declaration
//pattern_Assure_Declaration
  //Indépendance par rapport au SGBD Informix ou MySQL
  protected
    function SQLWHERE_ContraintesChamps: String; override;
  //Méthode de création de test
  public
    function Test( _Cyrillique: String;  _Translitteration: String;  _Francais: String):Integer;

//Details_Pascal_upool_charge_detail_declaration_pas
  //Création d'itérateur
  protected
    class function Classe_Iterateur: TIterateur_Class; override;
  public
    function Iterateur: TIterateur_Texte;
    function Iterateur_Decroissant: TIterateur_Texte;
  end;

function poolTexte: TpoolTexte;

implementation



var
   FpoolTexte: TpoolTexte;

function poolTexte: TpoolTexte;
begin
     TPool.class_Get( Result, FpoolTexte, TpoolTexte);

     if nil = ublTiming_poolTexte
     then
         ublTiming_poolTexte:= Result;

end;

{ TpoolTexte }

procedure TpoolTexte.DataModuleCreate(Sender: TObject);
begin
     NomTable:= 'Texte';
     Classe_Elements:= TblTexte;
     Classe_Filtre:= ThfTexte;

     inherited;

     hfTexte:= hf as ThfTexte;
end;

function TpoolTexte.Get( _id: integer): TblTexte;
begin
     Get_Interne_from_id( _id, Result);
end;

function TpoolTexte.Nouveau: TblTexte;
begin
     Nouveau_Base( Result);
end;

function TpoolTexte.Assure( _id: integer): TblTexte;
begin
     Get_Interne_from_id( _id, Result);
     if nil = Result
     then
         begin
         Result:= Nouveau;
         Result.Champs.cID.asInteger:= _id;
         end;
end;

//pattern_Get_by_Cle_Implementation

//pattern_Assure_Implementation

procedure TpoolTexte.To_Params( _Params: TParams);
begin
     with _Params
     do
       begin
//pattern_To_SQLQuery_Params_Body
       end;
end;

function TpoolTexte.SQLWHERE_ContraintesChamps: String;
begin
//pattern_SQLWHERE_ContraintesChamps_Body
end;

function TpoolTexte.Test( _Cyrillique: String;  _Translitteration: String;  _Francais: String):Integer;
var                                                 
   bl: TblTexte;                          
begin                                               
          Nouveau_Base( bl);                        
       bl.Cyrillique     := _Cyrillique   ;
       bl.Translitteration:= _Translitteration;
       bl.Francais       := _Francais     ;
     bl.Save_to_database;                            
     Result:= bl.id;                                 
end;                                                 


//Details_Pascal_upool_charge_detail_implementation_pas

class function TpoolTexte.Classe_Iterateur: TIterateur_Class;
begin
     Result:= TIterateur_Texte;
end;

function TpoolTexte.Iterateur: TIterateur_Texte;
begin
     Result:= TIterateur_Texte( Iterateur_interne);
end;

function TpoolTexte.Iterateur_Decroissant: TIterateur_Texte;
begin
     Result:= TIterateur_Texte( Iterateur_interne_Decroissant);
end;

initialization
finalization
              TPool.class_Destroy( FpoolTexte);
end.
