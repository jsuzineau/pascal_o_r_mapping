unit ublTiming;
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
    ufAccueil_Erreur,
    u_sys_,
    uuStrings,
    uBatpro_StringList,
    uChamp,

    uBatpro_Element,
    uBatpro_Ligne,

    udmDatabase,
    upool_Ancetre_Ancetre,
    upool,

//Aggregations_Pascal_ubl_uses_details_pas


    SysUtils, Classes, SqlDB, DB;

type
 TblTiming= class;
//pattern_aggregation_classe_declaration

 { TblTiming }

 TblTiming
 =
  class( TBatpro_Ligne)
  //Gestion du cycle de vie
  public
    constructor Create( _sl: TBatpro_StringList; _jsdc: TjsDataContexte; _pool: Tpool_Ancetre_Ancetre); override;
    destructor Destroy; override;
  //champs persistants
  public
    t: TDateTime;
  //Texte
  private
    FTexte_id: Integer;
    FTexte_bl: TBatpro_Ligne;
    FTexte: String;
    procedure SetTexte_bl(const Value: TBatpro_Ligne);
    procedure SetTexte_id(const Value: Integer);
    procedure Texte_id_Change;
    procedure Texte_Connecte;
    procedure Texte_Aggrege;
    procedure Texte_Desaggrege;
    procedure Texte_Change;
  public
    cTexte_id: TChamp;
    property Texte_id: Integer       read FTexte_id write SetTexte_id;
    property Texte_bl: TBatpro_Ligne read FTexte_bl write SetTexte_bl;
    function Texte: String;

  //Gestion de la clé
  public
//pattern_sCle_from__Declaration
    function sCle: String; override;
  //Gestion des déconnexions
  public
    procedure Unlink(be: TBatpro_Element); override;
  end;

 TIterateur_Timing
 =
  class( TIterateur)
  //Iterateur
  public
    procedure Suivant( out _Resultat: TblTiming);
    function  not_Suivant( out _Resultat: TblTiming): Boolean;
  end;

 TslTiming
 =
  class( TBatpro_StringList)
  //Gestion du cycle de vie
  public
    constructor Create( _Nom: String= ''); override;
    destructor Destroy; override;
  //Création d'itérateur
  protected
    class function Classe_Iterateur: TIterateur_Class; override;
  public
    function Iterateur: TIterateur_Timing;
    function Iterateur_Decroissant: TIterateur_Timing;
  end;

function blTiming_from_sl( sl: TBatpro_StringList; Index: Integer): TblTiming;
function blTiming_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TblTiming;

var
   ublTiming_poolTexte: TPool = nil;


implementation

function blTiming_from_sl( sl: TBatpro_StringList; Index: Integer): TblTiming;
begin
     _Classe_from_sl( Result, TblTiming, sl, Index);
end;

function blTiming_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TblTiming;
begin
     _Classe_from_sl_sCle( Result, TblTiming, sl, sCle);
end;

{ TIterateur_Timing }

function TIterateur_Timing.not_Suivant( out _Resultat: TblTiming): Boolean;
begin
     Result:= not_Suivant_interne( _Resultat);
end;

procedure TIterateur_Timing.Suivant( out _Resultat: TblTiming);
begin
     Suivant_interne( _Resultat);
end;

{ TslTiming }

constructor TslTiming.Create( _Nom: String= '');
begin
     inherited CreateE( _Nom, TblTiming);
end;

destructor TslTiming.Destroy;
begin
     inherited;
end;

class function TslTiming.Classe_Iterateur: TIterateur_Class;
begin
     Result:= TIterateur_Timing;
end;

function TslTiming.Iterateur: TIterateur_Timing;
begin
     Result:= TIterateur_Timing( Iterateur_interne);
end;

function TslTiming.Iterateur_Decroissant: TIterateur_Timing;
begin
     Result:= TIterateur_Timing( Iterateur_interne_Decroissant);
end;

//pattern_aggregation_classe_implementation

{ TblTiming }

constructor TblTiming.Create( _sl: TBatpro_StringList; _jsdc: TjsDataContexte; _pool: Tpool_Ancetre_Ancetre);
var
   CP: IblG_BECP;
begin
     CP:= Init_ClassParams;
     if Assigned( CP)
     then
         begin
         CP.Libelle:= 'Timing';
         CP.Font.Name:= sys_Times_New_Roman;
         CP.Font.Size:= 12;
         end;

     inherited;

     Champs.ChampDefinitions.NomTable:= 'Timing';

     //champs persistants
     DateTime_from_       ( t      , 't'      );


     FTexte_bl:= nil;
     cTexte_id:= Integer_from_Integer( FTexte_id, 'Texte_id');
     Champs.String_Lookup( FTexte, 'Texte', cTexte_id, @ublTiming_poolTexte.GetLookupListItems, '');
     Texte_id_Change;
     cTexte_id.OnChange.Abonne( Self, @Texte_id_Change);


end;

destructor TblTiming.Destroy;
begin

     inherited;
end;

//pattern_sCle_from__Implementation

function TblTiming.sCle: String;
begin
     Result:= sCle_ID;
end;

procedure TblTiming.Unlink( be: TBatpro_Element);
begin
     inherited Unlink( be);
     if Texte_bl = be then Texte_Desaggrege;

end;


//pattern_aggregation_accesseurs_implementation

procedure TblTiming.SetTexte_id(const Value: Integer);
begin
     if FTexte_id = Value then exit;
     FTexte_id:= Value;
     Texte_id_Change;
     Save_to_database;
end;

procedure TblTiming.Texte_id_Change;
begin
     Texte_Aggrege;
end;

procedure TblTiming.SetTexte_bl(const Value: TBatpro_Ligne);
begin
     if FTexte_bl = Value then exit;

     Texte_Desaggrege;

     FTexte_bl:= Value;

     if Texte_id <> FTexte_bl.id
     then
         begin
         Texte_id:= FTexte_bl.id;
         Save_to_database;
         end;

     Texte_Connecte;
end;

procedure TblTiming.Texte_Connecte;
begin
     if nil = Texte_bl then exit;

     if Assigned(Texte_bl) 
     then 
         Texte_bl.Aggregations.by_Name[ 'Timing'].Ajoute(Self);
     Connect_To( FTexte_bl);
end;

procedure TblTiming.Texte_Aggrege;
var
   Texte_bl_New: TBatpro_Ligne;
begin                                                        
     ublTiming_poolTexte.Get_Interne_from_id( Texte_id, Texte_bl_New);
     if Texte_bl = Texte_bl_New then exit;

     Texte_Desaggrege;
     FTexte_bl:= Texte_bl_New;

     Texte_Connecte;
end;

procedure TblTiming.Texte_Desaggrege;
begin
     if Texte_bl = nil then exit;

     if Assigned(Texte_bl) 
     then 
         Texte_bl.Aggregations.by_Name[ 'Timing'].Enleve(Self);
     Unconnect_To( FTexte_bl);
end;

procedure TblTiming.Texte_Change;
begin
     if Assigned( FTexte_bl)
     then
         FTexte:= FTexte_bl.GetLibelle
     else
         FTexte:= '';
end;

function TblTiming.Texte: String;
begin
     if Assigned( FTexte_bl)
     then
         Result:= FTexte_bl.GetLibelle
     else
         Result:= '';
end;

 

initialization
finalization
end.


