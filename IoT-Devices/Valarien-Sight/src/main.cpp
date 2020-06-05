#include <Arduino.h>
// #include <esp_camera.h>
#include <BLEDevice.h>
#include <BLEServer.h>
#include <BLEUtils.h>
#include <BLE2902.h>
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
char *ssid = "NguyenDieuLinh";
char *password = "0937437499";

// BLE Section
#define SERVICE_UUID "4fafc201-1fb5-459e-8fcc-c5c9c331914b"
#define CHARACTERISTIC_UUID "beb5483e-36e1-4688-b7f5-ea07361b26a8"

BLEServer *pServer = NULL;
BLECharacteristic *pCharacteristic = NULL;
bool deviceConnected = false;
//
// Button Section
boolean buttonActive = false;
boolean longPressActive = false;
long buttonTimer = 0;
byte longPressTime = 250;

//

class BLECharectoristicCallBack : public BLECharacteristicCallbacks
{
  void onWrite(BLECharacteristic *pCharacteristic)
  {
    // pCharacteristic->getData();
    std::string value = pCharacteristic->getValue();

    if (value.length() > 0)
    {
      Serial.println(value.c_str());
      digitalWrite(22, HIGH);
      Serial.println(ESP.getFreeHeap());
      // Serial.println(ESP.getfree;
    }
  }
};

class MyServerCallbacks : public BLEServerCallbacks
{
  void onConnect(BLEServer *pServer)
  {
    Serial.println("BLE Client Connected");
    BLEDevice::startAdvertising();
  };

  void onDisconnect(BLEServer *pServer)
  {
    deviceConnected = false;
  }
};
void initBLEMod()
{
  BLEDevice::init("ESP32 Valarien Sight");
  pServer = BLEDevice::createServer();

  pServer->setCallbacks(new MyServerCallbacks());
  // Create the BLE Service
  BLEService *pService = pServer->createService(SERVICE_UUID);
  // Create a BLE Characteristic
  pCharacteristic = pService->createCharacteristic(
      CHARACTERISTIC_UUID,
      BLECharacteristic::PROPERTY_READ |
          BLECharacteristic::PROPERTY_WRITE |
          BLECharacteristic::PROPERTY_NOTIFY |
          BLECharacteristic::PROPERTY_INDICATE);
  pCharacteristic->setCallbacks(new BLECharectoristicCallBack());

  pCharacteristic->addDescriptor(new BLE2902());
  pService->start();

  BLEAdvertising *pAdvertising = BLEDevice::getAdvertising();
  pAdvertising->addServiceUUID(SERVICE_UUID);
  pAdvertising->setScanResponse(false);
  pAdvertising->setMinPreferred(0x0); // set value to 0x00 to not advertise this parameter
  BLEDevice::startAdvertising();
  Serial.println("Waiting a client connection to notify...");
}
uint8_t value = 0;

void sendFakeData()
{
  pCharacteristic->setValue(&value, 4);
  pCharacteristic->notify();
  delay(1000);
  value++;
}

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

  // if (!MDNS.begin("valerian"))
  // {
  //   Serial.println("Error setting up MDNS responder!");
  //   delay(300);
  // }
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
  // pinMode(4, INPUT);

  initCamera_Config();
  delay(500);
  // pinMode(22, INPUT);
  // digitalWrite(22, LOW);

  esp_err_t err = esp_camera_init(&camera_config);
  if (err != ESP_OK)
  {
    Serial.printf("Camera init failed with error 0x%x", err);
    return;
  }
  Serial.print("Heap Init CAM config");
  Serial.println(ESP.getFreeHeap());
  Serial.println("Init Cam Sussesfully");
  // initBLEMod();
  turnOnWifiMode();
}

void turnOffWifiMode()
{
  stopcamServer();
  WiFi.disconnect(true, true);
  // MDNS.end();
}
int closingcounter = 4;
// void loop()
// {
//   if (Serial.available() > 0)
//   {
//     if (Serial.readString() == "1")
//     {
//       turnOnWifiMode();
//       delay(5000);
//       turnOffWifiMode();
//       Serial.println("");
//     }

//   }
// }

void loop()
{
  // sendFakeData();
  // if (digitalRead(4) == HIGH)
  // {
  //   if (buttonActive == false)
  //   {

  //     buttonActive = true;
  //     buttonTimer = millis();
  //   }

  //   if ((millis() - buttonTimer > longPressTime) && (longPressActive == false))
  //   {
  // 	Serial.println("Deinit BLE");
  //     BLEDevice::deinit(false);

  //     longPressActive = true;
  //     Serial.print("Start Server");
  //     turnOnWifiMode();
  //   }
  // }
  // else
  // {

  //   if (buttonActive == true)
  //   {

  //     if (longPressActive == true)
  //     {

  //       longPressActive = false;
  //     }
  //     else
  //     {
  //       Serial.print("Start BLE");
  // 	turnOffWifiMode();
  //       initBLEMod();
  //     }

  //     buttonActive = false;
  //   }
  // }
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
