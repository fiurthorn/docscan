import 'dart:io';

import 'package:cunning_document_scanner/cunning_document_scanner.dart';
import 'package:document_scanner/core/lib/tuple.dart';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

Future<Tuple2<String, Uint8List?>> scan() async {
  final imagePaths = await CunningDocumentScanner.getPictures();
  if (imagePaths == null || imagePaths.isEmpty) {
    return const Tuple2("", null);
  }

  final pdf = pw.Document();
  for (final imagePath in imagePaths) {
    await (img.Command()
          ..decodeJpgFile(imagePath)
          ..grayscale()
          //..monochrome(color: img.ColorInt16.rgb(0, 0, 0))
          ..encodeJpgFile(imagePath, quality: 50)
        //
        //..luminanceThreshold(threshold: 0.65)
        // ..encodeTiffFile(imagePath)
        //
        )
        .executeThread();

    final input = File(imagePath);
    final src = pw.MemoryImage(input.readAsBytesSync());
    input.deleteSync();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat(
          src.width!.toDouble(),
          src.height!.toDouble(),
          marginAll: 0.0,
        ),
        // margin: ,
        build: (pw.Context context) => pw.Image(src),
      ),
    );
  }

  return Tuple2("scan.pdf", await pdf.save());
}
