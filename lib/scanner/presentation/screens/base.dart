import 'package:document_scanner/core/lib/optional.dart';
import 'package:document_scanner/core/lib/platform/platform.dart';
import 'package:document_scanner/core/widgets/loading_widget/loading_widget.dart';
import 'package:document_scanner/scanner/presentation/screens/error/error.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:go_router/go_router.dart';

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
  Widget? buildFloatingActionButton(BuildContext context) => null;

  ThemeData? themeData(BuildContext context) => null;
  FormTheme formTheme(BuildContext context) {
    final theme = FormTheme.of(context).copyWith();
    return theme;
  }

//   Widget _onNewVersion(BuildContext context) {
//     return Center(
//       child: Column(
//         children: [
//           const Text("What's new on version $buildVersion"),
//           const Text("this dialog"),
//           const Text("scanned image rotation"),
//           const Text("update dropdown list values on change"),
//           TextButton(
//             onPressed: () => update(),
//             child: const Text("Okay"),
//           ),
//         ],
//       ),
//     );
//   }

  Widget _scaffold(BuildContext context) => _theme(
      context,
      WillPopScope(
        onWillPop: () => _onWillPop(context),
        child: Scaffold(
          extendBodyBehindAppBar: extendBodyBehindAppBar,
          appBar: buildAppBar(context),
          //! TODO OnceWidget showOnEveryNewVersion
          body: /*OnceWidget.showOnEveryNewVersion(
            builder: () => _onNewVersion(context),
            fallback: () =>*/
              buildScreen(context),
          //),
          key: scaffold,
          drawer: buildDrawer(context),
          endDrawer: buildEndDrawer(context),
          bottomNavigationBar: buildBottomNavigationBar(context),
          floatingActionButtonLocation: floatingActionButtonLocation,
          floatingActionButton: buildFloatingActionButton(context),
        ),
      ));

  _theme(BuildContext context, Widget screen) {
    screen = FormThemeProvider(
      theme: formTheme(context),
      child: screen,
    );

    final theme = themeData(context);

    if (theme == null) {
      return screen;
    }

    return Theme(
      data: theme,
      child: screen,
    );
  }

  Future<bool> _onWillPop(BuildContext context) async {
    if (!isMobile || isWeb) return true;

    bool? exitResult = await showDialog(
      context: context,
      builder: (context) => _buildExitDialog(context),
    );
    return exitResult ?? false;
  }

  AlertDialog _buildExitDialog(BuildContext context) {
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
}

abstract class FormBlocBaseScreenState<T extends StatefulWidget, F extends FormBloc<String, ErrorValue>>
    extends BaseScreenState<T> {
  FormBlocBaseScreenState({
    bool extendBodyBehindAppBar = false,
    FloatingActionButtonLocation floatingActionButtonLocation = FloatingActionButtonLocation.centerDocked,
  }) : super(
          extendBodyBehindAppBar: extendBodyBehindAppBar,
          floatingActionButtonLocation: floatingActionButtonLocation,
        );

  @override
  Widget build(BuildContext context) {
    return _theme(
      context,
      BlocProvider<F>(
        create: (context) => createBloc(context),
        child: FormBlocListener<F, String, ErrorValue>(
          onSuccess: onSuccess,
          onDeleteFailed: onDeleteFailed,
          onDeleting: onDeleting,
          onDeleteSuccessful: onDeleteSuccessful,
          onFailure: onFailure,
          onLoadFailed: onLoadFailed,
          onLoaded: onLoaded,
          onLoading: onLoading,
          onSubmissionCancelled: onSubmissionCancelled,
          onSubmissionFailed: onSubmissionFailed,
          onSubmitting: onSubmitting,
          child: BlocBuilder<F, FormBlocState<String, ErrorValue>>(
            builder: (context, state) {
              if (state is FormBlocLoading) {
                return const LoadingWidget();
              } else if (state is FormBlocLoadFailed) {
                final formBloc = BlocProvider.of<F>(context);
                return ErrorScaffold(
                  reload: () => formBloc.reload(),
                  title: title(context),
                  error: ((state as FormBlocLoadFailed).failureResponse as ErrorValue).exception,
                  stackTrace: ((state as FormBlocLoadFailed).failureResponse as ErrorValue).stackTrace,
                );
                //   } else if (state is FormBlocFailure) {
                //     final formBloc = BlocProvider.of<F>(context);
                //     return ErrorScaffold(
                //       reload: () => formBloc.reload(),
                //       title: title(context),
                //       error: ((state as FormBlocFailure).failureResponse as ErrorValue).exception,
                //       stackTrace: ((state as FormBlocFailure).failureResponse as ErrorValue).stackTrace,
                //     );
              } else {
                return _scaffold(context);
              }
            },
          ),
        ),
      ),
    );
  }

  F createBloc(BuildContext context);

  void onSuccess(BuildContext context, FormBlocSuccess<String, ErrorValue> state) {}
  void onDeleteFailed(BuildContext context, FormBlocDeleteFailed<String, ErrorValue> state) {}
  void onDeleting(BuildContext context, FormBlocDeleting<String, ErrorValue> state) {}
  void onDeleteSuccessful(BuildContext context, FormBlocDeleteSuccessful<String, ErrorValue> state) {}
  void onFailure(BuildContext context, FormBlocFailure<String, ErrorValue> state) {}
  void onLoadFailed(BuildContext context, FormBlocLoadFailed<String, ErrorValue> state) {}
  void onLoaded(BuildContext context, FormBlocLoaded<String, ErrorValue> state) {}
  void onLoading(BuildContext context, FormBlocLoading<String, ErrorValue> state) {}
  void onSubmissionCancelled(BuildContext context, FormBlocSubmissionCancelled<String, ErrorValue> state) {}
  void onSubmissionFailed(BuildContext context, FormBlocSubmissionFailed<String, ErrorValue> state) {}
  void onSubmitting(BuildContext context, FormBlocSubmitting<String, ErrorValue> state) {}
}

abstract class BlocBaseScreenState<T extends StatefulWidget, State, BLoC extends BlocBase<State>>
    extends BaseScreenState<T> {
  BlocBaseScreenState({
    bool extendBodyBehindAppBar = false,
    FloatingActionButtonLocation floatingActionButtonLocation = FloatingActionButtonLocation.centerDocked,
  }) : super(
          extendBodyBehindAppBar: extendBodyBehindAppBar,
          floatingActionButtonLocation: floatingActionButtonLocation,
        );

  void listener(BuildContext context, State state) {}

  @override
  Widget build(BuildContext context) {
    return _theme(
      context,
      BlocProvider<BLoC>(
        create: (context) => createBloc(context),
        child: BlocListener<BLoC, State>(
          listener: listener,
          child: BlocBuilder<BLoC, State>(
            builder: (context, state) => _scaffold(context),
          ),
        ),
      ),
    );
  }

  BLoC createBloc(BuildContext context);
}
