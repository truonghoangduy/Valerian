#include <Arduino.h>
// #include <esp_camera.h>
// #include <BLEDevice.h>
// #include <BLEServer.h>
// #include <BLEUtils.h>
// #include <BLE2902.h>
#include <camera_pins.h>
#include <esp_camera.h>
#include <http_server_linker.h>
#include <ArduinoJson.h>
#include <SPIFFS.h>
#include <WiFi.h>
// #include <ESPmDNS.h>

#include "soc/soc.h" //disable brownout problems
#include "soc/rtc_cntl_reg.h"
#define CAMERA_MODEL_AI_THINKER

#define SERVICE_UUID "4fafc201-1fb5-459e-8fcc-c5c9c331914b"
#define CHARACTERISTIC_UUID "beb5483e-36e1-4688-b7f5-ea07361b26a8"
#define BLE_BUFFER 160

#define DEBUG_BUFFER
// BLEServer *pServer = NULL;
// BLECharacteristic *pCharacteristic = NULL;
bool deviceConnected = false;

const char *filename = "/config.json"; // SPIFFS config file
char *ssid = "NguyenDieuLinh";
char *password = "0937437499";
void setup()
{
  WRITE_PERI_REG(RTC_CNTL_BROWN_OUT_REG, 0); //disable brownout detector

  Serial.begin(115200);
  Serial.setDebugOutput(true);
  Serial.println("Hello World");

  initCamera_Config();
  delay(500);

  esp_err_t err = esp_camera_init(&camera_config);
  if (err != ESP_OK)
  {
    Serial.printf("Camera init failed with error 0x%x", err);
    return;
  }
  Serial.println("Init Cam Sussesfully");
  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED)
  {
    delay(500);
    Serial.print(".");
  }
  Serial.println("");
  Serial.println("WiFi connected");

  Serial.print("Camera Stream Ready! Go to: http://");
  Serial.print(WiFi.localIP());
  delay(100);
  startCameraServer();
}

void loop()
{
}



//   for (size_t i = 0; i < fb->len; i++)
//   {

//     buffer = *(fb->buf + i);
// #ifdef DEBUG_BUFFER
//     Serial.print(buffer);
//     Serial.print(" ");
// #endif
//     pCharacteristic->setValue(&buffer,1);
//     pCharacteristic->notify();
//     delay(70);
//   }
