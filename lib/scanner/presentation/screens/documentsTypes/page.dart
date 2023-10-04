import 'package:document_scanner/core/design/theme_colors.dart';
import 'package:document_scanner/core/design/theme_icons.dart';
import 'package:document_scanner/core/lib/logger.dart';
import 'package:document_scanner/core/toaster/error.dart';
import 'package:document_scanner/core/toaster/success.dart';
import 'package:document_scanner/core/widgets/goroute/route.dart';
import 'package:document_scanner/core/widgets/loading_dialog/loading_dialog.dart';
import 'package:document_scanner/core/widgets/responsive.dart';
import 'package:document_scanner/l10n/app_lang.dart';
import 'package:document_scanner/scanner/presentation/blocs/documenttypes/bloc.dart';
import 'package:document_scanner/scanner/presentation/screens/base.dart';
import 'package:document_scanner/scanner/presentation/screens/base/template_page.dart';
import 'package:document_scanner/scanner/presentation/screens/base/top_nav.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:reactive_forms/reactive_forms.dart';

class DocumentTypesScreen extends BaseScreen {
  const DocumentTypesScreen({super.key});

  @override
  State<DocumentTypesScreen> createState() => _DocumentTypesScreenState();

  static const String path = '/documentTypes';

  static AuthGoRoute get route => AuthGoRoute.unauthorized(
        path: path,
        name: path,
        child: (context, state) => const DocumentTypesScreen(),
      );
}

class _DocumentTypesScreenState extends TemplateBaseScreenState<DocumentTypesScreen, ItemBloc> {
  _DocumentTypesScreenState()
      : super(
          onSubmitting: (context, state) => LoadingDialog.show(context),
          onSuccess: (context, state) {
            LoadingDialog.hide(context);
            showSnackBarSuccess(context, "documentTypes", "${state.successResponse}");
            context.pop();
          },
          onFailure: (context, state) {
            LoadingDialog.hide(context);
            final message =
                AppLang.i18n.message_failure_genericError(state.failureResponse?.exception.toString() ?? "");
            showSnackBarFailure(context, "documentTypes", message, state.failureResponse!.exception,
                stackTrace: state.failureResponse!.stackTrace);
          },
        );

  @override
  ItemBloc createBloc(BuildContext context) => ItemBloc();

  @override
  String title(BuildContext context) => AppLang.i18n.docTypes_page_title;

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) => LightSubTopNavBar(title: title(context), refresh: update);

  @override
  AlertDialog? onCanPop() {
    if (!bloc.group.dirty) {
      return null;
    }

    return AlertDialog(
      title: const Text('Please confirm'),
      content: const Text('Do you want to ignore changes?'),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('No'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('Yes'),
        ),
      ],
    );
  }

  @override
  Widget buildScreen(BuildContext context) {
    return buildForm(context);
  }

  Widget buildForm(BuildContext context) => ResponsiveWidthPadding(
        ReactiveForm(
          formGroup: bloc.group,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
            child: ReactiveFormArray(
              formArray: bloc.documentTypes,
              builder: (context, formArray, child) {
                return ListView.builder(
                  key: ValueKey(formArray.controls),
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  itemCount: bloc.documentTypes.controls.length,
                  itemBuilder: (context, index) => ReactiveTextField<String>(
                    formControl: bloc.documentTypes.controls[index] as FormControl<String>,
                    autofocus: index == bloc.documentTypes.controls.length - 1,
                    decoration: InputDecoration(
                      labelText: AppLang.i18n.docTypes_docTypeField_label,
                      hintText: AppLang.i18n.i18n_field_hint,
                      suffixIcon: IconButton(
                        icon: Icon(ThemeIcons.deletePosition),
                        onPressed: () {
                          bloc.removeItem(index);
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      );

  @override
  List<Widget>? buildPersistentFooterButtons(BuildContext context) {
    return [
      ReactiveForm(
        formGroup: bloc.group,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FloatingActionButton(
                heroTag: "documentTypes_btn1",
                child: Icon(ThemeIcons.newPosition),
                onPressed: () {
                  bloc.addItem();
                },
              ),
              ReactiveFormConsumer(builder: (context, formGroup, child) {
                Log.high("valid: ${formGroup.valid}");
                return FloatingActionButton(
                  heroTag: "documentTypes_btn2",
                  backgroundColor: formGroup.valid
                      ? nord12AuroraOrange
                      : Theme.of(context).floatingActionButtonTheme.backgroundColor,
                  onPressed: () => formGroup.valid ? bloc.submit() : bloc.validate(),
                  child: Icon(ThemeIcons.send),
                );
              }),
            ],
          ),
        ),
      ),
    ];
  }
}
