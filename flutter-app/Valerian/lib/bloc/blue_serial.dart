import 'dart:typed_data';
// import 'dart:typed_data';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'dart:async';
import 'dart:convert';

const BOARD_NAME = "Valerian-Sight";

class BluetoothBloc {
  BluetoothConnection connection;
  BluetoothDevice device; // bounded devices
  List<int> image = new List<int>();
  List<List<int>> chunks = <List<int>>[];
  int contentLength = 0;
  Uint8List _bytes;

  StreamController<int> _pictureController =
      new StreamController<int>.broadcast();
  // _pictureController.

  BluetoothBloc() {
    // _pictureController.stream.listen((event) {
    //   print("Stream listenner");
    //   print(event);
    // });
  }
  Future<bool> connectToDevice() async {
    // BluetoothConnection.toAddress(device.address).then((value) => {
    //       print("Connected"),
    //       this.connection = value,
    //       this.connection.input.listen((listenCallBack)).onDone(() {
    //         print("Done Reviced");
    //       })
    //     });
    //"FC:F5:C4:2F:EF:FA"
    // connection = await BluetoothConnection.toAddress(device.address);
    connection = await BluetoothConnection.toAddress("FC:F5:C4:2F:EF:FA");

    if (connection != null) {
      connection.input.listen((onData) {
        this.listenCallBack(onData);
      }).onDone(() {
        print("Done Sending");
      });
      return true;
    }
    return false;
  }

  void listenCallBack(Uint8List data) {
    if (data != null && data.length > 0) {
      // print('Reviced : ${data.length} Chunk ${this.chunk.toString()}');
      // this.image.addAll(data.buffer.asUint8List());
      // //  event.buffer.asUint8List();
      // this.chunk++;
      chunks.add(data);
      contentLength += data.length;
      // _timer.reset();
    }
    // Couting chunk sended
    print(
        'Reviced : ${data.length} Chunk ${this.chunks.length} Content lenght ${contentLength}');
    if (this.chunks.length > 25) {
      // _pictureController.add(this.chunks.length);
    }
  }

  openAndroidSessting() {
    FlutterBluetoothSerial.instance.openSettings();
  }

  Uint8List get pictureformBuffer {
    // if (this.chunks.length < 20) {
    //   this.sending();
    // }
    _drawImage();
    return _bytes;
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

  findBoundedDevice() {
    FlutterBluetoothSerial.instance.getBondedDevices().then((devices) => {
          devices.forEach((element) {
            if (element.name == BOARD_NAME) {
              this.device = element;
            }
          })
        });
  }

  sending() async {
    // if (pictureformBuffer.length > 0) {
    //       pictureformBuffer

    // }
    if (this.connection == null) {
      print("Not Connected");
    }
    this.connection.output.add(utf8.encode("1"));
    await connection.output.allSent;
  }

  Future<bool> scanDevices() async {
    // return true;

    var scaning = FlutterBluetoothSerial.instance.startDiscovery();
    BluetoothDiscoveryResult scanResult = await scaning
        .firstWhere((element) => element.device.name == BOARD_NAME);
    if (scanResult != null) {
      // await Future.delayed(Duration(seconds: 2));
      this.device = scanResult.device;

      return true;
    } else {
      return false;
    }
  }
}
