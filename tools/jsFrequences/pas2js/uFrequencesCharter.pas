{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            http://www.mars42.com                                               |
                                                                                |
    Copyright 2020 Jean SUZINEAU - MARS42                                       |
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
unit uFrequencesCharter;

{$mode objfpc}
{$MODESWITCH EXTERNALCLASS}

interface

uses
    uFrequence,
    uFrequences,
    uCouleur,
 Classes, SysUtils, JS, Web, Math, ChartJS, Types, strutils;

type
 { TFrequencesCharter }

 TFrequencesCharter
 =
  class
  //Gestion du cycle de vie
  public
    constructor Create;
    destructor Destroy; override;
  //Attributs
  private
   config: TChartConfiguration;
   Octave: Integer;
   NbOctaves: Integer;
   Coherent_Boundaries, DeCoherent_Boundaries: TDoubleDynArray;
   Coherent_Centers, DeCoherent_Centers: TDoubleDynArray;
   bleu: String;
   gris, vert: String;
   gris_fonce, vert_fonce: String;
   slCanvas: TStringList;
  //Méthodes
  private
   function Low_Frequency_Boundary: Double;
   function High_Frequency_Boundary: Double;
   procedure Push_dataset( _Name, _Color, _BkColor: String; _y: JSValue; _Data: TDoubleDynArray);
   procedure Axes;
   procedure Cree_Options;
   procedure Plugin_annotation_box( _XMin, _XMax, _YMin, _YMax: double; _Color: String);
   procedure Plugin_annotation_line(_Value: double; _label_position: string='center'; _Note_index: Integer=-1; _Background_Color: String='rgba(128, 128, 255, 50)');
   procedure Plugin_annotations(_Centers, _Boundaries: TDoubleDynArray;
    _Box_Color, _Line_Color: String; _Frequence_Note_: Boolean;
 _label_on_top: Boolean; _iDebut: Integer);
   procedure Bandes_from_Octave(_Octave, _NbOctaves: Integer;
    _Frequence_Note_: Boolean; _iDebut: Integer=-1; _iFin: Integer=-1);
   procedure Cree_Chart( _Canvas_Name: String);
   procedure Dimensionne_Canvas( _Canvas_Name: String);
  public
    procedure Draw_Chart_from_Octave(_Octave: Integer; _Canvas_Name: String;
     _NbOctaves: Integer=1; _Frequence_Note_: Boolean=True; _iDebut: Integer=-
 1; _iFin: Integer=-1);
    procedure Draw_Chart_from_Frequence(_Libelle: String; _Frequence: double; _Canvas_Name: String; _NbOctaves: Integer=1; _Frequence_Note_: Boolean=True);
    procedure Draw_Chart_from_Frequences(_Octave, _NbOctaves: Integer;
     _Libelle: String; _Frequences: TDoubleDynArray; _Canvas_Name: String;
 _iDebut: Integer=-1; _iFin: Integer=-1);
  end;

function FrequencesCharter: TFrequencesCharter;

type
 TChartOptions_annotation_annotations
 =
  class external name 'Object' (TJSObject)
   drawTime       : string;
   type_          : string external name 'type';
   xScaleID       : string;
   yScaleID       : string;
   xMin           : JSValue;
   xMax           : JSValue;
   yMin           : JSValue;
   yMax           : JSValue;
   backgroundColor: string;
   borderColor    : string;
   borderWidth    : Integer;
 end;

 TChartOptions_annotation_annotations_line_label
  =
  class external name 'Object' (TJSObject)
   backgroundColor: string;
   fontFamily: string;
   fontSize  : string;
   fontStyle : string;
   fontColor : string;
   xPadding  : integer;
   yPadding  : integer;
   cornerRadius: integer;
   position: string;
   xAdjust  : integer;
   yAdjust  : integer;
   enabled: Boolean;
   content: String;
   rotation: integer;
  end;

 TChartOptions_annotation_annotations_line
 =
  class external name 'Object' (TJSObject)
   drawTime       : string;
   type_          : string external name 'type';
   mode           : String;
   scaleID        : string;
   value          : JSValue;
   endValue       : JSValue;
   borderColor    : string;
   borderWidth    : Integer;
   label_: TChartOptions_annotation_annotations_line_label external name 'label';
 end;

 TChartOptions_annotation
 =
 class external name 'Object' (TJSObject)
  annotations: TJSArray;
 end;

 TChartOptions_with_annotation
 =
  class external name 'Object' (TChartOptions)
   annotation: TChartOptions_annotation;
  end;


implementation

var
   FFrequencesCharter: TFrequencesCharter= nil;

function FrequencesCharter: TFrequencesCharter;
begin
     if nil = FFrequencesCharter
     then
         FFrequencesCharter:= TFrequencesCharter.Create;

     Result:= FFrequencesCharter;
end;

{ TFrequencesCharter }

constructor TFrequencesCharter.Create;
begin
     slCanvas:= TStringList.Create;
end;

destructor TFrequencesCharter.Destroy;
begin
     FreeAndNil( slCanvas);
     inherited Destroy;
end;

function TFrequencesCharter.Low_Frequency_Boundary: Double;
begin
     Result:= DeCoherent_Boundaries[Low(DeCoherent_Boundaries)];
end;

function TFrequencesCharter.High_Frequency_Boundary: Double;
begin
     Result:= Coherent_Boundaries[High(Coherent_Boundaries)];
end;

procedure TFrequencesCharter.Push_dataset( _Name, _Color, _BkColor: String; _y: JSValue; _Data: TDoubleDynArray);
var
   dataset: TChartScatterDataset;
   procedure Push_Data;
   var
      I: Integer;
   begin
        for I:= Low(_Data) to High(_Data)
        do
          dataset.data_.push( TChartXYData.new(_Data[I],_y));
   end;
begin
     dataset:= TChartScatterDataset.new;
     dataset.label_ := _Name;
     dataset.borderColor := _Color;
     dataset.backgroundColor := _BkColor;
     dataset.showLine:= False;
     dataset.data_:= TJSArray.new;
     Push_Data;
     config.data.datasets_.push(dataset);
end;

procedure TFrequencesCharter.Axes;
var
   x: TChartScaleCartesian;
   y: TChartScaleCartesian;
begin
     x := TChartScaleCartesian.new;
     x.type_ := 'linear';
     //x.type_ := 'logarithmic';
     x.id    := 'x-axis-0';
     asm
     x.ticks=
       {
       callback:
         function(value, index, values)
           {
           console.log( value);
           if (rtl.isNumber(value))
             {
             return pas.uFrequence.sFrequence(value,6," ",true);
             }
           else
             {
             return value;
             }
           }
       }
     end;
         ;
     y := TChartScaleCartesian.new;
     y.type_ := 'linear';
     y.id    := 'y-axis-0';
     asm
     y.ticks=
     //ticks:
       {
       // Include a dollar sign in the ticks
       callback:
         function(value, index, values)
           {
           return " ";
           }
       }
     end;

     config.options.scales := TChartScalesConfiguration.new;
     config.options.scales.xAxes_ := TJSArray.new(x);
     config.options.scales.yAxes_ := TJSArray.new(y);
end;

procedure TFrequencesCharter.Cree_Options;
var
   oa: TChartOptions_annotation;
   o: TChartOptions_with_annotation;
begin
     oa:= TChartOptions_annotation.new;
     oa.annotations:= TJSArray.new;
     o:= TChartOptions_with_annotation.new;
     o.annotation:= oa;

     config.options:= o;
     Axes;
end;

procedure TFrequencesCharter.Plugin_annotation_box( _XMin, _XMax, _YMin, _YMax: double; _Color: String);
var
   a: TChartOptions_annotation_annotations;
begin
     a:= TChartOptions_annotation_annotations.new;
     a.drawTime       := 'beforeDatasetsDraw';
     a.type_          := 'box';
     a.xScaleID       := 'x-axis-0';
     a.yScaleID       := 'y-axis-0';
     a.xMin           := _XMin;
     a.xMax           := _XMax;
     a.yMin           := _YMin;
     a.yMax           := _YMax;
     a.backgroundColor:= _Color;
     a.borderColor    := _Color;
     a.borderWidth    := 1;

     TChartOptions_with_annotation(config.options).annotation.annotations.push( a);
end;

procedure TFrequencesCharter.Plugin_annotation_line(_Value: double; _label_position: string= 'center'; _Note_index: Integer=-1; _Background_Color: String= 'rgba(128, 128, 255, 50)');
var
   a: TChartOptions_annotation_annotations_line;
begin
     a:= TChartOptions_annotation_annotations_line.new;
     a.drawTime       := 'beforeDatasetsDraw';
     a.type_          := 'line';
     a.mode           := 'vertical';
     a.ScaleID        := 'x-axis-0';
     a.value          := _Value;
     a.borderColor    := 'black';
     a.borderWidth    := 1;
     a.label_:= TChartOptions_annotation_annotations_line_label.new;
     //a.label_.backgroundColor:= 'rgba(128, 128, 255, 50)';
     a.label_.backgroundColor:= _Background_Color;
     //a.label_.content:= FloatToStr( _Value);
     if -1 = _Note_index
     then
         a.label_.content:= uFrequence.sFrequence( _Value, 6, ' ', False)
     else
         a.label_.content:= Note_Latine( _Note_index);
     a.label_.position:= _label_position;
     a.label_.enabled:= true;

     TChartOptions_with_annotation(config.options).annotation.annotations.push( a);
end;

procedure TFrequencesCharter.Plugin_annotations( _Centers, _Boundaries: TDoubleDynArray; _Box_Color, _Line_Color: String;
                                                 _Frequence_Note_: Boolean; _label_on_top: Boolean;
                                                 _iDebut: Integer);
var
   iDebut: Integer;
   I2, I, L, L2: Integer;
   V1, V2, C: double;
   label_position: String;
   Visible_ydebut, Visible_yfin: double;
begin
     iDebut:= IfThen( -1 = _iDebut, 0,  _iDebut);
     L:= Length( _Boundaries);
     L2:= L div 2;
     for I2:= 0 to L2-1
     do
       begin
       I:= Low( _Boundaries)+2*I2;
       V1:= _Boundaries[I+0];
       V2:= _Boundaries[I+1];
       C := _Centers   [I2 ];
       label_position:= IfThen( _label_on_top, 'top', 'bottom');
       if _label_on_top
       then
           begin
           Visible_ydebut:= 2.2;
           Visible_yfin  := 2.6;
           end
       else
           begin
           Visible_ydebut:= 1.2;
           Visible_yfin  := 1.6;
           end;
       //Writeln( _Color, ' ', V1, ' ', V2);
       Plugin_annotation_box( V1, V2, 1, 3, _Box_Color);
       if Is_Visible( V1, V2)
       then
           Plugin_annotation_box( V1, V2, Visible_ydebut, Visible_yfin, RGB_from_Frequency_rgba( C, 1));
       //WriteLn( 'I2:', I2,' I:',I,' C:',C);
       Plugin_annotation_line( C, label_position, IfThen(_Frequence_Note_,-1, iDebut+I2), _Line_Color);
       end;
end;

procedure TFrequencesCharter.Bandes_from_Octave( _Octave, _NbOctaves: Integer; _Frequence_Note_: Boolean;
                                                 _iDebut: Integer=-1; _iFin: Integer=-1);
begin
     Octave   := _Octave;
     NbOctaves:= _NbOctaves;

     bleu:= 'blue';
     //rouge:= 'rgba(255, 128, 128, 1)';
     gris      := 'rgba(192, 192, 192, 1)';
     gris_fonce:= 'rgba(128, 128, 128, 1)';
     vert      := 'rgba(128, 255, 128, 1)';
     vert_fonce:= 'rgba(  0, 192,   0, 1)';

       Coherent_Boundaries:= Frequences.  aCoherent_boundaries(Octave, NbOctaves, _iDebut, _iFin);
     DeCoherent_Boundaries:= Frequences.aDeCoherent_boundaries(Octave, NbOctaves, _iDebut, _iFin);
       Coherent_Centers:= Frequences.  aCoherent_centers(Octave, NbOctaves, _iDebut, _iFin);
     DeCoherent_Centers:= Frequences.aDeCoherent_centers(Octave, NbOctaves, _iDebut, _iFin);
     Log_Frequences( 'Coherent_Boundaries', Coherent_Boundaries);
     Log_Frequences( 'DeCoherent_Boundaries', DeCoherent_Boundaries);
     Log_Frequences( 'Coherent_Centers', Coherent_Centers);
     Log_Frequences( 'DeCoherent_Centers', DeCoherent_Centers);

     config := TChartConfiguration.new;
     config.type_ := 'scatter';
     config.data := TChartData.new;
     Cree_Options;
     Plugin_annotations(   Coherent_Centers,   Coherent_Boundaries, vert, vert_fonce,_Frequence_Note_, True , _iDebut);
     Plugin_annotations( DeCoherent_Centers, DeCoherent_Boundaries, gris, gris_fonce,_Frequence_Note_, False, _iDebut);

     config.data.datasets_ := TJSArray.new;
     Push_dataset( 'Décohérentes' , gris, gris, 1, DeCoherent_Centers);
     Push_dataset( 'Cohérentes', vert , vert , 3,   Coherent_Centers);
end;

procedure TFrequencesCharter.Dimensionne_Canvas(_Canvas_Name: String);
var
   Canvas: TJSHTMLCanvasElement;
   dpr: double;
begin
     if -1 <> slCanvas.IndexOf( _Canvas_Name) then exit;

     slCanvas.Add( _Canvas_Name);

     dpr:= window.devicePixelRatio;
     Canvas:= TJSHTMLCanvasElement(document.getElementById(_Canvas_Name));
     Canvas.height:= Trunc(100*dpr);
end;

procedure TFrequencesCharter.Cree_Chart( _Canvas_Name: String);
begin
     Dimensionne_Canvas( _Canvas_Name);
     TChart.new( _Canvas_Name, config);
end;

procedure TFrequencesCharter.Draw_Chart_from_Octave( _Octave: Integer; _Canvas_Name: String; _NbOctaves: Integer=1;
                                                     _Frequence_Note_: Boolean= True;
                                                     _iDebut: Integer=-1; _iFin: Integer=-1);
begin
     Bandes_from_Octave( _Octave, _NbOctaves, _Frequence_Note_, _iDebut, _iFin);

     Cree_Chart( _Canvas_Name);
end;

procedure TFrequencesCharter.Draw_Chart_from_Frequence( _Libelle: String;
                                                        _Frequence: double; _Canvas_Name: String; _NbOctaves: Integer;
                                                        _Frequence_Note_: Boolean);
begin
     Bandes_from_Octave( Frequences.Octave_from_Frequence( _Frequence), _NbOctaves, _Frequence_Note_);

     Push_dataset( _Libelle, bleu, bleu, 2.5, [_Frequence]);

     Cree_Chart( _Canvas_Name);
end;

procedure TFrequencesCharter.Draw_Chart_from_Frequences( _Octave, _NbOctaves: Integer; _Libelle: String;
                                                        _Frequences: TDoubleDynArray; _Canvas_Name: String;
                                                        _iDebut: Integer=-1; _iFin: Integer=-1);
begin
     Bandes_from_Octave( _Octave, _NbOctaves, False, _iDebut, _iFin);
     Push_dataset( _Libelle, bleu, bleu, 2.5, _Frequences);

     Cree_Chart( _Canvas_Name);
end;

end.

