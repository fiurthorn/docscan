import 'package:flutter/material.dart';
import 'package:document_scanner/core/lib/breakpoints.dart';

class ResponsiveWidget extends StatelessWidget {
  final Widget largeScreen;
  final Widget smallScreen;

  const ResponsiveWidget({
    required this.largeScreen,
    required this.smallScreen,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return isLargeScreen(context) ? largeScreen : smallScreen;
      },
    );
  }
}

Widget responsiveScreenWidthPadding(BuildContext context, Widget child,
    {double horizontal = 1000, double vertical = 0}) {
  final width = MediaQuery.of(context).size.width;

  var pad = width * 0.1;
  if (isSmallScreen(context)) {
    pad = 5;
  }

  if (horizontal > 0 && width > horizontal) {
    pad = (width - horizontal) / 2;
  }

  return Padding(padding: EdgeInsets.symmetric(horizontal: pad, vertical: vertical), child: child);
}
