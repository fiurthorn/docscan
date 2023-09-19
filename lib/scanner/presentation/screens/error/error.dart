import 'package:document_scanner/core/design/theme_colors.dart';
import 'package:document_scanner/core/design/theme_data.dart';
import 'package:document_scanner/core/design/theme_icons.dart';
import 'package:document_scanner/core/lib/logger.dart';
import 'package:flutter/material.dart';

class ErrorApp extends StatelessWidget {
  final Object? error;
  final StackTrace? stackTrace;
  final VoidCallback reload;
  final String? title;

  const ErrorApp({this.error, this.stackTrace, required this.reload, this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      debugShowMaterialGrid: false,
      showSemanticsDebugger: false,
      builder: (context, widget) {
        return ErrorScaffold(
          error: error,
          stackTrace: stackTrace,
          reload: reload,
        );
      },
    );
  }
}

class ErrorScaffold extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffold = GlobalKey();
  final Object? error;
  final StackTrace? stackTrace;
  final VoidCallback reload;
  final String? title;

  ErrorScaffold({
    this.error,
    this.stackTrace,
    required this.reload,
    this.title,
    super.key,
  });

  ThemeData themeData() {
    return theme().copyWith(
      scaffoldBackgroundColor: nord3PolarNight,
      appBarTheme: const AppBarTheme(elevation: 0),
    );
  }

  @override
  Widget build(BuildContext context) => Theme(
        data: themeData(),
        child: Scaffold(
          appBar: AppBar(title: Text(title ?? ""), actions: [
            IconButton(
              icon: Icon(ThemeIcons.clearCache),
              onPressed: () => reload(),
            )
          ]),
          body: ErrorWidget(
            error: error,
            stackTrace: stackTrace,
            reload: reload,
          ),
        ),
      );
}

class ErrorWidget extends StatelessWidget {
  final Object? error;
  final StackTrace? stackTrace;
  final VoidCallback reload;

  const ErrorWidget({this.error, this.stackTrace, required this.reload, super.key});

  @override
  Widget build(BuildContext context) {
    Log.high("ErrorWidget", error: error, stackTrace: stackTrace);
    return Center(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Icon(ThemeIcons.dissatisfied, size: 70),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              alignment: Alignment.center,
              child: Column(
                children: [
                  const Text(
                    'An error has occurred please try again later',
                    style: TextStyle(fontSize: 25),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    '${error ?? ''}',
                    style: const TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: reload,
              child: const Text('RETRY'),
            ),
          ],
        ),
      ),
    );
  }
}
