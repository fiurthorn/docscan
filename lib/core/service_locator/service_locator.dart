import 'package:document_scanner/core/lib/hive_store/initialize.dart';
import 'package:document_scanner/core/lib/logger.dart';
import 'package:document_scanner/scanner/data/repositories/key_values.dart';
import 'package:document_scanner/scanner/domain/repositories/key_values.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<GetIt> initServiceLocator() async {
  try {
    // use cases

    // repositories
    sl.registerSingletonAsync<KeyValues>(() async => KeyValuesImpl(await initHive()));

    // data broker

    // wait to ready
    return sl.allReady().then((value) => sl).whenComplete(() => Log.less("service locator ready"));
  } on Exception catch (err, stack) {
    Log.high("sl", error: err, stackTrace: stack);
    rethrow;
  }
}

KeyValues keyValues() => sl();
