import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

enum ContentType { Paragaph, Media }

class EnlargerPicture extends StatelessWidget {
  // final Image _image;
  final String img_path;
  final FileImage imageByQues;
  final String tag;
  // final String dectionResult;
  final ContentType content_type;

  EnlargerPicture(
      {this.imageByQues, this.content_type, this.tag, this.img_path});

  Map<String, String> aaaa(NetworkImage image) {
    return image.headers;
  }

  Widget buildZoomablePhoto({Map<String, int> predictionResult, Size deviceSize}) {
    return PhotoView.customChild(
      backgroundDecoration: const BoxDecoration(color: Colors.white),
        child: Container(
      decoration: const BoxDecoration(color: Colors.white),
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text(
            "Hello there, this is a text, that is a svg:",
            style: const TextStyle(fontSize: 12.0),
            textAlign: TextAlign.center,
          ),
          Image(
            image: FileImage(File(this.img_path)),
            fit: BoxFit.contain,
          )
        ],
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    Size _querydata = MediaQuery.of(context).size;
    // print(pictrueSize
    return GestureDetector(
      onDoubleTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return Scaffold(
              appBar: AppBar(),
              // TODO make it Zoomable
              body: Hero(
                  tag: tag,
                  child: Center(
                      child: 
                  //     Image(
                  //   image: FileImage(File(img_path)),
                  //   fit: BoxFit.contain,
                  // )
                  Container(
                    color: Colors.white,
                    child: buildZoomablePhoto())
                  )));
        }));
      },
      child: Container(
        alignment: Alignment.center,
        child: Hero(
            tag: tag,
            child: Image(
              fit: BoxFit.fill,
              // alignment: Alignment.center,
              image: FileImage(File(img_path)),
              loadingBuilder: (BuildContext context, Widget child,
                  ImageChunkEvent loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                }
                return Container();
              },
            )),
      ),
    );
  }
}
