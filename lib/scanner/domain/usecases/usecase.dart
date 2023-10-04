import 'dart:async';

import 'package:document_scanner/core/lib/optional.dart';

abstract class UseCase<Result, Param> {
  Future<Optional<Result>> call(Param param);
}

abstract class UseCaseSync<Result, Param> {
  Optional<Result> call(Param param);
}

abstract class UseCaseStream<Result, Param> {
  Stream<Result> call(Param param);
}

abstract class UseCaseCompleter<Result, Param> {
  Completer<Result> call(Param param);
}
