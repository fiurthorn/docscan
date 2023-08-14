import 'dart:math';

import 'package:flutter/painting.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image/image.dart' as img;

ocr(dynamic inputImage) async {
  final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
  final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);

  String text = recognizedText.text;
  for (TextBlock block in recognizedText.blocks) {
    final Rect rect = block.boundingBox;
    final List<Point<int>> cornerPoints = block.cornerPoints;
    final String text = block.text;
    final List<String> languages = block.recognizedLanguages;

    for (TextLine line in block.lines) {
      // Same getters as TextBlock
      for (TextElement element in line.elements) {
        // element.boundingBox.
        // Same getters as TextBlock
      }
    }
  }
  textRecognizer.close();
}

void main() async {
  final input = await (img.Command()..decodeJpgFile('/home/weinmann/Pictures/yt/hqdefault.jpg')).executeThread();
  final output = img.luminanceThreshold(input.outputImage!, outputColor: false);

  await (img.Command()
        ..image(output)
        ..encodeTiffFile('/home/weinmann/Pictures/yt/hqdefault-out.jpeg'))
      .executeThread();
}
