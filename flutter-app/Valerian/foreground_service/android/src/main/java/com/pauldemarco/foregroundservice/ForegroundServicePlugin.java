package com.pauldemarco.foregroundservice;

import android.app.Activity;
import android.content.Intent;
import android.content.res.AssetFileDescriptor;
import android.content.res.AssetManager;
import android.os.Bundle;
import android.util.Log;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileDescriptor;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.nio.MappedByteBuffer;
import java.nio.channels.FileChannel;
import java.util.Vector;

import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.PluginRegistry.Registrar;
import io.flutter.plugin.common.PluginRegistry.RequestPermissionsResultListener;

/**
 * ForegroundServicePlugin
 */
public class ForegroundServicePlugin implements MethodCallHandler {
  private static final String TAG = "ForegroundServicePlugin";
  public static String STARTFOREGROUND_ACTION = "com.pauldemarco.foregroundservice.action.startforeground";
  public static String STOPFOREGROUND_ACTION = "com.pauldemarco.foregroundservice.action.stopforeground";

  private final Activity activity;

  private final Registrar mRegister;

  public ForegroundServicePlugin(Registrar registrar) {
    this.activity = registrar.activity();
    mRegister = registrar;
  }

  /**
   * Plugin registration.
   */
  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "com.pauldemarco.foreground_service");
    channel.setMethodCallHandler(new ForegroundServicePlugin(registrar));
  }

//  void loadModelTemper(String path, boolean isAsset) throws IOException {
//    MappedByteBuffer buffer = null;
//    String key = null;
//    AssetManager assetManager = null;
//    if (isAsset) {
//      assetManager = mRegister.context().getAssets();
//      key = mRegister.lookupKeyForAsset(path);
//      AssetFileDescriptor fileDescriptor = assetManager.openFd(key);
//      FileInputStream inputStream = new FileInputStream(fileDescriptor.getFileDescriptor());
//      FileChannel fileChannel = inputStream.getChannel();
//      long startOffset = fileDescriptor.getStartOffset();
//      long declaredLength = fileDescriptor.getDeclaredLength();
//      buffer = fileChannel.map(FileChannel.MapMode.READ_ONLY, startOffset, declaredLength);
//      Log.d(TAG,"OK");
//    } else {
////            FileInputStream inputStream = new FileInputStream(new File(model));
////            FileChannel fileChannel = inputStream.getChannel();
////            long declaredLength = fileChannel.size();
////            buffer = fileChannel.map(FileChannel.MapMode.READ_ONLY, 0, declaredLength);
//    }
//
//  }





  @Override
  public void onMethodCall(MethodCall call, Result result) {
    if (call.method.equals("start")) {
      Intent intent = new Intent(activity, ForegroundService.class);
      intent.setAction(STARTFOREGROUND_ACTION);
      intent.putExtra("title", (String)call.argument("title"));
      intent.putExtra("text", (String)call.argument("text"));
      intent.putExtra("subText", (String)call.argument("subText"));
      intent.putExtra("ticker", (String)call.argument("ticker"));
      intent.putExtra("modelPath",(String)call.argument("modelPath"));
      intent.putExtra("labelPath",(String)call.argument("labelPath"));
//      try {
//        loadModelTemper("assets/detect.tflite",true);
//      } catch (IOException e) {
//        e.printStackTrace();
//      }
      activity.startService(intent);
      result.success(null);
    } else if (call.method.equals("stop")) {
      Intent intent = new Intent(activity, ForegroundService.class);
      intent.setAction(STOPFOREGROUND_ACTION);
      activity.stopService(intent);
      result.success(null);
    }else if(
            call.method.equals("add-on")
    ){

    }
    else {
      result.notImplemented();
    }

  }
  // Permissions and request constants
  private static final int REQUEST_COARSE_LOCATION_PERMISSIONS = 1451;
  private static final int REQUEST_ENABLE_BLUETOOTH = 1337;
  private static final int REQUEST_DISCOVERABLE_BLUETOOTH = 2137;
//  @Override
//  public boolean onRequestPermissionsResult(int requestCode, String[] permissions, int[] grantResults) {
//    return false;
//  }
}
