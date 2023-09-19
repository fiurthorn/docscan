import 'package:document_scanner/core/lib/tuple.dart';
import 'package:document_scanner/core/service_locator/service_locator.dart';
import 'package:document_scanner/scanner/data/datasources/file_source.dart';
import 'package:document_scanner/scanner/domain/repositories/convert.dart';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;

class ImageConverterImpl implements ImageConverter {
  @override
  Uint8List convertImage(
    String converter,
    Tuple2<String, Uint8List> item, {
    double amount = 1,
    double threshold = 0.5,
  }) {
    final path = item.a;
    final image = item.b;

    Uint8List cachedImage;
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

    sl<FileSource>().writeImageFile(path, cachedImage);
    return cachedImage;
  }

  img.Image _load(Uint8List src) {
    return img.JpegDecoder().decode(src)!;
  }

  Uint8List _resize(img.Image src) {
    return img.JpegEncoder(quality: 75).encode(src);
  }

  Uint8List convertToResize(Uint8List input) {
    return _resize(_load(input));
  }

  Uint8List convertToGreyScale(Uint8List input) {
    return _resize(
      img.grayscale(_load(input)),
    );
  }

  Uint8List convertToMonochrome(Uint8List input, {double amount = 1}) {
    return _resize(
      img.monochrome(_load(input), color: img.ColorInt16.rgb(0, 0, 0), amount: amount),
    );
  }

  Uint8List convertToLuminance(Uint8List input, {double threshold = 0.5}) {
    return _resize(
      img.luminanceThreshold(_load(input), threshold: threshold, outputColor: false),
    );
  }

  @override
  Uint8List rotate(Uint8List input, bool counterClockwise) {
    return _resize(
      img.copyRotate(_load(input), angle: counterClockwise ? 90.0 : -90.0),
    );
  }
}
