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

  


  SharedPreferences sharedpreferenceslib;

  Future<void> initLib() async{
    sharedpreferenceslib =  await SharedPreferences.getInstance();
  }

  Future<bool> initGobaleVarible() async{
    return await sharedpreferenceslib.setString(APP_GLOBLE_VARIBLE, json.jsonEncode(appGlobalVarible));
  }

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