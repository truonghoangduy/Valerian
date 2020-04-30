#include <Arduino.h>
// #include <esp_camera.h>
#include <BLEDevice.h>
#include <BLEServer.h>
#include <BLEUtils.h>
#include <BLE2902.h>

#include <camera_pins.h>
#include <esp_camera.h>

#include <ArduinoJson.h>
#include <SPIFFS.h>

// #include <WiFi.h>
// #include <ESPmDNS.h>

#define SERVICE_UUID "4fafc201-1fb5-459e-8fcc-c5c9c331914b"
#define CHARACTERISTIC_UUID "beb5483e-36e1-4688-b7f5-ea07361b26a8"
BLEServer *pServer = NULL;
BLECharacteristic *pCharacteristic = NULL;
bool deviceConnected = false;

const char *filename = "/config.json"; // SPIFFS config file
char Wifissid[30];                     // It gonna fit ^^
char Wifipass[30];

camera_fb_t *fb = NULL;

void setupWifi()
{
  WiFi.begin(Wifissid, Wifipass);
  while (WiFi.status() != WL_CONNECTED)
  { // Wait for the Wi-Fi to connect
    delay(200);
    Serial.print(".");
  }
  Serial.println("");
  Serial.println(WiFi.localIP());
  if (!MDNS.begin("valariensight"))
  {
    Serial.println("Error setting up MDNS responder!");
    while (1)
    {
      delay(1000);
    }
  }
}
bool capture()
{
  fb = esp_camera_fb_get();
  if (!fb)
  {
    Serial.println("Camera capture failed");
    return false;
  }
  uint8_t buffer;
  Serial.print("Width : ");
  Serial.println(fb->width);
  Serial.print("Height : ");
  Serial.println(fb->height);
  Serial.print("Length : ");
  Serial.println(fb->len);
  Serial.println("Begin Buffering");

  // TO DO
  // Handle when picture to dark
  counter =0;
  for (size_t i = 0; i < fb->len; i++)
  {
    buffer = *(fb->buf + i);
    Serial.print(buffer);
    Serial.print(" ");
  }
  esp_camera_fb_return(fb);
  Serial.println("End");

  return true;
}



void handle_OnCapture()
{
  Serial.print("Client Request");
  if (capture())
  {
    /* code */
  }
}

void setup()
{
  Serial.begin(115200);
  Serial.println("GO");
  
  initCamera_Config();
  delay(200);

  esp_err_t err = esp_camera_init(&camera_config);
  if (err != ESP_OK)
  {
    Serial.printf("Camera init failed with error 0x%x", err);
    return;
  }

  Serial.println(Wifissid);
  Serial.println(Wifipass);
  // setupWifi();
  // server.begin();
  // MDNS.addService("http", "tcp", 80);
  pinMode(4,OUTPUT);
  if (capture())
  {
  }
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
	pCharacteristic->addDescriptor(new BLE2902());

	BLEAdvertising *pAdvertising = BLEDevice::getAdvertising();
	pAdvertising->addServiceUUID(SERVICE_UUID);
	pAdvertising->setScanResponse(false);
	pAdvertising->setMinPreferred(0x0); // set value to 0x00 to not advertise this parameter
	BLEDevice::startAdvertising();
	Serial.println("Waiting a client connection to notify...");
}


void sspifshandle(){
  if (SPIFFS.begin(true))
  {
    if (SPIFFS.exists(filename))
    {
      File configFile = SPIFFS.open(filename, "r");
      Serial.println(configFile.size());
      // size_t filesize = configFile.size();
      DynamicJsonDocument doc(configFile.size());
      DeserializationError error = deserializeJson(doc, configFile);
      if (!error)
        Serial.println("Connot Convert To JSON");

      configFile.close();
      stpcpy(Wifissid, doc["wifi"]["ssid"]);
      stpcpy(Wifipass, doc["wifi"]["password"]);
      // Hmmmm Relase Heap Memory
      doc.clear();
    }
    else
    {
      Serial.println("Fail to init SPIFS");
    }
    // SPIFFS.end()
  }
}
void loop()
{
}
