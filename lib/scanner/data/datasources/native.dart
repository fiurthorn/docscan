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
    return platform.invokeMethod('getAppConfigurationDir').then((value) => value as String);
  }

  Future<String> getAppConfigurationDir() async {
    return _appConfigurationDir ??= (await _getAppConfigurationDir());
  }

  String? __flavor;
  static Future<String> _flavor() async {
    return platform.invokeMethod('flavor').then((value) => value as String);
  }

  Future<String> flavor() async {
    return __flavor ??= (await _flavor());
  }

  Future<dynamic> saveFileInMediaStore(String input, String folder, String fileName) async {
    return platform.invokeMethod('saveFileInMediaStore', {
      "input": input,
      "folder": "docscan/$folder",
      "fileName": fileName,
    });
  }
}
