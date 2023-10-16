import 'package:document_scanner/core/design/theme_colors.dart';
import 'package:document_scanner/core/design/theme_icons.dart';
import 'package:document_scanner/core/widgets/confirm/confirm.dart';
import 'package:document_scanner/core/widgets/goroute/route.dart';
import 'package:document_scanner/core/widgets/reactive/floating_action_button.dart';
import 'package:document_scanner/core/widgets/reactive/list_view_builder.dart';
import 'package:document_scanner/core/widgets/responsive.dart';
import 'package:document_scanner/l10n/app_lang.dart';
import 'package:document_scanner/scanner/presentation/blocs/senders/bloc.dart';
import 'package:document_scanner/scanner/presentation/screens/base.dart';
import 'package:document_scanner/scanner/presentation/screens/base/template_page.dart';
import 'package:document_scanner/scanner/presentation/screens/base/top_nav.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:reactive_forms/reactive_forms.dart';

class SendersScreen extends BaseScreen {
  const SendersScreen({super.key});

  @override
  State<SendersScreen> createState() => _SendersScreenState();

  static const String path = '/senders';

  static AuthGoRoute get route => AuthGoRoute.unauthorized(
        path: path,
        name: path,
        child: (context, state) => const SendersScreen(),
      );
}

class _SendersScreenState extends TemplateBaseScreenState<SendersScreen, ItemBloc> {
  _SendersScreenState()
      : super(
          onProgressSuccess: (context, state) => context.pop(),
        );

  @override
  ItemBloc createBloc(BuildContext context) => ItemBloc();

  @override
  String title(BuildContext context) => AppLang.i18n.senders_page_title;

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) => LightSubTopNavBar(title: title(context));

  @override
  AlertDialog? onCanPop() {
    if (!bloc.group.dirty) {
      return null;
    }

    return ConfirmDialog(
      title: "Please confirm",
      content: "Do you want to ignore changes?",
      navigator: Navigator.of(context),
    );
  }

  @override
  Widget buildScreen(BuildContext context) {
    return buildForm(context);
  }

  Widget buildForm(BuildContext context) => ResponsiveWidthPadding(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
          child: ReactiveListViewBuilder(
            formArray: bloc.senders,
            itemBuilder: (context, index, count, item) => ReactiveTextField<String>(
              formControl: item as FormControl<String>,
              autofocus: index == count - 1,
              decoration: InputDecoration(
                labelText: AppLang.i18n.areas_areaField_label,
                hintText: AppLang.i18n.i18n_field_hint,
                suffixIcon: IconButton(
                  icon: Icon(ThemeIcons.deletePosition),
                  onPressed: () => bloc.removeItem(index),
                ),
              ),
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
                heroTag: "senders_btn1",
                child: Icon(ThemeIcons.newPosition),
                onPressed: () {
                  bloc.addItem();
                },
              ),
              ReactiveFloatingActionButton(
                onPressed: (formGroup) => formGroup.valid ? bloc.submit() : bloc.validate(),
                backgroundColor: Theme.of(context).floatingActionButtonTheme.backgroundColor,
                validBackgroundColor: nord12AuroraOrange,
                child: Icon(ThemeIcons.send),
              ),
            ],
          ),
        ),
      ),
    ];
  }
}
