import 'dart:typed_data';

import 'package:Valerian/ultis/bluetooth_exception.dart';
import 'package:Valerian/regconiction/regconiction.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:async/async.dart';

enum BluetoothFunctionality {
  NOTIFICATION,
  TEXT, // Normal String
  PICTURE // Encoding for sendback object dection
}
const IMAGE_ACCEPTED_CHUNK = 30;
const BOARD_NAME = "Valerian-Sight";

class BluetoothProvider {
  // Bluetooth prop
  BluetoothConnection connection; // Class to send and recive data form Bluetooth devices
  BluetoothDevice device;
  Recognition recognition = Recognition();
  // Data 
  List<List<int>> chunks = <List<int>>[];
  List<dynamic> detectionResult = new List();
  Uint8List _bytes;
  get chunkLenght => chunks.length;
  int contentLength = 0;
  RestartableTimer timer;

  void sendCommand(){
    
  }

  void setupTimerCaller(){
    this.timer = new RestartableTimer(Duration(seconds: 1),()=>{
      callTensorFlow(),
    });
  }

  void callTensorFlow(){
    if (chunkLenght > IMAGE_ACCEPTED_CHUNK) {
      // Call Tensorflow
      _drawImage();
      Recognition.objectDection_V2_BlueSerial(this._bytes);
    }else{
      return;
    }
  }

  void bluetoothCallBack(Uint8List data){
    if (data != null && data.length > 0) {
      this.timer.reset();
      chunks.add(data);
      contentLength += data.length;
      // _timer.reset();
    }
  }

  _drawImage() {
    if (this.chunks.length == 0 || contentLength == 0) return;

    _bytes = Uint8List(contentLength);
    int offset = 0;
    for (final List<int> chunk in chunks) {
      _bytes.setRange(offset, offset + chunk.length, chunk);
      offset += chunk.length;
    }
    contentLength = 0;
    chunks.clear();
  }

  Future<bool> connetToDevice() async {
    this.connection = await BluetoothConnection.toAddress(device.address);
    if (this.connection.isConnected) {
      this.connection.input.listen((event) {
        this.bluetoothCallBack(event);
       });
      return true;
    }else{
      throw BluetoothException(message: "Unable to Connect To board");
      return false;
    }
  }

  Future<bool> scanDevices() async {
    var scaning = FlutterBluetoothSerial.instance.startDiscovery();
    BluetoothDiscoveryResult scanResult = await scaning
        .firstWhere((element) => element.device.name == BOARD_NAME);
    if (scanResult != null) {
      // await Future.delayed(Duration(seconds: 2));
      this.device = scanResult.device;
      if (await connetToDevice()) {
        print("Connected to BOARD");
      }
      return true;
    } else {
      throw BluetoothException(message: "Unable to found BOARD");
      return false;
    }
  }
}
