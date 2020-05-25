import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';
import 'package:image/image.dart' as img;
import 'package:http/http.dart' as http;

/// [Recognition] model & lable & documentation 
/// from tensorflow could be found here
/// https://www.tensorflow.org/lite/models/object_detection/overview
///

class Recognition {

  Future<bool> loadModel() async {
    try {
      String res = await Tflite.loadModel(
          model: 'assets/model/detect.tflite',
          numThreads: 1,
          labels: "assets/model/labelmap.txt");
      if (res != null) {
        print("Model loaded");
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
    }
  }

  static Uint8List imageToByteListUint8(img.Image image, int inputSize) {
    var convertedBytes = Uint8List(1 * inputSize * inputSize * 3);
    var buffer = Uint8List.view(convertedBytes.buffer);
    int pixelIndex = 0;
    for (var i = 0; i < inputSize; i++) {
      for (var j = 0; j < inputSize; j++) {
        var pixel = image.getPixel(j, i);
        buffer[pixelIndex++] = img.getRed(pixel);
        buffer[pixelIndex++] = img.getGreen(pixel);
        buffer[pixelIndex++] = img.getBlue(pixel);
      }
    }
    return convertedBytes.buffer.asUint8List();
  }

  objectDection(img.Image img) async {
    try {

      var recognitions = await Tflite.detectObjectOnBinary(
          binary: imageToByteListUint8(img, 300), // required
          threshold: 0.1, // defaults to 0.1
          numResultsPerClass: 10, // defaults to 5
          asynch: true);
      if (recognitions != null) {
        return recognitions;
      } else {
        return null;
      }
    } catch (e) {
      print(e);
    }
  }

    static Future<List<dynamic>> objectDection_V1(String imgURL) async {

    try {
      var respone = await http.get(imgURL);      
      var pic = img.decodeImage(respone.bodyBytes); // byte Input
      var resize = img.copyResize(pic,width: 300,height: 300); // Resize

      // resize.getBytes();
      var recognitions = await Tflite.detectObjectOnBinary(
          binary: imageToByteListUint8(resize, 300),
          threshold: 0.3, // defaults to 0.1
          numResultsPerClass: 1, // defaults to 5
          asynch: true);
      if (recognitions != null) {
        print("Decteced");
        return recognitions;
      }else{
        return null;
      }
    } catch (e) {
      print(e);
    }
  }

  dispose() async {
    await Tflite.close();
  }

  static final Recognition _singleton = Recognition._internal();

  factory Recognition() {
    return _singleton;
  }

  Recognition._internal();
}
