import 'package:document_scanner/core/lib/optional.dart';
import 'package:document_scanner/core/lib/tuple.dart';
import 'package:document_scanner/core/service_locator/service_locator.dart';
import 'package:document_scanner/scanner/domain/repositories/disk_source.dart';
import 'package:document_scanner/scanner/domain/usecases/usecase.dart';
import 'package:flutter/foundation.dart';

class ReadFilesParam {
  final List<String> path;

  ReadFilesParam(this.path);
}

typedef Result = List<Tuple2<String, Uint8List>>;

class ReadFilesUseCase implements UseCase<Result, ReadFilesParam> {
  @override
  Future<Optional<Result>> call(ReadFilesParam param) async {
    try {
      return Optional.newValue(sl<DiskSource>().readFiles(param.path));
    } on Exception catch (e, st) {
      return Optional.newError(e, st);
    }
  }
}
