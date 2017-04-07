unit ufTest_Graphique;
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
    uJPEG_File,
    uPNG_File,
    uDimensions_from_pasjpeg,
    uDimensions_Image,
 Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
 FPimage,FPReadJPEG;

type

 { TfTest_Graphique }

 TfTest_Graphique = class(TForm)
  m: TMemo;
  procedure FormCreate(Sender: TObject);
 private
   procedure Infos_from_TJPEG_File;
   procedure Infos_from_TPNG_File;
   procedure Dimensions_from_TPicture;
   procedure Dimensions_from_TFPReaderJPEG;
   procedure Dimensions_from_pasjpeg;
   procedure Dimensions_Image_interne( _NomFichier: String);
   procedure Dimensions_Image;
   procedure Test;
 end;

var
 fTest_Graphique: TfTest_Graphique;

implementation

{$R *.lfm}

{ TfTest_Graphique }

procedure TfTest_Graphique.FormCreate(Sender: TObject);
begin
     Test;
end;

procedure TfTest_Graphique.Infos_from_TJPEG_File;
var
   jpeg_file: TJPEG_File;
begin
     jpeg_file:= TJPEG_File.Create( 'Test.jpg');
     try
        m.Lines.Add( jpeg_file.Affichage);
     finally
            FreeAndNil( jpeg_file);
            end;
end;

procedure TfTest_Graphique.Infos_from_TPNG_File;
var
   png_file: TPNG_File;
begin
     png_file:= TPNG_File.Create( 'Test.png', True);
     try
        m.Lines.Add( png_file.Affichage);
     finally
            FreeAndNil( png_file);
            end;
end;


procedure TfTest_Graphique.Dimensions_from_TPicture;
var
   p: TPicture;
begin
     p:= TPicture.Create;
     try
        p.LoadFromFile( 'Test.jpg');
        m.Lines.Add( 'Dimensions_from_TPicture:');
        m.Lines.Add( '  Largeur: '+ IntToStr( p.Width));
        m.Lines.Add( '  Hauteur: '+ IntToStr( p.Height));
     finally
            FreeAndNil( p);
            end;
end;

procedure TfTest_Graphique.Dimensions_from_TFPReaderJPEG;
var
   s: TFileStream;
   r: TFPReaderJPEG;
   i: TFPCustomImage;

begin
     r:= TFPReaderJPEG.Create;
     try
        s:= TFileStream.Create( 'Test.jpg', fmOpenRead);
        try
           i:= r.ImageRead( s, nil);
        finally
               FreeAndNil( s);
               end;
        m.Lines.Add( 'Dimensions_from_TFPReaderJPEG:');
        m.Lines.Add( '  Largeur: '+ IntToStr( i.Width));
        m.Lines.Add( '  Hauteur: '+ IntToStr( i.Height));
     finally
            FreeAndNil( r);
            end;
end;

procedure TfTest_Graphique.Dimensions_from_pasjpeg;
var
   d: TDimensions_from_pasjpeg;
begin
     d:= TDimensions_from_pasjpeg.Create( 'Test.jpg');
     try
        m.Lines.Add( 'Dimensions_from_pasjpeg:');
        m.Lines.Add( '  Largeur: '+ IntToStr( d.Width));
        m.Lines.Add( '  Hauteur: '+ IntToStr( d.Height));
        m.Lines.Add( '  Density_Units: '+ IntToStr( d.Density_units)+' '+d.sDensity_Units);
        m.Lines.Add( '  X Density : '+IntToStr( d.Xdensity));
        m.Lines.Add( '  Y Density : '+IntToStr( d.Ydensity));
        m.Lines.Add( '  svgWidth : '+d.svgWidth);
        m.Lines.Add( '  svgHeight: '+d.svgHeight);
        m.Lines.Add( d.Test_Formate_cm);
     finally
            FreeAndNil( d);
            end;
end;

procedure TfTest_Graphique.Dimensions_Image_interne(_NomFichier: String);
var
   d: TDimensions_Image;
begin
     d:= TDimensions_Image.Create( _NomFichier, '');
     try
        m.Lines.Add( 'Dimensions_Image_interne: '+_NomFichier);
        m.Lines.Add( '  svgWidth : '+d.svgWidth);
        m.Lines.Add( '  svgHeight: '+d.svgHeight);
     finally
            FreeAndNil( d);
            end;
end;

procedure TfTest_Graphique.Dimensions_Image;
begin
     Dimensions_Image_interne( 'Test.jpg');
     Dimensions_Image_interne( 'Test.png');
end;

procedure TfTest_Graphique.Test;
begin
     m.Text:= '';

     //Infos_from_TJPEG_File;

     //Dimensions_from_TPicture;
     //Dimensions_from_TFPReaderJPEG;
     //Dimensions_from_pasjpeg;

     //Infos_from_TPNG_File;
     Dimensions_Image;
end;

initialization
finalization
end.

