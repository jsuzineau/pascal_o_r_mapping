unit uOD_Niveau;
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
    uBatpro_StringList,
    uuStrings,
    uChamps,
    uChamp,
    uChampDefinition,
    uBatpro_Element,
    uBatpro_Ligne,
    uhAggregation,
    uOOoStrings,
    uOpenDocument,
    uOD_Champ,
    uOD_BatproTextTableContext,
    uOD_Styles,
  SysUtils, Classes, DB;

type
 TOD_Niveau
 =
  class
  //Gestion du cycle de vie
  public
    constructor Create( _Nom_Aggregation: String);
    destructor Destroy; override;
  //Attributs
  public
    Avant_Composition, Apres_Composition: String;
    Avant_TriggerField, Apres_TriggerField: String;
    Avant, Apres: TOD_Champ_array;
    OD_Styles: TOD_Styles;
  //Gestion de l'aggrégation
  private
    sl: TBatpro_StringList;
    bl_Courant: TBatpro_Ligne;
    Champs_Courant: TChamps;
    procedure Courant_from( Index: Integer);
  public
    Nom_Aggregation: String;
    procedure Charge_sl( _sl: TBatpro_StringList);
    procedure Charge_ha( _ha: ThAggregation);
    procedure Charge( _bl: TBatpro_Ligne);
    function IsEmpty: Boolean;
    function Count: Integer;
    function Go_to( Index: Integer): TBatpro_Ligne;
  //Méthodes
  public
    procedure Ajoute_Column_Avant( _FieldIndex, _Debut, _Fin: Integer); overload;
    procedure Ajoute_Column_Apres( _FieldIndex, _Debut, _Fin: Integer); overload;
    procedure Ajoute_Column_Avant( _FieldName: String; _Debut, _Fin: Integer); overload;
    procedure Ajoute_Column_Apres( _FieldName: String; _Debut, _Fin: Integer); overload;
    procedure Ajoute_Tout_Avant;
    procedure Ajoute_Tout_Apres;
  //Nom
  public
    function Nom: String;
  //Persistance dans le document OpenOffice
  private
    function Nom_Avant( Prefixe: String): String;
    function Nom_Apres( Prefixe: String): String;
    function Nom_Composition( Prefixe: String): String;
    function Nom_TriggerField( Prefixe: String): String;
  public
    procedure Assure_Modele( Prefixe: String; C: TOD_BatproTextTableContext);
    procedure to_Doc( Prefixe: String; C: TOD_BatproTextTableContext);
    procedure from_Doc( Prefixe: String; C: TOD_BatproTextTableContext);
  //Gestion des gachettes
  private
    function Triggered( TriggerField: String): Boolean;
  public
    function Avant_Triggered: Boolean;
    function Apres_Triggered: Boolean;
  //Sous-niveau
  public
    SousNiveau: TOD_Niveau;
  end;

 TOD_Niveau_array= array of TOD_Niveau;

implementation

{ TOD_Niveau }

constructor TOD_Niveau.Create( _Nom_Aggregation: String);
begin
     Nom_Aggregation:= _Nom_Aggregation;

     Avant_Composition:= '';
     Apres_Composition:= '';
     Avant_TriggerField:= '';
     Apres_TriggerField:= '';
     OD_Styles:= nil;

     sl            := nil;
     bl_Courant    := nil;
     Champs_Courant:= nil;
     SousNiveau:= nil;
end;

destructor TOD_Niveau.Destroy;
begin

end;

procedure TOD_Niveau.Ajoute_Column_Avant( _FieldName: String;
                                          _Debut, _Fin: Integer);
var
   C: TOD_Champ;
begin
     C:= TOD_Champ.Create( _FieldName, _Debut, _Fin);
     SetLength( Avant, Length( Avant)+1);
     Avant[High(Avant)]:= C;

     Formate_Liste( Avant_Composition, ',', _FieldName);
end;

procedure TOD_Niveau.Ajoute_Column_Avant( _FieldIndex, _Debut, _Fin: Integer);
var
   FieldName: String;
begin
     if Champs_Courant = nil then exit;

     FieldName:= Champs_Courant.Field_from_Index( _FieldIndex);
     Ajoute_Column_Avant( FieldName, _Debut, _Fin);
end;

procedure TOD_Niveau.Ajoute_Column_Apres( _FieldName: String;
                                          _Debut, _Fin: Integer);
var
   C: TOD_Champ;
begin
     C:= TOD_Champ.Create( _FieldName, _Debut, _Fin);
     SetLength( Apres, Length( Apres)+1);
     Apres[High(Apres)]:= C;

     Formate_Liste( Apres_Composition, ',', _FieldName);
end;

procedure TOD_Niveau.Ajoute_Column_Apres( _FieldIndex, _Debut, _Fin: Integer);
var
   Champ: TChamp;
   FieldName: String;
begin
     if Champs_Courant = nil then exit;

     Champ:= Champs_Courant.Champ_from_Index( _FieldIndex);
     if Champ = nil then exit;

     FieldName:= Champ.Definition.Nom;
     Ajoute_Column_Apres( FieldName, _Debut, _Fin);
end;

procedure TOD_Niveau.Ajoute_Tout_Avant;
var
   I: Integer;
begin
     if Champs_Courant = nil then exit;

     //Champs_Courant.Liste;
     for I:= 0 to Champs_Courant.Count - 1
     do
       Ajoute_Column_Avant( I, 0, 0);
end;

procedure TOD_Niveau.Ajoute_Tout_Apres;
var
   I: Integer;
begin
     if Champs_Courant = nil then exit;

     for I:= 0 to Champs_Courant.Count - 1
     do
       Ajoute_Column_Apres( I, 0, 0);
end;

function TOD_Niveau.Nom: String;
begin
     Result:= Nom_Aggregation;
end;

function TOD_Niveau.Nom_Avant(Prefixe: String): String;
begin
     Result:= Prefixe+'Avant';
end;

function TOD_Niveau.Nom_Apres(Prefixe: String): String;
begin
     Result:= Prefixe+'Apres';
end;

function TOD_Niveau.Nom_Composition(Prefixe: String): String;
begin
     Result:= Prefixe+'Composition';
end;

function TOD_Niveau.Nom_TriggerField(Prefixe: String): String;
begin
     Result:= Prefixe+'TriggerField';
end;

procedure TOD_Niveau.Assure_Modele( Prefixe: String; C: TOD_BatproTextTableContext);
var
   p: String;
   pav, pap: String;
   I: Integer;
begin
     p:= Prefixe+Nom+'_';
     pav:= Nom_Avant( p)+'_';
     pap:= Nom_Apres( p)+'_';
     C.Assure_Parametre( Nom_Composition( pav), Avant_Composition);
     C.Assure_Parametre( Nom_Composition( pap), Apres_Composition);
     C.Assure_Parametre( Nom_TriggerField( pav), Avant_TriggerField);
     C.Assure_Parametre( Nom_TriggerField( pap), Apres_TriggerField);
     for I:= Low( Avant) to High( Avant) do Avant[I].Assure_Modele( pav, C);
     for I:= Low( Apres) to High( Apres) do Apres[I].Assure_Modele( pap, C);
end;

procedure TOD_Niveau.to_Doc( Prefixe: String; C: TOD_BatproTextTableContext);
var
   p: String;
   pav, pap: String;
   I: Integer;
begin
     p:= Prefixe+Nom+'_';
     pav:= Nom_Avant( p)+'_';
     pap:= Nom_Apres( p)+'_';
     C.Ecrire( Nom_Composition( pav), Avant_Composition);
     C.Ecrire( Nom_Composition( pap), Apres_Composition);
     C.Ecrire( Nom_TriggerField( pav), Avant_TriggerField);
     C.Ecrire( Nom_TriggerField( pap), Apres_TriggerField);
     for I:= Low( Avant) to High( Avant) do Avant[I].to_Doc( pav, C);
     for I:= Low( Apres) to High( Apres) do Apres[I].to_Doc( pap, C);
end;

procedure TOD_Niveau.from_Doc( Prefixe: String; C: TOD_BatproTextTableContext);
var
   p: String;
   pav, pap: String;
   procedure Traite( pa: String; var Composition, TriggerField: String; var a: TOD_Champ_array);
   var
      I: Integer;
      FieldName: String;
      Champ: TChamp;
      ODC: TOD_Champ;
   begin
        Composition:= C.Lire( Nom_Composition( pa));
        TriggerField    := C.Lire( Nom_TriggerField    ( pa));
        for I:= Low( A) to High( A) do FreeAndNil( A[I]);
        SetLength( A, 0);

        if Assigned( Champs_Courant)
        then
            while Composition <> ''
            do
              begin
              FieldName:= StrToK( ',', Composition);

              Champ:= Champs_Courant.Champ_from_Field( FieldName);
              if Assigned( Champ)
              then
                  begin
                  SetLength( A, Length(A)+1);
                  ODC:= TOD_Champ.Create( FieldName, 0, 0);
                  ODC.from_Doc( pa, C);
                  A[High(A)]:= ODC;
                  end;
              end;
   end;

begin
     p:= Prefixe+Nom+'_';
     pav:= Nom_Avant( p)+'_';
     pap:= Nom_Apres( p)+'_';
     Traite( pav, Avant_Composition, Avant_TriggerField, Avant);
     Traite( pap, Apres_Composition, Apres_TriggerField, Apres);
end;

function TOD_Niveau.Triggered( TriggerField: String): Boolean;
var
   Champ: TChamp;
begin
     Result:= TriggerField = sys_Vide;
     if Result then exit;

     if Champs_Courant = nil then exit;

     Champ:= Champs_Courant.Champ_from_Field( TriggerField);
     if Champ = nil then exit;

     Result:= Champ.Chaine <> sys_Vide;
end;

function TOD_Niveau.Avant_Triggered: Boolean;
begin
     Result:= Triggered( Avant_TriggerField);
end;

function TOD_Niveau.Apres_Triggered: Boolean;
begin
     Result:= Triggered( Apres_TriggerField);
end;

procedure TOD_Niveau.Courant_from( Index: Integer);
begin
     bl_Courant:= Batpro_Ligne_from_sl( sl, Index);
     if bl_Courant = nil
     then
         Champs_Courant:= nil
     else
         begin
         Champs_Courant:= bl_Courant.Champs;
         if Assigned( SousNiveau)
         then
             SousNiveau.Charge( bl_Courant);
         end;
end;

procedure TOD_Niveau.Charge_sl( _sl: TBatpro_StringList);
begin
     sl:= _sl;
     Courant_from( 0);
end;

procedure TOD_Niveau.Charge_ha( _ha: ThAggregation);
begin
     if _ha = nil then exit;
     _ha.Charge;
     Charge_sl( _ha.sl);
end;

procedure TOD_Niveau.Charge( _bl: TBatpro_Ligne);
begin
     if _bl = nil then exit;
     
     Charge_ha( _bl.Aggregations[ Nom_Aggregation]);
end;

function TOD_Niveau.IsEmpty: Boolean;
begin
     Result
     :=
          (sl = nil    )
       or (sl.Count = 0);
end;

function TOD_Niveau.Count: Integer;
begin
     if sl = nil
     then
         Result:= 0
     else
         Result:= sl.Count;
end;

function TOD_Niveau.Go_to( Index: Integer): TBatpro_Ligne;
begin
     Courant_from( Index);
     Result:= bl_Courant;
end;

end.
