package com.pauldemarco.foregroundservice;

import android.Manifest;
import android.app.Notification;
import android.app.PendingIntent;
//import android.app.Service;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.content.res.AssetFileDescriptor;
import android.content.res.AssetManager;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.Binder;
import android.os.Bundle;
import android.os.IBinder;
import android.os.Build;
import android.graphics.Color;
import android.app.NotificationChannel;
import android.app.NotificationManager;

import androidx.core.app.NotificationCompat;

import io.flutter.Log;
import io.reactivex.rxjava3.functions.Consumer;
import io.reactivex.rxjava3.subjects.BehaviorSubject;
import me.aflak.bluetooth.Bluetooth;
import me.aflak.bluetooth.interfaces.DeviceCallback;
 import me.aflak.bluetooth.interfaces.DiscoveryCallback;

import android.bluetooth.BluetoothDevice;
import android.service.notification.NotificationListenerService;
import android.service.notification.StatusBarNotification;
//import java.util.function.Predicate;
//import java.util.stream.Collectors;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.nio.ByteBuffer;
import java.nio.MappedByteBuffer;
import java.nio.channels.FileChannel;
import java.nio.charset.StandardCharsets;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;
import java.util.Vector;
import java.util.concurrent.Executor;
import java.util.concurrent.Executors;






    public class ForegroundService extends NotificationListenerService {
    public static String NOTIFICATION_INTENT = "com.pauldemarco.foregroundservice";
    private static final String TAG = "ForegroundService";
    Bluetooth bluetoothScan;
    Bluetooth displayDevice;
    Bluetooth sightDevice;

    BehaviorSubject<BluetoothState> bluetoothDeviceState;
    public boolean foundTagSight;
    public boolean foundTagDisplay;
    List<Byte[]> pictureBuffer;

    public boolean WRITE_TO_FILE;

    Context applicationContext;



    int counter = 0;


    private Vector<String> labels;
    float[][] labelProb;

    private List<String> loadLabels(AssetManager assetManager, String path) {
        BufferedReader br;
        try {
            if (assetManager != null) {
                br = new BufferedReader(new InputStreamReader(assetManager.open(path)));
            } else {
                br = new BufferedReader(new InputStreamReader(new FileInputStream(new File(path))));
            }
            String line;
            labels = new Vector<>();
            while ((line = br.readLine()) != null) {
                labels.add(line);
            }
            labelProb = new float[1][labels.size()];
            br.close();
            return labels;
        } catch (IOException e) {
            throw new RuntimeException("Failed to read label file", e);
        }
    }

    public MappedByteBuffer loadModelTemper(String path, boolean isAsset) throws IOException {
        AssetFileDescriptor fileDescriptor = assetManager.openFd(path);
        FileInputStream inputStream = new FileInputStream(fileDescriptor.getFileDescriptor());
        FileChannel fileChannel = inputStream.getChannel();
        long startOffset = fileDescriptor.getStartOffset();
        long declaredLength = fileDescriptor.getDeclaredLength();
        return fileChannel.map(FileChannel.MapMode.READ_ONLY, startOffset, declaredLength);

    }


//    private Observable<BluetoothState> getBluetoothDeviceState(){
//        return Observable.create()
//    }

    void reactiveBluetoothInit(){
        bluetoothDeviceState.subscribe(new Consumer<BluetoothState>() {
            @Override
            public void accept(BluetoothState bluetoothState) throws Throwable {
                if (bluetoothState == BluetoothState.DISPLAY_DISCONNECTED){
                    Log.d("reactiveBluetoothInit","BluetoothState.DISPLAY_DISCONNECTED)");
                    if (!displayDevice.isConnected()){
                        displayDevice.connectToNameWithPortTrick("Valerian-Display-Test01");
                    }else {
                        Log.d(TAG,"Valerian-Display STILL CONNECTED 👍");
                    }

                }
                if (bluetoothState == BluetoothState.SIGHT_DISCONNECTED){
                    Log.d("reactiveBluetoothInit","BluetoothState.SIGHT_DISCONNECTED");
                    if(!sightDevice.isConnected()){
                        sightDevice.connectToNameWithPortTrick("Valerian-Sight");
                    }else {
                        Log.d(TAG,"Valerian-Sight STILL CONNECTED 👍");
                    }
                }
                if (bluetoothState == BluetoothState.SEND_TO_SIGHT){
                    sightDevice.send("0".getBytes());
                }
                if (bluetoothState == BluetoothState.RE_SCAN){
                    bluetoothScan.startScanning();
                }
            }
        });
    }

    void initBluetoothDevicesConnectionCallBack(){
        displayDevice.setDeviceCallback(DisplayConnectionCallBack);
        sightDevice.setDeviceCallback(SightConnectionCallback);
    }

    void initBluetoothLib(){
        bluetoothScan = new Bluetooth(this);
        displayDevice = new Bluetooth(this);
        sightDevice = new Bluetooth(this);
    }


    void checkPremission(){

        if (checkSelfPermission(Manifest.permission.FOREGROUND_SERVICE) == PackageManager.PERMISSION_GRANTED){
            Log.d(TAG,"PREMISSION OK FOR FOREGROUND");
        }else {
            Log.d(TAG,"do not has premission to run on FOREGROUND");
            if (checkSelfPermission(Manifest.permission.BIND_NOTIFICATION_LISTENER_SERVICE) == PackageManager.PERMISSION_GRANTED){
                Log.d(TAG,"PREMISSION OK FOR BIND_NOTIFICATION_LISTENER_SERVICE");
            }else {
                Log.d(TAG,"do not has premission to run on FOREGROUND");
            }
            if (checkSelfPermission(Manifest.permission.ACCESS_NOTIFICATION_POLICY) == PackageManager.PERMISSION_GRANTED){
                Log.d(TAG,"PREMISSION OK FOR ACCESS_NOTIFICATION_POLICY");
            }else {
                Log.d(TAG,"do not has premission to run on FOREGROUND");
            }
        }
    }


    void createBluetooth(){
        pictureBuffer = new ArrayList<>();
        foundTagSight = false;
        foundTagDisplay= false;
        Log.d(TAG,"Bluetooth CALLL LIB");
        checkPremission();
        initBluetoothLib();
//         bluetoothScan = new Bluetooth(this);
//         libBluetooth.setBluetoothCallback(bluetoothSightCallback);


        bluetoothScan.setDiscoveryCallback(bluetoothDiscoveryCallback);

        sightDevice.setDeviceCallback(SightConnectionCallback);
        sightDevice.setReader(DisplayBytePraser.class);
        displayDevice.setDeviceCallback(DisplayConnectionCallBack);

        sightDevice.onStart();
        displayDevice.onStart();
        bluetoothScan.onStart();
        reactiveBluetoothInit();


        if(bluetoothScan.isEnabled()){
            Log.d(TAG,"Bluetooth enable");
            bluetoothScan.startScanning();
            // doStuffWhenBluetoothOn() ...
        } else {
//            libBluetooth.showEnableDialog();
        }
     }





    private DiscoveryCallback bluetoothDiscoveryCallback = new DiscoveryCallback() {
         @Override
         public void onDiscoveryStarted() {
             Log.d(TAG,"onDiscoveryStarted: SCANING BEGIN");

         }

         @Override
         public void onDiscoveryFinished() {
             Log.d(TAG,"onDiscoveryFinished: SCANING TIME OUT");
             Log.d(TAG,"onDiscoveryFinished FLAG" + foundTagSight);
             if (foundTagDisplay) {
                 foundTagDisplay = false;
                 Log.d(TAG, "onDiscoveryFinished: DEVICE FOUNDED : Display");
                 bluetoothDeviceState.onNext(BluetoothState.DISPLAY_DISCONNECTED);
             }
             if (foundTagSight){
                 foundTagSight = false;
                 Log.d(TAG,"onDiscoveryFinished: DEVICE FOUNDED : Sight)");
                 bluetoothDeviceState.onNext(BluetoothState.SIGHT_DISCONNECTED);

             }
             else {
                 bluetoothScan.startScanning();

             }

         }

         @Override
         public void onDeviceFound(BluetoothDevice device) {
             Log.d(TAG,"onDevicesFound: "+ device.getAddress() +"    " + device.getName());
             if (device.getName() != null){
                 if (device.getName().equalsIgnoreCase("Valerian-Sight")){
                     foundTagSight = true;
                     Log.d(TAG,"onDevicesFound: "+ "Founded Device");
                     Log.d(TAG,"onDevicesFound FLAG" + foundTagSight);
                 }
                 if (device.getName().equalsIgnoreCase("Valerian-Display-Test01")){
                     foundTagDisplay = true;
                     Log.d(TAG,"onDevicesFound: "+ "Founded Device");
                     Log.d(TAG,"onDevicesFound FLAG" + foundTagSight);
                 }
             }
         }

         @Override
         public void onDevicePaired(BluetoothDevice device) {

         }

         @Override
         public void onDeviceUnpaired(BluetoothDevice device) {

         }

         @Override
         public void onError(int errorCode) {

         }
     };





     private DeviceCallback DisplayConnectionCallBack = new DeviceCallback() {
         @Override
         public void onDeviceConnected(BluetoothDevice device) {
             Log.d(TAG,"onDeviceConnected " + device.getName());
             displayDevice.send("0Hello World");
         }

         @Override
         public void onDeviceDisconnected(BluetoothDevice device, String message) {
             Log.d(TAG,"onDeviceDisconnected :"+device.getName() + "DISCONECTED" + message);

             bluetoothDeviceState.onNext(BluetoothState.RE_SCAN);



         }

         @Override
         public void onMessage(byte[] message) {

             String content = new String(message, StandardCharsets.UTF_8);
             Log.d("onMessage DISPLAY : ",content);
             if (content.equalsIgnoreCase("2")){
                 bluetoothDeviceState.onNext(BluetoothState.SEND_TO_SIGHT);
             }

         }

         @Override
         public void onError(int errorCode) {

         }

         @Override
         public void onConnectError(BluetoothDevice device, String message) {
             bluetoothDeviceState.onNext(BluetoothState.RE_SCAN);

         }
     };



    List<byte[]> bluetoothPicturePackage = new ArrayList<>();



    SimpleDateFormat ft = new SimpleDateFormat ("E yyyy.MM.dd 'at' hh:mm:ss a zzz");



     private DeviceCallback SightConnectionCallback = new DeviceCallback() {

         @Override
         public void onDeviceConnected(BluetoothDevice device) {
             Log.d(TAG,"onDeviceConnected " + device.getName());
//             sightDevice.send("0".getBytes());
         }

         @Override
         public void onDeviceDisconnected(BluetoothDevice device, String message) {

         }

         @Override
         public void onMessage(byte[] message) {
             //TODO Sight Device Bytes

             bluetoothPicturePackage.add(message);
             counter += message.length;

             Log.d(TAG,"RECIVED : " + message.length + " -- CHUNK : " + bluetoothPicturePackage.size() + " -- ContentLenght : " + counter);
//             pictureBuffer.add(TypedArrayUtils.getb)
                try {
                    if ( message[message.length-2] == -1 && message[message.length-1] == -39){
                        Log.d(TAG,"Found End FLAG");

                        ByteBuffer picture = ByteBuffer.allocate(counter);
                        for(byte[] bytes : bluetoothPicturePackage){
                            picture.put(bytes);
                        }


                        final Bitmap pictureBuffer = BitmapFactory.decodeByteArray(picture.array(),0,picture.array().length);
                        if (TF_READY){

                            List<Classifier.Recognition> result = classifier.recognizeImage(pictureBuffer);
                            Log.d(TAG,String.valueOf(result.size()));
                            if (displayDevice.isConnected()){
                                for (Classifier.Recognition euchres:result) {
                                    Log.d(TAG,euchres.getTitle() + "👈" + euchres.getConfidence());
                                }
                                if (result.size() <= 0 ){
                                    Log.d(TAG,"NULLLL OBJECT 😂😂😂😂😂😂");
                                    displayDevice.send("0"+"Undetected");
                                }else {
                                    displayDevice.send("0"+result.get(0).getTitle());
                                }
                            }else {
                                Log.d(TAG + "SIGHT DISCONNECTED 🔥","");
                            }



                        }

                        if (true){
                            // MAKE NEW THREAD
                            executor.execute(new Runnable() {
                                @Override
                                public void run() {
                                    new ImageToFile(applicationContext).setDirectoryName("images").setExternal(false)
                                            .setFileName("")
                                            .save(pictureBuffer);
                                }
                            });
                        }

                        counter = 0;
                        picture.clear();
                        bluetoothPicturePackage.clear();

                    }
                }catch (ArrayIndexOutOfBoundsException e){
                    Log.d(TAG,e.getMessage());
                }

         }

         public void bufferPictureToTensorFlow(){

         }

         @Override
         public void onError(int errorCode) {

         }

         @Override
         public void onConnectError(BluetoothDevice device, String message) {

         }
     };
























     AssetManager assetManager;
    private Executor executor = Executors.newSingleThreadExecutor();
    private Classifier classifier;
    boolean TF_READY =false;




    @Override
    public void onCreate() {
        super.onCreate();
        assetManager = this.getAssets();
        Log.d(TAG,"ForeGround Work 1?");
        applicationContext = this.getApplicationContext();

//        loadLabels(this.getAssets(),"flutter_assets/assets/labelmap.txt");
//
//        try {
//            loadModelTemper("flutter_assets/assets/detect.tflite",true);
//        } catch (IOException e) {
//            e.printStackTrace();
//        }

        executor.execute(new Runnable() {
            @Override
            public void run() {
                try {
                    classifier = new TensorFlowImageClassifier(
                            "flutter_assets/assets/mobilenet_float_v1_224.tflite",
                            "flutter_assets/assets/labelmap.txt",
                            loadLabels(assetManager,"flutter_assets/assets/labels.txt"),
                            loadModelTemper("flutter_assets/assets/mobilenet_float_v1_224.tflite",true),
                            224,false,
                            4,0.1f);
                    TF_READY = true;
                } catch (final Exception e) {
                    throw new RuntimeException("Error initializing TensorFlow!", e);
                }
            }
        });
        runWithPresistion();



        bluetoothDeviceState = BehaviorSubject.create();
        createBluetooth();
//        libBluetooth.startScanning();
    }

    void runWithPresistion(){
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O)
        {
            int ONGOING_NOTIFICATION_ID = 2;

            String NOTIFICATION_CHANNEL_ID = "com.pauldemarco.foregroundservice";
            String channelName = "Foreground Service";
            NotificationChannel chan = new NotificationChannel(NOTIFICATION_CHANNEL_ID,
                    channelName, NotificationManager.IMPORTANCE_NONE);

            chan.setLightColor(Color.BLUE);
            chan.setLockscreenVisibility(Notification.VISIBILITY_PRIVATE);
            NotificationManager manager = (NotificationManager) getSystemService(
                    getApplicationContext().NOTIFICATION_SERVICE);
            assert manager != null;
            manager.createNotificationChannel(chan);

            NotificationCompat.Builder notificationBuilder =
                    new NotificationCompat.Builder(this, NOTIFICATION_CHANNEL_ID);

            Notification notification = notificationBuilder
                    .setOngoing(true)
                    // .setSmallIcon(R.drawable.icon_1)
                    .setContentTitle("Valerian")
                    .setContentText("Background Bluetooth Execution")
                    .setSubText("Sub TEXT")
                    .setTicker("Ticker")
                    .setPriority(NotificationManager.IMPORTANCE_MAX)
                    .setCategory(Notification.CATEGORY_SERVICE)
                    .build();

            startForeground(ONGOING_NOTIFICATION_ID, notification);
        }
    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        if (ForegroundServicePlugin.STARTFOREGROUND_ACTION.equals(intent.getAction())) {
            PackageManager pm = getApplicationContext().getPackageManager();
            Intent notificationIntent = pm.getLaunchIntentForPackage(getApplicationContext().getPackageName());
            PendingIntent pendingIntent = PendingIntent.getActivity(this, 0,
                    notificationIntent, 0);

            Bundle bundle = intent.getExtras();
            // HANDLE WRITE TO FILE



            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O)
            {
                int ONGOING_NOTIFICATION_ID = 2;

                String NOTIFICATION_CHANNEL_ID = "com.pauldemarco.foregroundservice";
                String channelName = "Foreground Service";
                NotificationChannel chan = new NotificationChannel(NOTIFICATION_CHANNEL_ID,
                    channelName, NotificationManager.IMPORTANCE_NONE);

                chan.setLightColor(Color.BLUE);
                chan.setLockscreenVisibility(Notification.VISIBILITY_PRIVATE);
                NotificationManager manager = (NotificationManager) getSystemService(
                    getApplicationContext().NOTIFICATION_SERVICE);
                assert manager != null;
                manager.createNotificationChannel(chan);

                NotificationCompat.Builder notificationBuilder =
                    new NotificationCompat.Builder(this, NOTIFICATION_CHANNEL_ID);

                Notification notification = notificationBuilder
                    .setOngoing(true)
                    // .setSmallIcon(R.drawable.icon_1)
                    .setContentTitle(bundle.getString("title"))
                    .setContentText(bundle.getString("text"))
                    .setSubText(bundle.getString("subText"))
                    .setTicker(bundle.getString("ticker"))
                    .setPriority(NotificationManager.IMPORTANCE_MAX)
                    .setCategory(Notification.CATEGORY_SERVICE)
                    .build();

                startForeground(ONGOING_NOTIFICATION_ID, notification);
            }
            else
            {
                int ONGOING_NOTIFICATION_ID = 1;

                Notification notification =
                    new NotificationCompat.Builder(this)
                            .setOngoing(true)
                            .setPriority(NotificationCompat.PRIORITY_MAX)
                            .setContentTitle(bundle.getString("title"))
                            .setContentText(bundle.getString("text"))
                            .setSubText(bundle.getString("subText"))
                            .setTicker(bundle.getString("ticker"))
                            .setSmallIcon(android.R.drawable.ic_dialog_info)
                            .setContentIntent(pendingIntent)
                            .build();
                            
               startForeground(ONGOING_NOTIFICATION_ID, notification);
            }

        } else if (ForegroundServicePlugin.STOPFOREGROUND_ACTION.equals(intent.getAction())) {
            Log.d(TAG,"🧨 Stop Foreground Services");
            stopForeground(true);
            stopSelf();
        }
        return START_STICKY;
    }

    enum NOTIFICATION_ENCODE{
        MSG_NOTIFICATION,
        CALL_NOTIFICATION,
        DECTION_NOTIFICATION
    }

    String notifiCation_EncodeSwitch(String codex ){
        switch (codex){
            case Notification.CATEGORY_CALL:
                return String.valueOf(NOTIFICATION_ENCODE.CALL_NOTIFICATION.ordinal()) ;
            case Notification.CATEGORY_MESSAGE:
                return String.valueOf(NOTIFICATION_ENCODE.MSG_NOTIFICATION.ordinal());
            default:
                return String.valueOf(NOTIFICATION_ENCODE.MSG_NOTIFICATION.ordinal());
        }
    }

    boolean filter_Notification_Category(String codex){
        switch (codex){
            case Notification.CATEGORY_CALL:
                return true;
            case Notification.CATEGORY_MESSAGE:
                return true;
            default:
                return false;
        }
    }


    @Override
    public void onNotificationPosted(StatusBarNotification sbn) {
        String pack = sbn.getPackageName();
        String tiker="";
        String notification_category ="";
        String title = "";
        String text="";

        Bundle extraOnNotifi = sbn.getNotification().extras;
        title =  extraOnNotifi.getString("android.title");
        text = extraOnNotifi.getString("android.text").toString();
        if (sbn.getNotification().tickerText != null){
            tiker = sbn.getNotification().tickerText.toString();

        }

        if (sbn.getNotification().category != null){
            notification_category = this.notifiCation_EncodeSwitch(sbn.getNotification().category);
            if (displayDevice != null){
                if ( displayDevice.isConnected()){
                    try {
                        if (this.filter_Notification_Category(sbn.getNotification().category)){
                            displayDevice.send(notification_category+tiker);
                        }
                    }catch (Exception e){
                        Log.d(TAG,e.getMessage());
                    }
                }
            }

        }

        Log.d(TAG,"onNotificationPosted : 👉 " + tiker +" 🌟 "+ sbn.getNotification().category);




    }

    public class LocalBinder extends Binder {
            ForegroundService getService() {
                return ForegroundService.this;
            }
    }


    public void cleanUPBluetoothStack(){
        if (displayDevice != null){
            if (displayDevice.isConnected()){
                displayDevice.disconnect();
            }
        }
        if (sightDevice != null){
            if (sightDevice.isConnected()){
                sightDevice.disconnect();
            }
        }
        bluetoothScan.onStop();
        bluetoothScan.stopScanning();
    }





    @Override
    public void onDestroy() {
        super.onDestroy();
//        bluetoothScan.onStop();

//        sightDevice.disconnect();
//        displayDevice.disconnect();
        Log.d(TAG,"ForeGround OFFF ?");

        cleanUPBluetoothStack();
//        stopForeground(true);
//        stopSelf();

    }

    @Override
    public IBinder onBind(Intent intent) {
        Log.d(TAG,intent.getAction());
        // Used only in case if services are bound (Bound Services).
        return super.onBind(intent);
    }

    @Override
    public void onNotificationRemoved(StatusBarNotification sbn) {
//        throw new RuntimeException("Stub!");
    }

    @Override
    public void onListenerConnected(){
        super.onListenerConnected();
        Log.d(TAG," : onListenerConnected to NLS");
    }

    @Override
    public void onListenerDisconnected(){
        super.onListenerDisconnected();
        Log.d(TAG,"onListenerDisconnected NLS");
    }



}
