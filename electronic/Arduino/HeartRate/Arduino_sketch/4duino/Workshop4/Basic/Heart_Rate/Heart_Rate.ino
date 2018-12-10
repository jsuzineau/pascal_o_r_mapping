//
// NB! This is a file generated from the .4Dino file, changes will be lost
//     the next time the .4Dino file is built
//
#include <SPI.h>
#include <math.h>
#include <avr/wdt.h>
#include "arduinoFFT.h"

// Define LOG_MESSAGES to a serial port to send SPE errors messages to. Do not use the same Serial port as SPE
//#define LOG_MESSAGES Serial

#define RESETLINE     30

#define DisplaySerial Serial1


#include "Picaso_Serial_4DLib.h"
#include "Picaso_Const4D.h"

Picaso_Serial_4DLib Display(&DisplaySerial);

#include "uButton.h"
#include "uByteLabel.h"
#include "uSlider.h"
// Uncomment to use ESP8266
//#define ESPRESET 17
//#include <SoftwareSerial.h>
//#define ESPserial SerialS
//SoftwareSerial SerialS(8, 9) ;
// Uncomment next 2 lines to use ESP8266 with ESP8266 library from https://github.com/itead/ITEADLIB_Arduino_WeeESP8266
//#include "ESP8266.h"
//ESP8266 wifi(SerialS,19200);

// routine to handle Serial errors
void mycallback(int ErrCode, unsigned char Errorbyte)
{
#ifdef LOG_MESSAGES
  const char *Error4DText[] = {"OK\0", "Timeout\0", "NAK\0", "Length\0", "Invalid\0"} ;
  LOG_MESSAGES.print(F("Serial 4D Library reports error ")) ;
  LOG_MESSAGES.print(Error4DText[ErrCode]) ;
  if (ErrCode == Err4D_NAK)
  {
    LOG_MESSAGES.print(F(" returned data= ")) ;
    LOG_MESSAGES.println(Errorbyte) ;
  }
  else
    LOG_MESSAGES.println(F("")) ;
  while (1) ; // you can return here, or you can loop
#else
  // Pin 13 has an LED connected on most Arduino boards. Just give it a name
#define led 13
  while (1)
  {
    digitalWrite(led, HIGH);   // turn the LED on (HIGH is the voltage level)
    delay(200);                // wait for a second
    digitalWrite(led, LOW);    // turn the LED off by making the voltage LOW
    delay(200);                // wait for a second
  }
#endif
}
// end of routine to handle Serial errors

void setup()
{
// Ucomment to use the Serial link to the PC for debugging
//  Serial.begin(115200) ;        // serial to USB port
// Note! The next statement will stop the sketch from running until the serial monitor is started
//       If it is not present the monitor will be missing the initial writes
//    while (!Serial) ;             // wait for serial to be established

  pinMode(RESETLINE, OUTPUT);       // Display reset pin
digitalWrite(RESETLINE, 1);       // Reset Display, using shield
  delay(100);                       // wait for it to be recognised
digitalWrite(RESETLINE, 0);       // Release Display Reset, using shield
// Uncomment when using ESP8266
//  pinMode(ESPRESET, OUTPUT);        // ESP reset pin
//  digitalWrite(ESPRESET, 1);        // Reset ESP
//  delay(100);                       // wait for it t
//  digitalWrite(ESPRESET, 0);        // Release ESP reset
  delay(3000) ;                     // give display time to startup

  // now start display as Serial lines should have 'stabilised'
  DisplaySerial.begin(200000) ;     // Hardware serial to Display, same as SPE on display is set to
  Display.TimeLimit4D = 5000 ;      // 5 second timeout on all commands
  Display.Callback4D = mycallback ;

// uncomment if using ESP8266
//  ESPserial.begin(115200) ;         // assume esp set to 115200 baud, it's default setting
                                    // what we need to do is attempt to flip it to 19200
                                    // the maximum baud rate at which software serial actually works
                                    // if we run a program without resetting the ESP it will already be 19200
                                    // and hence the next command will not be understood or executed
//  ESPserial.println("AT+UART_CUR=19200,8,1,0,0\r\n") ;
//  ESPserial.end() ;
//  delay(10) ;                         // Necessary to allow for baud rate changes
//  ESPserial.begin(19200) ;            // start again at a resonable baud rate
  Display.gfx_ScreenMode(LANDSCAPE) ; // change manually if orientation change
  // put your setup code here, to run once:
  Display.touch_Set(TOUCH_ENABLE);                            // enable the touch screen

  fHeart_Rate_setup();
  //wdt_enable(WDTO_2S);
} // end Setup **do not alter, remove or duplicate this line**

enum eTForm { fNone, fHeart_Rate, fRange};
typedef enum eTForm TForm;

TForm f= fNone;

void fHeart_Rate_setup()
  {
  f= fHeart_Rate;
  attachInterrupt( digitalPinToInterrupt(2), interrupt, RISING);

  digitalWrite(13, HIGH);

  Display.gfx_BGcolour(BLACK) ;
  Display.gfx_Cls();                    // clear the screen
  Initialise();
  pinMode(13, OUTPUT);
  digitalWrite(13, LOW);

  Calcul_cx_cy();
  }
void fHeart_Rate_unsetup()
  {
  f= fNone;
  detachInterrupt( digitalPinToInterrupt(2));
  }

bool is_FFT= true;
word old_y=0;
const int  w4duino_dx=320; const int w4duino_max_x= w4duino_dx-1;
const byte w4duino_dy=240; const int w4duino_max_y= w4duino_dy-1;
//const int pouls_min=20; const int pouls_max=200;
byte pouls_min=40; byte pouls_max=100;
const word ms_from_minute=60000;
const word ms_from_seconde=1000;
byte temps_largeur_ecran= 30; //30s : 2 largeur d'�cran par minute

//Display.gfx_Slider(SLIDER_RAISED, 42, 49, 285, 68, TURQUOISE, 100, 40) ;  // sX
     TSlider sTemps( SLIDER_RAISED, 42, 49, 285, 68, TURQUOISE, 60, 30);
//Display.gfx_Slider(SLIDER_RAISED, 42, 98, 282, 117, TURQUOISE, 100, 40) ;  // sMin
       TSlider sMin( SLIDER_RAISED, 42, 98, 282, 117, TURQUOISE, 100, 40);
//Display.gfx_Slider(SLIDER_RAISED, 42, 148, 282, 168, TURQUOISE, 100, 40) ;  // sMax
       TSlider sMax( SLIDER_RAISED, 42, 148, 282, 168, TURQUOISE, 200, 40);

//Display.gfx_Button(1, 140, 196, SILVER, BLACK, FONT3, 1, 1, "OK") ; // bOK Width=29 Height=21
         TButton bOK(1, 140, 196, SILVER, BLACK, FONT3, 1, 1, "OK",29,21);
//Display.gfx_Button(1, 48, 196, RED, YELLOW, FONT3, 1, 1, "FFT") ; // bFFT Width=37 Height=21
        TButton bFFT(1, 48, 196, RED, YELLOW, FONT3, 1, 1, "FFT",37,21);

//Display.gfx_Button(1, 175, 22, WHITE, BLACK, FONT1, 1, 1, "Temps") ; // bTemps Width=48 Height=17
   TByteLabel bTemps(1, 175, 22, WHITE, BLACK, FONT1, 1, 1, &temps_largeur_ecran,48,17);
//Display.gfx_Button(1, 156, 79, WHITE, BLACK, FONT1, 1, 1, "Min") ; // bMin Width=34 Height=17
     TByteLabel bMin(1, 156, 79, WHITE, BLACK, FONT1, 1, 1, &pouls_min,34,17);
//Display.gfx_Button(1, 153, 127, WHITE, BLACK, FONT1, 1, 1, "Max") ; // bMax Width=34 Height=17
     TByteLabel bMax(1, 153, 127, WHITE, BLACK, FONT1, 1, 1, &pouls_max,34,17);


void fRange_setup()
  {
  f= fRange;

  sTemps.value= temps_largeur_ecran;
  sMin  .value= pouls_min          ;
  sMax  .value= pouls_max          ;

  // Form1 1.1 generated 10/02/2018 16:58:12
  Display.gfx_BGcolour(WHITE) ;
  Display.gfx_Cls() ;
  Display.gfx_Button(1, 42, 22, WHITE, BLACK, FONT1, 1, 1, "Echelle de temps") ; // bEchelle_Temps Width=125 Height=17
  Display.gfx_Button(1, 42, 79, WHITE, BLACK, FONT1, 1, 1, "Pouls minimum") ; // bEchelle_Pouls Width=104 Height=17
  Display.gfx_Button(1, 42, 127, WHITE, BLACK, FONT1, 1, 1, "Pouls maximum") ; // Button7 Width=104 Height=17

  sTemps.Draw(); bTemps.Draw();
  sMin  .Draw(); bMin  .Draw();
  sMax  .Draw(); bMax  .Draw();
  bOK   .Draw();
  bFFT  .Draw();

  }
void fRange_unsetup()
  {
  f= fNone;
  }

//on d�clare en volatile toutes les variables acc�d�es dans l'interruption (car thread diff�rent)
const byte Ps_Size=40;
const byte Ps_Max=Ps_Size-1;
class Pulsation
 {
 public:
   unsigned long T;
   byte y;
   byte dx;
   word dt;
   byte Written;
   byte Calc;
   void Initialise()
    {
    T      = 0   ;
    y      = 0   ;
    dx     = 0   ;
    Written= true;
    Calc   = true;
    }
 };
volatile Pulsation Ps[ Ps_Size];
volatile byte iPs=0;
volatile byte state = LOW; //alternance des interruptions

//String NomFichier="";
//String linuxNomFichier= "";
//String urlNomFichier="";
void Log_to_File()
  {
  bool All_written= true;

  for (byte i=0; i<=Ps_Max; i++)
    {
    if (Ps[i].Written) continue;

    All_written= false;
    break;
    }
  if (All_written) return;

  /*
  const int taille=1024;
  char lpstrNomFichier[taille];
  linuxNomFichier.toCharArray( lpstrNomFichier, taille);
  File F= FileSystem.open( lpstrNomFichier, FILE_APPEND);
  */
  for (byte i=0; i<=Ps_Max; i++)
    {
    if (Ps[i].Written) continue;

    Calcul_Ti( i);
    //Display_Ti( i);
    //F.println( String(Ps[i].T));
    Ps[i].Written= true;
    }

  if (is_FFT)
    {
     Calcul_FFT();
    Display_FFT();
    }
  else
    Display_T();

  //F.close();

  }

double cx= 1;
double cy= 1;
void Calcul_cx_cy()
  {
  cx= (double)w4duino_dx / (double)(temps_largeur_ecran*ms_from_seconde);
  cy= (double)w4duino_dy / (pouls_max-pouls_min);
  }
void Calcul_Ti( byte _i)
  {
  byte i_1= _i > 0 ? _i-1 : Ps_Max;
  volatile Pulsation &P_1=Ps[ i_1];
  volatile Pulsation &P  =Ps[_i  ];
  word dt=0;
  if ((0!=P.T)&&(0!=P_1.T))
    dt= P.T - P_1.T;
  byte y= 0;
  byte dx= 0;
  if (0==dt)
    {
     y=  P_1.y;
    dx=  P_1.dx;
    }
  else
    {
    double pouls= double(ms_from_minute) / (double)dt;
    if (pouls<pouls_min) pouls= pouls_min;
    if (pouls_max<pouls) pouls= pouls_max;
     y= w4duino_dy-cy*(pouls-pouls_min);
    dx= round(dt * cx);
    }
  P.y   =  y;
  P.dx  = dx;
  P.dt  =dt;
  P.Calc=true;
  }
void Display_Ti( byte _i)
  {
  volatile Pulsation &P  =Ps[ _i  ];
  byte  y= P. y;
  byte dx= P.dx;
  int largeur= w4duino_dx-dx;
  int old_x= largeur;

  Display.gfx_ScreenCopyPaste(dx, 0, 0, 0, largeur, w4duino_dy);
  //Display.gfx_Line(w4duino_max_x, 0, w4duino_max_x, w4duino_max_y, BLACK);   // draw line, can be patterned();
  Display.gfx_RectangleFilled(old_x,0,w4duino_max_x,w4duino_max_y, BLACK);    // draw filled rectangle
  Display.gfx_Line(old_x, old_y, w4duino_max_x, y, GREEN);   // draw line, can be patterned();
  //Display.gfx_PutPixel(w4duino_max_x, y, GREEN);            // set point at x y


  /*
  Serial.print( "pouls: "); Serial.print( pouls);
  Serial.print( " dt: "); Serial.print( delta);
  Serial.print( " cx: "); Serial.print( cx);
  Serial.print( " dx: "); Serial.print( dx);
  Serial.print( " y: "); Serial.print( y);
  Serial.print( " largeur: "); Serial.print( largeur);
  Serial.println("");
  */
  old_y=y;
  }

class TPoint
  {
  public:
  int x;
  byte y;
  boolean Out()
    {
    return (x<0)||(w4duino_max_x<x);
    }
  };
class TPolyLine
  {
  private:
    void Draw_interne( word _color)
      {
      for (byte i=1; i<Ps_Size; i++)
        {
        TPoint &p_1=points[i-1]; if(p_1.Out()) continue;
        TPoint &p  =points[i  ]; if(p  .Out()) continue;
        if (p_1.x>p.x) continue;

        for (byte j=0;j<3;j++)
          Display.gfx_Line(p_1.x,p_1.y+j, p.x, p.y+j, _color);
        }
      }
  public:
    TPoint points[Ps_Size];
    TPolyLine()
      {
      for (byte i=1; i<Ps_Size; i++)
        {
        TPoint &p=points[i];
        p.x= 0;
        p.y= 0;
        }
      }
    void Set_point( byte _i, int x, byte y)
      {
      TPoint &p=points[_i];
      p.x= x;
      p.y= y;
      }
    void   Draw() {Draw_interne( GREEN);}
    void UnDraw() {Draw_interne( BLACK);}
  };

TPolyLine Old_Line;
byte iPs_from_offset( byte _iPs_Original, char _offset)
  {
  char int_i= (_iPs_Original+_offset) % Ps_Size;
  if (int_i<0) int_i+= Ps_Size;//le modulo C++ peut �tre n�gatif
  return int_i;
  }
void Display_T()
  {
  TPolyLine Line;

  //Display.gfx_Cls();
  byte iPs_Original=iPs;
  int x= w4duino_max_x;
  for (char j=0; j>=-Ps_Max; j--)
    {
    byte i= iPs_from_offset( iPs_Original, j);
    byte i_1= i > 0 ? i-1 : Ps_Max;

    volatile Pulsation &P_1=Ps[ i_1];
    volatile Pulsation &P  =Ps[ i  ];
    byte y_1= P_1.y;
    byte y  = P  .y;
    byte dx = P  .dx;
    //Display.gfx_Line(x-dx,y_1, x, y, GREEN);
    Line.Set_point( i_1, x-dx, y_1);
    Line.Set_point( i  , x   , y  );
    //Serial.print( x);
    //Serial.print( i);
    //Serial.print( " ");
    x-=dx;
    }
  //Serial.println( " ");

  Old_Line.UnDraw();
  Line.Draw();
  Old_Line=Line;
  }
//calcul fft
double d_map(double x, double in_min, double in_max, double out_min, double out_max)
{
  return (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min;
}
const byte n=64;
const byte n2=n>>1;//=n/2
const byte FFT_dx= w4duino_max_x / n2;
double sample_dt=0;
double sample_y_real[n];
double Periode_max=0;

#define SCL_INDEX 0x00
#define SCL_TIME 0x01
#define SCL_FREQUENCY 0x02
#define SCL_PLOT 0x03

void Calcul_FFT()
  {
//  Serial.println("Calcul_FFT(), d�but");
  double sample_t[n];
  double sample_y_imaginary[n];
  double samplingFrequency=0;
  double f_max=0;

  for (byte i=0; i<n; i++)
    {
    sample_y_real[i]=0;
    sample_y_imaginary[i]=0;
    }

  byte iPs_Original=iPs;
  //calcul intervalle x
  word dt_sum=0;
  byte iPs_tmax=iPs_from_offset( iPs_Original, -1);
  unsigned long t_max= Ps[iPs_tmax].T;
//  Serial.print("tmax:");
//  Serial.println(t_max);

  for (char j=0; j>=-Ps_Max; j--)
    {
    byte i= iPs_from_offset( iPs_Original, j);

    volatile Pulsation &P  =Ps[ i  ];
    dt_sum+= P.dt;
    }
  //Calcul intervalle �l�mentaire
//  Serial.print("dt_sum:");
//  Serial.println(dt_sum);
  sample_dt= dt_sum / n;
//  Serial.print("sample_dt:");
  //Serial.println(sample_dt,6);
  samplingFrequency= 1000/sample_dt;
  //Serial.print("samplingFrequency:");
  //Serial.println(samplingFrequency,6);
  //calcul du vecteur des x
  //Serial.println("Vecteur des x:");
  double t=t_max;
  for (char j=n-1; j>=0; j--)
    {
    //Serial.print((int)j);
    //Serial.print(", t:");
    //Serial.print(t);
    //Serial.print(" ");
    sample_t[j]= t;
    t-=sample_dt;
    }
  //Serial.println();
  //interpolation du vecteur des y
  //Serial.println("Interpolation:");
  dt_sum=0;
  for (char j=0; j>=-Ps_Max; j--)
    {
    byte i= iPs_from_offset( iPs_Original, j);
    byte i_1= i > 0 ? i-1 : Ps_Max;

    volatile Pulsation &P_1=Ps[ i_1];
    volatile Pulsation &P  =Ps[ i  ];

    byte y_1= P_1.y;
    byte y  = P  .y;
    unsigned long t  = P  .T;
    unsigned long t_1= P_1.T;

    char i_sample= (n-1)-(int)(dt_sum/sample_dt);
    //Serial.print(i);
    //Serial.print(": t:");
    //Serial.print(t);
    //Serial.print(" y:");
    //Serial.print(y);
    //Serial.print(" t_1:");
    //Serial.print(t_1);
    //Serial.print(" y_1:");
    //Serial.print(y_1);
    //Serial.print(" i_sample:");
    //Serial.println((int)i_sample);

    while ((i_sample>=0)&&(sample_t[i_sample] > t_1))
      {
      double &yreal= sample_y_real[i_sample];
      yreal= d_map(sample_t[i_sample], t_1, t, y_1, y);
      //Serial.print((int)i_sample);Serial.print(", ");Serial.print(yreal,12);Serial.print(" ");
      i_sample--;
      }
    //Serial.println();

    dt_sum+= P.dt;
    }
  // FFT
  Log_FFT("apr�s interpolation:");
  arduinoFFT FFT= arduinoFFT( sample_y_real, sample_y_imaginary, n, samplingFrequency);
  FFT.Windowing( FFT_WIN_TYP_HAMMING, FFT_FORWARD);
  Log_FFT("apr�s windowing:");
  FFT.Compute( FFT_FORWARD);
  Log_FFT("apr�s compute:");
  FFT.ComplexToMagnitude();
  Log_FFT("apr�s ComplexToMagnitude:");
  f_max = FFT.MajorPeak();
  Periode_max= 1.0/f_max;


  //Serial.println("Computed magnitudes:");
  //PrintVector(sample_y_real, n2, SCL_FREQUENCY, samplingFrequency);
  //Serial.println(f_max, 6);
  //Serial.print("Periode:");
  //Serial.println(Periode_max, 6);
  //
  }

void Log_FFT( const char *message)
  {
  //Serial.println(message);
  for (char i=0; i<n; i++)
    {
    double &yreal= sample_y_real[i];
    //Serial.print(yreal,12);Serial.print(" ");
    }
  }
//duplicated from sample arduinoFFT / FFT_01
void PrintVector(double *vData, uint16_t bufferSize, uint8_t scaleType, double samplingFrequency)
{
  for (uint16_t i = 0; i < bufferSize; i++)
  {
    double abscissa;
    /* Print abscissa value */
    switch (scaleType)
    {
      case SCL_INDEX:
        abscissa = (i * 1.0);
	break;
      case SCL_TIME:
        abscissa = ((i * 1.0) / samplingFrequency);
	break;
      case SCL_FREQUENCY:
        abscissa = ((i * 1.0 * samplingFrequency) / n);
	break;
    }
    //Serial.print(abscissa, 6);
    //if(scaleType==SCL_FREQUENCY)
      //Serial.print("Hz");
    //Serial.print(" ");
    //Serial.println(vData[i], 4);
  }
  //Serial.println();
}

void Display_FFT()
  {
  //Serial.println("Display_FFT(), d�but");
  TPolyLine Line;

  double FFT_ymax= 0;
  for (byte j=0; j< n2; j++)
    {
    double FFT_y= sample_y_real[j];
    //Serial.print(FFT_y,12);Serial.print(" ");
    if (FFT_y > FFT_ymax) FFT_ymax= FFT_y;
    }
  //Serial.println();
  //Serial.print("FFT_ymax: ");Serial.println(FFT_ymax,6);

  double FFT_cy= (double)w4duino_dy / FFT_ymax;
  //Serial.print("FFT_cy: ");Serial.println(FFT_cy,6);

  double FFT_y_1= sample_y_real[0];
  byte y_1= (int)(FFT_y_1*FFT_cy);
  //Serial.print(y_1);Serial.print(" ");
  int x_1= 0;
  Line.Set_point( 0, x_1, y_1);
  for (byte j=1; j< n2; j++)
    {
    double FFT_y  = sample_y_real[j  ];
    byte y  = (int)(FFT_y  *FFT_cy);
    int x  = j*FFT_dx;

    //Serial.print(y);Serial.print(" ");

    Line.Set_point( j, x, y);
    }
  //Serial.println();

  //Serial.println("Display_FFT(), avant Old_Line.UnDraw();");
  Old_Line.UnDraw();
  //Serial.println("Display_FFT(), avant Line.Draw();");
  Line.Draw();
  Old_Line=Line;
  //Serial.println("Display_FFT(), fin");
  }


void interrupt()
  {
  state= !state;
  volatile Pulsation &P  =Ps[ iPs];
  P.T= millis();
  P.Written=false;
  P.Calc   =false;
  iPs= Ps_Max == iPs ? 0 : iPs+1;
  }

void Traite_data()
  {
  /*
  for (unsigned char i=0; i<=Ps_Max; i++)
    Bridge.put( String(i), String(Ps[i].T));
  */
  Log_to_File();
  }

void Initialise()
  {
  for (byte i=0; i<=Ps_Max; i++)
     Ps[i].Initialise();
  }

void fHeart_Rate_loop()
  {
  Traite_data();
  digitalWrite(13, state);
  word wTOUCH_STATUS = Display.touch_Get( TOUCH_STATUS);
  if (TOUCH_PRESSED == wTOUCH_STATUS)
    {
    fHeart_Rate_unsetup();
    fRange_setup();
    }
  }

void fRange_loop()
  {
  word wTOUCH_STATUS = Display.touch_Get( TOUCH_STATUS);
  boolean isPressed= TOUCH_PRESSED == wTOUCH_STATUS;
  boolean isMoving = TOUCH_MOVING == wTOUCH_STATUS;
  word x = Display.touch_Get(TOUCH_GETX);
  byte y = Display.touch_Get(TOUCH_GETY);
  if (isPressed || isMoving)
    {
          if (sTemps.Touch( x, y)) { temps_largeur_ecran= sTemps.value; bTemps.Draw();}
    else  if (sMin  .Touch( x, y)) { pouls_min          = sMin  .value; bMin  .Draw();}
    else  if (sMax  .Touch( x, y)) { pouls_max          = sMax  .value; bMax  .Draw();}
    }
  if ((isPressed)&&(bOK.Touch( x, y)))
    {
    is_FFT= false;
    fRange_unsetup();
    fHeart_Rate_setup();
    }
  if ((isPressed)&&(bFFT.Touch( x, y)))
    {
    is_FFT= true;
    fRange_unsetup();
    fHeart_Rate_setup();
    }
  }


void loop()
{
  // put your main code here, to run repeatedly:
  switch (f)
    {
    case fNone      :                     break;
    case fHeart_Rate: fHeart_Rate_loop(); break;
    case fRange     : fRange_loop     (); break;
    }
  //wdt_reset();
}

