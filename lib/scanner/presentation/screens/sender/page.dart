import 'package:document_scanner/core/design/theme_colors.dart';
import 'package:document_scanner/core/design/theme_icons.dart';
import 'package:document_scanner/core/lib/optional.dart';
import 'package:document_scanner/core/toaster/error.dart';
import 'package:document_scanner/core/toaster/success.dart';
import 'package:document_scanner/core/widgets/goroute/route.dart';
import 'package:document_scanner/core/widgets/loading_dialog/loading_dialog.dart';
import 'package:document_scanner/core/widgets/responsive.dart';
import 'package:document_scanner/l10n/app_lang.dart';
import 'package:document_scanner/scanner/presentation/blocs/sender/bloc.dart';
import 'package:document_scanner/scanner/presentation/screens/base.dart';
import 'package:document_scanner/scanner/presentation/screens/base/template_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:go_router/go_router.dart';

class SendersScreen extends BaseScreen {
  const SendersScreen({super.key});

  @override
  State<SendersScreen> createState() => _SendersState();

  static const String path = '/senders';

  static AuthGoRoute get route => AuthGoRoute.unauthorized(
        path: path,
        name: path,
        child: (context, state) => const SendersScreen(),
      );
}

class _SendersState extends TemplateBaseScreenState<SendersScreen, ItemBloc> {
  @override
  ItemBloc createBloc(BuildContext context) => ItemBloc();

  @override
  String title(BuildContext context) => AppLang.i18n.senders_page_title;

  @override
  Widget buildScreen(BuildContext context) => buildScannerForm(context);
  //buildScannerForm(context);

  Widget buildScannerForm(BuildContext context) {
    final formBloc = BlocProvider.of<ItemBloc>(context);

    return ResponsiveWidthPadding(
      FormBlocListener<ItemBloc, String, ErrorValue>(
        onSubmitting: (context, state) => LoadingDialog.show(context),
        onSuccess: (context, state) {
          LoadingDialog.hide(context);
          showSnackBarSuccess(context, "attach", "${state.successResponse}");
          context.pop();
        },
        onLoaded: (context, state) => update(),
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
        child: buildForm(context, formBloc),
      ),
    );
  }

  Widget buildForm(BuildContext context, ItemBloc formBloc) => SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        primary: true,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: formBloc.main.senders.value.length,
                itemBuilder: (context, index) => TextFieldBlocBuilder(
                  textFieldBloc: formBloc.main.senders.value[index],
                  autofocus: index == formBloc.main.senders.value.length - 1,
                  decoration: InputDecoration(
                    labelText: AppLang.i18n.senders_senderField_label,
                    hintText: AppLang.i18n.senders_senderField_label,
                    suffixIcon: IconButton(
                      icon: Icon(ThemeIcons.deletePosition),
                      onPressed: () {
                        formBloc.main.removeItem(index);
                        update();
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  @override
  List<Widget>? buildPersistentFooterButtons(BuildContext context) {
    final formBloc = BlocProvider.of<ItemBloc>(context);
    final valid = formBloc.state.isValid();

    return [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FloatingActionButton(
              heroTag: "sender_btn1",
              child: Icon(ThemeIcons.newPosition),
              onPressed: () {
                formBloc.main.createItem();
                update();
              },
            ),
            FloatingActionButton(
              heroTag: "sender_btn2",
              backgroundColor: valid ? nord12AuroraOrange : Theme.of(context).floatingActionButtonTheme.backgroundColor,
              onPressed: () => valid ? formBloc.submit() : formBloc.validate(),
              child: Icon(ThemeIcons.send),
            ),
          ],
        ),
      ),
    ];
  }
}
