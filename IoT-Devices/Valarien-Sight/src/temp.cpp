// #include <Arduino.h>
// #include <esp_camera.h>
// #include <camera_pins.h>
// #include <BLEDevice.h>
// #include <BLEServer.h>
// #include <BLEUtils.h>
// #include <BLE2902.h>
// #include <ArduinoJson.h>

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

// void setup()
// {

// 	Serial.begin(115200);
// 	// pinMode(4,OUTPUT);
// 	initCamera_Config();
// 	delay(200);
// 	esp_err_t err = esp_camera_init(&camera_config);
// 	if (err != ESP_OK)
// 	{
// 		Serial.printf("Camera init failed with error 0x%x", err);
// 		return;
// 	}

// 	Serial.println("Begin Capture");

// 	if (capture())
// 	{
// 		Serial.println(fb->len);
// 	}

// 	esp_camera_fb_return(fb);

// 	// BLE Section
// 	BLEDevice::init("ESP32 Valarien Sight");

// 	pServer = BLEDevice::createServer();

// 	pServer->setCallbacks(new MyServerCallbacks());
// 	// Create the BLE Service
// 	BLEService *pService = pServer->createService(SERVICE_UUID);
// 	// Create a BLE Characteristic
// 	pCharacteristic = pService->createCharacteristic(
// 		CHARACTERISTIC_UUID,
// 		BLECharacteristic::PROPERTY_READ |
// 			BLECharacteristic::PROPERTY_WRITE |
// 			BLECharacteristic::PROPERTY_NOTIFY |
// 			BLECharacteristic::PROPERTY_INDICATE);
// 	pCharacteristic->addDescriptor(new BLE2902());

// 	BLEAdvertising *pAdvertising = BLEDevice::getAdvertising();
// 	pAdvertising->addServiceUUID(SERVICE_UUID);
// 	pAdvertising->setScanResponse(false);
// 	pAdvertising->setMinPreferred(0x0); // set value to 0x00 to not advertise this parameter
// 	BLEDevice::startAdvertising();
// 	Serial.println("Waiting a client connection to notify...");
// }

// void loop()
// {
// 	if (deviceConnected)
// 	{
// 		if (capture())
// 		{
// 			pCharacteristic->setValue(fb->buf, fb->len);
// 			pCharacteristic->notify();
// 		}
// 		delay(500);
// 		esp_camera_fb_return(fb);

// 		// pCharacteristic->
// 	}
// 	// digitalWrite(4, HIGH);
// 	// delay(500);
// 	// digitalWrite(4, LOW);
// 	// delay(500);
// }



//   BLEDevice::init("ESP32 Valarien Sight");
//   pServer = BLEDevice::createServer();

//   pServer->setCallbacks(new MyServerCallbacks());
//   // Create the BLE Service
//   BLEService *pService = pServer->createService(SERVICE_UUID);
//   // Create a BLE Characteristic
//   pCharacteristic = pService->createCharacteristic(
//       CHARACTERISTIC_UUID,
//       BLECharacteristic::PROPERTY_READ |
//           BLECharacteristic::PROPERTY_WRITE |
//           BLECharacteristic::PROPERTY_NOTIFY |
//           BLECharacteristic::PROPERTY_INDICATE);
//   pCharacteristic->addDescriptor(new BLE2902());

//   pService->start();

//   BLEAdvertising *pAdvertising = BLEDevice::getAdvertising();
//   pAdvertising->addServiceUUID(SERVICE_UUID);
//   pAdvertising->setScanResponse(false);
//   pAdvertising->setMinPreferred(0x0); // set value to 0x00 to not advertise this parameter
//   BLEDevice::startAdvertising();
//   Serial.println("Waiting a client connection to notify...");



// bool sendOverBLE()
// {
//   uint8_t buffer;
//   Serial.print("Width : ");
//   Serial.println(fb->width);
//   Serial.print("Height : ");
//   Serial.println(fb->height);
//   Serial.print("Length : ");
//   Serial.println(fb->len);
//   Serial.println("Begin Buffering");
//   // IOS max Size 180 byte
//   // TO DO
//   // Handle when picture to dark
//   uint8_t *message = (uint8_t *)malloc(sizeof(uint8_t) * 1000);
//   uint16_t count = 0;
//   for (size_t i = 0; i < fb->len; i++)
//   {

//     // buffer = *(fb->buf + i);

//     message[count] = *(fb->buf + i);
//     if (count == 1000)
//     {
//       pCharacteristic->setValue(message, 1000);
//       pCharacteristic->notify();
//       count = 0;
//       Serial.println("OKE");
//       Serial.println(count);
//     }

//     count++;

//     // #ifdef DEBUG_BUFFER
//     //     Serial.print(buffer);
//     //     Serial.print(" ");
//     // #endif

//     delay(70);
//   }
//   esp_camera_fb_return(fb);
//   return true;
// }


//   int reading = digitalRead(buttonPin);
//   if (reading != lastButtonState)
//   {
//     lastDebounceTime = millis();
//   }

//   if ((millis() - lastDebounceTime) > debounceDelay)
//   {
//     if (reading != buttonState)
//     {
//       buttonState = reading;

//       if (buttonState == HIGH)
//       {
//         //Additional Code
//         if (deviceConnected)
//         {
//           Serial.println("Clicked");

//           if (capture())
//           {
//             Serial.println("Done cupture !!!");
//             if (sendOverBLE())
//             {
//               Serial.println("Done Sending over BLE !!!");
//             }
//           }
//         }
//         //
//       }
//     }
//   }
//   lastButtonState = reading;


// const int buttonPin = 4; // the number of the pushbutton pin
// int buttonState;
// int lastButtonState = LOW;
// unsigned long lastDebounceTime = 0; // the last time the output pin was toggled
// unsigned long debounceDelay = 50;   // the debounce time; increase if the output flickers
// bool isNormalMode = true;


// void sspifshandle()
// {
//   if (SPIFFS.begin(true))
//   {
//     if (SPIFFS.exists(filename))
//     {
//       File configFile = SPIFFS.open(filename, "r");
//       Serial.println(configFile.size());
//       // size_t filesize = configFile.size();
//       DynamicJsonDocument doc(configFile.size());
//       DeserializationError error = deserializeJson(doc, configFile);
//       if (!error)
//         Serial.println("Connot Convert To JSON");

//       configFile.close();
//       stpcpy(Wifissid, doc["wifi"]["ssid"]);
//       stpcpy(Wifipass, doc["wifi"]["password"]);
//       // Hmmmm Relase Heap Memory
//       doc.clear();
//     }
//     else
//     {
//       Serial.println("Fail to init SPIFS");
//     }
//     // SPIFFS.end()
//   }
// }