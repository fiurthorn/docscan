import 'package:flutter/services.dart';

class Helper {
  static const platform = MethodChannel('flutter.native/helper');

  static Future<String> getTempDir() async {
    return platform.invokeMethod('getTempDir').then((value) => value as String);
  }

  static Future<String> getLibraryDirectory() async {
    return platform.invokeMethod('getLibraryDirectory').then((value) => value as String);
  }

  static Future<dynamic> saveFileInMediaStore(String input, String folder, String fileName) async {
    return platform.invokeMethod('saveFileInMediaStore', {
      "input": input,
      "folder": folder,
      "fileName": fileName,
    });
  }
}
