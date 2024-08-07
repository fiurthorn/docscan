import 'package:document_scanner/core/design/theme_icons.dart';
import 'package:document_scanner/core/lib/logger.dart';
import 'package:document_scanner/core/widgets/responsive.dart';
import 'package:flutter/material.dart';

String showBannerFailure(
  BuildContext context,
  String hint, {
  String? message,
  dynamic failure,
  StackTrace? stackTrace,
}) {
  final msg = message ?? failure?.toString() ?? "Unknown error";

  Log.high("snackBar Failure on '$hint' $msg", error: failure, stackTrace: stackTrace ?? StackTrace.current);

  WidgetsBinding.instance.addPostFrameCallback((_) {
    ScaffoldMessenger.of(context).clearMaterialBanners();
    ScaffoldMessenger.of(context).showMaterialBanner(
      MaterialBanner(
        content: ResponsiveWidthPadding(
          Stack(
            children: [
              InkWell(
                onTap: () => ScaffoldMessenger.of(context).hideCurrentMaterialBanner(),
                child: Icon(
                  ThemeIcons.close,
                  size: 20,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: Text(msg, softWrap: true),
              ),
            ],
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.error,
        elevation: 0,
        actions: const [SizedBox()],
      ),
    );
  });

  return msg;
}
