import 'package:document_scanner/core/lib/optional.dart';
import 'package:document_scanner/core/lib/tuple.dart';
import 'package:document_scanner/core/service_locator/service_locator.dart';
import 'package:document_scanner/scanner/domain/repositories/pdf.dart';
import 'package:document_scanner/scanner/domain/usecases/usecase.dart';
import 'package:flutter/foundation.dart';

export 'call.dart';

class AttachmentParam extends Tuple2<String, Uint8List> {
  String get path => a;
  Uint8List get image => b;

  const AttachmentParam(String path, Uint8List image) : super(path, image);

  AttachmentParam.fromTuple(Tuple2<String, Uint8List> t) : this(t.a, t.b);
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
            param.documentTypes.map((e) => ImageAttachment.fromTuple(e)).toList(),
          )
          .then((value) => value!);
      return Optional.newValue(value);
    } on Exception catch (e, st) {
      return Optional.newError(e, st);
    }
  }
}
