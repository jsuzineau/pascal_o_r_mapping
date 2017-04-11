unit uPNG_File;
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

 { TPNG_Data_IHDR }

 TPNG_Data_IHDR
 =
  packed record
    Width             : Cardinal;//4 bytes
    Height            : Cardinal;//4 bytes
    Bit_depth 	      : Byte    ;//1 byte
    Colour_type       : Byte	;//1 byte
    Compression_method: Byte    ;//1 byte
    Filter_method     : Byte    ;//1 byte
    Interlace_method  : Byte    ;//1 byte
  end;

 { TPNG_Data_pHYs }
(*
Pixels per unit, X axis 	4 bytes (PNG unsigned integer)
Pixels per unit, Y axis 	4 bytes (PNG unsigned integer)
Unit specifier 	1 byte

The following values are defined for the unit specifier:
0 	unit is unknown
1 	unit is the metre

When the unit specifier is 0, the pHYs chunk defines pixel aspect ratio only; the actual size of the pixels remains unspecified.

If the pHYs chunk is not present, pixels are assumed to be square, and the physical size of each pixel is unspecified.
*)
 TPNG_Data_pHYs
 =
  packed record
    Xdensity: Cardinal;
    Ydensity: Cardinal;
    Density_units: Byte;
  end;

type
 { TPNG_Chunk }

 TPNG_Chunk
 =
  class
  //Gestion du cycle de vie
  public
    constructor Create( var _F: File; _Length: Cardinal);
    destructor Destroy; override;
  //Length
  public
    Length_: Cardinal;
  //Type
  public
    Type_: String;
    Type_Libelle: String;
    procedure Parse_Type;
  // Data
  public
    Data: TBytes;
    function Affiche_Data: String;
  //CRC
  public
    CRC: Cardinal;
  //is_IHDR
  public
    is_IHDR: Boolean;
  //S
  private
   function S(_Libelle: String; _Valeur: Integer): String;
  //IHDR
  public
    IHDR: TPNG_Data_IHDR;
    function Affiche_IHDR: String;
  //is_pHYs
  public
    is_pHYs: Boolean;
  //pHYs
  public
    pHYs: TPNG_Data_pHYs;
    function Affiche_pHYs: String;
  //is_IDAT
  public
    is_IDAT: Boolean;
  //Affichage
  public
    function Affichage: String;
  end;

 TIterateur_PNG_Chunk
 =
  class( TIterateur)
  //Iterateur
  public
    procedure Suivant( out _Resultat: TPNG_Chunk);
    function  not_Suivant( out _Resultat: TPNG_Chunk): Boolean;
  end;

 TslPNG_Chunk
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
    function Iterateur: TIterateur_PNG_Chunk;
    function Iterateur_Decroissant: TIterateur_PNG_Chunk;
  end;

 { TPNG_File }
 type
  TPNG_File
  =
   class
   //Gestion du cycle de vie
   public
     constructor Create( _NomFichier: String; _Only_Read_Dimensions: Boolean);
     destructor Destroy; override;
   //NomFichier
   public
     NomFichier: String;
   //Only_Read_Dimensions
   public
     Only_Read_Dimensions: Boolean;
   //F
   public
     F: File;
     procedure Parse_F;
   //Is_PNG (vérification de la signature)
   public
     Is_PNG: Boolean;
     procedure Verifie_signature;
   //Chunks
   public
     slChunks: TslPNG_Chunk;
   //IHDR
   public
     Has_IHDR: Boolean;
     IHDR: TPNG_Data_IHDR;
   public
     Has_pHYs: Boolean;
     pHYs: TPNG_Data_pHYs;
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

procedure ReadCardinal_BEtoN( var _F: File; out _c: Cardinal);
var
   Lu: Word;
begin
     BlockRead( _F, _c, SizeOf(_c), Lu);
     _c:= BEtoN( _c);
     if Lu = SizeOf(_c) then exit;

     _c:= 0;
end;

function Binary_String( _b: TBytes): String; overload;
var
   I: Integer;
   C: Byte;
   sHexa: String;
   sC: String;
begin
     Result:= '';
     for I:= Low(_b) to High(_b)
     do
       begin
       C:= _b[I];
       sHexa:= IntToHex( C, 2);
       case C
       of
         0..31   : sC:= sHexa;
         127..255: sC:= sHexa;
         else      sC:= chr( C);
         end;
       Formate_Liste( Result, ',', sC);
       end;
end;

function Binary_String( _S: String): String; overload;
var
   I: Integer;
   C: Char;
   sHexa: String;
   sC: String;
begin
     Result:= '';
     for I:= 1 to Length(_S)
     do
       begin
       C:= _S[I];
       sHexa:= IntToHex( Ord(C), 2);
       case C
       of
         #0..#31   : sC:= sHexa;
         #127..#255: sC:= sHexa;
         else      sC:= C;
         end;
       Formate_Liste( Result, ',', sC);
       end;
end;

{ TPNG_Chunk }

constructor TPNG_Chunk.Create(var _F: File; _Length: Cardinal);
  procedure ReadType;
  var
     Lu: Word;
     Taille: Integer;
  begin
       Taille:= 4;
       SetLength( Type_, Taille);
       BlockRead( _F, Type_[1], Taille, Lu);
       if Lu = Taille then exit;

       Type_:= 'Erreur:'+Type_;
  end;
  procedure ReadData;
  var
     Lu: Word;
  begin
       SetLength( Data, Length_);
       //if is_IDAT then dec(Length_,4);//bidouille provisoire
       BlockRead( _F, Data[0], Length_, Lu);
       SetLength( Data, Lu);
  end;
  procedure ReadIHDR;
  var
     Lu: Word;
     Taille: Integer;
  begin
       Taille:= SizeOf( IHDR);
       BlockRead( _F, IHDR, Taille, Lu);
       IHDR.Width := BEtoN( IHDR.Width );
       IHDR.Height:= BEtoN( IHDR.Height);
       if Lu = Taille then exit;

       IHDR.Width := 0;
       IHDR.Height:= 0;
  end;
  procedure ReadpHYs;
  var
     Lu: Word;
     Taille: Integer;
  begin
       Taille:= SizeOf( pHYs);
       BlockRead( _F, pHYs, Taille, Lu);
       pHYs.Xdensity := BEtoN( pHYs.Xdensity );
       pHYs.Ydensity := BEtoN( pHYs.Ydensity );
       if Lu = Taille then exit;

       pHYs.Xdensity:= 1;
       pHYs.Ydensity:= 1;
  end;
begin
     Length_ := _Length;


     SetLength( Data, 0);

     ReadType;
     Parse_Type;
          if is_IHDR then ReadIHDR
     else if is_pHYs then ReadpHYs
     else                 ReadData;
     ReadCardinal_BEtoN( _F, CRC);
end;

destructor TPNG_Chunk.Destroy;
begin
     inherited Destroy;
end;

procedure TPNG_Chunk.Parse_Type;
begin
     is_IHDR:= ('IHDR' = Type_) and (Length_ = SizeOf( IHDR));
     is_pHYs:= ('pHYs' = Type_) and (Length_ = SizeOf( pHYs));
     is_IDAT:= ('IDAT' = Type_);
     Type_Libelle:= Binary_String( Type_);
end;

function TPNG_Chunk.S( _Libelle: String; _Valeur: Integer): String;
begin
     Result:= _Libelle+': '+IntToStr( _Valeur);
end;

function TPNG_Chunk.Affiche_IHDR: String;
begin
     Result:= 'IHDR:';
     Formate_Liste_Indentation( Result, #13#10, '  ', S( 'Width             ', IHDR.Width             ));
     Formate_Liste_Indentation( Result, #13#10, '  ', S( 'Height            ', IHDR.Height            ));
     Formate_Liste_Indentation( Result, #13#10, '  ', S( 'Bit_depth 	    ', IHDR.Bit_depth 	       ));
     Formate_Liste_Indentation( Result, #13#10, '  ', S( 'Colour_type       ', IHDR.Colour_type       ));
     Formate_Liste_Indentation( Result, #13#10, '  ', S( 'Compression_method', IHDR.Compression_method));
     Formate_Liste_Indentation( Result, #13#10, '  ', S( 'Filter_method     ', IHDR.Filter_method     ));
     Formate_Liste_Indentation( Result, #13#10, '  ', S( 'Interlace_method  ', IHDR.Interlace_method  ));
end;

function TPNG_Chunk.Affiche_pHYs: String;
begin
     Result:= 'pHYs:';
     Formate_Liste_Indentation( Result, #13#10, '  ', S( 'Xdensity     ', pHYs.Xdensity));
     Formate_Liste_Indentation( Result, #13#10, '  ', S( 'Ydensity     ', pHYs.Ydensity));
     Formate_Liste_Indentation( Result, #13#10, '  ', S( 'Density_units', pHYs.Density_units));
end;

function TPNG_Chunk.Affiche_Data: String;
begin
     Result:= 'Data:'+Binary_String( Data);
end;

function TPNG_Chunk.Affichage: String;
var
   Valeur: String;
begin
     Result:= 'Type: '+Type_Libelle;
     Formate_Liste_Indentation( Result, #13#10, '  ', 'Length  : '+IntToStr(Length_));

          if is_IHDR then Valeur:= Affiche_IHDR
     else if is_pHYs then Valeur:= Affiche_pHYs
     else                 Valeur:= Affiche_Data;

     Formate_Liste_Indentation( Result, #13#10, '  ', Valeur);
end;

{ TIterateur_PNG_Chunk }

function TIterateur_PNG_Chunk.not_Suivant( out _Resultat: TPNG_Chunk): Boolean;
begin
     Result:= not_Suivant_interne( _Resultat);
end;

procedure TIterateur_PNG_Chunk.Suivant( out _Resultat: TPNG_Chunk);
begin
     Suivant_interne( _Resultat);
end;

{ TslPNG_Chunk }

constructor TslPNG_Chunk.Create( _Nom: String= '');
begin
     inherited CreateE( _Nom, TPNG_Chunk);
end;

destructor TslPNG_Chunk.Destroy;
begin
     inherited;
end;

class function TslPNG_Chunk.Classe_Iterateur: TIterateur_Class;
begin
     Result:= TIterateur_PNG_Chunk;
end;

function TslPNG_Chunk.Iterateur: TIterateur_PNG_Chunk;
begin
     Result:= TIterateur_PNG_Chunk( Iterateur_interne);
end;

function TslPNG_Chunk.Iterateur_Decroissant: TIterateur_PNG_Chunk;
begin
     Result:= TIterateur_PNG_Chunk( Iterateur_interne_Decroissant);
end;

{ TPNG_File }

constructor TPNG_File.Create( _NomFichier: String; _Only_Read_Dimensions: Boolean);
begin
     NomFichier          := _NomFichier;
     Only_Read_Dimensions:= _Only_Read_Dimensions;

     Has_IHDR:= False;
     Has_pHYs:= False;
     pHYs.Density_units:= 0;
     pHYs.Xdensity:= 0;
     pHYs.Ydensity:= 0;

     slChunks:= TslPNG_Chunk.Create(ClassName+'.slChunks');

     AssignFile( F, NomFichier);
     Reset( F, 1);
     Parse_F;
end;

destructor TPNG_File.Destroy;
begin
     CloseFile( F);
     FreeAndNil( slChunks);
     inherited Destroy;
end;

procedure TPNG_File.Parse_F;
var
   Length: Cardinal;
   c: TPNG_Chunk;
begin
     Verifie_signature;
     if not Is_PNG then exit;

     while not EOF( F)
     do
       begin

       ReadCardinal_BEtoN( F, Length);

       c:= TPNG_Chunk.Create( F, Length);
       slChunks.AddObject( c.Type_, c);

       if c.is_IHDR
       then
           begin
           IHDR:= c.IHDR;
           Has_IHDR:= True;
           end;
       if c.is_pHYs
       then
           begin
           pHYs:= c.pHYs;
           Has_pHYs:= True;
           Normalise_Density;
           end;
       if Only_Read_Dimensions and Has_IHDR and Has_pHYs then break;
       end;
     if not Has_pHYs
     then
         begin
         Has_pHYs:= True;
         Normalise_Density;
         end;
end;

procedure TPNG_File.Verifie_signature;
var
   b: array[1..8] of Byte;
   Taille, Lu: Integer;
begin
     Is_PNG:= False;

     Taille:= SizeOf(b);
     BlockRead( F, b, Taille, Lu);
     if Lu <> Taille then exit;

     if
          (b[1] <> $89)
       or (b[2] <> $50) //P
       or (b[3] <> $4E) //N
       or (b[4] <> $47) //G
       or (b[5] <> $0D) //<CR>
       or (b[6] <> $0A) //<LF>
       or (b[7] <> $1A) //<EOF>
       or (b[8] <> $0A) //<LF>
     then
         exit;

     Is_PNG:= True;
end;

procedure TPNG_File.Normalise_Density;
const
     //72 dpi, inch = 2.54 cm
     Xdensity_72dpi= (72/2.54)*100;
     procedure Cas_XDensity_Zero;
     begin  // pixel carrés, 72 dpi
          pHYs.Xdensity:= Trunc( Xdensity_72dpi);
          pHYs.Ydensity:= Trunc( Xdensity_72dpi);
          pHYs.Density_units:= 1;
     end;
     procedure Cas_General;
     var
        y_from_x: double;
     begin // 72 dpi en x, on ajuste en y selon le ratio
          y_from_x:= pHYs.Ydensity / pHYs.Xdensity;

          pHYs.Xdensity:= Trunc( Xdensity_72dpi);
          pHYs.Ydensity:= Trunc( y_from_x * pHYs.Xdensity);
          pHYs.Density_units:= 1;
     end;
begin
     if pHYs.Density_units = 1 then exit;

     if 0 = pHYs.Xdensity
     then
         Cas_XDensity_Zero
     else
         Cas_General;
end;

function TPNG_File.Affichage: String;
var
   I: TIterateur_PNG_Chunk;
   c: TPNG_Chunk;
begin
     Result:= ClassName+'.Affichage: '+NomFichier;
     I:= slChunks.Iterateur;
     while I.Continuer
     do
       begin
       if I.not_Suivant( c) then continue;

       Formate_Liste_Indentation( Result, #13#10, '  ',c.Affichage);
       end;
     Formate_Liste_Indentation( Result, #13#10, '  ', 'svgWidth : '+svgWidth);
     Formate_Liste_Indentation( Result, #13#10, '  ', 'svgHeight: '+svgHeight);
end;

function TPNG_File.Formate_cm( _cm: Double): String;
var
   nCM: Integer;
   nFracCM: Integer;
begin
     nCM    := Trunc( Int (_cm)       );
     nFracCM:= Trunc( Frac(_cm) * 1000);
     Result:= Format( '%d.%.3dcm',[ nCM, nFracCM]);
end;

function TPNG_File.cm_from_pixel_density( _pixel: Integer; _density: Word): String;
var
   m: double;
   cm: double;
begin
     m:= _pixel / _density;
     cm:= m*100;
     Result:= Formate_cm( cm);
end;

function TPNG_File.svgWidth: String;
begin
     Result:= '1cm';
     if not Has_IHDR then exit;
     if not Has_pHYs then exit;

     Result:= cm_from_pixel_density( ihdr.Width, pHYs.Xdensity);
end;

function TPNG_File.svgHeight: String;
begin
     Result:= '1cm';
     if not Has_IHDR then exit;
     if not Has_pHYs then exit;

     Result:= cm_from_pixel_density( ihdr.Height, pHYs.Ydensity);
end;


end.

