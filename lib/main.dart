import 'package:document_scanner/core/service_locator/service_locator.dart';
import 'package:document_scanner/scanner/document_scanner.dart';
import 'package:document_scanner/scanner/presentation/screens/error/error.dart' as error;
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initServiceLocator();

  ErrorWidget.builder = (FlutterErrorDetails details) => error.ErrorScaffold(
        error: details.exceptionAsString(),
        stackTrace: details.stack,
        reload: () => {},
      );

  runApp(DocumentScanner());
}
