import 'package:document_scanner/core/design/theme_icons.dart';
import 'package:document_scanner/core/widgets/custom_text/custom_text.dart';
import 'package:document_scanner/core/widgets/responsive.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppbarTitle extends StatelessWidget {
  final String title;

  const AppbarTitle(
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

class AppbarLeading extends StatelessWidget {
  const AppbarLeading({
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

class CustomButtonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget button;

  const CustomButtonAppBar({
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
            AppbarTitle(title),
            const Expanded(child: SizedBox()),
            button,
          ],
        )),
      );

  @override
  Size get preferredSize => const Size.fromHeight(56.0);
}

class MinimalAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool home;

  const MinimalAppBar({
    required this.title,
    this.home = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) => AppBar(
        actions: const [SizedBox()],
        leading: home ? const AppbarLeading() : null,
        automaticallyImplyLeading: false,
        title: ResponsiveWidthPadding(AppbarTitle(title)),
      );

  @override
  Size get preferredSize => const Size.fromHeight(56.0);
}

class FullAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget> navigation;
  final List<Widget> children;
  final bool home;

  const FullAppBar({
    required this.title,
    this.navigation = const [],
    this.children = const [],
    this.home = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) => AppBar(
        actions: const [SizedBox()],
        leading: home ? const AppbarLeading() : null,
        automaticallyImplyLeading: false,
        title: ResponsiveWidthPadding(
          Row(
            children: [
              AppbarTitle(title),
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
