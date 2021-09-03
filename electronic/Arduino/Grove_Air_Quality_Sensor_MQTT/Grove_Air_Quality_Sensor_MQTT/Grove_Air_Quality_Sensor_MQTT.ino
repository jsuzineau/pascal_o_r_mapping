/*
    Grove_Air_Quality_Sensor.ino
    Demo for Grove - Air Quality Sensor.

    Copyright (c) 2019 seeed technology inc.
    Author    : Lets Blu
    Created Time : Jan 2019
    Modified Time:

    The MIT License (MIT)

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in
    all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
    THE SOFTWARE.
*/
#include "Air_Quality_Sensor.h"

AirQualitySensor sensor(A0);

//https://projetsdiy.fr/mosquitto-broker-mqtt-raspberry-pi/
//https://projetsdiy.fr/debuter-node-red-raspberry-pi-installation-autostart/
// https://github.com/vortex314/serial2mqtt

/* serial2mqtt.json
{
 "mqtt": 
   {
   "connection": "tcp://localhost:1883"
   },
 "serial":
   {
   "protocol": "jsonArray"
   },
 "log": 
   {
   "protocol": true,
   "debug": true,
   "useColors": true
   }
}
 
*/
class Mqtt 
  {
  public:
    static void publish(int qos, bool retain, String topic, String message ) 
      {
      Serial.println( "[1,\""+topic+"\",\""+message+"\",\""+String(qos)+"\",\""+String(retain)+"\"]"); 
      }
  };

void setup(void) 
    {
    Serial.begin(115200);
    while (!Serial);

    //Serial.println("Waiting sensor to init...");
    delay(20000);

    /*
    if (sensor.init())
      {   
      Serial.println("[0,\"dst/DEVICE/+\"]");
      Serial.println("[1,\"dst/DEVICE/system/loopback\",\"true\"]");
      }
    */
    if (sensor.init()) Serial.println("Sensor ready.");
    else               Serial.println("Sensor ERROR!");    
    
    }

int i = 0;
void loop(void) 
    {
    int quality = sensor.slope();
    //Serial.println("[1,\"quality\",\""+String(quality)+"\"]"); 
    int value = sensor.getValue();
    //Serial.println("[1,\"value\",\""+String(value)+"\"]"); 

    String  message=String(i++);
    Mqtt::publish(0, false, "src/arduino1/system/upTime", message);
    Mqtt::publish(0,false,"src/arduino1/system/host"    ,"arduino1");
    Mqtt::publish(0,false,"src/First-Boss.USB0/serial2mqtt/quality" ,String(quality));
    Mqtt::publish(0,false,"src/First-Boss.USB0/serial2mqtt/value"   ,String(value));

    //Serial.print("Sensor value: ");
    //Serial.println(sensor.getValue());
    
    /*
    switch (quality)
      {
      case AirQualitySensor::FORCE_SIGNAL  : Serial.println("High pollution! Force signal active."); break;
      case AirQualitySensor::HIGH_POLLUTION: Serial.println("High pollution!"                     ); break;
      case AirQualitySensor::LOW_POLLUTION : Serial.println("Low pollution!"                      ); break;
      case AirQualitySensor::FRESH_AIR     : Serial.println("Fresh air."                          ); break;
      }
    */  

    delay(1000);
    }


/*   contenu du fichier  serial2mqtt.json 
 *    pour serial2mqtt.x86_64 provenant de https://github.com/vortex314/serial2mqtt
 *    téléchargé depuis https://github.com/vortex314/serial2mqtt/build
 *    tests avec le broker mosquitto https://mosquitto.org/ lancé par la commande mosquitto
 *    et avec la commande mosquitto_sub
 *    et avec node-red (http://nodered.org) lancé avec la commande node-red
{
 "mqtt": 
   {
   "connection": "tcp://localhost:1883"
   },
 "serial":
   {
   "protocol": "jsonArray"
   },
 "log": 
   {
   "protocol": true,
   "debug": true,
   "useColors": true
   }
}

      
*/ 
