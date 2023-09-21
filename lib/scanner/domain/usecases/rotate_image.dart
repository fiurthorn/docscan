import 'package:document_scanner/core/lib/optional.dart';
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
  Future<Optional<RotateImageResult>> call(RotateImageParam param) async {
    try {
      return Optional.newValue(sl<ImageConverter>().rotate(param.image, param.counterClockwise));
    } on Exception catch (e, st) {
      return Optional.newError(e, st);
    }
  }
}
