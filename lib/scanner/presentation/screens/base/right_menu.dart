import 'package:document_scanner/core/design/theme_colors.dart';
import 'package:document_scanner/core/design/theme_icons.dart';
import 'package:document_scanner/core/widgets/custom_text/custom_text.dart';
import 'package:document_scanner/scanner/presentation/screens/base/base_right_menu.dart';
import 'package:flutter/material.dart';

Drawer rightMenu(
  BuildContext context,
  GlobalKey<ScaffoldState> scaffold,
  Function refresh,
) {
  return baseRightMenu(context, scaffold, refresh, menuItems: [
    ListTile(
      title: const CustomText("<no-user>"),
      leading: Icon(
        ThemeIcons.defaultUser,
        color: themeTextColor,
      ),
    ),
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
