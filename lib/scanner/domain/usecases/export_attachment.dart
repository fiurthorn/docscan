import 'package:document_scanner/core/lib/optional.dart';
import 'package:document_scanner/core/lib/tuple.dart';
import 'package:document_scanner/core/service_locator/service_locator.dart';
import 'package:document_scanner/scanner/domain/repositories/key_values.dart';
import 'package:document_scanner/scanner/domain/repositories/media_store.dart';
import 'package:document_scanner/scanner/domain/usecases/usecase.dart';
import 'package:flutter/foundation.dart';

class ExportAttachmentParam extends Tuple2<String, Uint8List> {
  String get name => a;
  Uint8List get image => b;

  const ExportAttachmentParam(String name, Uint8List image) : super(name, image);

  ExportAttachmentParam.fromTuple(Tuple2<String, Uint8List> t) : this(t.a, t.b);
}

class ExportAttachmentsParam {
  final String area;
  final String sender;
  final String docType;
  final DateTime dateTime;
  final List<ExportAttachmentParam> attachments;

  ExportAttachmentsParam(
    this.area,
    this.sender,
    this.docType,
    this.dateTime,
    this.attachments,
  );
}

typedef Result = void;

class ExportAttachmentUseCase implements UseCase<Result, ExportAttachmentsParam> {
  @override
  Future<Optional<Result>> call(ExportAttachmentsParam param) async {
    try {
      return Optional.newValue(
        sl<MediaStore>().upload(
          param.area,
          param.sender,
          param.docType,
          param.dateTime,
          param.attachments.map((e) => ExportAttachmentModel.fromTuple(e)).toList(),
        )..then((_) => sl<KeyValues>().addSenderName(param.sender)),
      );
    } on Exception catch (e, st) {
      return Optional.newError(e, st);
    }
  }
}