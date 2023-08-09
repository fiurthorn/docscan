import 'package:document_scanner/core/design/theme_colors.dart';
import 'package:flutter/material.dart';

ThemeData theme() {
  final td = ThemeData(
    appBarTheme: const AppBarTheme(
      iconTheme: IconThemeData(color: nord6SnowStorm),
      foregroundColor: nord6SnowStorm,
      backgroundColor: themePrimaryColor,
      elevation: 0,
    ),
    textTheme: Typography.blackHelsinki.apply(
      bodyColor: nord3PolarNight,
      displayColor: nord3PolarNight,
    ),
    brightness: Brightness.light,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    inputDecorationTheme: const InputDecorationTheme(
      border: UnderlineInputBorder(),
    ),
    primaryColor: themePrimaryColor,
    secondaryHeaderColor: themeSecondaryColor,
    colorScheme: ColorScheme.fromSwatch(primarySwatch: toMaterialColor(themePrimaryColor)).copyWith(
      error: themeSignalColor,
    ),
  );
  return td;
}
