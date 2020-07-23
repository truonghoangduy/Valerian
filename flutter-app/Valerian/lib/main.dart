import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;
import 'package:Valerian/bloc/ble_bloc.dart';
import 'package:Valerian/bloc/blue_serial_v2.dart';
import 'package:Valerian/regconiction/regconiction.dart';
import 'package:Valerian/screens/deviceConfig.dart';
import 'package:Valerian/screens/findDevices.dart';
import 'package:Valerian/screens/testByte.dart';
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

class FlutterBlueApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mode = AppMode.BLueTest;
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        color: Colors.lightBlue,
        home:
            // mode==AppMode.DetectionTest?
            //     BLuetoothDiscover():
            //     // TestByte():
            //     // Detection():
            //     // Container()

            // StreamBuilder<BluetoothState>(
            //     stream: FlutterBluetoothSerial.instance.state,
            //     // initialData: BluetoothState.STATE_ON,
            //     builder: (c, snapshot) {
            //       final state = snapshot.data;
            //       if (state == BluetoothState.STATE_ON) {
            //         return FindDevicesScreen();
            //       }
            //       if (state == BluetoothState.UNKNOWN) {
            //         return Container();
            //       }
            //       if (state == BluetoothState.STATE_OFF) {
            //         return Container();
            //       }
            //       // return BLuetoothDiscover();
            //       // return Container();
            //     }),
            BluetoothApdaterController());
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
                      // future: checkPairedDevices(),
                      initialData: true,
                      builder: (context, snapshot) {
                        if (snapshot.data == true) {
                          return DeviceScrren();
                        }
                        if (snapshot.data == false) {
                          return BLuetoothDiscoverDevice();
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

// class FindDevicesScreen extends StatefulWidget {
//   @override
//   _FindDevicesScreenState createState() => _FindDevicesScreenState();
// }

// class _FindDevicesScreenState extends State<FindDevicesScreen> {
//   _FindDevicesScreenState() {
//   }
//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }

//   Widget discoverBLE(
//       BluetoothDeviceState snapshot, Size queryData, BuildContext context) {
//     if (BluetoothDeviceState.connected != snapshot) {
//       // Debug
//       return DeviceScrren();

//       //       GestureDetector(
//       //           // backgroundColor: Colors.green,
//       //           child: Container(
//       //   color: AppColoring.neumorphisum,
//       //   child: Center(
//       //     child: ClayContainer(
//       //       color: AppColoring.neumorphisum,
//       //       height: 200,
//       //       width: 200,
//       //     ),
//       //   ),
//       // ),
//       //           onDoubleTap: () {
//       //             _ble_bloc.writeTo(_ble_bloc.targetCharacteristic,
//       //                 "nv2fBYQqNjpJSgDrvZdmspCq5L0KfDcOcvxbdJH4WKcYYJpSbwnv2fBYQqNjpJSgDrvZdmspCq5L0KfDcOcvxbdJH4WKcYYJpSbwZZZZZ");
//       //           })
//     } else if (BluetoothDeviceState.disconnected == snapshot) {
//       return Container(
//         alignment: Alignment.center,
//         color: AppColoring.background,
//         child: Stack(
//           children: <Widget>[
//             Center(
//                 // color: Colors.black,
//                 // width: queryData.width,
//                 // height: queryData.height*0.3,
//                 child: Container(
//                     width: queryData.width,
//                     height: queryData.height * 0.5,
//                     child: lost_Connection)),
//             Center(
//                 child: Container(
//                     margin: EdgeInsets.only(
//                       top: queryData.height * 0.37,
//                     ),
//                     child: Text(
//                       "Losing Connection",
//                       style: TextStyle(
//                           fontFamily: 'OpenSans',
//                           fontWeight: FontWeight.bold,
//                           color: Colors.black,
//                           fontSize: queryData.width * 0.05),
//                     ))),
//             // StreamBuilder<String>(
//             //     stream: _ble_bloc.ble_content.stream,
//             //     builder: (context, snapshot) {
//             //       if (!snapshot.hasData) {
//             //         return Container(
//             //           width: 100,
//             //           height: 100,
//             //           color: Colors.blueAccent,
//             //         );
//             //       } else {
//             //         return Text(snapshot.data);
//             //       }
//             //     }),
//           ],
//         ),
//       );
//     }
//   }

//   final FlareActor ble_scaning = FlareActor(
//     "assets/images/Bluetooth Scan.flr",
//     isPaused: false,
//     snapToEnd: false,
//     fit: BoxFit.scaleDown,
//     animation: "Untitled",
//   );
//   final FlareActor lost_Connection = FlareActor(
//     "assets/images/dost-login.flr",
//     isPaused: false,
//     snapToEnd: true,
//     // fit: BoxFit.scaleDown,
//     animation: "Untitled",
//   );
//   @override
//   Widget build(BuildContext context) {
//     Size queryData = MediaQuery.of(context).size;
//     // TODO: implement build
//     return Scaffold(
//       // appBar: AppBar(
//       //   title: Text(
//       //     "ESP32",
//       //     style: TextStyle(fontFamily: 'OpenSans', fontWeight: FontWeight.bold),
//       //   ),
//       // ),
//       bottomNavigationBar: BottomNavigationBar(
//         items: const <BottomNavigationBarItem>[
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home),
//             title: Text('Home'),
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.image),
//             title: Text('Recogintion'),
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.settings),
//             title: Text('Sesting'),
//           ),
//         ],
//         currentIndex: 0,
//         selectedItemColor: Colors.amber[800],
//         onTap: (i) {},
//       ),
//       body: Container(
//         color: AppColoring.background,
//         child: StreamBuilder<BluetoothDeviceState>(
//             stream: _ble_bloc.device_state.stream,
//             initialData: null,
//             builder: (context, snapshot) {
//               if (snapshot.hasData) {
//                 return ble_scaning;
//               }
//               return discoverBLE(snapshot.data, queryData, context);
//             }),
//       ),
//     );
//   }
// }
