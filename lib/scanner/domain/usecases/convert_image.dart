import 'package:document_scanner/core/lib/optional.dart';
import 'package:document_scanner/core/service_locator/service_locator.dart';
import 'package:document_scanner/scanner/domain/repositories/convert.dart';
import 'package:document_scanner/scanner/domain/usecases/usecase.dart';
import 'package:flutter/foundation.dart';

export 'call.dart';

class ConvertImageParam {
  final Converter converter;
  final String itemName;
  final Uint8List itemData;
  final double amount;
  final double threshold;

  ConvertImageParam({
    required this.converter,
    required this.itemName,
    required this.itemData,
    this.amount = 1,
    this.threshold = 0.5,
  });
}

typedef ConvertImageResult = Uint8List;
typedef ConvertImage = UseCase<ConvertImageResult, ConvertImageParam>;

class ConvertImageUseCase implements ConvertImage {
  @override
  Future<Optional<ConvertImageResult>> call(ConvertImageParam param) async {
    try {
      return sl<ImageConverter>()
          .convertImage(
            param.converter,
            param.itemName,
            param.itemData,
            amount: param.amount,
            threshold: param.threshold,
          )
          .then((value) => Optional.newValue(value));
    } on Exception catch (e, st) {
      return Optional.newError(e, st);
    }
  }
}
