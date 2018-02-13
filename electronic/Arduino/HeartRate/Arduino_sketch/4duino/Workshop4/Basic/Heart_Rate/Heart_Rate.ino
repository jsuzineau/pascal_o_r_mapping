//
// NB! This is a file generated from the .4Dino file, changes will be lost
//     the next time the .4Dino file is built
//
#include <SPI.h>
#include <math.h>

// Define LOG_MESSAGES to a serial port to send SPE errors messages to. Do not use the same Serial port as SPE
//#define LOG_MESSAGES Serial

#define RESETLINE     30

#define DisplaySerial Serial1


#include "Picaso_Serial_4DLib.h"
#include "Picaso_Const4D.h"

Picaso_Serial_4DLib Display(&DisplaySerial);

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
} // end Setup **do not alter, remove or duplicate this line**

class TButton
  {
  public:
  word state, x, y, buttonColour, txtColour, font, txtWidth, txtHeight;
  char *text;
  word width, height;
  TButton( word _state, word _x, word _y, word _buttonColour, word _txtColour,
           word _font, word _txtWidth, word _txtHeight, char *_text, word _width, word _height)
    : state(_state), x(_x), y(_y),
      buttonColour(_buttonColour), txtColour(_txtColour), font(_font),
      txtWidth(_txtWidth), txtHeight(_txtHeight), text(_text), width(_width), height(_height)
    {
    }
  void Draw()
     {
     Display.gfx_Button(state, x, y, buttonColour, txtColour, font, txtWidth, txtHeight, text) ;
     }
  boolean Touch( word _x, word _y)
     {
     boolean Result=((x <= _x)&&(_x <= x+width) && (y <= _y)&&(_y <= y+height));
     return Result;
     }
  };
class TIntLabel: public TButton
  {
  public:
  long *lValue;
  char cValue[80];
  TIntLabel( word _state, word _x, word _y, word _buttonColour, word _txtColour,
           word _font, word _txtWidth, word _txtHeight, long *_lValue, word _width, word _height)
   :TButton( _state, _x, _y, _buttonColour, _txtColour,
           _font, _txtWidth, _txtHeight, cValue, _width, _height),
    lValue( _lValue)
    {
    }
  void Draw()
     {
     sprintf( cValue, "%d", *lValue);
     TButton::Draw();
     }

  };
class TSlider
  {
  public:
  word mode, x1, y1, x2, y2, colour, scale, value;
  TSlider ( word _mode, word _x1, word _y1, word _x2, word _y2, word _colour, word _scale, word _value)
    :
     mode( _mode),
     x1( _x1),
     y1( _y1),
     x2( _x2),
     y2( _y2),
     colour( _colour),
     scale( _scale),
     value( _value)
     {
     }
   void Draw()
     {
     Display.gfx_Slider( mode, x1, y1, x2, y2, colour, scale, value);
     }
   boolean is_Horizontal() { return (x2-x1) >  (y2-y1); }
   boolean is_Vertical  () { return (x2-x1) <= (y2-y1); }
   word xyValue( word _x, word _y)
     {
     if   (is_Horizontal()) return _x-x1;
     else                   return _y-y1;
     }
   word xyScale()
     {
     if   (is_Horizontal()) return x2-x1;
     else                   return y2-y1;
     }
   boolean Touch( word _x, word _y)
     {
     boolean Result=((x1 <= _x)&&(_x <= x2) && (y1 <= _y)&&(_y <= y2));
     if (Result)
       {
       value= (xyValue( _x, _y)*scale) / xyScale();
       Draw();
       }

     return Result;
     }
  };

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

unsigned long old_y=0;
const int w4duino_dx=320; const int w4duino_max_x= w4duino_dx-1;
const int w4duino_dy=240; const int w4duino_max_y= w4duino_dy-1;
//const int pouls_min=20; const int pouls_max=200;
long pouls_min=40; long pouls_max=100;
const unsigned long ms_from_minute=60000;
const unsigned long ms_from_seconde=1000;
long temps_largeur_ecran= 30; //30s : 2 largeur d'écran par minute

//Display.gfx_Slider(SLIDER_RAISED, 42, 49, 285, 68, TURQUOISE, 100, 40) ;  // sX
     TSlider sTemps( SLIDER_RAISED, 42, 49, 285, 68, TURQUOISE, 60, 30);
//Display.gfx_Slider(SLIDER_RAISED, 42, 98, 282, 117, TURQUOISE, 100, 40) ;  // sMin
       TSlider sMin( SLIDER_RAISED, 42, 98, 282, 117, TURQUOISE, 100, 40);
//Display.gfx_Slider(SLIDER_RAISED, 42, 148, 282, 168, TURQUOISE, 100, 40) ;  // sMax
       TSlider sMax( SLIDER_RAISED, 42, 148, 282, 168, TURQUOISE, 200, 40);

//Display.gfx_Button(1, 140, 196, SILVER, BLACK, FONT3, 1, 1, "OK") ; // bOK Width=29 Height=21
         TButton bOK(1, 140, 196, SILVER, BLACK, FONT3, 1, 1, "OK",29,21);

//Display.gfx_Button(1, 175, 22, WHITE, BLACK, FONT1, 1, 1, "Temps") ; // bTemps Width=48 Height=17
         TIntLabel bTemps(1, 175, 22, WHITE, BLACK, FONT1, 1, 1, &temps_largeur_ecran,48,17);
//Display.gfx_Button(1, 156, 79, WHITE, BLACK, FONT1, 1, 1, "Min") ; // bMin Width=34 Height=17
         TIntLabel bMin(1, 156, 79, WHITE, BLACK, FONT1, 1, 1, &pouls_min,34,17);
//Display.gfx_Button(1, 153, 127, WHITE, BLACK, FONT1, 1, 1, "Max") ; // bMax Width=34 Height=17
         TIntLabel bMax(1, 153, 127, WHITE, BLACK, FONT1, 1, 1, &pouls_max,34,17);


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

  }
void fRange_unsetup()
  {
  f= fNone;
  }

//on déclare en volatile toutes les variables accédées dans l'interruption (car thread différent)
const unsigned char Ps_Size=40;
const unsigned char Ps_Max=Ps_Size-1;
class Pulsation
 {
 public:
   unsigned long T;
   unsigned long y;
   unsigned long dx;
   unsigned char Written;
   unsigned char Calc;
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
volatile unsigned char iPs=0;
volatile unsigned char state = LOW; //alternance des interruptions

//String NomFichier="";
//String linuxNomFichier= "";
//String urlNomFichier="";
void Log_to_File()
  {
  unsigned char All_written= true;

  for (unsigned char i=0; i<=Ps_Max; i++)
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
  for (unsigned char i=0; i<=Ps_Max; i++)
    {
    if (Ps[i].Written) continue;

    Calcul_Ti( i);
    //Display_Ti( i);
    //F.println( String(Ps[i].T));
    Ps[i].Written= true;
    }

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
void Calcul_Ti( unsigned char _i)
  {
  unsigned char i_1= _i > 0 ? _i-1 : Ps_Max;
  volatile Pulsation &P_1=Ps[ i_1];
  volatile Pulsation &P  =Ps[_i  ];
  unsigned long delta= P.T - P_1.T;
  unsigned long y= 0;
  unsigned long dx= 0;
  if (0==delta)
    {
     y=  P_1.y;
    dx=  P_1.dx;
    }
  else
    {
    double pouls= double(ms_from_minute) / (double)delta;
    if (pouls<pouls_min) pouls= pouls_min;
    if (pouls_max<pouls) pouls= pouls_max;
     y= w4duino_dy-cy*(pouls-pouls_min);
    dx= round(delta * cx);
    }
  P.y   =  y;
  P.dx  = dx;
  P.Calc=true;
  }
void Display_Ti( unsigned char _i)
  {
  volatile Pulsation &P  =Ps[ _i  ];
  unsigned long  y= P. y;
  unsigned long dx= P.dx;
  unsigned long largeur= w4duino_dx-dx;
  unsigned long old_x= largeur;

  Display.gfx_ScreenCopyPaste(dx, 0, 0, 0, largeur, w4duino_dy);
  //Display.gfx_Line(w4duino_max_x, 0, w4duino_max_x, w4duino_max_y, BLACK);   // draw line, can be patterned();
  Display.gfx_RectangleFilled(old_x,0,w4duino_max_x,w4duino_max_y, BLACK);    // draw filled rectangle
  Display.gfx_Line(old_x, old_y, w4duino_max_x, y, GREEN);   // draw line, can be patterned();
  //Display.gfx_PutPixel(w4duino_max_x, y, GREEN);            // set point at x y


  /*
  Serial.print( "pouls: "); Serial.print( pouls);
  Serial.print( " delta: "); Serial.print( delta);
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
  int y;
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
      for (unsigned char i=1; i<Ps_Size; i++)
        {
        TPoint &p_1=points[i-1]; if(p_1.Out()) continue;
        TPoint &p  =points[i  ]; if(p  .Out()) continue;
        if (p_1.x>p.x) continue;

        for (char j=0;j<3;j++)
          Display.gfx_Line(p_1.x,p_1.y+j, p.x, p.y+j, _color);
        }
      }
  public:
    TPoint points[Ps_Size];
    TPolyLine()
      {
      for (unsigned char i=1; i<Ps_Size; i++)
        {
        TPoint &p=points[i];
        p.x= 0;
        p.y= 0;
        }
      }
    void Set_point( unsigned char _i, int x, int y)
      {
      TPoint &p=points[_i];
      p.x= x;
      p.y= y;
      }
    void   Draw() {Draw_interne( GREEN);}
    void UnDraw() {Draw_interne( BLACK);}
  };

TPolyLine Old_Line;
void Display_T()
  {
  TPolyLine Line;

  //Display.gfx_Cls();
  unsigned char offset=iPs;
  long x= w4duino_max_x;
  for (int j=0; j>=-Ps_Max; j--)
    {
    int int_i= (offset+j) % Ps_Size;
    if (int_i<0) int_i+= Ps_Size;//le modulo C++ peut être négatif
    unsigned char i= int_i;
    unsigned char i_1= i > 0 ? i-1 : Ps_Max;

    volatile Pulsation &P_1=Ps[ i_1];
    volatile Pulsation &P  =Ps[ i  ];
    unsigned long y_1= P_1.y;
    unsigned long y  = P  .y;
    unsigned long dx = P  .dx;
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
  for (unsigned char i=0; i<=Ps_Max; i++)
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
  word y = Display.touch_Get(TOUCH_GETY);
  if (isPressed || isMoving)
    {
          if (sTemps.Touch( x, y)) { temps_largeur_ecran= sTemps.value; bTemps.Draw();}
    else  if (sMin  .Touch( x, y)) { pouls_min          = sMin  .value; bMin  .Draw();}
    else  if (sMax  .Touch( x, y)) { pouls_max          = sMax  .value; bMax  .Draw();}
    }
  if ((isPressed)&&(bOK.Touch( x, y)))
    {
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
}


