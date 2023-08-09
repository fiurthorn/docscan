import 'package:flutter/services.dart';

class FileSource {
  Future<String> assetFileAsString(String asset) async => rootBundle.loadString(asset);
}
