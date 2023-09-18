import 'package:document_scanner/core/lib/tuple.dart';
import 'package:flutter/foundation.dart';

typedef Converter = String;

const Converter original = "Original";
const Converter grayscale = "GrayScale";
const Converter monochrome = "Monochrome";
const Converter luminance = "Luminance";

abstract class ImageConverter {
  Uint8List convertImage(
    Converter converter,
    Tuple2<String, Uint8List> item, {
    double amount = 1,
    double threshold = 0.5,
  });

  Uint8List rotate(Uint8List input, bool counterClockwise);
}
