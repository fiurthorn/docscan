import 'dart:io';

import 'package:cunning_document_scanner/cunning_document_scanner.dart';
import 'package:document_scanner/core/design/theme_colors.dart';
import 'package:document_scanner/core/design/theme_icons.dart';
import 'package:document_scanner/core/lib/optional.dart';
import 'package:document_scanner/core/lib/size.dart';
import 'package:document_scanner/core/toaster/error.dart';
import 'package:document_scanner/core/toaster/success.dart';
import 'package:document_scanner/core/widgets/bloc_builder/datetime.dart';
import 'package:document_scanner/core/widgets/bloc_builder/dropdown.dart';
import 'package:document_scanner/core/widgets/bloc_builder/text.dart';
import 'package:document_scanner/core/widgets/cropper/widget.dart';
import 'package:document_scanner/core/widgets/goroute/route.dart';
import 'package:document_scanner/core/widgets/loading_dialog/loading_dialog.dart';
import 'package:document_scanner/core/widgets/responsive.dart';
import 'package:document_scanner/core/widgets/style/round_icon_button.dart';
import 'package:document_scanner/l10n/app_lang.dart';
import 'package:document_scanner/scanner/domain/repositories/convert.dart';
import 'package:document_scanner/scanner/presentation/blocs/scanner/bloc.dart';
import 'package:document_scanner/scanner/presentation/screens/base.dart';
import 'package:document_scanner/scanner/presentation/screens/base/right_menu.dart';
import 'package:document_scanner/scanner/presentation/screens/base/top_nav.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pdfx/pdfx.dart';

class ScannerScreen extends BaseScreen {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();

  static const String path = '/scanner';

  static AuthGoRoute get route => AuthGoRoute.unauthorized(
        path: path,
        child: (context, state) => const ScannerScreen(),
      );
}

class _ScannerScreenState extends FormBlocBaseScreenState<ScannerScreen, ScannerBloc> {
  @override
  ScannerBloc createBloc(BuildContext context) => ScannerBloc();

  @override
  String title(BuildContext context) => "Scanner";

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) {
    final formBloc = BlocProvider.of<ScannerBloc>(context);

    if (formBloc.displayCropper.value) {
      return cropTopNavBar(formBloc);
    }

    return fullTopNavBar(context, title(context), scaffold, update);
  }

  AppBar cropTopNavBar(ScannerBloc formBloc) => customButtonTopNavBar(
      context,
      title(context),
      Row(
        children: [
          InkWell(
            onTap: () {
              formBloc.displayCropper.changeValue(false);
              update();
            },
            child: Center(
              child: Icon(
                ThemeIcons.close,
                color: themeGrey4Color,
              ),
            ),
          ),
        ],
      ),
      update);

  @override
  Drawer? buildEndDrawer(BuildContext context) {
    final formBloc = BlocProvider.of<ScannerBloc>(context);
    if (formBloc.displayCropper.value) {
      return null;
    }

    return rightMenu(context, scaffold, update);
  }

  @override
  Widget buildScreen(BuildContext context) => buildScannerForm(context);
  //buildScannerForm(context);

  Widget buildScannerForm(BuildContext context) {
    final formBloc = BlocProvider.of<ScannerBloc>(context);

    return responsiveScreenWidthPadding(
      context,
      FormBlocListener<ScannerBloc, String, ErrorValue>(
        onSubmitting: (context, state) => LoadingDialog.show(context),
        onSuccess: (context, state) {
          LoadingDialog.hide(context);
          showSnackBarSuccess(context, "attach", "${state.successResponse}");
          // context.go(ScannerScreen.path);
        },
        onLoadFailed: (context, state) {
          final message = AppLang.i18n.message_failure_genericError(state.failureResponse?.exception.toString() ?? "");
          showSnackBarFailure(context, "attach (load)", message, state.failureResponse!.exception,
              stackTrace: state.failureResponse!.stackTrace);
        },
        onFailure: (context, state) {
          LoadingDialog.hide(context);
          final message = AppLang.i18n.message_failure_genericError(state.failureResponse?.exception.toString() ?? "");
          showSnackBarFailure(context, "attach", message, state.failureResponse!.exception,
              stackTrace: state.failureResponse!.stackTrace);
        },
        child: Builder(builder: (context) {
          if (formBloc.scannedImages.value.isNotEmpty) {
            return buildImageEnhancementViewer(context, formBloc);
          } else if (formBloc.displayCropper.value) {
            return cropper(context);
          }

          return buildInputForm(context, formBloc);
        }),
      ),
    );
  }

  Widget cropper(BuildContext context) {
    final formBloc = BlocProvider.of<ScannerBloc>(context);
    final image = formBloc.cropperImage;

    return Cropper(
      image: image!,
      onCropped: (image) {
        LoadingDialog.show(context);
        final formBloc = BlocProvider.of<ScannerBloc>(context);
        formBloc.displayCropper.changeValue(false);
        formBloc.uploadAttachment(formBloc.cropperFilename!, image);
        update();
        LoadingDialog.hide(context);
      },
    );
  }

  Widget buildImageEnhancementViewer(BuildContext context, ScannerBloc formBloc) {
    return Column(
      children: [
        DropDownBlocBuilder(
          bloc: formBloc.converter,
          hint: AppLang.i18n.scanner_converterSelect_hint,
          requestFocus: true,
          onChanged: (_) => formBloc.clearImageCache(),
        ),
        Visibility(
          visible: formBloc.converter.value?.technical == monochrome,
          child: BlocBuilder(
              bloc: formBloc.amount,
              builder: (context, state) {
                return Slider(
                    value: formBloc.amount.value,
                    divisions: 20,
                    onChanged: (value) {
                      formBloc.amountChanged(value);
                      update();
                    });
              }),
        ),
        Visibility(
          visible: formBloc.converter.value?.technical == luminance,
          child: BlocBuilder(
              bloc: formBloc.threshold,
              builder: (context, state) {
                return Slider(
                    value: formBloc.threshold.value,
                    divisions: 20,
                    onChanged: (value) {
                      formBloc.thresholdChanged(value);
                      update();
                    });
              }),
        ),
        SizedBox(
          height: 400,
          width: 400,
          child: PhotoViewGallery.builder(
            scrollPhysics: const BouncingScrollPhysics(),
            builder: (BuildContext context, int index) {
              return PhotoViewGalleryPageOptions(
                imageProvider: MemoryImage(formBloc.convertedImage(index)),
                initialScale: PhotoViewComputedScale.contained * 0.8,
                heroAttributes: PhotoViewHeroAttributes(tag: index),
              );
            },
            itemCount: formBloc.scannedImages.value.length,
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
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              RoundIconButton(
                backgroundColor: themeGrey2Color,
                onPressed: () => formBloc.createPDF().then((value) => update()),
                icon: ThemeIcons.filePDF,
                tooltip: '',
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget buildInputForm(BuildContext context, ScannerBloc formBloc) => SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        primary: true,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 15),
          child: Column(
            children: [
              DropDownBlocBuilder(
                bloc: formBloc.main.area,
                label: AppLang.i18n.scanner_areaSelect_label,
                hint: AppLang.i18n.scanner_areaSelect_hint,
              ),
              TextBlocBuilder(
                bloc: formBloc.main.senderName,
                label: AppLang.i18n.scanner_senderField_label,
                hint: AppLang.i18n.scanner_senderField_hint,
              ),
              DropDownBlocBuilder(
                bloc: formBloc.main.documentType,
                label: AppLang.i18n.scanner_docTypeSelect_label,
                hint: AppLang.i18n.scanner_docTypeSelect_hint,
              ),
              DateTimeBlocBuilder(
                bloc: formBloc.main.documentDate,
                label: AppLang.i18n.scanner_docDateField_label,
                hint: AppLang.i18n.scanner_docDateField_hint,
                firstDateTime: DateTime(1900),
                lastDateDuration: const Duration(days: 3653 * 20),
              ),
              const SizedBox(height: 20),
              BlocBuilder(
                  bloc: formBloc.main.attachments,
                  builder: (context, state) {
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: formBloc.attachmentCount(),
                      itemBuilder: attachmentItemBuilder(formBloc),
                    );
                  }),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      scannerButton(formBloc),
                      const SizedBox(width: 8),
                      filePickerButton(formBloc),
                      const SizedBox(width: 8),
                      cameraButton(formBloc),
                    ],
                  ),
                  sendButton(context, formBloc),
                ],
              ),
            ],
          ),
        ),
      );

  void dirty(BuildContext context) {
    final formBloc = BlocProvider.of<ScannerBloc>(context);

    if (formBloc.attachments.isEmpty) {
      showSnackBarFailure(context, "create pre send (dirty)", AppLang.i18n.needOnePosition_errorHint,
          AppLang.i18n.scanner_noAttachment_hint);
      // } else {
      // showSnackBarFailure(context, "create pre send (dirty)", "missing required values");
    }

    formBloc.validate();
  }

  void submit(BuildContext context) => context.read<ScannerBloc>().submit();

  Widget sendButton(BuildContext context, ScannerBloc bloc) {
    final empty = bloc.main.attachments.value.isEmpty;
    final valid = bloc.state.isValid();

    return RoundIconButton(
      backgroundColor: valid && !empty ? themeSignalColor : themeGrey2Color,
      onPressed: () => valid && !empty ? submit(context) : dirty(context),
      icon: ThemeIcons.send,
      tooltip: '',
    );
  }

  Widget scannerButton(ScannerBloc formBloc) {
    return RoundIconButton(
      backgroundColor: Theme.of(context).primaryColor,
      onPressed: () async {
        LoadingDialog.show(context);
        CunningDocumentScanner.getPictures().then((value) {
          if (value != null) {
            formBloc.storeScanResult(value, ready: () => update());
          }
        }).whenComplete(() => LoadingDialog.hide(context));
      },
      tooltip: "Scan Document",
      icon: ThemeIcons.scanner,
    );
  }

  Widget cameraButton(ScannerBloc formBloc) {
    return RoundIconButton(
      backgroundColor: Theme.of(context).primaryColor,
      onPressed: () => camera(
        formBloc,
        source: ImageSource.camera,
        maxHeight: 2048,
        maxWidth: 2048,
        imageQuality: 66,
      ),
      tooltip: "Picture",
      icon: ThemeIcons.camera,
    );
  }

  void camera(
    ScannerBloc formBloc, {
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
        .then((file) => formBloc.loadCropperImage(file))
        .then((_) => update()); //.whenComplete(() => LoadingDialog.hide(context));
  }

  Widget filePickerButton(ScannerBloc formBloc) {
    return RoundIconButton(
      backgroundColor: Theme.of(context).primaryColor,
      onPressed: () async {
        LoadingDialog.show(context);

        FilePicker.platform
            .pickFiles() //
            .then((result) => result?.files.single.path)
            .then(
          (path) {
            if (path != null) {
              formBloc.uploadAttachment(path, File(path).readAsBytesSync());
            }
          },
        ).whenComplete(() => LoadingDialog.hide(context));
      },
      tooltip: "Pick Document",
      icon: ThemeIcons.file,
    );
  }

  IndexedWidgetBuilder attachmentItemBuilder(ScannerBloc formBloc) => (context, index) {
        return Card(
          color: themeGrey3Color,
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.only(left: 12, right: 12, top: 5, bottom: 5),
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
                        formBloc.attachments[index].value.name,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: nord6SnowStorm),
                      ),
                      Text(
                        displaySize(formBloc.attachments[index].value.size.toDouble()),
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
                        formBloc.removeAttachment(index);
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
