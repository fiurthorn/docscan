import 'package:document_scanner/core/lib/platform/platform.dart';
import 'package:document_scanner/core/reactive/bloc.dart';
import 'package:document_scanner/core/toaster/error.dart';
import 'package:document_scanner/core/toaster/success.dart';
import 'package:document_scanner/core/widgets/loading_dialog/loading_dialog.dart';
import 'package:document_scanner/core/widgets/reactive/listener.dart';
import 'package:document_scanner/l10n/app_lang.dart';
import 'package:document_scanner/scanner/presentation/screens/error/error.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:reactive_forms/reactive_forms.dart';

abstract class BaseScreen extends StatefulWidget {
  // static const String path = "/";.map((e) => null) baseLocation

  const BaseScreen({super.key});

  static String buildGoRoute(
    String baseLocation, {
    Map<String, String> pathParameters = const {},
    Map<String, String> queryParameters = const {},
  }) =>
      Uri(
        path: pathParameters.entries.fold<String>(
          baseLocation,
          (location, pathParam) => location.replaceAll(":${pathParam.key}", pathParam.value),
        ),
        queryParameters: queryParameters.isEmpty ? null : queryParameters,
      ).toString();
}

abstract class BaseScreenState<T extends StatefulWidget> extends State<T> {
  final GlobalKey<ScaffoldState> scaffold = GlobalKey();

  void go(String route) {
    GoRouter.of(context).go(route);
  }

  void push(String route) {
    if (isWeb) {
      GoRouter.of(context).go(route);
    } else {
      GoRouter.of(context).push(route);
    }
  }

  VoidCallback refresher(VoidCallback fn) => () => setState(fn);
  void refresh(VoidCallback fn) => setState(fn);
  void update() => refresh(() {});

  bool extendBodyBehindAppBar;
  FloatingActionButtonLocation floatingActionButtonLocation;

  BaseScreenState({
    this.extendBodyBehindAppBar = false,
    this.floatingActionButtonLocation = FloatingActionButtonLocation.centerDocked,
  });

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void reassemble() {
    super.reassemble();
  }

  @override
  void deactivate() {
    super.deactivate();
  }

  @override
  void didUpdateWidget(T oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) => SafeArea(child: _scaffold(context));

  PreferredSizeWidget? buildAppBar(BuildContext context) => null;
  String title(BuildContext context);
  Widget buildScreen(BuildContext context);
  Widget? buildEndDrawer(BuildContext context) => null;
  Widget? buildDrawer(BuildContext context) => null;
  Widget? buildBottomNavigationBar(BuildContext context) => null;
  List<Widget>? buildPersistentFooterButtons(BuildContext context) => null;
  Widget? buildFloatingActionButton(BuildContext context) => null;

  ThemeData themeData(BuildContext context) => Theme.of(context);

  Widget _scaffold(BuildContext context) => _theme(
      context,
      WillPopScope(
        onWillPop: () => _onWillPop(context),
        child: Scaffold(
          extendBodyBehindAppBar: extendBodyBehindAppBar,
          appBar: buildAppBar(context),
          body: buildScreen(context),
          key: scaffold,
          drawer: buildDrawer(context),
          endDrawer: buildEndDrawer(context),
          persistentFooterButtons: buildPersistentFooterButtons(context),
          bottomNavigationBar: buildBottomNavigationBar(context),
          floatingActionButtonLocation: floatingActionButtonLocation,
          floatingActionButton: buildFloatingActionButton(context),
        ),
      ));

  _theme(BuildContext context, Widget screen) {
    return Theme(
      data: themeData(context),
      child: screen,
    );
  }

  Future<bool> _onCanPop() async {
    final dialog = onCanPop();
    if (dialog == null) return true;

    return showDialog<bool>(
      context: context,
      builder: (context) => dialog,
    ).then((value) => value ?? false);
  }

  AlertDialog? onCanPop() => null;

  AlertDialog onExit(BuildContext context) {
    return AlertDialog(
      title: const Text('Please confirm'),
      content: const Text('Do you want to exit the app?'),
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

  Future<bool> _onWillPop(BuildContext context) async {
    if (Navigator.of(context).canPop()) return _onCanPop();

    return showDialog<bool>(
      context: context,
      builder: (context) => onExit(context),
    ).then((value) => value ?? false);
  }
}

abstract class ReactiveBlocBaseScreenState<T extends StatefulWidget, BLoC extends ReactiveBloc>
    extends BaseScreenState<T> {
  final ReactiveBlocListenerCallback<UpdateReactiveState>? onUpdate;
  final ReactiveBlocListenerCallback<ProgressReactiveState>? onProgress;
  final ReactiveBlocListenerCallback<ProgressSuccessReactiveState>? onProgressSuccess;
  final ReactiveBlocListenerCallback<ProgressFailureReactiveState>? onProgressFailure;

  ReactiveBlocBaseScreenState({
    this.onUpdate,
    this.onProgress,
    this.onProgressSuccess,
    this.onProgressFailure,
    bool extendBodyBehindAppBar = false,
    FloatingActionButtonLocation floatingActionButtonLocation = FloatingActionButtonLocation.centerDocked,
  }) : super(
          extendBodyBehindAppBar: extendBodyBehindAppBar,
          floatingActionButtonLocation: floatingActionButtonLocation,
        );

  late BLoC bloc;

  @override
  Widget build(BuildContext context) {
    return _theme(
      context,
      BlocProvider<BLoC>(
        create: (context) => bloc = createBloc(context)..init(),
        child: ReactiveBlocListener<BLoC>(
          onLoadFailure: (context, state) {
            LoadingDialog.hide(context);
            final message = AppLang.i18n.message_failure_genericError(state.failureResponse.exception.toString() ?? "");
            showBannerFailure(context, "load ($runtimeType)", message, state.failureResponse.exception,
                stackTrace: state.failureResponse.stackTrace);
          },
          onLoading: (context, state) => LoadingDialog.show(
            context,
            color: Colors.transparent,
          ),
          onLoaded: (context, state) => LoadingDialog.hide(context),
          //
          onProgress: (context, state) {
            ProgressLoadingDialog.show(context, state.progress, state.max);
            onProgress?.call(context, state);
          },
          onProgressSuccess: (context, state) {
            ProgressLoadingDialog.hide(context);
            if (state.successResponse != null) {
              showSnackBarSuccess(context, "scanner", "${state.successResponse}");
            }
            onProgressSuccess?.call(context, state);
          },
          onProgressFailure: (context, state) {
            final message = AppLang.i18n.message_failure_genericError(state.failureResponse.exception.toString() ?? "");
            showBannerFailure(context, "load ($runtimeType)", message, state.failureResponse.exception,
                stackTrace: state.failureResponse.stackTrace);
            onProgressFailure?.call(context, state);
          },
          child: BlocBuilder<BLoC, ReactiveState>(
            builder: (context, state) => FutureBuilder(
                future: bloc.loaded,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return ErrorScaffold(
                      reload: () => bloc.init(),
                      title: title(context),
                      error: snapshot.error,
                    );
                  }

                  if (!snapshot.hasData || snapshot.data == false) {
                    return Container();
                  }

                  return ReactiveForm(
                    formGroup: bloc.group,
                    child: _scaffold(context),
                  );
                }),
          ),
        ),
      ),
    );
  }

  BLoC createBloc(BuildContext context);
}
