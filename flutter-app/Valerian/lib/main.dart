import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;
import 'package:Valerian/bloc/ble_bloc.dart';
import 'package:Valerian/regconiction/regconiction.dart';
import 'package:Valerian/screens/findDevices.dart';
import 'package:Valerian/screens/testByte.dart';
import 'package:Valerian/widgets/bluetoothOff.dart';
import 'package:Valerian/widgets/detectObjectOnImage.dart';
import 'package:clay_containers/widgets/clay_containers.dart';
import 'package:clay_containers/widgets/clay_text.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:clay_containers/clay_containers.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

// Idea BLE send by mode 0|-------,------- For wificonfig
enum BLE_SEND_MODE {
  WIFI_CONFIG, // DEMIELT is|
  NOTIFICATION
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  // await Recognition().loadModel();

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
  void initState(){
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: StreamBuilder<BluetoothState>(
                      stream: FlutterBluetoothSerial.instance.onStateChanged(),
                      builder: (context, snap) {
                        print("Sate Change");
                        print(snap.data.toString());
                        if (snap.data == BluetoothState.STATE_OFF) {
                          return BluetoothOffScreen();
                        }
                        return BLuetoothDiscover(
                          // color: Colors.black,
                          // width: 100,
                          // height: 100,
                        );
                      }
            )
      ),
    );
  }
}


// class FindDevicesScreen extends StatefulWidget {
//   @override
//   _FindDevicesScreenState createState() => _FindDevicesScreenState();
// }

// class _FindDevicesScreenState extends State<FindDevicesScreen> {
//   BLE_Bloc _ble_bloc;
//   _FindDevicesScreenState() {
//     _ble_bloc = BLE_Bloc();
//   }
//   @override
//   void initState() {
//     super.initState();
//     _ble_bloc.scanDevices();
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     _ble_bloc.dispose();
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

// class DeviceScrren extends StatefulWidget {
//   @override
//   _DeviceScrrenState createState() => _DeviceScrrenState();
// }

// class _DeviceScrrenState extends State<DeviceScrren> {
//   BLE_Bloc _ble_bloc;
//   final Map<String, Map<bool, IconData>> uiIcon = {
//     '0': {true: Icons.wifi, false: Icons.signal_wifi_off},
//     '1': {false: Icons.notifications_none, true: Icons.notifications_active},
//     '2': {false: Icons.collections_bookmark, true: Icons.collections_bookmark}
//   };
//   _DeviceScrrenState() {
//     _ble_bloc = BLE_Bloc();
//   }

//   final TextEditingController _controllerWifi_SSID = TextEditingController();
//   final TextEditingController _controllerWifi_Pass = TextEditingController();

//   String pressed;
//   @override
//   Widget build(BuildContext context) {
//     Size queryData = MediaQuery.of(context).size;
//     return Container(
//       width: double.infinity,
//       height: queryData.height,
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: <Widget>[
//           Container(
//               // color: Colors.yellowAccent,
//               width: queryData.width * 0.4,
//               height: queryData.height,
//               child: Column(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     ...uiIcon.keys.map((e) => GestureDetector(
//                             onDoubleTap: () => {
//                                   wifiDialog(context),
//                                   setState(() {
//                                     this.pressed = e;
//                                   })
//                                 },
//                             child: ClayContainer(
//                                 width: queryData.width * 0.3,
//                                 height: queryData.height * 0.15,
//                                 child: Icon(e == this.pressed
//                                     ? uiIcon[e][this.pressed == e]
//                                     : uiIcon[e][false],
//                                     size: 30,
//                                     color: e==this.pressed?Colors.blueAccent:Colors.black,)))
//                         // ...[1, 2, 3].map((e) => GestureDetector(
//                         //   onDoubleTap: ()=>{

//                         //     setState(() {
//                         //       this.pressed = e;
//                         //     })
//                         //   },
//                         //                       child: ClayContainer(
//                         //       width: queryData.width * 0.3,
//                         //       height: queryData.height * 0.15,
//                         //       child: Icon(
//                         //         Icons.wifi,
//                         //         size: 45,
//                         //         color: e==this.pressed?Colors.blueAccent:Colors.black,
//                         //       )
//                         //       // FlareActor("assets/images/Success Check.flr",
//                         //       // animation: "Untitled",),
//                         //       ),
//                         // )),
//                         // StreamBuilder(
//                         //     stream: _ble_bloc.ble_char_data,
//                         //     builder: (context, snapshot) {
//                         //       if (!snapshot.hasData) {
//                         //         return Container();
//                         //       } else {
//                         //         print(utf8.decode(snapshot.data));
//                         //         return Text(utf8.decode(snapshot.data),
//                         //             style: TextStyle(
//                         //               color: Colors.blueAccent
//                         //               ));
//                         //       }
//                         //     }),
//                         )
//                   ])),
//           Container(
//             // color: Colors.black45,
//             width: queryData.width * 0.6,
//             height: queryData.height,
//             child: Center(
//               child: ClayContainer(
//                 width: queryData.width * 0.6,
//                 height: queryData.height * 0.65,
//                 depth: 10,
//                 spread: 10,
//                 borderRadius: 15,
//                 child: Center(
//                     child: Transform.rotate(
//                   angle: -math.pi / 4,
//                   child: Image.asset("assets/images/concept_image.png"),
//                 )),
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }

//   wifiDialog(BuildContext context) async{
//     return await showDialog(context: context,
//     barrierDismissible: true,
//     builder: (BuildContext context)=>Dialog(
//         child: Container(
//           child:Column(
//             children: [
//               ...["SSID","Password"].map((e) => buildWifiConfig(e=="SSID"?_controllerWifi_SSID:_controllerWifi_Pass, e))

//             ],
//           )
//         )
//     ));
//   }

//   Widget buildWifiConfig(TextEditingController textcontroller,String textLable){
//     return TextField(
//       controller: textcontroller,
//       decoration: InputDecoration(
//         labelText: textLable
//       ),

//     );
//   }
// }

// class BLE_Functionality extends StatefulWidget {
//   @override
//   _BLE_FunctionalityState createState() => _BLE_FunctionalityState();
// }

// class _BLE_FunctionalityState extends State<BLE_Functionality> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(

//     );
//   }
// }

// class DeviceServies extends StatelessWidget {
//   final BluetoothCharacteristic characteristic;
//   DeviceServies(this.characteristic) {}
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: <Widget>[
//         Container(
//           color: Colors.yellowAccent,
//           width: double.infinity,
//           height: double.infinity,
//         ),
//         Container(
//           color: Colors.blue,
//           width: double.infinity,
//           height: double.infinity,
//         )
//       ],
//     );
//   }
// }
