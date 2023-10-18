import 'dart:async';

import 'package:crop_your_image/crop_your_image.dart';
import 'package:document_scanner/core/lib/compare/compare.dart';
import 'package:document_scanner/core/lib/either.dart';
import 'package:document_scanner/core/lib/logger.dart';
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
import 'package:document_scanner/scanner/domain/usecases/read_file.dart';
import 'package:document_scanner/scanner/domain/usecases/read_files.dart';
import 'package:document_scanner/scanner/domain/usecases/rotate_image.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reactive_forms/reactive_forms.dart';

part 'bloc.freezed.dart';

@freezed
class StateParameter with _$StateParameter {
  const factory StateParameter({
    String? cropperFilename,
    Uint8List? cropperImage,
    @Default(0) int currentScannedImage,
    @Default(false) bool showCropper,
    @Default(false) bool showScanner,
    @Default(false) bool cropperImageLocked,
    @Default([]) List<I18nLabel> areaItems,
    @Default([]) List<String> senderItems,
    @Default([]) List<I18nLabel> receiverItems,
    @Default([]) List<I18nLabel> docTypeItems,
    @Default([]) List<FileAttachment> scannedImages,
    @Default([]) List<Uint8List?> cachedImages,
  }) = _StateParameter;
}

@freezed
class FileAttachment with _$FileAttachment {
  factory FileAttachment(
    String name,
    Uint8List data,
    int size,
  ) = $FileAttachment;
}

class ScannerBloc extends ReactiveBloc<StateParameter> implements GoRouteAware {
  static const String scan = "scan";

  final area = FormControl<I18nLabel>(validators: [const CustomRequiredValidator()]);
  final senderName = FormControl<String>(validators: [Validators.required]);
  final receiverName = FormControl<I18nLabel>(validators: [const CustomRequiredValidator()]);
  final documentType = FormControl<I18nLabel>(validators: [const CustomRequiredValidator()]);
  final documentDate = FormControl<DateTime>(validators: [Validators.required]);

  final converter = FormControl<I18nLabel>();

  final amount = FormControl<double>(value: 1.0);
  final threshold = FormControl<double>(value: 0.5);
  final converting = FormControl<bool>(value: false);
  final progress = FormControl<int>();

  final attachments = FormArray<FileAttachment>([], validators: [Validators.minLength(1)]);

  final cropController = CropController();

  final _currentScannedImageController = StreamController<Uint8List?>.broadcast();
  Stream<Uint8List?> get currentScannedImageStream => _currentScannedImageController.stream;
  Sink<Uint8List?> get currentScannedImageSink => _currentScannedImageController.sink;
  StreamSubscription? imageChanged;

  ScannerBloc() : super(parameter: const StateParameter()) {
    sl<GoRouterObserver>().subscribe(this);
    imageChanged = currentScannedImageStream.listen((event) {
      if (event == null) {
        converter.markAsDisabled();
        amount.markAsDisabled();
        threshold.markAsDisabled();
        converting.updateValue(true);
      } else {
        converter.markAsEnabled();
        amount.markAsEnabled();
        threshold.markAsEnabled();
        converting.updateValue(false);
      }
    });
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
        "amount": amount,
        "threshold": threshold,
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

    converter.updateValue(converterItems().firstWhere((item) => item.technical == grayscale));
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
    imageChanged?.cancel();
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

  void showCropper() => emitUpdate(
          parameter: state.parameter.copyWith(
        showCropper: true,
        cropperImageLocked: false,
      ));

  void hideCropper() => emitUpdate(
          parameter: state.parameter.copyWith(
        showCropper: false,
        cropperImageLocked: false,
      ));

  submit() {
    emitProgress();

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
            () => emitProgressSuccess(
              progressIndicator: scan,
              successResponse: "files created",
              parameter: state.parameter.copyWith(
                scannedImages: [],
                cachedImages: [],
              ),
            ),
          );
    } on Exception catch (err, stack) {
      emitProgressFailureError(failureResponse: Failure(err, stack));
    }
  }

  void storeScanResult(List<String> value) {
    if (value.isNotEmpty) {
      usecase<ReadFilesResult, ReadFilesParam>(ReadFilesParam(value)).then((value) {
        emitUpdate(
          parameter: state.parameter.copyWith(
            currentScannedImage: 0,
            scannedImages: value.map((e) => FileAttachment(e.name, e.data, e.data.length)).toList(),
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

  void uploadCropperImage(Uint8List image) {
    try {
      emitProgress();
      hideCropper();
      uploadAttachment(state.parameter.cropperFilename!, image);
      emitProgressSuccess();
    } on Exception catch (err, stack) {
      emitProgressFailureError(failureResponse: Failure(err, stack));
    }
  }

  void uploadFilePickerFile(String filename) {
    try {
      emitProgress();
      usecase<ReadFileResult, ReadFileParam>(ReadFileParam(filename))
          .then((value) => uploadAttachment(value.name, value.data));
      emitProgressSuccess();
    } on Exception catch (err, stack) {
      emitProgressFailureError(failureResponse: Failure(err, stack));
    }
  }

  void uploadAttachment(String filename, Uint8List bytes) {
    final value = FileAttachment(filename, bytes, bytes.length);
    attachments.add(FormControl<FileAttachment>(value: value));
    attachments.markAsDirty();
    emitUpdate(parameter: state.parameter);
  }

  loadCropperImage(XFile? file) async {
    if (file == null) {
      return;
    }

    final content = await sl<FileRepos>().readXFile(file);
    emitUpdate(
      parameter: state.parameter.copyWith(
        cropperFilename: content.name,
        cropperImage: content.data,
        showCropper: true,
      ),
    );
  }

  void counterClockwise() => _rotate(true);
  void clockwise() => _rotate(false);

  void _rotate(bool counterClockwise) {
    currentScannedImageSink.add(null);

    final index = state.parameter.currentScannedImage;
    final scannedImages = List.of(state.parameter.scannedImages);
    final cachedImages = List.of(state.parameter.cachedImages);

    usecase<Uint8List, RotateImageParam>(RotateImageParam(scannedImages[index].data, counterClockwise))
        .then((value) => scannedImages[index] = FileAttachment(
              scannedImages[index].name,
              value,
              value.length,
            ))
        .then((_) => cachedImages[index] = null)
        .then((_) => updateConvertedImage())
        .then(
          (_) => emitUpdate(
            parameter: state.parameter.copyWith(
              scannedImages: scannedImages,
              cachedImages: cachedImages,
            ),
          ),
        );
  }

  Future<void> createPDF() async {
    progress.updateValue(0);
    emitProgress(progress: progress, max: state.parameter.scannedImages.length);

    final futures = List.generate(state.parameter.scannedImages.length, (index) => index);
    await Future.forEach(
      futures,
      (index) => convertedImage(index).then(
        (value) {
          progress.updateValue(value);
          return Log.norm("pdf converted #${value + 1}");
        },
      ),
    )
        .then((value) => <FileAttachment>[])
        .then((pdfImageData) {
          for (var i = 0, len = state.parameter.scannedImages.length; i < len; i++) {
            pdfImageData.add(FileAttachment(
              state.parameter.scannedImages[i].name,
              state.parameter.cachedImages[i]!,
              state.parameter.cachedImages[i]!.length,
            ));
          }
          return pdfImageData;
        })
        .then((pdfImageData) => usecase<CreatePdfFileResult, CreatePdfFileParam>(
              CreatePdfFileParam(
                pdfImageData.map((e) => AttachmentParam(e.name, e.data)).toList(),
              ),
            ))
        .then(
          (pdfData) => uploadAttachment("scan.pdf", pdfData),
        )
        .then((value) => progress.updateValue(state.parameter.scannedImages.length))
        .whenComplete(() => emitProgressSuccess(
              parameter: state.parameter.copyWith(
                currentScannedImage: 0,
                scannedImages: [],
                cachedImages: [],
              ),
            ))
        .catchError((err, stackTrace) => emitProgressFailureError(failureResponse: Failure(err, stackTrace)));
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

    final item = state.parameter.scannedImages[index];
    return usecase<ConvertImageResult, ConvertImageParam>(ConvertImageParam(
      converter: converter.value!.technical,
      itemName: item.name,
      itemData: item.data,
      amount: amount.value!,
      threshold: threshold.value!,
    )).then((value) => state.parameter.cachedImages[index] = value).then((value) => index);
  }

  void updateConvertedImage() {
    final index = state.parameter.currentScannedImage;
    _currentScannedImageController.sink.add(null);

    if (state.parameter.cachedImages[index] != null) {
      _currentScannedImageController.sink.add(state.parameter.cachedImages[index]!);
    }

    final item = state.parameter.scannedImages[index];
    usecase<ConvertImageResult, ConvertImageParam>(ConvertImageParam(
      converter: converter.value!.technical,
      itemName: item.name,
      itemData: item.data,
      amount: amount.value!,
      threshold: threshold.value!,
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

  void amountChanged() {
    clearImageCache();
    updateConvertedImage();
  }

  void thresholdChanged() {
    clearImageCache();
    updateConvertedImage();
  }

  updateConverter(FormControl<I18nLabel> value) {
    clearImageCache();
    updateConvertedImage();
  }

  void toggleCropperImageLock() {
    emitUpdate(parameter: state.parameter.copyWith(cropperImageLocked: !state.parameter.cropperImageLocked));
  }

  List<String> filterSenderItems(String text) {
    if (text.isEmpty) {
      return state.parameter.senderItems;
    } else {
      return state.parameter.senderItems
          .where((element) => element.toLowerCase().contains(text.toLowerCase()))
          .toList();
    }
  }
}

extension CopyWithIndexValue<T> on List<T> {
  List<T> copyWithIndexValue(int index, T value) {
    final result = List<T>.from(this);
    result[index] = value;
    return result;
  }
}
