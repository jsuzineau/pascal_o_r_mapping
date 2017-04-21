unit uOD_Dataset_Columns;
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            partly as freelance: http://www.mars42.com                          |
        and partly as employee : http://www.batpro.com                          |
    Contact: gilles.doutre@batpro.com                                           |
                                                                                |
    Copyright 2011,2012,2014 Jean SUZINEAU - MARS42                             |
    Copyright 2011,2012,2014 Cabinet Gilles DOUTRE - BATPRO                     |
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
    along with this program.  If not, see <http://www.gnu.org/licenses/>. 1     |
                                                                                |
|                                                                               }

interface

uses
    uOOoStrings,
    uLog,
    uOD_Dataset_Column,
    uOD_TextTableContext,
    uOD_Styles,
    uPublieur,
  SysUtils, Classes, DB, StrUtils;

type

 TOD_Dataset_Columns= class;

 { TOD_Dataset_Column_set }

 TOD_Dataset_Column_set
 =
  class
  //Gestion du cycle de vie
  public
    constructor Create( _DCs: TOD_Dataset_Columns);
    destructor Destroy; override;
  //OD_Dataset_Columns
  public
    DCs: TOD_Dataset_Columns;
  //Composition
  public
    Composition: String;
  //DCA
  public
    DCA: TOD_Dataset_Column_array;
  //Find
  public
    function Find( _FieldName: String): TOD_Dataset_Column;
  //Assure
  public
    function Assure( _FieldName: String): TOD_Dataset_Column;
  //Accesseur par défaut
  private
    function Get( _FieldName: String): TOD_Dataset_Column;
  public
    property Column[ _FieldName: String]: TOD_Dataset_Column read Get; default;
  //Ajoute_Column
  public
    procedure Ajoute_Column( _FieldIndex, _Debut, _Fin: Integer);
  //Ajoute_Tout
  public
    procedure Ajoute_Tout;
  //Displayed
  public
    function Displayed( _FieldName: String): Boolean;
  //Column_SetDebutFin
  public
    procedure Column_SetDebutFin( _FieldName: String; _Debut, _Fin: Integer);
  //Column_from_
  public
    procedure Column_from_( _FieldName: String; _from: TOD_Dataset_Column);
  //Gestion du champ gachette
  public
    TriggerField: String;
    function Triggered: Boolean;
  //Persistance dans le document OpenOffice
  public //pour OpenDocument_DelphiReportEngine
    function Nom_set( Prefixe: String): String; virtual;
    function Nom_Composition( Prefixe: String): String;
    function Nom_TriggerField( Prefixe: String): String;
    procedure Assure_Modele( _Prefixe_DCs: String; _C: TOD_TextTableContext);
    procedure        to_Doc( _Prefixe_DCs: String; _C: TOD_TextTableContext);
    procedure      from_Doc( _Prefixe_DCs: String; _C: TOD_TextTableContext);
  end;

 { TOD_Dataset_Column_set_avant }

 TOD_Dataset_Column_set_avant
 =
  class( TOD_Dataset_Column_set)
  //Persistance dans le document OpenOffice
  public //pour OpenDocument_DelphiReportEngine
    function Nom_set( _Prefixe: String): String; override;
  end;

 { TOD_Dataset_Column_set_apres }

 TOD_Dataset_Column_set_apres
 =
  class( TOD_Dataset_Column_set)
  //Persistance dans le document OpenOffice
  public //pour OpenDocument_DelphiReportEngine
    function Nom_set( _Prefixe: String): String; override;
  end;

 { TOD_Dataset_Columns }

 TOD_Dataset_Columns
 =
  class
  //Gestion du cycle de vie
  public
    constructor Create( _D: TDataset);
    destructor Destroy; override;
  //Dataset
  public
    D: TDataset;
  //Nom
  public
    function Nom: String;
  //Avant
  public
    Avant: TOD_Dataset_Column_set_avant;
    procedure Ajoute_Column_Avant( FieldIndex, _Debut, _Fin: Integer);
    procedure Ajoute_Tout_Avant;
  //Apres
  public
    Apres: TOD_Dataset_Column_set_apres;
    procedure Ajoute_Column_Apres( FieldIndex, _Debut, _Fin: Integer);
    procedure Ajoute_Tout_Apres;
  //Styles
  public
    OD_Styles: TOD_Styles;
  //Persistance dans le document OpenOffice
  public
    procedure Assure_Modele( _Prefixe_Table: String; _C: TOD_TextTableContext);
    procedure        to_Doc( _Prefixe_Table: String; _C: TOD_TextTableContext);
    procedure      from_Doc( _Prefixe_Table: String; _C: TOD_TextTableContext);
  //Prefixe_Table
  public
    Prefixe_Table: String;
  end;

 TOD_Dataset_Columns_array= array of TOD_Dataset_Columns;

function FieldName_in_Composition( _FieldName, _Composition: String; Etat: PString= nil): Boolean;
procedure Assure_FieldName_in_Composition( _FieldName: String;
                                           var _Composition: String);

implementation

function FieldName_in_Composition( _FieldName, _Composition: String; Etat: PString= nil): Boolean;
var
   Offset: Integer;
   Arreter: Boolean;
   I: Integer;
   iAvant_FieldName,
   iApres_FieldName: Integer;
begin
     Result:= False;
     Offset:= 1;

     repeat
           I:= PosEx( _FieldName, _Composition, Offset);
           Arreter:= I = 0;
           if Arreter then break;

           iAvant_FieldName:= I-1;
           iApres_FieldName:= I+Length(_FieldName);
           Result
           :=
                 (
                   (iAvant_FieldName < 1) //début de chaine
                   or
                   (_Composition[iAvant_FieldName] = ',')//précédé par ,
                 )
             and
                 (
                   (iApres_FieldName>Length(_Composition)) //fin de chaine
                   or
                   (_Composition[iApres_FieldName] =',') //suivi par ,
                 );
           if Result then break;

           Offset:= iApres_FieldName;
           if Assigned( Etat)
           then
               Etat^:=  'iAvant_FieldName='+IntToStr( iAvant_FieldName)+#13#10
                       +'iApres_FieldName='+IntToStr( iApres_FieldName)+#13#10;

     until Arreter;
end;

procedure Assure_FieldName_in_Composition( _FieldName: String;
                                           var _Composition: String);
begin
        if FieldName_in_Composition( _FieldName, _Composition) then exit;

        if _Composition <> '' then _Composition:= _Composition+',';
        _Composition:= _Composition + _FieldName;
end;

{ TOD_Dataset_Column_set }

constructor TOD_Dataset_Column_set.Create(_DCs: TOD_Dataset_Columns);
begin
     inherited Create;
     DCs:= _DCs;
     Composition:= '';
     TriggerField:= '';
end;

destructor TOD_Dataset_Column_set.Destroy;
begin
     inherited Destroy;
end;

function TOD_Dataset_Column_set.Find( _FieldName: String): TOD_Dataset_Column;
var
   DC: TOD_Dataset_Column;
begin
     Result:= nil;
     for DC in DCA
     do
       begin
       if nil = DC                   then continue;
       if _FieldName <> DC.FieldName then continue;

       Result:= DC;
       end;
end;

function TOD_Dataset_Column_set.Assure( _FieldName: String): TOD_Dataset_Column;
begin
     Result:= Find( _FieldName);
     if Assigned( Result) then exit;

     Result:= TOD_Dataset_Column.Create( _FieldName);
     SetLength( DCA, Length( DCA)+1);
     DCA[High( DCA)]:= Result;
end;

function TOD_Dataset_Column_set.Get(_FieldName: String): TOD_Dataset_Column;
begin
     Result:= Assure( _FieldName);
     Assure_FieldName_in_Composition( _FieldName, Composition);
end;

procedure TOD_Dataset_Column_set.Ajoute_Column( _FieldIndex, _Debut, _Fin: Integer);
var
   F: TField;
   FieldName: String;
   C: TOD_Dataset_Column;
begin
     F:= DCs.D.Fields[ _FieldIndex];
     FieldName:= F.FieldName;
     C:= Column[ FieldName];
     C.SetDebutFin( _Debut, _Fin);
end;

procedure TOD_Dataset_Column_set.Ajoute_Tout;
var
   I: Integer;
begin
     for I:= 0 to DCs.d.FieldCount - 1
     do
       Ajoute_Column( I, 0, 0);
end;

function TOD_Dataset_Column_set.Displayed( _FieldName: String): Boolean;
begin
     Result:= FieldName_in_Composition( _FieldName, Composition);
end;

procedure TOD_Dataset_Column_set.Column_SetDebutFin( _FieldName: String; _Debut, _Fin: Integer);
begin
     Column[ _FieldName].SetDebutFin( _Debut, _Fin);
end;

procedure TOD_Dataset_Column_set.Column_from_( _FieldName: String;
                                               _from: TOD_Dataset_Column);
begin
     Column[_FieldName].Set_from_( _from);
end;

function TOD_Dataset_Column_set.Triggered: Boolean;
var
   F: TField;
begin
     Result:= TriggerField = sys_Vide;
     if Result then exit;

     F:= DCs.D.FindField( TriggerField);
     if F = nil then exit;

     Result:= F.DisplayText <> sys_Vide;
end;

function TOD_Dataset_Column_set.Nom_set(Prefixe: String): String;
begin
     Result:= '';
end;

function TOD_Dataset_Column_set.Nom_Composition(Prefixe: String): String;
begin
     Result:= Prefixe+'Composition';
end;

function TOD_Dataset_Column_set.Nom_TriggerField(Prefixe: String): String;
begin
     Result:= Prefixe+'TriggerField';
end;

procedure TOD_Dataset_Column_set.Assure_Modele( _Prefixe_DCs: String; _C: TOD_TextTableContext);
var
   Prefixe_set: String;
   I: Integer;
begin
     Prefixe_set:= Nom_set( _Prefixe_DCs)+'_';

     _C.Assure_Parametre( Nom_Composition ( Prefixe_set), Composition );
     _C.Assure_Parametre( Nom_TriggerField( Prefixe_set), TriggerField);

     for I:= Low( DCA) to High( DCA) do DCA[I].Assure_Modele( Prefixe_set, _C);
end;

procedure TOD_Dataset_Column_set.to_Doc( _Prefixe_DCs: String; _C: TOD_TextTableContext);
var
   Prefixe_set: String;
   I: Integer;
begin
     Prefixe_set:= Nom_set( _Prefixe_DCs)+'_';

     _C.Ecrire( Nom_Composition ( Prefixe_set), Composition );
     _C.Ecrire( Nom_TriggerField( Prefixe_set), TriggerField);

     for I:= Low( DCA) to High( DCA) do DCA[I].to_Doc( Prefixe_set, _C);
end;

procedure TOD_Dataset_Column_set.from_Doc( _Prefixe_DCs: String; _C: TOD_TextTableContext);
var
   Prefixe_set: String;
   I: Integer;
   FieldName: String;
   F: TField;
   ODC: TOD_Dataset_Column;
   Composition_local: String;
   sNomComposition: String;
begin
     Prefixe_set:= Nom_set( _Prefixe_DCs)+'_';

     //Composition
     sNomComposition:= Nom_Composition( Prefixe_set);
     Composition:= _C.Lire( sNomComposition);
     Log.PrintLn( sNomComposition+'='+Composition);
     Composition_local:= Composition;

     //TriggerField
     TriggerField    := _C.Lire( Nom_TriggerField    ( Prefixe_set));

     //DCA
     for I:= Low( DCA) to High( DCA) do FreeAndNil( DCA[I]);
     SetLength( DCA, 0);
     while Composition_local <> ''
     do
       begin
       FieldName:= StrToK( ',', Composition_local);
       F:= DCs.D.FindField( FieldName);
       if Assigned( F)
       then
           begin
           SetLength( DCA, Length(DCA)+1);
           ODC:= TOD_Dataset_Column.Create( FieldName);
           ODC.from_Doc( Prefixe_set, _C);
           DCA[High(DCA)]:= ODC;
           end;
       end;
end;

{ TOD_Dataset_Column_set_avant }

function TOD_Dataset_Column_set_avant.Nom_set( _Prefixe: String): String;
begin
     Result:= _Prefixe+'Avant';
end;

{ TOD_Dataset_Column_set_apres }

function TOD_Dataset_Column_set_apres.Nom_set( _Prefixe: String): String;
begin
     Result:= _Prefixe+'Apres';
end;

{ TOD_Dataset_Columns }

constructor TOD_Dataset_Columns.Create(_D: TDataset);
begin
     D:= _D;
     Avant:= TOD_Dataset_Column_set_avant.Create( Self);
     Apres:= TOD_Dataset_Column_set_apres.Create( Self);
     OD_Styles:= nil;
end;

destructor TOD_Dataset_Columns.Destroy;
begin
     FreeAndNil( Avant);
     FreeAndNil( Apres);
     inherited Destroy;
end;

function TOD_Dataset_Columns.Nom: String;
begin
     Result:= D.Name;
end;

procedure TOD_Dataset_Columns.Ajoute_Column_Avant( FieldIndex, _Debut, _Fin: Integer);
begin
     Avant.Ajoute_Column( FieldIndex, _Debut, _Fin);
end;

procedure TOD_Dataset_Columns.Ajoute_Tout_Avant;
begin
     Avant.Ajoute_Tout;
end;

procedure TOD_Dataset_Columns.Ajoute_Column_Apres( FieldIndex, _Debut, _Fin: Integer);
begin
     Apres.Ajoute_Column( FieldIndex, _Debut, _Fin);
end;

procedure TOD_Dataset_Columns.Ajoute_Tout_Apres;
begin
     Apres.Ajoute_Tout;
end;

procedure TOD_Dataset_Columns.Assure_Modele(_Prefixe_Table: String;
 _C: TOD_TextTableContext);
var
   Prefixe_DCs: String;
begin
     Prefixe_Table:= _Prefixe_Table;

     Prefixe_DCs:= Prefixe_Table+Nom+'_';

     Avant.Assure_Modele( Prefixe_DCs, _C);
     Apres.Assure_Modele( Prefixe_DCs, _C);
end;

procedure TOD_Dataset_Columns.to_Doc( _Prefixe_Table: String; _C: TOD_TextTableContext);
var
   Prefixe_DCs: String;
begin
     Prefixe_Table:= _Prefixe_Table;

     Prefixe_DCs:= Prefixe_Table+Nom+'_';

     Avant.to_Doc( Prefixe_DCs, _C);
     Apres.to_Doc( Prefixe_DCs, _C);
end;

procedure TOD_Dataset_Columns.from_Doc(_Prefixe_Table: String;
 _C: TOD_TextTableContext);
var
   Prefixe_DCs: String;
begin
     Prefixe_Table:= _Prefixe_Table;

     Prefixe_DCs:= Prefixe_Table+Nom+'_';

     Avant.from_Doc( Prefixe_DCs, _C);
     Apres.from_Doc( Prefixe_DCs, _C);
end;

end.
