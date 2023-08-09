import 'package:document_scanner/core/design/theme_colors.dart';
import 'package:document_scanner/core/design/theme_icons.dart';
import 'package:document_scanner/scanner/presentation/screens/base/base_right_menu.dart';
import 'package:flutter/material.dart';

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
    // ListTile(
    //   title: Text(AppLang.i18n.preAttach_page_title),
    //   leading: Icon(ThemeIcons.attach),
    //   onTap: () {
    //     scaffold.currentState!.closeEndDrawer();
    //     context.go(AttachScreen.path);
    //   },
    // ),
  ], accountItems: []);
}
