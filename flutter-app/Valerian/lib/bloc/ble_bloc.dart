import 'dart:async';
import 'dart:convert';

import 'package:flutter_blue/flutter_blue.dart';
import 'package:rxdart/rxdart.dart';

const String SERVICE_UUID = "4fafc201-1fb5-459e-8fcc-c5c9c331914b";
const String CHARACTERISTIC_UUID = "beb5483e-36e1-4688-b7f5-ea07361b26a8";
const String TARGET_DEVICE_NAME = "ESP32 Valarien Sight";
const List<String> SUPPORTED_BLE_CHARACTERISTIC = [WIFI_CHARACTERISTIC];
const String WIFI_CHARACTERISTIC = "beb5483e-36e1-4688-b7f5-ea07361b26a8";
enum BLE_Characteristic {
  WIFI_CONFIG,
  TEXT_NOTIFI,
  CALL_NOTIFI,
}

///
///[BLE_Bloc] some how singleton when re-conectiong back (user turn on | off) form Bluetooth
///the Future delay seem not working at all
///
class BLE_Bloc {
  Map<BLE_Characteristic, BluetoothCharacteristic> device_Characteristic;
  bool rescanflag = false;
  BluetoothDevice targetDevice;
  BluetoothCharacteristic targetCharacteristic; // List of char in ESP32
  StreamSubscription<ScanResult> _subscription;
  List<BluetoothService> ble_services;
  bool USER_TurnOffBLE = false;

  StreamController<BluetoothDeviceState> device_state =
      StreamController<BluetoothDeviceState>.broadcast();

  StreamController<String> ble_content = StreamController<String>.broadcast();
  // Stream<List<BluetoothService>> get stream_ble_services => ble_services.stream;
  Stream<bool> locate_device;
  FlutterBlue flutterBlue = FlutterBlue.instance;
  Stream<List<int>> ble_char_data;
  Stream<BluetoothDeviceState> deviceBLEState;
  Future<void> scanDevices() {
    flutterBlue.scan().listen((event) async {
      if (event.device.name == TARGET_DEVICE_NAME) {
        flutterBlue.stopScan();
        targetDevice = event.device;

        await targetDevice.connect(autoConnect: false);
        await Future.delayed(Duration(seconds: 2)); // Enjoy the animation ^^
        // if (rescanflag == false) {
        //   listenconected();
        // }
        discoverServices();

        // discoverServices(); 
      }
    });
  }

  ///
  /// [BLE_Bloc.dispose()]
  /// Implement when user turn on | off with a flag Hmm
  void dispose() {
    ble_services = null;
    targetDevice = null;
    flutterBlue?.stopScan();
    device_state.sink.add(BluetoothDeviceState.disconnected);
  }

  void decodeBLEData(List<int> bytes) {
    ble_content.sink.add(utf8.decode(bytes));
  }

  void writeTo(BluetoothCharacteristic characteristic, String content) async {
    await characteristic.write(utf8.encode(content));
  }

  // void listenconected() {
  //   rescanflag = true;
  //   if (targetDevice != null) {
  //     targetDevice.state.listen((event) {
  //       device_state.add(event);
  //       if (event == BluetoothDeviceState.disconnected) {
  //         scanDevices();
  //       }
  //     });
  //   }
  // }

  void discoverServices() {
    targetDevice.state.listen((event) async {
      if (event == BluetoothDeviceState.connected) {
        ble_services = await targetDevice.discoverServices();
        ble_services.forEach((element) {
          if (element.uuid.toString() == SERVICE_UUID) {
            element.characteristics.forEach((element) async {
              if (element.uuid.toString() == CHARACTERISTIC_UUID) {
                targetCharacteristic = element;
                await targetCharacteristic.setNotifyValue(true);
                ble_char_data = targetCharacteristic.value;
              }
            });
          }
        });
        device_state.add(BluetoothDeviceState.connected);
      } else if (event == BluetoothDeviceState.disconnected) {
        await targetDevice.disconnect();
        scanDevices();
      }
    });
  }

  writeData(String data) async {
    if (targetCharacteristic == null) return;

    List<int> bytes = utf8.encode(data);
    await targetCharacteristic.write(bytes);
  }

  // singleton boilplate
  static final BLE_Bloc _singleton = BLE_Bloc._internal();

  factory BLE_Bloc() {
    return _singleton;
  }

  BLE_Bloc._internal();
}
