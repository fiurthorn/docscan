// ignore: avoid_web_libraries_in_flutter
// import 'dart:js' as js;
import 'dart:math';

import 'package:document_scanner/core/design/theme_data.dart';
import 'package:document_scanner/core/lib/platform/platform.dart';
import 'package:document_scanner/core/lib/simple_bloc_observer.dart';
import 'package:document_scanner/core/service_locator/service_locator.dart';
import 'package:document_scanner/core/widgets/goroute/route.dart';
import 'package:document_scanner/l10n/app_lang.dart';
import 'package:document_scanner/l10n/translations/translations.dart';
import 'package:document_scanner/scanner/domain/repositories/key_values.dart';
import 'package:document_scanner/scanner/presentation/screens/error/error.dart' as err;
import 'package:document_scanner/scanner/presentation/screens/notfound/notfound.dart';
import 'package:document_scanner/scanner/presentation/screens/splash/page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

abstract class Application extends StatefulWidget {
  Application({super.key}) {
    Bloc.observer = SimpleBlocObserver();
  }

  static final random = Random();

  static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<ApplicationState>()?.restartApp();
  }
}

abstract class ApplicationState<T extends Application> extends State<T> {
  final String slashRoute = '/';

  Key key = UniqueKey();

  void restartApp() => setState(() => key = UniqueKey());

  @override
  void initState() {
    super.initState();
    loaded();

    sl<KeyValues>().init();
  }

  Widget error(AsyncSnapshot snapshot) {
    return err.ErrorApp(error: snapshot.error, stackTrace: snapshot.stackTrace, reload: restartApp);
  }

  Future<bool> setLanguage() async {
    final systemLocale = await findSystemLocale();
    AppLang.lang = sl<KeyValues>().get(KeyValueNames.locale, systemLocale);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: key,
      child: FutureBuilder(
          future: setLanguage(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return error(snapshot);
            }

            if (!snapshot.hasData) {
              return const SplashPage();
            }

            return app;
          }),
    );
  }

  Widget get app {
    final router = goRouter();

    return Builder(
      builder: (context) {
        ErrorWidget.builder = errorBuilder;

        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          debugShowMaterialGrid: false,
          showSemanticsDebugger: false,
          localizationsDelegates: S.localizationsDelegates,
          supportedLocales: S.supportedLocales,
          locale: Locale.fromSubtags(languageCode: AppLang.lang),
          theme: theme(),
          routeInformationProvider: router.goRouter.routeInformationProvider,
          routeInformationParser: router.goRouter.routeInformationParser,
          routerDelegate: router.goRouter.routerDelegate,
        );
      },
    );
  }

  Set<AuthGoRoute> get routes;

  AuthMap? _authMap;
  AuthMap get authMap => _authMap ??= routes.fold<AuthMap>(AuthMap(), (map, route) => map.add(route));

  Set<String>? _routePaths;
  Set<String> get routePaths => _routePaths ??= routes.map((e) => e.path).toSet();

  String get whatsNew;
  String get initialRoute;

  RouterConfiguration goRouter() {
    final navigatorKey = GlobalKey<NavigatorState>();

    final router = GoRouter(
      navigatorKey: navigatorKey,
      routes: routes.toList(),
      observers: [
        sl<GoRouterObserver>(),
      ],
      errorBuilder: (context, state) {
        if (!routePaths.contains(state.fullPath)) {
          return const NotFoundScreen();
        }
        return err.ErrorScaffold(reload: restartApp);
      },
      initialLocation: initialRoute,
      restorationScopeId: 'docscan',
      redirect: (context, state) {
        if (sl<KeyValues>().hasNewBuildNumber()) {
          return whatsNew;
        }

        return null;
      },
    );

    return RouterConfiguration(router, navigatorKey);
  }

  Widget errorBuilder(FlutterErrorDetails details) => err.ErrorWidget(
        error: details.exceptionAsString(),
        stackTrace: details.stack,
        reload: restartApp,
      );
}
