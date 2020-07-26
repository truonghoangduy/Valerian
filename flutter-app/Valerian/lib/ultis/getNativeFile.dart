import 'dart:io';

import 'package:path_provider/path_provider.dart';
const PICTURE_FOLDER = "/app_images";
class GetFileFromNative{
  
  GetFileFromNative(){

  }

  // static bool checkPathExits(Directory path){
  //   if (path.ex) {
      
  //   }
  // }

  static Future<List<String>> getPicturePath() async{
    var rootPath = await getApplicationSupportDirectory();
    Directory pictureDirectory =  Directory(rootPath.parent.path + PICTURE_FOLDER);
    if (await pictureDirectory.exists()) {
      var data = await pictureDirectory.list(recursive: true, followLinks: true)
          .toList();
      return data.map((e) => e.path).toList();
    }else{
      return null;
    }




    

  }

}

    // List<String> temperPath = abc.split("/");
//   int indexAppName = temperPath.indexWhere((eachPath)=> eachPath.contains("Valerian")) +1;
//   print(temperPath.indexWhere((eachPath)=> eachPath.contains("Valerian")));
// //   temperPath[indexAppName] = "app_imgaes";
//   List<String> temperString = temperPath.map((path) => path=path+"/").toList();


    // var location = await getApplicationSupportDirectory();
    // var temperPathToImg = location.path.split("/");
    // temperPathToImg[temperPathToImg.indexOf("Valerian") + 1] = PICTURE_FOLDER;
    // temperPathToImg.map((e) => {
    //       if (e == "") {e = "/"}
    //     });
    // Directory directory = Directory("/data/user/0/com.example.Valerian/app_images/");
    // // for (var item in await location.list(recursive: true).toList()) {
    // //   // /data/user/0/com.example.Valerian/app_images/23-07-2020 13:31:00

    // //   print(item.path);
    // // }
    // if (await directory.exists()) {
    //   for (var item in await directory
    //       .list(recursive: true, followLinks: true)
    //       .toList()) {
    //     // /data/user/0/com.example.Valerian/app_images/23-07-2020 13:31:00
    //     print(item.path);
    //     imagePath.add(item.path);
    //   }
    // }