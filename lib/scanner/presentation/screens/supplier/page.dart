import 'package:document_scanner/core/design/theme_colors.dart';
import 'package:document_scanner/core/design/theme_icons.dart';
import 'package:document_scanner/core/goroute/auth_route.dart';
import 'package:document_scanner/core/lib/optional.dart';
import 'package:document_scanner/core/toaster/error.dart';
import 'package:document_scanner/core/toaster/success.dart';
import 'package:document_scanner/core/widgets/loading_dialog/loading_dialog.dart';
import 'package:document_scanner/core/widgets/responsive.dart';
import 'package:document_scanner/core/widgets/style/round_icon_button.dart';
import 'package:document_scanner/l10n/app_lang.dart';
import 'package:document_scanner/scanner/presentation/blocs/supplier/bloc.dart';
import 'package:document_scanner/scanner/presentation/screens/base.dart';
import 'package:document_scanner/scanner/presentation/screens/base/right_menu.dart';
import 'package:document_scanner/scanner/presentation/screens/base/top_nav.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';

class SuppliersScreen extends BaseScreen {
  const SuppliersScreen({super.key});

  @override
  State<SuppliersScreen> createState() => _SuppliersState();

  static const String path = '/suppliers';

  static AuthGoRoute get route => AuthGoRoute.unauthorized(
        path: path,
        child: (context, state) => const SuppliersScreen(),
      );
}

class _SuppliersState extends FormBlocBaseScreenState<SuppliersScreen, ItemBloc> {
  @override
  ItemBloc createBloc(BuildContext context) => ItemBloc();

  @override
  String title(BuildContext context) => "Document types";

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) => fullTopNavBar(context, title(context), scaffold, update);

  @override
  Drawer? buildEndDrawer(BuildContext context) => rightMenu(context, scaffold, update);

  @override
  Widget buildScreen(BuildContext context) => buildScannerForm(context);
  //buildScannerForm(context);

  Widget buildScannerForm(BuildContext context) {
    final formBloc = BlocProvider.of<ItemBloc>(context);

    return responsiveScreenWidthPadding(
      context,
      FormBlocListener<ItemBloc, String, ErrorValue>(
        onSubmitting: (context, state) => LoadingDialog.show(context),
        onSuccess: (context, state) {
          LoadingDialog.hide(context);
          showSnackBarSuccess(context, "attach", "${state.successResponse}");
          // context.go(PurchaseListRequestsScreen.path);
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
          padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: formBloc.main.suppliers.value.length,
                itemBuilder: (context, index) => TextFieldBlocBuilder(
                  textFieldBloc: formBloc.main.suppliers.value[index],
                  decoration: InputDecoration(
                    labelText: "Area",
                    hintText: "Name",
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RoundIconButton(
                    icon: ThemeIcons.newPosition,
                    tooltip: "add",
                    backgroundColor: Theme.of(context).primaryColor,
                    onPressed: () {
                      formBloc.main.createItem();
                      update();
                    },
                  ),
                  Builder(builder: (context) {
                    final valid = formBloc.state.isValid();

                    return RoundIconButton(
                      icon: ThemeIcons.send,
                      tooltip: "add",
                      backgroundColor: valid ? themeSignalColor : themeGrey2Color,
                      onPressed: () => valid ? formBloc.submit() : formBloc.validate(),
                    );
                  }),
                ],
              ),
            ],
          ),
        ),
      );
}
