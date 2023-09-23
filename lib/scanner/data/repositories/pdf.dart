import 'package:document_scanner/core/lib/logger.dart';
import 'package:document_scanner/core/service_locator/service_locator.dart';
import 'package:document_scanner/scanner/data/datasources/ocr.dart';
import 'package:document_scanner/scanner/domain/repositories/pdf.dart';
import 'package:flutter/foundation.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfCreatorImpl implements PdfCreator {
  static const double inch = 72.0;
  static const double cm = inch / 2.54;

  static const PdfPageFormat portrait = PdfPageFormat(21.0 * cm, 29.7 * cm, marginAll: 0);
  static const PdfPageFormat landscape = PdfPageFormat(29.7 * cm, 21.0 * cm, marginAll: 0);

  @override
  Future<Uint8List?> createPdfFromImages(List<ImageAttachment> images) async {
    if (images.isEmpty) {
      return Future.sync(() => null);
    }

    final pdf = pw.Document();
    for (final image in images) {
      final src = pw.MemoryImage(image.image);
      final ocr = await sl<Ocr>().ocr(image.path);

      Log.high("ratio ${src.width! > src.height! ? src.width! / src.height! : src.height! / src.width!}");
      final page = composePage(src, ocr);

      pdf.addPage(page);
    }

    return pdf.save();
  }

  pw.Page composePage(pw.MemoryImage src, String ocr) {
    final pageFormat = this.pageFormat(src);
    final text = ocrContent(
      ocr,
      pageFormat.height * 0.008,
    );

    return pw.Page(
      pageFormat: pageFormat,
      build: (pw.Context context) => pw.Stack(
        children: [
          pw.Padding(padding: pw.EdgeInsets.all(pageFormat.height * 0.9), child: text),
          pw.Image(src, fit: pw.BoxFit.fill),
        ],
      ),
    );
  }

  bool isA4Portrait(pw.MemoryImage src) => (((src.height! / src.width!) * 10.0).round() == 14);
  bool isA4Landscape(pw.MemoryImage src) => (((src.width! / src.height!) * 10.0).round() == 14);

  PdfPageFormat pageFormat(pw.MemoryImage src) {
    if (isA4Portrait(src)) {
      return portrait;
    }

    if (isA4Landscape(src)) {
      return landscape;
    }

    return PdfPageFormat(
      src.width!.toDouble(),
      src.height!.toDouble(),
      marginAll: 0.0,
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
