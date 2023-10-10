import 'package:document_scanner/core/design/theme_icons.dart';
import 'package:document_scanner/core/widgets/custom_text/custom_text.dart';
import 'package:document_scanner/core/widgets/responsive.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NavbarTitle extends StatelessWidget {
  final String title;

  const NavbarTitle(
    this.title, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Visibility(
        visible: context.canPop(),
        child: IconButton(
          icon: Icon(
            ThemeIcons.back,
            color: Theme.of(context).appBarTheme.foregroundColor,
          ),
          onPressed: context.pop,
        ),
      ),
      CustomText(
        title,
        color: Theme.of(context).appBarTheme.foregroundColor,
        size: 20,
        weight: FontWeight.bold,
      ),
    ]);
  }
}

class Leading extends StatelessWidget {
  const Leading({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => GoRouter.of(context).go("/"),
      icon: Icon(ThemeIcons.home),
    );
  }
}

class CustomButtonTopNavBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget button;

  const CustomButtonTopNavBar({
    required this.title,
    required this.button,
    super.key,
  });

  @override
  Widget build(BuildContext context) => AppBar(
        actions: const [SizedBox()],
        automaticallyImplyLeading: false,
        title: ResponsiveWidthPadding(Row(
          children: [
            NavbarTitle(title),
            const Expanded(child: SizedBox()),
            button,
          ],
        )),
      );

  @override
  Size get preferredSize => const Size.fromHeight(56.0);
}

class LightSubTopNavBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool home;

  const LightSubTopNavBar({
    required this.title,
    this.home = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) => AppBar(
        actions: const [SizedBox()],
        leading: home ? const Leading() : null,
        automaticallyImplyLeading: false,
        title: ResponsiveWidthPadding(NavbarTitle(title)),
      );

  @override
  Size get preferredSize => const Size.fromHeight(56.0);
}

class FullTopNavBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget> navigation;
  final List<Widget> children;
  final bool home;

  const FullTopNavBar({
    required this.title,
    this.navigation = const [],
    this.children = const [],
    this.home = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) => AppBar(
        actions: const [SizedBox()],
        leading: home ? const Leading() : null,
        automaticallyImplyLeading: false,
        title: ResponsiveWidthPadding(
          Row(
            children: [
              NavbarTitle(title),
              ...navigation,
              const Expanded(child: SizedBox()),
              ...children,
              profileIconMenu(context)
            ],
          ),
        ),
      );

  @override
  Size get preferredSize => const Size.fromHeight(56.0);

  Widget profileIconMenu(BuildContext context) => InkWell(
        onTap: () => Scaffold.of(context).openEndDrawer(),
        child: Center(
          child: Icon(
            ThemeIcons.menu,
            color: Theme.of(context).appBarTheme.foregroundColor,
          ),
        ),
      );
}
