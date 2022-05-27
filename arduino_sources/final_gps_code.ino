#include <ESP8266wifi.h>
#include <TinyGPS++.h>
#include <SoftwareSerial.h>
#include <FirebaseArduino.h>

TinyGPSPlus gps;

SoftwareSerial GPS(4, 5);

#define FIREBASE_HOST "pettracking-e0ec8.firebaseapp.com"
#define FIREBASE_AUTH "AIzaSyCefkXO93MYvw4gGkljXuE0Y_jWr-Q29zY"
#define WIFI_SSID "HOME WIFI"
#define WIFI_PASSWORD "12345678"
#define ID "testdeviceid"

float latitude , longitude;
String lat_str , lng_str , date_str, Date;

void setup() {
  Serial.begin(115200);

  // connect to wifi.
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  Serial.print("connecting");
  while (WiFi.status() != WL_CONNECTED) {
    Serial.print(".");
    delay(500);
  }
  Serial.println();
  Serial.print("connected: ");
  Serial.println(WiFi.localIP());

  Firebase.begin(FIREBASE_HOST, FIREBASE_AUTH);

  GPS.begin(9600);
  Serial.println("NEO-6M GPS Module");
  Serial.print("Connecting...");
  Serial.println(" ");
}

int n = 0;

void loop() {
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
    latitude = gps.location.lat();
    lat_str = String(latitude , 6);
    Serial.print(F(","));
    Serial.print(gps.location.lng(), 6);
    longitude = gps.location.lng();
    lng_str = String(longitude , 6);
    Firebase.setString("devices/" + ID, lat_str + "," + lng_str);
    delay(500);
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

    // Date = String(gps.date.month()) + "/" + String(gps.date.day()) + "/" + String(gps.date.year());
    // Firebase.setString("devices/" + ID + "/date", Date);
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
