import 'package:Valerian/bloc/blue_serial.dart';
import 'package:Valerian/regconiction/regconiction.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;
import 'dart:typed_data';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'dart:async';

// import 'package:image/image.dart' as img;
class Detection extends StatefulWidget {
  @override
  _DetectionState createState() => _DetectionState();
}

class _DetectionState extends State<Detection> {
  Stream name;
  // Image;

  _DetectionState() {}
  @override
  Widget build(BuildContext context) {
    String path = "";

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              child: FutureBuilder<List<dynamic>>(
                  future: Recognition.objectDection_V1(path),
                  builder: (BuildContext context, snap) {
                    if (snap.data != null) {
                      print(snap.data);
                      return Column(
                        children: <Widget>[
                          // Image.network(path),
                          Image.memory(Recognition.temper),

                          Container(
                            width: 200,
                            height: 200,
                            child: Text(
                              snap.data[0]['detectedClass'] +
                                  ": " +
                                  snap.data[0]['confidenceInClass'].toString(),
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ],
                        // color:Colors.blueAccent
                      );
                    } else {
                      return Container(color: Colors.black);
                    }
                  }),
            ),
            FloatingActionButton(
              onPressed: () => {setState(() {})},
              child: Icon(Icons.camera),
            ),
          ],
        ),
      ),
    );
  }
}

class BLuetoothDiscover extends StatefulWidget {
  @override
  _BLuetoothDiscoverState createState() => _BLuetoothDiscoverState();
}

class _BLuetoothDiscoverState extends State<BLuetoothDiscover> {
  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;
  BluetoothBloc _bluetoothBloc;
  Recognition recognition;
  bool captured = false;
  _BLuetoothDiscoverState() {
    this._bluetoothBloc = new BluetoothBloc();
    this.recognition = new Recognition();
  }
  final FlareActor ble_scaning = FlareActor(
    "assets/images/Bluetooth Scan.flr",
    isPaused: false,
    snapToEnd: false,
    fit: BoxFit.scaleDown,
    animation: "Untitled",
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
              child: Column(
          children: <Widget>[
            SwitchListTile(
              title: Text('Enable Bluetooth'),
              value: _bluetoothState.isEnabled,
              onChanged: (bool value) async {
                if (value) {
                  await FlutterBluetoothSerial.instance.requestEnable();
                  var vaule = await FlutterBluetoothSerial.instance.isAvailable;
                  print(vaule);
                } else {
                  await FlutterBluetoothSerial.instance.requestDisable();
                }
              },
            ),
            // StreamBuilder<BluetoothDiscoveryResult>(
            //   stream: FlutterBluetoothSerial.instance.startDiscovery(),
            //   builder: (BuildContext context,AsyncSnapshot<BluetoothDiscoveryResult> snapshot){
            //     if (snapshot.hasData && snapshot.data.device.address !=null && snapshot.data.device.name == BOARD_NAME) {
            //       if (snapshot.data.device.name == BOARD_NAME) {
            //         print("Find Ya");
            //         return Container(
            //         color: Colors.yellowAccent,
            //         width: 100,
            //         height: 100,
            //         child:Text(snapshot.data.device.name!=null?snapshot.data.device.name:snapshot.data.device.address),

            //       );
            //       }

            //     }else{
            //       return Container(
            //         color: Colors.blueAccent,
            //         width: 100,
            //         height: 100,
            //       );
            //     }
            // })
            FutureBuilder<bool>(
                future: this._bluetoothBloc.scanDevices(),
                initialData: false,
                builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                  if (snapshot.data == true) {
                    return Container(
                      color: Colors.blueAccent,
                      width: 100,
                      height: 100,
                      // child: Text(this._bluetoothBloc.device.name),
                    );
                  }
                  return Container(
                    width: 200,
                    height: 200,
                    color: Colors.black38,
                    // child: ble_scaning,
                  );
                }),
            FloatingActionButton(
              onPressed: () async {
                if (await this._bluetoothBloc.connectToDevice()) {
                  print("Connected");
                }
              },
              isExtended: true,
              backgroundColor:Colors.redAccent,

              child:
                Text("Connecting"),
            ),
            FloatingActionButton(
              child: Container(
                color: Colors.greenAccent,
                child: Text("Capture"),
              ),
              onPressed: () async{
               await this._bluetoothBloc.sending();
            }),
            FloatingActionButton(
              // child: ,

              onPressed: () => {
                setState(() {
                  this.captured = true;
                })
              },
              backgroundColor: Colors.yellow,
            ),

            this.captured
                ? Image.memory(
                    // Uint8List.fromList(this._bluetoothBloc.image)
                    this._bluetoothBloc.pictureformBuffer)
                : Container(
                    color: Colors.black,
                    width: 100,
                    height: 100,
                  )
          ],
        ),
      ),
    );
  }
}
