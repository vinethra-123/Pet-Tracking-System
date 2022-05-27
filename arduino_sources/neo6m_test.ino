
#include <TinyGPS++.h>
#include <SoftwareSerial.h>

TinyGPSPlus gps;

SoftwareSerial GPS(4, 5); 

void setup()
{
  Serial.begin(9600);
  GPS.begin(9600);
  Serial.println("NEO-6M GPS Module");
  Serial.print("Connecting..."); delay(100); Serial.print("."); delay(100); Serial.print("."); delay(100); Serial.print("."); delay(100); Serial.print("."); delay(100); Serial.print("."); delay(100);delay(100); Serial.print("."); delay(100); Serial.print("."); delay(100); Serial.print("."); delay(100); Serial.print("."); delay(100); Serial.print("."); delay(100);delay(100); Serial.print("."); delay(100); Serial.print("."); delay(100); Serial.print("."); delay(100); Serial.print("."); delay(100); Serial.print("."); delay(100);delay(100); Serial.print("."); delay(100); Serial.print("."); delay(100); Serial.print("."); delay(100); Serial.print("."); delay(100); Serial.print("."); delay(100);delay(100); Serial.print("."); delay(100); Serial.print("."); delay(100); Serial.print("."); delay(100); Serial.print("."); delay(100); Serial.print("."); delay(100);delay(100); Serial.print("."); delay(100); Serial.print("."); delay(100); Serial.print("."); delay(100); Serial.print("."); delay(100); Serial.print("."); delay(100);delay(100); Serial.print("."); delay(100); Serial.print("."); delay(100); Serial.print("."); delay(100); Serial.print("."); delay(100); Serial.print("."); delay(100);delay(100); Serial.print("."); delay(100); Serial.print("."); delay(100); Serial.print("."); delay(100); Serial.print("."); delay(100); Serial.print("."); delay(100);delay(100); Serial.print("."); delay(100); Serial.print("."); delay(100); Serial.print("."); delay(100); Serial.print("."); delay(100); Serial.print("."); delay(100);delay(100); Serial.print("."); delay(100); Serial.print("."); delay(100); Serial.print("."); delay(100); Serial.print("."); delay(100); Serial.print("."); delay(100); 
  Serial.println(" ");
}

void loop()
{
  while (GPS.available() > 0)
    if (gps.encode(GPS.read()))
      displayInfo();

  if (millis() > 5000 && gps.charsProcessed() < 10)
  {
    Serial.println(F("No GPS detected: check wiring."));
    while (true);
  }
}

void displayInfo()
{
  Serial.print(F("Location: "));
  if (gps.location.isValid())
  {
    Serial.print(gps.location.lat(), 6);
    Serial.print(F(","));
    Serial.print(gps.location.lng(), 6);
  }
  else
  {
    Serial.print(F("INVALID"));
  }

  Serial.print(F("  Date/Time: "));
  if (gps.date.isValid())
  {
    Serial.print(gps.date.month());
    Serial.print(F("/"));
    Serial.print(gps.date.day());
    Serial.print(F("/"));
    Serial.print(gps.date.year());
  }
  else
  {
    Serial.print(F("INVALID"));
  }

  Serial.print(F(" "));
  if (gps.time.isValid())
  {
    if (gps.time.hour() < 10) Serial.print(F("0"));
    Serial.print(gps.time.hour());
    Serial.print(F(":"));
    if (gps.time.minute() < 10) Serial.print(F("0"));
    Serial.print(gps.time.minute());
    Serial.print(F(":"));
    if (gps.time.second() < 10) Serial.print(F("0"));
    Serial.print(gps.time.second());
    Serial.print(F("."));
    if (gps.time.centisecond() < 10) Serial.print(F("0"));
    Serial.print(gps.time.centisecond());
  }
  else
  {
    Serial.print(F("INVALID"));
  }

  Serial.println();
  
}
