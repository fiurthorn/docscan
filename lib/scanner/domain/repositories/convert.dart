import 'package:flutter/foundation.dart';

typedef Converter = String;

const Converter original = "Original";
const Converter grayscale = "GrayScale";
const Converter monochrome = "Monochrome";
const Converter luminance = "Luminance";

abstract class ImageConverter {
  Future<Uint8List> convertImage(
    Converter converter,
    String itemName,
    Uint8List itemData, {
    double amount = 1,
    double threshold = 0.5,
  });

  Future<Uint8List> rotate(Uint8List input, bool counterClockwise);
}
