import 'package:document_scanner/core/design/theme_colors.dart';
import 'package:document_scanner/core/goroute/auth_route.dart';
import 'package:document_scanner/core/lib/optional.dart';
import 'package:document_scanner/core/toaster/error.dart';
import 'package:document_scanner/core/toaster/success.dart';
import 'package:document_scanner/core/widgets/loading_dialog/loading_dialog.dart';
import 'package:document_scanner/core/widgets/responsive.dart';
import 'package:document_scanner/l10n/app_lang.dart';
import 'package:document_scanner/scanner/presentation/blocs/scanner.dart';
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
          return const SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            primary: true,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 32, horizontal: 15),
              child: Column(
                children: [
                  Text("66", style: TextStyle(fontSize: 66)),
                  //
                  Text("0123456789abcdefghijklmnopqrstuvwxyz äöüßẞ",
                      style: TextStyle(fontSize: 18, backgroundColor: nord0PolarNight, color: nord4SnowStorm)),
                  Text("0123456789abcdefghijklmnopqrstuvwxyz äöüßẞ",
                      style: TextStyle(fontSize: 18, backgroundColor: nord1PolarNight, color: nord4SnowStorm)),
                  Text("0123456789abcdefghijklmnopqrstuvwxyz äöüßẞ",
                      style: TextStyle(fontSize: 18, backgroundColor: nord2PolarNight, color: nord4SnowStorm)),
                  Text("0123456789abcdefghijklmnopqrstuvwxyz äöüßẞ",
                      style: TextStyle(fontSize: 18, backgroundColor: nord3PolarNight, color: nord4SnowStorm)),
                  //
                  Text("0123456789abcdefghijklmnopqrstuvwxyz äöüßẞ",
                      style: TextStyle(fontSize: 18, backgroundColor: nord4SnowStorm, color: nord0PolarNight)),
                  Text("0123456789abcdefghijklmnopqrstuvwxyz äöüßẞ",
                      style: TextStyle(fontSize: 18, backgroundColor: nord5SnowStorm, color: nord0PolarNight)),
                  Text("0123456789abcdefghijklmnopqrstuvwxyz äöüßẞ",
                      style: TextStyle(fontSize: 18, backgroundColor: nord6SnowStorm, color: nord0PolarNight)),
                  //
                  Text("0123456789abcdefghijklmnopqrstuvwxyz äöüßẞ",
                      style: TextStyle(fontSize: 18, backgroundColor: nord7Frost, color: nord0PolarNight)),
                  Text("0123456789abcdefghijklmnopqrstuvwxyz äöüßẞ",
                      style: TextStyle(fontSize: 18, backgroundColor: nord8Frost, color: nord0PolarNight)),
                  Text("0123456789abcdefghijklmnopqrstuvwxyz äöüßẞ",
                      style: TextStyle(fontSize: 18, backgroundColor: nord9Frost, color: nord0PolarNight)),
                  Text("0123456789abcdefghijklmnopqrstuvwxyz äöüßẞ",
                      style: TextStyle(fontSize: 18, backgroundColor: nord10Frost, color: nord0PolarNight)),
                  //
                  Text("0123456789abcdefghijklmnopqrstuvwxyz äöüßẞ",
                      style: TextStyle(fontSize: 18, backgroundColor: nord11AuroraRed, color: nord0PolarNight)),
                  Text("0123456789abcdefghijklmnopqrstuvwxyz äöüßẞ",
                      style: TextStyle(fontSize: 18, backgroundColor: nord12AuroraOrange, color: nord0PolarNight)),
                  Text("0123456789abcdefghijklmnopqrstuvwxyz äöüßẞ",
                      style: TextStyle(fontSize: 18, backgroundColor: nord13AuroraYellow, color: nord0PolarNight)),
                  Text("0123456789abcdefghijklmnopqrstuvwxyz äöüßẞ",
                      style: TextStyle(fontSize: 18, backgroundColor: nord14AuroraGreen, color: nord0PolarNight)),
                  Text("0123456789abcdefghijklmnopqrstuvwxyz äöüßẞ",
                      style: TextStyle(fontSize: 18, backgroundColor: nord15AuroraPurple, color: nord0PolarNight)),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
