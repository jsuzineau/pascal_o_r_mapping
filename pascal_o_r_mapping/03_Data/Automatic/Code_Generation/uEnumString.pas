unit uEnumString;
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            http://www.mars42.com                          |
                                                                                |
    Copyright 2025 Jean SUZINEAU - MARS42                                       |
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
    uTypeMapping,//pour TContexteClasse_Ancetre
  SysUtils, Classes, FileUtil;

type

 { TEnumString }

 TEnumString
 =
  class( TStringList)
  public
  //cycle de vie
  public
    constructor Create( _nfEnumString: String);
  //Attributs
  public
    nfEnumString: String;
    sEnumString: String;
  public
    function Produit( _cc: TContexteClasse_Ancetre; _Prefixe, _sTypChamp_UPPERCASE, _sModele: String): String;
  end;

 TIterateur_EnumString
 =
  class( TIterateur)
  //Iterateur
  public
    procedure Suivant( var _Resultat: TEnumString);
    function  not_Suivant( var _Resultat: TEnumString): Boolean;
  end;

 { TslEnumString }

 TslEnumString
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
    function Iterateur: TIterateur_EnumString;
    function Iterateur_Decroissant: TIterateur_EnumString;
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

function EnumString_from_sl( sl: TBatpro_StringList; Index: Integer): TEnumString;
function EnumString_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TEnumString;

implementation

function EnumString_from_sl( sl: TBatpro_StringList; Index: Integer): TEnumString;
begin
     _Classe_from_sl( Result, TEnumString, sl, Index);
end;

function EnumString_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TEnumString;
begin
     _Classe_from_sl_sCle( Result, TEnumString, sl, sCle);
end;

{ TIterateur_EnumString }

function TIterateur_EnumString.not_Suivant( var _Resultat: TEnumString): Boolean;
begin
     Result:= not_Suivant_interne( _Resultat);
end;

procedure TIterateur_EnumString.Suivant( var _Resultat: TEnumString);
begin
     Suivant_interne( _Resultat);
end;

{ TslEnumString }

constructor TslEnumString.Create( _Nom: String= '');
begin
     inherited CreateE( _Nom, TEnumString);
end;

destructor TslEnumString.Destroy;
begin
     inherited;
end;

class function TslEnumString.Classe_Iterateur: TIterateur_Class;
begin
     Result:= TIterateur_EnumString;
end;

function TslEnumString.Iterateur: TIterateur_EnumString;
begin
     Result:= TIterateur_EnumString( Iterateur_interne);
end;

function TslEnumString.Iterateur_Decroissant: TIterateur_EnumString;
begin
     Result:= TIterateur_EnumString( Iterateur_interne_Decroissant);
end;

function TslEnumString.Produit(_cc: TContexteClasse_Ancetre; _Prefixe, _sTypChamp_UPPERCASE, _sModele: String): String;
var
   I: TIterateur_EnumString;
   tm: TEnumString;
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


{ TEnumString }

constructor TEnumString.Create(_nfEnumString: String);
var
   sl: TStringList;
   I: Integer;
   Name, Value: String;
   EnumStrings_prefix: String;
   EnumStrings_Name: String;
begin
     inherited Create;
     nfEnumString:= _nfEnumString;
     LoadFromFile( nfEnumString);
     sEnumString:= ChangeFileExt( ExtractFileName( nfEnumString), '');
     //Mapped_Type_
end;

function TEnumString.Produit( _cc: TContexteClasse_Ancetre;
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
     Key:= _Prefixe+'Mapped_Type_'+sEnumString;
     sMapped_Type:= Mapped_Type_from_sTypChamp_UPPERCASE;
     Result:= StringReplace( _sModele, Key, sMapped_Type, [rfReplaceAll,rfIgnoreCase]);
end;

end.
