import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'pdf.freezed.dart';

@freezed
class ImageAttachment with _$ImageAttachment {
  factory ImageAttachment(String path, Uint8List image) = _ImageAttachment;
}

abstract class PdfCreator {
  Future<Uint8List?> createPdfFromImages(List<ImageAttachment> images);
}
