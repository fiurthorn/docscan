import 'dart:async';
import 'dart:io';

import 'package:document_scanner/core/lib/logger.dart';
import 'package:document_scanner/core/lib/optional.dart';
import 'package:document_scanner/core/lib/tuple.dart';
import 'package:document_scanner/core/service_locator/service_locator.dart';
import 'package:document_scanner/core/states/validators.dart';
import 'package:document_scanner/core/widgets/bloc_builder/dropdown.dart';
import 'package:document_scanner/core/widgets/blocs/datetime.dart';
import 'package:document_scanner/scanner/domain/usecases/read_scanned_files.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:lecle_downloads_path_provider/lecle_downloads_path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:permission_handler/permission_handler.dart';

import '../../../../core/widgets/scanner/scanner.dart';

part 'state.dart';

const original = "Original";
const grayscale = "GrayScale";
const monochrome = "Monochrome";
const luminance = "Luminance";

class ScannerBloc extends FormBloc<String, ErrorValue> {
  final scannedImages = InputFieldBloc<List<Tuple2<String, Uint8List>>, dynamic>(initialValue: []);
  List<Uint8List?> cachedImages = [];

  final amount = InputFieldBloc<double, dynamic>(initialValue: 1.0);
  final threshold = InputFieldBloc<double, dynamic>(initialValue: 0.5);

  void uploadAttachment(String filename, Uint8List bytes) => main.uploadAttachment(filename, bytes);
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
      if (await Permission.manageExternalStorage.request().isGranted) {
        final df = DateFormat("yyyyMMdd");
        final downloadsDirectory = (await DownloadsPath.downloadsDirectory())!;

        final filepath =
            Directory("${downloadsDirectory.path}/Archive/${main.area.value!.technical}/${main.supplierName.value}");

        if (!filepath.existsSync()) {
          filepath.createSync(recursive: true);
        }

        int i = 0;
        for (var element in main.attachments.value) {
          final basename =
              "${filepath.path}/${main.documentType.value!.technical}_${df.format(main.documentDate.dateTime!)}";
          final extension = p.extension(p.basename(element.value.name));
          File file;
          do {
            file = File("$basename${i == 0 ? '' : '-'}${i == 0 ? '' : i}$extension");
            ++i;
          } while (file.existsSync());

          Log.high("filepath: ${file.path}");
          file.writeAsBytesSync(element.value.data);
        }

        keyValues().addSupplierNames(main.supplierName.value);
        clearScannedImage();
        main.attachments.value.clear();
        emitSuccess(successResponse: "files created", canSubmitAgain: true);
      }
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
      final item = scannedImages.value[index];
      final path = item.a;
      final image = item.b;

      switch (converter.value?.technical) {
        case original:
          cachedImages[index] = convertToResize(image);
          break;
        case grayscale:
          cachedImages[index] = convertToGreyScale(image);
          break;
        case monochrome:
          cachedImages[index] = convertToMonochrome(image, amount: amount.value);
          break;
        case luminance:
          cachedImages[index] = convertToLuminance(image, threshold: threshold.value);
          break;
        default:
          cachedImages[index] = convertToResize(image);
      }

      File(path).writeAsBytesSync(cachedImages[index]!);

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

    final pdfData = await createPdf(pdfImageData);
    uploadAttachment("scan.pdf", pdfData!);
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
}
