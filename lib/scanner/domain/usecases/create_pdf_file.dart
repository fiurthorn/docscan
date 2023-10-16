import 'package:document_scanner/core/lib/optional.dart';
import 'package:document_scanner/core/service_locator/service_locator.dart';
import 'package:document_scanner/scanner/domain/repositories/pdf.dart';
import 'package:document_scanner/scanner/domain/usecases/usecase.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

export 'call.dart';

part 'create_pdf_file.freezed.dart';

@freezed
class AttachmentParam with _$AttachmentParam {
  factory AttachmentParam(String path, Uint8List image) = _AttachmentParam;
}

class CreatePdfFileParam {
  final List<AttachmentParam> documentTypes;

  CreatePdfFileParam(this.documentTypes);
}

typedef CreatePdfFileResult = Uint8List;
typedef CreatePdfFile = UseCase<CreatePdfFileResult, CreatePdfFileParam>;

class CreatePdfFileUseCase implements CreatePdfFile {
  @override
  Future<Optional<CreatePdfFileResult>> call(CreatePdfFileParam param) async {
    try {
      final value = await sl<PdfCreator>()
          .createPdfFromImages(
            param.documentTypes.map((e) => ImageAttachment(e.path, e.image)).toList(),
          )
          .then((value) => value!);
      return Optional.newValue(value);
    } on Exception catch (e, st) {
      return Optional.newError(e, st);
    }
  }
}
