// #include "esp_http_server.h"
// #include "esp_camera.h"
// #include "Arduino.h"
// #include <http_server_linker.h>
// #include <WiFi.h>
// // httpd_handle_t capture_httpd = NULL;
// camera_fb_t *fb = NULL;
// httpd_handle_t capture_httpd = NULL;

// static esp_err_t capture_handler(httpd_req_t *req)
// {

//     // Susses Flag
//     esp_err_t res_flag = ESP_OK;
//     //Init header to Respone
//     httpd_resp_set_type(req, "image/jpeg");
//     httpd_resp_set_hdr(req, "Content-Disposition", "inline; filename=capture.jpg");
//     httpd_resp_set_hdr(req, "Access-Control-Allow-Origin", "*");
//     fb = esp_camera_fb_get();
//     if (!fb)
//     {
//         Serial.print("Fail To Capture");
//     }

//     res_flag = httpd_resp_send(req, (const char *)fb->buf, fb->len);
//     Serial.println("Sended Img");

//     // free memory
//     esp_camera_fb_return(fb);

//     // Capture

//     return res_flag;
// }

// static esp_err_t defaut_uri_handler(httpd_req_t *req)
// {
//     Serial.println("Defualt web ///");
//     esp_err_t res_flag = ESP_OK;
//     const char *ipInformation = WiFi.localIP().toString().c_str();
//     httpd_resp_set_type(req, "text/html");
//     // httpd_resp_set_hdr(req, "Content-Encoding", "gzip");
//     httpd_resp_set_hdr(req, "Access-Control-Allow-Origin", "*");
//     res_flag = httpd_resp_send(req,(char *)ipInformation, strlen(ipInformation));
//     //192.168.1.7
//     if (res_flag == ESP_OK)
//     {
//         Serial.println("Sended");
//     }
    

//     return res_flag;
// }

// void startCameraServer()
// {
//     httpd_config_t config = HTTPD_DEFAULT_CONFIG();

//     httpd_uri_t defaut_uri = {
// }
