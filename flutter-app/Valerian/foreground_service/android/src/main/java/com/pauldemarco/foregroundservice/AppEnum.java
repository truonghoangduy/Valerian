package com.pauldemarco.foregroundservice;
enum METHOD_CHANNEL_CALL{

    START_NOTIFICATION("start_notifcation"),
    START_DECTION("start_dection"),
    OFF_NOTIFICATION("off_notifcation"),
    OFF_DECTION("off_dection"),

    START_PHOTO_SAVE("on_photo_save"),
    OFF_PHOTO_SAVE("off_photo_save");


    public String methodToCall;
    METHOD_CHANNEL_CALL(String encode){
        this.methodToCall = encode;
    }

    public String getMethod(){
        return this.methodToCall;
    }
}



