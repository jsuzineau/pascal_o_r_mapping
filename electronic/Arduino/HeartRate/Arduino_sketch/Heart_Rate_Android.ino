/************************* 2011 Seeedstudio **************************
* File Name : Heart rate sensor.pde
* Author : Seeedteam
* Version : V1.0
* Date : 30/12/2011
* Description : This program can be used to measure heart rate,
the lowest pulse in the program be set to 30.
*************************************************************************/
 
//Modified by @BuildingIoT
//for communication with Android
 
#include <SPI.h>
#include <Adb.h>
 
// Adb connection.
Connection * connection;
 
// Elapsed time for ADC sampling
long lastTime;
 
unsigned char pin = 13;
unsigned char counter=0;
unsigned int heart_rate=0;
unsigned long temp[21];
unsigned long sub=0;
volatile unsigned char state = LOW;
bool data_effect=true;

//you can change it follow your system's request.3000 meams 3 seconds. System return error if the duty overtrip 2 second.
const int max_heartpulse_duty=3000;
 
void setup() 
  {
  pinMode(pin, OUTPUT);
  Serial.begin(115200);
  //Serial.println("Please put on the ear clip.");
  //delay(5000);
  
  array_init();
  //Serial.println("Heart rate test begin.");
  Serial.println(0);
  attachInterrupt(0, interrupt, RISING);//set interrupt 0,digital port 2
   
  // Initialise the ADB subsystem.
  ADB::init();
   
  // Open an ADB stream to the phone's shell. Auto-reconnect
  connection = ADB::addConnection("tcp:4568", true, adbEventHandler);
  }
 
void loop() 
  {
  digitalWrite(pin, state);   
  }
 
void sum()//calculate the heart rate
  {
  if (data_effect)
    {
    heart_rate= 1200000 / (temp[20]-temp[0]);//60*20*1000/20_total_time
    //Serial.print("Heart_rate_is:\t");
    Serial.println( heart_rate);
    connection->write(2, (uint8_t*)&heart_rate);
    ADB::poll();
    }
  data_effect=1;//sign bit
  }
  
void interrupt()
  {
  temp[counter]=millis();
  state = !state;
  //Serial.println(counter,DEC);
  //Serial.println(temp[counter]);
  switch(counter)
    {
    case(0):
      sub=temp[counter]-temp[20];
      //Serial.println(sub);
      break;
    default:
      sub=temp[counter]-temp[counter-1];
      //Serial.println(sub);
      break;
    }
  if(sub>max_heartpulse_duty)//set 2 seconds as max heart pulse duty
    {
    data_effect=0;//sign bit
    counter=0;
    Serial.println("Heart rate measure error,test will restart!" );
    array_init();
    }
  if (counter==20&&data_effect)
    {
    counter=0;
    sum();
    }
  else if(counter!=20&&data_effect)
    counter++;
  else
    {
    counter=0;
    data_effect=1;
    }
  }
  
void array_init()
  {
  for(unsigned char i=0;i!=20;++i)
    {
    temp[i]=0;
    }
  temp[20]=millis();
  }

// Event handler for the shell connection.
void adbEventHandler(Connection * connection, adb_eventType event, uint16_t length, uint8_t * data)
  {
   
  }
