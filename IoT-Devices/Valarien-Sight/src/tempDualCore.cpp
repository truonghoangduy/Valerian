// #include <Arduino.h>
// #include <camera_pins.h>
// #include <esp_camera.h>
// // #include <http_server_linker.h>
// // #include <esp_http_server.h>
// #include <ArduinoJson.h>
// #include <SPIFFS.h>
// #include "soc/soc.h" //disable brownout problems
// #include "soc/rtc_cntl_reg.h"
// // BOARD
// #define CAMERA_MODEL_AI_THINKER

// // Swithover Bluetooth Serial on Android
// #include "BluetoothSerial.h"
// // Dishplay
// // #include <Adafruit_GFX.h>    // Core graphics library
// // #include <Adafruit_ST7735.h> // Hardware-specific library for ST7735
// // #include <SPI.h>
// #include "display.h"
// uint8_t buffer;
// const char *filename = "/config.json"; // SPIFFS config file
// char *ssid = "HSU_Students";
// char *password = "dhhs12cnvch";
// BluetoothSerial SerialBT;
// String stringRead;
// bool dataReady = false;
// #include "freertos/FreeRTOS.h"
// #include "freertos/task.h"
// typedef enum BOARD_FUNCTIONALITY
// {
//   NOTIFICATION,
//   TEXT,
//   DECTION
// };

// void writeSerialBT(camera_fb_t *fb)
// {
//   Serial.print("Picture lenght");
//   Serial.println(fb->len);
//   SerialBT.write(fb->buf, fb->len); // Queue package alreay implemented
//   SerialBT.flush();
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
//   // sendPictutreBufferLenght(fb);
//   writeSerialBT(fb);
//   esp_camera_fb_return(fb);
// }



// void setCameraParam(int paramInt)
// {
//   sensor_t *s = esp_camera_sensor_get();
//   s->set_vflip(s, 1);
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
//     s->set_hmirror(s, 1);
//     s->set_framesize(s, FRAMESIZE_CIF);
//     break;

//   case 0:
//   default:
//     s->set_framesize(s, FRAMESIZE_VGA);
//     break;
//   }

//   capture();
// }

// void functionalitySwitch(int opCode, String content)
// {
//   Serial.println("CALL SWITCH");
//   Serial.print(opCode);
//   Serial.print(" : ");
//   Serial.println(content);
//   if (opCode == TEXT)
//   {
//     Serial.println("CAll TEXT");
//     Serial.println(content);
//     // testdrawtext((char *)content.c_str(), ST77XX_WHITE);
//     tft.fillScreen(ST77XX_BLACK);
//     tft.setCursor(0, 0);
//     tft.setTextColor(ST77XX_WHITE);
//     tft.setTextWrap(true);
//     tft.print("What the hell");
//   }

//   // switch (opCode)
//   // {
//   // case NOTIFICATION:
//   //   Serial.println("CAll NOTIFICATION");
//   //   Serial.println(content);

//   //   break;
//   // case DECTION:
//   //   Serial.println("CAll DECTION");
//   //   // setCameraParam(opCode);
//   //   break;

//   // case TEXT:
//   //   Serial.println("CAll TEXT");
//   //   Serial.println(content);
//   //   drawTEXT(content,ST7735_GREEN);
//   //   // callDrawtext((char *)content.c_str(), ST77XX_WHITE);

//   //   break;
//   // default:
//   //   break;
//   // }
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
//     // String stringRead = String(*param->data_ind.data);
//     stringRead = SerialBT.readStringUntil('\n');
//     Serial.print("Original : ");
//     Serial.println(stringRead);
//     int opCode = ((String)stringRead.charAt(0)).toInt();
//     // testdrawtext((char *)stringRead.c_str(), ST77XX_WHITE);
//     // delay(1000);
//     functionalitySwitch(opCode, stringRead.substring(1));
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

//   // SerialBT.register_callback(btCallback);
//   Serial.println("The device started, now you can pair it with bluetooth");
// }

// void initCameraConfig()
// {
//   initCamera_Config();
//   delay(500);
//   esp_err_t err = esp_camera_init(&camera_config);
//   if (err != ESP_OK)
//   {
//     Serial.printf("Camera init failed with error 0x%x", err);
//     return;
//   }
//   Serial.println("Init Cam Sussesfully");
// }

// void BlueToothReq(void *parameter)
// {
//   initBT();
//   // initCameraConfig();
//   for (;;)
//   {
//     if (SerialBT.available())
//     {
//       stringRead = SerialBT.readStringUntil('\n');
//       Serial.print("Original : ");
//       Serial.println(stringRead);
//       int opCode = ((String)stringRead.charAt(0)).toInt();
//       if (opCode == DECTION)
//       {
//         // capture();
//       }else
//       {
//         dataReady = true;
//       }
//     }
//     vTaskDelay(1);
//   }
// }

// void SendDisplay(void *parameter)
// {
//   displaysetup();
//   tftPrintTest();
  
//   for (;;)
//   {
//     if (dataReady == true)
//     {
//       Serial.println("IntoLooop");
//       // testdrawtext("OKKKKKKKKAAAA",ST77XX_WHITE);
//       tftPrintTest();
//     }
//     vTaskDelay(1);
//   }
// }

// void setup()
// {
//   WRITE_PERI_REG(RTC_CNTL_BROWN_OUT_REG, 0); //disable brownout detector

//   Serial.begin(115200);
//   Serial.setDebugOutput(true);
//   Serial.println("Hello World");
//   Serial.print("Heap");
//   Serial.println(ESP.getFreeHeap());
//   // delay(2000);
//   // initBT();

//   xTaskCreatePinnedToCore(
//     BlueToothReq,
//     "BlueToothReq",   // A name just for humans
//     80000,  // This stack size can be checked & adjusted by reading the Stack Highwater
//     NULL,   // task input parameter
//     1,  // Priority, with 3 (configMAX_PRIORITIES - 1) being the highest, and 0 being the lowest.
//     NULL, // Task handle
//     1);  // Core0



//   xTaskCreatePinnedToCore(
//     SendDisplay,
//     "SendDisplay",   // A name just for humans
//     10000,  // This stack size can be checked & adjusted by reading the Stack Highwater
//     NULL,   // task input parameter
//     0,  // Priority, with 3 (configMAX_PRIORITIES - 1) being the highest, and 0 being the lowest.
//     NULL, // Task handle
//     0);  

// }

// void loop()
// {
//   vTaskDelete(NULL); 
// }

// //   for (size_t i = 0; i < fb->len; i++)
// //   {

// //     buffer = *(fb->buf + i);
// // #ifdef DEBUG_BUFFER
// //     Serial.print(buffer);
// //     Serial.print(" ");
// // #endif
// //     pCharacteristic->setValue(&buffer,1);
// //     pCharacteristic->notify();
// //     delay(70);
// //   }

// // void sendPictutreBufferLenght(camera_fb_t *fb){
// //   Serial.print("Picture lenght : ");
// //   byte *abc = (uint8_t * )fb->len;
// //   Serial.println(fb->len);
// //   SerialBT.write(fb->len);// Queue package alreay implemented
// //   SerialBT.flush();
// // }