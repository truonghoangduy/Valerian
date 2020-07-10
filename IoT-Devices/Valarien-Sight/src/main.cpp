#include <Arduino.h>
// #include <esp_camera.h>
// #include <BLEDevice.h>
// #include <BLEServer.h>
// #include <BLEUtils.h>
// #include <BLE2902.h>
#include <camera_pins.h>
#include <esp_camera.h>
// #include <http_server_linker.h>
// #include <ArduinoJson.h>
// #include <SPIFFS.h>
// #include <WiFi.h>
// #include <ESPmDNS.h>
// #include <esp_http_server.h>
#include "soc/soc.h" //disable brownout problems
#include "soc/rtc_cntl_reg.h"

// Swithover Bluetooth Serial on Android
#include "BluetoothSerial.h"
#define CAMERA_MODEL_AI_THINKER

#define DEBUG_MODE
#ifdef DEBUG_MODE // setDebug mode

#endif

const char *filename = "/config.json"; // SPIFFS config file
char *ssid = "HSU_Students";
char *password = "dhhs12cnvch";
BluetoothSerial SerialBT;
camera_fb_t *fb = NULL;
uint8_t  buffer= NULL;

enum BLUE_MESSAGE
{

};
void writeSerialBT(camera_fb_t *fb)
{

//     for (size_t i = 0; i < fb->len; i++)
//   {

//     buffer = *(fb->buf + i);
// // #ifdef DEBUG_MODE
// //     Serial.print((char)buffer);
// //     Serial.print(" ");
// // #endif
//     // pCharacteristic->setValue(&buffer,1);
//     // pCharacteristic->notify();
//     SerialBT.write(&buffer,1);
//       // SerialBT.flush();
//     delay(5);
//   }
  SerialBT.write(fb->buf, fb->len); // Queue package alreay implemented
  SerialBT.flush();

  if (SerialBT.getWriteError() == 1)
  {
    Serial.println("Fail to send");
    SerialBT.write(fb->buf, fb->len); // Queue package alreay implemented
    SerialBT.flush();
  }
}

// esp_spp_cb_event_t Enum for Bluetooth SerialCallBack type
// void blueCallBack(esp_spp_cb_event_t event, esp_spp_cb_param_t *param)
// {
//   if (event == ESP_SPP_OPEN_EVT)
//   {
//     /* code */
//   }
//   else if (event = ESP_SPP_DATA_IND_EVT) // client send request
//   {
//     // param->data_ind.data
//     String messege = String(*param->data_ind.data); // * *uint8_t => char
//     Serial.println(messege);
//   }
// }

void capture()
{

  esp_err_t res = ESP_OK;
  // digitalWrite(4, HIGH);
  // delay(100);
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
  // digitalWrite(4, LOW);
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
    s->set_framesize(s, FRAMESIZE_CIF);
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
  if (SerialBT.available() == 1)
  {
    Serial.println("Alrealy Stuck on Bluetooth Serial");
    SerialBT.end();
  }
  
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
void setup()
{
  WRITE_PERI_REG(RTC_CNTL_BROWN_OUT_REG, 0); //disable brownout detector

  Serial.begin(115200);
  Serial.setDebugOutput(true);
  Serial.println("Hello World");
  Serial.print("Heap");
  Serial.println(ESP.getFreeHeap());
  // pinMode(4, OUTPUT);
  initBT();

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