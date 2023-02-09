unit upoolFacture;
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
  ufAccueil_Erreur,
  uRequete,
{implementation_uses_key}

  udmDatabase,
  udmBatpro_DataModule,
  uPool,

  ublFacture,

    ublPiece,
    upoolPiece,
    ublFacture_Ligne,
    upoolFacture_Ligne,


  uhfFacture,
  SysUtils, Classes, DB, SqlDB;

type

 { TpoolFacture }

 TpoolFacture
 =
  class( TPool)
    procedure DataModuleCreate(Sender: TObject);  override;
  //Filtre
  public
    hfFacture: ThfFacture;
  //Accés général
  public
    function Get( _id: integer): TblFacture;
  //Nouveau
  public
    function Nouveau: TblFacture;
  //Accés par clé
  protected
    procedure To_Params( _Params: TParams); override;
  public
    Annee: Integer;
    NumeroDansAnnee: Integer;

    function Get_by_Cle( _Annee: Integer;  _NumeroDansAnnee: Integer): TblFacture;
    function Assure( _Annee: Integer;  _NumeroDansAnnee: Integer): TblFacture;
  //Indépendance par rapport au SGBD Informix ou MySQL
  protected
    function SQLWHERE_ContraintesChamps: String; override;
  //Méthode de création de test
  public
    function Test( _Annee: Integer;  _NumeroDansAnnee: Integer;  _Date: TDatetime;  _Client_id: Integer;  _Nom: String;  _NbHeures:  String;   _Montant: Double):Integer;

  //Chargement d'un Client
  public
    procedure Charge_Client( _Client_id: Integer; _slLoaded: TBatpro_StringList = nil);

  //Création d'itérateur
  protected
    class function Classe_Iterateur: TIterateur_Class; override;
  public
    function Iterateur: TIterateur_Facture;
    function Iterateur_Decroissant: TIterateur_Facture;
  //Nouveau numéro à partir de la détermination de la dernière facture
  public
    function MaxNumeroDansAnnee( _Annee: Integer=0): Integer;
    function Annee_Incoherente( _Annee: Integer=0): Boolean;
    function Annee_Incoherente_Message( _Annee: Integer=0): Boolean;
    function Nouveau_Numero( _Annee: Integer=0): Integer;
  end;

function poolFacture: TpoolFacture;

implementation



var
   FpoolFacture: TpoolFacture;

function poolFacture: TpoolFacture;
begin
     TPool.class_Get( Result, FpoolFacture, TpoolFacture);

     if nil = ublPiece_poolFacture
     then
         ublPiece_poolFacture:= Result;

     if nil = ublFacture_Ligne_poolFacture
     then
         ublFacture_Ligne_poolFacture:= Result;

end;

{ TpoolFacture }

procedure TpoolFacture.DataModuleCreate(Sender: TObject);
begin
     NomTable:= 'Facture';
     Classe_Elements:= TblFacture;
     Classe_Filtre:= ThfFacture;

     inherited;

     hfFacture:= hf as ThfFacture;
end;

function TpoolFacture.Get( _id: integer): TblFacture;
begin
     Get_Interne_from_id( _id, Result);
end;

function TpoolFacture.Nouveau: TblFacture;
var
   Annee: Word;
begin
     Result:= nil;
     Annee:= CurrentYear;
     if Annee_Incoherente_Message(Annee) then exit;

     Nouveau_Base( Result);
     Result.Annee          := Annee;
     Result.NumeroDansAnnee:= Nouveau_Numero( Result.Annee);
     Result.Save_to_database;
end;

function TpoolFacture.Get_by_Cle( _Annee: Integer;  _NumeroDansAnnee: Integer): TblFacture;
begin                               
     Annee:=  _Annee;
     NumeroDansAnnee:=  _NumeroDansAnnee;
     sCle:= TblFacture.sCle_from_( Annee, NumeroDansAnnee);
     Get_Interne( Result);       
end;                             


function TpoolFacture.Assure( _Annee: Integer;  _NumeroDansAnnee: Integer): TblFacture;
begin                               
     Result:= Get_by_Cle(  _Annee,  _NumeroDansAnnee);
     if Assigned( Result) then exit;

     Nouveau_Base( Result);                        
       Result.Annee          := _Annee        ;
       Result.NumeroDansAnnee:= _NumeroDansAnnee;
     Result.Save_to_database;
end;


procedure TpoolFacture.To_Params( _Params: TParams);
begin
     with _Params
     do
       begin
       ParamByName( 'Annee'    ).AsInteger:= Annee;
       ParamByName( 'NumeroDansAnnee'    ).AsInteger:= NumeroDansAnnee;
       end;
end;

function TpoolFacture.SQLWHERE_ContraintesChamps: String;
begin
     Result                                    
     :=                                        
       'where                        '#13#10+
       '         Annee           = :Annee          '#13#10+
       '     and NumeroDansAnnee = :NumeroDansAnnee';
end;

function TpoolFacture.Test( _Annee: Integer; _NumeroDansAnnee: Integer;
                            _Date: TDatetime;
                            _Client_id: Integer; _Nom: String;
                            _NbHeures: String;  _Montant: Double): Integer;
var                                                 
   bl: TblFacture;                          
begin                                               
     Nouveau_Base( bl);
       bl.Annee          := _Annee        ;
       bl.NumeroDansAnnee:= _NumeroDansAnnee;
       bl.Date           := _Date         ;
       bl.Client_id      := _Client_id    ;
       bl.Nom            := _Nom          ;
       bl.NbHeures       := _NbHeures     ;
       bl.Montant        := _Montant      ;
     bl.Save_to_database;                            
     Result:= bl.id;                                 
end;                                                 


procedure TpoolFacture.Charge_Client( _Client_id: Integer; _slLoaded: TBatpro_StringList = nil);
var
   SQL: String;
begin
     SQL:= 'select * from '+NomTable+' where Client_id = '+IntToStr( _Client_id);

     Load( SQL, _slLoaded);
end;


class function TpoolFacture.Classe_Iterateur: TIterateur_Class;
begin
     Result:= TIterateur_Facture;
end;

function TpoolFacture.Iterateur: TIterateur_Facture;
begin
     Result:= TIterateur_Facture( Iterateur_interne);
end;

function TpoolFacture.Iterateur_Decroissant: TIterateur_Facture;
begin
     Result:= TIterateur_Facture( Iterateur_interne_Decroissant);
end;

function TpoolFacture.MaxNumeroDansAnnee(_Annee: Integer=0): Integer;
var
   SQL: String;
begin
     if 0 = _Annee then _Annee:= CurrentYear;
     SQL
     :=
        'select                                          '+LineEnding
       +'      max(NumeroDansAnnee) as MaxNumeroDansAnnee'+LineEnding
       +'from                                            '+LineEnding
       +'    Facture                                     '+LineEnding
       +'where                                           '+LineEnding
       +'     Annee='+IntToStr(_Annee);
     if not Requete.Integer_from( SQL, 'MaxNumeroDansAnnee', Result)
     then
         Result:= -1;
end;

function TpoolFacture.Annee_Incoherente(_Annee: Integer=0): Boolean;
var
   Fin: Integer;
   I: Integer;
   bl: TblFacture;
begin
     Result:= False;
     Fin:= MaxNumeroDansAnnee( _Annee);
     for I:= Fin-1 downto 1
     do
       begin
       bl:= Get_by_Cle( _Annee, I);
       Result:= nil = bl;
       if Result then break;
       end;
end;

function TpoolFacture.Annee_Incoherente_Message( _Annee: Integer=0): Boolean;
begin
     Result:= Annee_Incoherente( _Annee);
     if Result
     then
         fAccueil_Erreur( 'Incohérence de numérotation pour l''année '+IntToStr(_Annee));

end;


function TpoolFacture.Nouveau_Numero( _Annee: Integer=0): Integer;
begin
     Result:= MaxNumeroDansAnnee( _Annee) + 1;
end;

initialization
finalization
              TPool.class_Destroy( FpoolFacture);
end.
