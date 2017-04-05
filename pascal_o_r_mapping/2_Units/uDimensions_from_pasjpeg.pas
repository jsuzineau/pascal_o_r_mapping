unit uDimensions_from_pasjpeg;
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
//développé à partir de FPReadJPEG.pas:TFPReaderJPEG.InternalRead

{$mode objfpc}{$H+}

interface

uses
    uuStrings,
 Classes, SysUtils, jpeglib,JDataSrc,JdAPImin;

type

 { TDimensions_from_pasjpeg }

 TDimensions_from_pasjpeg
 =
  class
  //Gestion du cycle de vie
  public
    constructor Create( _NomFichier: String);
    destructor Destroy; override;
  //Nom de fichier
  public
    NomFichier: String;
  //Calcul
  private
    function cm_from_pixel_density( _pixel: Integer; _density: Word): String;
    function Formate_cm( _cm: Double): String;
  public
    Width: Integer;
    Height: Integer;
    Density_units: Byte;
    Xdensity: Word;
    Ydensity: Word;
    procedure Calcul;
    function sDensity_Units: String;
    function svgWidth: String;
    function svgHeight: String;
    function Test_Formate_cm: String;
  end;

implementation

procedure JPEGError(CurInfo: j_common_ptr);
begin
  if CurInfo=nil then exit;
  raise Exception.CreateFmt('JPEG error',[CurInfo^.err^.msg_code]);
end;

procedure EmitMessage(CurInfo: j_common_ptr; msg_level: Integer);
begin
  if CurInfo=nil then exit;
  if msg_level=0 then ;
end;

procedure OutputMessage(CurInfo: j_common_ptr);
begin
  if CurInfo=nil then exit;
end;

procedure FormatMessage(CurInfo: j_common_ptr; var buffer: string);
begin
  if CurInfo=nil then exit;
  {$ifdef FPC_Debug_Image}
     writeln('FormatMessage ',buffer);
  {$endif}
end;

procedure ResetErrorMgr(CurInfo: j_common_ptr);
begin
  if CurInfo=nil then exit;
  CurInfo^.err^.num_warnings := 0;
  CurInfo^.err^.msg_code := 0;
end;

var
  jpeg_std_error: jpeg_error_mgr;

{ TDimensions_from_pasjpeg }

constructor TDimensions_from_pasjpeg.Create( _NomFichier: String);
begin
     NomFichier:= _NomFichier;
     Calcul;
end;

destructor TDimensions_from_pasjpeg.Destroy;
begin
     inherited Destroy;
end;

procedure TDimensions_from_pasjpeg.Calcul;
var
   s: TFileStream;
   jem: jpeg_error_mgr;
   jds: jpeg_decompress_struct;
   procedure SetSource;
   begin
        s.Position:=0;
        jpeg_stdio_src(@jds, @s);
   end;
   procedure ReadHeader;
   begin
        jpeg_read_header(@jds, TRUE);
        Width := jds.image_width;
        Height := jds.image_height;
        Density_units:= jds.density_unit;
        Xdensity:= jds.X_density;
        Ydensity:= jds.Y_density;
        //FGrayscale := jds.jpeg_color_space = JCS_GRAYSCALE;
        //FProgressiveEncoding := jpeg_has_multiple_scans(@jds);
   end;
begin
     s:= TFileStream.Create( NomFichier, fmOpenRead);
     try
        jem:=jpeg_std_error;
        jds.err := @jem;
        jpeg_CreateDecompress(@jds, JPEG_LIB_VERSION, SizeOf(jds));
        try
          //FProgressMgr.pub.progress_monitor := @ProgressCallback;
          //FProgressMgr.instance := Self;
          //jds.progress := @FProgressMgr.pub;
          jds.progress := nil;
          SetSource;
          ReadHeader;
        finally
          jpeg_Destroy_Decompress(@jds);
        end;
     finally
            FreeAndNil( s);
            end;
end;

function TDimensions_from_pasjpeg.sDensity_Units: String;
begin
     Result:= '';
     case Density_units
     of
       0: sDensity_Units:= 'No units; width:height pixel aspect ratio = Xdensity:Ydensity';
       1: sDensity_Units:= 'Pixels per inch (2.54 cm)';
       2: sDensity_Units:= 'Pixels per centimeter';
       end;
end;

function TDimensions_from_pasjpeg.Formate_cm( _cm: Double): String;
var
   nCM: Integer;
   nFracCM: Integer;
begin
     nCM    := Trunc( Int (_cm)       );
     nFracCM:= Trunc( Frac(_cm) * 1000);
     Result:= Format( '%d.%.3dcm',[ nCM, nFracCM]);
end;

function TDimensions_from_pasjpeg.Test_Formate_cm: String;
    procedure T( _cm: Double);
    begin
      Formate_Liste( Result, #13#10, '  '+FloatToStr( _cm)+' => '+Formate_cm( _cm));
    end;
begin
     Result:= 'Test '+ClassName+'.Test_Formate_cm';
     T(1);
     T(1.2);
     T(1.23);
     T(1.234);
     T(1.2345);
     T(21.234);
     T(321.234);
end;

function TDimensions_from_pasjpeg.cm_from_pixel_density( _pixel: Integer; _density: Word): String;
var
   inch, cm: Double;
   procedure inch_from_;
   begin
        inch:= _pixel / _density;
   end;
   procedure cm_from_;
   begin
        cm:= _pixel / _density;
   end;
   procedure cm_from_inch;
   begin  // Pixels per inch (2.54 cm)
        cm:= inch * 2.54;
   end;
   procedure Traite_inch;
   begin
        inch_from_;
        cm_from_inch;
   end;
   procedure Traite_No_Units;
   begin
        _density:= 72;//moyenne pour un écran
        Traite_inch;
   end;
   procedure Traite_cm;
   begin
        cm_from_;
   end;
begin
     case Density_units
     of
       0: Traite_No_Units;// No units; width:height pixel aspect ratio = Xdensity:Ydensity
       1: Traite_inch    ;// Pixels per inch (2.54 cm)
       2: Traite_cm      ;// Pixels per centimeter
       else cm:= 1;
       end;
     Result:= Formate_cm( cm);
end;

function TDimensions_from_pasjpeg.svgWidth: String;
begin
     Result:= cm_from_pixel_density( Width, Xdensity);
end;

function TDimensions_from_pasjpeg.svgHeight: String;
begin
     Result:= cm_from_pixel_density( Height, Ydensity);
end;

initialization
              with jpeg_std_error
              do
                begin
                error_exit:=@JPEGError;
                emit_message:=@EmitMessage;
                output_message:=@OutputMessage;
                format_message:=@FormatMessage;
                reset_error_mgr:=@ResetErrorMgr;
                end;
finalization
end.

