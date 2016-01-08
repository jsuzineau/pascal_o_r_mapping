#include <SPI.h>
#include <Bridge.h>
#include <FileIO.h>

 
//on déclare en volatile toutes les variables accédées dans l'interruption (car thread différent)
const unsigned char Ts_Size=20;
const unsigned char Ts_Max=Ts_Size-1;
volatile unsigned long Ts[Ts_Size];
volatile unsigned char Written[Ts_Size];
volatile unsigned char iTs=0;
volatile unsigned char state = LOW; //alternance des interruptions 
String NomFichier="";
String linuxNomFichier= "";
String urlNomFichier="";
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
  for (unsigned char i=0; i<=Ts_Max; i++)  
    Bridge.put( String(i), String(Ts[i]));
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
 
// This function return a string with the time stamp
String getTimeStamp() {
  String result;
  Process time;
  // date is a command line utility to get the date and the time
  // in different formats depending on the additional parameter
  time.begin("date");
  time.addParameter("+%Y_%m_%d__%Hh%Mmin%Ss");  // parameters: D for the complete date mm/dd/yy
  //             T for the time hh:mm:ss
  time.run();  // run the command

  // read the output of the command
  while (time.available() > 0) {
    char c = time.read();
    if (c != '\n') {
      result += c;
    }
  }

  return result;
}

void setup() 
  {
  Initialise();  
  pinMode(13, OUTPUT);
  digitalWrite(13, LOW);
  
  Bridge.begin();
  NomFichier= "/sd/"+getTimeStamp()+".txt";//au plus prés du début du programme mais aprés Bridge.begin
  linuxNomFichier= "/www"+NomFichier;
  
  Bridge.put( "Ts_Size", String(Ts_Size));
  FileSystem.begin();

  attachInterrupt( digitalPinToInterrupt(2), interrupt, RISING);

  digitalWrite(13, HIGH);
  
  Bridge.put( "NomFichier", NomFichier);
  }
 
