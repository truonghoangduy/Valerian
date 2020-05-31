#include <Arduino.h>
// #include <esp_camera.h>
#include <camera_pins.h>
#include <esp_camera.h>
#include <http_server_linker.h>
#include <ArduinoJson.h>
#include <SPIFFS.h>
#include <WiFi.h>
// mDNS
#include <ESPmDNS.h>
#include <esp_http_server.h>
#include "soc/soc.h" //disable brownout problems
#include "soc/rtc_cntl_reg.h"
#define BLE_BUFFER 160
#define DEBUG_BUFFER

#define CAMERA_MODEL_AI_THINKER

const char *filename = "/config.json"; // SPIFFS config file
char *ssid = ""; // YOUR GUYS Wifi
char *password = "";


void turnOnWifiMode()
{
  // Serial.println("Init Cam Sussesfully");
  // WiFi.mode(WIFI_STA);

  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED)
  {
    delay(500);
    Serial.print(".");
  }
  Serial.println("");
  Serial.println("WiFi connected");

  delay(400);

  if (!MDNS.begin("valerian"))
  {
    Serial.println("Error setting up MDNS responder!");
    delay(300);
  }
  // MDNS.addServiceTxt("_http","_tcp","caputre","caputre");
  

  startCameraServer();
    // MDNS.addService("_http", "_tcp", 80);

  // MDNS.addService("_http", "_tcp", 80);
  Serial.print("Camera Stream Ready! Go to: http://");
  Serial.print(WiFi.localIP());
}

void setup()
{
  WRITE_PERI_REG(RTC_CNTL_BROWN_OUT_REG, 0); //disable brownout detector

  Serial.begin(115200);
  Serial.setDebugOutput(true);
  Serial.println("Hello World");
  Serial.print("Heap");
  Serial.println(ESP.getFreeHeap());

  initCamera_Config();
  delay(500);


  esp_err_t err = esp_camera_init(&camera_config);
  if (err != ESP_OK)
  {
    Serial.printf("Camera init failed with error 0x%x", err);
    return;
  }
  Serial.print("Heap Init CAM config");
  Serial.println(ESP.getFreeHeap());
  Serial.println("Init Cam Sussesfully");
  turnOnWifiMode();
}

void turnOffWifiMode()
{
  stopcamServer();
  WiFi.disconnect(true, true);
  // MDNS.end();
}

void loop()
{
 
}
