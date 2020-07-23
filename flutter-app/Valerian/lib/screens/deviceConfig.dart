
import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;
import 'package:Valerian/screens/photo_library.dart';
import 'package:Valerian/ultis/globalPreferences.dart';
import 'package:flutter/material.dart';
import 'package:clay_containers/clay_containers.dart';
import 'package:foreground_service/foreground_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as img;

class DeviceScrren extends StatefulWidget {
  @override
  _DeviceScrrenState createState() => _DeviceScrrenState();
}

class _DeviceScrrenState extends State<DeviceScrren> {
  final Map<String, Map<bool, IconData>> uiIcon = {
    '0': {true: Icons.center_focus_strong, false: Icons.center_focus_weak},
    '2': {false: Icons.notifications_none, true: Icons.notifications_active}
  };

  Map<String, bool> localPersistentData = new Map();

  _DeviceScrrenState() {
    localPersistentData = GlobalVarible().readGoble().cast<String, bool>();
  }
  String sestingSwicth(String codex) {
    String encodeString = "";
    switch (codex) {
      case '0':
        encodeString = "dection";
        break;
      case '2':
        encodeString = "notification";
        break;
      default:
    }
    return encodeString;
  }

  String getButtonTitle(String codex) {
    String encodeString = "";
    switch (codex) {
      case '0':
        encodeString = "Picture Dection";
        break;
      case '2':
        encodeString = "Notification";
        break;
      default:
    }
    return encodeString;
  }

  Future<void> toggleButton(String inCode) async {
    Map<String, bool> persitionData =
        GlobalVarible().readGoble().cast<String, bool>();
    bool temperData = persitionData[this.sestingSwicth(inCode)];
    temperData = !temperData;
    persitionData[this.sestingSwicth(inCode)] = temperData;
    if (await GlobalVarible().replaceGloble(persitionData)) {
      Map<String, bool> newestpersitionData =
          GlobalVarible().readGoble().cast<String, bool>();
      localPersistentData = newestpersitionData;
      print(newestpersitionData);
    }


  }

  String pressed;
  @override
  Widget build(BuildContext context) {
    Size queryData = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      height: queryData.height,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
              // color: Colors.yellowAccent,
              width: queryData.width * 0.4,
              height: queryData.height,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ...uiIcon.keys.map((e) => GestureDetector(
                            onDoubleTap: () async => {
                                  await toggleButton(e),
                                  // FlutterBluetoothSerial.instance.cancelDiscovery(),
                                  // await FlutterBluetoothSerial.instance.disconnect(),
                                  // FlutterBluetoothSerial.instance.
                                  // FlutterBluetoothSerial.instance.
                                  // wifiDialog(context);
                                  print("OK"),
                                  await ForegroundService.start(
                                    title: 'Valerain',
                                    text: 'Background Ground Processing',
                                    subText: 'Do not close',
                                    ticker: 'Ticker',
                                  ),

                                  print("Done"),

                                  setState(() {
                                    // this.pressed = e;
                                  }),
                                },
                            child: ClayContainer(
                                width: queryData.width * 0.3,
                                height: queryData.height * 0.15,
                                child: Center(
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Icon(
                                          uiIcon[e][this.localPersistentData[
                                              this.sestingSwicth(e)]],
                                          size: 30,
                                          color: this.localPersistentData[
                                                  this.sestingSwicth(e)]
                                              ? Colors.blueAccent
                                              : Colors.black,
                                        ),
                                        Text(
                                          getButtonTitle(e),
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ]),
                                )))
                        // ...[1, 2, 3].map((e) => GestureDetector(
                        //   onDoubleTap: ()=>{

                        //     setState(() {
                        //       this.pressed = e;
                        //     })
                        //   },
                        //                       child: ClayContainer(
                        //       width: queryData.width * 0.3,
                        //       height: queryData.height * 0.15,
                        //       child: Icon(
                        //         Icons.wifi,
                        //         size: 45,
                        //         color: e==this.pressed?Colors.blueAccent:Colors.black,
                        //       )
                        //       // FlareActor("assets/images/Success Check.flr",
                        //       // animation: "Untitled",),
                        //       ),
                        // )),
                        // StreamBuilder(
                        //     stream: _ble_bloc.ble_char_data,
                        //     builder: (context, snapshot) {
                        //       if (!snapshot.hasData) {
                        //         return Container();
                        //       } else {
                        //         print(utf8.decode(snapshot.data));
                        //         return Text(utf8.decode(snapshot.data),
                        //             style: TextStyle(
                        //               color: Colors.blueAccent
                        //               ));
                        //       }
                        //     }),
                        ),
                    GestureDetector(
                      onDoubleTap: () => {
                        Navigator.push(context, MaterialPageRoute(
                                  builder: (context) => PhotoViewFromDevice(),
                                ))
                      },
                      child: ClayContainer(
                          width: queryData.width * 0.3,
                          height: queryData.height * 0.15,
                          child: Center(
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(
                                    Icons.photo_library,
                                    size: 30,
                                    // color: this.localPersistentData[
                                    //         this.sestingSwicth(e)]
                                    //     ? Colors.blueAccent
                                    //     : Colors.black,
                                  ),
                                  Text(
                                    "Galarey",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                ]),
                          )),
                    )
                  ])),
          Container(
            // color: Colors.black45,
            width: queryData.width * 0.6,
            height: queryData.height,
            child: Center(
              child: ClayContainer(
                width: queryData.width * 0.6,
                height: queryData.height * 0.65,
                depth: 10,
                spread: 10,
                borderRadius: 15,
                child: Center(
                    child: Transform.rotate(
                  angle: -math.pi / 4,
                  child: Image.asset("assets/images/concept_image.png"),
                )),
              ),
            ),
          )
        ],
      ),
    );
  }
}

  // <application
  //       android:name="io.flutter.app.FlutterApplication"
  //       android:label="Valerian"
  //       android:icon="@mipmap/ic_launcher"
  //       tools:node="replace">

//   dependencies {
//     implementation "org.jetbrains.kotlin:kotlin-stdlib-jdk7:$kotlin_version"
//     implementation('com.journeyapps:zxing-android-embedded:3.6.0') { transitive = false }
// }

// <manifest xmlns:android="http://schemas.android.com/apk/res/android"
//     package="com.example.Valerian"
//     xmlns:tools="http://schemas.android.com/tools">