import 'package:document_scanner/core/lib/breakpoints.dart';
import 'package:flutter/material.dart';

class ResponsiveWidthPadding extends StatelessWidget {
  final Widget child;
  final double horizontal;
  final double vertical;

  const ResponsiveWidthPadding(
    this.child, {
    this.horizontal = 1000,
    this.vertical = 0,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
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
}

class ResponsiveLayout extends LayoutBuilder {
  ResponsiveLayout({
    required Widget small,
    required Widget large,
    super.key,
  }) : super(builder: (context, constraints) {
          if (isSmallScreen(context)) {
            return small;
          } else {
            return large;
          }
        });
}
