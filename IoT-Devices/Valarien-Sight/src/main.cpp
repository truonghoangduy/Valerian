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
// #include <WiFi.h>
// #include <ESPmDNS.h>
#include <esp_http_server.h>
#include "soc/soc.h" //disable brownout problems
#include "soc/rtc_cntl_reg.h"

// Swithover Bluetooth Serial on Android
#include "BluetoothSerial.h"
#define CAMERA_MODEL_AI_THINKER

#define DEBUG_MODE
#ifdef DEBUG_MODE // setDebug mode

#endif

const char *filename = "/config.json"; // SPIFFS config file
<<<<<<< HEAD
char *ssid = "NguyenDieuLinh";
char *password = "0937437499";

// BLE Section
#define SERVICE_UUID "4fafc201-1fb5-459e-8fcc-c5c9c331914b"
};
void initBluetoothSerial()
>>>>>>> ba7a39622c03ae1a42e6848fdd95a1bd2235db05
{
  if (!SerialBT.begin("valarian-sight"))
  {
    Serial.println("Bluetooth Serial not Init");
    ESP.restart();
  else
  {
    Serial.println("Bluetooth Serial Initalized");
  }
  // blueSerial.register_callback()
}
void writeSerialBT(camera_fb_t *fb)
{
  SerialBT.write(fb->buf, fb->len); // Queue package alreay implemented
  SerialBT.flush();
}


// esp_spp_cb_event_t Enum for Bluetooth SerialCallBack type
void blueCallBack(esp_spp_cb_event_t event, esp_spp_cb_param_t *param)
{
  if (event == ESP_SPP_OPEN_EVT)
  {
    /* code */
  }
  else if (event = ESP_SPP_DATA_IND_EVT) // client send request
  {
    // param->data_ind.data
    String messege = String(*param->data_ind.data); // * *uint8_t => char
    Serial.println(messege);
  }
}
void capture()
{
  camera_fb_t *fb = NULL;
  esp_err_t res = ESP_OK;
  fb = esp_camera_fb_get();
  if (!fb)
  {
    esp_camera_fb_return(fb);
    return;
  }

  if (fb->format != PIXFORMAT_JPEG)
  {
    return;
  }

  writeSerialBT(fb);
  esp_camera_fb_return(fb);
}
void setCameraParam(int paramInt)
{
  sensor_t *s = esp_camera_sensor_get();
  switch (paramInt)
  {
  case 4:
    s->set_framesize(s, FRAMESIZE_UXGA);
    break;

  case 3:
    s->set_framesize(s, FRAMESIZE_SXGA);
    break;

  case 2:
    s->set_framesize(s, FRAMESIZE_XGA);
    break;

  case 1:
    s->set_framesize(s, FRAMESIZE_SVGA);
    break;

  case 0:
  default:
    s->set_framesize(s, FRAMESIZE_VGA);
    break;
  }

  capture();
}


void btCallback(esp_spp_cb_event_t event, esp_spp_cb_param_t *param)
{
  if (event == ESP_SPP_SRV_OPEN_EVT)
  {
    Serial.println("Client Connected!");
  }
  else if (event == ESP_SPP_DATA_IND_EVT)
  {
    Serial.printf("ESP_SPP_DATA_IND_EVT len=%d, handle=%d\n\n", param->data_ind.len, param->data_ind.handle);
    String stringRead = String(*param->data_ind.data);
    int paramInt = stringRead.toInt() - 48;
    Serial.printf("paramInt: %d\n", paramInt);
    setCameraParam(paramInt);
  }
}

void initBT()
{
  if (!SerialBT.begin("Valerian-Sight"))
  {
    Serial.println("An error occurred initializing Bluetooth");
    ESP.restart();
  }
  else
  {
    Serial.println("Bluetooth initialized");
  }

  SerialBT.register_callback(btCallback);
  Serial.println("The device started, now you can pair it with bluetooth");
}

<<<<<<< HEAD
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
  digitalWrite(22, LOW);
>>>>>>> ba7a39622c03ae1a42e6848fdd95a1bd2235db05

  esp_err_t err = esp_camera_init(&camera_config);
  if (err != ESP_OK)
  {
    return;
  }
  Serial.print("Heap Init CAM config");
  Serial.println(ESP.getFreeHeap());
  Serial.println("Init Cam Sussesfully");
  initBT();
}

void loop()
{
<<<<<<< HEAD
  // sendFakeData();
  // if (digitalRead(4) == HIGH)
  // {
  //   if (buttonActive == false)
  //   {

  //     buttonActive = true;
  //     buttonTimer = millis();
  //   }

  //   if ((millis() - buttonTimer > longPressTime) && (longPressActive == false))
}