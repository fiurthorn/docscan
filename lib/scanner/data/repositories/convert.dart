import 'package:document_scanner/core/lib/tuple.dart';
import 'package:document_scanner/core/service_locator/service_locator.dart';
import 'package:document_scanner/scanner/data/datasources/file_source.dart';
import 'package:document_scanner/scanner/domain/repositories/convert.dart';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;

class ImageConverterImpl implements ImageConverter {
  @override
  Future<Uint8List> convertImage(
    String converter,
    Tuple2<String, Uint8List> item, {
    double amount = 1,
    double threshold = 0.5,
  }) {
    final path = item.a;
    final image = item.b;

    Future<Uint8List> cachedImage;
    switch (converter) {
      case original:
        cachedImage = convertToResize(image);
        break;
      case grayscale:
        cachedImage = convertToGreyScale(image);
        break;
      case monochrome:
        cachedImage = convertToMonochrome(image, amount: amount);
        break;
      case luminance:
        cachedImage = convertToLuminance(image, threshold: threshold);
        break;
      default:
        cachedImage = convertToResize(image);
    }

    return cachedImage.then((value) {
      sl<FileSource>().writeImageFile(path, value);
      return value;
    });
  }

  img.Command _load(Uint8List input) {
    return img.Command()..decodeJpg(input);
  }

  Future<Uint8List> _store(img.Command command) {
    return img
        .executeCommandBytesAsync(
          command..encodeJpg(quality: 75),
        )
        .then((value) => value!);
  }

  Future<Uint8List> convertToResize(Uint8List input) {
    return _store(_load(input));
  }

  Future<Uint8List> convertToGreyScale(Uint8List input) {
    return _store(_load(input)..grayscale());
  }

  Future<Uint8List> convertToMonochrome(Uint8List input, {double amount = 1}) {
    return _store(
      _load(input)
        ..monochrome(
          color: img.ColorInt16.rgb(0, 0, 0),
          amount: amount,
        ),
    );
  }

  Future<Uint8List> convertToLuminance(Uint8List input, {double threshold = 0.5}) {
    return _store(
      _load(input)
        ..luminanceThreshold(
          threshold: threshold,
          outputColor: false,
        ),
    );
  }

  @override
  Future<Uint8List> rotate(Uint8List input, bool counterClockwise) {
    return _store(
      _load(input)
        ..copyRotate(
          angle: counterClockwise ? 90.0 : -90.0,
        ),
    );
  }
}
