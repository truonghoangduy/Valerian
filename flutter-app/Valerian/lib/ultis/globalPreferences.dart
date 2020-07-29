import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as json;

class GlobalVarible{

  static final GlobalVarible _singleton = GlobalVarible._internal();

  factory GlobalVarible() {
    return _singleton;
  }
  GlobalVarible._internal();


  static const String APP_GLOBLE_VARIBLE = "appGlobalVarible";

  static Map<String,bool> appGlobalVarible = {
    "dection":false,
    "notification":false,
  };

  BluetoothState blue_state;
  Future<void> bluetoothState() async{
    blue_state = await FlutterBluetoothSerial.instance.state;
    print(blue_state);
  }


  SharedPreferences sharedpreferenceslib;

  Future<void> initLib() async{
    sharedpreferenceslib =  await SharedPreferences.getInstance();
  }

  Future<bool> initGobaleVarible() async{
    return await sharedpreferenceslib.setString(APP_GLOBLE_VARIBLE, json.jsonEncode(appGlobalVarible));
  }

  Map<String,dynamic> readGoble(){
    var data = this.sharedpreferenceslib.getString(APP_GLOBLE_VARIBLE);
    return json.json.decode(data);
  }

  Future<bool> replaceGloble(Map<String,bool> changedValue)async{
    return await this.sharedpreferenceslib.setString(APP_GLOBLE_VARIBLE, json.jsonEncode(changedValue));
  }

  // wirteString()

  bool checkAlreadyInitGobaleVarible(){
    var data = this.sharedpreferenceslib.getString(APP_GLOBLE_VARIBLE);
    if (data != null) {
      print(data);
      return true;
    }else{
      return false;
    }
  }

}