import 'package:document_scanner/core/lib/tuple.dart';
import 'package:flutter/foundation.dart';

class ImageAttachment extends Tuple2<String, Uint8List> {
  String get path => a;
  Uint8List get image => b;

  const ImageAttachment(String path, Uint8List image) : super(path, image);

  ImageAttachment.fromTuple(Tuple2<String, Uint8List> t) : this(t.a, t.b);
}

abstract class PdfCreator {
  Future<Uint8List?> createPdfFromImages(List<ImageAttachment> images);
}
