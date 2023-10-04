import 'package:cunning_document_scanner/cunning_document_scanner.dart';
import 'package:document_scanner/core/design/theme_colors.dart';
import 'package:document_scanner/core/design/theme_icons.dart';
import 'package:document_scanner/core/lib/size.dart';
import 'package:document_scanner/core/reactive/i18n_label.dart';
import 'package:document_scanner/core/toaster/error.dart';
import 'package:document_scanner/core/toaster/signal.dart';
import 'package:document_scanner/core/toaster/success.dart';
import 'package:document_scanner/core/widgets/confirm/confirm.dart';
import 'package:document_scanner/core/widgets/cropper/widget.dart';
import 'package:document_scanner/core/widgets/goroute/route.dart';
import 'package:document_scanner/core/widgets/loading_dialog/loading_dialog.dart';
import 'package:document_scanner/core/widgets/reactive/autocomplete.dart';
import 'package:document_scanner/core/widgets/responsive.dart';
import 'package:document_scanner/l10n/app_lang.dart';
import 'package:document_scanner/scanner/domain/repositories/convert.dart';
import 'package:document_scanner/scanner/presentation/blocs/scanner/bloc.dart';
import 'package:document_scanner/scanner/presentation/screens/base.dart';
import 'package:document_scanner/scanner/presentation/screens/base/template_page.dart';
import 'package:document_scanner/scanner/presentation/screens/base/top_nav.dart';
import 'package:document_scanner/scanner/presentation/screens/whats_new/app.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pdfx/pdfx.dart';
import 'package:reactive_date_time_picker/reactive_date_time_picker.dart';
import 'package:reactive_forms/reactive_forms.dart';

class ScannerScreen extends BaseScreen {
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

class _ScannerScreenState extends TemplateBaseScreenState<ScannerScreen, ScannerBloc> {
  _ScannerScreenState()
      : super(
          onSubmitting: (context, state) => LoadingDialog.show(context),
          onSuccess: (context, state) {
            LoadingDialog.hide(context);
            showSnackBarSuccess(context, "scanner", "${state.successResponse}");
          },
          onFailure: (context, state) {
            LoadingDialog.hide(context);
            final message =
                AppLang.i18n.message_failure_genericError(state.failureResponse?.exception.toString() ?? "");
            showSnackBarFailure(context, "scanner", message, state.failureResponse!.exception,
                stackTrace: state.failureResponse!.stackTrace);
          },
        );

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

  PreferredSizeWidget cropTopNavBar() => CustomButtonTopNavBar(
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
        refresh: update,
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
      return buildImageEnhancementViewer(context);
    }

    if (bloc.state.parameter.showCropper) {
      return cropper(context);
    }

    return buildScannerForm(context);
  }

  Widget buildScannerForm(BuildContext context) {
    if (bloc.shouldShowWhatsNew()) {
      SchedulerBinding.instance.addPostFrameCallback(
        (_) => showDialog(
          context: context,
          builder: (context) => const WhatsNew(),
        ).then((value) => bloc.closedWhatsNew()),
      );
    }

    return ResponsiveWidthPadding(
      ReactiveForm(
        formGroup: bloc.group,
        child: SingleChildScrollView(
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
                  enableSuggestions: false,
                  optionsBuilder: (value) => bloc.state.parameter.filterSenderItems(value.text),
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
                  firstDate: DateTime(1900),
                  lastDate: DateTime(2100),
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
      ),
    );
  }

  @override
  List<Widget>? buildPersistentFooterButtons(BuildContext context) {
    if (bloc.state.parameter.showCropper) {
      return null;
    }

    if (bloc.state.parameter.scannedImages.isNotEmpty) {
      return [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                FloatingActionButton(
                  heroTag: "scanner_counterClockwise_pdf",
                  onPressed: bloc.working.value! ? null : bloc.counterClockwise,
                  child: Icon(ThemeIcons.counterClockwise),
                ),
                const SizedBox(
                  width: 20,
                ),
                FloatingActionButton(
                  heroTag: "scanner_clockwise_pdf",
                  onPressed: bloc.working.value! ? null : bloc.clockwise,
                  child: Icon(ThemeIcons.clockwise),
                ),
              ],
            ),
            FloatingActionButton(
              heroTag: "scanner_btn_pdf",
              onPressed: () => bloc.working.value! ? null : bloc.createPDF(),
              child: Icon(ThemeIcons.filePDF),
            ),
          ],
        )
      ];
    }

    return buildPersistentDefaultFooterButtons(context);
  }

  List<Widget>? buildPersistentDefaultFooterButtons(BuildContext context) {
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
            sendButton(context, bloc),
          ],
        ),
      ),
    ];
  }

  void dirty(BuildContext context) {
    if (bloc.attachments.controls.isEmpty) {
      showSnackBarSignal(context, "create (dirty)", AppLang.i18n.scanner_noAttachment_hint);
    }

    bloc.validate();
  }

  void submit(BuildContext context) => bloc.submit();

  Widget sendButton(BuildContext context, ScannerBloc bloc) {
    final valid = bloc.group.valid;
    return FloatingActionButton(
      heroTag: "scanner_btn_send",
      backgroundColor: valid ? nord12AuroraOrange : Theme.of(context).floatingActionButtonTheme.backgroundColor,
      onPressed: () => valid ? submit(context) : dirty(context),
      child: Icon(ThemeIcons.send),
    );
  }

  Widget scannerButton() {
    return FloatingActionButton(
      heroTag: "scanner_btn_scanner",
      onPressed: () async {
        LoadingDialog.show(context);
        CunningDocumentScanner.getPictures().then((value) {
          if (value != null) {
            bloc.storeScanResult(value);
          }
        }).whenComplete(() => LoadingDialog.hide(context));
      },
      child: Icon(ThemeIcons.scanner),
    );
  }

  Widget filePickerButton() {
    return FloatingActionButton(
      heroTag: "scanner_btn_filePicker",
      onPressed: () async {
        LoadingDialog.show(context);

        FilePicker.platform
            .pickFiles(
              allowMultiple: false,
              dialogTitle: "Choose a file",
            )
            .then((result) => result?.files.single.path)
            .then(
          (path) {
            if (path != null) {
              bloc.uploadFile(path);
            }
          },
        ).whenComplete(() => LoadingDialog.hide(context));
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
    return Cropper(
      image: bloc.state.parameter.cropperImage!,
      onCropped: (image) {
        LoadingDialog.show(context);
        bloc.hideCropper();
        bloc.uploadAttachment(bloc.state.parameter.cropperFilename!, image);
        LoadingDialog.hide(context);
      },
    );
  }

  Widget buildImageEnhancementViewer(BuildContext context) {
    return ReactiveForm(
      formGroup: bloc.group,
      child: Column(
        children: [
          ReactiveDropdownField<I18nLabel>(
            items:
                bloc.converterItems().map((e) => DropdownMenuItem<I18nLabel>(value: e, child: Text(e.label))).toList(),
            formControl: bloc.converter,
            decoration: InputDecoration(
              hintText: AppLang.i18n.scanner_converterSelect_hint,
            ),
            onChanged: bloc.updateConverter,
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
                return PhotoViewGalleryPageOptions.customChild(
                  child: StreamBuilder<Uint8List?>(
                    stream: bloc.currentScannedImageStream,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting || !snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      return Image.memory(snapshot.data!);
                    },
                  ),
                  heroAttributes: PhotoViewHeroAttributes(tag: index),
                );
              },
              onPageChanged: (index) => bloc.updateCurrentScannedImage(index),
              itemCount: bloc.state.parameter.scannedImages.length,
              loadingBuilder: (context, event) => Center(
                child: SizedBox(
                  width: 20.0,
                  height: 20.0,
                  child: CircularProgressIndicator(
                    value: event == null
                        ? 0
                        : event.cumulativeBytesLoaded / (event.expectedTotalBytes ?? event.cumulativeBytesLoaded),
                  ),
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
