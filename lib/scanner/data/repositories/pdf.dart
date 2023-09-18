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
      final ocr = await sl<Ocr>().ocr(image.path);

      final text = ocrContent(
        ocr,
        (src.height! / 80) * 0.8,
      );
      final page = composePage(src, text);

      pdf.addPage(page);
    }

    return pdf.save();
  }

  pw.Page composePage(pw.MemoryImage src, pw.Text text) {
    return pw.Page(
      pageFormat: PdfPageFormat(
        src.width!.toDouble(),
        src.height!.toDouble(),
        marginAll: 0.0,
      ),
      // margin: ,
      build: (pw.Context context) => pw.Stack(
        children: [
          pw.Padding(padding: pw.EdgeInsets.all(src.height! / 20.0), child: text),
          pw.Image(src),
        ],
      ),
    );
  }

  pw.Text ocrContent(String ocr, double fontSize) {
    return pw.Text(
      ocr,
      style: pw.TextStyle(
        color: const PdfColor(0, 0, 0, 0),
        fontSize: fontSize,
      ),
    );
  }
}
