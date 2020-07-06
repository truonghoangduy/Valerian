import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';


class BluetoothAdapterController{
  bool requestEnable; 

  Future<void> enableBluetooth() async{
    this.requestEnable  = await FlutterBluetoothSerial.instance.requestEnable();
    return this.requestEnable;
  }
}