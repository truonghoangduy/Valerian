package com.pauldemarco.foregroundservice;

import android.app.Activity;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.ServiceConnection;
import android.content.res.AssetFileDescriptor;
import android.content.res.AssetManager;
import android.os.Bundle;
import android.os.IBinder;
import android.provider.Settings;
import android.text.TextUtils;
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
/**
 * ForegroundServicePlugin
 */
public class ForegroundServicePlugin implements MethodCallHandler {
  private static final String TAG = "ForegroundServicePlugin";
  private static final String ENABLED_NOTIFICATION_LISTENERS = "enabled_notification_listeners";
  public static String STARTFOREGROUND_ACTION = "com.pauldemarco.foregroundservice.action.startforeground";
  public static String STOPFOREGROUND_ACTION = "com.pauldemarco.foregroundservice.action.stopforeground";
  private static final String ACTION_NOTIFICATION_LISTENER_SETTINGS = "android.settings.ACTION_NOTIFICATION_LISTENER_SETTINGS";
  private  static final String ACTION_NOTIFICATION_LISTENER = "android.service.notification.NotificationListenerService";

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


  ForegroundService foregroundService = null;

  boolean isBound;

  private ServiceConnection foregroundServices_connection = new ServiceConnection() {
    @Override
    public void onServiceConnected(ComponentName className, IBinder service) {
      ForegroundService.LocalBinder binder = (ForegroundService.LocalBinder) service;
      foregroundService = binder.getService();
      isBound = true;
    }
    @Override
    public void onServiceDisconnected(ComponentName arg0) {
      isBound = false;
    }
  };

  @Override
  public void onMethodCall(MethodCall call, Result result) {
    if (call.method.equals("start")) {

//      this.activity.startActivityForResult(new Intent(ACTION_NOTIFICATION_LISTENER_SETTINGS),0);

      IntentFilter intentFilter = new IntentFilter();
      intentFilter.addAction(ForegroundService.NOTIFICATION_INTENT);
      Intent notification_intent = new Intent();
      notification_intent.setAction(ACTION_NOTIFICATION_LISTENER);
//      activity.startActivity(notification_intent);

      Intent intent = new Intent(this.activity, ForegroundService.class);
      intent.setAction(STARTFOREGROUND_ACTION);
      intent.putExtra(Intent.EXTRA_INITIAL_INTENTS,notification_intent);
      intent.putExtra("title", (String)call.argument("title"));
      intent.putExtra("text", (String)call.argument("text"));
      intent.putExtra("subText", (String)call.argument("subText"));
      intent.putExtra("ticker", (String)call.argument("ticker"));
      intent.putExtra("modelPath",(String)call.argument("modelPath"));
      intent.putExtra("labelPath",(String)call.argument("labelPath"));

      activity.startService(intent);
//      this.activity.startActivityForResult(new Intent(ACTION_NOTIFICATION_LISTENER_SETTINGS),1);

//      activity.startActivity(new Intent("android.settings.ACTION_NOTIFICATION_LISTENER_SETTINGS").addFlags(Intent.FLAG_ACTIVITY_NEW_TASK));
      result.success(null);
    } else if (call.method.equals("stop")) {
      Intent intent = new Intent(activity, ForegroundService.class);
      intent.setAction(STOPFOREGROUND_ACTION);
      activity.stopService(intent);
      result.success(null);
    }else if(

            METHOD_CHANNEL_CALL.valueOf(call.method).equals(METHOD_CHANNEL_CALL.START_NOTIFICATION.getMethod())

    ){


      if (!permissionGiven()) {
//        this.activity.startActivity(new Intent(ACTION_NOTIFICATION_LISTENER_SETTINGS));

        this.activity.startActivityForResult(new Intent(ACTION_NOTIFICATION_LISTENER_SETTINGS),0);
      }else {
        this.activity.bindService(new Intent(ACTION_NOTIFICATION_LISTENER),foregroundServices_connection, Context.BIND_AUTO_CREATE);
      }
    }
    else {
      result.notImplemented();
    }

  }

  private boolean permissionGiven() {
    String packageName = this.activity.getPackageName();
    String flat = Settings.Secure.getString(this.activity.getContentResolver(),
            ENABLED_NOTIFICATION_LISTENERS);
    if (!TextUtils.isEmpty(flat)) {
      String[] names = flat.split(":");
      for (String name : names) {
        ComponentName componentName = ComponentName.unflattenFromString(name);
        boolean nameMatch = TextUtils.equals(packageName, componentName.getPackageName());
        if (nameMatch) {
          return true;
        }
      }
    }
    return false;
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
