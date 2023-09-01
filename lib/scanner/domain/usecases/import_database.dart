import 'package:document_scanner/core/lib/optional.dart';
import 'package:document_scanner/core/service_locator/service_locator.dart';
import 'package:document_scanner/scanner/domain/repositories/key_values.dart';
import 'package:document_scanner/scanner/domain/usecases/usecase.dart';

export 'call.dart';

class ImportDatabaseParam {
  final Map<dynamic, dynamic> map;
  ImportDatabaseParam(this.map);
}

typedef ImportDatabase = UseCase<bool, ImportDatabaseParam>;

class ImportDatabaseUseCase implements ImportDatabase {
  @override
  Future<Optional<bool>> call(ImportDatabaseParam param) async {
    try {
      return sl<KeyValues>().importDatabase(param.map).then((value) => Optional.newValue(true));
    } on Exception catch (e, st) {
      return Optional.newError(e, st);
    }
  }
}
