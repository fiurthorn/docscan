import 'package:document_scanner/core/lib/either.dart';
import 'package:document_scanner/core/service_locator/service_locator.dart';
import 'package:document_scanner/scanner/domain/repositories/convert.dart';
import 'package:document_scanner/scanner/domain/usecases/usecase.dart';
import 'package:flutter/foundation.dart';

export 'call.dart';

class RotateImageParam {
  final Uint8List image;
  final bool counterClockwise;

  RotateImageParam(this.image, this.counterClockwise);
}

typedef RotateImageResult = Uint8List;
typedef RotateImage = UseCase<RotateImageResult, RotateImageParam>;

class RotateImageUseCase implements RotateImage {
  @override
  Future<Either<RotateImageResult>> call(RotateImageParam param) async {
    try {
      return sl<ImageConverter>().rotate(param.image, param.counterClockwise).then((value) => Either.value(value));
    } on Exception catch (e, st) {
      return Either.exception(e, st);
    }
  }
}
