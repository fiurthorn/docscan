import 'package:document_scanner/core/lib/hive_store/value.dart';
import 'package:document_scanner/core/lib/logger.dart';
import 'package:document_scanner/core/lib/trace.dart';
import 'package:document_scanner/core/platform/platform.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

Future<Box<dynamic>> initHive() async {
  if (isDesktop || (isMobile && !isWeb)) {
    Hive.init(trace(await getLibraryDirectory().then((dir) => dir.path), "getLibraryDirectory"));
  }

  Hive.registerAdapter<Value>(ValueAdapter());
  final a = await Hive.openBox<dynamic>("docscan");
  Log.high("Hive initialized ${a.toMap()}");
  return a;
}
