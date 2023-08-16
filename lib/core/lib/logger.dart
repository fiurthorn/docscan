import 'package:flutter/foundation.dart';

class Log {
  static less(String msg) {
    if (kDebugMode) {
      debugPrint("LOG: L:$msg");
    }
  }

  static norm(String msg) {
    debugPrint("LOG: $msg");
  }

  static high(String msg, {Object? error, StackTrace? stackTrace}) {
    if (stackTrace != null) {
      debugPrintStack(label: "H: $msg ${error ?? ""}", stackTrace: stackTrace);
    } else {
      debugPrint("LOG: H: $msg ${error ?? ""}");
    }
  }
}
