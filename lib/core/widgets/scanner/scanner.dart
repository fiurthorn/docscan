import 'package:cunning_document_scanner/cunning_document_scanner.dart';
import 'package:document_scanner/core/lib/tuple.dart';
import 'package:flutter/foundation.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image/image.dart' as img;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

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

Future<List<String>?> scan() async {
  return CunningDocumentScanner.getPictures();
}

img.Image _load(Uint8List src) {
  return img.JpegDecoder().decode(src)!;
}

Uint8List _resize(img.Image src) {
  return img.JpegEncoder(quality: 75).encode(
    img.copyResize(src, width: 2000),
  );
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

Future<Uint8List?> createPdf(List<Tuple2<String, Uint8List>> images) async {
  if (images.isEmpty) {
    return Future.sync(() => null);
  }

  final pdf = pw.Document();
  for (final image in images) {
    final src = pw.MemoryImage(image.b);

    final text = pw.Text(
      await ocr(image.a),
      style: pw.TextStyle(
        color: const PdfColor(1, 1, 1, 1),
        fontSize: (src.height! / 80) * 0.8,
      ),
    );

    final page = pw.Page(
      pageFormat: PdfPageFormat(
        src.width!.toDouble(),
        src.height!.toDouble(),
        marginAll: 0.0,
      ),
      // margin: ,
      build: (pw.Context context) => pw.Stack(
        children: [
          text,
          pw.Image(src),
        ],
      ),
    );

    pdf.addPage(page);
  }

  return pdf.save();
}
