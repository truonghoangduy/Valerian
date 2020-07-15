import 'package:Valerian/ultis/appColoring.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class FindDevicesScreen extends StatefulWidget {
  @override
  _FindDevicesScreenState createState() => _FindDevicesScreenState();
}

class _FindDevicesScreenState extends State<FindDevicesScreen> {
  _FindDevicesScreenState() {
  }
  @override
  void initState() {
    super.initState();
    // _ble_bloc.scanDevices();
  }

  @override
  void dispose() {
    super.dispose();
    // _ble_bloc.dispose();
  }

  // Widget discoverBLE(
  //     BluetoothDeviceState snapshot, Size queryData, BuildContext context) {
  //   if (BluetoothDeviceState.connected != snapshot) {
  //     // Debug
  //     return DeviceScrren();

      //       GestureDetector(
      //           // backgroundColor: Colors.green,
      //           child: Container(
      //   color: AppColoring.neumorphisum,
      //   child: Center(
      //     child: ClayContainer(
      //       color: AppColoring.neumorphisum,
      //       height: 200,
      //       width: 200,
      //     ),
      //   ),
      // ),
      //           onDoubleTap: () {
      //             _ble_bloc.writeTo(_ble_bloc.targetCharacteristic,
      //                 "nv2fBYQqNjpJSgDrvZdmspCq5L0KfDcOcvxbdJH4WKcYYJpSbwnv2fBYQqNjpJSgDrvZdmspCq5L0KfDcOcvxbdJH4WKcYYJpSbwZZZZZ");
      //           })
    // } else if (BluetoothDeviceState.disconnected == snapshot) {
    //   return Container(
    //     alignment: Alignment.center,
    //     color: AppColoring.background,
    //     child: Stack(
    //       children: <Widget>[
    //         Center(
    //             // color: Colors.black,
    //             // width: queryData.width,
    //             // height: queryData.height*0.3,
    //             child: Container(
    //                 width: queryData.width,
    //                 height: queryData.height * 0.5,
    //                 child: lost_Connection)),
    //         Center(
    //             child: Container(
    //                 margin: EdgeInsets.only(
    //                   top: queryData.height * 0.37,
    //                 ),
    //                 child: Text(
    //                   "Losing Connection",
    //                   style: TextStyle(
    //                       fontFamily: 'OpenSans',
    //                       fontWeight: FontWeight.bold,
    //                       color: Colors.black,
    //                       fontSize: queryData.width * 0.05),
    //                 ))),
            // StreamBuilder<String>(
            //     stream: _ble_bloc.ble_content.stream,
            //     builder: (context, snapshot) {
            //       if (!snapshot.hasData) {
            //         return Container(
            //           width: 100,
            //           height: 100,
            //           color: Colors.blueAccent,
            //         );
            //       } else {
            //         return Text(snapshot.data);
            //       }
            //     }),
  //         ],
  //       ),
  //     );
  //   }
  // }

  final FlareActor ble_scaning = FlareActor(
    "assets/images/Bluetooth Scan.flr",
    isPaused: false,
    snapToEnd: false,
    fit: BoxFit.scaleDown,
    animation: "Untitled",
  );
  final FlareActor lost_Connection = FlareActor(
    "assets/images/dost-login.flr",
    isPaused: false,
    snapToEnd: true,
    // fit: BoxFit.scaleDown,
    animation: "Untitled",
  );
  @override
  Widget build(BuildContext context) {
    Size queryData = MediaQuery.of(context).size;
    // TODO: implement build
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(
      //     "ESP32",
      //     style: TextStyle(fontFamily: 'OpenSans', fontWeight: FontWeight.bold),
      //   ),
      // ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.image),
            title: Text('Recogintion'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            title: Text('Sesting'),
          ),
        ],
        currentIndex: 0,
        selectedItemColor: Colors.amber[800],
        onTap: (i) {},
      ),
      body: Container(
        color: AppColoring.background,
        child: StreamBuilder<bool>(
            stream: Stream.empty(),
            initialData: true,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ble_scaning;
              }
              // return discoverBLE(snapshot.data, queryData, context);
            }),
      ),
    );
  }
}




// class BLuetoothDiscover extends StatefulWidget {
//   @override
//   _BLuetoothDiscoverState createState() => _BLuetoothDiscoverState();
// }

// class _BLuetoothDiscoverState extends State<BLuetoothDiscover> {
//   BluetoothState _bluetoothState = BluetoothState.UNKNOWN;
//   BluetoothBloc _bluetoothBloc;
//   Recognition recognition;
//   bool captured = false;
//   _BLuetoothDiscoverState() {
//     this._bluetoothBloc = new BluetoothBloc();
//     this.recognition = new Recognition();
//   }
//   final FlareActor ble_scaning = FlareActor(
//     "assets/images/Bluetooth Scan.flr",
//     isPaused: false,
//     snapToEnd: false,
//     fit: BoxFit.scaleDown,
//     animation: "Untitled",
//   );
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(),
//       body: SingleChildScrollView(
//               child: Column(
//           children: <Widget>[
//             SwitchListTile(
//               title: Text('Enable Bluetooth'),
//               value: _bluetoothState.isEnabled,
//               onChanged: (bool value) async {
//                 if (value) {
//                   await FlutterBluetoothSerial.instance.requestEnable();
//                   var vaule = await FlutterBluetoothSerial.instance.isAvailable;
//                   print(vaule);
//                 } else {
//                   await FlutterBluetoothSerial.instance.requestDisable();
//                 }
//               },
//             ),
//             // StreamBuilder<BluetoothDiscoveryResult>(
//             //   stream: FlutterBluetoothSerial.instance.startDiscovery(),
//             //   builder: (BuildContext context,AsyncSnapshot<BluetoothDiscoveryResult> snapshot){
//             //     if (snapshot.hasData && snapshot.data.device.address !=null && snapshot.data.device.name == BOARD_NAME) {
//             //       if (snapshot.data.device.name == BOARD_NAME) {
//             //         print("Find Ya");
//             //         return Container(
//             //         color: Colors.yellowAccent,
//             //         width: 100,
//             //         height: 100,
//             //         child:Text(snapshot.data.device.name!=null?snapshot.data.device.name:snapshot.data.device.address),

//             //       );
//             //       }

//             //     }else{
//             //       return Container(
//             //         color: Colors.blueAccent,
//             //         width: 100,
//             //         height: 100,
//             //       );
//             //     }
//             // })
//             FutureBuilder<bool>(
//                 future: this._bluetoothBloc.scanDevices(),
//                 initialData: false,
//                 builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
//                   if (snapshot.data == true) {
//                     return Container(
//                       color: Colors.blueAccent,
//                       width: 100,
//                       height: 100,
//                       // child: Text(this._bluetoothBloc.device.name),
//                     );
//                   }
//                   return Container(
//                     width: 200,
//                     height: 200,
//                     color: Colors.black38,
//                     // child: ble_scaning,
//                   );
//                 }),
//             FloatingActionButton(
//               onPressed: () async {
//                 if (await this._bluetoothBloc.connectToDevice()) {
//                   print("Connected");
//                 }
//               },
//               isExtended: true,
//               backgroundColor:Colors.redAccent,

//               child:
//                 Text("Connecting"),
//             ),
//             FloatingActionButton(
//               child: Container(
//                 color: Colors.greenAccent,
//                 child: Text("Capture"),
//               ),
//               onPressed: () async{
//                await this._bluetoothBloc.invokeCAMERA();
//             }),
//             FloatingActionButton(
//               // child: ,

//               onPressed: () => {
//                 setState(() {
//                   this.captured = !this.captured;
//                 })
//               },
//               backgroundColor: Colors.yellow,
//             ),

//             this.captured
//                 ? Column(
//                   children: <Widget>[
//                     Image.memory(
//                         // Uint8List.fromList(this._bluetoothBloc.image)
//                         this._bluetoothBloc.pictureformBuffer),
//                     FutureBuilder<List<dynamic>>(
//                       future:Recognition.objectDection_V2_BlueSerial(this._bluetoothBloc.pictureformBuffer),
//                       builder: (context,snap){
//                       if (snap.data != null) {
//                       print(snap.data);
//                       return Column(
//                         children: <Widget>[
//                           // Image.network(path),
//                           Image.memory(Recognition.temper),

//                           Container(
//                             width: 200,
//                             height: 200,
//                             child: Text(
//                               snap.data[0]['detectedClass'] +
//                                   ": " +
//                                   snap.data[0]['confidenceInClass'].toString(),
//                               style: TextStyle(fontSize: 18),
//                             ),
//                           ),
//                         ],
//                         // color:Colors.blueAccent
//                       );
//                     } else {
//                       return Container(color: Colors.black);
//                     }
//                     },)
//                   ],
//                 )
//                 : Container(
//                     color: Colors.black,
//                     width: 100,
//                     height: 100,
//                   )
//           ],
//         ),
//       ),
//     );
//   }
// }
