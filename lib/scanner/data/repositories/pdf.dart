import 'package:document_scanner/core/service_locator/service_locator.dart';
import 'package:document_scanner/scanner/data/datasources/ocr.dart';
import 'package:document_scanner/scanner/domain/repositories/pdf.dart';
import 'package:flutter/foundation.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfCreatorImpl implements PdfCreator {
  @override
  Future<Uint8List?> createPdfFromImages(List<ImageAttachment> images) async {
    if (images.isEmpty) {
      return Future.sync(() => null);
    }

    final pdf = pw.Document();
    for (final image in images) {
      final src = pw.MemoryImage(image.image);
      final result = await sl<Ocr>().ocr(image.path);

      final text = pw.Text(
        result,
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
}
