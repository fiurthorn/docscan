import 'package:document_scanner/core/lib/optional.dart';
import 'package:document_scanner/core/service_locator/service_locator.dart';
import 'package:document_scanner/scanner/domain/repositories/key_values.dart';
import 'package:document_scanner/scanner/domain/usecases/usecase.dart';

export 'call.dart';

class ExportDatabaseParam {
  ExportDatabaseParam();
}

typedef ExportDatabase = UseCase<bool, ExportDatabaseParam>;

class ExportDatabaseUseCase implements UseCase<bool, ExportDatabaseParam> {
  @override
  Future<Optional<bool>> call(ExportDatabaseParam param) async {
    try {
      return sl<KeyValues>().exportDatabase().then((value) => Optional.newValue(true));
    } on Exception catch (e, st) {
      return Optional.newError(e, st);
    }
  }
}
