import 'package:document_scanner/core/lib/optional.dart';
import 'package:document_scanner/scanner/presentation/screens/base.dart';
import 'package:document_scanner/scanner/presentation/screens/base/right_menu.dart';
import 'package:document_scanner/scanner/presentation/screens/base/top_nav.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';

abstract class TemplateBaseScreenState<T extends StatefulWidget, F extends FormBloc<String, ErrorValue>>
    extends FormBlocBaseScreenState<T, F> {
  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) => FullTopNavBar(title: title(context), refresh: update);

  @override
  Widget? buildEndDrawer(BuildContext context) => RightMenu(refresh: update);
}
