unit uJPEG_File;
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
 Classes, SysUtils;

type

 { TJFIF_Header }

 TJFIF_Header
 =
  packed record
    Identifier: array [1..5] of char;
    JFIF_version: UINT16;
    Density_units: UINT8;
    Xdensity: UINT16;
    Ydensity: UINT16;
    Xthumbnail: Byte;
    Ythumbnail: Byte;
  end;

type
 { TJPEG_Segment }

 TJPEG_Segment
 =
  class
  //Gestion du cycle de vie
  public
    constructor Create( var _F: File; _Marker: Byte);
    destructor Destroy; override;
  //Marker
  public
    Marker: Byte;
    procedure Parse_Marker;
  //Libelle
  public
    Libelle: String;
  //Has_Length
  public
    Has_Length: Boolean;
  //Length
  public
    Longueur: Word;
  // Data
  public
    Data: String;
    procedure Parse_Data;
    function Affiche_Data: String;
  // Is_JFIF
  public
    Is_JFIF: Boolean;
  //JFIF
  public
    jfif: TJFIF_Header;
    sDensity_Units: String;
    procedure Parse_JFIF;
    function Affiche_JFIF: String;
  //Affichage
  public
    function Affichage: String;
  end;

 { TJPEG_File }
 type
  TJPEG_File
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
   //Markers
   public
     slMarkers: TStringList;
   //Affichage
   public
     function Affichage: String;
   end;

implementation

{ TJPEG_Segment }

constructor TJPEG_Segment.Create(var _F: File; _Marker: Byte);
  procedure ReadWord( var _w: Word);
  var
     Lu: Word;
  begin
       BlockRead( _F, _w, SizeOf(_w), Lu);
       _w:= swap( _w);
       if Lu = SizeOf(_w) then exit;

       _w:= 0;
  end;
  procedure ReadData;
  var
     DataLength: Integer;
     Lu: Word;
  begin
       DataLength:= Longueur-SizeOf(Longueur);
       SetLength( Data, DataLength);
       BlockRead( _F, Data[1], DataLength, Lu);
       SetLength( Data, Lu);
  end;
begin
     Marker := _Marker;
     Libelle:= '';
     Data   := '';
     Is_JFIF:= False;

     Parse_Marker;
     if not Has_Length then exit;

     ReadWord( Longueur);
     ReadData;
     Parse_Data;
end;

destructor TJPEG_Segment.Destroy;
begin
     inherited Destroy;
end;

procedure TJPEG_Segment.Parse_Marker;
    procedure T( _Has_Length: Boolean; _Libelle: String);
    begin
         Has_Length:= _Has_Length;
         Libelle   := _Libelle   ;
    end;
begin
     case Marker
     of
       $C0: T( True , 'Start Of Frame , Huffman coding, baseline DCT)'                        );
       $C1: T( True , 'Start Of Frame , Huffman coding, Extended sequential DCT)'             );
       $C2: T( True , 'Start Of Frame , Huffman coding, progressive DCT)'                     );
       $C3: T( True , 'Start Of Frame , Huffman coding, Lossless (sequential)'                );
       $C4: T( True , 'Define Huffman Table'                                                  );
       $C5: T( True , 'Start Of Frame , Huffman coding, Differential sequential DCT'          );
       $C6: T( True , 'Start Of Frame , Huffman coding, Differential progressive DCT'         );
       $C7: T( True , 'Start Of Frame , Huffman coding, Differential Lossless (sequential)'   );
       $C8: T( True , 'Start Of Frame , arithmetic coding, Reserved for JPEG Extensions'      );
       $C9: T( True , 'Start Of Frame , arithmetic coding, Extended Sequential DCT'           );
       $CA: T( True , 'Start Of Frame , arithmetic coding, Progressive DCT'                   );
       $CB: T( True , 'Start Of Frame , arithmetic coding, Lossless (sequential)'             );
       $CC: T( True , 'Define arithmetic coding conditionning(s)'                             );
       $CD: T( True , 'Start Of Frame , arithmetic coding, Differential sequential DCT'       );
       $CE: T( True , 'Start Of Frame , arithmetic coding, Differential progressive DCT'      );
       $CF: T( True , 'Start Of Frame , arithmetic coding, Differential Lossless (sequential)');
       $D0..$D7:
            T( False, 'Restart '+IntToStr(Marker and $7)                                      );
       $D8: T( False, 'Start Of Image'                                                        );
       $D9: T( False, 'End Of Image'                                                          );
       $DA: T( True , 'Start Of Scan'                                                         );
       $DB: T( True , 'Define Quantization Table'                                             );
       $DC: T( True , 'Define Number of Lines'                                                );
       $DD: T( True , 'Define Restart Interval'                                               );
       $DE: T( True , 'Define hierarchical progression'                                       );
       $DF: T( True , 'Expand reference components'                                           );//? Longueur
       $E0..$EF:
            T( True , 'Application-specific '+IntToStr(Marker and $F)                         );
       $F0..$FD:
            T( True, 'Reserved for JPEG extensions '+IntToStr(Marker and $F)                  );//? Longueur
       $FE: T( True , 'Comment'                                                               );
       end;
end;

procedure TJPEG_Segment.Parse_Data;
begin
     if '' = Data then exit;

     Is_JFIF:= 'JFIF'#0 = copy( Data, 1, 5);
     Parse_JFIF;
end;

function TJPEG_Segment.Affiche_Data: String;
var
   I: Integer;
   C: Char;
   sHexa: String;
   sC: String;
begin
     Result:= '';
     for I:= 1 to Length( Data)
     do
       begin
       C:= Data[I];
       sHexa:= IntToHex( Ord(C), 2);
       case C
       of
         #0..#31   : sC:= sHexa;
         #127..#255: sC:= sHexa;
         else        sC:= C;
         end;
       Formate_Liste( Result, ',', sC);
       end;
end;

procedure TJPEG_Segment.Parse_JFIF;
    procedure swap_byte( var _w: Word);
    var
       b1, b2: Byte;
    begin
         b1:= Hi( _w);
         b2:= Lo( _w);
         _w:= b2 shl 8 + b1;
    end;
begin
     if not Is_JFIF then exit;

     Move( data[1], jfif, SizeOf(jfif));
     jfif.JFIF_version:= swap( jfif.JFIF_version);
     jfif.Xdensity    := swap( jfif.Xdensity    );
     jfif.Ydensity    := swap( jfif.Ydensity    );

     case jfif.Density_units
     of
       0: sDensity_Units:= 'No units; width:height pixel aspect ratio = Xdensity:Ydensity';
       1: sDensity_Units:= 'Pixels per inch (2.54 cm)';
       2: sDensity_Units:= 'Pixels per centimeter';
       end;
end;

function TJPEG_Segment.Affiche_JFIF: String;
begin
     Result
     :=
        '  JFIF version '+IntToStr(Hi(jfif.JFIF_version))+'.'+IntToStr(Lo(jfif.JFIF_version))+'('+IntToHex(jfif.JFIF_version,4)+')'+#13#10
       +'  Density units: '+sDensity_Units+#13#10
       +'  X Density : '+IntToStr( jfif.Xdensity)+'('+IntToHex(jfif.Xdensity,4)+')'+#13#10
       +'  Y Density : '+IntToStr( jfif.Ydensity)+'('+IntToHex(jfif.Ydensity,4)+')'+#13#10
       +'  X thumbnail : '+IntToStr( jfif.Xthumbnail)+#13#10
       +'  Y thumbnail : '+IntToStr( jfif.Ythumbnail)+#13#10
       ;
end;

function TJPEG_Segment.Affichage: String;
begin
     Result:= 'Marker: '+IntToHex( Marker, 2)+' '+Libelle;
     if Has_Length then Result:= Result+', Length: '+IntToStr( Longueur);
     Result:= Result+#13#10'  Data:'+Affiche_Data+#13#10;
     if Is_JFIF
     then
         Result:= Result+ #13#10+Affiche_JFIF;

end;

{ TJPEG_File }

constructor TJPEG_File.Create( _NomFichier: String);
begin
     slMarkers:= TStringList.Create;

     NomFichier:= _NomFichier;
     AssignFile( F, NomFichier);
     Reset( F, 1);
     Parse_F;
end;

destructor TJPEG_File.Destroy;
begin
     CloseFile( F);
     FreeAndNil( slMarkers);
     inherited Destroy;
end;

procedure TJPEG_File.Parse_F;
var
   MarkerStart: Byte;
   Marker: Byte;
   s: TJPEG_Segment;
   procedure ReadByte( var _b: Byte);
   var
      Lu: Word;
   begin
        BlockRead( F, _b, SizeOf(_b), Lu);
        if Lu = SizeOf(_b) then exit;

        _b:= 0;
   end;
begin
     while not EOF( F)
     do
       begin
       ReadByte( MarkerStart);
       if $FF <> MarkerStart then continue;

       ReadByte( Marker);
       if ($00 = Marker) or ($FF = Marker)
       then
           begin
           Seek( F, FilePos( F)-SizeOf(Marker));
           continue;
           end;

       s:= TJPEG_Segment.Create( F, Marker);
       slMarkers.AddObject( s.Affichage, s);
       end;
end;

function TJPEG_File.Affichage: String;
begin
     Result:= slMarkers.Text;
end;

end.

