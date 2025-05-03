#include <ESP8266WiFi.h>
#include <Firebase_ESP_Client.h>
#include "addons/TokenHelper.h"
#include "addons/RTDBHelper.h"

#define WIFI_SSID "AUSTUDENT"
#define WIFI_PASSWORD "4592cdef0912"
#define API_KEY "AIzaSyAz_82v6TSJKNM4vl01L2gXUJ0ks8cKTGA"
#define DATABASE_URL "https://smart-c7a94-default-rtdb.firebaseio.com/"

FirebaseData fbdo;
FirebaseAuth auth;
FirebaseConfig config;

int soilMoisturePin = A0;
int moistureValue;


int getSoilMoisturePercent(int value) {
  int percent = map(value, 1023, 300, 0, 100);
  percent = constrain(percent, 0, 100);
  return percent;
}

void setup() {
  Serial.begin(9600);
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  Serial.print("Connecting");
  while (WiFi.status() != WL_CONNECTED) {
    Serial.print(".");
    delay(500);
  }
  Serial.println("Connected!");

  configTime(0, 0, "pool.ntp.org", "time.nist.gov");
  while (!time(nullptr)) {
    delay(1000);
    Serial.println("Waiting for time...");
  }

  config.api_key = API_KEY;
  config.database_url = DATABASE_URL;
  auth.user.email = "prabhanjanuv20040404@gmail.com";
  auth.user.password = "Prabhu@2004";

  Firebase.begin(&config, &auth);
  Firebase.reconnectWiFi(true);
}

void loop() {
  moistureValue = analogRead(soilMoisturePin);
  int moisturePercent = getSoilMoisturePercent(moistureValue);

  Serial.print("Moisture (%): ");
  Serial.println(moisturePercent);

  if (Firebase.RTDB.setInt(&fbdo, "/sensor/soil_moisture", moisturePercent)) {
    Serial.println("Sent to Firebase");
  } else {
    Serial.println("Failed: " + fbdo.errorReason());
  }

  delay(5000);
}
