import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'media_store.freezed.dart';

@freezed
class ExportAttachmentModel with _$ExportAttachmentModel {
  factory ExportAttachmentModel(String name, Uint8List image) = _ExportAttachmentModel;
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
