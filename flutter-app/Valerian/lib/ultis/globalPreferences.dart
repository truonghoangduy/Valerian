import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as json;

class GlobalVarible{

  static const APP_GLOBLE_VARIBLE = "appGlobalVarible";

  static Map<String,bool> appGlobalVarible = {
    "dection":false,
    "notification":false,
  };


  static SharedPreferences sharedpreferenceslib;

  static Future<void> initLib() async{
    sharedpreferenceslib =  await SharedPreferences.getInstance();
  }

  static Future<bool> initGobaleVarible() async{
    return await sharedpreferenceslib.setString(APP_GLOBLE_VARIBLE, json.jsonEncode(appGlobalVarible));
  }

  static bool checkAlreadyInitGobaleVarible(){
    var data =  sharedpreferenceslib.getString(APP_GLOBLE_VARIBLE);
    if (data != null) {
      print(data);
      return true;
    }else{
      return false;
    }
  }

}