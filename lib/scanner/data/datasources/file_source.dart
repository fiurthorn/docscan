import 'dart:io';

import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class FileSource {
  Future<String> assetFileAsString(String asset) async => rootBundle.loadString(asset);

  Uint8List readFile(String path) {
    return File(path).readAsBytesSync();
  }

  String readFileAsString(String path) {
    return File(path).readAsStringSync();
  }

  void deleteFile(String path) {
    return File(path).deleteSync();
  }

  Future<String> getTempDir() async {
    return Directory.systemTemp.path;
  }

  void writeImageFile(String path, Uint8List data) {
    return File(path).writeAsBytesSync(data);
  }

  Future<Uint8List> readXFile(XFile file) {
    return file.readAsBytes();
  }
}
