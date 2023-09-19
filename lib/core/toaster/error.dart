import 'package:document_scanner/core/lib/logger.dart';
import 'package:document_scanner/core/widgets/responsive.dart';
import 'package:flutter/material.dart';

String showSnackBarFailure(
  BuildContext context,
  String hint,
  String? message,
  Object? error, {
  StackTrace? stackTrace,
}) {
  final msg = message ?? error?.toString() ?? "Unknown error";

  Log.high("snackBar Failure on hint:'$hint' ${message ?? ''}", error: error, stackTrace: stackTrace);

  WidgetsBinding.instance.addPostFrameCallback((_) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: ResponsiveWidthPadding(Text(msg)),
      backgroundColor: Theme.of(context).colorScheme.error,
      duration: const Duration(seconds: 5),
    ));
  });

  return msg;
}
