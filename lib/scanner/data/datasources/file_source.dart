import 'dart:io';

import 'package:document_scanner/core/lib/tuple.dart';
import 'package:flutter/services.dart';

class FileSource {
  Future<String> assetFileAsString(String asset) async => rootBundle.loadString(asset);

  List<Tuple2<String, Uint8List>> readFiles(List<String> paths) {
    final images = paths.map((path) => Tuple2(path, File(path).readAsBytesSync())).toList();
    for (var path in paths) {
      File(path).deleteSync();
    }
    return images;
  }

  Future<String> getTempDir() async {
    return Directory.systemTemp.path;
  }

  void writeImageFile(String path, Uint8List data) {
    return File(path).writeAsBytesSync(data);
  }
}
