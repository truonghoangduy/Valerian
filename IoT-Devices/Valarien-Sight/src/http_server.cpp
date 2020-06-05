#include "esp_http_server.h"
#include "esp_camera.h"
#include "Arduino.h"
#include <http_server_linker.h>
#include <WiFi.h>
// httpd_handle_t capture_httpd = NULL;
camera_fb_t *fb = NULL;
httpd_handle_t capture_httpd = NULL;

static esp_err_t capture_handler(httpd_req_t *req)
{

    // Susses Flag
    esp_err_t res_flag = ESP_OK;
    // Init header to Respone
    httpd_resp_set_type(req, "image/jpeg");
    httpd_resp_set_hdr(req, "Content-Disposition", "inline; filename=capture.jpg");
    httpd_resp_set_hdr(req, "Access-Control-Allow-Origin", "*");
    fb = esp_camera_fb_get();
    if (!fb)
    {
        Serial.print("Fail To Capture");
    }
    res_flag = httpd_resp_send(req, (const char *)fb->buf,fb->len);
    if (res_flag == ESP_OK)
    {
        Serial.println("Sended Img");
    }
    

    // free memory
    esp_camera_fb_return(fb);

    // Capture

    return res_flag;
}

static esp_err_t defaut_uri_handler(httpd_req_t *req)
{
    Serial.println("Defualt web ///");
    esp_err_t res_flag = ESP_OK;
    const char *ipInformation = WiFi.localIP().toString().c_str();
    httpd_resp_set_type(req, "text/html");
    // httpd_resp_set_hdr(req, "Content-Encoding", "gzip");
    httpd_resp_set_hdr(req, "Access-Control-Allow-Origin", "*");
    res_flag = httpd_resp_send(req,(const char *)ipInformation, strlen(ipInformation));
    //192.168.1.7
    if (res_flag == ESP_OK)
    {
        Serial.println("Sended");
    }
    

    return res_flag;
}

void startCameraServer()
{
    httpd_config_t config = HTTPD_DEFAULT_CONFIG();

    httpd_uri_t defaut_uri = {
        .uri = "/",
        .method = HTTP_GET,
        .handler = defaut_uri_handler,
        .user_ctx = NULL};
    httpd_uri_t capture_uri = {
        .uri = "/capture",
        .method = HTTP_GET,
        .handler = capture_handler,
        .user_ctx = NULL};

    config.server_port = 80;

    if (httpd_start(&capture_httpd, &config) == ESP_OK)
    {
        Serial.println("Init Webserver");
        /* code */
        httpd_register_uri_handler(capture_httpd, &defaut_uri);
        httpd_register_uri_handler(capture_httpd, &capture_uri);
    }
    else
    {
        Serial.println("Fail To Init Webserver");
    }
    // return capture_httpd;
}

void deInitCameraServer(httpd_handle_t server)
{
    if (server != NULL)
    {
        httpd_stop(server);
        server = NULL;
    }
}

// void stopcamServer()
// {
//     if (capture_httpd != NULL)
//     {
//         if (httpd_stop(capture_httpd) == ESP_OK)
//         {
//             Serial.println("Server stopped");
//         }
//     }
// }
