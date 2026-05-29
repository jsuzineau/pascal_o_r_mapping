unit uApplicationJoinPointFile_OpenAPI_Path_Verb_Property;
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            http://www.mars42.com                          |
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
    uuStrings,
    uBatpro_StringList,
    uGenerateur_de_code_Ancetre,
    uContexteClasse,
    uContexteMembre,
    uJoinPoint,
    ujpFile,
    uOpenAPI,
  SysUtils, Classes;

type

 { TApplicationJoinPointFile_OpenAPI_Path_Verb_Property }

 TApplicationJoinPointFile_OpenAPI_Path_Verb_Property
 =
  class(TJoinPointFile_Ancetre)
  public
  //cycle de vie
  public
    constructor Create( _nfKey: String);
  //Attributs
  public
    nfKey       : String; sKey       : String;
    nfBegin     : String; sBegin     : String;
    nfElement   : String; sElement   : String;
    nfSeparateur: String; sSeparateur: String;
    nfEnd       : String; sEnd       : String;
  public
    Cle: String;
    Valeur: String;
  //Gestion de la visite d'une classe
  private
    Premier: Boolean;
  public
    procedure Initialise;
    procedure VisitePath_Verb_Property(_path: TPath; _verb: TVerb;
     _property: TVerb_Property);
    procedure Finalise;
    procedure To_Parametres( _sl: TStringList);
  end;

 TIterateur_ApplicationJoinPointFile_OpenAPI_Path_Verb_Property
 =
  class( TIterateur)
  //Iterateur
  public
    procedure Suivant( var _Resultat: TApplicationJoinPointFile_OpenAPI_Path_Verb_Property);
    function  not_Suivant( var _Resultat: TApplicationJoinPointFile_OpenAPI_Path_Verb_Property): Boolean;
  end;

 { TslApplicationJoinPointFile_OpenAPI_Path_Verb_Property }

 TslApplicationJoinPointFile_OpenAPI_Path_Verb_Property
 =
  class( TslJoinPointFile_Ancetre)
  //Gestion du cycle de vie
  public
    constructor Create( _Nom: String= ''); override;
    destructor Destroy; override;
  //Création d'itérateur
  protected
    class function Classe_Iterateur: TIterateur_Class; override;
  public
    function Iterateur: TIterateur_ApplicationJoinPointFile_OpenAPI_Path_Verb_Property;
    function Iterateur_Decroissant: TIterateur_ApplicationJoinPointFile_OpenAPI_Path_Verb_Property;
  //Création JoinPointFile
  public
    function  Create_JoinPointFile( _nfKey: String): TJoinPointFile_Ancetre;override;
  //Gestion de la visite d'une classe
  public
    procedure Initialise;
    procedure VisitePath_Verb_Property(_path: TPath; _verb: TVerb;
     _property: TVerb_Property);
    procedure Finalise;
    procedure To_Parametres( _sl: TStringList);
  end;

function ApplicationJoinPointFile_OpenAPI_Path_Verb_Property_from_sl( sl: TBatpro_StringList; Index: Integer): TApplicationJoinPointFile_OpenAPI_Path_Verb_Property;
function ApplicationJoinPointFile_OpenAPI_Path_Verb_Property_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TApplicationJoinPointFile_OpenAPI_Path_Verb_Property;

implementation

function ApplicationJoinPointFile_OpenAPI_Path_Verb_Property_from_sl( sl: TBatpro_StringList; Index: Integer): TApplicationJoinPointFile_OpenAPI_Path_Verb_Property;
begin
     _Classe_from_sl( Result, TApplicationJoinPointFile_OpenAPI_Path_Verb_Property, sl, Index);
end;

function ApplicationJoinPointFile_OpenAPI_Path_Verb_Property_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TApplicationJoinPointFile_OpenAPI_Path_Verb_Property;
begin
     _Classe_from_sl_sCle( Result, TApplicationJoinPointFile_OpenAPI_Path_Verb_Property, sl, sCle);
end;

{ TIterateur_ApplicationJoinPointFile_OpenAPI_Path_Verb_Property }

function TIterateur_ApplicationJoinPointFile_OpenAPI_Path_Verb_Property.not_Suivant( var _Resultat: TApplicationJoinPointFile_OpenAPI_Path_Verb_Property): Boolean;
begin
     Result:= not_Suivant_interne( _Resultat);
end;

procedure TIterateur_ApplicationJoinPointFile_OpenAPI_Path_Verb_Property.Suivant( var _Resultat: TApplicationJoinPointFile_OpenAPI_Path_Verb_Property);
begin
     Suivant_interne( _Resultat);
end;

{ TslApplicationJoinPointFile_OpenAPI_Path_Verb_Property }

constructor TslApplicationJoinPointFile_OpenAPI_Path_Verb_Property.Create( _Nom: String= '');
begin
     inherited CreateE( _Nom, TApplicationJoinPointFile_OpenAPI_Path_Verb_Property);
end;

destructor TslApplicationJoinPointFile_OpenAPI_Path_Verb_Property.Destroy;
begin
     inherited;
end;

class function TslApplicationJoinPointFile_OpenAPI_Path_Verb_Property.Classe_Iterateur: TIterateur_Class;
begin
     Result:= TIterateur_ApplicationJoinPointFile_OpenAPI_Path_Verb_Property;
end;

function TslApplicationJoinPointFile_OpenAPI_Path_Verb_Property.Iterateur: TIterateur_ApplicationJoinPointFile_OpenAPI_Path_Verb_Property;
begin
     Result:= TIterateur_ApplicationJoinPointFile_OpenAPI_Path_Verb_Property( Iterateur_interne);
end;

function TslApplicationJoinPointFile_OpenAPI_Path_Verb_Property.Iterateur_Decroissant: TIterateur_ApplicationJoinPointFile_OpenAPI_Path_Verb_Property;
begin
     Result:= TIterateur_ApplicationJoinPointFile_OpenAPI_Path_Verb_Property( Iterateur_interne_Decroissant);
end;

function TslApplicationJoinPointFile_OpenAPI_Path_Verb_Property.Create_JoinPointFile( _nfKey: String): TJoinPointFile_Ancetre;
begin
     Result:= TApplicationJoinPointFile_OpenAPI_Path_Verb_Property.Create( _nfKey);
end;

procedure TslApplicationJoinPointFile_OpenAPI_Path_Verb_Property.Initialise;
var
   I: TIterateur_ApplicationJoinPointFile_OpenAPI_Path_Verb_Property;
   jpf: TApplicationJoinPointFile_OpenAPI_Path_Verb_Property;
begin
     I:= Iterateur;
     try
        while I.Continuer
        do
          begin
          if I.not_Suivant( jpf) then Continue;
          jpf.Initialise;
          end;
     finally
            FreeAndNil( I);
            end;
end;

procedure TslApplicationJoinPointFile_OpenAPI_Path_Verb_Property.VisitePath_Verb_Property( _path: TPath; _verb: TVerb; _property: TVerb_Property);
var
   I: TIterateur_ApplicationJoinPointFile_OpenAPI_Path_Verb_Property;
   jpf: TApplicationJoinPointFile_OpenAPI_Path_Verb_Property;
begin
     I:= Iterateur;
     try
        while I.Continuer
        do
          begin
          if I.not_Suivant( jpf) then Continue;
          jpf.VisitePath_Verb_Property( _path, _verb,_property);
          end;
     finally
            FreeAndNil( I);
            end;
end;

procedure TslApplicationJoinPointFile_OpenAPI_Path_Verb_Property.Finalise;
var
   I: TIterateur_ApplicationJoinPointFile_OpenAPI_Path_Verb_Property;
   jpf: TApplicationJoinPointFile_OpenAPI_Path_Verb_Property;
begin
     I:= Iterateur;
     try
        while I.Continuer
        do
          begin
          if I.not_Suivant( jpf) then Continue;
          jpf.Finalise;
          end;
     finally
            FreeAndNil( I);
            end;
end;

procedure TslApplicationJoinPointFile_OpenAPI_Path_Verb_Property.To_Parametres(_sl: TStringList);
var
   I: TIterateur_ApplicationJoinPointFile_OpenAPI_Path_Verb_Property;
   jpf: TApplicationJoinPointFile_OpenAPI_Path_Verb_Property;
begin
     I:= Iterateur;
     try
        while I.Continuer
        do
          begin
          if I.not_Suivant( jpf) then Continue;
          jpf.To_Parametres( _sl);
          end;
     finally
            FreeAndNil( I);
            end;
end;

{ TApplicationJoinPointFile_OpenAPI_Path_Verb_Property }

constructor TApplicationJoinPointFile_OpenAPI_Path_Verb_Property.Create( _nfKey: String);
   procedure RemoveTrailing_LineEnding( var _s: String);
   var
      ls: Integer;
      lle: Integer;
   begin
        lle:= Length( LineEnding);
        ls := Length( _s);
        if ls < lle then exit;

        Delete( _s, ls-lle+1, lle);
   end;
   function s_from_nf( _nf: String):String;
   begin
        Result:= String_from_File( _nf);
        RemoveTrailing_LineEnding( Result);
   end;
begin
     nfKey       := _nfKey;
     nfBegin     := StringReplace( nfKey, s_key_, s_begin_     , [rfReplaceAll]);
     nfElement   := StringReplace( nfKey, s_key_, s_element_   , [rfReplaceAll]);
     nfSeparateur:= StringReplace( nfKey, s_key_, s_separateur_, [rfReplaceAll]);
     nfEnd       := StringReplace( nfKey, s_key_, s_end_       , [rfReplaceAll]);

     sKey       := s_from_nf( nfKey       );
     sBegin     := s_from_nf( nfBegin     );
     sElement   := s_from_nf( nfElement   );
     sSeparateur:= s_from_nf( nfSeparateur);
     sEnd       := s_from_nf( nfEnd       );

     Cle:= sKey;
end;

procedure TApplicationJoinPointFile_OpenAPI_Path_Verb_Property.Initialise;
begin
     inherited;
     Valeur:= sBegin;
     Premier:= True;
end;

procedure TApplicationJoinPointFile_OpenAPI_Path_Verb_Property.VisitePath_Verb_Property( _path: TPath; _verb: TVerb; _property: TVerb_Property);
var
   s: String;
begin
     inherited;
     if Premier
     then
         Premier:= False
     else
         Valeur:= Valeur + sSeparateur;

     s:= _property.Produit( 'Property.', sElement);
     s:= _verb    .Produit( 'Verb.'    , s       );
     s:= _path    .Produit( 'Path.'    , s       );

     Valeur:= Valeur+ s;
end;

procedure TApplicationJoinPointFile_OpenAPI_Path_Verb_Property.Finalise;
begin
     Valeur:= Valeur+sEnd;
     inherited;
end;

procedure TApplicationJoinPointFile_OpenAPI_Path_Verb_Property.To_Parametres(_sl: TStringList);
begin
     _sl.Values[ Cle]:= Valeur;
end;

end.
