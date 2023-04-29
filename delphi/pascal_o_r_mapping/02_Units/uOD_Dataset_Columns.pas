unit uOD_Dataset_Columns;
{                                                                               |
    Part of package pOpenDocument_DelphiReportEngine                            |
                                                                                |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            partly as freelance: http://www.mars42.com                          |
        and partly as employee : http://www.batpro.com                          |
    Contact: gilles.doutre@batpro.com                                           |
                                                                                |
    Copyright (C) 2004-2011  Jean SUZINEAU - MARS42                             |
    Copyright (C) 2004-2011  Cabinet Gilles DOUTRE - BATPRO                     |
                                                                                |
    See pOpenDocument_DelphiReportEngine.dpk.LICENSE for full copyright notice. |
|                                                                               }

interface

uses
    uOOoStrings,
    uOD_Dataset_Column,
    uOD_TextTableContext,
    uOD_Styles,
  SysUtils, Classes, DB, StrUtils;

type
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
    FAvant: TOD_Dataset_Column_array;
  private
    function GetAvant( _FieldName: String): TOD_Dataset_Column;
  public
    Avant_Composition: String;
    property Avant[_FieldName: String]: TOD_Dataset_Column read GetAvant;
    procedure Ajoute_Column_Avant( FieldIndex, _Debut, _Fin: Integer);
    procedure Column_Avant( _FieldName: String; _Debut, _Fin: Integer);
    procedure Column_Avant_from_( _FieldName: String; _from: TOD_Dataset_Column);
    procedure Ajoute_Tout_Avant;
  //Apres
  public
    FApres: TOD_Dataset_Column_array;
  private
    function GetApres( _FieldName: String): TOD_Dataset_Column;
  public
    Apres_Composition: String;
    property Apres[_FieldName: String]: TOD_Dataset_Column read GetApres;
    procedure Ajoute_Column_Apres( FieldIndex, _Debut, _Fin: Integer);
    procedure Column_Apres( _FieldName: String; _Debut, _Fin: Integer);
    procedure Column_Apres_from_( _FieldName: String; _from: TOD_Dataset_Column);
    procedure Ajoute_Tout_Apres;
  //Styles
  public
    OD_Styles: TOD_Styles;
  //Persistance dans le document OpenOffice
  private
    function Nom_Avant( Prefixe: String): String;
    function Nom_Apres( Prefixe: String): String;
    function Nom_Composition( Prefixe: String): String;
    function Nom_TriggerField( Prefixe: String): String;
  public
    procedure Assure_Modele( Prefixe: String; C: TOD_TextTableContext);
    procedure   to_Doc( Prefixe: String; C: TOD_TextTableContext);
    procedure from_Doc( Prefixe: String; C: TOD_TextTableContext);
  //Gestion des gachettes
  private
    function Triggered( TriggerField: String): Boolean;
  public
    Avant_TriggerField, Apres_TriggerField: String;
    function Avant_Triggered: Boolean;
    function Apres_Triggered: Boolean;
  //Gestion de l'insertion de colonne
  public
    procedure InsererColonneApres( _Index: Integer);
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

{ TOD_Dataset_Columns }

constructor TOD_Dataset_Columns.Create(_D: TDataset);
begin
     D:= _D;
     Avant_Composition:= '';
     Apres_Composition:= '';
     Avant_TriggerField:= '';
     Apres_TriggerField:= '';
     OD_Styles:= nil;
end;

destructor TOD_Dataset_Columns.Destroy;
begin

end;

function TOD_Dataset_Columns.GetAvant( _FieldName: String): TOD_Dataset_Column;
var
   I: Integer;
   Trouve: Boolean;
   procedure Cherche;
   begin
        Trouve:= False;
        I:= Low( FAvant);
        while I <= High( FAvant)
        do
          begin
          Result:= FAvant[I];
          Trouve:= _FieldName = Result.FieldName;
          if Trouve then break;

          Inc( I);
          end;
   end;
   procedure Ajoute;
   begin
        Result:= TOD_Dataset_Column.Create( _FieldName);
        SetLength( FAvant, Length( FAvant)+1);
        FAvant[High( FAvant)]:= Result;

        Assure_FieldName_in_Composition( _FieldName, Avant_Composition);
   end;
begin
     Cherche;
     if Trouve then exit;

     Ajoute;
end;

function TOD_Dataset_Columns.GetApres( _FieldName: String): TOD_Dataset_Column;
var
   I: Integer;
   Trouve: Boolean;
   procedure Cherche;
   begin
        Trouve:= False;
        I:= Low( FApres);
        while I <= High( FApres)
        do
          begin
          Result:= FApres[I];
          Trouve:= _FieldName = Result.FieldName;
          if Trouve then break;

          Inc( I);
          end;
   end;
   procedure Ajoute;
   begin
        Result:= TOD_Dataset_Column.Create( _FieldName);
        SetLength( FApres, Length( FApres)+1);
        FApres[High( FApres)]:= Result;

        Assure_FieldName_in_Composition( _FieldName, Apres_Composition);
   end;
begin
     Cherche;
     if Trouve then exit;

     Ajoute;
end;

procedure TOD_Dataset_Columns.Column_Avant( _FieldName: String;
                                            _Debut, _Fin: Integer);
begin
     Avant[_FieldName].SetDebutFin( _Debut, _Fin);
end;

procedure TOD_Dataset_Columns.Column_Apres( _FieldName: String;
                                            _Debut, _Fin: Integer);
begin
     Apres[_FieldName].SetDebutFin( _Debut, _Fin);
end;

procedure TOD_Dataset_Columns.Column_Avant_from_( _FieldName: String; _from: TOD_Dataset_Column);
begin
     Avant[_FieldName].Set_from_( _from);
end;

procedure TOD_Dataset_Columns.Column_Apres_from_( _FieldName: String; _from: TOD_Dataset_Column);
begin
     Apres[_FieldName].Set_from_( _from);
end;

procedure TOD_Dataset_Columns.Ajoute_Column_Avant( FieldIndex, _Debut, _Fin: Integer);
var
   F: TField;
   FieldName: String;
   C: TOD_Dataset_Column;
begin
     F:= d.Fields[ FieldIndex];
     FieldName:= F.FieldName;
     C:= TOD_Dataset_Column.Create( FieldName);
     C.SetDebutFin( _Debut, _Fin);
     SetLength( FAvant, Length( FAvant)+1);
     FAvant[High(FAvant)]:= C;

     Assure_FieldName_in_Composition( FieldName, Avant_Composition);
end;

procedure TOD_Dataset_Columns.Ajoute_Column_Apres( FieldIndex, _Debut, _Fin: Integer);
var
   F: TField;
   FieldName: String;
   C: TOD_Dataset_Column;
begin
     F:= d.Fields[ FieldIndex];
     FieldName:= F.FieldName;
     C:= TOD_Dataset_Column.Create( FieldName);
     C.SetDebutFin( _Debut, _Fin);
     SetLength( FApres, Length( FApres)+1);
     FApres[High(FApres)]:= C;

     Assure_FieldName_in_Composition( FieldName, Apres_Composition);
end;

procedure TOD_Dataset_Columns.Ajoute_Tout_Avant;
var
   I: Integer;
begin
     for I:= 0 to d.FieldCount - 1
     do
       Ajoute_Column_Avant( I, 0, 0);
end;

procedure TOD_Dataset_Columns.Ajoute_Tout_Apres;
var
   I: Integer;
begin
     for I:= 0 to d.FieldCount - 1
     do
       Ajoute_Column_Apres( I, 0, 0);
end;

function TOD_Dataset_Columns.Nom: String;
begin
     Result:= D.Name;
end;

function TOD_Dataset_Columns.Nom_Avant(Prefixe: String): String;
begin
     Result:= Prefixe+'Avant';
end;

function TOD_Dataset_Columns.Nom_Apres(Prefixe: String): String;
begin
     Result:= Prefixe+'Apres';
end;

function TOD_Dataset_Columns.Nom_Composition(Prefixe: String): String;
begin
     Result:= Prefixe+'Composition';
end;

function TOD_Dataset_Columns.Nom_TriggerField(Prefixe: String): String;
begin
     Result:= Prefixe+'TriggerField';
end;

procedure TOD_Dataset_Columns.Assure_Modele( Prefixe: String; C: TOD_TextTableContext);
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
     for I:= Low( FAvant) to High( FAvant) do FAvant[I].Assure_Modele( pav, C);
     for I:= Low( FApres) to High( FApres) do FApres[I].Assure_Modele( pap, C);
end;

procedure TOD_Dataset_Columns.to_Doc( Prefixe: String; C: TOD_TextTableContext);
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
     for I:= Low( FAvant) to High( FAvant) do FAvant[I].to_Doc( pav, C);
     for I:= Low( FApres) to High( FApres) do FApres[I].to_Doc( pap, C);
end;

procedure TOD_Dataset_Columns.from_Doc( Prefixe: String; C: TOD_TextTableContext);
var
   p: String;
   pav, pap: String;
   procedure Traite( pa: String; var Composition, TriggerField: String; var a: TOD_Dataset_Column_array);
   var
      I: Integer;
      FieldName: String;
      F: TField;
      ODC: TOD_Dataset_Column;
      Composition_local: String;
   begin
        Composition:= C.Lire( Nom_Composition( pa));
        Composition_local:= Composition;
        TriggerField    := C.Lire( Nom_TriggerField    ( pa));
        for I:= Low( A) to High( A) do FreeAndNil( A[I]);
        SetLength( A, 0);
        while Composition_local <> ''
        do
          begin
          FieldName:= StrToK( ',', Composition_local);
          F:= D.FindField( FieldName);
          if Assigned( F)
          then
              begin
              SetLength( A, Length(A)+1);
              ODC:= TOD_Dataset_Column.Create( FieldName);
              ODC.from_Doc( pa, C);
              A[High(A)]:= ODC;
              end;
          end;
   end;

begin
     p:= Prefixe+Nom+'_';
     pav:= Nom_Avant( p)+'_';
     pap:= Nom_Apres( p)+'_';
     Traite( pav, Avant_Composition, Avant_TriggerField, FAvant);
     Traite( pap, Apres_Composition, Apres_TriggerField, FApres);
end;

function TOD_Dataset_Columns.Triggered( TriggerField: String): Boolean;
var
   F: TField;
begin
     Result:= TriggerField = sys_Vide;
     if Result then exit;

     F:= D.FindField( TriggerField);
     if F = nil then exit;

     Result:= F.DisplayText <> sys_Vide;
end;

function TOD_Dataset_Columns.Avant_Triggered: Boolean;
begin
     Result:= Triggered( Avant_TriggerField);
end;

function TOD_Dataset_Columns.Apres_Triggered: Boolean;
begin
     Result:= Triggered( Apres_TriggerField);
end;

procedure TOD_Dataset_Columns.InsererColonneApres(_Index: Integer);
var
   I: Integer;
   od: TOD_Dataset_Column;
begin
     for I:= Low(FAvant) to High(FAvant)
     do
       begin
       od:= FAvant[I];
       od.InsererColonneApres( _Index);
       end;
     for I:= Low(FApres) to High(FApres)
     do
       begin
       od:= FApres[I];
       od.InsererColonneApres( _Index);
       end;
end;

end.
