import 'dart:async';

import 'package:document_scanner/core/lib/optional.dart';
import 'package:document_scanner/core/lib/states/validators.dart';
import 'package:document_scanner/core/lib/tuple.dart';
import 'package:document_scanner/core/service_locator/service_locator.dart';
import 'package:document_scanner/core/widgets/bloc_builder/dropdown.dart';
import 'package:document_scanner/core/widgets/bloc_builder/i18n_dropdown.dart';
import 'package:document_scanner/core/widgets/blocs/datetime.dart';
import 'package:document_scanner/core/widgets/goroute/route.dart';
import 'package:document_scanner/scanner/domain/repositories/convert.dart';
import 'package:document_scanner/scanner/domain/repositories/file_repos.dart';
import 'package:document_scanner/scanner/domain/repositories/key_values.dart';
import 'package:document_scanner/scanner/domain/usecases/convert_image.dart';
import 'package:document_scanner/scanner/domain/usecases/create_pdf_file.dart';
import 'package:document_scanner/scanner/domain/usecases/export_attachment.dart';
import 'package:document_scanner/scanner/domain/usecases/load_list_items.dart';
import 'package:document_scanner/scanner/domain/usecases/read_files.dart';
import 'package:document_scanner/scanner/domain/usecases/rotate_image.dart';
import 'package:document_scanner/scanner/presentation/screens/scanner/page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;

part 'state.dart';

class ScannerBloc extends FormBloc<String, ErrorValue> implements GoRouteAware {
  final displayCropper = InputFieldBloc<bool, String>(initialValue: false);
  String? cropperFilename;
  Uint8List? cropperImage;

  final scannedImages = InputFieldBloc<List<Tuple2<String, Uint8List>>, dynamic>(initialValue: []);
  List<Uint8List?> cachedImages = [];

  final amount = InputFieldBloc<double, dynamic>(initialValue: 1.0);
  final threshold = InputFieldBloc<double, dynamic>(initialValue: 0.5);
  int currentImage = 0;

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

    sl<GoRouterObserver>().subscribe(this);
  }

  Future<bool> validate() {
    return main.validate();
  }

  @override
  FutureOr<void> onSubmitting() async {
    try {
      usecase<ExportAttachmentResult, ExportAttachmentsParam>(ExportAttachmentsParam(
        main.area.value!.technical!,
        main.senderName.value,
        main.receiverName.value!.technical,
        main.documentType.value!.technical!,
        main.documentDate.dateTime!,
        main.attachments.value.map((e) => ExportAttachmentParam(e.value.name, e.value.data)).toList(),
      ))
          .then(
            (_) => main.attachments.value.clear(),
          )
          .whenComplete(
            () => emitSuccess(successResponse: "files created", canSubmitAgain: true),
          );
    } on Exception catch (err, stack) {
      emitFailure(failureResponse: ErrorValue(err, stack));
    }
  }

  void storeScanResult(List<String> value, {required void Function() ready}) {
    usecase<ReadFilesResult, ReadFilesParam>(ReadFilesParam(value)).then((value) {
      scannedImages.updateValue(value);
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

  Future<Uint8List> convertedImage(int index) {
    if (cachedImages[index] == null) {
      emitLoading();

      return usecase<ConvertImageResult, ConvertImageParam>(ConvertImageParam(
        converter: converter.value!.technical,
        item: scannedImages.value[index],
        amount: amount.value,
        threshold: threshold.value,
      )).then((value) => cachedImages[index] = value).then((_) => emitLoaded()).then((_) => cachedImages[index]!);
    }

    return Future.sync(() => cachedImages[index]!);
  }

  updateReceiverNames() => main.updateReceiverNames();
  updateDocumentTypeItems() => main.updateDocumentTypeItems();
  updateAreaItems() => main.updateAreaItems();

  Future<void> createPDF() async {
    emitLoading();

    final pdfImageData = <Tuple2<String, Uint8List>>[];
    for (var i = 0, len = scannedImages.value.length; i < len; i++) {
      final image = await convertedImage(i);
      pdfImageData.add(Tuple2(scannedImages.value[i].a, image));
    }

    final pdfData = await usecase<CreatePdfFileResult, CreatePdfFileParam>(
      CreatePdfFileParam(
        pdfImageData.map((e) => AttachmentParam.fromTuple(e)).toList(),
      ),
    );
    uploadAttachment("scan.pdf", pdfData);

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

  void counterClockwise() => _rotate(true);

  void clockwise() => _rotate(false);

  void _rotate(bool counterClockwise) {
    emitLoading();

    final current = scannedImages.value[currentImage];
    final filename = current.a;
    usecase<Uint8List, RotateImageParam>(RotateImageParam(current.b, true))
        .then((value) {
          scannedImages.value[currentImage] = Tuple2(filename, value);
        })
        .then((_) => clearImageCache())
        .then((_) => usecase<ConvertImageResult, ConvertImageParam>(ConvertImageParam(
              converter: converter.value!.technical,
              item: scannedImages.value[currentImage],
              amount: amount.value,
              threshold: threshold.value,
            )))
        .then((value) => cachedImages[currentImage] = value)
        .then((_) => emitLoaded());
  }

  void amountChanged(double value) {
    amount.updateValue(value);
    clearImageCache();
  }

  Future<void> loadCropperImage(XFile? file) async {
    if (file == null) {
      return;
    }

    final content = await sl<FileRepos>().readXFile(file);
    cropperFilename = content.a;
    cropperImage = content.b;
    displayCropper.changeValue(true);
  }

  @override
  void didPop(String? name, String? previousName) {
    if (previousName == ScannerScreen.path) {
      updateAreaItems();
      updateDocumentTypeItems();
      updateReceiverNames();
    }
  }

  @override
  void didPush(String? name, String? previousName) {}

  @override
  Future<void> close() {
    sl<GoRouterObserver>().unsubscribe(this);
    return super.close();
  }

  closedWhatsNew() => sl<KeyValues>().resetBuildNumber();

  bool shouldShowWhatsNew() => sl<KeyValues>().hasNewBuildNumber();
}
