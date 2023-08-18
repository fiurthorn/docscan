import 'package:flutter/services.dart';

class Native {
  static const platform = MethodChannel('flutter.native/helper');

  String? _tempDir;
  String? libraryDirectory;

  Future<String> _getTempDir() {
    return platform.invokeMethod('getTempDir').then((value) => value as String);
  }

  Future<String> getTempDir() async {
    return _tempDir ??= (await _getTempDir());
  }

  Future<String> _getLibraryDirectory() {
    return platform.invokeMethod('getLibraryDirectory').then((value) => value as String);
  }

  Future<String> getLibraryDirectory() async {
    return libraryDirectory ??= (await _getLibraryDirectory());
  }

  Future<dynamic> saveFileInMediaStore(String input, String folder, String fileName) async {
    return platform.invokeMethod('saveFileInMediaStore', {
      "input": input,
      "folder": folder,
      "fileName": fileName,
    });
  }
}
