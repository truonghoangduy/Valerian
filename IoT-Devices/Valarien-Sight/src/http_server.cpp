#include "esp_http_server.h"
#include "esp_camera.h"
#include "Arduino.h"
#include <http_server_linker.h>
httpd_handle_t capture_httpd = NULL;
camera_fb_t *fb = NULL;
static esp_err_t capture_handler(httpd_req_t *req)
{

    // Susses Flag
    esp_err_t res_flag = ESP_OK;
    //Init header to Respone
    httpd_resp_set_type(req, "image/jpeg");
    httpd_resp_set_hdr(req, "Content-Disposition", "inline; filename=capture.jpg");
    httpd_resp_set_hdr(req, "Access-Control-Allow-Origin", "*");
    fb = esp_camera_fb_get();
    if (!fb)
    {
        Serial.print("Fail To Capture");
    }

    res_flag = httpd_resp_send(req,(const char *)fb->buf,fb->len);

    // free memory 
    esp_camera_fb_return(fb);
    
    // Capture

    return res_flag;
}

void startCameraServer()
{
    httpd_config_t config = HTTPD_DEFAULT_CONFIG();

    httpd_uri_t capture_uri = {
        .uri = "/capture",
        .method = HTTP_GET,
        .handler = capture_handler,
        .user_ctx = NULL};

    config.server_port = 80;

    if (httpd_start(&capture_httpd, &config) == ESP_OK)
    {
        /* code */
        httpd_register_uri_handler(capture_httpd, &capture_uri);
    }
}
