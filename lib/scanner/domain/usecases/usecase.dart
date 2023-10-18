import 'dart:async';

import 'package:document_scanner/core/lib/either.dart';

abstract class UseCase<Result, Param> {
  Future<Either<Result>> call(Param param);
}

abstract class UseCaseSync<Result, Param> {
  Either<Result> call(Param param);
}

abstract class UseCaseStream<Result, Param> {
  Stream<Result> call(Param param);
}

abstract class UseCaseCompleter<Result, Param> {
  Completer<Result> call(Param param);
}
