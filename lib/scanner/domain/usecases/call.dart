import 'dart:async';

import 'package:document_scanner/core/service_locator/service_locator.dart';

import 'usecase.dart';

Future<Result> usecase<Result, Param>(Param param) async {
  return (await sl<UseCase<Result, Param>>()(param)).eval();
}

Stream<Result> ucStream<Usecase extends UseCaseStream<Result, Param>, Result, Param>(Param param) {
  return sl<Usecase>()(param);
}

Completer<Result> ucCompleter<Usecase extends UseCaseCompleter<Result, Param>, Result, Param>(Param param) {
  return sl<Usecase>()(param);
}
