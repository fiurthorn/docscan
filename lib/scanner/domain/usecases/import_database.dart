import 'dart:convert';

import 'package:document_scanner/core/lib/either.dart';
import 'package:document_scanner/core/service_locator/service_locator.dart';
import 'package:document_scanner/scanner/domain/repositories/file_repos.dart';
import 'package:document_scanner/scanner/domain/repositories/key_values.dart';
import 'package:document_scanner/scanner/domain/usecases/usecase.dart';

export 'call.dart';

class ImportDatabaseParam {
  final String path;
  ImportDatabaseParam(this.path);
}

typedef ImportDatabaseResult = bool;
typedef ImportDatabase = UseCase<ImportDatabaseResult, ImportDatabaseParam>;

class ImportDatabaseUseCase implements ImportDatabase {
  @override
  Future<Either<ImportDatabaseResult>> call(ImportDatabaseParam param) async {
    try {
      final content = sl<FileRepos>().readFileAsString(param.path);
      return sl<KeyValues>()
          .importDatabase(jsonDecode(content) as Map<dynamic, dynamic>)
          .then((value) => const Either.value(true));
    } on Exception catch (e, st) {
      return Either.failure(e, st);
    }
  }
}
