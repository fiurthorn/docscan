import 'package:document_scanner/core/design/theme_colors.dart';
import 'package:document_scanner/core/design/theme_icons.dart';
import 'package:document_scanner/core/lib/language_name.dart';
import 'package:document_scanner/core/version.g.dart';
import 'package:document_scanner/core/widgets/systempanel/systempanel.dart';
import 'package:document_scanner/l10n/app_lang.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BaseMenu extends StatelessWidget {
  final bool logout, about;

  List<Widget> menuItems(BuildContext context) => const [];
  List<Widget> accountItems(BuildContext context) => const [];

  const BaseMenu({
    this.about = true,
    this.logout = false,
    super.key,
  });

  void push(BuildContext context, String path) {
    Scaffold.of(context).closeEndDrawer();

    if (context.canPop()) {
      context.pushReplacement(path);
    } else {
      context.push(path);
    }
  }

  @override
  Widget build(BuildContext context) => Drawer(
        child: SafeArea(
          child: Column(
            children: [
              const Padding(padding: EdgeInsets.only(top: 10)),
              Expanded(
                child: Column(children: menuItems(context)),
              ),
              ...accountItems(context),
              const Divider(thickness: 1, height: 2),
              ListTile(
                leading: Icon(ThemeIcons.lang, color: nord3PolarNight),
                title: DropdownButton<String>(
                  value: AppLang.lang,
                  underline: Container(),
                  items: sortedLanguageNames
                      .map(
                        (e) => DropdownMenuItem(
                          value: e.code,
                          child: Text(
                            e.name,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (newValue) {
                    AppLang.lang = newValue!;
                    Scaffold.of(context).closeEndDrawer();
                  },
                ),
              ),
              const Divider(thickness: 1, height: 2),
              ListTile(
                leading: Icon(ThemeIcons.info, color: nord3PolarNight),
                title: Text(AppLang.i18n.baseScreen_about_label('docscan')),
                onTap: () {
                  showAboutDialog(
                      context: context,
                      applicationIcon: CircleAvatar(
                          radius: 40,
                          backgroundColor: nord3PolarNight,
                          child: ThemeIcons.logo2(
                            height: 70,
                            color: nord4SnowStorm,
                          )),
                      applicationName: 'docscan',
                      applicationVersion: buildVersion,
                      applicationLegalese: copyright,
                      children: [const SystemPanel()]);

                  Scaffold.of(context).closeEndDrawer();
                },
              ),
              const Divider(thickness: 1, height: 2),
            ],
          ),
        ),
      );
}
