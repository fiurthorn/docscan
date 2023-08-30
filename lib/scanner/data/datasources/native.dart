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

  Future<String> _appConfigurationDir() {
    return platform.invokeMethod('appConfigurationDir').then((value) => value as String);
  }

  Future<String> appConfigurationDir() async {
    return libraryDirectory ??= (await _appConfigurationDir());
  }

  Future<dynamic> saveFileInMediaStore(String input, String folder, String fileName) async {
    return platform.invokeMethod('saveFileInMediaStore', {
      "input": input,
      "folder": "docscan/$folder",
      "fileName": fileName,
    });
  }
}
