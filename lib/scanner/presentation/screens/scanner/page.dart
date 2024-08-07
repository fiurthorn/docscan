import 'package:crop_your_image/crop_your_image.dart';
import 'package:cunning_document_scanner/cunning_document_scanner.dart';
import 'package:document_scanner/core/design/theme_colors.dart';
import 'package:document_scanner/core/design/theme_icons.dart';
import 'package:document_scanner/core/lib/size.dart';
import 'package:document_scanner/core/reactive/i18n_label.dart';
import 'package:document_scanner/core/toaster/failure.dart';
import 'package:document_scanner/core/widgets/confirm/confirm.dart';
import 'package:document_scanner/core/widgets/goroute/route.dart';
import 'package:document_scanner/core/widgets/reactive/autocomplete.dart';
import 'package:document_scanner/core/widgets/reactive/floating_action_button.dart';
import 'package:document_scanner/core/widgets/responsive.dart';
import 'package:document_scanner/l10n/app_lang.dart';
import 'package:document_scanner/scanner/domain/repositories/convert.dart';
import 'package:document_scanner/scanner/presentation/blocs/scanner/bloc.dart';
import 'package:document_scanner/scanner/presentation/screens/base/app_bar.dart';
import 'package:document_scanner/scanner/presentation/screens/base/scanner_scareen_sate.dart';
import 'package:document_scanner/scanner/presentation/screens/base/screen.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pdfx/pdfx.dart';
import 'package:reactive_date_time_picker/reactive_date_time_picker.dart';
import 'package:reactive_forms/reactive_forms.dart';

class ScannerScreen extends Screen {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();

  static const String path = '/scanner';

  static AuthGoRoute get route => AuthGoRoute.unauthorized(
        path: path,
        name: path,
        child: (context, state) => const ScannerScreen(),
      );
}

class _ScannerScreenState extends ScannerScreenState<ScannerScreen, ScannerBloc> {
  @override
  ScannerBloc createBloc(BuildContext context) => ScannerBloc();

  @override
  String title(BuildContext context) => "Scanner";

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) {
    if (bloc.state.parameter.showCropper) {
      return cropTopNavBar();
    }

    return super.buildAppBar(context);
  }

  PreferredSizeWidget cropTopNavBar() => CustomButtonAppBar(
        title: title(context),
        button: Row(
          children: [
            InkWell(
              onTap: bloc.hideCropper,
              child: Center(
                child: Icon(
                  ThemeIcons.close,
                ),
              ),
            ),
          ],
        ),
      );

  @override
  Widget? buildEndDrawer(BuildContext context) {
    if (bloc.state.parameter.showCropper) {
      return null;
    }

    return super.buildEndDrawer(context);
  }

  @override
  Widget buildScreen(BuildContext context) {
    if (bloc.state.parameter.scannedImages.isNotEmpty) {
      if (bloc.state.parameter.showPdfSorter) {
        return buildImageEnhancementSortingViewer(context);
      } else {
        return buildImageEnhancementViewer(context);
      }
    }

    if (bloc.state.parameter.showCropper) {
      return cropper(context);
    }

    return buildScannerForm(context);
  }

  Widget buildScannerForm(BuildContext context) {
    return ResponsiveWidthPadding(
      SingleChildScrollView(
        primary: true,
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            children: [
              ReactiveDropdownField<I18nLabel>(
                items: bloc.state.parameter.areaItems
                    .map((e) => DropdownMenuItem<I18nLabel>(value: e, child: Text(e.label)))
                    .toList(),
                formControl: bloc.area,
                decoration: InputDecoration(
                  labelText: AppLang.i18n.scanner_areaSelect_label,
                  hintText: AppLang.i18n.scanner_areaSelect_hint,
                ),
              ),
              ReactiveAutocomplete<String>(
                formControl: bloc.senderName,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: AppLang.i18n.scanner_senderField_label,
                  hintText: AppLang.i18n.scanner_senderField_hint,
                ),
                optionsBuilder: (value) => bloc.filterSenderItems(value.text),
              ),
              ReactiveDropdownField<I18nLabel>(
                items: bloc.state.parameter.receiverItems
                    .map((e) => DropdownMenuItem<I18nLabel>(value: e, child: Text(e.label)))
                    .toList(),
                formControl: bloc.receiverName,
                decoration: InputDecoration(
                  labelText: AppLang.i18n.scanner_receiverField_label,
                  hintText: AppLang.i18n.scanner_receiverField_hint,
                ),
              ),
              ReactiveDropdownField<I18nLabel>(
                items: bloc.state.parameter.docTypeItems
                    .map((e) => DropdownMenuItem<I18nLabel>(value: e, child: Text(e.label)))
                    .toList(),
                formControl: bloc.documentType,
                decoration: InputDecoration(
                  labelText: AppLang.i18n.scanner_docTypeSelect_label,
                  hintText: AppLang.i18n.scanner_docTypeSelect_hint,
                ),
              ),
              ReactiveDateTimePicker(
                formControl: bloc.documentDate,
                firstDate: DateTime.now().subtract(const Duration(days: 36530)),
                lastDate: DateTime.now().add(const Duration(days: 3653)),
                decoration: InputDecoration(
                  labelText: AppLang.i18n.scanner_docDateField_label,
                  hintText: AppLang.i18n.scanner_docDateField_label,
                ),
              ),
              const SizedBox(height: 20),
              ReactiveFormArray(
                formArray: bloc.attachments,
                builder: (BuildContext context, FormArray<dynamic> formArray, Widget? child) {
                  return ListView.builder(
                    key: ValueKey(formArray.controls),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: bloc.attachments.controls.length,
                    itemBuilder: attachmentItemBuilder(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  List<Widget>? buildPersistentFooterButtons(BuildContext context) {
    if (bloc.state.parameter.showCropper) {
      return buildPersistentCropperFooterButtons(context);
    }

    if (bloc.state.parameter.scannedImages.isNotEmpty) {
      if (bloc.state.parameter.showPdfSorter) {
        return buildPersistentSortingFooterButtons(context);
      } else {
        return buildPersistentConverterFooterButtons(context);
      }
    }

    return buildPersistentScannerFooterButtons(context);
  }

  List<Widget>? buildPersistentCropperFooterButtons(BuildContext context) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          FloatingActionButton(
            heroTag: "scanner_crop_lock",
            onPressed: bloc.toggleCropperImageLock,
            backgroundColor: bloc.state.parameter.cropperImageLocked ? null : nord12AuroraOrange,
            child: Icon(!bloc.state.parameter.cropperImageLocked ? ThemeIcons.lock : ThemeIcons.lockOpen),
          ),
          FloatingActionButton(
            heroTag: "scanner_crop",
            onPressed: bloc.state.parameter.cropperImageLocked ? bloc.cropController.crop : null,
            backgroundColor: bloc.state.parameter.cropperImageLocked ? nord12AuroraOrange : nord3PolarNight,
            child: Icon(ThemeIcons.check),
          ),
        ],
      )
    ];
  }

  List<Widget>? buildPersistentConverterFooterButtons(BuildContext context) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              ReactiveFormField(
                formControl: bloc.converting,
                builder: (context) => FloatingActionButton(
                  heroTag: "scanner_counterClockwise_pdf",
                  onPressed: bloc.converting.value! ? null : bloc.counterClockwise,
                  child: Icon(ThemeIcons.counterClockwise),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              ReactiveFormField(
                formControl: bloc.converting,
                builder: (context) => FloatingActionButton(
                  heroTag: "scanner_clockwise_pdf",
                  onPressed: bloc.converting.value! ? null : bloc.clockwise,
                  child: Icon(ThemeIcons.clockwise),
                ),
              ),
            ],
          ),
          ReactiveFormField(
            formControl: bloc.converting,
            builder: (context) => FloatingActionButton(
              heroTag: "scanner_btn_pdf",
              onPressed: () => bloc.converting.value! ? null : bloc.createPDF(),
              child: Icon(ThemeIcons.filePDF),
            ),
          ),
        ],
      )
    ];
  }

  List<Widget>? buildPersistentSortingFooterButtons(BuildContext context) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              ReactiveFormField(
                formControl: bloc.converting,
                builder: (context) => FloatingActionButton(
                  heroTag: "scanner_up_pdf",
                  onPressed: bloc.converting.value! || bloc.parameter.currentScannedImage == 0 //
                      ? null
                      : bloc.up,
                  child: Icon(ThemeIcons.up),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              ReactiveFormField(
                formControl: bloc.converting,
                builder: (context) => FloatingActionButton(
                  heroTag: "scanner_down_pdf",
                  onPressed: bloc.converting.value! ||
                          bloc.parameter.currentScannedImage + 1 == bloc.parameter.scannedImages.length //
                      ? null
                      : bloc.down,
                  disabledElevation: 5,
                  child: Icon(ThemeIcons.down),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              scannerButton(true),
            ],
          ),
          ReactiveFormField(
            formControl: bloc.converting,
            builder: (context) => FloatingActionButton(
              heroTag: "scanner_btn_convert",
              onPressed: () => bloc.converting.value! ? null : bloc.convertPDF(),
              child: Icon(ThemeIcons.fileExport),
            ),
          ),
        ],
      )
    ];
  }

  List<Widget>? buildPersistentScannerFooterButtons(BuildContext context) {
    return [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                scannerButton(),
                const SizedBox(width: 8),
                filePickerButton(),
                const SizedBox(width: 8),
                cameraButton(),
              ],
            ),
            sendButton(context),
          ],
        ),
      ),
    ];
  }

  void dirty(BuildContext context) {
    if (bloc.attachments.controls.isEmpty) {
      showSnackBarFailure(context, AppLang.i18n.scanner_noAttachment_hint);
    }

    bloc.validate();
  }

  void submit(BuildContext context) => bloc.submit();

  Widget sendButton(BuildContext context) {
    return ReactiveFloatingActionButton(
      heroTag: "scanner_btn_send",
      validBackgroundColor: nord12AuroraOrange,
      backgroundColor: Theme.of(context).floatingActionButtonTheme.backgroundColor,
      onPressed: (group) => group.valid ? submit(context) : dirty(context),
      child: Icon(ThemeIcons.send),
    );
  }

  Widget scannerButton([bool add = false]) {
    return FloatingActionButton(
      heroTag: "scanner_btn_scanner",
      onPressed: () async {
        CunningDocumentScanner.getPictures(true).then((value) {
          if (value != null) {
            bloc.storeScanResult(value, add: add);
          }
        });
      },
      child: Icon(add ? ThemeIcons.fileAdd : ThemeIcons.scanner),
    );
  }

  Widget filePickerButton() {
    return FloatingActionButton(
      heroTag: "scanner_btn_filePicker",
      onPressed: () async {
        FilePicker.platform
            .pickFiles(
              allowMultiple: false,
              dialogTitle: "Choose a file",
            )
            .then((result) => result?.files.single.path)
            .then(
          (path) {
            if (path != null) {
              bloc.uploadFilePickerFile(path);
            }
          },
        );
      },
      child: Icon(ThemeIcons.file),
    );
  }

  Widget cameraButton() {
    return FloatingActionButton(
      heroTag: "scanner_btn_camera",
      onPressed: () => camera(
        source: ImageSource.camera,
        maxHeight: 2048,
        maxWidth: 2048,
        imageQuality: 66,
      ),
      child: Icon(ThemeIcons.camera),
    );
  }

  void camera({
    ImageSource source = ImageSource.gallery,
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
  }) {
    ImagePicker()
        .pickImage(
          source: source,
          maxWidth: maxWidth,
          maxHeight: maxHeight,
          imageQuality: imageQuality,
          requestFullMetadata: false,
        )
        .then((file) => bloc.loadCropperImage(file));
  }

  Widget cropper(BuildContext context) {
    final maskColor = Theme.of(context).scaffoldBackgroundColor;

    return Crop(
      image: bloc.state.parameter.cropperImage!,
      controller: bloc.cropController,
      maskColor: bloc.state.parameter.cropperImageLocked ? maskColor : null,
      fixArea: bloc.state.parameter.cropperImageLocked,
      cornerDotBuilder: (size, edgeAlignment) => bloc.state.parameter.cropperImageLocked //
          ? const SizedBox.shrink()
          : const DotControl(),
      baseColor: maskColor,
      initialSize: 0.5,
      radius: 0,
      onCropped: bloc.uploadCropperImage,
    );
  }

  Widget buildImageEnhancementViewer(BuildContext context) {
    return ReactiveForm(
      formGroup: bloc.group,
      child: Column(
        children: [
          Visibility(
            visible: !bloc.parameter.showPdfSorter,
            child: ReactiveDropdownField<I18nLabel>(
              items: bloc
                  .converterItems()
                  .map((e) => DropdownMenuItem<I18nLabel>(value: e, child: Text(e.label)))
                  .toList(),
              formControl: bloc.converter,
              decoration: InputDecoration(
                hintText: AppLang.i18n.scanner_converterSelect_hint,
              ),
              onChanged: bloc.updateConverter,
            ),
          ),
          Visibility(
            visible: bloc.converter.value?.technical == monochrome,
            child: ReactiveSlider(
              formControl: bloc.amount,
              min: 0,
              max: 1,
              divisions: 20,
              onChanged: (value) => bloc.amountChanged(),
            ),
          ),
          Visibility(
            visible: bloc.converter.value?.technical == luminance,
            child: ReactiveSlider(
              formControl: bloc.threshold,
              min: 0,
              max: 1,
              divisions: 20,
              onChanged: (value) => bloc.thresholdChanged(),
            ),
          ),
          Expanded(
            child: PhotoViewGallery.builder(
              scrollPhysics: const BouncingScrollPhysics(),
              builder: (BuildContext context, int index) {
                return PhotoViewGalleryPageOptions(
                  imageProvider: MemoryImage(bloc.state.parameter.cachedImages[index]!),
                  heroAttributes: PhotoViewHeroAttributes(tag: index),
                );
              },
              //   onPageChanged: (index) => bloc.updateCurrentScannedImage(index),
              itemCount: bloc.state.parameter.cachedImages.length,
              loadingBuilder: (context, event) => const Center(
                child: SizedBox(
                  width: 20.0,
                  height: 20.0,
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildImageEnhancementSortingViewer(BuildContext context) {
    return ReactiveForm(
      formGroup: bloc.group,
      child: Column(
        children: [
          Expanded(
            child: PhotoViewGallery.builder(
              scrollPhysics: const BouncingScrollPhysics(),
              builder: (BuildContext context, int index) {
                return PhotoViewGalleryPageOptions(
                  imageProvider: MemoryImage(bloc.state.parameter.scannedImages[index].data),
                  heroAttributes: PhotoViewHeroAttributes(tag: index),
                );
              },
              //   onPageChanged: (index) => bloc.updateCurrentScannedImage(index),
              itemCount: bloc.state.parameter.scannedImages.length,
              loadingBuilder: (context, event) => const Center(
                child: SizedBox(
                  width: 20.0,
                  height: 20.0,
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  IndexedWidgetBuilder attachmentItemBuilder() => (context, index) {
        final attachment = bloc.attachments.value![index]!;

        return Card(
          color: Theme.of(context).colorScheme.primary,
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 10,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        attachment.name,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: nord6SnowStorm),
                      ),
                      Text(
                        displaySize(attachment.size.toDouble()),
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: nord6SnowStorm),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 32,
                  child: FittedBox(
                    child: IconButton(
                      color: nord6SnowStorm,
                      onPressed: () {
                        showDialog<bool>(
                          context: context,
                          builder: (context) => ConfirmDialog(
                            title: "Löschen",
                            content: "Soll der Anhang entfernt werden?",
                            navigator: Navigator.of(context),
                          ),
                        ).then((value) {
                          if (value ?? false) {
                            bloc.removeAttachment(index);
                          }
                        });
                      },
                      icon: Icon(
                        ThemeIcons.deletePosition,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      };
}
