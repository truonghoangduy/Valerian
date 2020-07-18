// #include <UTFT.h>
// #include <Fonts/FreeMono9pt7b.h>
#include "SPI.h"
#include "dishplaySetUp.h"
#include "TFT_eSPI.h"
// #include "bitPicture.h"
#include "strings.h"

TFT_eSPI tft = TFT_eSPI();

// #include <Fonts/miror20pt7bBitmaps.h>
#include <Fonts/miror10pt7b.h>

// const GFXfont myfont PROGMEM ={
// 	(uint8_t *)25537_miror20pt7b
// }

String Variablel = "car";

void displaysetup()
{
	tft.init();
	tft.begin();
	tft.setRotation(1);
	tft.fillScreen(TFT_BLACK);
}


void showDisplay(String message)
{
	

	// Set text colour to orange with black background

	tft.fillScreen(TFT_RED); // Clear screen
							 // tft.setTextFont(&FreeMono9pt7b);
							 // bool flip = false;			   // Select the font
	/* code */
	// flip =!flip;
	// tft.invertDisplay(flip);
	// tft.writedata(TFT_MAD_MX | TFT_MAD_BGR);
	// tft.setAttribute
	// tft.drawString("person dog tv bed", 0, 0);

	// delay(3000);

	// tft.drawRoundRect(70, 0, 80, 80, 10, TFT_SILVER);
	// tft.drawRect(70, 0, 80, 80, TFT_BLACK);
	// int x0 = 30;
	// int y0 = 40;
	// int r = 25;
	// for(int a = 18; a > 0; a--)
	// {
	// 	tft.drawCircle(x0, y0, r, 0x001F);
	// 	delay(300);
	// 	tft.fillCircle(x0, y0, r, 0xFFE0);
	// 	delay(200);
		
	// }
	// tft.fillScreen(TFT_BLACK);
	
	for(int b = 1; b < 8; b++)
	{
		tft.fillCircle(10, 40, 2, TFT_WHITE);
		delay(100);
		tft.fillCircle(20, 40, 2, TFT_WHITE);
		delay(200);
		tft.fillCircle(30, 40, 2, TFT_WHITE);
		delay(300);
		tft.fillScreen(TFT_BLACK);
	}
	
		
	
	tft.fillScreen(TFT_RED);

	tft.drawRoundRect(2, 2, 80, 80, 10, TFT_SILVER);

	tft.fillRect(2, 0, 80, 80, TFT_BLACK);
	tft.setTextWrap(false, true);

	tft.setFreeFont(&miror10pt7b);
	tft.setTextSize(0);
	tft.setCursor(7,30);

	int start = 0;
	int end = message.length();

	char revesttext[end];

	

	for (int i = end - 1; i > -1; i--)
	{
		Serial.println(message.charAt(i));
		revesttext[start] = message.charAt(i);
		Serial.println(revesttext[start]);
		start += 1;
	}
	Serial.println((char *)revesttext);
	revesttext[end] = '\0'; // ARHHHHH !!! THE BUGGG IS FOUND

	Serial.println((char *)revesttext);
	
	
	// while((message.indexOf(' ', start) >= 0) && (start <= message.length()))
	// {
	// 	end = message.indexOf(' ', start +1);
	// 	uint16_t len = tft.textWidth(message.substring(start, end));
	// 	if(tft.getCursorX() + len >= tft.width())
	// 	{
	// 		tft.println();
	// 		start ++;
	// 	}
	// 	tft.println(message.substring(start, end));
	// 	start = end;
	// }
	
	tft.println(revesttext);

	//hello my name end game---------------------------------------------------------------------------------
	
	// tft.setCursor(10, 20);

	// tft.println(Variablel.reserve(30));
	// Serial.println(Variablel.l);

	// Print the string name of the font
	// delay(3000);
	// tft.fillScreen(TFT_YELLOW);
	// delay(3000);
	// // tft.setAddrWindow()
	// // for (size_t i = 0; i < 5050; i++)
	// // {
	// // 	/* code */
	// // }

	// // tft.drawBitmap(0,0,bellicon,50,50,TFT_BLACK,TFT_GREEN);
	// // tft.drawXBitmap(0,0,bellicon,50,50,TFT_BLUE);
	// testdrawrects(TFT_RED);
	// 	delay(3000);
	// testfillrects(TFT_BLUE,TFT_DARKGREEN);
}

// #define SERVICE_UUID "4fafc201-1fb5-459e-8fcc-c5c9c331914b"
// #define CHARACTERISTIC_UUID "beb5483e-36e1-4688-b7f5-ea07361b26a8"
// BLEServer *pServer = NULL;
// BLECharacteristic *pCharacteristic = NULL;
// bool deviceConnected = false;
// camera_fb_t *fb = NULL;
// bool capture()
// {
// 	fb = esp_camera_fb_get();
// 	if (!fb)
// 	{
// 		Serial.println("Camera capture failed");
// 		return false;
// 	}
// 	return true;
// }
// class MyServerCallbacks : public BLEServerCallbacks
// {
// 	void onConnect(BLEServer *pServer)
// 	{
// 		Serial.println("BLE Client Connected");
// 		Serial.println(pServer->getConnId());
// 		deviceConnected = true;
// 		BLEDevice::startAdvertising();
// 	};

// 	void onDisconnect(BLEServer *pServer)
// 	{
// 		deviceConnected = false;
// 	}
// };

// // BLE Section
// BLEDevice::init("ESP32 Valarien Sight");

// pServer = BLEDevice::createServer();

// pServer->setCallbacks(new MyServerCallbacks());
// // Create the BLE Service
// BLEService *pService = pServer->createService(SERVICE_UUID);
// // Create a BLE Characteristic
// pCharacteristic = pService->createCharacteristic(
// 	CHARACTERISTIC_UUID,
// 	BLECharacteristic::PROPERTY_READ |
// 		BLECharacteristic::PROPERTY_WRITE |
// 		BLECharacteristic::PROPERTY_NOTIFY |
// 		BLECharacteristic::PROPERTY_INDICATE);
// pCharacteristic->addDescriptor(new BLE2902());

// BLEAdvertising *pAdvertising = BLEDevice::getAdvertising();
// pAdvertising->addServiceUUID(SERVICE_UUID);
// pAdvertising->setScanResponse(false);
// pAdvertising->setMinPreferred(0x0); // set value to 0x00 to not advertise this parameter
// BLEDevice::startAdvertising();
// Serial.println("Waiting a client connection to notify...");

// 	#include <Wire.h>

// #include <Arduino.h>
// // #include <Adafruit_GFX.h>    // Core graphics library
// // #include <Adafruit_ST7735.h> // Hardware-specific library for ST7735
// // #include <Adafruit_ST77xx.h>
// // #include <Adafruit_ST7789.h> // Hardware-specific library for ST7789
// #include <SPI.h>
// #include <TFT_eSPI.h>

// #include "bitPicture.h";
// // #include "showText.h";
// // #define TRACKING

// #define ARDUINO_FEATHER_ESP32
// #if defined(ARDUINO_FEATHER_ESP32) // Feather Huzzah32
//   #define TFT_CS         5
//   #define TFT_RST        2
//   #define TFT_DC         4

// #elif defined(ESP8266)
//   #define TFT_CS         4
//   #define TFT_RST        16
//   #define TFT_DC         5

// #else
//   // For the breakout board, you can use any 2 or 3 pins.
//   // These pins will also work for the 1.8" TFT shield.
//   #define TFT_CS        10
//   #define TFT_RST        9 // Or set to -1 and connect to Arduino RESET pin
//   #define TFT_DC         8
// #endif

// // OPTION 1 (recommended) is to use the HARDWARE SPI pins, which are unique
// // to each board and not reassignable. For Arduino Uno: MOSI = pin 11 and
// // SCLK = pin 13. This is the fastest mode of operation and is required if
// // using the breakout board's microSD card.

// // OPTION 2 lets you interface the tft using ANY TWO or THREE PINS,
// // tradeoff being that performance is not as fast as hardware SPI above.
// #define TFT_MOSI 23  // Data out
// #define TFT_SCLK 18  // Clock out

// // For ST7735-based tfts, we will use this call
// #define ST7735_YELLOW ST77XX_YELLOW

// // Adafruit_ST7735 tft = Adafruit_ST7735(TFT_CS, TFT_DC, TFT_MOSI, TFT_SCLK, TFT_RST);

// #include <Fonts/FreeMonoBold12pt7b.h>
// #include <Fonts/FreeMonoBold9pt7b.h>
// #include <Fonts/FreeSansBold24pt7b.h>
// #include <Fonts/FreeMonoBold18pt7b.h>
// #include <Fonts/FreeMono9pt7b.h>
// String Variablel = "person";

// void displaysetup(){
// //   tft.initR(INITR_MINI160x80);
// //   tft.setSPISpeed(40000000);
// //   tft.fillScreen(ST77XX_BLACK);
// //   tft.setTextWrap(false);
// //   tft.setRotation(1);

// }

// void showDisplay()
// {
//   tft.drawBitmap(0,0,bellicon,50,50,ST7735_YELLOW);

//   for (int i = 1; i < 3; i++)
//   {

//     // tft.setFont(&FreeMono9pt7b);
//   tft.fillRoundRect(5, 5, 75, 75, 5, ST77XX_YELLOW);
//   tft.setTextSize(1);
//   tft.setTextColor(tft.color565(255, 0, 255), tft.color565(0,0,0));

//   tft.setCursor(10, 20);
//   tft.println("Welcome");

//   delay(3000);
//   tft.fillScreen(ST77XX_BLACK);

// // delay(3000);
// //   // tft.drawBitmap(0,0,wifi,50,50,ST77XX_GREEN);
// //   tft.setFont(&FreeMono9pt7b);
// //   tft.setTextSize(0);

// //   // tft.drawRect(5, 75, 75, 75, ST77XX_YELLOW);

//   tft.setTextSize(2);

//   tft.setCursor(10, 20);

//   tft.println(Variablel);

//   }

// }/