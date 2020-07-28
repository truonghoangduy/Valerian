import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;
import 'package:Valerian/bloc/ble_bloc.dart';
import 'package:Valerian/bloc/blue_serial.dart';
// import 'package:Valerian/bloc/blue_serial_v2.dart';
import 'package:Valerian/regconiction/regconiction.dart';
import 'package:Valerian/screens/deviceConfig.dart';
import 'package:Valerian/screens/findDevices.dart';
import 'package:Valerian/screens/photo_library.dart';
import 'package:Valerian/screens/testByte.dart';
import 'package:Valerian/ultis/appRoute.dart';
import 'package:Valerian/ultis/globalPreferences.dart';
import 'package:Valerian/widgets/bluetoothOff.dart';
import 'package:Valerian/widgets/detectObjectOnImage.dart';
import 'package:Valerian/widgets/discoverDecvice.dart';
import 'package:clay_containers/widgets/clay_containers.dart';
import 'package:clay_containers/widgets/clay_text.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_blue/flutter_blue.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:clay_containers/clay_containers.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:foreground_service/foreground_service.dart';
// <service android:name="com.pauldemarco.foregroundservice.ForegroundService" >
// </service>

// Idea BLE send by mode 0|-------,------- For wificonfig
enum BLE_SEND_MODE {
  WIFI_CONFIG, // DEMIELT is|
  NOTIFICATION
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  // await Recognition().loadModel(); //// Only for Flutter not for foreground services running task
  await GlobalVarible().initLib();
  if (!GlobalVarible().checkAlreadyInitGobaleVarible()) {
    await GlobalVarible().initGobaleVarible();
  }
  await GlobalVarible().bluetoothState();

  runApp(FlutterBlueApp());
}

enum AppMode { DetectionTest, BLueTest }
final RouteObserver<Route> routeObserver = RouteObserver<Route>();

class FlutterBlueApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // final mode = AppMode.BLueTest;
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        color: Colors.lightBlue,
        routes: {
          AppRouting.devicePage: (context) => DeviceScrren(),
          AppRouting.scaningPage: (context) => BLuetoothDiscoverDevice(),
          AppRouting.bluetoothOffPage: (context) => BluetoothOffScreen(),
          AppRouting.homePage: (context) => BluetoothApdaterController(),
          AppRouting.viewPhotoPage: (context) => PhotoViewFromDevice(),
        },
        initialRoute: AppRouting.homePage,
        navigatorObservers: [routeObserver]);
  }
}

class BluetoothApdaterController extends StatefulWidget {
  @override
  _BluetoothApdaterControllerState createState() =>
      _BluetoothApdaterControllerState();
}

class _BluetoothApdaterControllerState
    extends State<BluetoothApdaterController> {
  BluetoothState state;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future<bool> checkPairedDevices() async {
    List<BluetoothDevice> listofDevices =
        await FlutterBluetoothSerial.instance.getBondedDevices();
    int deviceCounter = 0;
    listofDevices.forEach((element) {
      if (element.name == BOARD_NAME_SIGHT) {
        deviceCounter++;
      }
      if (element.name == BOARD_NAME_DISPLAY) {
        deviceCounter++;
      }
    });
    if (deviceCounter >= DEVICE_DEBUG) {
      return true;
    } else {
      print("MISING : "+ deviceCounter.toString() + "device 🤕");
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: StreamBuilder<BluetoothState>(
              stream: FlutterBluetoothSerial.instance.onStateChanged(),
              initialData: GlobalVarible().blue_state,
              builder: (context, snap) {
                print("Sate Change");
                print(snap.data.toString());
                if (snap.data == BluetoothState.STATE_OFF) {
                  return BluetoothOffScreen();
                }

                if (snap.data == BluetoothState.STATE_ON ||
                    snap.data == BluetoothState.STATE_TURNING_ON) {
                  return FutureBuilder<bool>(
                      future: checkPairedDevices(),
                      // initialData: true,
                      builder: (context, snapshot) {
                        if (snapshot.data == true) {
                          return DeviceScrren();
                        }
                        if (snapshot.data == false) {
                          print("👉 PairedDevices UNFOUND 😩😩😩");
                          return FloatingActionButton(
                              backgroundColor: Colors.red,
                              onPressed: () async {
                                await Navigator.popAndPushNamed(
                                    context,
                                    AppRouting.scaningPage);
                              });
                        }
                        return Container();
                      });
                }
                return Container(
                  color: Colors.black,
                );
              })),
    );
  }
}
