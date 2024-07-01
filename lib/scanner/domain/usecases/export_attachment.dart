import 'package:document_scanner/core/lib/either.dart';
import 'package:document_scanner/core/service_locator/service_locator.dart';
import 'package:document_scanner/scanner/domain/repositories/key_values.dart';
import 'package:document_scanner/scanner/domain/repositories/media_store.dart';
import 'package:document_scanner/scanner/domain/usecases/usecase.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

export 'call.dart';

part 'export_attachment.freezed.dart';

@freezed
class ExportAttachmentParam with _$ExportAttachmentParam {
  factory ExportAttachmentParam(String name, Uint8List image) = _ExportAttachmentParam;
}

class ExportAttachmentsParam {
  final String area;
  final String sender;
  final String receiver;
  final String docType;
  final DateTime dateTime;
  final List<ExportAttachmentParam> attachments;

  ExportAttachmentsParam(
    this.area,
    this.sender,
    this.receiver,
    this.docType,
    this.dateTime,
    this.attachments,
  );
}

typedef ExportAttachmentResult = void;
typedef ExportAttachment = UseCase<ExportAttachmentResult, ExportAttachmentsParam>;

class ExportAttachmentUseCase implements ExportAttachment {
  @override
  Future<Either<ExportAttachmentResult>> call(ExportAttachmentsParam param) async {
    try {
      return Either.value(
        sl<MediaStore>().upload(
          param.area,
          param.sender,
          param.receiver,
          param.docType,
          param.dateTime,
          param.attachments.map((e) => ExportAttachmentModel(e.name, e.image)).toList(),
        )..then((_) => sl<KeyValues>().addSenderName(param.sender)),
      );
    } on Exception catch (e, st) {
      return Either.exception(e, st);
    }
  }
}
