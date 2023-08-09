import 'package:document_scanner/core/design/theme_colors.dart';
import 'package:document_scanner/core/design/theme_icons.dart';
import 'package:document_scanner/core/goroute/auth_route.dart';
import 'package:document_scanner/core/lib/optional.dart';
import 'package:document_scanner/core/lib/size.dart';
import 'package:document_scanner/core/toaster/error.dart';
import 'package:document_scanner/core/toaster/success.dart';
import 'package:document_scanner/core/widgets/bloc_builder/datetime.dart';
import 'package:document_scanner/core/widgets/bloc_builder/dropdown.dart';
import 'package:document_scanner/core/widgets/bloc_builder/text.dart';
import 'package:document_scanner/core/widgets/loading_dialog/loading_dialog.dart';
import 'package:document_scanner/core/widgets/responsive.dart';
import 'package:document_scanner/core/widgets/scanner/scanner.dart';
import 'package:document_scanner/core/widgets/style/round_icon_button.dart';
import 'package:document_scanner/l10n/app_lang.dart';
import 'package:document_scanner/scanner/presentation/blocs/scanner/bloc.dart';
import 'package:document_scanner/scanner/presentation/screens/base.dart';
import 'package:document_scanner/scanner/presentation/screens/base/right_menu.dart';
import 'package:document_scanner/scanner/presentation/screens/base/top_nav.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';

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
  PreferredSizeWidget? buildAppBar(BuildContext context) => fullTopNavBar(context, title(context), scaffold, update);

  @override
  Drawer? buildEndDrawer(BuildContext context) => rightMenu(context, scaffold, update);

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
          // context.go(PurchaseListRequestsScreen.path);
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
          return SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            primary: true,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 15),
              child: Column(
                children: [
                  DropDownBlocBuilder(
                    bloc: formBloc.main.area,
                    label: "Area",
                    hint: "Area",
                  ),
                  DropDownBlocBuilder(
                    bloc: formBloc.main.documentType,
                    label: "Document Type",
                    hint: "Document Type",
                  ),
                  TextBlocBuilder(
                    bloc: formBloc.main.supplierName,
                    label: "Supplier Name",
                    hint: "Supplier Name",
                  ),
                  DateTimeBlocBuilder(
                    bloc: formBloc.main.documentDate,
                    label: "Document Date",
                    hint: "Document Date",
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
                      scannerButton(formBloc),
                      sendPurchaseButton(context, formBloc),
                    ],
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  void dirty(BuildContext context) => BlocProvider.of<ScannerBloc>(context).validate();
  void submit(BuildContext context) => context.read<ScannerBloc>().submit();

  Widget sendPurchaseButton(BuildContext context, ScannerBloc bloc) {
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
        // TODO move converting to bloc
        // TODO clean up
        scan().then((value) {
          if (value.b != null) {
            formBloc.uploadAttachment(value.a, value.b!, ready: () => update());
          }
        }).whenComplete(() => LoadingDialog.hide(context));
      },
      tooltip: "Scan Document",
      icon: Icons.scanner,
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
