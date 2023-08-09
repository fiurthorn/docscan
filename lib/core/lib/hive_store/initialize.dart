import 'package:hive/hive.dart';
import 'package:document_scanner/core/lib/hive_store/value.dart';
import 'package:document_scanner/core/lib/trace.dart';
import 'package:document_scanner/core/platform/platform.dart';

Future<Box<Value>> initHive() async {
  if (isDesktop || (isMobile && !isWeb)) Hive.init(trace(await appDocumentsDir(), "appDocumentsDir"));

  Hive.registerAdapter<Value>(ValueAdapter());
  final a = Hive.openBox<Value>("docscan");
  return await a;
}
