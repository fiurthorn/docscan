import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class Ocr {
  Future<String> ocr(String filepath) async {
    final inputImage = InputImage.fromFilePath(filepath);
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    try {
      final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
      return recognizedText.text;
    } finally {
      textRecognizer.close();
    }
  }
}
