unit uDimensions_Image;
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            http://www.mars42.com                                               |
                                                                                |
    Copyright 2017 Jean SUZINEAU - MARS42                                       |
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

{$mode objfpc}{$H+}

interface

uses
    uLog,
    uuStrings,
    uBatpro_StringList,
    uDimensions_from_pasjpeg,
    uPNG_File,
 Classes, SysUtils;

type

 TDimensions_Image_Cas= (dic_jpeg, dic_png, dic_bmp, dic_unknown);

 { TDimensions_Image }

 TDimensions_Image
 =
  class
  //Gestion du cycle de vie
  public
    constructor Create( _NomFichier, _URL: String);
    destructor Destroy; override;
  //Nom de fichier
  public
    NomFichier: String;
    URL: String; //référence à l'intérieur de l'OpenDocument
  //Cas
  private
    jpeg: TDimensions_from_pasjpeg;
    png: TPNG_File;
  public
    Cas: TDimensions_Image_Cas;
  //Dimensions pour fichier ODT
  public
    function svgWidth: String;
    function svgHeight: String;
  end;

 TIterateur_Dimensions_Image
 =
  class( TIterateur)
  //Iterateur
  public
    procedure Suivant( var _Resultat: TDimensions_Image);
    function  not_Suivant( var _Resultat: TDimensions_Image): Boolean;
  end;

 TslDimensions_Image
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
    function Iterateur: TIterateur_Dimensions_Image;
    function Iterateur_Decroissant: TIterateur_Dimensions_Image;
  end;

function Dimensions_Image_from_sl( sl: TBatpro_StringList; Index: Integer): TDimensions_Image;
function Dimensions_Image_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TDimensions_Image;

implementation

function Dimensions_Image_from_sl( sl: TBatpro_StringList; Index: Integer): TDimensions_Image;
begin
     _Classe_from_sl( Result, TDimensions_Image, sl, Index);
end;

function Dimensions_Image_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TDimensions_Image;
begin
     _Classe_from_sl_sCle( Result, TDimensions_Image, sl, sCle);
end;

{ TIterateur_Dimensions_Image }

function TIterateur_Dimensions_Image.not_Suivant( var _Resultat: TDimensions_Image): Boolean;
begin
     Result:= not_Suivant_interne( _Resultat);
end;

procedure TIterateur_Dimensions_Image.Suivant( var _Resultat: TDimensions_Image);
begin
     Suivant_interne( _Resultat);
end;

{ TslDimensions_Image }

constructor TslDimensions_Image.Create( _Nom: String= '');
begin
     inherited CreateE( _Nom, TDimensions_Image);
end;

destructor TslDimensions_Image.Destroy;
begin
     inherited;
end;

class function TslDimensions_Image.Classe_Iterateur: TIterateur_Class;
begin
     Result:= TIterateur_Dimensions_Image;
end;

function TslDimensions_Image.Iterateur: TIterateur_Dimensions_Image;
begin
     Result:= TIterateur_Dimensions_Image( Iterateur_interne);
end;

function TslDimensions_Image.Iterateur_Decroissant: TIterateur_Dimensions_Image;
begin
     Result:= TIterateur_Dimensions_Image( Iterateur_interne_Decroissant);
end;


{ TDimensions_Image }

constructor TDimensions_Image.Create( _NomFichier, _URL: String);
var
   Extension: String;
begin
     NomFichier:= _NomFichier;
     URL       := _URL       ;
     jpeg:= nil;
     png := nil;

     Extension:= LowerCase( ExtractFileExt( _NomFichier));

          if '.jpg' = Extension then Cas:= dic_jpeg
     else if '.png' = Extension then Cas:= dic_png
     else if '.bmp' = Extension then Cas:= dic_bmp
     else                            Cas:= dic_unknown;

     case Cas
     of
       dic_jpeg: jpeg:= TDimensions_from_pasjpeg.Create( _NomFichier);
       dic_png : png := TPNG_File               .Create( _NomFichier, True);
       end;
end;

destructor TDimensions_Image.Destroy;
begin
     inherited Destroy;
end;

function TDimensions_Image.svgWidth: String;
begin
     case Cas
     of
       dic_jpeg: Result:= jpeg.svgWidth;
       dic_png : Result:= png .svgWidth;
       else      Result:= '';
       end;
end;

function TDimensions_Image.svgHeight: String;
begin
     case Cas
     of
       dic_jpeg: Result:= jpeg.svgHeight;
       dic_png : Result:= png .svgHeight;
       else      Result:= '';
       end;
end;

end.

