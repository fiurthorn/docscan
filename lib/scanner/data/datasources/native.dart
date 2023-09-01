import 'package:flutter/services.dart';

class Native {
  static const platform = MethodChannel('flutter.native/helper');

  String? _tempDir;
  Future<String> _getTempDir() {
    return platform.invokeMethod('getTempDir').then((value) => value as String);
  }

  Future<String> getTempDir() async {
    return _tempDir ??= (await _getTempDir());
  }

  String? _appConfigurationDir;
  Future<String> _getAppConfigurationDir() {
    return platform.invokeMethod('appConfigurationDir').then((value) => value as String);
  }

  Future<String> getAppConfigurationDir() async {
    return _appConfigurationDir ??= (await _getAppConfigurationDir());
  }

  String? _flavor;
  static Future<String> _getFlavor() async {
    return platform.invokeMethod('getFlavor').then((value) => value as String);
  }

  Future<String> getFlavor() async {
    return _flavor ??= (await _getFlavor());
  }

  Future<dynamic> saveFileInMediaStore(String input, String folder, String fileName) async {
    return platform.invokeMethod('saveFileInMediaStore', {
      "input": input,
      "folder": "docscan/$folder",
      "fileName": fileName,
    });
  }
}
