import 'package:document_scanner/core/lib/optional.dart';
import 'package:document_scanner/core/lib/tuple.dart';
import 'package:document_scanner/core/service_locator/service_locator.dart';
import 'package:document_scanner/scanner/domain/repositories/file_repos.dart';
import 'package:document_scanner/scanner/domain/usecases/usecase.dart';
import 'package:flutter/foundation.dart';

export 'call.dart';

class ReadFileParam {
  final String path;

  ReadFileParam(this.path);
}

typedef ReadFileResult = Tuple2<String, Uint8List>;
typedef ReadFile = UseCase<ReadFileResult, ReadFileParam>;

class ReadFileUseCase implements ReadFile {
  @override
  Future<Optional<ReadFileResult>> call(ReadFileParam param) async {
    try {
      return Optional.newValue(sl<FileRepos>().readFile(param.path));
    } on Exception catch (e, st) {
      return Optional.newError(e, st);
    }
  }
}
