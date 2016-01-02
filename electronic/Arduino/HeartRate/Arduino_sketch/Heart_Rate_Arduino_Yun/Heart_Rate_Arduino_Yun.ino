
#include <Bridge.h>
#include <BridgeServer.h>
#include <BridgeClient.h>
#include <SPI.h>


BridgeServer server;
 
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
  
  if (iTs == Ts_Max) 
    iTs= 0;
  else
    iTs++;
  }

void Traite_client()
  {
  BridgeClient client;  
  client= server.accept();  
  if (! client) return;
  
  String command = client.readString();
  command.trim();
  if (command == "pouls") 
    {
    client.print( "[\"");
    for (unsigned char i=0; i<=Ts_Max; i++)  
      {
      if (i)
        client.print( "\",\"");
      client.print( Ts[i]);
      }
    client.print( "\"]");
    }
  client.stop();
  }  
  
void loop() 
  {
  digitalWrite(13, state);   
  Traite_client();
  }
 
void setup() 
  {
  Serial.begin(115200);
  pinMode(13, OUTPUT);

  Serial.println("Debut setup");
  digitalWrite(13, LOW);
  
  Bridge.begin();
  server.noListenOnLocalhost();
  server.begin();

  attachInterrupt( digitalPinToInterrupt(2), interrupt, RISING);

  digitalWrite(13, HIGH);
  Serial.println("Fin setup");
  }
 
