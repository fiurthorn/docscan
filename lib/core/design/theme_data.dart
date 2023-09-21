import 'package:document_scanner/core/design/theme_colors.dart';
import 'package:flutter/material.dart';

ThemeData theme() {
  return ThemeData.from(
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: nord3PolarNight,
      onPrimary: nord4SnowStorm,
      secondary: nord9Frost,
      onSecondary: nord4SnowStorm,
      error: nord11AuroraRed,
      onError: nord4SnowStorm,
      background: nord4SnowStorm,
      onBackground: nord1PolarNight,
      surface: nord4SnowStorm,
      onSurface: nord1PolarNight,
    ),
    useMaterial3: false,
    textTheme: Typography.blackMountainView,
  ).copyWith(
    appBarTheme: const AppBarTheme(
      elevation: 0,
      foregroundColor: nord4SnowStorm,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      // backgroundColor: nord10Frost,
      // foregroundColor: nord4SnowStorm,
      elevation: 0,
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}
