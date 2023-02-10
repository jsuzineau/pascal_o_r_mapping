unit upoolMois;
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

  ublMois,

    ublFacture,


  uhfMois,
  SysUtils, Classes, DB, SqlDB;

type

 { TpoolMois }

 TpoolMois
 =
  class( TPool)
    procedure DataModuleCreate(Sender: TObject);  override;
  //Filtre
  public
    hfMois: ThfMois;
  //Accés général
  public
    function Get( _id: integer): TblMois;
  //Nouveau
  public
    function Nouveau: TblMois;
  //Accés par clé
  protected
    procedure To_Params( _Params: TParams); override;
  public
    Annee: Integer;
    Mois: Integer;

    function Get_by_Cle( _Annee: Integer;  _Mois: Integer): TblMois;
    function Assure( _Annee: Integer;  _Mois: Integer): TblMois;
  //Indépendance par rapport au SGBD Informix ou MySQL
  protected
    function SQLWHERE_ContraintesChamps: String; override;
  //Méthode de création de test
  public
    function Test( _Annee: Integer;  _Mois: Integer;  _Montant: Double;  _Declare: Double;  _URSSAF: Double):Integer;

  //Chargement d'une Annee
  public
    procedure Charge_Annee( _Annee: Integer; _slLoaded: TBatpro_StringList = nil);

  //Création d'itérateur
  protected
    class function Classe_Iterateur: TIterateur_Class; override;
  public
    function Iterateur: TIterateur_Mois;
    function Iterateur_Decroissant: TIterateur_Mois;
  end;

function poolMois: TpoolMois;

implementation



var
   FpoolMois: TpoolMois;

function poolMois: TpoolMois;
begin
     TPool.class_Get( Result, FpoolMois, TpoolMois);

     if nil = ublPiece_poolMois
     then
         ublPiece_poolMois:= Result;

end;

{ TpoolMois }

procedure TpoolMois.DataModuleCreate(Sender: TObject);
begin
     NomTable:= 'Mois';
     Classe_Elements:= TblMois;
     Classe_Filtre:= ThfMois;

     inherited;

     hfMois:= hf as ThfMois;
end;

function TpoolMois.Get( _id: integer): TblMois;
begin
     Get_Interne_from_id( _id, Result);
end;

function TpoolMois.Nouveau: TblMois;
begin
     Nouveau_Base( Result);
end;

function TpoolMois.Get_by_Cle( _Annee: Integer;  _Mois: Integer): TblMois;
begin                               
     Annee:=  _Annee;
     Mois:=  _Mois;
     sCle:= TblMois.sCle_from_( Annee, Mois);
     Get_Interne( Result);       
end;                             


function TpoolMois.Assure( _Annee: Integer;  _Mois: Integer): TblMois;
begin                               
     Result:= Get_by_Cle(  _Annee,  _Mois);
     if Assigned( Result) then exit;

     Nouveau_Base( Result);                        
       Result.Annee          := _Annee        ;
       Result.Mois           := _Mois         ;
     Result.Save_to_database;
end;


procedure TpoolMois.To_Params( _Params: TParams);
begin
     with _Params
     do
       begin
       ParamByName( 'Annee'    ).AsInteger:= Annee;
       ParamByName( 'Mois'    ).AsInteger:= Mois;
       end;
end;

function TpoolMois.SQLWHERE_ContraintesChamps: String;
begin
     Result                                    
     :=                                        
       'where                        '#13#10+
       '         Annee           = :Annee          '#13#10+
       '     and Mois            = :Mois           ';
end;

function TpoolMois.Test( _Annee: Integer;  _Mois: Integer;  _Montant: Double;  _Declare: Double;  _URSSAF: Double):Integer;
var                                                 
   bl: TblMois;                          
begin                                               
          Nouveau_Base( bl);                        
       bl.Annee          := _Annee        ;
       bl.Mois           := _Mois         ;
       bl.Montant        := _Montant      ;
       bl.Declare        := _Declare      ;
       bl.URSSAF         := _URSSAF       ;
     bl.Save_to_database;                            
     Result:= bl.id;                                 
end;                                                 


procedure TpoolMois.Charge_Annee( _Annee: Integer; _slLoaded: TBatpro_StringList = nil);
var
   SQL: String;
begin
     SQL:= 'select * from '+NomTable+' where Annee = '+IntToStr( _Annee);

     Load( SQL, _slLoaded);
end;


class function TpoolMois.Classe_Iterateur: TIterateur_Class;
begin
     Result:= TIterateur_Mois;
end;

function TpoolMois.Iterateur: TIterateur_Mois;
begin
     Result:= TIterateur_Mois( Iterateur_interne);
end;

function TpoolMois.Iterateur_Decroissant: TIterateur_Mois;
begin
     Result:= TIterateur_Mois( Iterateur_interne_Decroissant);
end;

initialization
finalization
              TPool.class_Destroy( FpoolMois);
end.
