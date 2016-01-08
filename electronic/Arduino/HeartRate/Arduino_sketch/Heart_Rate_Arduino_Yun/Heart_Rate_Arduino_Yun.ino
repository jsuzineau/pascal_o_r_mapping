#include <Bridge.h>
#include <SPI.h>
 
//on déclare en volatile toutes les variables accédées dans l'interruption (car thread différent)
const unsigned char Ts_Size=20;
const unsigned char Ts_Max=Ts_Size-1;
volatile unsigned long Ts[Ts_Size];
volatile unsigned char iTs=0;
volatile unsigned char state = LOW; //alternance des interruptions 

void interrupt()
  {
  state= !state;  
  Ts[iTs]= millis();
  iTs= Ts_Max == iTs ? 0 : iTs+1;
  }

void Traite_data()
  {
  for (unsigned char i=0; i<=Ts_Max; i++)  
    Bridge.put( String(i), String(Ts[i]));
  }  
  
void loop() 
  {
  Traite_data();
  digitalWrite(13, state);   
  }
 
void setup() 
  {
  pinMode(13, OUTPUT);
  digitalWrite(13, LOW);
  
  Bridge.begin();
  Bridge.put( "Ts_Size", String(Ts_Size));

  attachInterrupt( digitalPinToInterrupt(2), interrupt, RISING);

  digitalWrite(13, HIGH);
  }
 
