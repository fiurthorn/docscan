import 'package:document_scanner/core/design/theme_colors.dart';
import 'package:document_scanner/core/lib/logger.dart';
import 'package:document_scanner/core/widgets/responsive.dart';
import 'package:flutter/material.dart';

String showSnackBarFailure(
  BuildContext context,
  String message, {
  String? hint,
  dynamic failure,
  StackTrace? stackTrace,
}) {
  Log.high("snackBar Failure on '$hint' $message", error: failure, stackTrace: stackTrace ?? StackTrace.current);

  final content = Text(
    message,
    style: TextStyle(
      color: Theme.of(context).colorScheme.onSecondary,
      backgroundColor: nord12AuroraOrange,
    ),
  );

  WidgetsBinding.instance.addPostFrameCallback((_) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: ResponsiveWidthPadding(content),
      backgroundColor: nord12AuroraOrange,
      duration: const Duration(seconds: 5),
    ));
  });
  return message;
}
