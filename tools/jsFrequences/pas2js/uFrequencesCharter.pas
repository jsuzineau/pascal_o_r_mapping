unit uFrequencesCharter;

{$mode objfpc}
{$MODESWITCH EXTERNALCLASS}

interface

uses
    uFrequence,
    uFrequences,
 Classes, SysUtils, JS, Web, Math, ChartJS, Types;

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
   rouge, vert: String;
  //Méthodes
  private
   function Low_Frequency_Boundary: Double;
   function High_Frequency_Boundary: Double;
   procedure Push_dataset( _Name, _Color, _BkColor: String; _y: JSValue; _Data: TDoubleDynArray);
   procedure Axes;
   procedure Cree_Options;
   procedure Plugin_annotation_box( _XMin, _XMax, _YMin, _YMax: double; _Color: String);
   procedure Plugin_annotation_line(_Value: double; _label_position: string='cente'
 +'r');
   procedure Plugin_annotations(_Centers, _Boundaries: TDoubleDynArray;
    _Color: String; _label_position: string='center');
   procedure Bandes_from_Octave( _Octave, _NbOctaves: Integer);
  public
    procedure Draw_Chart_from_Octave   ( _Octave   : Integer; _Canvas_Name: String);
    procedure Draw_Chart_from_Frequence(_Libelle: String; _Frequence: double;
     _Canvas_Name: String);
    procedure Draw_Chart_from_Frequences(_Octave, _NbOctaves: Integer;
     _Libelle: String; _Frequences: TDoubleDynArray; _Canvas_Name: String);
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

end;

destructor TFrequencesCharter.Destroy;
begin
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

     y := TChartScaleCartesian.new;
     y.type_ := 'linear';
     y.id    := 'y-axis-0';

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

procedure TFrequencesCharter.Plugin_annotation_line(_Value: double; _label_position: string= 'center');
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
     //a.label_.content:= FloatToStr( _Value);
     a.label_.content:= uFrequence.sFrequence( _Value);
     a.label_.position:= _label_position;
     a.label_.enabled:= true;

     TChartOptions_with_annotation(config.options).annotation.annotations.push( a);
end;

procedure TFrequencesCharter.Plugin_annotations( _Centers, _Boundaries: TDoubleDynArray; _Color: String; _label_position: string= 'center');
var
   I2, I, L, L2: Integer;
   V1, V2: double;
begin
     L:= Length( _Boundaries);
     L2:= L div 2;
     for I2:= 0 to L2-1
     do
       begin
       I:= Low( _Boundaries)+2*I2;
       V1:= _Boundaries[I+0];
       V2:= _Boundaries[I+1];
       //Writeln( _Color, ' ', V1, ' ', V2);
       Plugin_annotation_box( V1, V2, 1, 3, _Color);
       Plugin_annotation_line( _Centers[I2], _label_position);
       end;
end;

procedure TFrequencesCharter.Bandes_from_Octave( _Octave, _NbOctaves: Integer);
begin
     Octave   := _Octave;
     NbOctaves:= _NbOctaves;

     rouge:= 'rgba(255, 128, 128, 50)';
     vert := 'rgba(128, 255, 128, 50)';
       Coherent_Boundaries:= Frequences.  aCoherent_boundaries(Octave, NbOctaves);
     DeCoherent_Boundaries:= Frequences.aDeCoherent_boundaries(Octave, NbOctaves);
       Coherent_Centers:= Frequences.  aCoherent_centers(Octave, NbOctaves);
     DeCoherent_Centers:= Frequences.aDeCoherent_centers(Octave, NbOctaves);
     //Frequences.Log_Frequences( 'Coherent_Centers', Coherent_Centers);
     //Frequences.Log_Frequences( 'DeCoherent_Centers', DeCoherent_Centers);

     config := TChartConfiguration.new;
     config.type_ := 'scatter';
     config.data := TChartData.new;
     Cree_Options;
     Plugin_annotations(   Coherent_Centers,   Coherent_Boundaries, vert , 'top'   );
     Plugin_annotations( DeCoherent_Centers, DeCoherent_Boundaries, rouge, 'bottom');

     config.data.datasets_ := TJSArray.new;
     Push_dataset( 'Décohérentes' , rouge, rouge, 1, DeCoherent_Centers);
     Push_dataset( 'Cohérentes', vert , vert , 3,   Coherent_Centers);
end;

procedure TFrequencesCharter.Draw_Chart_from_Octave( _Octave: Integer; _Canvas_Name: String);
begin
     Bandes_from_Octave( _Octave, 1);

     TChart.new( _Canvas_Name, config);
end;

procedure TFrequencesCharter.Draw_Chart_from_Frequence( _Libelle: String; _Frequence: double; _Canvas_Name: String);
begin
     Bandes_from_Octave( Frequences.Octave_from_Frequence( _Frequence), 1);

     Push_dataset( _Libelle, 'blue', 'blue', 2.5, [_Frequence]);

     TChart.new( _Canvas_Name, config);
end;

procedure TFrequencesCharter.Draw_Chart_from_Frequences( _Octave, _NbOctaves: Integer; _Libelle: String; _Frequences: TDoubleDynArray; _Canvas_Name: String);
begin
     Bandes_from_Octave( _Octave, _NbOctaves);
     Push_dataset( _Libelle, 'blue', 'blue', 2.5, _Frequences);

     TChart.new( _Canvas_Name, config);
end;

end.

