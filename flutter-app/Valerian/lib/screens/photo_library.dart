import 'dart:io';
import 'package:Valerian/ultis/getNativeFile.dart';
import 'package:Valerian/widgets/enlargePicture.dart';
import 'package:auto_animated/auto_animated.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:image/image.dart' as img;

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

const PICTURE_FOLDER = "/app_images";

class PhotoViewFromDevice extends StatefulWidget {
  @override
  _PhotoViewFromDeviceState createState() => _PhotoViewFromDeviceState();
}

class _PhotoViewFromDeviceState extends State<PhotoViewFromDevice> {
  img.Image finalImage;
  img.Image finalImage2;

  List<String> imagePath = new List();
  Future<bool> loadImgae() async {

    imagePath = await GetFileFromNative.getPicturePath();
    await Future.delayed(Duration(seconds: 4)); // UI THINGS
    return true;
  }

  Widget buildAnimatedItem(
    BuildContext context,
    int index,
    Animation<double> animation,
  ) =>
      // For example wrap with fade transition
      FadeTransition(
        opacity: Tween<double>(
          begin: 0,
          end: 1,
        ).animate(animation),
        // And slide transition
        child: SlideTransition(
            position: Tween<Offset>(
              begin: Offset(0, -0.1),
              end: Offset.zero,
            ).animate(animation),
            // Paste you Widget
            child: EnlargerPicture(
                img_path: imagePath[index], tag: imagePath[index])),
      );

  final options = LiveOptions(
    // Start animation after (default zero)
    delay: Duration(milliseconds: 700),

    // Show each item through (default 250)
    showItemInterval: Duration(milliseconds: 500),

    // Animation duration (default 250)
    showItemDuration: Duration(seconds: 1),

    // Animations starts at 0.05 visible
    // item fraction in sight (default 0.025)
    visibleFraction: 0.05,

    // Repeat the animation of the appearance
    // when scrolling in the opposite direction (default false)
    // To get the effect as in a showcase for ListView, set true
    reAnimateOnVisibility: false,
  );
  static const FlareActor flare_loading = FlareActor(
    "assets/images/Loading White Moon.flr",
    isPaused: false,
    snapToEnd: false,
    fit: BoxFit.scaleDown,
    animation: "Alarm",
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: FutureBuilder(
          future: this.loadImgae(),
          initialData: false,
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            return snapshot.data == true
                // ? Image.memory(finalImage2.getBytes())
                ? LiveGrid.options(
                    options: options,
                    itemBuilder: buildAnimatedItem,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: imagePath.length,
                  )
                // MemoryImage(f)
                : Container(
                    alignment: Alignment.center,
                    child: flare_loading,
                    color: Colors.white);
          }),
    ));
  }

  // PhotoViewGallery buildPhotoViewGallery() {
  //   return PhotoViewGallery.builder(
  //     scrollPhysics: const BouncingScrollPhysics(),
  //     builder: (BuildContext context, int index) {
  //       return PhotoViewGalleryPageOptions(
  //         imageProvider: FileImage(File(imagePath[index])),
  //         initialScale: PhotoViewComputedScale.contained * 0.8,
  //         // heroAttributes: HeroAttributes(tag: galleryItems[index].id),
  //       );
  //     },
  //     itemCount: imagePath.length,
  //     loadingBuilder: (context, event) => Center(
  //       child: Container(
  //         width: 20.0,
  //         height: 20.0,
  //         child: CircularProgressIndicator(
  //           value: event == null
  //               ? 0
  //               : event.cumulativeBytesLoaded / event.expectedTotalBytes,
  //         ),
  //       ),
  //     ),
  //     // backgroundDecoration: ,
  //     // pageController: widget.pageController,
  //     // onPageChanged: onPageChanged,
  //   );
  // }
}
//   String abc = "/data/user/0/com.example.Valerian/flutter_app";

//   print(abc.split("/"));
//   List<String> temperPath = abc.split("/");
//   int indexAppName = temperPath.indexWhere((eachPath)=> eachPath.contains("Valerian")) +1;
//   print(temperPath.indexWhere((eachPath)=> eachPath.contains("Valerian")));
// //   temperPath[indexAppName] = "app_imgaes";
//   List<String> temperString = temperPath.map((path) => path=path+"/").toList();

//   print(temperString.join());

//   if("/data/user/0/com.example.Valerian/flutter_app" == abc){
//     print("OK");
//   }
