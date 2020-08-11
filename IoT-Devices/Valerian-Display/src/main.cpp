#include <Arduino.h>
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

void displayConfig(String mesges, int opCode)
{

  if (opCode == MSG_NOTIFICATION)
  {
    if (mesges.length() < 16)
    {
      Serial.printf("DECTION_NOTIFICATION");
      Serial.println(mesges);
      showDisplay(mesges);
    }
    else
    {
      /* code */
      Serial.printf("MSG_NOTIFICATION");
      Serial.println(mesges);
      showMessenge(mesges, MSG_NOTIFICATION);
    }
  }
  else if (opCode == CALL_NOTIFICATION)
  {
    Serial.printf("CALL_NOTIFICATION");
    Serial.println(mesges);
    showMessenge(mesges, CALL_NOTIFICATION);
  }
  else if (opCode == DECTION_NOTIFICATION)
  {
    Serial.printf("DECTION_NOTIFICATION");
    Serial.println(mesges);
    showDisplay(mesges);
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
  }
  else if (event == ESP_SPP_CLOSE_EVT)
  {
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
  Serial.println(sizeof(DECTION_NOTIFICATION));
  if (SerialBT.hasClient())
  {
    Serial.println("Send Messages");
    int encode = (int)DECTION_NOTIFICATION;
    // SerialBT.write((uint8_t *)&encode, sizeof(encode));
    // SerialBT.write((uint8_t *)&EOL, sizeof(EOL));
    // SerialBT.write((uint8_t *)&stop, sizeof(stop));
    SerialBT.println(encode);
    SerialBT.flush();
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
  displaysetup();
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