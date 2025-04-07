unit uTypeMapping;
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            http://www.mars42.com                          |
                                                                                |
    Copyright 2023 Jean SUZINEAU - MARS42                                       |
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
  SysUtils, Classes, FileUtil;

type

 { TContexteClasse_Ancetre }

 TContexteClasse_Ancetre
 =
  class
  //Recherche/remplacement par les valeurs dans un modèle
  public
    function Produit( _Prefixe, _sModele: String): String; virtual; abstract;
  end;

 { TTypeMapping }

 TTypeMapping
 =
  class( TStringList)
  public
  //cycle de vie
  public
    constructor Create( _nfTypeMapping: String);
  //Attributs
  public
    nfTypeMapping: String;
    sTypeMapping: String;
  public
    function Produit( _cc: TContexteClasse_Ancetre; _Prefixe, _sTypChamp_UPPERCASE, _sModele: String): String;
  end;

 TIterateur_TypeMapping
 =
  class( TIterateur)
  //Iterateur
  public
    procedure Suivant( var _Resultat: TTypeMapping);
    function  not_Suivant( var _Resultat: TTypeMapping): Boolean;
  end;

 { TslTypeMapping }

 TslTypeMapping
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
    function Iterateur: TIterateur_TypeMapping;
    function Iterateur_Decroissant: TIterateur_TypeMapping;
  public
    function Produit( _cc: TContexteClasse_Ancetre; _Prefixe, _sTypChamp_UPPERCASE, _sModele: String): String;
  end;



const
     s_key_       = '.01_key.'       ;
     s_begin_     = '.02_begin.'     ;
     s_element_   = '.03_element.'   ;
     s_separateur_= '.04_separateur.';
     s_end_       = '.05_end.'       ;

     s_key_mask='*'+s_key_+'*';

function TypeMapping_from_sl( sl: TBatpro_StringList; Index: Integer): TTypeMapping;
function TypeMapping_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TTypeMapping;

implementation

function TypeMapping_from_sl( sl: TBatpro_StringList; Index: Integer): TTypeMapping;
begin
     _Classe_from_sl( Result, TTypeMapping, sl, Index);
end;

function TypeMapping_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TTypeMapping;
begin
     _Classe_from_sl_sCle( Result, TTypeMapping, sl, sCle);
end;

{ TIterateur_TypeMapping }

function TIterateur_TypeMapping.not_Suivant( var _Resultat: TTypeMapping): Boolean;
begin
     Result:= not_Suivant_interne( _Resultat);
end;

procedure TIterateur_TypeMapping.Suivant( var _Resultat: TTypeMapping);
begin
     Suivant_interne( _Resultat);
end;

{ TslTypeMapping }

constructor TslTypeMapping.Create( _Nom: String= '');
begin
     inherited CreateE( _Nom, TTypeMapping);
end;

destructor TslTypeMapping.Destroy;
begin
     inherited;
end;

class function TslTypeMapping.Classe_Iterateur: TIterateur_Class;
begin
     Result:= TIterateur_TypeMapping;
end;

function TslTypeMapping.Iterateur: TIterateur_TypeMapping;
begin
     Result:= TIterateur_TypeMapping( Iterateur_interne);
end;

function TslTypeMapping.Iterateur_Decroissant: TIterateur_TypeMapping;
begin
     Result:= TIterateur_TypeMapping( Iterateur_interne_Decroissant);
end;

function TslTypeMapping.Produit(_cc: TContexteClasse_Ancetre; _Prefixe, _sTypChamp_UPPERCASE, _sModele: String): String;
var
   I: TIterateur_TypeMapping;
   tm: TTypeMapping;
begin
     Result:= _sModele;
     I:= Iterateur;
     try
        while I.Continuer
        do
          begin
          if I.not_Suivant( tm) then Continue;
          Result:= tm.Produit( _cc, _Prefixe, _sTypChamp_UPPERCASE, Result);
          end;
     finally
            FreeAndNil( I);
            end;
end;


{ TTypeMapping }

constructor TTypeMapping.Create(_nfTypeMapping: String);
var
   sl: TStringList;
   I: Integer;
   Name, Value: String;
   TypeMappings_prefix: String;
   TypeMappings_Name: String;
begin
     inherited Create;
     nfTypeMapping:= _nfTypeMapping;
     LoadFromFile( nfTypeMapping);
     sTypeMapping:= ChangeFileExt( ExtractFileName( nfTypeMapping), '');
     //Mapped_Type_
end;

function TTypeMapping.Produit( _cc: TContexteClasse_Ancetre;
                               _Prefixe,
                               _sTypChamp_UPPERCASE,
                               _sModele: String): String;
var
   Key: String;
   sMapped_Type: String;
   function Mapped_Type_from_sTypChamp_UPPERCASE: String;
   var
      I: Integer;
   begin
        I:= IndexOfName( _sTypChamp_UPPERCASE);
        if -1 = I
        then
            Result:= _sTypChamp_UPPERCASE
        else
            Result:= _cc.Produit( 'Classe.', ValueFromIndex[ I]);
   end;
begin
     Key:= _Prefixe+'Mapped_Type_'+sTypeMapping;
     sMapped_Type:= Mapped_Type_from_sTypChamp_UPPERCASE;
     Result:= StringReplace( _sModele, Key, sMapped_Type, [rfReplaceAll,rfIgnoreCase]);
end;

end.
