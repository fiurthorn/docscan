import 'package:document_scanner/core/design/theme_colors.dart';
import 'package:document_scanner/core/design/theme_icons.dart';
import 'package:document_scanner/l10n/app_lang.dart';
import 'package:document_scanner/scanner/presentation/screens/areas/page.dart';
import 'package:document_scanner/scanner/presentation/screens/base/base_right_menu.dart';
import 'package:document_scanner/scanner/presentation/screens/documentsTypes/page.dart';
import 'package:document_scanner/scanner/presentation/screens/scanner/page.dart';
import 'package:document_scanner/scanner/presentation/screens/sender/page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

Drawer rightMenu(
  BuildContext context,
  GlobalKey<ScaffoldState> scaffold,
  Function refresh,
) {
  return baseRightMenu(context, scaffold, refresh, menuItems: [
    ListTile(
      title: const Text("docscan"),
      leading: CircleAvatar(
        radius: 25,
        backgroundColor: themeGrey4Color,
        child: ThemeIcons.logo2(color: nord4SnowStorm),
      ),
    ),
    const SizedBox(height: 10),
    const Divider(thickness: 1, height: 2),
    const SizedBox(height: 10),
    ListTile(
      title: Text(AppLang.i18n.scanner_page_title),
      leading: Icon(ThemeIcons.scanner, color: themeGrey4Color),
      onTap: () {
        scaffold.currentState!.closeEndDrawer();
        context.go(ScannerScreen.path);
      },
    ),
    const Divider(thickness: 1, height: 2),
    ListTile(
      title: Text(AppLang.i18n.areas_page_title),
      leading: Icon(ThemeIcons.area, color: themeGrey4Color),
      onTap: () {
        scaffold.currentState!.closeEndDrawer();
        context.go(AreasScreen.path);
      },
    ),
    ListTile(
      title: Text(AppLang.i18n.docTypes_page_title),
      leading: Icon(ThemeIcons.docType, color: themeGrey4Color),
      onTap: () {
        scaffold.currentState!.closeEndDrawer();
        context.go(DocumentTypesScreen.path);
      },
    ),
    ListTile(
      title: Text(AppLang.i18n.senders_page_title),
      leading: Icon(ThemeIcons.envelopeOpenText, color: themeGrey4Color),
      onTap: () {
        scaffold.currentState!.closeEndDrawer();
        context.go(SendersScreen.path);
      },
    ),
  ], accountItems: []);
}
