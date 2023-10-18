import 'package:document_scanner/core/reactive/bloc.dart';
import 'package:document_scanner/scanner/presentation/screens/base/app_bar.dart';
import 'package:document_scanner/scanner/presentation/screens/base/scanner_right_menu.dart';
import 'package:document_scanner/scanner/presentation/screens/base/screen.dart';
import 'package:flutter/material.dart';

abstract class ScannerScreenState<T extends StatefulWidget, F extends ReactiveBloc> extends ReactiveScreenState<T, F> {
  ScannerScreenState({
    super.onUpdate,
    super.onProgress,
    super.onProgressSuccess,
    super.onProgressFailure,
    bool extendBodyBehindAppBar = false,
    FloatingActionButtonLocation floatingActionButtonLocation = FloatingActionButtonLocation.centerDocked,
  });

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) => FullAppBar(title: title(context));

  @override
  Widget? buildEndDrawer(BuildContext context) => const ScannerRightMenu();
}
