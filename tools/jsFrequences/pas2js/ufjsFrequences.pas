unit ufjsFrequences;

{$mode objfpc}
{$MODESWITCH EXTERNALCLASS}

interface

uses
    uFrequence,
    uFrequences, uCPL_G3,
 Classes, SysUtils, JS, Web, Math, ChartJS, Types;

type

 { TfjsFrequences }

 TfjsFrequences
 =
  class
  //Gestion du cycle de vie
  public
    constructor Create;
    destructor Destroy; override;
  //Interface
  public
    d: TJSHTMLElement;
    bCPL_G3: TJSHTMLButtonElement;
    iOctave: TJSHTMLInputElement;
    iFrequence: TJSHTMLInputElement;
    sFrequence: TJSHTMLElement;
    dOctave: TJSHTMLElement;
    dFrequence: TJSHTMLElement;
    dCPL_G3: TJSHTMLElement;
    dInfos: TJSHTMLElement;
    procedure Connecte_Interface;
    function bClick( _Event: TJSMouseEvent): boolean;
    function iOctaveInput( _Event: TEventListenerEvent): boolean;
    function iFrequenceInput( _Event: TEventListenerEvent): boolean;
    procedure Draw_Chart;
    procedure Draw_Chart_from_Octave( _Octave: Integer);
    procedure Draw_Chart_from_Frequence( _Frequence: double);
  end;

implementation

function element_from_id( _id: String): TJSHTMLElement;
begin
     Result:= TJSHTMLElement( document.getElementById(_id));
end;

function button_from_id( _id: String): TJSHTMLButtonElement;
begin
     Result:= TJSHTMLButtonElement(document.getElementById(_id))
end;

function input_from_id( _id: String): TJSHTMLInputElement;
begin
     Result:= TJSHTMLInputElement(document.getElementById(_id))
end;

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

{ TfjsFrequences }

constructor TfjsFrequences.Create;
begin
     Connecte_Interface;
end;

destructor TfjsFrequences.Destroy;
begin
     inherited Destroy;
end;

procedure TfjsFrequences.Connecte_Interface;
begin
     d:= element_from_id('d');

     bCPL_G3:= button_from_id( 'bCPL_G3');
     bCPL_G3.onclick:= @bClick;

     iOctave:= input_from_id('iOctave');
     iOctave.oninput:=@iOctaveInput;

     iFrequence:= input_from_id( 'iFrequence');
     iFrequence.oninput:=@iFrequenceInput;
     sFrequence:= element_from_id('sFrequence');

     //cFrequence
     //Draw_Chart;
     dOctave   := element_from_id('dOctave'   );
     dFrequence:= element_from_id('dFrequence');


     dCPL_G3:= element_from_id('dCPL_G3');
     dCPL_G3.innerHTML:= CPL_G3.Liste;
     dInfos:= element_from_id('dInfos');
     dInfos.innerHTML
     :=
        'compilé avec pas2js version '+{$I %FPCVERSION%}+'<br>'
       +'target: '+{$I %FPCTARGETCPU%}+' - '+{$I %FPCTARGETOS%}+'<br>'
       +'os: '+{$I %FPCTARGETOS%}+'<br>'
       +'cpu: '+{$I %FPCTARGETCPU%}+'<br>'
       +'compilé le '+{$I %DATE%}+' à '+{$I %TIME%}+'<br>'
       +'langue du navigateur: '+window.navigator.language;
end;

function TfjsFrequences.bClick(_Event: TJSMouseEvent): boolean;
begin
     dCPL_G3.innerHTML:= CPL_G3.Liste;
end;

function TfjsFrequences.iOctaveInput(_Event: TEventListenerEvent): boolean;
var
   Octave: Integer;
begin
     if not TryStrToInt( iOctave.value, Octave) then exit;

     Draw_Chart_from_Octave( Octave);
     dOctave.innerHTML:= Frequences.Liste( Octave);
end;

function TfjsFrequences.iFrequenceInput(_Event: TEventListenerEvent): boolean;
var
   Frequence: double;
begin
     if not TryStrToFloat( iFrequence.value, Frequence) then exit;

     Draw_Chart_from_Frequence( Frequence);
     dFrequence.innerHTML:= Frequences.Liste_from_Frequence( Frequence);
     sFrequence .innerHTML:= uFrequence.sFrequence( Frequence);
end;

procedure TfjsFrequences.Draw_Chart;
function randomScalingFactor: NativeUInt;
begin
  Result := RandomRange(-100, 100);
end;

var
  config: TChartConfiguration;
  procedure Push_ChartLineDataset( _Name, _Color, _BkColor: String);
  var
     dataset: TChartLineDataset;
  begin
       dataset:= TChartLineDataset.new;
       dataset.label_ := _Name;
       dataset.borderColor := _Color;
       dataset.backgroundColor := _BkColor;
       dataset.showLine:= False;
       dataset.data := [randomScalingFactor, randomScalingFactor,
         randomScalingFactor, randomScalingFactor, randomScalingFactor,
         randomScalingFactor, randomScalingFactor];
       config.data.datasets_.push(dataset);
  end;
  procedure Push_dataset( _Name, _Color, _BkColor: String; _y: Integer);
  var
     dataset: TChartScatterDataset;
  begin
       dataset:= TChartScatterDataset.new;
       dataset.label_ := _Name;
       dataset.borderColor := _Color;
       dataset.backgroundColor := _BkColor;
       dataset.showLine:= False;
       dataset.datas
       :=
       [
        TChartXYData.new(10,_y),
        TChartXYData.new(20,_y),
        TChartXYData.new(30,_y),
        TChartXYData.new(40,_y),
        TChartXYData.new(50,_y),
        TChartXYData.new(60,_y),
        TChartXYData.new(70,_y)
       ];
       config.data.datasets_.push(dataset);
  end;
  procedure Axes;
  var
     x: TChartScaleCartesian;
     y: TChartScaleCartesian;
  begin
       x := TChartScaleCartesian.new;
       x.type_ := 'linear';//'logarithmic';
       x.id    := 'x-axis-0';

       y := TChartScaleCartesian.new;
       y.type_ := 'linear';
       y.id    := 'y-axis-0';

       config.options.scales := TChartScalesConfiguration.new;
       config.options.scales.xAxes_ := TJSArray.new(x);
       config.options.scales.yAxes_ := TJSArray.new(y);
  end;
  procedure Cree_Options;
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
  procedure Plugin_annotation( _XMin, _XMax, _YMin, _YMax: double);
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
       a.backgroundColor:= 'rgba(128, 255, 128, 50)';
       a.borderColor    := 'rgba(128, 255, 128, 50)';
       a.borderWidth    := 1;

       TChartOptions_with_annotation(config.options).annotation.annotations.push( a);
  end;
begin
  config := TChartConfiguration.new;
  config.type_ := 'scatter';
  config.data := TChartData.new;
  Cree_Options;
  Plugin_annotation( 20, 25, 20, 25);
  Plugin_annotation( 25, 30, 25, 30);

  config.data.datasets_ := TJSArray.new;
  Push_dataset( 'My First dataset' , 'rgb(255, 99, 132)', 'rgb(255, 99, 132)', 10);
  Push_dataset( 'My Second dataset', 'rgb(54, 162, 235)', 'rgb(54, 162, 235)', 20);
  Push_dataset( 'My Third dataset' , 'rgb(75, 192, 192)', 'rgb(75, 192, 192)', 30);


  TChart.new('cFrequence', config);
end;

procedure TfjsFrequences.Draw_Chart_from_Octave( _Octave: Integer);
var
  config: TChartConfiguration;
  Coherent_Boundaries, DeCoherent_Boundaries: TDoubleDynArray;
  Coherent_Centers, DeCoherent_Centers: TDoubleDynArray;
  rouge, vert: String;
  function Low_Frequency_Boundary: Double;
  begin
       Result:= DeCoherent_Boundaries[Low(DeCoherent_Boundaries)];
  end;
  function High_Frequency_Boundary: Double;
  begin
       Result:= Coherent_Boundaries[High(Coherent_Boundaries)];
  end;
  function randomScalingFactor: NativeUInt;
  begin
       Result := RandomRange(Trunc(Low_Frequency_Boundary), Trunc(High_Frequency_Boundary)+1);
  end;
  procedure Push_ChartLineDataset( _Name, _Color, _BkColor: String);
  var
     dataset: TChartLineDataset;
  begin
       dataset:= TChartLineDataset.new;
       dataset.label_ := _Name;
       dataset.borderColor := _Color;
       dataset.backgroundColor := _BkColor;
       dataset.showLine:= False;
       dataset.data := [randomScalingFactor, randomScalingFactor,
         randomScalingFactor, randomScalingFactor, randomScalingFactor,
         randomScalingFactor, randomScalingFactor];
       config.data.datasets_.push(dataset);
  end;
  procedure Push_dataset( _Name, _Color, _BkColor: String; _y: Integer; _Data: TDoubleDynArray);
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
       (*
       dataset.datas
       :=
       [
        TChartXYData.new(Low_Frequency_Boundary,_y),
        TChartXYData.new(randomScalingFactor,_y),
        TChartXYData.new(randomScalingFactor,_y),
        TChartXYData.new(randomScalingFactor,_y),
        TChartXYData.new(randomScalingFactor,_y),
        TChartXYData.new(randomScalingFactor,_y),
        TChartXYData.new(High_Frequency_Boundary,_y)
       ];
       *)
       dataset.data_:= TJSArray.new;
       Push_Data;
       config.data.datasets_.push(dataset);
  end;
  procedure Axes;
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
  procedure Cree_Options;
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
  procedure Plugin_annotation( _XMin, _XMax, _YMin, _YMax: double; _Color: String);
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
  procedure Plugin_annotation_line( _Value: double);
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
       a.label_.content:= FloatToStr( _Value);
       a.label_.enabled:= true;

       TChartOptions_with_annotation(config.options).annotation.annotations.push( a);
  end;
  procedure Plugin_annotations( _Centers, _Boundaries: TDoubleDynArray; _Color: String);
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
         Plugin_annotation( V1, V2, 1, 3, _Color);
         Plugin_annotation_line( _Centers[I2]);
         end;
  end;
begin
     rouge:= 'rgba(255, 128, 128, 50)';
     vert := 'rgba(128, 255, 128, 50)';
       Coherent_Boundaries:= Frequences.  aCoherent_boundaries(_Octave);
     DeCoherent_Boundaries:= Frequences.aDeCoherent_boundaries(_Octave);
       Coherent_Centers:= Frequences.  aCoherent_centers(_Octave);
     DeCoherent_Centers:= Frequences.aDeCoherent_centers(_Octave);

     config := TChartConfiguration.new;
     config.type_ := 'scatter';
     config.data := TChartData.new;
     Cree_Options;
     Plugin_annotations(   Coherent_Centers,   Coherent_Boundaries, vert );
     Plugin_annotations( DeCoherent_Centers, DeCoherent_Boundaries, rouge);

     config.data.datasets_ := TJSArray.new;
     Push_dataset( 'Bas' , rouge, rouge, 1, DeCoherent_Centers);
     Push_dataset( 'Haut', vert , vert , 3,   Coherent_Centers);


     TChart.new('cOctave', config);
end;

procedure TfjsFrequences.Draw_Chart_from_Frequence(_Frequence: double);
var
   Octave: Integer;
   config: TChartConfiguration;
   Coherent_Boundaries, DeCoherent_Boundaries: TDoubleDynArray;
   Coherent_Centers, DeCoherent_Centers: TDoubleDynArray;
   rouge, vert: String;
  function Low_Frequency_Boundary: Double;
  begin
       Result:= DeCoherent_Boundaries[Low(DeCoherent_Boundaries)];
  end;
  function High_Frequency_Boundary: Double;
  begin
       Result:= Coherent_Boundaries[High(Coherent_Boundaries)];
  end;
  function randomScalingFactor: NativeUInt;
  begin
       Result := RandomRange(Trunc(Low_Frequency_Boundary), Trunc(High_Frequency_Boundary)+1);
  end;
  procedure Push_ChartLineDataset( _Name, _Color, _BkColor: String);
  var
     dataset: TChartLineDataset;
  begin
       dataset:= TChartLineDataset.new;
       dataset.label_ := _Name;
       dataset.borderColor := _Color;
       dataset.backgroundColor := _BkColor;
       dataset.showLine:= False;
       dataset.data := [randomScalingFactor, randomScalingFactor,
         randomScalingFactor, randomScalingFactor, randomScalingFactor,
         randomScalingFactor, randomScalingFactor];
       config.data.datasets_.push(dataset);
  end;
  procedure Push_dataset( _Name, _Color, _BkColor: String; _y: JSValue; _Data: TDoubleDynArray);
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
       (*
       dataset.datas
       :=
       [
        TChartXYData.new(Low_Frequency_Boundary,_y),
        TChartXYData.new(randomScalingFactor,_y),
        TChartXYData.new(randomScalingFactor,_y),
        TChartXYData.new(randomScalingFactor,_y),
        TChartXYData.new(randomScalingFactor,_y),
        TChartXYData.new(randomScalingFactor,_y),
        TChartXYData.new(High_Frequency_Boundary,_y)
       ];
       *)
       dataset.data_:= TJSArray.new;
       Push_Data;
       config.data.datasets_.push(dataset);
  end;
  procedure Axes;
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
  procedure Cree_Options;
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
  procedure Plugin_annotation( _XMin, _XMax, _YMin, _YMax: double; _Color: String);
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
  procedure Plugin_annotation_line( _Value: double);
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
       a.label_.content:= FloatToStr( _Value);
       a.label_.enabled:= true;

       TChartOptions_with_annotation(config.options).annotation.annotations.push( a);
  end;
  procedure Plugin_annotations( _Centers, _Boundaries: TDoubleDynArray; _Color: String);
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
         Plugin_annotation( V1, V2, 1, 3, _Color);
         Plugin_annotation_line( _Centers[I2]);
         end;
  end;
begin
     Octave:= Frequences.Octave_from_Frequence( _Frequence);
     rouge:= 'rgba(255, 128, 128, 50)';
     vert := 'rgba(128, 255, 128, 50)';
       Coherent_Boundaries:= Frequences.  aCoherent_boundaries(Octave);
     DeCoherent_Boundaries:= Frequences.aDeCoherent_boundaries(Octave);
       Coherent_Centers:= Frequences.  aCoherent_centers(Octave);
     DeCoherent_Centers:= Frequences.aDeCoherent_centers(Octave);

     config := TChartConfiguration.new;
     config.type_ := 'scatter';
     config.data := TChartData.new;
     Cree_Options;
     Plugin_annotations(   Coherent_Centers,   Coherent_Boundaries, vert );
     Plugin_annotations( DeCoherent_Centers, DeCoherent_Boundaries, rouge);

     config.data.datasets_ := TJSArray.new;
     Push_dataset( 'Bas' , rouge, rouge, 1, DeCoherent_Centers);
     Push_dataset( 'Haut', vert , vert , 3,   Coherent_Centers);
     Push_dataset( 'Frequence', 'blue', 'blue', 2.5, [_Frequence]);


     TChart.new('cFrequence', config);
end;

end.

