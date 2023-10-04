import 'dart:async';

import 'package:document_scanner/core/lib/compare/compare.dart';
import 'package:document_scanner/core/lib/logger.dart';
import 'package:document_scanner/core/lib/optional.dart';
import 'package:document_scanner/core/lib/tuple.dart';
import 'package:document_scanner/core/reactive/bloc.dart';
import 'package:document_scanner/core/reactive/i18n_label.dart';
import 'package:document_scanner/core/reactive/validators/required.dart';
import 'package:document_scanner/core/service_locator/service_locator.dart';
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
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reactive_forms/reactive_forms.dart';

part 'state.dart';

class ScannerBloc extends ReactiveBloc<StateParameter> implements GoRouteAware {
  final area = FormControl<I18nLabel>(validators: [const CustomRequiredValidator()]);
  final senderName = FormControl<String>(validators: [Validators.required]);
  final receiverName = FormControl<I18nLabel>(validators: [const CustomRequiredValidator()]);
  final documentType = FormControl<I18nLabel>(validators: [const CustomRequiredValidator()]);
  final documentDate = FormControl<DateTime>(validators: [Validators.required]);

  final converter = FormControl<I18nLabel>();

  final attachments = FormArray<FileAttachment>([], validators: [Validators.minLength(1)]);

  final _currentScannedImageController = StreamController<Uint8List?>.broadcast();
  Stream<Uint8List?> get currentScannedImageStream => _currentScannedImageController.stream;
  Sink<Uint8List?> get currentScannedImageSink => _currentScannedImageController.sink;

  ScannerBloc() : super(parameter: const StateParameter()) {
    sl<GoRouterObserver>().subscribe(this);
  }

  Map<String, AbstractControl>? _form;

  @override
  Map<String, AbstractControl> get form => _form ??= {
        "area": area,
        "documentType": documentType,
        "senderName": senderName,
        "receiverName": receiverName,
        "documentDate": documentDate,
        "attachments": attachments,
        "converter": converter,
      };

  @override
  Future<void> loading() async {
    emitUpdate(
        parameter: state.parameter.copyWith(
      areaItems: _i18nItems(KeyValueNames.areas),
      senderItems: _plainItems(KeyValueNames.senderNames),
      receiverItems: _i18nItems(KeyValueNames.receiverNames),
      docTypeItems: _i18nItems(KeyValueNames.documentTypes),
    ));

    converter.updateValue(converterItems()[1]);
  }

  List<String> _plainItems(KeyValueNames key) {
    return _items(key)
      ..sort(compare)
      ..insert(0, "");
  }

  List<I18nLabel> _i18nItems(KeyValueNames key) {
    return _items(key).map((element) => I18nLabel.build(label: element)).toList()
      ..sort(compareLabel)
      ..insert(0, I18nLabel.empty);
  }

  List<String> _items(KeyValueNames key) {
    return syncUsecase<LoadListItemsResult, LoadListItemsParam>(LoadListItemsParam(key));
  }

  @override
  Future<void> close() {
    sl<GoRouterObserver>().unsubscribe(this);
    return super.close();
  }

  @override
  void didPop(String? name, String? previousName) {
    Log.high("didPop $name $previousName");

    if (previousName == "/scanner") {
      switch (name) {
        case "/areas":
          emitUpdate(parameter: state.parameter.copyWith(areaItems: _i18nItems(KeyValueNames.areas)));
          break;
        case "/senders":
          emitUpdate(parameter: state.parameter.copyWith(senderItems: _plainItems(KeyValueNames.senderNames)));
          break;
        case "/receivers":
          emitUpdate(parameter: state.parameter.copyWith(receiverItems: _i18nItems(KeyValueNames.receiverNames)));
          break;
        case "/documentTypes":
          emitUpdate(parameter: state.parameter.copyWith(docTypeItems: _i18nItems(KeyValueNames.documentTypes)));
          break;
      }
    }
  }

  @override
  void didPush(String? name, String? previousName) {
    // Log.high("didPush $name $previousName");
  }

  List<I18nLabel> converterItems() {
    return [
      I18nLabel.build(label: "$original;de:Original;en:Original"),
      I18nLabel.build(label: "$grayscale;de:Graustufen;en:Grayscale"),
      I18nLabel.build(label: "$monochrome;de:Monochrome;en:Monochrome"),
      I18nLabel.build(label: "$luminance;de:Helligkeit;en:Luminance"),
    ];
  }

  void showCropper() => emit(UpdateReactiveState(parameter: state.parameter.copyWith(showCropper: true)));
  void hideCropper() => emit(UpdateReactiveState(parameter: state.parameter.copyWith(showCropper: false)));

  submit() {
    emitSubmitting();

    try {
      usecase<ExportAttachmentResult, ExportAttachmentsParam>(ExportAttachmentsParam(
        area.value!.technical!,
        senderName.value!,
        receiverName.value!.technical,
        documentType.value!.technical!,
        documentDate.value!,
        attachments.value!.map((e) => e!).map((e) => ExportAttachmentParam(e.name, e.data)).toList(),
      ))
          .then(
            (_) => attachments.clear(),
          )
          .whenComplete(
            () => emitSuccess(
              successResponse: "files created",
              parameter: state.parameter.copyWith(
                scannedImages: [],
                cachedImages: [],
              ),
            ),
          );
    } on Exception catch (err, stack) {
      emitFailure(failureResponse: ErrorValue(err, stack));
    }
  }

  void storeScanResult(List<String> value) {
    if (value.isNotEmpty) {
      usecase<ReadFilesResult, ReadFilesParam>(ReadFilesParam(value)).then((value) {
        emitUpdate(
          parameter: state.parameter.copyWith(
            currentScannedImage: 0,
            scannedImages: value,
            cachedImages: List.filled(value.length, null),
          ),
        );
      }).then((value) => updateConvertedImage());
    }
  }

  void removeAttachment(int index) {
    attachments.removeAt(index);
    attachments.markAsDirty();
  }

  void uploadAttachment(String filename, Uint8List bytes) {
    final value = FileAttachment(filename, bytes, bytes.length);
    attachments.add(FormControl<FileAttachment>(value: value));
    attachments.markAsDirty();
    emit(UpdateReactiveState(parameter: state.parameter));
  }

  loadCropperImage(XFile? file) async {
    emitLoading();
    if (file == null) {
      return;
    }

    final content = await sl<FileRepos>().readXFile(file);
    emitLoaded(
      parameter: state.parameter.copyWith(
        cropperFilename: content.a,
        cropperImage: content.b,
        showCropper: true,
      ),
    );
  }

  void counterClockwise() => _rotate(true);
  void clockwise() => _rotate(false);

  void _rotate(bool counterClockwise) {
    currentScannedImageSink.add(null);
    final index = state.parameter.currentScannedImage;
    final currentScanned = state.parameter.scannedImages[index];
    usecase<Uint8List, RotateImageParam>(RotateImageParam(currentScanned.b, counterClockwise))
        .then((value) => state.parameter.scannedImages[index] = Tuple2(currentScanned.a, value))
        .then((_) => state.parameter.cachedImages[index] = null)
        .then((_) => updateConvertedImage())
        .then(
          (_) => emitUpdate(
            parameter: state.parameter.copyWith(
              scannedImages: state.parameter.scannedImages,
              cachedImages: state.parameter.cachedImages,
            ),
          ),
        );
  }

  Future<void> createPDF() async {
    emitLoading();

    final futures = List.generate(state.parameter.scannedImages.length, (index) => index);
    await Future.forEach(
      futures,
      (index) => convertedImage(index).then(
        (value) => Log.norm("pdf converted #${value + 1}"),
      ),
    );

    final pdfImageData = <Tuple2<String, Uint8List>>[];
    for (var i = 0, len = state.parameter.scannedImages.length; i < len; i++) {
      pdfImageData.add(Tuple2(
        state.parameter.scannedImages[i].a,
        state.parameter.cachedImages[i]!,
      ));
    }

    final pdfData = await usecase<CreatePdfFileResult, CreatePdfFileParam>(
      CreatePdfFileParam(
        pdfImageData.map((e) => AttachmentParam.fromTuple(e)).toList(),
      ),
    );
    uploadAttachment("scan.pdf", pdfData);

    emitLoaded(
      parameter: state.parameter.copyWith(
        currentScannedImage: 0,
        scannedImages: [],
        cachedImages: [],
      ),
    );
  }

  clearImageCache() {
    currentScannedImageSink.add(null);
    emitUpdate(
      parameter: state.parameter.copyWith(
        cachedImages: List.filled(state.parameter.scannedImages.length, null),
      ),
    );
  }

  Future<int> convertedImage(int index) {
    if (state.parameter.cachedImages[index] != null) return Future.value(index);

    return usecase<ConvertImageResult, ConvertImageParam>(ConvertImageParam(
      converter: converter.value!.technical,
      item: state.parameter.scannedImages[index],
      amount: state.parameter.amount,
      threshold: state.parameter.threshold,
    )).then((value) => state.parameter.cachedImages[index] = value).then((value) => index);
  }

  void updateConvertedImage() {
    final index = state.parameter.currentScannedImage;
    _currentScannedImageController.sink.add(null);

    if (state.parameter.cachedImages[index] != null) {
      _currentScannedImageController.sink.add(state.parameter.cachedImages[index]!);
    }

    usecase<ConvertImageResult, ConvertImageParam>(ConvertImageParam(
      converter: converter.value!.technical,
      item: state.parameter.scannedImages[index],
      amount: state.parameter.amount,
      threshold: state.parameter.threshold,
    )) //
        .then(
          (value) => emitUpdate(
            parameter: state.parameter.copyWith(
              cachedImages: state.parameter.cachedImages.copyWithIndexValue(index, value),
            ),
          ),
        )
        .then((_) => _currentScannedImageController.sink.add(state.parameter.cachedImages[index]!));
  }

  updateCurrentScannedImage(int index) {
    emitUpdate(parameter: state.parameter.copyWith(currentScannedImage: index));
    updateConvertedImage();
  }

  bool shouldShowWhatsNew() => sl<KeyValues>().hasNewBuildNumber();

  closedWhatsNew() => sl<KeyValues>().resetBuildNumber();

  void amountChanged(double value) {
    emitUpdate(parameter: state.parameter.copyWith(amount: value));
    clearImageCache();
    updateConvertedImage();
  }

  void thresholdChanged(double value) {
    emitUpdate(parameter: state.parameter.copyWith(threshold: value));
    clearImageCache();
    updateConvertedImage();
  }

  updateConverter(FormControl<I18nLabel> value) {
    clearImageCache();
    updateConverter(value);
  }
}

extension CopyWithIndexValue<T> on List<T> {
  List<T> copyWithIndexValue(int index, T value) {
    final result = List<T>.from(this);
    result[index] = value;
    return result;
  }
}
