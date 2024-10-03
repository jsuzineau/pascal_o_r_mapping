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
    uOOoStrings,
    uOpenDocument,
    uOD_Champ,
    uOD_BatproTextTableContext,
    uOD_Styles,
    uOD_Dataset_Columns,//pour Assure_FieldName_in_Composition
  SysUtils, Classes, DB;

type
 TOD_Niveau= class;

 { TOD_Niveau_set }

 TOD_Niveau_set
 =
  class
  //Gestion du cycle de vie
  public
    constructor Create( _Niveau: TOD_Niveau);
    destructor Destroy; override;
  //OD_Dataset_Columns
  public
    Niveau: TOD_Niveau;
  //Composition
  public
    Composition: String;
  //CA
  public
    CA: TOD_Champ_array;
  //Find
  public
    function Find( _FieldName: String): TOD_Champ;
  //Assure
  public
    function Assure( _FieldName: String): TOD_Champ;
  //Accesseur par défaut
  private
    function Get( _FieldName: String): TOD_Champ;
  public
    property Column[ _FieldName: String]: TOD_Champ read Get; default;
  //Ajoute_Column
  public
    procedure Ajoute_Column( _FieldIndex, _Debut, _Fin: Integer); overload;
    procedure Ajoute_Column( _FieldName: String; _Debut, _Fin: Integer); overload;
  //Ajoute_Tout
  public
    procedure Ajoute_Tout;
  //Column_SetDebutFin
  public
    procedure Column_SetDebutFin( _FieldName: String; _Debut, _Fin: Integer);
  //Gestion du champ gachette
  public
    TriggerField: String;
    function Triggered: Boolean;
  //Persistance dans le document OpenOffice
  public //pour OpenDocument_DelphiReportEngine
    function Nom_set( Prefixe: String): String; virtual;
    function Nom_Composition( Prefixe: String): String;
    function Nom_TriggerField( Prefixe: String): String;
    procedure Assure_Modele( _Prefixe_Niveau: String; _C: TOD_BatproTextTableContext);
    procedure        to_Doc( _Prefixe_Niveau: String; _C: TOD_BatproTextTableContext);
    procedure      from_Doc( _Prefixe_Niveau: String; _C: TOD_BatproTextTableContext);
  end;

 { TOD_Niveau_set_avant }

 TOD_Niveau_set_avant
 =
  class( TOD_Niveau_set)
  //Persistance dans le document OpenOffice
  public //pour OpenDocument_DelphiReportEngine
    function Nom_set( _Prefixe: String): String; override;
  end;

 { TOD_Niveau_set_apres }

 TOD_Niveau_set_apres
 =
  class( TOD_Niveau_set)
  //Persistance dans le document OpenOffice
  public //pour OpenDocument_DelphiReportEngine
    function Nom_set( _Prefixe: String): String; override;
  end;

 { TOD_Niveau }
 TOD_Niveau
 =
  class
  //Gestion du cycle de vie
  public
    constructor Create( _Nom_Aggregation: String);
    destructor Destroy; override;
  //Attributs
  public
    Avant: TOD_Niveau_set_avant;
    Apres: TOD_Niveau_set_apres;
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
  public
    procedure Assure_Modele( Prefixe: String; C: TOD_BatproTextTableContext);
    procedure to_Doc( Prefixe: String; C: TOD_BatproTextTableContext);
    procedure from_Doc( Prefixe: String; C: TOD_BatproTextTableContext);
  //Gestion des gachettes
  public
    function Avant_Triggered: Boolean;
    function Apres_Triggered: Boolean;
  //Sous-niveau
  public
    SousNiveau: TOD_Niveau;
  end;

 TOD_Niveau_array= array of TOD_Niveau;

implementation

{ TOD_Niveau_set }

constructor TOD_Niveau_set.Create( _Niveau: TOD_Niveau);
begin
     inherited Create;
     Niveau:= _Niveau;
     Composition:= '';
     TriggerField:= '';
end;

destructor TOD_Niveau_set.Destroy;
begin
     inherited Destroy;
end;

function TOD_Niveau_set.Find(_FieldName: String): TOD_Champ;
var
   ODC: TOD_Champ;
begin
     Result:= nil;
     for ODC in CA
     do
       begin
       if nil = ODC                   then continue;
       if _FieldName <> ODC.FieldName then continue;

       Result:= ODC;
       end;
end;

function TOD_Niveau_set.Assure(_FieldName: String): TOD_Champ;
begin
     Result:= Find( _FieldName);
     if Assigned( Result) then exit;

     Result:= TOD_Champ.Create( _FieldName);
     SetLength( CA, Length( CA)+1);
     CA[High( CA)]:= Result;
end;

function TOD_Niveau_set.Get(_FieldName: String): TOD_Champ;
begin
     Result:= Assure( _FieldName);
     Assure_FieldName_in_Composition( _FieldName, Composition);
end;

procedure TOD_Niveau_set.Ajoute_Column( _FieldName: String; _Debut, _Fin: Integer);
var
   C: TOD_Champ;
begin
     C:= Column[ _FieldName];
     C.SetDebutFin( _Debut, _Fin);
end;

procedure TOD_Niveau_set.Ajoute_Column( _FieldIndex, _Debut, _Fin: Integer);
var
   FieldName: String;
begin
     if Niveau.Champs_Courant = nil then exit;

     FieldName:= Niveau.Champs_Courant.Field_from_Index( _FieldIndex);
     Ajoute_Column( FieldName, _Debut, _Fin);
end;

procedure TOD_Niveau_set.Ajoute_Tout;
var
   I: Integer;
begin
     if Niveau.Champs_Courant = nil then exit;

     //Niveau.Champs_Courant.Liste;
     for I:= 0 to Niveau.Champs_Courant.Count - 1
     do
       Ajoute_Column( I, 0, 0);
end;

procedure TOD_Niveau_set.Column_SetDebutFin( _FieldName: String; _Debut, _Fin: Integer);
begin
     Column[ _FieldName].SetDebutFin( _Debut, _Fin);
end;

function TOD_Niveau_set.Triggered: Boolean;
var
   Champ: TChamp;
begin
     Result:= TriggerField = sys_Vide;
     if Result then exit;

     if Niveau = nil                then exit;
     if Niveau.Champs_Courant = nil then exit;

     Champ:= Niveau.Champs_Courant.Champ_from_Field( TriggerField);
     if Champ = nil then exit;

     Result:= Champ.Chaine <> sys_Vide;
end;

function TOD_Niveau_set.Nom_set(Prefixe: String): String;
begin
     Result:= '';
end;

function TOD_Niveau_set.Nom_Composition(Prefixe: String): String;
begin
     Result:= Prefixe+'Composition';
end;

function TOD_Niveau_set.Nom_TriggerField(Prefixe: String): String;
begin
     Result:= Prefixe+'TriggerField';
end;

procedure TOD_Niveau_set.Assure_Modele( _Prefixe_Niveau: String; _C: TOD_BatproTextTableContext);
var
   Prefixe_set: String;
   I: Integer;
begin
     Prefixe_set:= Nom_set( _Prefixe_Niveau)+'_';

     _C.Assure_Parametre( Nom_Composition ( Prefixe_set), Composition );
     _C.Assure_Parametre( Nom_TriggerField( Prefixe_set), TriggerField);

     for I:= Low( CA) to High( CA) do CA[I].Assure_Modele( Prefixe_set, _C);
end;

procedure TOD_Niveau_set.to_Doc( _Prefixe_Niveau: String; _C: TOD_BatproTextTableContext);
var
   Prefixe_set: String;
   I: Integer;
begin
     Prefixe_set:= Nom_set( _Prefixe_Niveau)+'_';

     _C.Ecrire( Nom_Composition ( Prefixe_set), Composition );
     _C.Ecrire( Nom_TriggerField( Prefixe_set), TriggerField);

     for I:= Low( CA) to High( CA) do CA[I].to_Doc( Prefixe_set, _C);
end;

procedure TOD_Niveau_set.from_Doc( _Prefixe_Niveau: String; _C: TOD_BatproTextTableContext);
var
   Prefixe_set: String;
   I: Integer;
   Composition_local: String;
   FieldName: String;
   Champ: TChamp;
   ODC: TOD_Champ;

begin
     Prefixe_set:= Nom_set( _Prefixe_Niveau)+'_';

     //Composition
     Composition:= _C.Lire( Nom_Composition( Prefixe_set));

     //TriggerField
     TriggerField:= _C.Lire( Nom_TriggerField    ( Prefixe_set));

     //CA
     for I:= Low( CA) to High( CA) do FreeAndNil( CA[I]);
     SetLength( CA, 0);

     if Assigned( Niveau.Champs_Courant)
     then
         begin
         Composition_local:= Composition;
         while Composition_local <> ''
         do
           begin
           FieldName:= StrToK( ',', Composition_local);
           if '' = FieldName then continue;

           Champ:= Niveau.Champs_Courant.Champ_from_Field( FieldName);
           if nil = Champ then continue;

           ODC:= Column[ FieldName];
           ODC.from_Doc( Prefixe_set, _C);
           end;
         end;
end;

{ TOD_Niveau_set_avant }

function TOD_Niveau_set_avant.Nom_set( _Prefixe: String): String;
begin
     Result:= _Prefixe+'Avant';
end;

{ TOD_Niveau_set_apres }

function TOD_Niveau_set_apres.Nom_set( _Prefixe: String): String;
begin
     Result:= _Prefixe+'Apres';
end;

{ TOD_Niveau }

constructor TOD_Niveau.Create( _Nom_Aggregation: String);
begin
     Nom_Aggregation:= _Nom_Aggregation;

     Avant:= TOD_Niveau_set_avant.Create( Self);
     Apres:= TOD_Niveau_set_apres.Create( Self);

     OD_Styles:= nil;

     sl            := nil;
     bl_Courant    := nil;
     Champs_Courant:= nil;
     SousNiveau:= nil;
end;

destructor TOD_Niveau.Destroy;
begin
     FreeAndNil( Avant);
     FreeAndNil( Apres);
     inherited Destroy;
end;

procedure TOD_Niveau.Ajoute_Tout_Avant;
begin
     Avant.Ajoute_Tout;
end;

procedure TOD_Niveau.Ajoute_Tout_Apres;
begin
     Apres.Ajoute_Tout;
end;

function TOD_Niveau.Nom: String;
begin
     Result:= Nom_Aggregation;
end;

procedure TOD_Niveau.Assure_Modele( Prefixe: String; C: TOD_BatproTextTableContext);
var
   Prefixe_Niveau: String;
begin
     Prefixe_Niveau:= Prefixe+Nom+'_';

     Avant.Assure_Modele( Prefixe_Niveau, C);
     Apres.Assure_Modele( Prefixe_Niveau, C);
end;

procedure TOD_Niveau.to_Doc( Prefixe: String; C: TOD_BatproTextTableContext);
var
   Prefixe_Niveau: String;
begin
     Prefixe_Niveau:= Prefixe+Nom+'_';

     Avant.to_Doc( Prefixe_Niveau, C);
     Apres.to_Doc( Prefixe_Niveau, C);
end;

procedure TOD_Niveau.from_Doc( Prefixe: String; C: TOD_BatproTextTableContext);
var
   Prefixe_Niveau: String;
begin
     Prefixe_Niveau:= Prefixe+Nom+'_';
     Avant.from_Doc( Prefixe_Niveau, C);
     Apres.from_Doc( Prefixe_Niveau, C);
end;

function TOD_Niveau.Avant_Triggered: Boolean;
begin
     Result:= Avant.Triggered;
end;

function TOD_Niveau.Apres_Triggered: Boolean;
begin
     Result:= Apres.Triggered;
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

procedure TOD_Niveau.Ajoute_Column_Avant( _FieldIndex, _Debut, _Fin: Integer);
begin
     Avant.Ajoute_Column( _FieldIndex, _Debut, _Fin);
end;

procedure TOD_Niveau.Ajoute_Column_Apres( _FieldIndex, _Debut, _Fin: Integer);
begin
     Apres.Ajoute_Column( _FieldIndex, _Debut, _Fin);
end;

procedure TOD_Niveau.Ajoute_Column_Avant( _FieldName: String; _Debut, _Fin: Integer);
begin
     Avant.Ajoute_Column( _FieldName, _Debut, _Fin);
end;

procedure TOD_Niveau.Ajoute_Column_Apres( _FieldName: String; _Debut, _Fin: Integer);
begin
     Apres.Ajoute_Column( _FieldName, _Debut, _Fin);
end;

end.
