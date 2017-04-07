unit uBMP_File;
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
    uuStrings,
    uBatpro_StringList,
 Classes, SysUtils;

type


 { TBMP_Bitmap_File_Header }
 TBMP_Bitmap_File_Header
 =
  packed record
    header_field: array[1..2] of Char;
    filesize    : Cardinal;
    reserved1   : Word;
    reserved2   : Word;
    image_data_offset: Cardinal;
  end;

 { TBMP_BITMAPINFOHEADER }
 TBMP_BITMAPINFOHEADER
 =
  packed record
    Size        : Cardinal;
    Width       : Cardinal;
    Height      : Cardinal;
    ColorPlanes : Word;
    BitsPerPixel: Word;
    Compression : Cardinal;
    ImageSize   : Cardinal;
    Xdensity    : Cardinal;
    Ydensity    : Cardinal;
    ColorCount  : Cardinal;
    ColorImportant: Cardinal;
  end;

 { TBMP_File }
 type
  TBMP_File
  =
   class
   //Gestion du cycle de vie
   public
     constructor Create( _NomFichier: String);
     destructor Destroy; override;
   //NomFichier
   public
     NomFichier: String;
   //F
   public
     F: File;
     procedure Parse_F;
   //bfh
   public
     bfh: TBMP_Bitmap_File_Header;
     Has_BFH: Boolean;
   //Is_BMP (vérification de la signature)
   public
     Is_BMP: Boolean;
     procedure Verifie_signature;
   //bih
   public
     bih: TBMP_BITMAPINFOHEADER;
     Has_BIH: Boolean;
   //Normalise_Density
   public
     procedure Normalise_Density;
   //Affichage
   public
     function Affichage: String;
   //Dimensions pour fichier odt
   private
     function cm_from_pixel_density( _pixel: Integer; _density: Word): String;
     function Formate_cm( _cm: Double): String;
   public
     function svgWidth: String;
     function svgHeight: String;
   end;

implementation

{ TBMP_File }

constructor TBMP_File.Create( _NomFichier: String);
begin
     NomFichier          := _NomFichier;

     Has_BFH:= False;
     Has_BIH:= False;

     AssignFile( F, NomFichier);
     Reset( F, 1);
     Parse_F;
end;

destructor TBMP_File.Destroy;
begin
     CloseFile( F);
     inherited Destroy;
end;

procedure TBMP_File.Parse_F;
  procedure Read_BFH;
  var
     Lu: Word;
     Taille: Integer;
  begin
       Lu:= 0;
       Taille:= SizeOf( bfh);
       BlockRead( F, bfh, Taille, Lu);
       Has_BFH:= Taille= Lu;
  end;
  procedure Read_BIH;
  var
     Lu: Word;
     Taille: Integer;
  begin
       Lu:= 0;
       Taille:= SizeOf( bih);
       BlockRead( F, bih, Taille, Lu);
       Has_BIH:= Taille= Lu;
       Normalise_Density;
  end;
begin
     Read_BFH;
     Verifie_signature;
     if not Is_BMP then exit;

     Read_BIH;
end;

procedure TBMP_File.Verifie_signature;
begin
     Is_BMP
     :=
           (bfh.header_field[1]='B')
       and (bfh.header_field[2]='M');
end;

procedure TBMP_File.Normalise_Density;
const
     //72 dpi, inch = 2.54 cm
     Xdensity_72dpi= (72/2.54)*100;
begin
     if not Has_BIH then exit;

     if 0 = bih.Xdensity then bih.Xdensity:= Trunc( Xdensity_72dpi);
     if 0 = bih.Ydensity then bih.Ydensity:= Trunc( Xdensity_72dpi);
end;


function TBMP_File.Affichage: String;
begin
     Result:= ClassName+'.Affichage: '+NomFichier;
     if not Has_BFH then exit;

     if not Has_BIH then exit;

     Formate_Liste_Indentation( Result, #13#10, '  ', 'Width   : '+IntToStr(bih.Width   ));
     Formate_Liste_Indentation( Result, #13#10, '  ', 'Height  : '+IntToStr(bih.Height  ));
     Formate_Liste_Indentation( Result, #13#10, '  ', 'Xdensity: '+IntToStr(bih.Xdensity));
     Formate_Liste_Indentation( Result, #13#10, '  ', 'Ydensity: '+IntToStr(bih.Ydensity));

     Formate_Liste_Indentation( Result, #13#10, '  ', 'svgWidth : '+svgWidth);
     Formate_Liste_Indentation( Result, #13#10, '  ', 'svgHeight: '+svgHeight);
end;

function TBMP_File.Formate_cm( _cm: Double): String;
var
   nCM: Integer;
   nFracCM: Integer;
begin
     nCM    := Trunc( Int (_cm)       );
     nFracCM:= Trunc( Frac(_cm) * 1000);
     Result:= Format( '%d.%.3dcm',[ nCM, nFracCM]);
end;

function TBMP_File.cm_from_pixel_density( _pixel: Integer; _density: Word): String;
var
   m: double;
   cm: double;
begin
     m:= _pixel / _density;
     cm:= m*100;
     Result:= Formate_cm( cm);
end;

function TBMP_File.svgWidth: String;
begin
     Result:= '1';
     if not Has_BFH then exit;
     if not Has_BIH then exit;

     Result:= cm_from_pixel_density( bih.Width, bih.Xdensity);
end;

function TBMP_File.svgHeight: String;
begin
     Result:= '1';
     if not Has_BFH then exit;
     if not Has_BIH then exit;

     Result:= cm_from_pixel_density( bih.Height, bih.Ydensity);
end;


end.

