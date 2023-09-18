import 'package:async/async.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class Native {
  static const platform = MethodChannel('flutter.native/helper');

  final _getTempDir = AsyncMemoizer<String>();
  Future<String> getTempDir() async {
    return _getTempDir.runOnce(() => platform.invokeMethod('getTempDir').then((value) => value as String));
  }

  final _getAppConfigurationDir = AsyncMemoizer<String>();
  Future<String> getAppConfigurationDir() async {
    return _getAppConfigurationDir
        .runOnce(() => platform.invokeMethod('getAppConfigurationDir').then((value) => value as String));
  }

  final _flavor = AsyncMemoizer<String>();
  Future<String> flavor() async {
    return _flavor.runOnce(() => platform.invokeMethod('flavor').then((value) => value as String));
  }

  String get prefix => kReleaseMode ? "" : "!";
  String get name => "docscan";

  Future<dynamic> saveFileInMediaStore(String input, String folder, String fileName) async {
    return platform.invokeMethod('saveFileInMediaStore', {
      "input": input,
      "folder": "$prefix$name/$folder",
      "fileName": fileName,
    });
  }
}
