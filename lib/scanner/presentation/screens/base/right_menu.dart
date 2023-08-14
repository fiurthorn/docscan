import 'package:document_scanner/core/design/theme_colors.dart';
import 'package:document_scanner/core/design/theme_icons.dart';
import 'package:document_scanner/scanner/presentation/screens/areas/page.dart';
import 'package:document_scanner/scanner/presentation/screens/base/base_right_menu.dart';
import 'package:document_scanner/scanner/presentation/screens/documentsTypes/page.dart';
import 'package:document_scanner/scanner/presentation/screens/scanner/page.dart';
import 'package:document_scanner/scanner/presentation/screens/supplier/page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

Drawer rightMenu(
  BuildContext context,
  GlobalKey<ScaffoldState> scaffold,
  Function refresh,
) {
  return baseRightMenu(context, scaffold, refresh, menuItems: [
    ListTile(
      title: const Text("Settings"),
      leading: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          border: Border.all(width: 2, color: themeGrey4Color),
        ),
        child: CircleAvatar(
          radius: 25,
          backgroundColor: nord6SnowStorm,
          child: Icon(
            ThemeIcons.defaultUser,
            color: themeTextColor,
          ),
        ),
      ),
    ),
    const SizedBox(height: 10),
    const Divider(thickness: 1, height: 2),
    const SizedBox(height: 10),
    ListTile(
      title: const Text("Scan"),
      leading: const Icon(Icons.scanner),
      onTap: () {
        scaffold.currentState!.closeEndDrawer();
        context.go(ScannerScreen.path);
      },
    ),
    const Divider(thickness: 1, height: 2),
    ListTile(
      title: const Text("Areas"),
      leading: Icon(ThemeIcons.area),
      onTap: () {
        scaffold.currentState!.closeEndDrawer();
        context.go(AreasScreen.path);
      },
    ),
    ListTile(
      title: const Text("Document types"),
      leading: Icon(ThemeIcons.docType),
      onTap: () {
        scaffold.currentState!.closeEndDrawer();
        context.go(DocumentTypesScreen.path);
      },
    ),
    ListTile(
      title: const Text("Suppliers"),
      leading: Icon(ThemeIcons.supplier),
      onTap: () {
        scaffold.currentState!.closeEndDrawer();
        context.go(SuppliersScreen.path);
      },
    ),
  ], accountItems: []);
}
