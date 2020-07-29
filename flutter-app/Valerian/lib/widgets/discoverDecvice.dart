import 'package:Valerian/bloc/blue_serial.dart';
import 'package:Valerian/main.dart';
import 'package:Valerian/regconiction/regconiction.dart';
import 'package:Valerian/ultis/appEnum.dart';
import 'package:Valerian/ultis/appRoute.dart';
import 'package:Valerian/widgets/bluetoothOff.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class BLuetoothDiscoverDevice extends StatefulWidget {
  @override
  _BLuetoothDiscoverDeviceState createState() =>
      _BLuetoothDiscoverDeviceState();
}

class _BLuetoothDiscoverDeviceState extends State<BLuetoothDiscoverDevice> {
  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;
  BluetoothBloc _bluetoothBloc;
  Recognition recognition;
  bool captured = false;

  _BLuetoothDiscoverDeviceState() {
    this._bluetoothBloc = new BluetoothBloc();
    this.recognition = new Recognition();
  }
  static const FlareActor ble_scaning = FlareActor(
    "assets/images/Bluetooth Scan.flr",
    isPaused: false,
    snapToEnd: false,
    fit: BoxFit.scaleDown,
    animation: "Untitled",
  );

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    // FlutterBluetoothSerial.instance.disconnect();
    // this._bluetoothBloc.cleenUpResoruce();
  }
  @override
  Widget build(BuildContext context) {
    // Future.delayed(Duration(seconds: 1),
    //     () => {
          this._bluetoothBloc.scanFlag.add(BLUETOOTH_SCAN_STATE.RE_SCAN);
          // });

    // Future.delayed(
    //     Duration(seconds: 3),
    //     () => {
    //           this._bluetoothBloc.scanFlag.add(BLUETOOTH_SCAN_STATE.OK_FOUNDED)
    //         });
    Size mediaQuery = MediaQuery.of(context).size;
    var futureBuilder =
        // RESCAN METHOD
        Container(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: <Widget>[
          ble_scaning,
          Align(
            alignment: Alignment.center,
            child: StreamBuilder<BLUETOOTH_SCAN_STATE>(
                stream: this._bluetoothBloc.scanFlag.stream,
                // initialData: BLUETOOTH_SCAN_STATE.RE_SCAN,
                // initialData: false,
                builder: (BuildContext context,
                    AsyncSnapshot<BLUETOOTH_SCAN_STATE> snapshot) {
                  if (snapshot.data == BLUETOOTH_SCAN_STATE.OK_FOUNDED) {
                    // FOUNDED DEVICE
                    return Container(
                      // color: Colors.blueAccent,
                      width: mediaQuery.width * 0.7,
                      height: mediaQuery.height * 0.4,
                      child: Stack(
                        children: <Widget>[
                          Align(
                            alignment: Alignment.topLeft,
                            child: Container(
                              color: Colors.black,
                              width: 50,
                              height: 50,
                              margin: EdgeInsets.only(
                                top: mediaQuery.height * 0.2,
                              ),
                            ),
                          ),
                          Align(
                              alignment: Alignment.topRight,
                              child: Container(
                                color: Colors.red,
                                margin: EdgeInsets.only(
                                    top: mediaQuery.height * 0.05,
                                    right: mediaQuery.width * 0.1),
                                width: 50,
                                height: 50,
                              ))
                        ],
                      ),
                      // child: Text(this._bluetoothBloc.device.name),
                    );
                  }
                  return Container();
                }),
          )
        ],
      ),
    );
    return Scaffold(
      // appBar: AppBar(),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          // color: Colors.blueAccent,
          child: Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.center,
                child: futureBuilder,
              ),
              StreamBuilder<BLUETOOTH_SCAN_STATE>(
                stream: this._bluetoothBloc.scanFlag.stream,
                // initialData: BLUETOOTH_SCAN_STATE.RE_SCAN,
                builder: (BuildContext context,
                    AsyncSnapshot<BLUETOOTH_SCAN_STATE> snapshot) {
                  if (snapshot.data == BLUETOOTH_SCAN_STATE.OK_FOUNDED) {
                    return Align(
                      alignment: Alignment.center,
                      child: Container(
                          width: mediaQuery.width * 0.6,
                          height: mediaQuery.height * 0.08,
                          margin: EdgeInsets.only(top: mediaQuery.height * 0.6),
                          child: RaisedButton(
                            onPressed: () async {
                              if (await this._bluetoothBloc.connectToDevice()) {
                                await this._bluetoothBloc.cleenUpResoruce();
                                print("Paring went OK");
                                await Navigator.popAndPushNamed(context, AppRouting.homePage);

                              }
                            },
                            color: Colors.white,
                            child: Text(
                              "Connect To Decvice".toUpperCase(),
                              style: TextStyle(
                                  fontSize: mediaQuery.width * 0.05,
                                  fontWeight: FontWeight.bold),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          )),
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
