import 'dart:ffi';
import 'dart:typed_data';
// import 'dart:typed_data';
import 'package:Valerian/bloc/blue_serial_v2.dart';
import 'package:Valerian/regconiction/regconiction.dart';
import 'package:Valerian/ultis/appEnum.dart';
import 'package:Valerian/ultis/bluetooth_exception.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'dart:async';
import 'dart:convert';
import 'package:async/async.dart';
import 'package:rxdart/subjects.dart';

const BOARD_NAME_SIGHT = "Valerian-Sight";
const BOARD_NAME_DISPLAY = "Valerian-Display-Test01";
const DEVICE_DEBUG = 2;
// enum BLUETOOTHFUNCTIONALITY {
const NOTIFICATION = 0;
const TEXT = 1; // Normal String
const DECTION = 2; // Encoding for sendback object dection

// }
class BluetoothBloc {
  BluetoothConnection connectionSight; // Connection BOARD INFO
  BluetoothConnection connectionDisplay;

  BluetoothDevice device; // bounded devices

  BluetoothDevice deviceSight;
  BluetoothDevice deviceDisplay;

  Recognition recognition = Recognition();

  List<int> image = new List<int>();
  List<List<int>> chunks = <List<int>>[];
  int contentLength = 0;
  Uint8List _bytes;
  RestartableTimer _timer;
  RestartableTimer _timer2;
  String imageBufferLenght;

  StreamController<int> _pictureController =
      new StreamController<int>.broadcast();
  // _pictureController.
  bool turnOnFristTimeFlag = false;
  BluetoothBloc() {
    // scanLoopForDevices();
    // _pictureController.stream.listen((event) {
    //   print("Stream listenner");
    //   print(event);
    // });
    _timer2 = new RestartableTimer(Duration(seconds: 1), () => {print("TICK")});
    this.listForScanFlagV1();
  }

  void handleImageCallBack(Uint8List data) {
    if (data.length == 1 && data.first == 255) {
      print("Error TAG");
    }
    // TODO implement listen form DISPLAY Device not form frist time flag
    if (this.turnOnFristTimeFlag == false) {
      _timer =
          new RestartableTimer(Duration(seconds: 2), () => {this._drawImage()});
      this.turnOnFristTimeFlag = true;
    }
    this.listenIMAGECallBack(data);
  }

  void functionalitySwitch(int opCode, String message) {
    switch (opCode) {
      case DECTION:
        // Call 1 -> CAMERA - > GRABED - > TENSORFLOW
        this.turnOnFristTimeFlag = false;
        this.invokeCAMERA();
        break;
      default:
    }
  }

  void handleDisplayCallBack(Uint8List data) {
    // Command controller
    String message = utf8.decode(data);
    functionalitySwitch(int.parse(message[0]), message); // Blank data for now
  }

  Future<void> cleenUpResoruce({String devicename}) async {
    if (devicename == BOARD_NAME_SIGHT) {
      await connectionSight.close();
      connectionSight?.dispose();
    }
    if (devicename == BOARD_NAME_DISPLAY) {
      await connectionSight.close();
      connectionDisplay?.dispose();
    }
  }

  Future<bool> connectToDevice() async {
    int connectingState = 0;
    connectionSight = await BluetoothConnection.toAddress(
        deviceSight.address); //BOARD_NAME_SIGHT
    connectionDisplay = await BluetoothConnection.toAddress(
        deviceDisplay.address); //BOARD_NAME_DISPLAY
    if (connectionSight != null) {
      //   connectionSight.input.listen(handleImageCallBack).onDone(() {
      //     print("LOST Connection TO : " + BOARD_NAME_SIGHT);
      //     cleenUpResoruce(BOARD_NAME_SIGHT);
      //     this.scanFlag.sink.add(BLUETOOTH_SCAN_STATE.RE_SCAN);
      //   });
      connectingState++;
    }
    if (connectionDisplay != null) {
      //   connectionDisplay.input.listen(handleDisplayCallBack).onDone(() {
      //     print("LOST Connection TO : " + BOARD_NAME_DISPLAY);
      //     cleenUpResoruce(BOARD_NAME_DISPLAY);
      //     this.scanFlag.sink.add(BLUETOOTH_SCAN_STATE.RE_SCAN);
      //   });
      connectingState++;
    }
    if (connectingState >= DEVICE_DEBUG) {
      return true;
    }
    return false;
  }

  void listenIMAGECallBack(Uint8List data) {
    if (data != null && data.length > 0) {
      // print('Reviced : ${data.length} Chunk ${this.chunk.toString()}');
      // this.image.addAll(data.buffer.asUint8List());
      // //  event.buffer.asUint8List();
      // this.chunk++;
      chunks.add(data);
      contentLength += data.length;
      this._timer.reset();

      // _timer.reset();
    }
    // Couting chunk sended
    print(
        'Reviced : ${data.length} Chunk ${this.chunks.length} Content lenght ${this.contentLength}');
  }

  openAndroidSessting() {
    FlutterBluetoothSerial.instance.openSettings();
  }

  Uint8List get pictureformBuffer {
    // if (this.chunks.length < 20) {
    //   this.sending();
    // }
    // _drawImage();
    return _bytes;
  }

  _drawImage() {
    // Concat Byte to Unint8List
    print("Call Draw");
    if (this.chunks.length != null) {
      if (this.chunks.length == 0 || contentLength == 0) return;

      _bytes = Uint8List(contentLength);
      int offset = 0;
      for (final List<int> chunk in chunks) {
        _bytes.setRange(offset, offset + chunk.length, chunk);
        offset += chunk.length;
      }
      contentLength = 0;
      chunks.clear();
      print("Done Draw");
    } else {
      this.turnOnFristTimeFlag = false;
      print("Dont Draw");
      // Clear bytes
      contentLength = 0;
      chunks.clear();
      this.invokeCAMERA();
    }
  }

  Future<bool> findBoundedDevice() async {
    int deviceCounter = 0;
    var boundedDevices =
        await FlutterBluetoothSerial.instance.getBondedDevices();
    boundedDevices.forEach((element) {
      if (element.name == BOARD_NAME_DISPLAY) {
        this.deviceDisplay = element;
        deviceCounter++;
      }
      if (element.name == BOARD_NAME_SIGHT) {
        this.deviceSight = element;
        deviceCounter++;
      }
    });
    return deviceCounter == DEVICE_DEBUG ? true : false;
  }

  void sendingToDisplay(String opCode, String message) async {
    if (this.connectionDisplay == null) {
      print("Not Connected to " + BOARD_NAME_DISPLAY);
    }
    this.connectionDisplay.output.add(utf8.encode(opCode + message + "\r\n"));
  }

  bool jpegBitCheck() {
    if (this._bytes.last != 217 &&
        this._bytes.elementAt(this._bytes.length - 2) != 255) {
      print("Missing JPEG EOI");
      // imgBytes.addAll([255,217]);
      // newIamge = new Uint8List.fromList([...imgBytes, ...JPEG_EOI]);
      return true;
    }
    return false;
  }

  void invokeCAMERA({String cameraPixel = "0"}) async {
    print("Invoke Camera");
    // choose your pixel
    this.connectionSight.output.add(utf8.encode(cameraPixel));
    await this.connectionSight.output.allSent;
  }

  bool checkDevies_SCAN() {
    if (deviceSight != null && deviceSight != null) {
      return true;
    }
    return false;
  }

  StreamSubscription<BluetoothDiscoveryResult> scaningSubscripption;
  StreamConsumer test00;
  scanLoopForDevices() async {
    int deviceCounter = 0;
    var scaning = FlutterBluetoothSerial.instance.startDiscovery();
    // this.scaningSubscripption.onDone(() {
    //    print("object"); });
    this.scaningSubscripption = scaning.listen((element) {
      print(element.device.name != null
          ? element.device.name
          : element.device.address);
      if (element.device.name != null) {
        if (element.device.name == BOARD_NAME_SIGHT) {
          this.deviceSight = element.device;
          deviceCounter++;
        }
        if (element.device.name == BOARD_NAME_DISPLAY) {
          this.deviceDisplay = element.device;
          deviceCounter++;
        }
      }
      if (deviceCounter == 4) {
        this.scaningSubscripption.cancel();
      }
      print(deviceCounter);
    });

    this.scaningSubscripption.onDone(() async {
      if (deviceCounter == 3) {
        print("Found Total Devoices");
      } else {
        await this.scanDevices();
      }
    });
  }

  BehaviorSubject<BLUETOOTH_SCAN_STATE> scanFlag =
      new BehaviorSubject<BLUETOOTH_SCAN_STATE>();
  int deviceCounter = 0;

  listForScanFlagV1() {
    this.scanFlag.stream.listen((event) async {
      print(event);
      if (event == BLUETOOTH_SCAN_STATE.RE_SCAN) {
        this.scanDevicesV1();
      } else if (event == BLUETOOTH_SCAN_STATE.STOP_SCAN) {
        print("STOP SCANING");
        await this.scaningSubscripption?.pause();
        await FlutterBluetoothSerial.instance.cancelDiscovery();
      }
      if (event == BLUETOOTH_SCAN_STATE.OK_FOUNDED) {
        print("OK FOUNDED");
      }
    });
  }

  bool deviceScanFilter() {
    deviceCounter = 0;
    if (this.deviceDisplay?.address != null) {
      deviceCounter++;
    }
    if (this.deviceSight?.address != null) {
      deviceCounter++;
    }
    if (deviceCounter == DEVICE_DEBUG) {
      return true;
    }
    return false;
  }

  scanDevicesV1() async {
    print("ReScan");
    // // return true;
    var scaning = FlutterBluetoothSerial.instance.startDiscovery();
    this.scaningSubscripption = scaning.listen((element) async {
      print(element.device.name != null
          ? element.device.name
          : element.device.address);
      if (element.device.name != null) {
        if (element.device.name == BOARD_NAME_SIGHT) {
          this.deviceSight = element.device;
          deviceCounter++;
        }
        if (element.device.name == BOARD_NAME_DISPLAY) {
          this.deviceDisplay = element.device;
          deviceCounter++;
        }
      }
      print('Match Counter ${deviceCounter.toString()}');
      if (this.deviceScanFilter()) {
        print("Find Total Devices");
        await FlutterBluetoothSerial.instance.cancelDiscovery();
      }
    });
    this.scaningSubscripption.onDone(() async {
      print("Stop Scanning");
      if (this.deviceScanFilter()) {
        print("Found Total Devoices");
        if (
            // await this.connectToDevice()
            true) {
        } else {
          throw BluetoothException(message: "Cannot Connect To DEVICES");
        }
        // TO DO Implement for each Devices lost connection
        // SECTION FOR CONNECT TO DEVICE

        this.scanFlag.sink.add(BLUETOOTH_SCAN_STATE.OK_FOUNDED);
      } else {
        await FlutterBluetoothSerial.instance.cancelDiscovery();
        this.scanFlag.sink.add(BLUETOOTH_SCAN_STATE.RE_SCAN);
      }
    });
  }

  Future<bool> scanDevices() async {
    return false;
    // var scaning = FlutterBluetoothSerial.instance.startDiscovery();
    // // this.scaningSubscripption.onDone(() {
    // //    print("object"); });
    // this.scaningSubscripption = scaning.listen((element) {
    //   print(element.device.name != null
    //       ? element.device.name
    //       : element.device.address);
    //   if (element.device.name != null) {
    //     if (element.device.name == BOARD_NAME_SIGHT) {
    //       this.deviceSight = element.device;
    //       deviceCounter++;
    //     }
    //     if (element.device.name == BOARD_NAME_DISPLAY) {
    //       this.deviceDisplay = element.device;
    //       deviceCounter++;
    //     }
    //   }
    //   if (deviceCounter == 4) {
    //     this.scaningSubscripption.cancel();
    //   }
    //   print(deviceCounter);
    // });

    // this.scaningSubscripption.onDone(() async {
    //   if (deviceCounter == 3) {
    //     print("Found Total Devoices");
    //   } else {
    //     this.scanFlag.add(true);
    //   }
    // });

    // // Lib automatomaticly close the Stream
    // // await scaning.forEach((element) {
    // //   if (element.device.name == BOARD_NAME_SIGHT) {
    // //     this.deviceSight = element.device;
    // //     deviceCounter++;
    // //   }
    // //   if (element.device.name == BOARD_NAME_DISPLAY) {
    // //     this.deviceDisplay = element.device;
    // //     deviceCounter++;
    // //   }
    // // });

    // // BluetoothDiscoveryResult scanResult = await scaning
    // // //     .firstWhere((element) => element.device.name == BOARD_NAME_SIGHT);
    // // this.deviceSight = scanResult.device;
    // if (deviceCounter >= DEVICE_DEBUG) {
    //   // await Future.delayed(Duration(seconds: 2)); // UI THINGSYYY
    //   return true;
    // } else {
    //   return false;
    // }
    // return true;
  }

  establishConnectionToDevice(String deviceName) {}

  Future<BluetoothDevice> scanDeviceWithName(String deviceName) async {
    try {
      var discoveryResult = await FlutterBluetoothSerial.instance
          .startDiscovery()
          .firstWhere((element) => element.device.name == deviceName);
      return discoveryResult.device;
    } catch (e) {
      print(e);
      return null;
    }
  }
}

// BluetoothDiscoveryResult scanResult = await scaning
//     .firstWhere((element) => element.device.name == BOARD_NAME_SIGHT);
