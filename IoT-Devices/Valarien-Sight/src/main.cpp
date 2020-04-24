#include <Arduino.h>
#include <WiFi.h>
// #include <display.h>
#include <ESP32_I2S_Camera/OV7670.h>
#include <ESP32_I2S_Camera/BMP.h>
#include <bluetooth.h>
extern "C"
{
#include <esp_spiram.h>
#include <esp_himem.h>
}
// Camera
const int SIOD = 21; //SDA
const int SIOC = 22; //SCL

const int VSYNC = 34;
const int HREF = 35;

const int XCLK = 32;
const int PCLK = 33;

const int D0 = 27;
const int D1 = 17;
const int D2 = 16;
const int D3 = 15;
const int D4 = 14;
const int D5 = 13;
const int D6 = 12;
const int D7 = 4;
//----------------------------------

void setup()
{
  Serial.begin(115200);
  WiFi.mode(WIFI_STA);
  WiFi.disconnect();
  setupBluetooth();
  Serial.print("BLuetooth ready");
  
  printf("PsramSize %u\n", esp_spiram_init());
  printf("spiram size %u\n", esp_spiram_get_size());
  printf("himem free %u\n", esp_himem_get_free_size());
  printf("himem phys %u\n", esp_himem_get_phys_size());
  printf("himem reserved %u\n", esp_himem_reserved_area_size());
  delay(1000);
  // displaysetup();
}

void loop()
{

  // tft.setTextSize(2);
  // tft.setCursor(0,0);
  // tft.print("...Scaning");
  // WiFi.scanNetworks();
  // tft.fillScreen(ST77XX_BLACK);
  // tft.setCursor(2,0);
  // for (int i = 0; i < 4; i++)
  // {
  //     // String text =;
  //     // char charText[50];
  //     // text.toCharArray(charText,50);
  //     tft.setTextSize(2);
  //     tft.setTextWrap(true);
  //     tft.println( WiFi.SSID(i));
  //     delay(400);

  // }
  // delay(1000);
  // tft.fillScreen(ST77XX_BLACK);
}