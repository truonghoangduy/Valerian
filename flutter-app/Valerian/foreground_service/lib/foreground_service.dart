import 'dart:async';

import 'package:flutter/services.dart';
import 'package:platform/platform.dart';

class ForegroundService {
  static const MethodChannel _channel =
      const MethodChannel('com.pauldemarco.foreground_service');

  /// ticker only has usage with accessibility services enabled. It does not show a text in the status bar.
  static Future<String> start({String title, String text, String subText, String ticker}) {
    assert(const LocalPlatform().isAndroid);
    final args = {
      'title': title,
      'text': text,
      'subText': subText,
      'ticker': ticker,
      'labelPath':"assets/labelmap.txt",
      'modelPath':"assets/detect.tflite"
    };
    return _channel.invokeMethod('start', args);
  }
  static Future<bool> enableTfLite({String title, String text, String subText, String ticker}){
        final args = {
      'title': title,
      'text': text,
      'subText': subText,
      'ticker': ticker,
      'labelPath':"assets/labelmap.txt",
      'modelPath':"assets/detect.tflite",
      'enableTensorFlow':true
    };
    return _channel.invokeMethod('start',args);
  }

  static Future<String> stop() {
    assert(const LocalPlatform().isAndroid);
    return _channel.invokeMethod('stop');
  }
}
