#include <Arduino.h>
// #include <esp_camera.h>
// #include <BLEDevice.h>
// #include <BLEServer.h>
// #include <BLEUtils.h>
// #include <BLE2902.h>
// #include <camera_pins.h>
// #include <esp_camera.h>
// #include <http_server_linker.h>
// #include <ArduinoJson.h>
// #include <SPIFFS.h>
// #include <WiFi.h>
// #include <ESPmDNS.h>
// #include <esp_http_server.h>
#include "soc/soc.h" //disable brownout problems
#include "soc/rtc_cntl_reg.h"
#include "OneButton.h"
#define INPUT_PINS 15
#include "display.h"
OneButton oneButton(INPUT_PINS, false, false);

// Swithover Bluetooth Serial on Android
#include "BluetoothSerial.h"

#if !defined(CONFIG_BT_ENABLED) || !defined(CONFIG_BLUEDROID_ENABLED)
#error Bluetooth is not enabled! Please run `make menuconfig` to and enable it
#endif

#define CAMERA_MODEL_AI_THINKER

#define DEBUG_MODE
#ifdef DEBUG_MODE // setDebug mode

#endif

const char *filename = "/config.json"; // SPIFFS config file
char *ssid = "NguyenDieuLinh";
char *password = "0937437499";
char EOL = '\0';
BluetoothSerial SerialBT;

char stop = '\n';

enum Board_State
{
  NOTIFICATION,
  TEXT,
  DECTION
} Board_State;

void displayConfig(String mesges, int opCode)
{

  if (opCode == NOTIFICATION)
  {
    Serial.printf("Hello\n");
    Serial.println(mesges);
    // showDisplay(mesges);
    // showDisplay();
  }
  else if (opCode == TEXT)
  {
    Serial.printf("Me may\n");
    Serial.println(mesges);
    showMessenge(mesges);
  }
  else if (opCode == DECTION)
  {
    Serial.printf("Fuck u\n");
  }
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
    // String stringRead = String((char *)param->data_ind.data);
    // int paramInt = stringRead.toInt() - 48;
    // Serial.printf("paramInt: %d\n", paramInt);
    String mesges = SerialBT.readStringUntil(stop);
    // mesges.remove()
    int opCode = ((String)mesges.charAt(0)).toInt();

    displayConfig(mesges.substring(1), opCode);
    // testdrawtext((char *)mesges.c_str(),ST7735_WHITE);
    // Serial.println((char *)param->data_ind.data);   // setCameraParam(paramInt);
  }else if(event == ESP_SPP_CLOSE_EVT ){
    Serial.println("Client disconnected");
  }
  
  
}

void initBT()
{
  if (!SerialBT.begin("Valerian-Display-Test01"))
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
void callBackLongPressStop()
{

  Serial.println("hello");
  Serial.println(sizeof(DECTION));
  if (SerialBT.hasClient())
  {
    Serial.println("Send Messages");
    int encode = (int) DECTION;
    // SerialBT.write((uint8_t *)&encode, sizeof(encode));
    // SerialBT.write((uint8_t *)&EOL, sizeof(EOL));
    // SerialBT.write((uint8_t *)&stop, sizeof(stop));
    SerialBT.println(encode);SerialBT.flush();
  }
}
void callBackDuringLongPressStop()
{

  Serial.println("callBackDuringLongPressStop");
}

void setup()
{
  Serial.begin(115200);
  // SerialBT.begin("ESP32test"); //Bluetooth device name
  Serial.setDebugOutput(true);

  pinMode(INPUT_PINS, OUTPUT);

  // Serial.println("The device started, now you can pair it with bluetooth!");
  // displaysetup();
  // showDisplay();
  // delay(2000);
  initBT();
  oneButton.setDebounceTicks(2000);
  oneButton.setPressTicks(2000);
  oneButton.attachLongPressStop(callBackLongPressStop);
  // oneButton.attachDuringLongPress(callBackLongPressStop);
}

void loop()
{
  oneButton.tick();
  // Serial.println(digitalRead(INPUT_PINS));
  // tft.invertDisplay(true);
  // delay(2000);
  // tft.invertDisplay(false);
  // delay(2000);
  // if (Serial.available()) {
  //   SerialBT.write(Serial.read());
  // }
  // if (SerialBT.available()) {
  // //   String  data = SerialBT.readStringUntil(stop);
  // //   testdrawtext((char *) data.c_str(),ST7735_WHITE);
  // //   // Serial.write(data);
  // //   delay(300);
  // }
  // delay(20);
}

// enum BLUE_MESSAGE
// {

// };
// void initBluetoothSerial()
// {
//   if (!SerialBT.begin("valarian-sight"))
//   {
//     Serial.println("Bluetooth Serial not Init");
//     ESP.restart();
//   }
//   else
//   {
//     Serial.println("Bluetooth Serial Initalized");
//   }
//   // blueSerial.register_callback()
// }
// void writeSerialBT(camera_fb_t *fb)
// {
//   SerialBT.write(fb->buf, fb->len); // Queue package alreay implemented
//   SerialBT.flush();
// }

// // esp_spp_cb_event_t Enum for Bluetooth SerialCallBack type
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
// void capture()
// {
//   camera_fb_t *fb = NULL;
//   esp_err_t res = ESP_OK;
//   fb = esp_camera_fb_get();
//   if (!fb)
//   {
//     esp_camera_fb_return(fb);
//     return;
//   }

//   if (fb->format != PIXFORMAT_JPEG)
//   {
//     return;
//   }

//   writeSerialBT(fb);
//   esp_camera_fb_return(fb);
// }
// void setCameraParam(int paramInt)
// {
//   sensor_t *s = esp_camera_sensor_get();
//   switch (paramInt)
//   {
//   case 4:
//     s->set_framesize(s, FRAMESIZE_UXGA);
//     break;

//   case 3:
//     s->set_framesize(s, FRAMESIZE_SXGA);
//     break;

//   case 2:
//     s->set_framesize(s, FRAMESIZE_XGA);
//     break;

//   case 1:
//     s->set_framesize(s, FRAMESIZE_SVGA);
//     break;

//   case 0:
//   default:
//     s->set_framesize(s, FRAMESIZE_VGA);
//     break;
//   }

//   capture();
// }

// void btCallback(esp_spp_cb_event_t event, esp_spp_cb_param_t *param)
// {
//   if (event == ESP_SPP_SRV_OPEN_EVT)
//   {
//     Serial.println("Client Connected!");
//   }
//   else if (event == ESP_SPP_DATA_IND_EVT)
//   {
//     Serial.printf("ESP_SPP_DATA_IND_EVT len=%d, handle=%d\n\n", param->data_ind.len, param->data_ind.handle);
//     String stringRead = String(*param->data_ind.data);
//     int paramInt = stringRead.toInt() - 48;
//     Serial.printf("paramInt: %d\n", paramInt);
//     setCameraParam(paramInt);
//   }
// }

// void initBT()
// {
//   if (!SerialBT.begin("Valerian-Sight"))
//   {
//     Serial.println("An error occurred initializing Bluetooth");
//     ESP.restart();
//   }
//   else
//   {
//     Serial.println("Bluetooth initialized");
//   }

//   SerialBT.register_callback(btCallback);
//   Serial.println("The device started, now you can pair it with bluetooth");
// }

// void handleMessage(String message)
// {
// }
// void setup()
// {
//   WRITE_PERI_REG(RTC_CNTL_BROWN_OUT_REG, 0); //disable brownout detector

//   Serial.begin(115200);
//   Serial.setDebugOutput(true);
//   Serial.println("Hello World");
//   Serial.print("Heap");
//   Serial.println(ESP.getFreeHeap());
//   pinMode(4, INPUT);

//   initCamera_Config();
//   delay(500);
//   pinMode(22, INPUT);
//   digitalWrite(22, LOW);

//   esp_err_t err = esp_camera_init(&camera_config);
//   if (err != ESP_OK)
//   {
//     Serial.printf("Camera init failed with error 0x%x", err);
//     return;
//   }
//   Serial.print("Heap Init CAM config");
//   Serial.println(ESP.getFreeHeap());
//   Serial.println("Init Cam Sussesfully");
//   initBT();
// }

// void loop()
// {
// }

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
