import 'dart:async';

import 'package:document_scanner/core/lib/optional.dart';
import 'package:document_scanner/core/lib/states/validators.dart';
import 'package:document_scanner/core/lib/tuple.dart';
import 'package:document_scanner/core/service_locator/service_locator.dart';
import 'package:document_scanner/core/widgets/bloc_builder/dropdown.dart';
import 'package:document_scanner/core/widgets/bloc_builder/i18n_dropdown.dart';
import 'package:document_scanner/core/widgets/blocs/datetime.dart';
import 'package:document_scanner/scanner/domain/repositories/convert.dart';
import 'package:document_scanner/scanner/domain/repositories/key_values.dart';
import 'package:document_scanner/scanner/domain/usecases/create_pdf_file.dart';
import 'package:document_scanner/scanner/domain/usecases/export_attachment.dart';
import 'package:document_scanner/scanner/domain/usecases/load_list_items.dart';
import 'package:document_scanner/scanner/domain/usecases/read_files.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;

part 'state.dart';

class ScannerBloc extends FormBloc<String, ErrorValue> {
  final displayCropper = InputFieldBloc<bool, String>(initialValue: false);
  String? cropperFilename;
  Uint8List? cropperImage;

  final scannedImages = InputFieldBloc<List<Tuple2<String, Uint8List>>, dynamic>(initialValue: []);
  List<Uint8List?> cachedImages = [];

  final amount = InputFieldBloc<double, dynamic>(initialValue: 1.0);
  final threshold = InputFieldBloc<double, dynamic>(initialValue: 0.5);

  void uploadAttachment(String filename, Uint8List bytes) => main.uploadAttachment(p.basename(filename), bytes);
  void removeAttachment(int index) => main.removeAttachment(index);

  int attachmentCount() => main.attachments.value.length;
  List<AttachmentState> get attachments => main.attachments.value;

  AttachState get main => (state.groupFieldBlocOf("main")! as AttachState);

  final converter = SelectFieldBloc<I18nLabel, dynamic>();

  ScannerBloc() {
    addFieldBlocs(fieldBlocs: [
      AttachState(),
      scannedImages,
      converter,
      threshold,
      amount,
    ]);
    final items = converterItems();
    converter
      ..updateItems(items)
      ..updateInitialValue(items[1]);

    converter.subscribeToFieldBlocs([threshold, amount]);
  }

  Future<bool> validate() {
    return main.validate();
  }

  @override
  FutureOr<void> onSubmitting() async {
    try {
      sl<ExportAttachmentUseCase>()
          .call(ExportAttachmentsParam(
            main.area.value!.technical!,
            main.senderName.value,
            main.receiverName.value!.technical,
            main.documentType.value!.technical!,
            main.documentDate.dateTime!,
            main.attachments.value.map((e) => ExportAttachmentParam(e.value.name, e.value.data)).toList(),
          ))
          .then((_) => main.attachments.value.clear())
          .whenComplete(
            () => emitSuccess(successResponse: "files created", canSubmitAgain: true),
          );
    } on Exception catch (err, stack) {
      emitFailure(failureResponse: ErrorValue(err, stack));
    }
  }

  void storeScanResult(List<String> value, {required void Function() ready}) {
    sl<ReadFilesUseCase>().call(ReadFilesParam(value)).then((value) {
      final list = value.eval();
      scannedImages.updateValue(list);
      clearImageCache();
    }).whenComplete(ready);
  }

  static List<I18nLabel> converterItems() {
    return [
      I18nLabel.build(label: "$original;de:Original;en:Original"),
      I18nLabel.build(label: "$grayscale;de:Graustufen;en:Grayscale"),
      I18nLabel.build(label: "$monochrome;de:Monochrome;en:Monochrome"),
      I18nLabel.build(label: "$luminance;de:Helligkeit;en:Luminance"),
    ];
  }

  Uint8List convertedImage(int index) {
    if (cachedImages[index] == null) {
      emitLoading();

      cachedImages[index] = sl<ImageConverter>().convertImage(
        converter.value!.technical,
        scannedImages.value[index],
        amount: amount.value,
        threshold: threshold.value,
      );

      emitLoaded();
    }

    return cachedImages[index]!;
  }

  Future<void> createPDF() async {
    emitLoading();

    final pdfImageData = <Tuple2<String, Uint8List>>[];
    for (var i = 0, len = scannedImages.value.length; i < len; i++) {
      final image = convertedImage(i);
      pdfImageData.add(Tuple2(scannedImages.value[i].a, image));
    }

    final pdfData = await sl<CreatePdfFileUseCase>().call(
      CreatePdfFileParam(
        pdfImageData.map((e) => AttachmentParam.fromTuple(e)).toList(),
      ),
    );
    uploadAttachment("scan.pdf", pdfData.eval());

    scannedImages.updateValue([]);
    clearImageCache();

    emitLoaded();
  }

  clearScannedImage() {
    scannedImages.updateValue([]);
    cachedImages = [];
  }

  clearImageCache() {
    cachedImages = List.filled(scannedImages.value.length, null);
  }

  void thresholdChanged(double value) {
    threshold.updateValue(value);
    clearImageCache();
  }

  void amountChanged(double value) {
    amount.updateValue(value);
    clearImageCache();
  }

  // TODO! move to usecase->repos->usecase->datasource?
  Future<void> loadCropperImage(XFile? file) async {
    if (file == null) {
      return;
    }

    cropperFilename = file.name;
    cropperImage = await file.readAsBytes();
    displayCropper.changeValue(true);
  }
}
