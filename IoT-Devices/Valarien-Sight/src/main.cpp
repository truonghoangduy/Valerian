#include <Arduino.h>
#include <camera_pins.h>
#include <esp_camera.h>
// #include <http_server_linker.h>
// #include <esp_http_server.h>
// #include <ArduinoJson.h>
#include <SPIFFS.h>
#include "soc/soc.h" //disable brownout problems
#include "soc/rtc_cntl_reg.h"
// BOARD

#define CAMERA_MODEL_AI_THINKER

// Swithover Bluetooth Serial on Android
#include "BluetoothSerial.h"
// Dishplay
// #include "displayPins.h"

uint8_t buffer;
const char *filename = "/config.json"; // SPIFFS config file
// char *ssid = "HSU_Students";
// char *password = "dhhs12cnvch";
BluetoothSerial SerialBT;

// Adafruit_ST7735 tft = Adafruit_ST7735(TFT_CS, TFT_DC, TFT_MOSI, TFT_SCLK, TFT_RST);

typedef enum BOARD_FUNCTIONALITY
{
  NOTIFICATION, //0
  TEXT,         //1
  DECTION       //2
};

camera_fb_t *fb = NULL;

void writeSerialBT()
// void writeSerialBT()
{
  if (SerialBT.write(fb->buf, fb->len) == ESP_OK)
  {
    Serial.println("Malloocoo Failll");
    SerialBT.write(255);
    esp_camera_fb_return(fb);
  }
  Serial.println("OK Sending");

  // Queue package alreay implemented
  SerialBT.flush();
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
// bool formatCheck(camera_fb_t *fb)
bool formatCheck()
{
  if (!fb)
  {
    esp_camera_fb_return(fb);
    return true;
  }

  Serial.print("Picture lenght : ");
  Serial.println(fb->len);
  Serial.print("Last bit check");
  Serial.print(*(fb->buf + fb->len - 2));
  Serial.print("  :  ");
  Serial.println(*(fb->buf + fb->len - 1));
  if (*(fb->buf + fb->len - 2) == 255 && 217 == *(fb->buf + fb->len - 1))
  {
    if (fb->len > 10000 && fb->len < 24000)
    {
      return false;
    }
  }
  esp_camera_fb_return(fb);
  return true;
}
void capture()
{

  // esp_camera_fb_return(fb);
  esp_err_t res = ESP_OK;
  do
  {
    fb = esp_camera_fb_get();
    if (fb->format != PIXFORMAT_JPEG)
    {
      Serial.println("Not JPEG");
    }
    delay(50);
  } while (formatCheck());
  delay(300);
  Serial.println("Begin Send");
  writeSerialBT();

  // fb = esp_camera_fb_get();
  // if (!fb)
  // {
  //   esp_camera_fb_return(fb);
  //   return;
  // }

  // if (fb->format != PIXFORMAT_JPEG)
  // {
  //   esp_camera_fb_return(fb);
  //   return;
  // }
  // // sendPictutreBufferLenght(fb);
  // // writeSerialBT(fb);
  // if (formatCheck())
  // {
  //   Serial.println("Format Checked : vaild");
  //   writeSerialBT();
  // }
  // else
  // {
  //   Serial.println("Format failed");
  // }
  esp_camera_fb_return(fb);
  Serial.println("Done queue of bluetooth");
}
void setCameraParam(int paramInt)
{
  sensor_t *s = esp_camera_sensor_get();
  s->set_vflip(s, 1);
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
    s->set_hmirror(s, 1);
    s->set_framesize(s, FRAMESIZE_CIF);
    break;

  case 0:
  default:
    s->set_framesize(s, FRAMESIZE_VGA);
    break;
  }

  capture();
}

void functionalitySwitch(int opCode, String content)
{
  Serial.println("CALL SWITCH");
  Serial.print(opCode);
  Serial.print(" : ");
  Serial.println(content);

  switch (opCode)
  {
  case NOTIFICATION:
    Serial.println("CAll NOTIFICATION");
    Serial.println(content);

    break;
  case DECTION:
    Serial.println("CAll DECTION");
    // setCameraParam(opCode);
    break;

  case TEXT:
    Serial.println("CAll TEXT");
    Serial.println(content);
    // drawTEXT(content,ST7735_GREEN);
    // callDrawtext((char *)content.c_str(), ST77XX_WHITE);

    break;
  default:
    break;
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
    // String stringRead = String(*param->data_ind.data);
    String stringRead = SerialBT.readStringUntil('\n');
    Serial.print("Original : ");
    Serial.println(stringRead);
    int opCode = ((String)stringRead.charAt(0)).toInt();
    // functionalitySwitch(opCode, stringRead.substring(1));
    setCameraParam(opCode);
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
  // initDisplay();

  initBT();
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

// void sendPictutreBufferLenght(camera_fb_t *fb){
//   Serial.print("Picture lenght : ");
//   byte *abc = (uint8_t * )fb->len;
//   Serial.println(fb->len);
//   SerialBT.write(fb->len);// Queue package alreay implemented
//   SerialBT.flush();
// }