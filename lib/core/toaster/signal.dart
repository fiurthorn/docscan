import 'package:document_scanner/core/design/theme_colors.dart';
import 'package:document_scanner/core/widgets/responsive.dart';
import 'package:flutter/material.dart';
import 'package:sprintf/sprintf.dart';

String showSnackBarSignal(BuildContext context, String hint, String message, [List<dynamic> args = const []]) {
  final content = Text(
    message,
    style: TextStyle(
      color: Theme.of(context).colorScheme.onSecondary,
      backgroundColor: nord12AuroraOrange,
    ),
  );

  if (args.isNotEmpty) {
    message = sprintf(message, args);
  }

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
