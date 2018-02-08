#include <SPI.h>

#define RESETLINE     30
#define DisplaySerial Serial1
#define LOG_MESSAGES


#include "Picaso_Const4D.h"
#include "Picaso_Serial_4DLib.h"
Picaso_Serial_4DLib Display(&DisplaySerial);

void setup() 
  {
  pinMode(RESETLINE, OUTPUT);       // Display reset pin
  digitalWrite(RESETLINE, 1);       // Reset Display, using shield
  delay(100);                       // wait for it to be recognised
  digitalWrite(RESETLINE, 0);       // Release Display Reset, using shield

  // now start display as Serial lines should have 'stabilised'
  DisplaySerial.begin(200000) ;     // Hardware serial to Display, same as SPE on display is set to
  Display.TimeLimit4D = 5000 ;      // 5 second timeout on all commands
  Display.Callback4D = mycallback ;

  attachInterrupt( digitalPinToInterrupt(2), interrupt, RISING);

  digitalWrite(13, HIGH);
  
  Display.print("Coucou\r\n");

  Initialise();  
  pinMode(13, OUTPUT);
  digitalWrite(13, LOW);
  }

//on déclare en volatile toutes les variables accédées dans l'interruption (car thread différent)
const unsigned char Ts_Size=20;
const unsigned char Ts_Max=Ts_Size-1;
volatile unsigned long Ts[Ts_Size];
volatile unsigned char Written[Ts_Size];
volatile unsigned char iTs=0;
volatile unsigned char state = LOW; //alternance des interruptions 

//String NomFichier="";
//String linuxNomFichier= "";
//String urlNomFichier="";
void Log_to_File()
  {
  unsigned char All_written= true;
    
  for (unsigned char i=0; i<=Ts_Max; i++)  
    {
    if (Written[i]) continue;

    All_written= false;
    break;
    }
  if (All_written) return;

  /*
  const int taille=1024;
  char lpstrNomFichier[taille];
  linuxNomFichier.toCharArray( lpstrNomFichier, taille);
  File F= FileSystem.open( lpstrNomFichier, FILE_APPEND); 
  for (unsigned char i=0; i<=Ts_Max; i++)  
    {
    if (Written[i]) continue;

    F.println( String(Ts[i]));
    Written[i]= true;
    }
  F.close();
  */
  }
  
void interrupt()
  {
  state= !state;  
  Ts[iTs]= millis();
  Written[iTs]=false;
  iTs= Ts_Max == iTs ? 0 : iTs+1;
  }

void Traite_data()
  {
  /*
  for (unsigned char i=0; i<=Ts_Max; i++)  
    Bridge.put( String(i), String(Ts[i]));
  */  
  Log_to_File();
  }  
  
void loop() 
  {
  Traite_data();
  digitalWrite(13, state);   
  }

void Initialise()
  {
  for (unsigned char i=0; i<=Ts_Max; i++)  
    {
    Ts[i]=0;
    Written[i]= true;
    }
  }

// routine to handle Serial errors
void mycallback(int ErrCode, unsigned char Errorbyte)
{
#ifdef LOG_MESSAGES
  const char *Error4DText[] = {"OK\0", "Timeout\0", "NAK\0", "Length\0", "Invalid\0"} ;
  Serial.print(F("Serial 4D Library reports error ")) ;
  Serial.print(Error4DText[ErrCode]) ;
  if (ErrCode == Err4D_NAK)
  {
    Serial.print(F(" returned data= ")) ;
    Serial.println(Errorbyte) ;
  }
  else
    Serial.println(F("")) ;
  //while (1) ; // you can return here, or you can loop
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
 
