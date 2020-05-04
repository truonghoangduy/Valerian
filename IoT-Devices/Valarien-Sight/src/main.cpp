#include <Arduino.h>
#include <esp_camera.h>
#include <camera_pins.h>
#include <WebServer.h>
#include <ESPmDNS.h>

// #include <BLEDevice.h>
// #include <BLEServer.h>
// #include <BLEUtils.h>
// #include <BLE2902.h>
#include <WiFi.h>
const char *ssid = "Ambrose";
const char *password = "12345678";

WebServer server(80);
camera_fb_t *fb = NULL;
void handlecapture()
{
	fb = esp_camera_fb_get();
	if (!fb)
	{
		Serial.println("Fail to captute");
	}
	server.send(200, "image/jpeg",(const char *)fb->buf);
	// httpd_resp_send(req,(const char *)fb->buf,fb->len);
	
	esp_camera_fb_return(fb);
	// server.sendContent((char *)*(fb->buf));
}

void handleRoot()
{
	Serial.println("Run");
	// server.send(200, "text/plain", "Hello form server");
}

void setup()
{

	Serial.begin(115200);
	// pinMode(4,OUTPUT);

	WiFi.mode(WIFI_STA);
	WiFi.begin(ssid, password);
	

	// Wait for connection
	uint8_t i = 0;
	while (WiFi.status() != WL_CONNECTED && i++ < 20)
	{ //wait 10 seconds
		delay(500);
	}

	initCamera_Config();

	delay(200);
	esp_err_t err = esp_camera_init(&camera_config);
	if (err != ESP_OK)
	{
		Serial.printf("Camera init failed with error 0x%x", err);
		return;
	}

	// if (MDNS.begin("ValerianSight"))
	// {
	// 	MDNS.addService("http", "tcp", 80);
	// 	Serial.println("MDNS responder started");
	// 	Serial.println("You can now connect to http://");
	// 	Serial.print("ValerianSight");
	// 	Serial.print(".local");
	// }
	server.on("/", handleRoot);
	server.on("/capture", handlecapture);
	server.begin();

	Serial.print("Server ready on:");
	// Serial.println(Wifi.)
	Serial.println(WiFi.localIP());
}

void loop()
{
	server.handleClient();
}