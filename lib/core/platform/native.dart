import 'package:document_scanner/core/lib/trace.dart';
import 'package:flutter/services.dart';

class Helper {
  static const platform = MethodChannel('flutter.native/helper');

  static Future<dynamic> getDownloadsDirectory() async {
    return trace(platform.invokeMethod('getDownloadsDirectory'), 'getDownloadsDirectory');
  }

  static Future<dynamic> getLibraryDirectory() async {
    return trace(platform.invokeMethod('getLibraryDirectory'), 'getLibraryDirectory');
  }
}
