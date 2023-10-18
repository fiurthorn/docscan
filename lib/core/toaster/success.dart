import 'package:document_scanner/core/widgets/responsive.dart';
import 'package:flutter/material.dart';

String showSnackBarSuccess(BuildContext context, String message) {
  final content = Text(
    message,
    style: TextStyle(
      color: Theme.of(context).colorScheme.onSecondary,
      backgroundColor: Theme.of(context).colorScheme.secondary,
    ),
  );

  WidgetsBinding.instance.addPostFrameCallback((_) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: ResponsiveWidthPadding(content),
      backgroundColor: Theme.of(context).colorScheme.secondary,
      duration: const Duration(seconds: 5),
    ));
  });
  return message;
}
