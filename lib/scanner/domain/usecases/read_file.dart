import 'package:document_scanner/core/lib/either.dart';
import 'package:document_scanner/core/service_locator/service_locator.dart';
import 'package:document_scanner/scanner/domain/repositories/file_repos.dart';
import 'package:document_scanner/scanner/domain/usecases/usecase.dart';
import 'package:flutter/foundation.dart';

export 'call.dart';

class ReadFileParam {
  final String path;

  ReadFileParam(this.path);
}

class ReadFileEntity {
  final String name;
  final Uint8List data;

  ReadFileEntity(this.name, this.data);
}

typedef ReadFileResult = ReadFileEntity;
typedef ReadFile = UseCase<ReadFileResult, ReadFileParam>;

class ReadFileUseCase implements ReadFile {
  @override
  Future<Either<ReadFileResult>> call(ReadFileParam param) async {
    try {
      final result = sl<FileRepos>().readFile(param.path);
      return Either.value(ReadFileEntity(result.name, result.data));
    } on Exception catch (e, st) {
      return Either.exception(e, st);
    }
  }
}
