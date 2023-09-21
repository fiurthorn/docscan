import 'package:document_scanner/core/design/theme_colors.dart';
import 'package:document_scanner/core/design/theme_icons.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: nord3PolarNight,
      child: Column(
        children: [
          const SizedBox(height: 140.0),
          ThemeIcons.logo2(color: nord4SnowStorm),
        ],
      ),
    );
  }
}
