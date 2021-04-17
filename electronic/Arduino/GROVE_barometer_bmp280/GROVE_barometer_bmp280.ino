#include <rgb_lcd.h>

//coef pression/altitude pour gagnac altitude 118m
//>>> a=(1-(0.0065*118)/288.15)**5.255
//>>> a
//0.9860911829528476

//
/*
 * bmp280_example.ino
 * Example sketch for BMP280
 *
 * Copyright (c) 2016 seeed technology inc.
 * Website    : www.seeedstudio.com
 * Author     : Lambor, CHN
 * Create Time:
 * Change Log :
 *
 * The MIT License (MIT)
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */
#include "Seeed_BMP280.h"
#include <Wire.h>

BMP280 bmp280;
rgb_lcd lcd;

void setup()
  {
  lcd.begin(16, 2);
  
  Serial.begin(9600);
  if(!bmp280.init()) 
    {
    Serial.println("Device not connected or broken!");
    }
}

void loop()
  {
  //Temperature
  float T=bmp280.getTemperature();
  Serial.print("Temperature="); //°C
  Serial.println(T);

  //Pressure
  float pressure;
  Serial.print("Pressure="); //Pa
  Serial.println(pressure = bmp280.getPressure());

  float p_gagnac=pressure/0.9860911829528476;
  //Serial.print("Pression_corrigee_118_m_Gagnac=");//Pa
  //Serial.println(p_gagnac);

  
  //Altitude
  //Serial.print("Altitude="); //m
  //Serial.print(bmp280.calcAltitude(pressure));

  Serial.println("#");//add a line between output of different times.
  
  lcd.clear();
  lcd.setCursor( 0, 0); lcd.print( "P: ");lcd.print( p_gagnac/100);lcd.print( " hPa");
  lcd.setCursor( 0, 1); lcd.print( "T: ");lcd.print( T);lcd.print( " deg C");

  delay(1000);
  }
