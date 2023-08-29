import 'package:document_scanner/core/lib/tuple.dart';
import 'package:flutter/foundation.dart';

class ExportAttachmentModel extends Tuple2<String, Uint8List> {
  String get name => a;
  Uint8List get image => b;

  const ExportAttachmentModel(String name, Uint8List image) : super(name, image);

  ExportAttachmentModel.fromTuple(Tuple2<String, Uint8List> t) : this(t.a, t.b);
}

abstract class MediaStore {
  Future<void> upload(
    String area,
    String sender,
    String receiver,
    String docType,
    DateTime dateTime,
    List<ExportAttachmentModel> attachments,
  );
}
