unit uChampDefinition;
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            partly as freelance: http://www.mars42.com                          |
        and partly as employee : http://www.batpro.com                          |
    Contact: gilles.doutre@batpro.com                                           |
                                                                                |
    Copyright 2014 Jean SUZINEAU - MARS42                                       |
    Copyright 2014 Cabinet Gilles DOUTRE - BATPRO                               |
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
    u_sys_,
    uuStrings,
    uReal_Formatter,
    {$IFDEF MSWINDOWS}
    uWinUtils,
    {$ENDIF}
  SysUtils, Classes,
  {$IFDEF MSWINDOWS}
  Forms, Graphics,Grids,
  {$ENDIF}
  DB;

type
 {$IF DEFINED(MSWINDOWS) AND NOT DEFINED(FPC)}
 TfcbChamp
 =
  class( TForm)

  public
    procedure InplaceEditUpdateContents( _iel: TInplaceEditList; _Champ: TObject); virtual; abstract;
    procedure InplaceEditChange                                                  ; virtual; abstract;
    procedure InplaceEditKeyDown       ( var Key: Word; Shift: TShiftState)      ; virtual; abstract;
    procedure InplaceEditDecroche                                                ; virtual; abstract;
  end;
 TfcbChamp_class= class of TfcbChamp;
 {$IFEND}

 TChampDefinition
 =
  class
  public
    Nom       : String;
    Typ       : TFieldType;
    Persistant: Boolean;
    Visible   : Boolean;
    Libelle   : String;
    Longueur  : Integer;
    constructor Create(
                        _Nom       : String;
                        _Typ       : TFieldType;
                        _Persistant: Boolean;
                        F          : TField
                       );
  //Gestion des lookups
  private
    procedure Init_Lookup( _LookupKey: TChampDefinition);
    {$IF DEFINED(MSWINDOWS) AND NOT DEFINED(FPC)}
    function GetfcbChamp: TfcbChamp;
    {$IFEND}
    procedure SetMinValue(const Value: double);
  public
    LookupKey: TChampDefinition;
    constructor Create_Lookup( _Nom       : String;
                               _Typ       : TFieldType;
                               _LookupKey: TChampDefinition
                               );
    function Is_Lookup: Boolean;
  {$IFDEF MSWINDOWS}
  //Gestion de la largeur maxi d'affichage
  public
    function Largeur( Font: TFont): Integer;
  {$ENDIF}
  {$IF DEFINED(MSWINDOWS) AND NOT DEFINED(FPC)}
  //Gestion des modifications dans TChampGrid
  public
    function GetEditStyle: TEditStyle;
  {$IFEND}
  //Formatage des flottants
  public
    Flottant_Tronque: Boolean;
    Flottant_Precision: Integer;
    function Format_Float( Value: Double): String;
  {$IF DEFINED(MSWINDOWS) AND NOT DEFINED(FPC)}
  //Gestion de l'éditeur
  private
    FfcbChamp: TfcbChamp;
  public
    fcbChamp_class: TfcbChamp_class;
    property fcbChamp: TfcbChamp read GetfcbChamp;
    procedure fcbChamp_InplaceEditUpdateContents( _iel: TInplaceEditList; _Champ: TObject);
    procedure fcbChamp_InplaceEditChange        ;
    procedure fcbChamp_InplaceEditKeyDown       ( var Key: Word; Shift: TShiftState);
    procedure fcbChamp_InplaceEditDecroche      ;
  {$IFEND}
  //Gestion des valeurs minimales
  private
    FMinValue   : double;
    FHasMinValue: Boolean;
  public
    property MinValue   : double  read FMinValue    write SetMinValue;
    property HasMinValue: Boolean read FHasMinValue ;
  end;

function ChampDefinition_from_sl( sl: TBatpro_StringList; I: Integer): TChampDefinition;

implementation

function ChampDefinition_from_sl( sl: TBatpro_StringList; I: Integer): TChampDefinition;
var
   O: TObject;
begin
     Result:= nil;
     if (I < 0) or (sl.Count <= I) then exit;

     O:= sl.Objects[ I];
     Affecte( Result, TChampDefinition, O);
end;

{ TChampDefinition }

constructor TChampDefinition.Create( _Nom       : String;
                                     _Typ       : TFieldType;
                                     _Persistant: Boolean;
                                     F          : TField
                                     );
begin
     Nom       := _Nom       ;
     Typ       := _Typ       ;
     Persistant:= _Persistant;
     if F = nil
     then
         begin
         Visible := False;
         Libelle := Nom;
         Longueur:= 0;
         end
     else
         begin
         Visible := F.Visible;
         Libelle := f.DisplayLabel;
         Longueur:= f.DisplayWidth;
         end;

     Flottant_Tronque  := False;
     Flottant_Precision:= 2;

     {$IF DEFINED(MSWINDOWS) AND NOT DEFINED(FPC)}
     fcbChamp_class:= nil;
     FfcbChamp     := nil;
     {$IFEND}

     FHasMinValue:= False;
end;

constructor TChampDefinition.Create_Lookup( _Nom:String;
                                            _Typ: TFieldType;
                                            _LookupKey: TChampDefinition);
begin
     Create( _Nom, _Typ, False, nil);
     Init_Lookup( _LookupKey);
end;

procedure TChampDefinition.Init_Lookup( _LookupKey: TChampDefinition);
begin
     LookupKey:= _LookupKey;
     LookupKey.Visible:= False;
               Visible:= True;
end;

function TChampDefinition.Is_Lookup: Boolean;
begin
     Result:= Assigned( LookupKey);
end;

function TChampDefinition.Format_Float( Value: Double): String;
begin
     Result
     :=
       uReal_Formatter.Format_Float( Value,Flottant_Tronque,Flottant_Precision);
end;

procedure TChampDefinition.SetMinValue(const Value: double);
begin
     FMinValue:= Value;
     FHasMinValue:= True;
end;

{$IFDEF MSWINDOWS}
function TChampDefinition.Largeur(Font: TFont): Integer;
var
   S: String;
begin
     S:= ChaineDe( Longueur, 'W');
     Result:= LargeurTexte( Font, S);
end;
{$ENDIF}
{$IF DEFINED(MSWINDOWS) AND NOT DEFINED(FPC)}
function TChampDefinition.GetEditStyle: TEditStyle;
begin
     if Is_Lookup
     then
         Result:= esEllipsis
     else
         case Typ
         of
           ftString   : Result:= esSimple;
           ftMemo     : Result:= esSimple;
           ftBlob     : Result:= esSimple;
           ftDate     : Result:= esEllipsis;
           ftInteger  : Result:= esSimple;
           ftSmallint : Result:= esSimple;
           ftBCD      : Result:= esSimple;
           ftDateTime : Result:= esEllipsis;
           ftTimeStamp: Result:= esEllipsis;
           ftFloat    : Result:= esSimple;
           else         Result:= esSimple;
           end;
end;

function TChampDefinition.GetfcbChamp: TfcbChamp;
begin
     if     (FfcbChamp = nil)
        and Assigned( fcbChamp_class)
     then
         FfcbChamp:= fcbChamp_class.Create( nil);

     Result:= FfcbChamp;
end;

procedure TChampDefinition.fcbChamp_InplaceEditUpdateContents( _iel: TInplaceEditList; _Champ: TObject);
begin
     if fcbChamp = nil then exit;

     FfcbChamp.InplaceEditUpdateContents( _iel, _Champ);
end;

procedure TChampDefinition.fcbChamp_InplaceEditChange;
begin
     if fcbChamp = nil then exit;
     FfcbChamp.InplaceEditChange;
end;

procedure TChampDefinition.fcbChamp_InplaceEditKeyDown( var Key: Word; Shift: TShiftState);
begin
     if fcbChamp = nil then exit;
     FfcbChamp.InplaceEditKeyDown( Key, Shift);
end;

procedure TChampDefinition.fcbChamp_InplaceEditDecroche;
begin
     if fcbChamp = nil then exit;
     FfcbChamp.InplaceEditDecroche;
end;

{$IFEND}
end.
