import 'package:document_scanner/core/lib/trace.dart';
import 'package:hive/hive.dart';

import 'value.dart';

Future<Box<dynamic>> initHive(String storageLocation) async {
  Hive.init(trace(storageLocation, "appConfigurationDir"));

  Hive.registerAdapter<Value>(ValueAdapter());
  final a = await Hive.openBox<dynamic>("docscan");
  return a;
}
