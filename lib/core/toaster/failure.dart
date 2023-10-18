import 'package:document_scanner/core/design/theme_colors.dart';
import 'package:document_scanner/core/widgets/responsive.dart';
import 'package:flutter/material.dart';

String showSnackBarFailure(BuildContext context, String message) {
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
