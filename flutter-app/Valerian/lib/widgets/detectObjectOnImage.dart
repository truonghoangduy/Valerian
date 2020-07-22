import 'dart:ffi';

import 'package:Valerian/bloc/blue_serial.dart';
import 'package:Valerian/regconiction/regconiction.dart';
import 'package:Valerian/ultis/appEnum.dart';
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
    String path = "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcRaXQvw-ZZQOpY1h-wC5hYRvodgyz5iLTXo8FgyQAZjgUjEXA1k&usqp=CAU";

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
            FloatingActionButton(
              backgroundColor: Colors.green,
              child: Text("Rescan"),
              onPressed: (){
                _bluetoothBloc.scanFlag.add(BLUETOOTH_SCAN_STATE.RE_SCAN);
              }),

              FloatingActionButton(
              backgroundColor: Colors.red,
              child: Text("STOP SACAN"),
              onPressed: (){
                _bluetoothBloc.scanFlag.add(BLUETOOTH_SCAN_STATE.STOP_SCAN);
              }),
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
                    child: ble_scaning,
                  );
                }),

            FloatingActionButton(onPressed: ()=>{
              this._bluetoothBloc.scanLoopForDevices()
            },),
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
               await this._bluetoothBloc.invokeCAMERA();
            }),
            FloatingActionButton(
              // child: ,

              onPressed: () => {
                setState(() {
                  this.captured = !this.captured;
                })
              },
              backgroundColor: Colors.yellow,
            ),

            this.captured
                ? Column(
                  children: <Widget>[
                    Image.memory(
                        // Uint8List.fromList(this._bluetoothBloc.image)
                        this._bluetoothBloc.pictureformBuffer),
                    FutureBuilder<List<dynamic>>(
                      future:Recognition.objectDection_V2_BlueSerial(this._bluetoothBloc.pictureformBuffer),
                      builder: (context,snap){
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
                    },)
                  ],
                )
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
