#include <Arduino.h>
#include <esp_camera.h>
#include <camera_pins.h>
#include "esp_timer.h"
#include "img_converters.h"
#include <BLEDevice.h>
#include <BLEServer.h>
#include <BLEUtils.h>
#include <BLE2902.h>

#define SERVICE_UUID "4fafc201-1fb5-459e-8fcc-c5c9c331914b"
#define CHARACTERISTIC_UUID "beb5483e-36e1-4688-b7f5-ea07361b26a8"
BLEServer *pServer = NULL;
BLECharacteristic *pCharacteristic = NULL;
bool deviceConnected = false;
camera_fb_t *fb = NULL;
bool capture()
{
	fb = esp_camera_fb_get();
	if (!fb)
	{
		Serial.println("Camera capture failed");
		return false;
	}
	return true;
}
class MyServerCallbacks : public BLEServerCallbacks
{
	void onConnect(BLEServer *pServer)
	{
		Serial.println(pServer->getConnId());
		deviceConnected = true;
		BLEDevice::startAdvertising();
	};

	void onDisconnect(BLEServer *pServer)
	{
		deviceConnected = false;
	}
};


void setup()
{
	Serial.begin(115200);
	initCamera_Config();
	delay(200);
	esp_err_t err = esp_camera_init(&camera_config);
	if (err != ESP_OK)
	{
		Serial.printf("Camera init failed with error 0x%x", err);
		return;
	}

	Serial.println("Begin Capture");

	if (capture())
	{
		Serial.println(fb->len);
	}

	esp_camera_fb_return(fb);

	// BLE Section
	BLEDevice::init("ESP32 Valarien Sight");

	pServer = BLEDevice::createServer();

	//pServer->setCallbacks(new MyServerCallbacks());
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

void loop()
{
	if (deviceConnected)
	{
		if (capture())
		{
			pCharacteristic->setValue(fb->buf, fb->len);
			pCharacteristic->notify();
		}
		delay(500);
		esp_camera_fb_return(fb);

		// pCharacteristic->
	}
}