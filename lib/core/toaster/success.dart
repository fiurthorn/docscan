import 'package:document_scanner/core/design/theme_colors.dart';
import 'package:document_scanner/core/widgets/responsive.dart';
import 'package:flutter/material.dart';
import 'package:sprintf/sprintf.dart';

String showSnackBarSuccess(BuildContext context, String hint, String message, [List<dynamic> args = const []]) {
  final content = Text(message, style: const TextStyle(color: themeGrey4Color, backgroundColor: themeSecondaryColor));
  if (args.isNotEmpty) {
    message = sprintf(message, args);
  }

  WidgetsBinding.instance.addPostFrameCallback((_) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: ResponsiveWidthPadding(content),
      backgroundColor: themeSecondaryColor,
      duration: const Duration(seconds: 5),
    ));
  });
  return message;
}
